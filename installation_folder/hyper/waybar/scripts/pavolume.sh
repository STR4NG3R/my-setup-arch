#!/usr/bin/env bash

# --- Configuración ---
INC=1
MAX_VOL=120
CAP_VOL="no"
AUTOSYNC="yes"
DUNST_ID=25932 # ID único para que la notificación se reemplace a sí misma

get_active_sink() {
    pactl get-default-sink
}

get_cur_vol() {
    pactl get-sink-volume "$(get_active_sink)" | awk -F '/' '{print $2}' | tr -d ' %' | head -n1
}

# --- Función de Notificación con Dunstify ---
show_osd() {
    local vol=$1
    local muted=$2
    local icon="audio-volume-high"
    local bar_val=$vol

    if [[ "$muted" == "1" || "$vol" == "0" ]]; then
        icon="audio-volume-muted"
        msg="Muted"
        bar_val=0
    else
        [[ "$vol" -lt 33 ]] && icon="audio-volume-low"
        [[ "$vol" -lt 66 && "$vol" -ge 33 ]] && icon="audio-volume-medium"
        msg="Volumen: ${vol}%"
    fi

    # notify-send con hint de progreso (barra) y sincronización para
    # reemplazar la notificación anterior. Compatible con swaync/mako/dunst.
    notify-send -a "Volume" \
         -u low \
         -i "$icon" \
         -h "int:value:$bar_val" \
         -h "string:x-canonical-private-synchronous:volume" \
         -h "string:synchronous:volume" \
         "$msg"
}

vol_sync() {
    local active_sink=$(get_active_sink)
    local cur_vol=$(get_cur_vol)
    pactl list sink-inputs short | awk -v sink="$active_sink" '$3 == sink {print $1}' | while read -r id; do
        pactl set-sink-input-volume "$id" "${cur_vol}%"
    done
}

case "$1" in
    --up)
        ACTIVE=$(get_active_sink)
        CUR=$(get_cur_vol)
        if [[ "$CAP_VOL" == "yes" && "$CUR" -ge 100 ]]; then
            pactl set-sink-volume "$ACTIVE" 100%
        elif [[ "$((CUR + INC))" -gt "$MAX_VOL" ]]; then
            pactl set-sink-volume "$ACTIVE" "$MAX_VOL%"
        else
            pactl set-sink-volume "$ACTIVE" "+$INC%"
        fi
        [[ "$AUTOSYNC" == "yes" ]] && vol_sync
        show_osd "$(get_cur_vol)" 0
        ;;

    --down)
        pactl set-sink-volume "$(get_active_sink)" "-$INC%"
        [[ "$AUTOSYNC" == "yes" ]] && vol_sync
        show_osd "$(get_cur_vol)" 0
        ;;

    --togmute)
        ACTIVE=$(get_active_sink)
        pactl set-sink-mute "$ACTIVE" toggle
        MUTED=$(pactl get-sink-mute "$ACTIVE" | grep -q "yes" && echo 1 || echo 0)
        show_osd "$(get_cur_vol)" "$MUTED"
        ;;
    --listen)
        # 1. Función interna para imprimir el estado actual en formato JSON (mejor para Waybar)
        print_vol() {
            local sink=$(get_active_sink)
            local vol=$(get_cur_vol)
            local mute_status=$(pactl get-sink-mute "$sink")

            # Nombre legible del dispositivo y puerto activo
            local desc=$(pactl list sinks | awk -v s="$sink" '
                /^Sink #/ {cur=0}
                $1=="Name:" && $2==s {cur=1}
                cur && /Description:/ {sub(/^[[:space:]]*Description:[[:space:]]*/,""); print; exit}')
            local port=$(pactl list sinks | awk -v s="$sink" '
                /^Sink #/ {cur=0}
                $1=="Name:" && $2==s {cur=1}
                cur && /Active Port:/ {sub(/^[[:space:]]*Active Port:[[:space:]]*/,""); print; exit}')
            [[ -z "$desc" ]] && desc="$sink"

            if [[ "$mute_status" == *"yes"* ]]; then
                local tip="Dispositivo: ${desc}\\nPuerto: ${port}\\nVolumen: ${vol}% (silenciado)"
                # Salida JSON para que Waybar pueda aplicar estilos CSS (.muted)
                echo "{\"text\": \"󰝟 \", \"class\": \"muted\", \"percentage\": $vol, \"tooltip\": \"$tip\"}"
            else
                local tip="Dispositivo: ${desc}\\nPuerto: ${port}\\nVolumen: ${vol}%"
                echo "{\"text\": \"󰕾 $vol%\", \"class\": \"active\", \"percentage\": $vol, \"tooltip\": \"$tip\"}"
            fi
        }

        # 2. Imprimir estado inicial
        print_vol

        # 3. Suscribirse a eventos con manejo de errores
        # Usamos stdbuf para evitar que los datos se queden trabados en el buffer
        pactl subscribe | stdbuf -oL grep --line-buffered "sink" | while read -r _; do
            if ! print_vol; then
                break # Si hay un Broken Pipe, salimos del ciclo limpiamente
            fi
        done
        ;;
    *)
        VOL=$(get_cur_vol)
        pactl get-sink-mute "$(get_active_sink)" | grep -q "yes" && echo " $VOL%" || echo " $VOL%"
        ;;
esac
