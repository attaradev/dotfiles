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

### 2. Run the setup script

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

```bash
# Install and use Node.js LTS globally
mise use node@lts

# Install Python 3.12 for current project
mise use python@3.12

# Install Ruby 3.2
mise use ruby@3.2

# List all available versions for a tool
mise ls-remote node
mise ls-remote python

# Show currently installed versions
mise list

# Upgrade tools to latest versions
mise upgrade node@lts
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
| `ls` | **eza** | Modern replacement with Git status, icons, tree views, and colors |
| `cat` | **bat** | File viewer with syntax highlighting, line numbers, and Git integration |
| `find` | **fd** | Intuitive alternative with smart case-sensitivity and `.gitignore` awareness |
| `grep` | **ripgrep** | Blazing-fast recursive search, respects `.gitignore` by default |
| `cd` | **zoxide** | Smart directory jumper that learns your habits (use `z` to jump) |
| - | **fzf** | Interactive fuzzy finder for files, history, and more (Ctrl+R, Ctrl+T) |
| - | **starship** | Minimal, fast cross-shell prompt with Git, languages, and execution time |
| - | **tldr** | Simplified, practical command examples (better than man pages) |
| - | **jq** | Command-line JSON processor for parsing and manipulating JSON data |

### Shell Configuration

A carefully tuned ZSH setup optimized for speed and developer productivity, using **Starship** instead of Oh My Zsh.

**Why Starship over Oh My Zsh?**

This setup intentionally uses Starship rather than Oh My Zsh (with Powerlevel10k) for these reasons:

- ⚡ **Performance** - Starship renders in <1ms vs 50-200ms for Powerlevel10k. Zero startup lag
- 🦀 **Built in Rust** - Single compiled binary, no shell script overhead
- 🔌 **Minimal footprint** - ~2MB vs OMZ's ~200MB with themes/plugins
- 🎯 **Purpose-built** - Does one thing (prompts) exceptionally well
- 🔧 **Simple configuration** - Single TOML file vs complex OMZ/P10k wizard
- 🌍 **Cross-shell** - Same config for ZSH, Bash, Fish, etc.
- 📦 **Standalone plugins** - Use only what you need via Homebrew (autosuggestions, syntax highlighting)

That said, Oh My Zsh is excellent if you prefer an all-in-one framework with extensive plugins and community themes!

**Starship Prompt:**

- ⚡ **Lightning fast** - Written in Rust, renders instantly (<1ms)
- 🎨 **Minimal and clean** - Shows only relevant information (Git branch, status, language versions)
- 🔋 **Context-aware** - Automatically detects and displays Node, Python, Go, Ruby, AWS, Docker context
- ⏱️ **Execution time** - Shows how long commands took to run
- ✨ **Cross-shell** - Same config works in ZSH, Bash, Fish, PowerShell
- 🎯 **Git integration** - Branch name, status indicators, stash count, ahead/behind commits

**ZSH Plugins (via Homebrew):**

- **zsh-autosuggestions** - Fish-style command suggestions based on your history
  - Async mode enabled for zero performance impact
  - Combines both history and completion strategies
  - Accept suggestions with → (right arrow)
- **zsh-syntax-highlighting** - Real-time command syntax highlighting (green=valid, red=invalid)
- **zsh-completions** - 200+ additional completion definitions for Docker, Git, npm, etc.

**Performance Optimizations:**

- ⚡ Fast startup time (<100ms)
- 🔄 Async plugin loading where supported
- 💤 Lazy initialization of mise and heavy tools
- 📦 Minimal plugin footprint (no framework overhead)
- 🎯 Optimized for daily development workflow

### Dotfile Management with GNU Stow

**GNU Stow** creates and manages symlinks from `~/.dotfiles` to your home directory, keeping your configurations organized and version-controlled. No more scattered config files!

```bash
# Create symlinks for all ZSH configs (automatically backs up existing files)
cd ~/.dotfiles
stow zsh

# Add more configurations (example: Git config)
mkdir -p git
echo "[user]" > git/.gitconfig
stow git

# Remove symlinks if needed
stow -D zsh

