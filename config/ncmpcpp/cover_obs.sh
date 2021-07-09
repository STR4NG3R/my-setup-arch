#!/bin/bash
COVER="/tmp/tmp_album_cover.png"
COVER_SIZE="250"
#path to current song
file_name=`mpc --format %file% current`
path="$HOME/Music/$file_name"

result=`echo -en "Y\n" | ffmpeg -i "$path"  "$COVER"`

if [[ "$result" == *"GCC"* ]]; then
  $COVER="$HOME/.config/ncmpcpp/default_cover.png"
fi

art=/tmp/"$file_name".png
ffmpeg -loglevel fatal -hide_banner -y -i "$COVER" -vf scale="$COVER_SIZE":-1 /tmp/album_cover.png 
