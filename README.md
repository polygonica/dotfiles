# Dotfiles

Personal development environment configuration files.

## Quickly putting dotfiles in place

See <https://www.chezmoi.io/quick-start/#using-chezmoi-across-multiple-machines>

## Supported Platforms

- MacOS (primary)
- Linux (primary)
- Windows (limited support, will probably work to some degree, sometimes)

## High-level customizations (and TODOs)

- Chezmoi
  - Currently:
    - dotfile repo initialized
  - TODO:
    - Create a `run_once_install-deps.sh`-type file to install my favorite QOL tools during `chezmoi init` or `chezmoi apply`
- Wezterm
  - Currently:
    - automatic light/dark terminal color theming
    - automatic (mainly for light/dark) theming of tabs from scheme colors
    - Some automatic process detection for emojis in tab names
    - iTerm-style tab shortcut naming
  - TODO:
    - shell integration configured <https://wezterm.org/shell-integration.html> to make the tab titles / status area more informative about username @ hostname (running process)
    - Add some space to the left of the tab area so that MacOS buttons aren’t completely screwed when we go fullscreen
    - Consider adding workspaces for manual naming of tasks
- Starship
  - Currently:
    - Colored prompt
    - git repo context info
    - command success / failure
    - Command timing
  - TODO:
    - User @ host info on prompt to avoid discombobulation with most machines running a standardized prompt