# Re-apply symlinks (useful after editing configs)
stow --restow zsh
```

**How it works:**

- Keeps all dotfiles organized in `~/.dotfiles/`
- Creates symlinks from `~/.dotfiles/zsh/.zshrc` → `~/.zshrc`
- Easy to version control in Git
- Automatically backs up existing files before creating symlinks
- Portable across machines - just clone and stow

### GnuPG (GPG) Setup

**GnuPG** provides secure encryption and digital signatures for communications and Git commits. Automatically configured with macOS-native integration.

**Pre-configured Features:**

- 🔐 **pinentry-mac** - Native macOS dialog for secure passphrase entry (no terminal prompts)
- 🔒 **Strong encryption** - AES256 cipher, SHA512 digest for maximum security
- ✍️ **Git commit signing** - Sign commits to prove authorship and prevent tampering
- 🔑 **Long key IDs** - Uses secure long format for key identification
- 📋 **Clipboard integration** - Easy key export with `pbcopy` for GitHub/GitLab

**Quick Start:**

```bash
# Generate a new GPG key
gpg --full-generate-key

# List your keys
gpg --list-secret-keys --keyid-format LONG

# Configure Git to sign commits
git config --global user.signingkey <YOUR_KEY_ID>
git config --global commit.gpgsign true

# Export public key for GitHub/GitLab (copies to clipboard)
gpg --armor --export <YOUR_KEY_ID> | pbcopy
```

**Useful Commands:**

- `gpg --list-keys` - List all public keys
- `gpg --edit-key <KEY_ID>` - Edit key (change expiry, add email, etc.)
- `gpg --delete-secret-key <KEY_ID>` - Delete a private key
- `echo 'test' | gpg --clearsign` - Test GPG signing

---

## 🎨 Customization

This setup reflects my personal preferences for development tools and workflows. You're encouraged to customize it to match your own needs!

### Add More Packages

Edit [Brewfile](Brewfile) to add your preferred packages:

```ruby
# CLI tools
brew "neovim"
brew "htop"

# GUI applications
cask "firefox"
cask "iterm2"

# Mac App Store apps (requires 'mas')
mas "Xcode", id: 497799835
```

Then run:

```bash
brew bundle install
```

### Add More VSCode Extensions

The included extensions are what I use daily. Edit [vscode_setup.sh](vscode_setup.sh) to add your preferred extensions:

```bash
EXTENSIONS=(
  # Add your preferred extensions here
  bradlc.vscode-tailwindcss
  GraphQL.vscode-graphql
  # ... more extensions
)
```

**Tip:** Consider using VSCode's built-in Settings Sync for automatic synchronization across your machines.

### Customize Shell Configuration

The ZSH configuration includes my preferred aliases and settings. Edit [zsh/.zshrc](zsh/.zshrc) to customize:

- **Aliases** - Modify or add your own command shortcuts
- **Functions** - Add custom shell functions
- **Environment variables** - Set your project paths and API keys
- **Plugin configurations** - Tune plugin behavior to your liking

For machine-specific or private settings, create `~/.zshrc.local` (automatically gitignored):

```bash
# ~/.zshrc.local - This file is never committed to Git
export API_KEY="your-secret-key"
export WORK_DIR="$HOME/MyProjects"
alias work="cd $WORK_DIR"
alias personalproject="cd $HOME/Code/personal"
```

### Add More Dotfiles

To add more configurations (git, vim, tmux, etc.):

```bash
# Create a directory in ~/.dotfiles
mkdir -p ~/.dotfiles/git

# Add your config files
cp ~/.gitconfig ~/.dotfiles/git/.gitconfig

# Stow it
cd ~/.dotfiles
stow git
```

---

## 💡 Tips & Tricks

### Modern CLI Usage

```bash
# Use eza instead of ls
ls              # Lists files with icons
ll              # Long format with git status
tree            # Tree view with icons

# Use bat instead of cat
cat script.js   # Syntax-highlighted output

# Use zoxide for smart navigation
z dotfiles      # Jump to dotfiles directory
z doc           # Jump to most frecent "doc" directory

# Use fzf for fuzzy finding
Ctrl+R          # Search command history
Ctrl+T          # Search files
```

### Useful Aliases

Pre-configured in [zsh/.zshrc](zsh/.zshrc):

```bash
# Git aliases
g='git'
gs='git status'
ga='git add'
gc='git commit'
gp='git push'
gl='git log --oneline --graph'

