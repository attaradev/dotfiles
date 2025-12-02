# 🛠 Dotfiles Setup for macOS

> My personal macOS development environment setup with performance-optimized configurations, modern CLI tools, and streamlined workflows. Feel free to fork and customize to your preferences!

This is my preferred setup for macOS development environments. You can use it as-is or as a starting point to build your own. The setup includes:

- **Homebrew Bundle** - Declarative package management through a single Brewfile for consistent installs
- **mise** - Fast, unified version manager supporting 300+ tools (Node.js, Python, Ruby, Go, etc.)
- **GNU Stow** - Elegant symlink management keeping your dotfiles organized and portable
- **Starship** - Minimal, blazing-fast cross-shell prompt with smart context awareness
- **Modern CLI tools** - Enhanced replacements: eza (ls), bat (cat), fd (find), ripgrep (grep), fzf, zoxide
- **VSCode** - Curated extension collection for Python, Go, TypeScript, Docker, Terraform, and AI tools

## ⚙️ Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/attaradev/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the setup

#### Option A: Using Makefile (recommended)

```bash
make install
```

#### Option B: Using setup script directly

```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:

1. ✅ Install Homebrew (macOS package manager, skipped if already present)
2. 📦 Install all packages, tools, and applications from the Brewfile
3. 🔧 Setup mise and install Node.js LTS by default
4. 🔗 Create symlinks for dotfiles using GNU Stow (backs up existing files)
5. 🔐 Configure GnuPG with pinentry-mac for Git commit signing
6. 🎨 Install VSCode extensions (optional, prompts before installing)

### 3. Restart your terminal

```bash
# Reload your shell configuration
source ~/.zshrc

# Or simply restart your terminal
```

### 4. Verify installation

```bash
brew doctor          # Check Homebrew health
mise doctor          # Check mise health
mise list            # Show installed versions
```

---

## 📂 Project Structure

```text
dotfiles/
├── Makefile              # Convenient shortcuts for common tasks
├── Brewfile              # Declarative Homebrew package list
├── setup.sh              # Main orchestration script
├── install_mise.sh       # mise version manager setup
├── stow_setup.sh         # GNU Stow symlink manager setup
├── setup_gnupg.sh        # GnuPG (GPG) configuration
├── vscode_setup.sh       # VSCode extensions installer
├── .stow-local-ignore    # Stow ignore patterns
├── .gitignore            # Git ignore patterns
└── zsh/
    └── .zshrc            # ZSH configuration with Starship prompt
```

## 🚀 What's Included

### Makefile Commands

**Convenient shortcuts** for managing your dotfiles. Run `make help` to see all available commands:

```bash
# Setup & Installation
make install          # Full setup (first time)
make brew             # Install packages from Brewfile
make mise             # Setup mise and language runtimes
make stow             # Create dotfile symlinks

# Updates & Maintenance
make update           # Update all packages and tools
make doctor           # Run health checks
make status           # Show system status

# Brewfile Management
make dump             # Generate Brewfile from system
make cleanup          # Remove unlisted packages

# Backup & Testing
make backup           # Backup current dotfiles
make test             # Test idempotency
```

**Benefits:**

- Single command for common operations
- No need to remember script names
- Built-in help documentation
- Safer operations with validation

### Package Management

**Brewfile** provides declarative, version-controlled package management. Instead of manually installing packages one by one, define everything in a single file:

```bash
# Install all packages defined in Brewfile
brew bundle install

# Generate Brewfile from currently installed packages
brew bundle dump --force --describe

# Remove packages not listed in Brewfile (cleanup unused packages)
brew bundle cleanup --force
```

**Benefits:**

- Reproducible setups across multiple machines
- Version-controlled package list in Git
- Easy to share and collaborate
- One command to install everything

### Version Management with mise

**mise** replaces nvm, pyenv, rbenv, and similar tools with a single, blazing-fast version manager written in Rust. It automatically detects and switches language versions based on your project directory.

**Default installations** (via [install_mise.sh](install_mise.sh)):

- Node.js LTS + npm
- Python latest
- Go latest
- Ruby latest
- pnpm (fast Node.js package manager)

```bash
# Install and use Node.js LTS globally
mise use --global node@lts

