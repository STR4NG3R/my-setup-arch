#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# cpu-mode-class.sh — módulo Waybar para el modo/estado de la CPU
# Optimizado para Intel i5-8250U (Kaby Lake R, 4C/8T, intel_pstate)
# en un Acer Aspire A315-53.
#
# Muestra:  <icono-modo> <freq media GHz>  <temp°C>
# Click    -> cicla modo (ahorro -> normal -> extreme) vía helper sudo.
#
# El cambio privilegiado lo hace /usr/local/bin/cpu-mode-set, autorizado
# con NOPASSWD en /etc/sudoers.d/cpu-mode.
# ──────────────────────────────────────────────────────────────
set -euo pipefail

CPU_PATH="/sys/devices/system/cpu"
GOV_FILE="$CPU_PATH/cpu0/cpufreq/scaling_governor"
TURBO_FILE="$CPU_PATH/intel_pstate/no_turbo"
EPP_FILE="$CPU_PATH/cpu0/cpufreq/energy_performance_preference"
STATE_FILE="/run/cpu-mode.state"

# ── Toggle (click en Waybar): cicla al siguiente modo ──────────
if [ "${1:-}" = "toggle" ] || [ "${1:-}" = "next" ]; then
    sudo -n /usr/local/bin/cpu-mode-set next
    exit 0
fi

read_or() { cat "$1" 2>/dev/null || echo "$2"; }

GOV="$(read_or "$GOV_FILE" powersave)"
NO_TURBO="$(read_or "$TURBO_FILE" 1)"
EPP="$(read_or "$EPP_FILE" "-")"
MODE="$(read_or "$STATE_FILE" "")"

# ── Frecuencia MEDIA de todos los núcleos (más representativa que cpu0) ──
total=0
count=0
for f in "$CPU_PATH"/cpu[0-9]*/cpufreq/scaling_cur_freq; do
    [ -r "$f" ] || continue
    v="$(cat "$f" 2>/dev/null || echo 0)"
    total=$((total + v))
    count=$((count + 1))
done
[ "$count" -gt 0 ] || count=1
AVG_KHZ=$((total / count))
FREQ_GHZ="$(awk "BEGIN { printf \"%.2f\", $AVG_KHZ/1000000 }")"

# ── Temperatura del paquete ────────────────────────────────────
# Fuente preferida: coretemp "Package id 0" vía hwmon (lo más canónico
# para CPU Intel). Fallbacks: x86_pkg_temp y, por último, cualquier zona.
TEMP_C=""
for h in /sys/class/hwmon/hwmon*; do
    [ -r "$h/name" ] || continue
    [ "$(cat "$h/name" 2>/dev/null)" = "coretemp" ] || continue
    for lbl in "$h"/temp*_label; do
        [ -r "$lbl" ] || continue
        if [ "$(cat "$lbl" 2>/dev/null)" = "Package id 0" ]; then
            idx="$(basename "$lbl" | sed 's/_label//')"
            t="$(cat "$h/${idx}_input" 2>/dev/null || echo "")"
            [ -n "$t" ] && TEMP_C=$((t / 1000))
            break
        fi
    done
    [ -n "$TEMP_C" ] && break
done
# Fallback 1: zona térmica x86_pkg_temp
if [ -z "$TEMP_C" ]; then
    for z in /sys/class/thermal/thermal_zone*; do
        [ -r "$z/type" ] || continue
        if [ "$(cat "$z/type" 2>/dev/null)" = "x86_pkg_temp" ]; then
            t="$(cat "$z/temp" 2>/dev/null || echo "")"
            [ -n "$t" ] && TEMP_C=$((t / 1000))
            break
        fi
    done
fi
# Fallback 2: primera zona disponible
if [ -z "$TEMP_C" ]; then
    for z in /sys/class/thermal/thermal_zone*; do
        t="$(cat "$z/temp" 2>/dev/null || echo "")"
        [ -n "$t" ] && { TEMP_C=$((t / 1000)); break; }
    done
fi

# ── Modo / clase / icono ───────────────────────────────────────
# Preferimos el estado persistido (3 modos). Si no existe aún (primer
# arranque), lo inferimos del governor + turbo.
if [ -z "$MODE" ]; then
    if [ "$GOV" = "performance" ]; then
        MODE="extreme"
    elif [ "$NO_TURBO" = "1" ]; then
        MODE="ahorro"
    else
        MODE="normal"
    fi
fi

case "$MODE" in
    ahorro)  CLASS="ahorro";  ICON="🔋" ;;
    normal)  CLASS="normal";  ICON="⚡" ;;
    extreme) CLASS="extreme"; ICON="🔥" ;;
    *)       CLASS="normal";  ICON="⚡" ;;
esac

# ── Texto y clase de temperatura (para colorear en CSS si quieres) ──
TEMP_TXT=""
TEMP_CLASS=""
if [ -n "$TEMP_C" ]; then
    TEMP_TXT="  ${TEMP_C}°C"
    if   [ "$TEMP_C" -ge 85 ]; then TEMP_CLASS="hot"
    elif [ "$TEMP_C" -ge 70 ]; then TEMP_CLASS="warm"
    else                            TEMP_CLASS="cool"
    fi
fi

TEXT="${ICON} ${FREQ_GHZ} GHz${TEMP_TXT}"
TOOLTIP="Modo: ${MODE}\nGobernador: ${GOV}\nTurbo: $([ "$NO_TURBO" = 0 ] && echo activado || echo desactivado)\nEPP: ${EPP}\nFreq media: ${FREQ_GHZ} GHz${TEMP_C:+\nTemp paquete: ${TEMP_C}°C}\n(clic: cambia de modo)"

# ── Salida JSON para Waybar ────────────────────────────────────
printf '{"text":"%s","class":["%s"%s],"tooltip":"%s"}\n' \
    "$TEXT" "$CLASS" "${TEMP_CLASS:+,\"$TEMP_CLASS\"}" "$TOOLTIP"
