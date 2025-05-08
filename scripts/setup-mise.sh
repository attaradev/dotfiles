#!/bin/bash

# ============================================
# mise Setup Script
# Unified version manager for Node.js, Python, Java, Rust, uv, Ruby, and more
# ============================================

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=./mutable-target.sh
source "$DOTFILES_DIR/scripts/mutable-target.sh"

normalize_bool() {
  case "${1:-}" in
    1|true|TRUE|yes|YES|on|ON) echo "1" ;;
    *) echo "0" ;;
  esac
}

DOTFILES_INSTALL_JAVA="$(normalize_bool "${DOTFILES_INSTALL_JAVA:-0}")"
DOTFILES_INSTALL_RUST="$(normalize_bool "${DOTFILES_INSTALL_RUST:-0}")"
export DOTFILES_INSTALL_JAVA DOTFILES_INSTALL_RUST

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

has_mise_activation() {
  local pattern="$1"
  shift
  local file

  for file in "$@"; do
    if [[ -f "$file" ]] && grep -q "$pattern" "$file"; then
      return 0
    fi
  done

  return 1
}

# Add mise to .zshrc if not already present
ZSHRC_TARGET=$(resolve_mutable_target "$ZSHRC" "$HOME/.zshrc.local" "$DOTFILES_DIR")
if [[ -f "$ZSHRC_TARGET" ]] || [[ "$ZSHRC_TARGET" == "$HOME/.zshrc.local" ]] || [[ "$ZSHRC_TARGET" == "$HOME/.zshrc" ]]; then
  touch "$ZSHRC_TARGET"
  if ! has_mise_activation 'mise activate zsh' "$ZSHRC" "$ZSHRC_TARGET"; then
    {
      echo ""
      echo "# mise (unified version manager)"
      echo 'eval "$(mise activate zsh)"'
    } >> "$ZSHRC_TARGET"
    echo "✓ Added mise to ${ZSHRC_TARGET/#$HOME/~}"
  else
    echo "✓ mise already configured in ${ZSHRC_TARGET/#$HOME/~}"
  fi
fi

# Add mise to .bashrc if not already present
BASHRC_TARGET=$(resolve_mutable_target "$BASHRC" "$HOME/.bashrc.local" "$DOTFILES_DIR")
if [[ -f "$BASHRC_TARGET" ]] || [[ "$BASHRC_TARGET" == "$HOME/.bashrc.local" ]] || [[ "$BASHRC_TARGET" == "$HOME/.bashrc" ]]; then
  touch "$BASHRC_TARGET"
  if ! has_mise_activation 'mise activate bash' "$BASHRC" "$BASHRC_TARGET"; then
    {
      echo ""
      echo "# mise (unified version manager)"
      echo 'eval "$(mise activate bash)"'
    } >> "$BASHRC_TARGET"
    echo "✓ Added mise to ${BASHRC_TARGET/#$HOME/~}"
  else
    echo "✓ mise already configured in ${BASHRC_TARGET/#$HOME/~}"
  fi
fi

# ============================================
# Install Default Language Runtimes
# ============================================

echo ""
echo "📦 Installing runtimes from tracked config (mise/.mise.toml)..."
echo "   Optional runtimes: Java=${DOTFILES_INSTALL_JAVA} Rust=${DOTFILES_INSTALL_RUST}"

INSTALL_TOOLS=(node python uv go ruby pnpm npm)

if [[ "$DOTFILES_INSTALL_JAVA" == "1" ]]; then
  INSTALL_TOOLS+=(java)
else
  echo "   - Skipping optional runtime: java (set DOTFILES_INSTALL_JAVA=1 to enable)"
fi

if [[ "$DOTFILES_INSTALL_RUST" == "1" ]]; then
  INSTALL_TOOLS+=(rust)
else
  echo "   - Skipping optional runtime: rust (set DOTFILES_INSTALL_RUST=1 to enable)"
fi

if [[ -f "$DOTFILES_DIR/mise/.mise.toml" ]]; then
  (
    cd "$DOTFILES_DIR/mise"

    # Ensure ruby-build picks up Homebrew libyaml/openssl paths for psych/openssl when Ruby is installed.
    LIBYAML_PREFIX="$(brew --prefix libyaml 2>/dev/null || true)"
    OPENSSL_PREFIX="$(brew --prefix openssl@3 2>/dev/null || true)"
    RUBY_CONFIGURE_OPTS_EXTRA=""
    [[ -n "$LIBYAML_PREFIX" ]] && RUBY_CONFIGURE_OPTS_EXTRA+=" --with-libyaml-dir=${LIBYAML_PREFIX}"
    [[ -n "$OPENSSL_PREFIX" ]] && RUBY_CONFIGURE_OPTS_EXTRA+=" --with-openssl-dir=${OPENSSL_PREFIX}"
    export RUBY_CONFIGURE_OPTS="${RUBY_CONFIGURE_OPTS}${RUBY_CONFIGURE_OPTS_EXTRA}"

    mise install "${INSTALL_TOOLS[@]}"
  )
  echo "✓ Installed selected runtimes from $DOTFILES_DIR/mise/.mise.toml"
else
  echo "⚠️  $DOTFILES_DIR/mise/.mise.toml not found; skipping runtime install."
fi

# Show installed versions
echo ""
echo "📋 Installed mise tool versions:"
mise list

echo ""
echo "✅ mise setup complete!"
echo ""
echo "Installed runtimes come from:"
echo "  • $DOTFILES_DIR/mise/.mise.toml"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Verify installation: mise doctor"
echo "  3. Check core versions: node -v && python --version && uv --version && go version && ruby -v"
echo "     Optional (if enabled): java -version && rustc --version && cargo --version"
echo ""
echo "Common mise commands:"
echo "  mise install          - Install versions from current config"
echo "  mise use node@25      - Set active version for current directory/global config"
echo "  mise use python@3.14  - Install Python 3.14"
echo "  mise use uv@0.10      - Install uv 0.10"
echo "  DOTFILES_INSTALL_JAVA=1 make mise              - Install optional Java 21"
echo "  DOTFILES_INSTALL_RUST=1 make mise              - Install optional Rust 1.93"
echo "  DOTFILES_INSTALL_JAVA=1 DOTFILES_INSTALL_RUST=1 make mise"
echo "  mise list             - Show installed versions"
echo "  mise ls-remote node   - Show available Node versions"
echo "  mise ls-remote java   - Show available Java versions"
echo "  mise ls-remote rust   - Show available Rust versions"
echo "  mise upgrade          - Upgrade installed tools within configured constraints"
echo ""
