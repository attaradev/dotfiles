#!/bin/bash

echo "🔧 Starting system setup..."

# Run Homebrew setup
if [ -x ./brew.sh ]; then
  echo "📦 Running brew.sh..."
  ./brew.sh
else
  echo "❌ brew.sh not found or not executable."
fi

# Run NVM setup
if [ -x ./install_nvm.sh ]; then
  echo "📦 Running install_nvm.sh..."
  ./install_nvm.sh
else
  echo "❌ install_nvm.sh not found or not executable."
fi

# Run VSCode setup
if [ -x ./vscode_setup.sh ]; then
  echo "📦 Running vscode_setup.sh..."
  ./vscode_setup.sh
else
  echo "❌ vscode_setup.sh not found or not executable."
fi

# Autoload the shell profile
echo "🔄 Sourcing shell profile to apply changes..."

# Detect the shell (zsh or bash)
SHELL_PROFILE="$HOME/.zshrc"
if [ -n "$BASH_VERSION" ]; then
  SHELL_PROFILE="$HOME/.bashrc"
fi

# Check if profile exists before sourcing
if [ -f "$SHELL_PROFILE" ]; then
  source "$SHELL_PROFILE"
  echo "✔️ Sourced $SHELL_PROFILE successfully."
else
  echo "❌ $SHELL_PROFILE not found. Please source manually."
fi

echo "✅ Setup complete!"
