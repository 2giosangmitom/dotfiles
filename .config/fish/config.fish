set -U fish_greeting
set -U fish_user_paths ~/.local/share/bob/nvim-bin/ ~/.bun/bin/ ~/.deno/bin/

zoxide init fish | source
starship init fish | source
fzf --fish | source

alias ls="eza --color=auto --group-directories-first"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias lt="ls --tree"
alias dev="nix develop"
