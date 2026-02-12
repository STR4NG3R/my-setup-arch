#!/bin/bash

function run {
  if ! pgrep -x "$1" > /dev/null; then
    "$@" &
  fi
}


# Run monitor setup script last
~/.screenlayout/dual-monitor.sh 
~/.config/scripts/lock.sh

# Start utilities at boot
run numlockx on
run nm-applet
run blueberry-tray
run nitrogen --restore
run xfce4-power-manager
run udiskie