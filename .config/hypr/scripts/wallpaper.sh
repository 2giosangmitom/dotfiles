#!/usr/bin/env bash

# Check if swww-daemon is running, and start it if not
if ! pgrep -x swww-daemon >/dev/null; then
  echo "Starting swww-daemon..."
  swww-daemon --no-cache &>/tmp/swww.log &
  sleep 1 # Wait for the daemon to initialize
  if ! pgrep -x swww-daemon >/dev/null; then
    echo "Failed to start swww-daemon. Check /tmp/swww.log for details." >&2
    exit 1
  fi
fi

# Set the directory containing wallpapers
DIR="$HOME/wallpapers/"

# Check if the directory exists
if [[ -d "$DIR" ]]; then
  # Find a random image file
  random=$(fd -pa -t f "^*" "$DIR" | shuf -n1)

  # Ensure a file was found
  if [[ -z "$random" ]]; then
    echo "No images found in $DIR" >&2
    exit 1
  fi

  # Set the wallpaper
  if ! swww img -t wipe --transition-duration 1 "$random"; then
    echo "Failed to set wallpaper with swww" >&2
    exit 1
  fi
else
  echo "Directory $DIR does not exist" >&2
  exit 1
fi
