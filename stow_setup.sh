#!/bin/bash

# ============================================
# GNU Stow Setup Script
# Manages symlinks for dotfiles
# ============================================

set -e  # Exit on error

echo "🔗 Setting up dotfiles with GNU Stow..."

# Check if stow is installed
if ! command -v stow &> /dev/null; then
  echo "❌ GNU Stow not found. Please run 'brew bundle install' first."
  exit 1
fi

# Navigate to dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "❌ Dotfiles directory not found at $DOTFILES_DIR"
  echo "Creating symbolic link from $(pwd) to $DOTFILES_DIR..."
  ln -s "$(pwd)" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# ============================================
# Backup existing configs
# ============================================

backup_if_exists() {
  local file=$1
  if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
    echo "📦 Backing up existing $file to ${file}.backup"
    mv "$file" "${file}.backup"
  fi
}

# Backup existing configs before symlinking
backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.gitconfig"
backup_if_exists "$HOME/.npmrc"
backup_if_exists "$HOME/.mise.toml"

# ============================================
# Stow packages
# ============================================

echo ""
echo "📂 Stowing configuration packages..."

# Array of packages to stow
PACKAGES=(
  "zsh"
  "git"
  "npm"
  "mise"
  "starship"
  "ssh"
  "gpg"
)

# Stow each package
for package in "${PACKAGES[@]}"; do
  if [[ -d "$package" ]]; then
    echo "  ✓ Stowing $package..."
    stow -v "$package" --target="$HOME" --restow
  else
    echo "  ⚠️  Package directory '$package' not found, skipping..."
  fi
done

echo ""
echo "✅ Stow setup complete!"
echo ""
echo "Symlinks created:"
echo "  ~/.zshrc -> $DOTFILES_DIR/zsh/.zshrc"
echo "  ~/.gitconfig -> $DOTFILES_DIR/git/.gitconfig"
echo "  ~/.npmrc -> $DOTFILES_DIR/npm/.npmrc"
echo "  ~/.mise.toml -> $DOTFILES_DIR/mise/.mise.toml"
echo "  ~/.config/starship.toml -> $DOTFILES_DIR/starship/.config/starship.toml"
echo "  ~/.ssh/config -> $DOTFILES_DIR/ssh/.ssh/config"
echo "  ~/.gnupg/gpg.conf -> $DOTFILES_DIR/gpg/.gnupg/gpg.conf"
echo "  ~/.gnupg/gpg-agent.conf -> $DOTFILES_DIR/gpg/.gnupg/gpg-agent.conf"

echo ""
echo "⚠️  Security Note:"
echo "  Private keys are NOT stowed for security reasons."
echo "  SSH: ssh-keygen -t ed25519 -C 'your_email@example.com'"
echo "  GPG: gpg --full-generate-key"
echo "  Create directories: mkdir -p ~/.ssh/sockets ~/.gnupg && chmod 700 ~/.ssh ~/.gnupg"
echo ""
echo "🔐 Keychain Integration:"
echo "  Git credentials: Stored securely in macOS Keychain (osxkeychain)"
echo "  GPG passphrases: Managed by pinentry-mac with Keychain"
echo "  Restart GPG agent: gpgconf --kill gpg-agent"
echo ""
echo "To add more configurations:"
echo "  1. Create a directory in $DOTFILES_DIR (e.g., 'git')"
echo "  2. Add your config files (e.g., 'git/.gitconfig')"
echo "  3. Run: stow git"
echo ""
echo "To remove symlinks:"
echo "  stow -D <package-name>"
echo ""
