function install_qtile {
    PATH_DIR=$1
    USER_HOME=$2
    paru -S python-psutil qtile-git network-manager-applet rofi nitrogen arandr
    cp -Rf "$PATH_DIR/installation_folder/qtile/*" "$USER_HOME/.config/"
}
