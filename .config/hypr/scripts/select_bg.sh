#!/usr/bin/env bash

set -euo pipefail

TMPDIR="${TMPDIR:-/tmp}"
UB_PID_FILE="$(mktemp "$TMPDIR/ueberzugpp-pid.XXXXXX")"
SOCKET=""

cleanup() {
  [[ -n "${SOCKET:-}" ]] && ueberzugpp cmd -s "$SOCKET" -a exit || true
  [[ -f "$UB_PID_FILE" ]] && rm -f "$UB_PID_FILE"
}
trap cleanup HUP INT QUIT TERM EXIT

ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
UB_PID="$(cat "$UB_PID_FILE")"
export SOCKET="$TMPDIR/ueberzugpp-$UB_PID.socket"

# Run fzf with preview
choice=$(
  fzf --reverse \
      --preview="ueberzugpp cmd -s \"$SOCKET\" -i fzfpreview -a add \
      -x \$FZF_PREVIEW_LEFT -y \$FZF_PREVIEW_TOP \
      --max-width \$FZF_PREVIEW_COLUMNS --max-height \$FZF_PREVIEW_LINES \
      -f {}" \
      --preview-window=right,60%
)

if [[ -n "${choice:-}" ]]; then
  swww img -t wipe --transition-duration 1 "$choice"
else
  echo "No selection made."
fi
