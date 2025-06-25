#!/usr/bin/env bash

ROOT_UID=0
THEME_DIR="/usr/share/grub/themes"
THEME_NAME="Itsuki"

# Define colors
CDEF="\033[0m"
b_CCIN="\033[1;36m"
b_CGSC="\033[1;32m"
b_CRER="\033[1;31m"
b_CWAR="\033[1;33m"

# Colored prompt output
prompt() {
  case "$1" in
  -s | --success)
    shift
    echo -e "${b_CGSC}$*${CDEF}"
    ;;
  -e | --error)
    shift
    echo -e "${b_CRER}$*${CDEF}"
    ;;
  -w | --warning)
    shift
    echo -e "${b_CWAR}$*${CDEF}"
    ;;
  -i | --info)
    shift
    echo -e "${b_CCIN}$*${CDEF}"
    ;;
  *) echo -e "$*" ;;
  esac
}

# Command existence check
has_command() {
  command -v "$1" >/dev/null 2>&1
}

# Header
prompt -s "\n\t          **********************************"
prompt -s "\t          * Nakano Itsuki Bootloader Theme *"
prompt -s "\t          **********************************\n"
prompt -s "\t           Grub theme by Andi Trisna Mukti\n"

# Start message
prompt -i "Press Enter to begin installation (auto-install in 10s): ${b_CWAR}"
read -r -t 10

# Root permission check
prompt -w "\nChecking for root access...\n"
if [ "$UID" -ne "$ROOT_UID" ]; then
  prompt -e "\n[Error] Please run this script as root.\n"
  exit 1
fi

# Check required commands
for cmd in grub-mkconfig cp mkdir sed grep; do
  if ! has_command "$cmd"; then
    prompt -e "[Missing] Required command '$cmd' is not found in PATH."
    exit 1
  fi
done

# Create theme directory
prompt -i "Preparing theme directory..."
THEME_PATH="${THEME_DIR}/${THEME_NAME}"
if [ -d "$THEME_PATH" ]; then
  prompt -w "Existing theme directory found. Removing..."
  rm -rf "$THEME_PATH"
fi
mkdir -p "$THEME_PATH"

# Copy files
prompt -i "Copying theme files to ${THEME_PATH}..."
cp -a "${THEME_NAME}/." "$THEME_PATH"

# Backup grub config
prompt -i "Backing up current GRUB config to /etc/default/grub.bak..."
cp -an /etc/default/grub /etc/default/grub.bak

# Set theme in grub config
prompt -i "Applying new theme in /etc/default/grub..."
sed -i '/^GRUB_THEME=/d' /etc/default/grub
echo "GRUB_THEME=\"${THEME_PATH}/theme.txt\"" >>/etc/default/grub

# Update grub
prompt -i "Updating grub configuration..."
grub-mkconfig -o /boot/grub/grub.cfg

# Done
prompt -s "\n\t            **************************"
prompt -s "\t            * Successfully Installed *"
prompt -s "\t            **************************\n"
