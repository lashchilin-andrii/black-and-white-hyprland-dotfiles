#!/usr/bin/env bash

# Path to your horizontal language-selection theme
ROFI_THEME="/home/andrii/.config/rofi/language-selection.rasi"

# 1. Fetch installed tesseract language packs dynamically via pacman
LANGS=$(pacman -Qeq | grep '^tesseract-data-' | sed 's/tesseract-data-//')

# Fallback: if no language packages are found, default to 'eng'
if [ -z "$LANGS" ]; then
    LANGS="eng"
fi

# 2. Open rofi using the horizontal test.rasi layout
LANG_CHOICE=$(echo "$LANGS" | rofi -dmenu -theme "$ROFI_THEME" -p "Language:")

# Exit if user cancels or closes the menu
if [ -z "$LANG_CHOICE" ]; then
    exit 0
fi

# Target screenshots folder
SCREENSHOT_DIR="$HOME/pictures/screenshots"
mkdir -p "$SCREENSHOT_DIR"

# 3. Capture region and open Swappy (Swappy auto-saves to SCREENSHOT_DIR)
grim -g "$(slurp)" - | swappy -f -

# 4. Find the most recently created PNG file in the screenshots folder
LATEST_IMG=$(find "$SCREENSHOT_DIR" -maxdepth 1 -type f -name "*.png" -printf '%T@ %p\n' | sort -n | tail -n 1 | cut -d' ' -f2-)

# 5. Run OCR on that file if it exists
if [ -n "$LATEST_IMG" ]; then
    tesseract -l "$LANG_CHOICE" "$LATEST_IMG" stdout | wl-copy
fi