#!/bin/bash

# ============================================
# mise Setup Script
# Unified version manager for Node.js, Python, Ruby, and more
# ============================================

set -e  # Exit on error

echo "🔧 Setting up mise (unified version manager)..."

# Check if mise is already installed
if command -v mise &> /dev/null; then
  echo "✓ mise is already installed ($(mise --version))"
else
  echo "❌ mise not found. Please run 'brew bundle install' first to install mise."
  exit 1
fi

# ============================================
# Configure Shell Integration
# ============================================

ZSHRC="$HOME/.zshrc"
BASHRC="$HOME/.bashrc"

# Add mise to .zshrc if not already present
if [[ -f "$ZSHRC" ]]; then
  if ! grep -q 'mise activate' "$ZSHRC"; then
    echo "" >> "$ZSHRC"
    echo "# mise (unified version manager)" >> "$ZSHRC"
    echo 'eval "$(mise activate zsh)"' >> "$ZSHRC"
    echo "✓ Added mise to ~/.zshrc"
  else
    echo "✓ mise already configured in ~/.zshrc"
  fi
fi

# Add mise to .bashrc if not already present
if [[ -f "$BASHRC" ]]; then
  if ! grep -q 'mise activate' "$BASHRC"; then
    echo "" >> "$BASHRC"
    echo "# mise (unified version manager)" >> "$BASHRC"
    echo 'eval "$(mise activate bash)"' >> "$BASHRC"
    echo "✓ Added mise to ~/.bashrc"
  else
    echo "✓ mise already configured in ~/.bashrc"
  fi
fi

# ============================================
# Install Default Language Runtimes
# ============================================

echo ""
echo "📦 Installing default language runtimes..."

# Activate mise in current shell
eval "$(mise activate bash 2>/dev/null || mise activate zsh 2>/dev/null || true)"

# Install Node.js LTS
echo ""
echo "📥 Installing Node.js LTS..."
if mise list node 2>/dev/null | grep -q "lts"; then
  echo "✓ Node.js LTS already installed"
else
  mise use --global node@lts
  echo "✓ Node.js LTS installed and set as global default"
fi

# Install Python latest stable
echo ""
echo "📥 Installing Python latest..."
if mise list python 2>/dev/null | grep -q "3"; then
  echo "✓ Python already installed"
else
  mise use --global python@latest
  echo "✓ Python latest installed and set as global default"
fi

# Install Go latest
echo ""
echo "📥 Installing Go latest..."
if mise list go 2>/dev/null | grep -q "go"; then
  echo "✓ Go already installed"
else
  mise use --global go@latest
  echo "✓ Go latest installed and set as global default"
fi

# Install Ruby latest
echo ""
echo "📥 Installing Ruby latest..."
if mise list ruby 2>/dev/null | grep -q "ruby"; then
  echo "✓ Ruby already installed"
else
  mise use --global ruby@latest
  echo "✓ Ruby latest installed and set as global default"
fi

# Install pnpm (Node.js package manager)
echo ""
echo "📥 Installing pnpm..."
if mise list pnpm 2>/dev/null | grep -q "pnpm"; then
  echo "✓ pnpm already installed"
else
  mise use --global pnpm@latest
  echo "✓ pnpm latest installed and set as global default"
fi

# Show installed versions
echo ""
echo "📋 Current mise configuration:"
mise list

echo ""
echo "✅ mise setup complete!"
echo ""
echo "Installed runtimes:"
echo "  • Node.js LTS (includes npm)"
echo "  • Python latest"
echo "  • Go latest"
echo "  • Ruby latest"
echo "  • pnpm latest"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Verify installation: mise doctor"
echo "  3. Check versions: node -v && python --version && go version && ruby -v"
echo ""
echo "Common mise commands:"
echo "  mise use node@20      - Switch to Node.js 20"
echo "  mise use python@3.12  - Switch to Python 3.12"
echo "  mise list             - Show installed versions"
echo "  mise ls-remote node   - Show available Node versions"
echo "  mise upgrade          - Upgrade all tools to latest"
echo ""
