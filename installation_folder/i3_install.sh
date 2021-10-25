function install_i3 {
    PATH_DIR=$1
    USER_HOME=$2
    yay -S  i3-gaps  pulseaudio-control
    cp -R "$PATH_DIR/installation_folder/i3/*" "$USER_HOME/.config/"
}


