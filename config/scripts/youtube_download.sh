#!/bin/zsh
regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
link=$(xclip -o)
if [[ $link =~ $regex ]]
then 
    notify-send "Starting Download ${link}"
    cwd=$(pwd)
    cd $HOME/Music/
    youtube-dl -x --embed-thumbnail --audio-format mp3 $link
    notify-send "Downloaded"
    cd $cwd
  else 
    notify-send "Invalid Link"
fi
