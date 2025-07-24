set -U fish_greeting
set -U fish_user_paths ~/.local/share/bob/nvim-bin/ ~/.bun/bin/

zoxide init fish | source
starship init fish | source
fzf --fish | source