# Install Python 3.12 for current project
mise use python@3.12

# Install specific Go version
mise use go@1.21

# Install Ruby 3.2
mise use ruby@3.2

# List all available versions for a tool
mise ls-remote node
mise ls-remote python

# Show currently installed versions
mise list

# Upgrade tools to latest versions
mise upgrade
```

**Key Features:**

- ⚡ **Blazing fast** - Written in Rust, 20-100x faster than nvm/pyenv
- 🔄 **Auto-switching** - Automatically changes versions when you cd into project directories
- 🌍 **Universal support** - Manages 300+ tools: Node, Python, Ruby, Go, Java, PHP, Terraform, etc.
- 🔙 **Drop-in compatible** - Reads `.nvmrc`, `.node-version`, `.ruby-version`, `.python-version` files
- 🎯 **Environment variables** - Built-in support for per-project environment variables
- 📦 **Single binary** - One tool to replace nvm, pyenv, rbenv, goenv, and more
- 💾 **Project-local configs** - Each project can specify its own tool versions in `.mise.toml`

### Modern CLI Tools

Enhanced, faster, and more user-friendly alternatives to standard Unix tools. All are automatically aliased in [zsh/.zshrc](zsh/.zshrc):

| Command | Tool | Description |
|---------|------|-------------|
| `l` | **eza** | Quick listing with icons |
| `ll` | **eza** | Long format with Git status, icons, and file details |
| `la` | **eza** | Long format including hidden files |
| `cat` | **bat** | File viewer with syntax highlighting, line numbers, and Git integration |
| `tree` | **eza** | Tree view with icons |
| `z` | **zoxide** | Smart directory jumper that learns your habits |
| `f` | **fd** | Fast, user-friendly 'find' alternative with `.gitignore` awareness |
| `rg` | **ripgrep** | Blazing-fast recursive search, respects `.gitignore` by default |
| `ss` | **starship** | Shortcut for starship commands (config, prompt, etc.) |
| - | **fzf** | Interactive fuzzy finder for files, history, and more (Ctrl+R, Ctrl+T) |
| - | **tldr** | Simplified, practical command examples (better than man pages) |
| - | **jq** | Command-line JSON processor for parsing and manipulating JSON data |

**Note:** I use custom shortcuts rather than replacing system commands. This avoids conflicts with scripts or system tools that rely on the original commands.

### Shell Configuration

A carefully tuned ZSH setup optimized for speed and developer productivity, using **Starship**.

**Why Starship over Oh My Zsh?**

- ⚡ **Performance** - <1ms rendering vs 50-200ms for Powerlevel10k
- 🦀 **Rust binary** - ~2MB vs OMZ's ~200MB with themes/plugins
- 🎯 **Focused** - Single TOML config file, no complex wizard
- 🌍 **Universal** - Same config for ZSH, Bash, Fish, PowerShell
- 📦 **Modular** - Use only needed plugins via Homebrew

**Features:**

- 🎨 Minimal prompt showing Git status, language versions, execution time
- 🔋 Smart context detection (Node, Python, Go, Ruby, AWS, Docker)
- 📊 Branch status, stash count, ahead/behind commits

*Note: Oh My Zsh is excellent if you prefer an all-in-one framework!*

**ZSH Plugins:**

- **zsh-autosuggestions** - Fish-style suggestions (async, accept with →)
- **zsh-syntax-highlighting** - Real-time highlighting (green=valid, red=invalid)
- **zsh-completions** - 200+ definitions for Docker, Git, npm, etc.

**Performance:** <100ms startup, async plugin loading, lazy initialization

### Dotfile Management with GNU Stow

Manages symlinks from `~/.dotfiles` to your home directory. Version-controlled, portable, automatically backs up existing files.

```bash
cd ~/.dotfiles
stow zsh              # Create symlinks
stow -D zsh           # Remove symlinks
stow --restow zsh     # Re-apply symlinks
```

### GnuPG (GPG) Setup

Secure encryption and Git commit signing with macOS-native integration.

**Features:** pinentry-mac, AES256/SHA512 encryption, Git commit signing, clipboard integration

```bash
gpg --full-generate-key                        # Create key
gpg --list-secret-keys --keyid-format LONG     # List keys
git config --global user.signingkey <KEY_ID>   # Configure Git
git config --global commit.gpgsign true
gpg --armor --export <KEY_ID> | pbcopy         # Export to clipboard
```

---

## 🎨 Customization

Fork and customize to match your needs!

**Packages:** Edit [Brewfile](Brewfile), then run `brew bundle install`

**VSCode Extensions:** Edit [vscode_setup.sh](vscode_setup.sh) or use Settings Sync

**Shell Config:** Edit [zsh/.zshrc](zsh/.zshrc) or create `~/.zshrc.local` for private settings

```bash
# ~/.zshrc.local - Never committed to Git
export API_KEY="secret"
alias work="cd $HOME/Projects"
```

**More Dotfiles:** `mkdir ~/.dotfiles/git && stow git`

---

## 💡 Tips & Tricks

**CLI Usage:**

```bash
l                   # Quick eza listing with icons
ll                  # Long list with git status
tree                # Tree view with icons
z dotfiles          # Jump to directory
f pattern           # Fast file search with fd
rg pattern          # Fast content search with ripgrep
ss config           # Starship commands (config, prompt, etc.)
Ctrl+R              # Search history (fzf)
```

**Aliases:** `l`, `ll`, `la`, `f`, `rg`, `ss`, `g`, `gs`, `ga`, `gc`, `gp`, `gl`, `brewup`, `brewdump`, `..`, `reload`, `c`

**mise:**

```bash
mise use node@20                 # Specific version
mise use --global node@lts       # Global default
echo 'VAR=value' >> .mise.toml   # Per-project env vars
```

---

## 🔧 Maintenance

**Using Makefile (recommended):**

```bash
make update                      # Update all packages and tools
make doctor                      # Run health checks
make dump                        # Regenerate Brewfile
make status                      # Show system status
```

**Using shell aliases:**

```bash
brewup                           # Update Homebrew packages
mise upgrade                     # Update mise-managed tools
brewdump                         # Regenerate Brewfile
```

---

## 💡 Troubleshooting

**mise not found:** `source ~/.zshrc` or restart terminal

**VSCode CLI:** In VSCode: `Cmd+Shift+P` → "Shell Command: Install 'code' command in PATH"

**Stow conflicts:** `mv ~/.zshrc ~/.zshrc.backup` then re-run `stow zsh`

**Homebrew issues:** `brew doctor` and `brew update`

**Permissions:** `chmod +x *.sh`

---

## 🤝 Sharing & Contributing

I'm always learning! Share your workflows, tools, and productivity tips.

**Use This Setup:**

- Fork and customize to your needs
- Share what works for you!

**Share With Me:**

- Tools that transformed your workflow
- Time-saving aliases, scripts, configs
- Better alternatives to tools listed here

**Contribute:**

- Found bugs? Submit PRs!
- Fork for major customizations

Open an [issue](https://github.com/attaradev/dotfiles/issues) or discussion—I value your input!

---

**Resources:** [Homebrew](https://docs.brew.sh/) · [mise](https://mise.jdx.dev/) · [Stow](https://www.gnu.org/software/stow/) · [Starship](https://starship.rs/) · [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)

**License:** MIT

---

*This setup reflects my personal preferences built over years of development on macOS. Your ideal setup may differ—use this as inspiration and make it your own!*

Made with ❤️ for the developer community
