function install_qtile {
    PATH_DIR=$1
    USER_HOME=$2
    trizen -S --noedit --noconfirm python-psutil qtile-git network-manager-applet
    cp -Rf "$PATH_DIR/installation_folder/qtile/*" "$USER_HOME/.config/"
}
