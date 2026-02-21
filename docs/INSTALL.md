# Installation

## Prerequisites

- macOS
- Xcode Command Line Tools

```bash
xcode-select --install
```

## Recommended Bootstrap (Bash)

```bash
curl -fsSL https://raw.githubusercontent.com/attaradev/dotfiles/main/bootstrap.sh | bash
```

Bootstrap will clone to `~/.dotfiles` (or pull latest if already cloned) and run `./setup.sh`.

## Manual Installation

```bash
git clone https://github.com/attaradev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

`make install` runs:

1. Homebrew install/check
2. `brew bundle install`
3. `install_mise.sh`
4. Git identity setup (`~/.gitconfig.local`)
5. `stow_setup.sh`
6. `setup_gnupg.sh`
7. `vscode_setup.sh` (if `code` CLI exists)

## Non-Interactive Installation

Use this mode for automation and CI runners.

```bash
DOTFILES_NONINTERACTIVE=1 SKIP_VSCODE_EXTENSIONS=1 ./setup.sh
```

When `DOTFILES_NONINTERACTIVE=1` is set:

- Optional cask prompts are disabled.
- Git identity prompts are disabled.
- Sudo credential refresh prompt is skipped.

You can pre-seed Git values:

```bash
DOTFILES_NONINTERACTIVE=1 \
GIT_USER_NAME="Your Name" \
GIT_USER_EMAIL="you@example.com" \
GIT_USER_SIGNINGKEY="" \
./setup.sh
```

Set `GIT_USER_SIGNINGKEY=""` to explicitly disable signing in local config.

Note: this repository has personal fallback Git defaults in `setup.sh`; override with `GIT_USER_*` (or `DEFAULT_GIT_*` in your fork).

## Optional Casks

Optional GUI tools are controlled by env vars and persisted to `~/.config/dotfiles/brew-optional.env`.

- `BREW_INSTALL_ANTIGRAVITY`
- `BREW_INSTALL_VIRTUALBOX`
- `BREW_INSTALL_BRAVE_BROWSER`
- `BREW_INSTALL_VLC`
- `BREW_INSTALL_SPOTIFY`

Homebrew bundle equivalents are mirrored to `HOMEBREW_BUNDLE_INSTALL_*` automatically.

## Post-Install Verification

```bash
source ~/.zshrc
make doctor
make status
mise list
```
