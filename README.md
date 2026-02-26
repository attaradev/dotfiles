# Dotfiles Setup for macOS

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

### 2. Run bootstrap with Bash (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/attaradev/dotfiles/main/bootstrap.sh | bash
```

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

- Homebrew packages and casks from `Brewfile`
- Language runtimes and tooling via `scripts/setup-mise.sh`, installed from tracked `mise/.mise.toml`
- Dotfile symlinks via `scripts/setup-stow.sh` (GNU Stow)
- Obsidian knowledge vault and plugin setup via `scripts/setup-obsidian.sh` (personal vault notes stay local in `~/.knowledge`; only public scaffolding is tracked)
- GPG configuration via `scripts/setup-gnupg.sh` with `pinentry-mac` and non-destructive defaults
- VSCode extensions via `scripts/setup-vscode.sh` (when `code` CLI is present, unless skipped)
- Claude Code global context/settings via `~/.claude/CLAUDE.md` and `~/.claude/settings.json`
- Codex CLI defaults/notifications via `~/.codex/config.toml` (Obsidian activity logging)
- Codex user instructions via `~/.codex/AGENTS.md` (tracked at `codex/.codex/AGENTS.md`)

## Managed Runtime and Tooling Tracks

- Core runtimes (tracked): Node.js `25`, Python `3.14`, Go `1.26`, Ruby `4.0`
- Package managers/tooling (tracked): npm `11`, pnpm `10`, uv `0.10`
- Add additional runtimes as needed by updating `mise/.mise.toml` (for example, Java `21` or Rust `1.93`) and rerunning `make mise`

For runtime policy and workflows, see [docs/RUNTIMES.md](docs/RUNTIMES.md).

## Common Commands

All `make` targets are defined in `~/.dotfiles/Makefile`. Run commands from `~/.dotfiles`, or run `make` with `-C ~/.dotfiles` from any directory.

```bash
make install      # Full setup
make update       # Upgrade brew + mise-managed tools
make doctor       # Health checks for Homebrew and mise
make mise         # Install runtimes from mise/.mise.toml
# Add tools in mise/.mise.toml as needed, then rerun make mise
make stow         # Apply dotfile symlinks with GNU Stow
make obsidian     # Configure knowledge vault defaults + install plugins
make gnupg        # Configure GnuPG and signing defaults
make vscode       # Install VSCode extensions
make backup       # Timestamped backup of key local config
make backup-list  # Show backup files/directories from setup scripts
make backup-clean # Prompt to delete backups (or CONFIRM=1)
make check        # Local quality gate (shell/docs/custom checks)
make smoke        # Mocked smoke checks for setup + make wrapper paths
make dump         # Re-generate Brewfile from current system
make cleanup      # Remove packages not listed in Brewfile
```

## Documentation

- Installation details: [docs/INSTALL.md](docs/INSTALL.md)
- Runtime management: [docs/RUNTIMES.md](docs/RUNTIMES.md)
- Day-2 operations: [docs/OPERATIONS.md](docs/OPERATIONS.md)
- Customization guide: [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md)
- Troubleshooting: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- Security model and practices: [SECURITY.md](SECURITY.md)

## License

MIT ([LICENSE](LICENSE))
