#!/usr/bin/env bash

if [[ "$BLOCK_BUTTON" == "1" ]]; then
    ~/projects/scripts/rofi_choice.nim \
        -theme "~/projects/dotfiles/.config/rofi_choice.rasi" \
        "Power Profiles" "profile >>" \
        "⚡ Fast|powerprofilesctl set performance" \
        "⚖️ Paced|powerprofilesctl set balanced" \
        "🌱 Slow|powerprofilesctl set power-saver" \
        >/dev/null 2>&1
fi
case $(/usr/bin/powerprofilesctl get) in
    performance) echo 'fast' ;;
    balanced)    echo 'paced' ;;
    power-saver) echo 'slow' ;;
esac
