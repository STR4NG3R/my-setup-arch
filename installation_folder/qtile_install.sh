function install_qtile {
    yay -S --noconfirm python-psutil qtile network-manager-applet
    cp -R "$PATH_DIR/installation_folder/qtile/" "$USER_HOME/.config/"
}
