#!/bin/bash
# ───────────────────────────────────────────────────────────────
# move_screen.sh — selector de perfiles de monitores (SUPER + M)
#
# IMPORTANTE: este Hyprland usa el parser Lua (no legacy), por lo que
# `hyprctl keyword monitor ...` NO funciona (error: "keyword can't work
# with non-legacy parsers. Use eval."). Aquí usamos `hyprctl eval` con
# la API Lua `hl.monitor{...}`:
#   • Configurar/habilitar: hl.monitor({output=.., mode=.., position=.., scale=..})
#   • Deshabilitar:         hl.monitor({output=.., disabled=true})
#   • Mirror:               ... mirror="<output_origen>"
# ───────────────────────────────────────────────────────────────

# Helper: ejecuta una expresión Lua en Hyprland.
hypr_eval() {
    hyprctl eval "$1" >/dev/null 2>&1
}

# Helper: configura/habilita un monitor.
#   $1=output  $2=mode  $3=position  $4=scale  [$5=mirror_source]
mon_enable() {
    local out="$1" mode="$2" pos="$3" scale="$4" mirror="$5"
    if [ -n "$mirror" ]; then
        hypr_eval "hl.monitor({output=\"$out\", mode=\"$mode\", position=\"$pos\", scale=$scale, mirror=\"$mirror\"})"
    else
        hypr_eval "hl.monitor({output=\"$out\", mode=\"$mode\", position=\"$pos\", scale=$scale})"
    fi
}

# Helper: deshabilita un monitor.
mon_disable() {
    hypr_eval "hl.monitor({output=\"$1\", disabled=true})"
}

# Define tus perfiles aquí
options="Solo Laptop\nDual Monitor (Casa)\nMonitor Externo (Oficina)\nPresentación (Mirror)"

# Mostrar el menú con Wofi
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Seleccionar perfil de pantalla:" --width 400 --height 250)

case "$chosen" in
    "Solo Laptop")
        mon_enable  "eDP-1" "1920x1080@60" "0x0" "1"
        mon_disable "HDMI-A-1"
        mon_disable "DVI-I-1"
        ;;
    "Dual Monitor (Casa)")
        mon_disable "eDP-1"
        mon_enable  "DVI-I-1"  "1920x1080@60" "0x0"    "1"
        mon_enable  "HDMI-A-1" "1920x1080@60" "1920x0" "1"
        ;;
    "Monitor Externo (Oficina)")
        mon_disable "eDP-1"
        mon_enable  "DP-1" "2560x1440@144" "0x0" "1"
        ;;
    "Presentación (Mirror)")
        # Duplica la pantalla del laptop en el HDMI.
        mon_enable "eDP-1"    "1920x1080@60" "0x0" "1"
        mon_enable "HDMI-A-1" "1920x1080@60" "0x0" "1" "eDP-1"
        ;;
    *)
        # Sin selección (ESC) -> no hacer nada.
        exit 0
        ;;
esac

# Reaplicar las reglas de workspaces por monitor tras cambiar el layout.
hyprctl eval 'require("monitors").apply_workspace_rules()' >/dev/null 2>&1
