#!/bin/bash
icon_unlocked=""
icon_locked=""

sleep .2

case $1 in
    'num')
        mask=2
        key="Num"
        ;;
    'caps')
        mask=1
        key="Caps"
        ;;
esac

value="$(xset q | grep 'LED mask' | awk '{ print $NF }')"

if [ $(( 0x$value & 0x$mask )) == $mask ]
then
    output="$icon_locked $key Lock is on"
else
    output="$icon_unlocked $key Lock is off"
fi

notify-send "$output"
