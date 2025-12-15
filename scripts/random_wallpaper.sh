#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Wallpapers"

if ! pgrep -x "hyprpaper" >/dev/null; then
  hyprpaper &
fi

[[ -d "$WALLPAPER_DIR" ]] || exit 1

random_wp=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$random_wp"
hyprctl hyprpaper wallpaper ",$random_wp"
