#!/bin/bash
# bootstrap.sh - Dotfiles setup bootstrap script
# Usage: curl -fsSL https://raw.githubusercontent.com/attaradev/dotfiles/main/bootstrap.sh | sh

set -e

DOTFILES_DIR="${HOME}/.dotfiles"
REPO_URL="https://github.com/attaradev/dotfiles.git"

echo "🚀 Bootstrapping dotfiles setup..."

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Error: git is not installed. Please install git first."
    exit 1
fi

# Clone repository if it doesn't exist
if [ -d "$DOTFILES_DIR" ]; then
    echo "📁 Dotfiles directory already exists at $DOTFILES_DIR"
    cd "$DOTFILES_DIR"
    echo "🔄 Pulling latest changes..."
    git pull origin main || {
        echo "⚠️  Warning: Could not pull latest changes. Continuing with existing files..."
    }
else
    echo "📦 Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

# Make setup script executable
chmod +x stow_setup.sh

# Run the setup script
echo "⚙️  Running setup script..."
./stow_setup.sh

echo ""
echo "✅ Bootstrap complete!"
echo "💡 To reload your shell configuration, run: exec $SHELL"
