#!/usr/bin/env bash

if ! pgrep -x swww-daemon >/dev/null; then
  swww-daemon --no-cache &
fi

DIR="$HOME/wallpapers/"

if [[ -d $DIR ]]; then
  random=$(fd -pa -t f "^*" "$DIR" | shuf -n1)
  swww img -t wipe --transition-duration 1 "$random" &
fi
