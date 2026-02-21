#!/bin/bash

# ============================================
# GnuPG Setup Script
# Configures GPG for secure communications and Git commit signing
# ============================================

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./scripts/mutable-target.sh
source "$DOTFILES_DIR/scripts/mutable-target.sh"

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
else
  echo "✓ GPG directory already exists"
fi
chmod 700 "$GPG_DIR"

# Backup helper to preserve user configs
backup_file() {
  local file="$1"
  if [[ -e "$file" && ! -L "$file" ]]; then
    local ts
    ts=$(date +%Y%m%d%H%M%S)
    local backup="${file}.bak.${ts}"
    cp "$file" "$backup"
    echo "📦 Backed up existing $(basename "$file") to $(basename "$backup")"
  fi
}

materialize_local_file() {
  local file="$1"
  if [[ -L "$file" ]]; then
    local tmp
    tmp="$(mktemp)"
    cat "$file" > "$tmp"
    echo "🔁 Replacing symlinked $(basename "$file") with a local machine-specific file"
    rm "$file"
    cat "$tmp" > "$file"
    rm -f "$tmp"
  fi
}

append_setting_if_missing() {
  local file="$1"
  local pattern="$2"
  local line="$3"

  if grep -Eq "$pattern" "$file"; then
    return 1
  fi

  printf '%s\n' "$line" >> "$file"
  return 0
}

find_pinentry_mac() {
  local candidates=(
    "$(command -v pinentry-mac 2>/dev/null || true)"
    "/opt/homebrew/bin/pinentry-mac"
    "/usr/local/bin/pinentry-mac"
  )

  for candidate in "${candidates[@]}"; do
    if [[ -n "$candidate" && -x "$candidate" ]]; then
      echo "$candidate"
      return
    fi
  done
}

# ============================================
# Configure GPG Agent
# ============================================

GPG_AGENT_CONF="$GPG_DIR/gpg-agent.conf"

echo "📝 Configuring GPG agent..."

PINENTRY_BIN="$(find_pinentry_mac)"

if [[ -z "$PINENTRY_BIN" ]]; then
  echo "❌ pinentry-mac not found. Install with: brew install pinentry-mac"
  exit 1
fi

echo "✓ Using pinentry: $PINENTRY_BIN"

materialize_local_file "$GPG_AGENT_CONF"
touch "$GPG_AGENT_CONF"

needs_gpg_agent_update=0
if ! grep -Eq '^[[:space:]]*default-cache-ttl([[:space:]]+|$)' "$GPG_AGENT_CONF"; then
  needs_gpg_agent_update=1
fi
if ! grep -Eq '^[[:space:]]*max-cache-ttl([[:space:]]+|$)' "$GPG_AGENT_CONF"; then
  needs_gpg_agent_update=1
fi
if ! grep -Eq '^[[:space:]]*pinentry-program([[:space:]]+|$)' "$GPG_AGENT_CONF"; then
  needs_gpg_agent_update=1
fi

if (( needs_gpg_agent_update == 1 )); then
  backup_file "$GPG_AGENT_CONF"
  append_setting_if_missing "$GPG_AGENT_CONF" '^[[:space:]]*default-cache-ttl([[:space:]]+|$)' "default-cache-ttl 3600" && echo "✓ Added default-cache-ttl to gpg-agent.conf"
  append_setting_if_missing "$GPG_AGENT_CONF" '^[[:space:]]*max-cache-ttl([[:space:]]+|$)' "max-cache-ttl 86400" && echo "✓ Added max-cache-ttl to gpg-agent.conf"
  append_setting_if_missing "$GPG_AGENT_CONF" '^[[:space:]]*pinentry-program([[:space:]]+|$)' "pinentry-program $PINENTRY_BIN" && echo "✓ Added pinentry-program to gpg-agent.conf"
else
  echo "✓ Preserving existing gpg-agent.conf settings"
fi

chmod 600 "$GPG_AGENT_CONF"
echo "✓ GPG agent configured at $GPG_AGENT_CONF"

# ============================================
# Configure GPG
# ============================================

GPG_CONF="$GPG_DIR/gpg.conf"

echo "📝 Configuring GPG..."

materialize_local_file "$GPG_CONF"
touch "$GPG_CONF"

needs_gpg_conf_update=0
if ! grep -Eq '^[[:space:]]*keyid-format([[:space:]]+|$)' "$GPG_CONF"; then
  needs_gpg_conf_update=1
