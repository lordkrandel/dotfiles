#!/bin/bash

if lsusb | grep -q 'Ducky'
then
    SELECTED=it
    LAYOUT=it,us,fr
else
    SELECTED=us
    LAYOUT=us,it,fr
fi

setxkbmap -model pc105 -layout $SELECTED
sleep 1
setxkbmap -model pc105 -layout $LAYOUT
