#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/dotfiles/Wallpapers"

if ! pgrep -x "hyprpaper" >/dev/null; then
  hyprpaper &
fi

[[ -d "$WALLPAPER_DIR" ]] || exit 1

current=$(hyprctl hyprpaper listloaded)

next_wp=$(
  find "$WALLPAPER_DIR" -type f |
    awk -v cur="$current" '
    found { print; exit }
    $0 == cur { found=1 }
  '
)

# If current is last or not found -> wrap to first
if [[ -z "$next_wp" ]]; then
  next_wp=$(find "$WALLPAPER_DIR" -type f | head -n 1)
fi

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$next_wp"
hyprctl hyprpaper wallpaper ",$next_wp"
