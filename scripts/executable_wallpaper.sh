#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Wallpapers}"
LAST_WALLPAPER_PATH="/tmp/awww_current_wallpaper"

die() {
	echo "error: $*" >&2
	exit 1
}

ensure_daemon() {
	if ! pgrep -x "awww-daemon" >/dev/null 2>&1; then
		awww-daemon --no-cache &
		sleep 1
	fi
}

list_wallpapers() {
	find "$WALLPAPER_DIR" -type f \( \
		-iname "*.jpg" -o -iname "*.jpeg" -o \
		-iname "*.png" -o -iname "*.gif" -o \
		-iname "*.webp" \
		\) | sort
}

set_wallpaper() {
	local path="$1"
	awww img "$path"
	echo "$path" >"$LAST_WALLPAPER_PATH"
	echo "wallpaper: $(basename "$path")"
}

current_wallpaper() {
	if [[ -f "$LAST_WALLPAPER_PATH" ]]; then
		cat "$LAST_WALLPAPER_PATH"
	fi
}

[[ -d "$WALLPAPER_DIR" ]] || die "wallpaper directory not found: $WALLPAPER_DIR"

mapfile -t wallpapers < <(list_wallpapers)
((${#wallpapers[@]} > 0)) || die "no wallpapers found in $WALLPAPER_DIR"

cmd="${1:-random}"

case "$cmd" in
random)
	ensure_daemon
	idx=$((RANDOM % ${#wallpapers[@]}))
	set_wallpaper "${wallpapers[$idx]}"
	;;

next | prev)
	ensure_daemon
	current=$(current_wallpaper)
	count=${#wallpapers[@]}
	idx=0

	for i in "${!wallpapers[@]}"; do
		if [[ "${wallpapers[$i]}" == "$current" ]]; then
			idx=$i
			break
		fi
	done

	if [[ "$cmd" == "next" ]]; then
		idx=$(((idx + 1) % count))
	else
		idx=$(((idx - 1 + count) % count))
	fi

	set_wallpaper "${wallpapers[$idx]}"
	;;

*)
	echo "usage: $(basename "$0") [random|next|prev]" >&2
	exit 1
	;;
esac
