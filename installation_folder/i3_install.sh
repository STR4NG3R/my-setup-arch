function install_i3 {
    PATH_DIR=$1
    USER_HOME=$2
    trizen -S --noedit --noconfirm i3wm i3-lock i3-gaps-rounded-git pulseaudio-control
    cp -R "$PATH_DIR/installation_folder/i3/*" "$USER_HOME/.config/"
}


