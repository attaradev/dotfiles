#!/bin/bash

# ============================================
# GnuPG Setup Script
# Configures GPG for secure communications and Git commit signing
# ============================================

set -e  # Exit on error

echo "🔐 Setting up GnuPG (GPG)..."

# ============================================
# Check if GPG is installed
# ============================================

if ! command -v gpg &> /dev/null; then
  echo "❌ GPG not found. Please run 'brew bundle install' first."
  exit 1
fi

echo "✓ GPG found: $(gpg --version | head -n 1)"

# ============================================
# Create GPG directories if they don't exist
# ============================================

GPG_DIR="$HOME/.gnupg"

if [[ ! -d "$GPG_DIR" ]]; then
  echo "📁 Creating GPG directory at $GPG_DIR..."
  mkdir -p "$GPG_DIR"
  chmod 700 "$GPG_DIR"
else
  echo "✓ GPG directory already exists"
fi

# ============================================
# Configure GPG Agent
# ============================================

GPG_AGENT_CONF="$GPG_DIR/gpg-agent.conf"

echo "📝 Configuring GPG agent..."

cat > "$GPG_AGENT_CONF" << 'EOF'
# GPG Agent Configuration
# Timeout settings (in seconds)
default-cache-ttl 3600
max-cache-ttl 86400

# Use pinentry-mac for passphrase entry on macOS
pinentry-program /opt/homebrew/bin/pinentry-mac

# Enable SSH support (optional)
# enable-ssh-support
EOF

chmod 600 "$GPG_AGENT_CONF"
echo "✓ GPG agent configured at $GPG_AGENT_CONF"

# ============================================
# Configure GPG
# ============================================

GPG_CONF="$GPG_DIR/gpg.conf"

echo "📝 Configuring GPG..."

cat > "$GPG_CONF" << 'EOF'
# GPG Configuration

# Use AES256 for symmetric encryption
cipher-algo AES256

# Use SHA512 for hashing
digest-algo SHA512

# Use ZLIB for compression
compress-algo ZLIB

# Preferences for new keys
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

# Show long key IDs
keyid-format 0xlong

# Display the fingerprint of keys
with-fingerprint

# Use UTF-8
charset utf-8

# Don't include version in output
no-emit-version

# Don't include comments in output
no-comments

# Use gpg-agent for passphrase management
use-agent
EOF

chmod 600 "$GPG_CONF"
echo "✓ GPG configured at $GPG_CONF"

# ============================================
# Restart GPG Agent
# ============================================

echo "🔄 Restarting GPG agent..."
gpgconf --kill gpg-agent
gpg-agent --daemon &> /dev/null || true
echo "✓ GPG agent restarted"

# ============================================
# Check for existing keys
# ============================================

echo ""
echo "🔑 Checking for existing GPG keys..."

KEY_COUNT=$(gpg --list-secret-keys --keyid-format LONG 2>/dev/null | grep -c "sec" || echo "0")

if [[ "$KEY_COUNT" -gt 0 ]]; then
  echo "✓ Found $KEY_COUNT existing GPG key(s):"
  gpg --list-secret-keys --keyid-format LONG
else
  echo "ℹ️  No GPG keys found. You can generate one with:"
  echo ""
  echo "  gpg --full-generate-key"
  echo ""
  echo "Recommended settings:"
  echo "  - Key type: RSA and RSA"
  echo "  - Key size: 4096 bits"
  echo "  - Expiration: 1-2 years (you can extend later)"
  echo "  - Real name: Your full name"
  echo "  - Email: Your GitHub/GitLab email"
fi

# ============================================
# Git Integration
# ============================================

echo ""
echo "🔧 Git Integration"
echo ""

# Check if Git is configured with GPG
GIT_SIGNING_KEY=$(git config --global user.signingkey 2>/dev/null || echo "")

if [[ -n "$GIT_SIGNING_KEY" ]]; then
  echo "✓ Git is already configured to use GPG key: $GIT_SIGNING_KEY"
else
  echo "ℹ️  Git is not configured for commit signing"
  echo ""
  echo "To enable Git commit signing:"
  echo "  1. Get your GPG key ID:"
  echo "     gpg --list-secret-keys --keyid-format LONG"
  echo ""
  echo "  2. Configure Git to use your GPG key:"
  echo "     git config --global user.signingkey <YOUR_KEY_ID>"
  echo ""
  echo "  3. Enable commit signing by default:"
  echo "     git config --global commit.gpgsign true"
  echo ""
  echo "  4. Add your GPG public key to GitHub/GitLab:"
  echo "     gpg --armor --export <YOUR_KEY_ID>"
fi

# ============================================
# Shell Integration
# ============================================

echo ""
echo "🐚 Shell Integration"
echo ""

ZSHRC="$HOME/.zshrc"

if [[ -f "$ZSHRC" ]]; then
  if ! grep -q "GPG_TTY" "$ZSHRC"; then
    echo "" >> "$ZSHRC"
    echo "# GPG TTY configuration for commit signing" >> "$ZSHRC"
    echo 'export GPG_TTY=$(tty)' >> "$ZSHRC"
    echo "✓ Added GPG_TTY export to ~/.zshrc"
  else
    echo "✓ GPG_TTY already configured in ~/.zshrc"
  fi
else
  echo "⚠️  ~/.zshrc not found. You may need to add manually:"
  echo "     export GPG_TTY=\$(tty)"
fi

# ============================================
# Summary
# ============================================

echo ""
echo "✅ GnuPG setup complete!"
echo ""
echo "📋 What was configured:"
echo "  ✓ GPG directory created at ~/.gnupg"
echo "  ✓ GPG agent configured with pinentry-mac"
echo "  ✓ GPG preferences set (AES256, SHA512)"
echo "  ✓ Shell integration added to ~/.zshrc"
echo ""
echo "🔐 Next Steps:"
echo ""
echo "1. Generate a new GPG key (if you don't have one):"
echo "   gpg --full-generate-key"
echo ""
echo "2. List your GPG keys:"
echo "   gpg --list-secret-keys --keyid-format LONG"
echo ""
echo "3. Configure Git to use your GPG key:"
echo "   git config --global user.signingkey <YOUR_KEY_ID>"
echo "   git config --global commit.gpgsign true"
echo ""
echo "4. Export your public key for GitHub/GitLab:"
echo "   gpg --armor --export <YOUR_KEY_ID> | pbcopy"
echo "   (This copies it to clipboard - paste in GitHub Settings)"
echo ""
echo "5. Test GPG signing:"
echo "   echo 'test' | gpg --clearsign"
echo ""
echo "📖 Useful GPG commands:"
echo "   gpg --list-keys              # List public keys"
echo "   gpg --list-secret-keys       # List private keys"
echo "   gpg --delete-key <KEY_ID>    # Delete a public key"
echo "   gpg --delete-secret-key <ID> # Delete a private key"
echo "   gpg --edit-key <KEY_ID>      # Edit a key (change expiry, etc.)"
echo ""
