#!/usr/bin/env bash

set -euo pipefail

readonly CURSOR_NAME="Bibata-Modern-Ice"
readonly CURSOR_VERSION="v2.0.7"
readonly CURSOR_URL="https://github.com/ful1e5/Bibata_Cursor/releases/download/${CURSOR_VERSION}/${CURSOR_NAME}.tar.xz"
readonly ICONS_DIR="${HOME}/.local/share/icons"
readonly DOWNLOAD_DIR="$(mktemp -d)"

trap 'rm -rf "$DOWNLOAD_DIR"' EXIT

curl --output-dir "$DOWNLOAD_DIR" -fSOL "$CURSOR_URL"

mkdir -p "$ICONS_DIR"
rm -rf "${ICONS_DIR:?}/${CURSOR_NAME}"
tar -xf "${DOWNLOAD_DIR}/${CURSOR_NAME}.tar.xz" -C "$ICONS_DIR"
