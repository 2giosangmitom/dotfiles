# Disable greeting message
set fish_greeting

# Enable starship integration
starship init fish | source

# Enable zoxide integration
zoxide init fish | source

# Enable fzf integration
fzf --fish | source

set PATH $PATH $HOME/.local/bin/
