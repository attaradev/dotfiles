#!/bin/bash

# ============================================
# mise Setup Script
# Unified version manager for Node.js, Python, Java, Rust, uv, Ruby, and more
# ============================================

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=./mutable-target.sh
source "$DOTFILES_DIR/scripts/mutable-target.sh"
LOCAL_MISE_CONFIG="$HOME/.mise.toml"
TRACKED_MISE_TEMPLATE="$DOTFILES_DIR/mise/.mise.toml"

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

ensure_local_mise_config() {
  local tmp_config

  if [[ -L "$LOCAL_MISE_CONFIG" ]]; then
    if [[ -f "$TRACKED_MISE_TEMPLATE" && "$LOCAL_MISE_CONFIG" -ef "$TRACKED_MISE_TEMPLATE" ]]; then
      tmp_config="$(mktemp "${LOCAL_MISE_CONFIG}.tmp.XXXXXX")"
      cp "$LOCAL_MISE_CONFIG" "$tmp_config"
      rm "$LOCAL_MISE_CONFIG"
      mv "$tmp_config" "$LOCAL_MISE_CONFIG"
      echo "✓ Migrated ~/.mise.toml from stowed symlink to local file"
    else
      echo "ℹ️  ~/.mise.toml is a symlink not managed by this repo; leaving as-is."
      return 0
    fi
  fi

  if [[ -f "$LOCAL_MISE_CONFIG" ]]; then
    echo "✓ Using existing local mise config at ~/.mise.toml"
    return 0
  fi

  if [[ -f "$TRACKED_MISE_TEMPLATE" ]]; then
    cp "$TRACKED_MISE_TEMPLATE" "$LOCAL_MISE_CONFIG"
    echo "✓ Created ~/.mise.toml from tracked template at $TRACKED_MISE_TEMPLATE"
    return 0
  fi

  echo "⚠️  $TRACKED_MISE_TEMPLATE not found; could not bootstrap ~/.mise.toml."
  return 1
}

extract_mise_tool_tracks() {
  local config_path="$1"
  local in_tools=0
  local line
  local tool
  local track

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^[[:space:]]*\[tools\][[:space:]]*$ ]]; then
      in_tools=1
      continue
    fi

    if [[ $in_tools -eq 1 && "$line" =~ ^[[:space:]]*\[[^]]+\][[:space:]]*$ ]]; then
      break
    fi

    [[ $in_tools -eq 0 ]] && continue

    if [[ "$line" =~ ^[[:space:]]*\"?([A-Za-z0-9:_-]+)\"?[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
      tool="${BASH_REMATCH[1]}"
      track="${BASH_REMATCH[2]}"
      printf '%s@%s\n' "$tool" "$track"
    fi
  done < "$config_path"
}

sync_global_mise_tracks() {
  local config_path="$1"

  if [[ ! -f "$config_path" ]]; then
    return 0
  fi

  local specs=()
  local spec
  while IFS= read -r spec; do
    [[ -n "$spec" ]] && specs+=("$spec")
  done < <(extract_mise_tool_tracks "$config_path")

  if (( ${#specs[@]} == 0 )); then
    return 0
  fi

  local batch_output
  if batch_output=$(mise use -g "${specs[@]}" 2>&1); then
    echo "✓ Synced ${#specs[@]} global mise tool track(s) from ~/.mise.toml"
  else
    echo "⚠️  Batch sync failed; falling back to per-tool sync."
    [[ -n "$batch_output" ]] && echo "    $batch_output"
    local synced=0 failed=0
    for spec in "${specs[@]}"; do
      if mise use -g "$spec" >/dev/null 2>&1; then
        synced=$((synced + 1))
      else
        failed=$((failed + 1))
        echo "⚠️  Failed to sync global mise track: $spec"
      fi
    done
    (( synced > 0 )) && echo "✓ Synced $synced global mise tool track(s) from ~/.mise.toml"
    (( failed > 0 )) && echo "⚠️  Unable to sync $failed global mise tool track(s); continuing."
  fi
}

echo ""
echo "📦 Installing runtimes from local config (~/.mise.toml)..."
ensure_local_mise_config || true

if [[ -f "$LOCAL_MISE_CONFIG" ]]; then
  sync_global_mise_tracks "$LOCAL_MISE_CONFIG"

  (
    cd "$HOME"

    # Ensure ruby-build picks up Homebrew libyaml/openssl paths for psych/openssl when Ruby is installed.
    LIBYAML_PREFIX="$(brew --prefix libyaml 2>/dev/null || true)"
    OPENSSL_PREFIX="$(brew --prefix openssl@3 2>/dev/null || true)"
    RUBY_CONFIGURE_OPTS_EXTRA=""
    [[ -n "$LIBYAML_PREFIX" ]] && RUBY_CONFIGURE_OPTS_EXTRA+=" --with-libyaml-dir=${LIBYAML_PREFIX}"
    [[ -n "$OPENSSL_PREFIX" ]] && RUBY_CONFIGURE_OPTS_EXTRA+=" --with-openssl-dir=${OPENSSL_PREFIX}"
    export RUBY_CONFIGURE_OPTS="${RUBY_CONFIGURE_OPTS}${RUBY_CONFIGURE_OPTS_EXTRA}"

    mise install
    mise reshim || true
  )
  echo "✓ Installed runtimes from ~/.mise.toml"
else
  echo "⚠️  ~/.mise.toml not found; skipping runtime install."
fi

# Show installed versions
echo ""
echo "📋 Installed mise tool versions:"
mise list

echo ""
echo "✅ mise setup complete!"
echo ""
echo "Installed runtimes come from:"
echo "  • ~/.mise.toml (bootstrapped from $TRACKED_MISE_TEMPLATE only when missing)"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Verify installation: mise doctor"
echo "  3. Check versions: node -v && python --version && uv --version && go version && ruby -v"
echo "     Added as-needed: java -version && rustc --version && cargo --version"
echo ""
echo "Common mise commands:"
echo "  mise install          - Install versions from current config"
echo "  mise use node@25      - Set active version for current directory/global config"
echo "  mise use python@3.14  - Install Python 3.14"
echo "  mise use uv@0.10      - Install uv 0.10"
echo "  # Edit ~/.mise.toml to add/remove tools, then run:"
echo "  make mise"
echo "  mise list             - Show installed versions"
echo "  mise ls-remote node   - Show available Node versions"
echo "  mise ls-remote java   - Show available Java versions"
echo "  mise ls-remote rust   - Show available Rust versions"
echo "  mise upgrade          - Upgrade installed tools within configured constraints"
echo ""
