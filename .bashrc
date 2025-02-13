#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls="ls --color --group-directories-first"

eval "$(zoxide init bash)"
eval "$(fzf --bash)"

PS1="\n\[\e[38;5;159m\]\w\n\[\e[0m\]\$ "

export PATH="$PATH:$HOME/.local/bin/"
