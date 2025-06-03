#!/usr/bin/env bash

set -euo pipefail

# Bright color palette and styles
BOLD='\033[1m'
UNDERLINE='\033[4m'
RESET='\033[0m'
BLACK='\033[1;90m'
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[1;93m'
BLUE='\033[1;94m'
MAGENTA='\033[1;95m'
CYAN='\033[1;96m'
WHITE='\033[1;97m'
BG_BLUE='\033[44m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_RED='\033[41m'

log_task() {
  # Blue bold underline for tasks
  echo -e "${BOLD}${UNDERLINE}${BLUE}==> $1${RESET}"
}

log_info() {
  # Cyan bold for info
  echo -e "${BOLD}${CYAN}$1${RESET}"
}

log_success() {
  # Green bold with background for success
  echo -e "${BOLD}${BG_GREEN}${BLACK}✔ $1${RESET}"
}

log_warn() {
  # Yellow bold with background for warnings
  echo -e "${BOLD}${BG_YELLOW}${BLACK}⚠ $1${RESET}"
}

log_error() {
  # Red bold with background for errors
  echo -e "${BOLD}${BG_RED}${WHITE}✖ $1${RESET}"
}

usage() {
  echo -e "${BOLD}${UNDERLINE}Usage:${RESET} $0 [options]"
  echo -e "${CYAN}Options:${RESET}"
  echo -e "  ${YELLOW}-n${RESET}, ${YELLOW}--dry-run${RESET}   Show what would be installed, but don't install"
  echo -e "  ${YELLOW}-y${RESET}, ${YELLOW}--yes${RESET}       Don't prompt for confirmation"
  echo -e "  ${YELLOW}-h${RESET}, ${YELLOW}--help${RESET}      Show this help"
}

PKGS=(
  # Terminal & Shell
  alacritty starship fastfetch zoxide fzf yazi bottom ripgrep fd git-delta git

  # Editors
  neovim vim

  # Window Manager & Desktop
  hyprland hypridle swww waybar nwg-look xdg-desktop-portal xdg-desktop-portal-hyprland

  # Fonts
  ttf-roboto ttf-jetbrains-mono-nerd noto-fonts-emoji

  # Media & Audio
  obs-studio pavucontrol

  # Misc
  nix
)

DRY_RUN=0
ASSUME_YES=0

while [[ $# -gt 0 ]]; do
  case "$1" in
  -n | --dry-run) DRY_RUN=1 ;;
  -y | --yes) ASSUME_YES=1 ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    log_warn "Unknown option: $1"
    usage
    exit 1
    ;;
  esac
  shift
done

main() {
  log_task "Checking installed packages"
  install_list=()
  skipped_list=()
  for pkg in "${PKGS[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
      install_list+=("$pkg")
    else
      log_info "Skipping already installed package: ${BOLD}${GREEN}$pkg${RESET}"
      skipped_list+=("$pkg")
    fi
  done

  if [[ ${#skipped_list[@]} -gt 0 ]]; then
    log_task "Already installed packages"
    printf "${GREEN}✔ %s${RESET}\n" "${skipped_list[@]}"
    echo
  fi

  if [[ ${#install_list[@]} -eq 0 ]]; then
    log_success "All packages are already installed!"
    return
  fi

  log_task "Packages to be installed"
  printf "${MAGENTA}➜ %s${RESET}\n" "${install_list[@]}"
  echo

  if [[ $DRY_RUN -eq 1 ]]; then
    log_warn "[Dry Run] Would run: sudo pacman -S ${install_list[*]} --needed --noconfirm"
    exit 0
  fi

  if [[ $ASSUME_YES -eq 0 ]]; then
    read -rp "$(echo -e "${YELLOW}""${BOLD}"Proceed with installation? [y/N] "${RESET}")" confirm
    [[ $confirm =~ ^[Yy]$ ]] || {
      log_warn "Aborted by user"
      exit 1
    }
  fi

  log_task "Installing packages"
  sudo pacman -S "${install_list[@]}" --needed --noconfirm &&
    log_success "All done!"
}

main "$@"
