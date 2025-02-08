#!/usr/bin/env bash

if [[ ! $(pgrep -x swww-daemon) ]]; then
  swww-daemon
fi

DIR="$HOME/backgrounds/"

if [ -d "$DIR" ]; then
  random_background=$(fd -tf -a "^*" "$DIR" | shuf -n1)
  swww img --transition-duration 1 --transition-step 20 --transition-type simple "$random_background"
fi
