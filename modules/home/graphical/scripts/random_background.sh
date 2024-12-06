#!/usr/bin/env bash

# Directory containing background images
DIR="$HOME/Pictures/backgrounds/"
LAST_BG_FILE="/tmp/last_background"

# Ensure the background directory exists
if [[ ! -d "$DIR" ]]; then
  echo "Error: Directory $DIR does not exist."
  exit 1
fi

# Generate a random background that is different from the previous one
while :; do
  random_background=$(find "$DIR" -name "bg*" | shuf -n1)
  [[ ! -f "$LAST_BG_FILE" || "$random_background" != "$(cat "$LAST_BG_FILE")" ]] && break
done

# Start swww-daemon if it's not running
if ! pgrep -u "$UID" -x swww-daemon >/dev/null; then
  if ! swww-daemon >/dev/null; then
    echo "Error: Failed to start swww-daemon."
    exit 1
  fi
  sleep 1
fi

# Set the new background
if swww img -t wipe --transition-duration 1 --transition-fps 60 "$random_background"; then
  echo "$random_background" >"$LAST_BG_FILE"
else
  echo "Error: Failed to set background image."
  exit 1
fi
