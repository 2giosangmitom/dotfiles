# Dotfiles

These are the configs I use on my Arch Linux desktop, managed with [chezmoi](https://www.chezmoi.io/). There's also a wallpaper and a small theme switcher script in here.

## Setup

Install [chezmoi](https://www.chezmoi.io/install/), then pull the repo and look at what it would change before applying anything:

```sh
chezmoi init git@github.com:2giosangmitom/dotfiles.git
chezmoi diff
chezmoi apply
```

Some of this is tuned to my machine, especially the Niri config and the fonts, so read the diff first. The terminal expects **JetBrainsMono Nerd Font** to be installed.

After editing anything in the chezmoi source, the same two commands push it to your home directory:

```sh
chezmoi diff
chezmoi apply
```

## Switching themes

The terminal and TUI apps share the four color variants from [nightfall.nvim](https://github.com/2giosangmitom/nightfall.nvim). Switch between them with:

```sh
mitom-theme-switch nightfall
mitom-theme-switch deeper-night
mitom-theme-switch maron
mitom-theme-switch winter
```

`mitom-theme-switch --list` prints the options, and running it with no arguments shows the current one. Your choice is saved in `~/.config/nightfall/theme`. If nothing is saved, it falls back to `nightfall`.

`README.md` and `setup/` are in `.chezmoiignore`, so they stay in the repo and never land in your home directory.
