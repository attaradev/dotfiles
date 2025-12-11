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

# Navigate to dotfiles directory (script location)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.dotfiles"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "🔗 Creating symlink $TARGET_DIR -> $DOTFILES_DIR"
  ln -s "$DOTFILES_DIR" "$TARGET_DIR"
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
backup_if_exists "$HOME/.ssh/config"

# Ensure secure directories exist before stowing SSH/GPG configs
ensure_secure_dir() {
  local dir=$1
  local mode=$2

  if [[ -L "$dir" && ! -d "$dir" ]]; then
    echo "⚠️  $dir exists as a symlink that is not a directory; skipping."
    return
  fi

  if [[ -e "$dir" && ! -d "$dir" ]]; then
    echo "⚠️  $dir exists but is not a directory; skipping."
    return
  fi

  if [[ ! -d "$dir" ]]; then
    echo "📁 Creating $dir"
    mkdir -p "$dir"
  fi

  chmod "$mode" "$dir"
}

if [[ -d "$DOTFILES_DIR/ssh" ]]; then
  ensure_secure_dir "$HOME/.ssh" 700
  ensure_secure_dir "$HOME/.ssh/sockets" 700
fi

if [[ -d "$DOTFILES_DIR/gpg" ]]; then
  ensure_secure_dir "$HOME/.gnupg" 700
  backup_if_exists "$HOME/.gnupg/gpg-agent.conf"
  backup_if_exists "$HOME/.gnupg/gpg.conf"
fi

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

STOWED=()
SKIPPED=()

# Stow each package
for package in "${PACKAGES[@]}"; do
  if [[ -d "$DOTFILES_DIR/$package" ]]; then
    echo "  ✓ Stowing $package..."
    stow -v "$package" --target="$HOME" --restow
    STOWED+=("$package")
  else
    echo "  ⚠️  Package directory '$package' not found in $DOTFILES_DIR, skipping..."
    SKIPPED+=("$package")
  fi
done

echo ""
echo "✅ Stow setup complete!"
echo "  (Existing dotfiles are backed up to <file>.backup when replaced.)"
if [[ ${#STOWED[@]} -gt 0 ]]; then
  echo ""
  echo "Symlinks created:"
  for package in "${STOWED[@]}"; do
    case "$package" in
      zsh)      echo "  ~/.zshrc -> $DOTFILES_DIR/zsh/.zshrc" ;;
      git)      echo "  ~/.gitconfig -> $DOTFILES_DIR/git/.gitconfig" ;;
      npm)      echo "  ~/.npmrc -> $DOTFILES_DIR/npm/.npmrc" ;;
      mise)     echo "  ~/.mise.toml -> $DOTFILES_DIR/mise/.mise.toml" ;;
      starship) echo "  ~/.config/starship.toml -> $DOTFILES_DIR/starship/.config/starship.toml" ;;
      ssh)      echo "  ~/.ssh/config -> $DOTFILES_DIR/ssh/.ssh/config" ;;
      gpg)      echo "  ~/.gnupg/gpg.conf -> $DOTFILES_DIR/gpg/.gnupg/gpg.conf"; echo "  ~/.gnupg/gpg-agent.conf -> $DOTFILES_DIR/gpg/.gnupg/gpg-agent.conf" ;;
    esac
  done
fi
if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo ""
  echo "Skipped (not found in $DOTFILES_DIR): ${SKIPPED[*]}"
fi

echo ""
echo "⚠️  Security Note:"
echo "  Private keys are NOT stowed for security reasons."
echo "  SSH: ssh-keygen -t ed25519 -C 'your_email@example.com'"
echo "  GPG: gpg --full-generate-key"
echo "  Directories secured: ~/.ssh, ~/.ssh/sockets, ~/.gnupg (chmod 700)"
echo ""
echo "🔐 Keychain Integration:"
echo "  Git credentials: Stored in macOS Keychain (osxkeychain)"
echo "  GPG passphrases: pinentry-mac (resolved via PATH for /opt/homebrew and /usr/local)"
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
