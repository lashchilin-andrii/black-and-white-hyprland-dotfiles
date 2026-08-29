#!/bin/bash

# Fetch current active layout name
LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) .active_keymap' | head -n1)

# Fallback if no main keyboard is tagged
if [ -z "$LAYOUT" ] || [ "$LAYOUT" = "null" ]; then
    LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[0].active_keymap')
fi

# Convert layout string to 2-letter code
case "$LAYOUT" in
    *"English"*)   SHORT="us" ;;
    *"German"*)    SHORT="de" ;;
    *"Ukrainian"*) SHORT="ua" ;;
    *"Russian"*)   SHORT="ru" ;;
    *)             SHORT=$(echo "$LAYOUT" | cut -c1-2 | tr '[:upper:]' '[:lower:]') ;;
esac

# Check Caps Lock status
CAPS=$(cat /sys/class/leds/input*::capslock/brightness 2>/dev/null | head -n1)

if [ "$CAPS" = "1" ]; then
    TEXT=$(echo "$SHORT" | tr '[:lower:]' '[:upper:]')
    CLASS="capslock"
else
    TEXT="$SHORT"
    CLASS="normal"
fi

printf '{"text":"%s","class":"%s"}\n' "$TEXT" "$CLASS"