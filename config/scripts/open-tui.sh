#!/bin/bash
tool=ranger
loc="$1"
loc=${loc#"file://"}


if [[ ! -e $loc ]]; then
    loc=$(dirname "$loc")
fi

notify-send "Opening ${tool} at ${loc}"

i3-msg exec "alacritty -e ${tool} ${loc}"
