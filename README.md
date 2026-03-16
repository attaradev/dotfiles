<div align="center">
  <h1>💻 macOS Dev Environment</h1>

  [![Quality](https://github.com/attaradev/dotfiles/actions/workflows/quality.yml/badge.svg)](https://github.com/attaradev/dotfiles/actions/workflows/quality.yml)
  [![macOS](https://img.shields.io/badge/macOS-Apple%20Silicon%20%7C%20Intel-000000?logo=apple)](https://www.apple.com/macos/)
  [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
</div>

Personal macOS development environment focused on reproducible installs, security-conscious defaults, and fast daily workflows.

## Supported Platform

- macOS only (Apple Silicon and Intel)
- Default shell: `zsh`
- System package manager: Homebrew
- Runtime manager: `mise`
- Language package managers: `npm`, `pnpm`, `uv` (managed via `mise`)

## 5-Minute Setup

### 1. Install Xcode Command Line Tools (one time per machine)

```bash
xcode-select --install
```

### 2. Run bootstrap with Bash

```bash
curl -fsSL https://raw.githubusercontent.com/attaradev/dotfiles/main/bootstrap.sh | bash
```

Or clone first and run locally:

```bash
git clone https://github.com/attaradev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

Bootstrap is idempotent: rerunning it safely updates `~/.dotfiles` and reapplies setup.
If Homebrew is missing, `setup.sh` installs it automatically via the official installer.

Keep shareable defaults in this repo. Put machine-specific or secret customizations
in local override files such as `~/.gitconfig.local`, `~/.zshrc.local`,
`~/.npmrc.local`, and `~/.ssh/config.local`.

### 3. Verify setup

```bash
source ~/.zshrc
make doctor
mise list
```

## Manual Setup

```bash
git clone https://github.com/attaradev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

## Non-Interactive Setup (CI/headless)

Use `DOTFILES_NONINTERACTIVE=1` to disable interactive prompts and sudo credential refresh.

```bash
DOTFILES_NONINTERACTIVE=1 SKIP_VSCODE_EXTENSIONS=1 ./setup.sh
```

Skip Obsidian community plugin installation when needed:

```bash
DOTFILES_SETUP_OBSIDIAN_PLUGINS=0 ./setup.sh
```

Optional identity defaults for non-interactive runs:

```bash
DOTFILES_NONINTERACTIVE=1 \
GIT_USER_NAME="Your Name" \
GIT_USER_EMAIL="you@example.com" \
GIT_USER_SIGNINGKEY="" \
./setup.sh
```

This repo keeps personal fallback Git defaults in `setup.sh`; if you reuse/fork it, override with `GIT_USER_*` (or set `DEFAULT_GIT_*` in your fork).

## What This Configures

- **Homebrew** — packages and casks from `Brewfile`
- **Language runtimes** — Node.js, Python, Go, Ruby, npm, pnpm, uv via `mise`, sourced from `~/.mise.toml`
- **Dotfiles** — symlinks managed by GNU Stow (`zsh`, `git`, `npm`, `ssh`, `gpg`, `starship`, `claude`, `codex`)
- **Obsidian** — knowledge vault scaffold, pinned community plugins with SHA-256 verification, and `~/Knowledge` alias
- **GPG** — `gpg-agent.conf` and `gpg.conf` with `pinentry-mac`, non-destructive (preserves existing local values)
- **VSCode** — extensions installed when the `code` CLI is present (skippable)
- **Claude Code** — global context and settings at `~/.claude/CLAUDE.md` and `~/.claude/settings.json`
- **Codex CLI** — defaults at `~/.codex/config.toml` and instructions at `~/.codex/AGENTS.md`

## Managed Runtime and Tooling Tracks

- Core runtimes (tracked): Node.js `25`, Python `3.14`, Go `1.26`, Ruby `4.0`
- Package managers/tooling (tracked): npm `11`, pnpm `10`, uv `0.10`
- Add additional runtimes as needed by updating `~/.mise.toml` (for example, `java = "21"` or `rust = "1.93"`), then rerun `make mise`

For runtime policy and workflows, see [docs/RUNTIMES.md](docs/RUNTIMES.md).

## Common Commands

All `make` targets are defined in `~/.dotfiles/Makefile`. Run commands from `~/.dotfiles`, or run `make` with `-C ~/.dotfiles` from any directory.

```bash
make install        # Full setup
make setup          # Re-apply idempotent setup after pulling config changes
make update         # Upgrade brew + mise-managed packages
make doctor         # Health checks for Homebrew and mise
make mise           # Install runtimes from ~/.mise.toml (edit ~/.mise.toml to add/remove tools)
make stow           # Apply dotfile symlinks with GNU Stow
make agents         # Refresh Claude/Codex global config symlinks
make obsidian       # Setup vault + create ~/Knowledge alias + register in Obsidian UI + plugins
make obsidian-lock  # Refresh pinned Obsidian plugin lock (review diff before applying)
make obsidian-clean # Remove unmanaged Obsidian plugin directories
make gnupg          # Configure GnuPG and signing defaults
make vscode         # Install VSCode extensions
make backup         # Timestamped backup of key local config
make backup-list    # Show backup files/directories from setup scripts
make backup-clean   # Prompt to delete backups (or CONFIRM=1)
make check          # Local quality gate (shell/docs/local override checks)
make smoke          # Mocked smoke checks for setup + make wrapper paths
make dump           # Re-generate Brewfile from current system
make cleanup        # Remove packages not listed in Brewfile
```

`make update` is the repo-level maintenance path: it refreshes both Homebrew and
mise-managed tooling. For Homebrew-only work inside an interactive `zsh`
session, use `brewup [formula|cask]`; it asks for your password once up front,
then runs `brew upgrade --greedy` followed by `brew cleanup`.

To update Obsidian community plugins safely: run `make obsidian-lock`, review `obsidian/community-plugin-lock.json`, then run `make obsidian`.
To prune stale plugin directories not present in the lock file, run `make obsidian-clean`.

## Documentation

- Installation details: [docs/INSTALL.md](docs/INSTALL.md)
- Runtime management: [docs/RUNTIMES.md](docs/RUNTIMES.md)
- Day-2 operations: [docs/OPERATIONS.md](docs/OPERATIONS.md)
- Customization guide: [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md)
- Troubleshooting: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- Security model and practices: [SECURITY.md](SECURITY.md)

## License

MIT ([LICENSE](LICENSE))
