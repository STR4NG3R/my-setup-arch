function install_hyper {
    PATH_DIR=$1
    USER_HOME=$2
    paru -S wofi hyprland waybar
    cp -R "$PATH_DIR/installation_folder/i3/*" "$USER_HOME/.config/"
}
