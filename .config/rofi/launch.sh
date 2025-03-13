#!/usr/bin/env bash

DIR="$HOME/.config/rofi"

case $1 in
"launcher")
  rofi -config "$DIR/launcher.rasi" -show drun
  ;;
esac
