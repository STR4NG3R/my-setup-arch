function install_hyper {
    PATH_DIR=$1
    USER_HOME=$2
    paru -S wofi hyprland waybar waypaper swww cliphist wl-paste hyprlock hypridle
    cp -R "$PATH_DIR/installation_folder/hyper/*" "$USER_HOME/.config/"
}
