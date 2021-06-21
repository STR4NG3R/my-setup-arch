#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#starting utility applications at boot time
run numlockx on &
# xfce4-power-manager &
# nm-applet &
# blueberry-tray &
setxkbmap -layout latam &
redshift &
picom &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
exec --no-startup-id /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
nitrogen --restore &
xfce4-power-manager-settings &
nm-applet

if [ "$1" == "qtile" ]; then
    run nm-applet & xfce4-power-manager-settings
elif [ "$1" == "i3" ]; then 
  run nm-applet
fi

