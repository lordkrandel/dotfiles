#!/usr/bin/bash

~/projects/scripts/rofi_choice.nim "Power Menu" "session >>" \
    -theme "~/projects/scripts/rofi_choice.rasi" \
    "🛑 Shutdown|systemctl poweroff" \
    "🔄 Reboot|systemctl reboot" \
    "🌙 Suspend|systemctl suspend" \
    "🔒 Lock|i3-msg exec ~/projects/scripts/lock.sh" \
    "🚪 Logout|i3-msg exit"
