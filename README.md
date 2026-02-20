# Dotfiles Setup for macOS

Personal macOS development environment focused on reproducible installs, security-conscious defaults, and fast daily workflows.

## Supported Platform

- macOS only (Apple Silicon and Intel)
- Default shell: `zsh`
- Package manager: Homebrew

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

Optional identity defaults for non-interactive runs:

```bash
DOTFILES_NONINTERACTIVE=1 \
GIT_USER_NAME="Your Name" \
GIT_USER_EMAIL="you@example.com" \
GIT_USER_SIGNINGKEY="" \
./setup.sh
```

## What This Configures

- Homebrew packages and casks from `Brewfile`
- Language runtimes via `mise` (Node.js, Python, Go, Ruby, pnpm)
- Dotfile symlinks via GNU Stow
- GPG configuration with `pinentry-mac`
- VSCode extensions (when `code` CLI is present, unless skipped)

## Common Commands

```bash
make install      # Full setup
make update       # Upgrade brew + mise-managed tools
make doctor       # Health checks for Homebrew and mise
make backup       # Timestamped backup of key local config
make check        # Local quality gate (shell/docs/custom checks)
make dump         # Re-generate Brewfile from current system
make cleanup      # Remove packages not listed in Brewfile
```

## Documentation

- Installation details: [docs/INSTALL.md](docs/INSTALL.md)
- Day-2 operations: [docs/OPERATIONS.md](docs/OPERATIONS.md)
- Customization guide: [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md)
- Troubleshooting: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- Security model and practices: [SECURITY.md](SECURITY.md)

## License

MIT ([LICENSE](LICENSE))
