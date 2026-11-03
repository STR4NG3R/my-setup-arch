#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# brightness-osd.sh
# Ajusta el brillo con `light` y muestra una notificación con barra
# de progreso. Compatible con swaync/mako/dunst (vía notify-send).
#
# Uso:
#   brightness-osd.sh up      # +5%
#   brightness-osd.sh down    # -5%
#   brightness-osd.sh set 50  # fija 50%
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

STEP="${BRIGHT_STEP:-5}"

case "${1:-}" in
    up)   light -A "$STEP" ;;
    down) light -U "$STEP" ;;
    set)  light -S "${2:-50}" ;;
    *)    echo "uso: $0 {up|down|set <n>}" >&2; exit 1 ;;
esac

# Brillo actual redondeado a entero
BRIGHT="$(light -G)"
BRIGHT="${BRIGHT%.*}"

# Icono según nivel
if   [ "$BRIGHT" -ge 66 ]; then ICON="display-brightness-high-symbolic"
elif [ "$BRIGHT" -ge 33 ]; then ICON="display-brightness-medium-symbolic"
else                            ICON="display-brightness-low-symbolic"
fi

notify-send -a "Brightness" \
    -u low \
    -i "$ICON" \
    -h "int:value:$BRIGHT" \
    -h "string:x-canonical-private-synchronous:brightness" \
    -h "string:synchronous:brightness" \
    "Brillo: ${BRIGHT}%"
