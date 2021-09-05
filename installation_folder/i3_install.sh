function install_i3 {
    PATH_DIR=$1
    USER_HOME=$2
    trizen -S --noedit --noconfirm i3-wm i3-lock pulseaudio-control
    cp -R "$PATH_DIR/installation_folder/i3/*" "$USER_HOME/.config/"
}


