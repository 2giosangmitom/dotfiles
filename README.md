# Dotfiles

My Arch Linux configurations and agent skills, managed with [chezmoi](https://www.chezmoi.io/).

Just copy things that suitable to you.

## Theming

Every themed app uses the same palette, so they all match.

- `.chezmoidata/theme.toml`: flavor palettes (the single source of truth), the default flavor, and the files `mitom-theme-switch` re-applies.
- `.chezmoitemplates/theme/flavor`: prints the active flavor name. Start a themed template with `{{- $flavor := includeTemplate "theme/flavor" . -}}` and `{{- $t := index .theme.flavors $flavor -}}`, then use `{{ $t.accent }}`, `{{ $t.normal.red }}`, …
- `mitom-theme-switch <flavor>` saves the choice to `~/.config/nightfall/theme` and re-applies the themed files. Neovim reads the same file at startup.

To theme a new app, write its template with `$t`, then add its target path to `theme.targets`.
To add a flavor, add a `[theme.flavors.<name>]` table with the same keys as the others, plus a `dot_config/noctalia/palettes/nightfall-<name>.json.tmpl` stub.
