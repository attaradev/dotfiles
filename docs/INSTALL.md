# Installation

## Prerequisites

- macOS
- Xcode Command Line Tools

```bash
xcode-select --install
```

## Recommended Bootstrap (Bash)

Fast online bootstrap:

```bash
curl -fsSL https://raw.githubusercontent.com/attaradev/dotfiles/main/bootstrap.sh | bash
```

Or clone first and run locally:

```bash
git clone https://github.com/attaradev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

Bootstrap will clone to `~/.dotfiles` (or pull latest if already cloned) and run `./setup.sh`.
Bootstrap is idempotent and safe to rerun; it refreshes the repo and reapplies setup.
If Homebrew is missing, `setup.sh` installs it automatically via the official installer.
All `make` targets are defined in `~/.dotfiles/Makefile`; run them from `~/.dotfiles`, run `make -C ~/.dotfiles help` for the full catalog, or run `make help` from within the repo.

## Manual Installation

```bash
git clone https://github.com/attaradev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

`make install` runs:

1. Homebrew install/check
2. `brew bundle install`
3. Runtime and tooling setup via `mise` (bootstraps `~/.mise.toml` from template when missing)
4. Git identity setup (`~/.gitconfig.local`)
5. Dotfile symlinks via GNU Stow
6. Obsidian vault scaffold and community plugins with SHA-256 verification
7. GPG agent configuration with `pinentry-mac`
8. VSCode extensions (if `code` CLI is present)

After pulling later dotfile changes, run `make setup` to re-apply idempotent setup tasks without running package upgrades.

Runtime and tooling versions are sourced from local `~/.mise.toml` (created from `mise/.mise.toml` template when missing); see [RUNTIMES.md](RUNTIMES.md) for the tracked defaults and update workflows.

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

Skip Obsidian community plugin setup when needed:

```bash
DOTFILES_SETUP_OBSIDIAN_PLUGINS=0 ./setup.sh
```

Skip community plugin asset downloads while still writing plugin enablement JSON:

```bash
DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1 ./scripts/obsidian.sh setup
```

By default, already installed community plugins are not re-downloaded on reruns.
To re-check and re-apply versions pinned in `obsidian/community-plugin-lock.json`:

```bash
DOTFILES_OBSIDIAN_UPDATE_PLUGINS=1 make obsidian
```

To update plugin versions safely:

```bash
make obsidian-lock
# review obsidian/community-plugin-lock.json
make obsidian
```

If GitHub API limits are hit during lock refresh, set `GITHUB_TOKEN_FILE` to a
local file containing a token before running `make obsidian-lock`.

Note: this repository has personal fallback Git defaults in `setup.sh`; override with `GIT_USER_*` (or `DEFAULT_GIT_*` in your fork).

## Optional Casks

Optional GUI tools are controlled by env vars and persisted to `~/.config/dotfiles/brew-optional.env`.

- `BREW_INSTALL_ANTIGRAVITY`
- `BREW_INSTALL_UTM`
- `BREW_INSTALL_BRAVE_BROWSER`
- `BREW_INSTALL_VLC`
- `BREW_INSTALL_SPOTIFY`

Homebrew bundle equivalents are mirrored to `HOMEBREW_BUNDLE_INSTALL_*` automatically.

## Post-Install Verification

```bash
source ~/.zshrc
make doctor
make status

# Runtimes
mise list
node -v && npm -v && pnpm -v
python --version && uv --version
go version
ruby -v

# Dotfiles and vault
test -L ~/.zshrc && echo "zshrc symlinked"
test -L ~/Knowledge && echo "Knowledge alias present"
test -e ~/.knowledge/hub.md && echo "vault seeded"
test -e ~/.codex/config.toml && echo "codex config present"
```

For additional runtimes you added to `~/.mise.toml` (e.g. `java`, `rust`), verify with `java -version` or `rustc --version` after running `make mise`.
