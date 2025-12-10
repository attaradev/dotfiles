# 🛠 Dotfiles Setup for macOS

> My personal macOS development environment setup with **security-first design**, performance-optimized configurations, modern CLI tools, and streamlined workflows. Built for developers who value both security and productivity.

## ✨ Highlights

- **🔐 Security First** - Keychain integration, GPG signing, hardened SSH, credential protection
- **📦 Declarative Package Management** - Single Brewfile for reproducible installs
- **⚡ Fast Version Management** - mise for Node.js, Python, Go, Ruby (20-100x faster than nvm/pyenv)
- **🔗 Smart Symlinks** - GNU Stow for organized, portable dotfile management
- **🎨 Modern CLI Tools** - eza, bat, fd, ripgrep, fzf, zoxide, starship
- **🛡️ Security Tools** - gitleaks, trivy, lynis, ssh-audit, git-crypt

## ⚙️ Quick Start

**Prerequisite:** Xcode Command Line Tools (once per machine)

```bash
xcode-select --install
```

**Tip:** Run `sudo -v` first (or let the installer do it) so you only enter your password once; the setup keeps the sudo session alive while installing Homebrew/casks.

### One-Line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/attaradev/dotfiles/main/bootstrap.sh | sh
```

This will clone the repository to `~/.dotfiles` and run the setup automatically.

### Manual Installation

#### 1. Clone the repository

```bash
git clone https://github.com/attaradev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

#### 2. Run the setup

##### Option A: Using Makefile (recommended)

```bash
make install
```

##### Option B: Using setup script directly

```bash
chmod +x stow_setup.sh
./stow_setup.sh
```

The setup installs Homebrew, packages, mise (Node/Python/Go/Ruby/pnpm), creates symlinks via GNU Stow, and configures GPG with Keychain integration.

### 3. Verify installation

```bash
source ~/.zshrc      # Or restart terminal
mise list            # Show installed tools
```

---

## 📂 Project Structure

```text
dotfiles/
├── Makefile              # Task shortcuts (install, update, backup)
├── Brewfile              # Declarative package list
├── setup.sh              # Main orchestration script
├── install_mise.sh       # Version manager setup
├── stow_setup.sh         # Symlink manager
├── setup_gnupg.sh        # GPG configuration
├── zsh/.zshrc            # Shell config + security
├── git/.gitconfig        # Git + Keychain + signing
├── npm/.npmrc            # npm config (tokens in .npmrc.local)
├── mise/.mise.toml       # Tool versions (Node, Python, Go, Ruby, pnpm)
├── starship/.config/starship.toml  # Prompt styling
├── ssh/.ssh/config       # SSH hardening
└── gpg/.gnupg/           # GPG + Keychain integration
```

## 🚀 What's Included

### Makefile Commands

```bash
make install          # Full setup (first time)
make update           # Update all packages and tools
make doctor           # Run health checks
make dump             # Generate Brewfile from system
make backup           # Backup current dotfiles
make help             # See all commands
```

### Package Management

**Brewfile** = declarative, version-controlled package management. One file, all packages. Core/cask taps are implicit—no manual tap commands required.

```bash
brew bundle install              # Install all
brew bundle dump --force         # Generate from system
brew bundle cleanup --force      # Remove unlisted
```

**TLDR pages** are provided via the maintained `tlrc` client; use the familiar `tldr <command>` syntax.

### Version Management with mise

**mise** = single tool replacing nvm/pyenv/rbenv. Rust-based, 20-100x faster, auto-switches versions per directory.

**Installed**: Node.js LTS, Python, Go, Ruby, pnpm
**Prereqs**: Xcode Command Line Tools + Homebrew `libyaml`/`openssl@3` (included in Brewfile) for Ruby builds

```bash
mise use --global node@lts       # Set global default
mise use python@3.12             # Project-specific version
mise ls-remote node              # List available versions
mise list                        # Show installed
mise upgrade                     # Update all
```

### Modern CLI Tools

Fast, user-friendly alternatives with smart defaults. Aliased in [zsh/.zshrc](zsh/.zshrc):

