#!/usr/bin/env bash

TMP="/tmp"

cleanup() {
  ueberzugpp cmd -s "$SOCKET" -a exit
}
trap cleanup HUP INT QUIT TERM EXIT

UB_PID_FILE="$TMP/.$(uuidgen)"
ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
UB_PID=$(cat "$UB_PID_FILE")

export SOCKET="$TMP"/ueberzugpp-"$UB_PID".socket

# Run fzf with preview
choice=$(fzf --reverse --preview="ueberzugpp cmd -s $SOCKET -i fzfpreview -a add \
                            -x \$FZF_PREVIEW_LEFT -y \$FZF_PREVIEW_TOP \
                            --max-width \$FZF_PREVIEW_COLUMNS --max-height \$FZF_PREVIEW_LINES \
                            -f {}")

swww img --transition-duration 1 --transition-step 20 --transition-type simple "$choice"

ueberzugpp cmd -s "$SOCKET" -a exit
