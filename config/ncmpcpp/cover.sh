#!/bin/bash

source "`ueberzug library`"

COVER="/tmp/album_cover.png"

function add_cover {
  ImageLayer::add [identifier]="img" [x]="0" [y]="0" [path]="$COVER"
}

ImageLayer 0< <(
if [ ! -f "$COVER" ]; then
  cp "$HOME/.config/ncmpcpp/default_cover.png" "$COVER"
fi

clear
#rerender image when changed
while inotifywait -q -q -e close_write "$COVER"; do
  add_cover
done
)
