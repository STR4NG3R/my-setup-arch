function install_i3 {
    PATH_DIR=$1
    USER_HOME=$2
    paru -S  i3-gaps   arandr nitrogen rofi polybar lightdm lightdm-gtk-greeter flameshot \
    network-manager-applet 
    cp -R "$PATH_DIR/installation_folder/i3/*" "$USER_HOME/.config/"
}


