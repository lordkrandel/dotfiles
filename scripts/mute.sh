#!/bin/bash

SINK_LINE=$(pactl list short sinks | grep RUNNING)
SINK_NAME=$(echo $SINK_LINE | awk '{printf $2}' | sed 's/\(_sink\)\..*/\1/g')
echo toggling $SINK_NAME
SINK=$( echo $SINK_LINE | awk '{printf $1}' )
pactl set-sink-mute $SINK toggle $*
