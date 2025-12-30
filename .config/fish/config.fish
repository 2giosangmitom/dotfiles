set -U fish_greeting

zoxide init fish | source
starship init fish | source
fzf --fish | source
mise activate fish | source

alias ls="eza --color=auto --group-directories-first"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias lt="ls --tree"
