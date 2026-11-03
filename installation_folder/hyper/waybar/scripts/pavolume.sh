#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# pavolume.sh — control de volumen (PipeWire/PulseAudio vía pactl)
# para Waybar + notificaciones OSD (notify-send, compatible swaync).
#
# Uso:
#   pavolume.sh --up        sube el volumen
#   pavolume.sh --down      baja el volumen
#   pavolume.sh --togmute   alterna silencio
#   pavolume.sh --listen    emite JSON para Waybar y escucha cambios
#   pavolume.sh             imprime el volumen actual (texto simple)
# ═══════════════════════════════════════════════════════════════

# --- Configuración ---
INC=1          # incremento por paso (%)
MAX_VOL=120    # volumen máximo permitido (%)
CAP_VOL="no"   # "yes" para limitar a 100%
AUTOSYNC="yes" # sincronizar el volumen de los sink-inputs con el sink

# ── Helpers ────────────────────────────────────────────────────
get_active_sink() {
    pactl get-default-sink
}

# Volumen actual (entero). Acepta el sink como argumento para evitar
# re-consultar el sink por defecto en cada llamada.
get_cur_vol() {
    local sink="${1:-$(get_active_sink)}"
    pactl get-sink-volume "$sink" | awk -F '/' '{gsub(/[ %]/,"",$2); print $2; exit}'
}

is_muted() {
    local sink="${1:-$(get_active_sink)}"
    [[ "$(pactl get-sink-mute "$sink")" == *"yes"* ]]
}

# Escapa una cadena para incrustarla en un string JSON.
json_escape() {
    local s="$1"
    s="${s//\\/\\\\}"  # backslash
    s="${s//\"/\\\"}"  # comillas
    printf '%s' "$s"
}

# ── Notificación OSD ───────────────────────────────────────────
show_osd() {
    local vol=$1
    local muted=$2
    local icon msg bar_val=$vol

    if [[ "$muted" == "1" || "$vol" == "0" ]]; then
        icon="audio-volume-muted"
        msg="Muted"
        bar_val=0
    elif [[ "$vol" -lt 33 ]]; then
        icon="audio-volume-low"
        msg="Volumen: ${vol}%"
    elif [[ "$vol" -lt 66 ]]; then
        icon="audio-volume-medium"
        msg="Volumen: ${vol}%"
    else
        icon="audio-volume-high"
        msg="Volumen: ${vol}%"
    fi

    # Hint de progreso (barra) + sincronización para reemplazar la
    # notificación anterior. Compatible con swaync/mako/dunst.
    notify-send -a "Volume" \
        -u low \
        -i "$icon" \
        -h "int:value:$bar_val" \
        -h "string:x-canonical-private-synchronous:volume" \
        -h "string:synchronous:volume" \
        "$msg"
}

# Sincroniza el volumen de los sink-inputs activos con el del sink.
vol_sync() {
    local sink="$1" cur_vol="$2" id
    pactl list sink-inputs short | awk -v s="$sink" '$3 == s {print $1}' | while read -r id; do
        pactl set-sink-input-volume "$id" "${cur_vol}%"
    done
}

# ── Main ───────────────────────────────────────────────────────
case "$1" in
    --up)
        sink=$(get_active_sink)
        cur=$(get_cur_vol "$sink")
        if [[ "$CAP_VOL" == "yes" && "$cur" -ge 100 ]]; then
            pactl set-sink-volume "$sink" 100%
        elif [[ "$((cur + INC))" -gt "$MAX_VOL" ]]; then
            pactl set-sink-volume "$sink" "$MAX_VOL%"
        else
            pactl set-sink-volume "$sink" "+$INC%"
        fi
        new_vol=$(get_cur_vol "$sink")
        [[ "$AUTOSYNC" == "yes" ]] && vol_sync "$sink" "$new_vol"
        show_osd "$new_vol" 0
        ;;

    --down)
        sink=$(get_active_sink)
        pactl set-sink-volume "$sink" "-$INC%"
        new_vol=$(get_cur_vol "$sink")
        [[ "$AUTOSYNC" == "yes" ]] && vol_sync "$sink" "$new_vol"
        show_osd "$new_vol" 0
        ;;

    --togmute)
        sink=$(get_active_sink)
        pactl set-sink-mute "$sink" toggle
        if is_muted "$sink"; then muted=1; else muted=0; fi
        show_osd "$(get_cur_vol "$sink")" "$muted"
        ;;

    --listen)
        # Emite el estado actual en JSON para Waybar.
        print_vol() {
            local sink vol desc port tip
            sink=$(get_active_sink)
            vol=$(get_cur_vol "$sink")

            # Descripción y puerto activo en una sola pasada de pactl.
            {
                read -r desc
                read -r port
            } < <(pactl list sinks | awk -v s="$sink" '
                /^Sink #/        { cur = 0 }
                $1 == "Name:" && $2 == s { cur = 1 }
                cur && /Description:/ { sub(/^[[:space:]]*Description:[[:space:]]*/, ""); d = $0 }
                cur && /Active Port:/ { sub(/^[[:space:]]*Active Port:[[:space:]]*/, ""); p = $0 }
                END { print d; print p }')
            [[ -z "$desc" ]] && desc="$sink"

            desc=$(json_escape "$desc")
            port=$(json_escape "$port")

            if is_muted "$sink"; then
                tip="Dispositivo: ${desc}\\nPuerto: ${port}\\nVolumen: ${vol}% (silenciado)"
                echo "{\"text\": \"󰝟 \", \"class\": \"muted\", \"percentage\": $vol, \"tooltip\": \"$tip\"}"
            else
                tip="Dispositivo: ${desc}\\nPuerto: ${port}\\nVolumen: ${vol}%"
                echo "{\"text\": \"󰕾 $vol%\", \"class\": \"active\", \"percentage\": $vol, \"tooltip\": \"$tip\"}"
            fi
        }

        print_vol

        # Reemitir en cada evento de sink. stdbuf evita el buffering.
        pactl subscribe | stdbuf -oL grep --line-buffered "sink" | while read -r _; do
            print_vol || break
        done
        ;;

    *)
        echo " $(get_cur_vol)%"
        ;;
esac