fi
if ! grep -Eq '^[[:space:]]*with-fingerprint([[:space:]]+|$)' "$GPG_CONF"; then
  needs_gpg_conf_update=1
fi
if ! grep -Eq '^[[:space:]]*auto-key-retrieve([[:space:]]+|$)' "$GPG_CONF"; then
  needs_gpg_conf_update=1
fi
if ! grep -Eq '^[[:space:]]*use-agent([[:space:]]+|$)' "$GPG_CONF"; then
  needs_gpg_conf_update=1
fi

if (( needs_gpg_conf_update == 1 )); then
  backup_file "$GPG_CONF"
  append_setting_if_missing "$GPG_CONF" '^[[:space:]]*keyid-format([[:space:]]+|$)' "keyid-format 0xlong" && echo "✓ Added keyid-format to gpg.conf"
  append_setting_if_missing "$GPG_CONF" '^[[:space:]]*with-fingerprint([[:space:]]+|$)' "with-fingerprint" && echo "✓ Added with-fingerprint to gpg.conf"
  append_setting_if_missing "$GPG_CONF" '^[[:space:]]*auto-key-retrieve([[:space:]]+|$)' "auto-key-retrieve" && echo "✓ Added auto-key-retrieve to gpg.conf"
  append_setting_if_missing "$GPG_CONF" '^[[:space:]]*use-agent([[:space:]]+|$)' "use-agent" && echo "✓ Added use-agent to gpg.conf"
else
  echo "✓ Preserving existing gpg.conf settings"
fi

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

KEY_COUNT=$(gpg --list-secret-keys --keyid-format LONG 2>/dev/null | grep -c "^sec" || true)
KEY_COUNT=${KEY_COUNT:-0}
KEY_COUNT=${KEY_COUNT//$'\n'/}

if (( KEY_COUNT > 0 )); then
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

# Check effective Git config (includes ~/.gitconfig includes and local overrides)
GIT_SIGNING_KEY=$(git config --get user.signingkey 2>/dev/null || true)
GIT_COMMIT_GPGSIGN=$(git config --type=bool --get commit.gpgsign 2>/dev/null || true)

if [[ -n "$GIT_SIGNING_KEY" && "$GIT_COMMIT_GPGSIGN" == "true" ]]; then
  echo "✓ Git commit signing is configured with GPG key: $GIT_SIGNING_KEY"
elif [[ -n "$GIT_SIGNING_KEY" ]]; then
  echo "ℹ️  Git has a signing key configured: $GIT_SIGNING_KEY"
  echo "ℹ️  Enable commit signing by default with:"
  echo "   git config --global commit.gpgsign true"
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

ZSHRC_TARGET=$(resolve_mutable_target "$ZSHRC" "$HOME/.zshrc.local" "$DOTFILES_DIR")

if [[ -f "$ZSHRC_TARGET" ]] || [[ "$ZSHRC_TARGET" == "$HOME/.zshrc.local" ]] || [[ "$ZSHRC_TARGET" == "$HOME/.zshrc" ]]; then
  touch "$ZSHRC_TARGET"
  if grep -Eq '^[[:space:]]*export[[:space:]]+GPG_TTY=' "$ZSHRC_TARGET" || ([[ -f "$ZSHRC" ]] && grep -Eq '^[[:space:]]*export[[:space:]]+GPG_TTY=' "$ZSHRC"); then
    echo "✓ GPG_TTY already configured in ~/.zshrc or ~/.zshrc.local"
  else
    {
      echo ""
      echo "# GPG TTY configuration for commit signing"
      echo 'export GPG_TTY=$(tty)'
    } >> "$ZSHRC_TARGET"
    echo "✓ Added GPG_TTY export to ${ZSHRC_TARGET/#$HOME/~}"
  fi
else
  echo "⚠️  ${ZSHRC/#$HOME/~} not found. You may need to add manually:"
  echo "     export GPG_TTY=\$(tty)"
fi

# ============================================
# Summary
# ============================================

echo ""
echo "✅ GnuPG setup complete!"
echo ""
echo "📋 What was configured:"
echo "  ✓ GPG directory prepared at ~/.gnupg (permissions enforced)"
echo "  ✓ GPG agent configured with pinentry-mac"
echo "  ✓ GPG defaults ensured without overwriting custom settings"
echo "  ✓ Shell integration checked for GPG_TTY"
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
