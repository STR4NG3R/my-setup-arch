function install_hyper {
    PATH_DIR=$1
    USER_HOME=$2
    USER=$3

    # --- Paquetes del entorno Hyprland ---
    #   Compositor + utilidades de sesión
    #     hyprland hyprlock hypridle   -> compositor, lockscreen, idle daemon
    #     waybar                       -> barra de estado
    #     waypaper swww                -> wallpaper
    #     swaync                       -> daemon de notificaciones (reemplaza dunst)
    #     wofi fuzzel                  -> lanzadores / menús
    #     cliphist wl-clipboard        -> historial y portapapeles de Wayland
    #     grim slurp                   -> capturas de pantalla (y selección de área)
    #   Multimedia / hardware
    #     playerctl                    -> control de reproducción (play/pause/next/prev)
    #     pamixer                      -> control/mute de volumen (scripts)
    #     pavucontrol                  -> mezclador GUI (on-click del módulo de audio)
    #     brightnessctl light          -> control de brillo (brightness-osd.sh usa light)
    #     btop                         -> monitor de sistema (on-click del módulo memory)
    #   OCR (ocr-clipboard.sh)
    #     tesseract + datos spa/eng
    #   Bandeja / red / discos
    #     network-manager-applet udiskie blueman
    #     polkit-gnome                 -> agente de autenticación
    paru -S --noconfirm --needed \
        hyprland hyprlock hypridle \
        waybar waypaper swww swaync \
        wofi fuzzel \
        cliphist wl-clipboard \
        grim slurp \
        playerctl pamixer pavucontrol \
        brightnessctl light \
        btop jq \
        tesseract tesseract-data-spa tesseract-data-eng \
        network-manager-applet udiskie blueman \
        polkit-gnome

    # Copiar las configs del entorno Hyprland al ~/.config del usuario.
    # Nota: el glob NO debe ir entre comillas o no se expande.
    sudo -u "$USER" cp -R "$PATH_DIR"/installation_folder/hyper/* "$USER_HOME/.config/"
}
