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

# ============================================
# Stow packages
# ============================================

echo ""
echo "📂 Stowing configuration packages..."

# Array of packages to stow
PACKAGES=(
  "zsh"
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
echo ""
echo "To add more configurations:"
echo "  1. Create a directory in $DOTFILES_DIR (e.g., 'git')"
echo "  2. Add your config files (e.g., 'git/.gitconfig')"
echo "  3. Run: stow git"
echo ""
echo "To remove symlinks:"
echo "  stow -D <package-name>"
echo ""