| Shortcut | Tool | Replaces |
|----------|------|----------|
| `l`, `ll`, `la` | **eza** | ls (with icons, Git status) |
| `cat` | **bat** | cat (syntax highlighting) |
| `tree` | **eza** | tree (with icons) |
| `z` | **zoxide** | cd (learns habits) |
| `f` | **fd** | find (gitignore-aware) |
| `rg` | **ripgrep** | grep (fast, smart) |
| `fzf` | **fzf** | Fuzzy finder (Ctrl+R, Ctrl+T) |

**Note:** Custom shortcuts avoid overriding system commands to prevent script conflicts.

### Shell Configuration

**Starship prompt** (<1ms rendering, Rust-based) + ZSH plugins for speed and productivity.

**Plugins**: autosuggestions, syntax-highlighting, completions
**Startup**: <100ms with async loading

### Dotfile Management with GNU Stow

Symlink manager: `~/.dotfiles` → home directory. Auto-backs up existing files.

**Packages**: zsh, git, npm, mise, starship, ssh, gpg

```bash
stow zsh              # Create symlinks
stow -D zsh           # Remove symlinks
stow --restow zsh     # Re-apply symlinks
```

### GnuPG (GPG) Setup

Encryption + Git signing with **Keychain integration** (Touch ID compatible).

**Config**: AES256/SHA512, 2h/8h cache, pinentry-mac

```bash
gpg --full-generate-key                        # Generate RSA 4096
gpg --list-secret-keys --keyid-format LONG     # List keys
gpg --armor --export <KEY_ID> | pbcopy         # Copy to GitHub
git commit --allow-empty -m "test" --gpg-sign  # Test signing
```

---

## 🎨 Customization

**Packages**: Edit [Brewfile](Brewfile) → `brew bundle install`

**Private settings**: Create `~/.zshrc.local` (never committed)

**Tool versions**: Edit [mise/.mise.toml](mise/.mise.toml)

**Add dotfiles**: Create dir → `stow <name>`

---

## 💡 Tips & Tricks

```bash
l / ll / la         # eza listing
z <dir>             # zoxide jump
f / rg <pattern>    # fd / ripgrep search
Ctrl+R              # fzf history
mise use node@20    # Set version
```

---

## 🔧 Maintenance

```bash
make update         # Update all
make doctor         # Health checks
make dump           # Regenerate Brewfile
```

---

## 🔒 Security

**Built-in**: GPG signing, SSH hardening (Ed25519, ChaCha20), Keychain integration, no hardcoded tokens

**Tools**: gitleaks, trivy, lynis, ssh-audit, git-crypt

**⚠️ Never commit**: SSH keys, GPG keys, tokens, `.env` files. Use `~/.npmrc.local` and `~/.zshrc.local` instead.

**Quick setup**:

```bash
ssh-keygen -t ed25519              # Generate key
chmod 600 ~/.ssh/id_ed25519        # Set permissions
gitleaks detect --source . -v      # Scan for secrets
```

**See [SECURITY.md](SECURITY.md) for complete documentation**

---

## 💡 Troubleshooting

- **mise not found**: `source ~/.zshrc` or restart terminal
- **Stow conflicts**: Backup existing file → re-run stow
- **Homebrew issues**: `brew doctor && brew update`

---

## 🤝 Sharing & Contributing

Fork, customize, and share what works! Found bugs or improvements? Submit PRs or open an [issue](https://github.com/attaradev/dotfiles/issues).

---

**Resources:** [Homebrew](https://docs.brew.sh/) · [mise](https://mise.jdx.dev/) · [Stow](https://www.gnu.org/software/stow/) · [Starship](https://starship.rs/) · [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)

**License:** MIT

---

*This setup reflects my personal preferences built over years of development on macOS. Your ideal setup may differ—use this as inspiration and make it your own!*

Made with ❤️ by Mike Attara

[![Website](https://img.shields.io/badge/Website-attara.dev-blue?style=for-the-badge&logo=google-chrome&logoColor=white)](https://attara.dev)
[![GitHub](https://img.shields.io/badge/GitHub-attaradev-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/attaradev)
[![Twitter](https://img.shields.io/badge/Twitter-@attaradev-1DA1F2?style=for-the-badge&logo=x&logoColor=white)](https://twitter.com/attaradev)
