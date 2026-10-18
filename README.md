# Dotfiles

My Linux desktop configuration, managed with [chezmoi](https://www.chezmoi.io/).

## What's included

| Tool      | Configuration                                          |
| --------- | ------------------------------------------------------ |
| Niri      | Wayland compositor, bindings, layouts, and rules       |
| Noctalia  | Shell appearance and behavior                          |
| Alacritty | Terminal settings and four Nightfall color variants    |
| Yazi      | File manager theme with matching Nightfall variants    |
| Lazygit   | Git TUI theme with matching Nightfall variants         |
| Neovim    | Editor settings and plugins                            |
| Bash      | Starship, fzf, mise, zoxide, eza, and Yazi integration |
| Starship  | Nerd Font Symbols preset                               |
| Git       | Git defaults and delta integration                     |

The repository also includes a wallpaper and the `mitom-theme-switch` script.

## Setup

Install [chezmoi](https://www.chezmoi.io/install/) and the applications you use, then initialize these dotfiles:

```sh
chezmoi init git@github.com:2giosangmitom/dotfiles.git
chezmoi diff
chezmoi apply
```

Review `chezmoi diff` before applying: the configuration may include machine-specific settings, particularly for Niri and installed fonts. Alacritty uses **JetBrainsMono Nerd Font**.

To apply changes after editing the chezmoi source:

```sh
chezmoi diff
chezmoi apply
```

## Theme switching

Alacritty, Yazi, and Lazygit use the four variants from [nightfall.nvim](https://github.com/2giosangmitom/nightfall.nvim):

```sh
mitom-theme-switch nightfall
mitom-theme-switch deeper-night
mitom-theme-switch maron
mitom-theme-switch winter
```

Run `mitom-theme-switch --list` to see the options, or run it without arguments to show the current variant. The selection is saved at `~/.config/nightfall/theme`; the default is `nightfall`.

`README.md` and `setup/` are listed in `.chezmoiignore` so chezmoi does not install them into the home directory.
