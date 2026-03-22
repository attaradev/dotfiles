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
- **Dotfiles** — symlinks managed by GNU Stow for the packages listed in `scripts/stow-packages.txt`
- **Obsidian** — knowledge vault scaffold, pinned community plugins with SHA-256 verification, and `~/Knowledge` alias
- **GPG** — `gpg-agent.conf` and `gpg.conf` with `pinentry-mac`, non-destructive (preserves existing local values)
- **VSCode** — extensions installed when the `code` CLI is present (skippable)
- **Claude Code** — global context and settings at `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, and tracked skills under `~/.claude/skills`
- **Codex CLI** — defaults at `~/.codex/config.toml`, instructions at `~/.codex/AGENTS.md`, and tracked skills under `~/.codex/skills`

## Managed Runtime and Tooling Tracks

Tracked defaults live in `mise/.mise.toml` and are documented in [docs/RUNTIMES.md](docs/RUNTIMES.md), while your local active configuration is `~/.mise.toml`.

Add additional runtimes by editing `~/.mise.toml` with the track you want, then rerun `make mise`.

## Common Commands

Run `make help` when you need the full target catalog. Practical workflows include:

```bash
make install        # Full setup
make update         # Update Homebrew and mise-managed packages
make stow           # Apply dotfile symlinks with GNU Stow
make obsidian       # Ensure the Knowledge vault and plugins are configured
make check          # Run lint + local quality checks
```

`make update` refreshes both Homebrew and mise-managed tooling; for Homebrew-only upgrades use the `brewup` helper defined in `zsh/.zshrc`.

Update Obsidian plugins safely by running `make obsidian-lock`, reviewing `obsidian/community-plugin-lock.json`, then re-running `make obsidian`. Prune stale plugin directories with `make obsidian-clean`.

## Documentation

- Installation details: [docs/INSTALL.md](docs/INSTALL.md)
- Runtime management: [docs/RUNTIMES.md](docs/RUNTIMES.md)
- Day-2 operations: [docs/OPERATIONS.md](docs/OPERATIONS.md)
- Customization guide: [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md)
- Troubleshooting: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- Security model and practices: [SECURITY.md](SECURITY.md)

## License

MIT ([LICENSE](LICENSE))
