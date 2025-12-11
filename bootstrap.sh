#!/bin/bash
# bootstrap.sh - Dotfiles setup bootstrap script
# Usage: curl -fsSL https://raw.githubusercontent.com/attaradev/dotfiles/main/bootstrap.sh | sh

set -e

DOTFILES_DIR="${HOME}/.dotfiles"
REPO_URL="https://github.com/attaradev/dotfiles.git"

echo "🚀 Bootstrapping dotfiles setup..."

# Ensure Xcode Command Line Tools are present before proceeding
if ! xcode-select -p >/dev/null 2>&1; then
    echo "⚙️  Installing Xcode Command Line Tools (required for git/Homebrew)..."
    xcode-select --install || true
    echo "➡️  Re-run this bootstrap after the tools finish installing."
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Error: git is not installed. Please install git first."
    exit 1
fi

# Clone repository if it doesn't exist; otherwise update it
if [ -d "$DOTFILES_DIR" ]; then
    echo "📁 Dotfiles directory already exists at $DOTFILES_DIR"
    if [ -d "$DOTFILES_DIR/.git" ]; then
        echo "🔄 Pulling latest changes..."
        git -C "$DOTFILES_DIR" pull --ff-only origin main || {
            echo "⚠️  Warning: Could not pull latest changes. Continuing with existing files..."
        }
        cd "$DOTFILES_DIR"
    else
        echo "⚠️  $DOTFILES_DIR exists but is not a git repository. Remove or rename it, then rerun."
        exit 1
    fi
else
    echo "📦 Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

# Make scripts executable
chmod +x *.sh

# Run full setup (Homebrew, Brewfile, mise, stow, GPG, VSCode)
echo "⚙️  Running full setup..."
./setup.sh

echo ""
echo "✅ Bootstrap complete!"
echo "💡 To reload your shell configuration, run: exec $SHELL"
