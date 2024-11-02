#!/usr/bin/env bash

set -e

CONFIG_DIR="$HOME/.config"
DRY_RUN=false

# Function to run a command with optional dry run
run_cmd() {
  local cmd="$1"
  if $DRY_RUN; then
    echo "[DRY RUN] $cmd"
  else
    eval "$cmd"
  fi
}

# Ensures the configuration directory exists
ensure_config_dir() {
  [ -d "$CONFIG_DIR" ] || run_cmd "mkdir -p $CONFIG_DIR"
}

# Update system packages
update_system() {
  echo "Updating system packages..."
  run_cmd "sudo pacman -Syu"
}

# Install and configure Hyprland
install_hyprland() {
  echo "Installing and setting up Hyprland..."
  run_cmd "sudo pacman -S hyprland hyprpaper hyprlock --needed"
  ensure_config_dir
  run_cmd "cp -r ./hypr/ $CONFIG_DIR/"
}

# Install and configure Neovim
install_neovim() {
  echo "Installing and setting up Neovim..."
  run_cmd "sudo pacman -S neovim --needed"
  ensure_config_dir
  run_cmd "cp -r ./nvim/ $CONFIG_DIR/"
}

# Install and configure Rofi
install_rofi() {
  echo "Installing and setting up Rofi..."
  run_cmd "sudo pacman -S rofi-wayland --needed"
  ensure_config_dir
  run_cmd "cp -r ./rofi/ $CONFIG_DIR/"
}

# Configure Bash
setup_bash() {
  echo "Setting up Bash configuration..."
  run_cmd "cp ./.bashrc ~/"
}

# Install and configure Starship
install_starship() {
  echo "Installing and setting up Starship prompt..."
  run_cmd "sudo pacman -S starship --needed"
  ensure_config_dir
  run_cmd "cp ./starship.toml $CONFIG_DIR/"
}

# Install and configure Waybar
install_waybar() {
  echo "Installing and setting up Waybar..."
  run_cmd "sudo pacman -S waybar --needed"
  ensure_config_dir
  run_cmd "cp -r ./waybar/ $CONFIG_DIR/"
}

# Main bootstrap function
bootstrap() {
  update_system
  install_hyprland
  install_neovim
  install_rofi
  setup_bash
  install_starship
  install_waybar
}

# Help function
show_help() {
  echo "Usage: $0 [OPTION]"
  echo ""
  echo "Options:"
  echo "  --bootstrap       Run the full bootstrap process to install and configure all applications"
  echo "  --dry-run         Show the commands without executing them (useful for testing)"
  echo "  --help            Display this help message"
  echo ""
}

# Check for arguments
if [ "$#" -eq 0 ]; then
  echo "The script needs arguments. See --help for details."
  exit 1
fi

# Parse arguments
for arg in "$@"; do
  case "$arg" in
  "--bootstrap") bootstrap ;;
  "--dry-run") DRY_RUN=true ;;
  "--help")
    show_help
    exit 0
    ;;
  *)
    echo "Invalid option: $arg"
    show_help
    exit 1
    ;;
  esac
done