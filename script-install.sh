sudo pacman -S udiskie neovim dhcpcd base-devel linux-lts arandr screengrab nitrogen linux-firmware networkmanager qtile sddm pyton-psutil light

mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
EndSection
EOF

