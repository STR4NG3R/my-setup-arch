function install_i3 {
    PATH_DIR=$1
    USER_HOME=$2
    trizen -S --noconfirm i3wm i3status-rust i3-lock i3-gaps-rounded-git
    cp -R "$PATH_DIR/installation_folder/i3/" "$USER_HOME/.config/"
}


