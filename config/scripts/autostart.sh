#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#starting utility applications at boot time
run numlockx on &
xfsettingsd --sync &
mpd &
exec /usr/lib/kdeconnectd &
nm-applet &
blueberry-tray &
picom &
udiskie &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
exec --no-startup-id /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
nitrogen --restore &
/usr/lib/geoclue-2.0/demos/agent &
redshift &
pgrep redshift | xargs -n1 kill -9 &
