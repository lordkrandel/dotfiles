#!/usr/bin/bash


PRIMARY=
EDP=
MONITORS=$(xrandr --query | grep " connected" | awk '{print $1}')

echo Looking for monitors...
for monitor in $MONITORS; do
    echo Activating $monitor...
    xrandr --output $monitor --mode 1920x1080 --pos 0x0
    if [[ "$monitor" != "eDP" && "$monitor" != "eDP-*" ]]; then
        PRIMARY="$monitor"
    else
        EDP="$monitor"
    fi
done

if [ -z "${PRIMARY}" ]; then
    PRIMARY=$EDP
fi

echo $PRIMARY set as primary.
xrandr --output "$PRIMARY" --primary --mode 1920x1080 --pos 0x0
