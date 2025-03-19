#!/usr/bin/env bash

# Start ibus
ibus-daemon -rxRd

# Directory containing wallpapers
BG_DIR="$HOME/wallpapers"

# Check if hyprpaper is not running, then start it
if ! pgrep -x hyprpaper >/dev/null; then
  hyprpaper &
  sleep 1
fi

# If the wallpaper directory exists, select a random wallpaper and set it
if [ -d "$BG_DIR" ]; then
  random_background=$(fd -a "^*" "$BG_DIR" | shuf -n1)
  hyprctl hyprpaper preload "$random_background"
  hyprctl hyprpaper wallpaper "eDP-1,$random_background"
fi
