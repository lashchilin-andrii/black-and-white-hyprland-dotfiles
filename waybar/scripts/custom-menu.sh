#!/usr/bin/env bash

readonly THEME="$HOME/.config/rofi/option-selection.rasi"

readonly OPT_POWER="Power Profile"
readonly OPT_NIGHT="Night Light"
readonly OPT_AERO="Aeroplane Mode"

menu()   { rofi -dmenu -config "$THEME" "$@"; }
notify() { notify-send -t 3000 "$@"; }

power_profile() {
    local profiles=(power-saver balanced performance)
    local current selected=0 index new

    current=$(powerprofilesctl get)
    for i in "${!profiles[@]}"; do
        [[ ${profiles[i]} == "$current" ]] && selected=$i
    done

    index=$(printf '%s\n' \
        '<span foreground="#7CD992">Power Saver</span>' \
        '<span foreground="#FFFFFF">Balanced</span>' \
        '<span foreground="#FF6B6B">Performance</span>' \
        | menu -markup-rows -format i -p "Power Profile" -selected-row "$selected")
    [[ -n $index ]] || return 0   # Esc pressed

    new=${profiles[index]}
    powerprofilesctl set "$new"

    # Replaces hyphens with spaces and capitalizes the first letter of each word
    local notify_msg="${new//-/ }"
    notify_msg=$(echo "$notify_msg" | sed 's/\b\([a-z]\)/\U\1/g')

    notify "$notify_msg"
}


night_light() {
    if pgrep -x gammastep >/dev/null; then
        pkill gammastep
        notify "Disabled"
    else
        gammastep -O 4000 &
        notify "Enabled"
    fi
}

aeroplane_mode() {
    if rfkill list wifi | grep -q "Soft blocked: yes"; then
        rfkill unblock wifi
        notify "Aeroplane Mode" "Disabled"
    else
        rfkill block wifi
        notify "Aeroplane Mode" "Enabled"
    fi
}

choice=$(printf '%s\n' "$OPT_POWER" "$OPT_NIGHT" "$OPT_AERO" | menu -p "Quick Settings")

case $choice in
    "$OPT_POWER") power_profile ;;
    "$OPT_NIGHT") night_light ;;
    "$OPT_AERO")  aeroplane_mode ;;
esac