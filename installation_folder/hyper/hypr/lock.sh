#!/bin/bash

# Lee la ruta del wallpaper actual configurado en Waypaper
WALLPAPER=$(grep '^wallpaper =' "$HOME/.config/waypaper/config.ini" | cut -d '=' -f2 | xargs)

# Copia el wallpaper a una ruta temporal si existe
if [ -f "$WALLPAPER" ]; then
    cp "$WALLPAPER" /tmp/lockscreen.png
else
    # Imagen de respaldo por si falla la lectura
    cp "$HOME/.config/hypr/wallpaper.png" /tmp/lockscreen.png
fi

# Lanza hyprlock
hyprlock
