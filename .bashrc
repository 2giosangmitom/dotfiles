#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Integrations
eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"

# Enable bash-completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
fi

# Auto update the window size after each command
shopt -s checkwinsize

# Aliases
alias ls="eza"
alias la="ls -a"
alias ll="ls -l"
alias lt="ls -T"
alias lla="ls -la"
alias dev="nix develop"

# Use nvim as manpager
export MANPAGER="nvim +Man!"

# Override PATH
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