# Homebrew
brewup='brew update && brew upgrade && brew cleanup'
brewdump='brew bundle dump --force --describe --file=~/.dotfiles/Brewfile'

# Navigation
..='cd ..'
...='cd ../..'
dotfiles='cd ~/.dotfiles'

# Utilities
reload='source ~/.zshrc'
c='code .'
```

### mise Power Features

```bash
# Install specific versions
mise use node@20.10.0
mise use python@3.12.1

# Per-project versions
cd myproject
mise use node@18        # Creates .mise.toml
mise use python@3.11

# Set global defaults
mise use --global node@lts
mise use --global python@3.12

# Environment variables per project
echo 'MY_VAR=value' >> .mise.toml
```

---

## 🔧 Maintenance

### Update Everything

```bash
# Update Homebrew packages
brewup  # Or: brew update && brew upgrade && brew cleanup

# Update mise
brew upgrade mise

# Update mise tools
mise upgrade node@lts
mise upgrade python@latest

# Regenerate Brewfile from current state
brewdump  # Or: brew bundle dump --force --describe
```

### Backup Current Setup

```bash
# Backup Brewfile
brew bundle dump --force --describe --file=~/Brewfile.backup

# List all installed packages
brew list > ~/brew-packages.txt
brew list --cask > ~/brew-casks.txt
```

---

## 💡 Troubleshooting

### mise not found after installation

Restart your terminal or run:

```bash
source ~/.zshrc
```

### VSCode CLI not working

Install the VSCode CLI:

1. Open VSCode
2. Press `Cmd+Shift+P`
3. Type "Shell Command: Install 'code' command in PATH"
4. Press Enter

### Stow conflicts with existing files

Backup existing files:

```bash
mv ~/.zshrc ~/.zshrc.backup
```

Then re-run:

```bash
cd ~/.dotfiles
stow zsh
```

### Homebrew installation fails

Check Homebrew health:

```bash
brew doctor
```

Update Homebrew:

```bash
brew update
```

### Permission issues

Ensure scripts are executable:

```bash
chmod +x setup.sh install_mise.sh stow_setup.sh vscode_setup.sh
```

---

## 📚 Additional Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [mise Documentation](https://mise.jdx.dev/)
- [GNU Stow Documentation](https://www.gnu.org/software/stow/)
- [Starship Documentation](https://starship.rs/)
- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)

---

## 🤝 Sharing & Contributing

This is my personal dotfiles setup, but I'm always learning and improving! I'd love to hear about your workflows, tools, and productivity tips.

**Using This Setup:**

- Fork this repository to create your own version
- Customize the tools, aliases, and configurations to match your workflow
- Keep your fork updated with your preferences
- Share your customizations—I'd love to see what works for you!

**Share Your Productivity Tips:**

I'm constantly looking to improve my workflow and efficiency. Please share:

- **Tools you love** - What developer tools or CLI utilities have transformed your workflow?
- **Productivity hacks** - Any aliases, scripts, or configurations that save you time?
- **Workflow improvements** - How do you optimize your development environment?
- **Modern alternatives** - Found a better tool than what's listed here? Let me know!

Open an issue or discussion to share your recommendations—I'm always eager to learn from the community!

**Contributing Improvements:**

Found bugs or have suggestions? Contributions are welcome:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Make your changes
4. Submit a pull request with a clear description

**Note:** While I may not adopt every suggestion (personal preferences vary!), I genuinely value your input and learn from every contribution. For major customizations, consider maintaining your own fork.

---

## ⚡ License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## 📞 Support

For issues or questions:

- Open an [Issue](https://github.com/attaradev/dotfiles/issues)
- Check the [Troubleshooting](#-troubleshooting) section

---

---

**About This Setup:**

This dotfiles repository represents my personal preferences built over years of macOS development. It emphasizes performance, modern tooling, and developer productivity. While it works great for me, your ideal setup might be different—and that's perfectly fine! Use this as inspiration, fork it, customize it, and make it your own.

Made with ❤️ for the developer community
