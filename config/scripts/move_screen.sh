#!/bin/bash

max_screens =  xrandr | grep -c "\*" 
case $1 in
    'next')
        if [ $2 < max_screens ]
            then
                echo [ $2 + 1 ]
                notify-send "Moved to Next Display" 
        fi
        ;;     
    'previous')     
         if [ $2 > 0 ]     
            then    
                echo [ $2 - 1 ]    
                notify-send "Moved to previous Display"
         fi
        ;; 
esac   
