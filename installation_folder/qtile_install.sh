function install_qtile {
    PATH_DIR=$1
    USER_HOME=$2
    yay -S --noconfirm python-psutil qtile network-manager-applet
    cp -R "$PATH_DIR/installation_folder/qtile/" "$USER_HOME/.config/"
}
