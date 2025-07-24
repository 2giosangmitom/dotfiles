#
# ~/.bashrc
#

# Exit if not running interactively
[[ $- != *i* ]] && return

# Path helper functions
pathprepend() { [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; }
pathappend() { [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"; }

# Add Neovim managed by bob to PATH
pathprepend "$HOME/.local/share/bob/nvim-bin"
pathappend "$HOME/.local/bin"

# Integrations
command -v starship &>/dev/null && eval "$(starship init bash)"
command -v fzf &>/dev/null && eval "$(fzf --bash)"
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# Auto change directory when using yazi
function y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd" || return 0
  rm -f -- "$tmp"
}

# Enable bash-completion
[[ -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion

# Shell behavior
shopt -s checkwinsize
shopt -s histappend
shopt -s cdspell

# Aliases
alias ls="eza --color=auto --group-directories-first"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias lt="ls --tree"
alias dev="nix develop"

# Use nvim as manpager
export MANPAGER="nvim +Man!"

# Use nvim as default editor
export EDITOR="nvim"

# History settings
export HISTSIZE=10000

# bun
export BUN_INSTALL="$HOME/.bun"
pathappend "$BUN_INSTALL/bin:$PATH"
