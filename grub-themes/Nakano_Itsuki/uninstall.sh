#!/usr/bin/env bash

ROOT_UID=0
THEME_DIR="/usr/share/grub/themes"
THEME_NAME="Itsuki"
THEME_PATH="${THEME_DIR}/${THEME_NAME}"
GRUB_CFG="/etc/default/grub"
GRUB_BAK="${GRUB_CFG}.bak"

# Colors
CDEF="\033[0m"
b_CGSC="\033[1;32m"
b_CRER="\033[1;31m"
b_CWAR="\033[1;33m"
b_CCIN="\033[1;36m"

# Prompt function
prompt() {
  local type="$1"
  shift
  case "$type" in
  -s | --success) echo -e "${b_CGSC}$*${CDEF}" ;;
  -e | --error) echo -e "${b_CRER}$*${CDEF}" ;;
  -w | --warning) echo -e "${b_CWAR}$*${CDEF}" ;;
  -i | --info) echo -e "${b_CCIN}$*${CDEF}" ;;
  *) echo -e "$type $*" ;; # fallback
  esac
}

# Command existence checker
has_command() {
  command -v "$1" >/dev/null 2>&1
}

# Header
prompt -s "\n\t          **********************************"
prompt -s "\t          * Nakano Itsuki Bootloader Theme *"
prompt -s "\t          **********************************"
prompt -s "\n\t           Grub theme by Andi Trisna Mukti\n"

# Confirm or wait
prompt -i "Press Enter to begin uninstallation (auto-continue in 10s): ${b_CWAR}"
read -r -t 10

# Root check
prompt -w "\nChecking for root access...\n"
if [ "$UID" -ne "$ROOT_UID" ]; then
  prompt -e "\n[Error] Please run this script as root (e.g. sudo ./uninstall.sh).\n"
  exit 1
fi

# Remove theme directory
if [ -d "$THEME_PATH" ]; then
  prompt -i "Removing theme directory at ${THEME_PATH}..."
  rm -rf "$THEME_PATH"
else
  prompt -w "Theme directory not found at ${THEME_PATH}."
fi

# Backup GRUB config
if [ ! -f "$GRUB_BAK" ]; then
  cp -an "$GRUB_CFG" "$GRUB_BAK"
  prompt -i "Backed up original GRUB config to ${GRUB_BAK}"
else
  prompt -w "Backup already exists at ${GRUB_BAK}, skipping."
fi

# Remove GRUB_THEME line
prompt -i "Removing GRUB_THEME entry from GRUB config..."
sed -i '/^GRUB_THEME=/d' "$GRUB_CFG"

# Regenerate grub config
if has_command grub-mkconfig; then
  prompt -i "Updating GRUB configuration..."
  grub-mkconfig -o /boot/grub/grub.cfg
  prompt -s "\n\t            ****************************"
  prompt -s "\t            * Successfully Uninstalled *"
  prompt -s "\t            ****************************\n"
else
  prompt -e "[Error] grub-mkconfig not found! Please install GRUB or update manually."
  exit 1
fi
