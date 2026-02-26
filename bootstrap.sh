#!/bin/bash
# bootstrap.sh - Dotfiles setup bootstrap script
# Usage: curl -fsSL https://raw.githubusercontent.com/attaradev/dotfiles/main/bootstrap.sh | bash
# Usage (recommended): git clone https://github.com/attaradev/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./bootstrap.sh

set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
REPO_URL="https://github.com/attaradev/dotfiles.git"
DEFAULT_BRANCH="${DOTFILES_BOOTSTRAP_BRANCH:-main}"
DOTFILES_BOOTSTRAP_SKIP_GIT_PULL="${DOTFILES_BOOTSTRAP_SKIP_GIT_PULL:-0}"

normalize_bool() {
  local raw
  raw="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')"
  case "$raw" in
    1|y|yes|true|on) echo "1" ;;
    0|n|no|false|off) echo "0" ;;
    *) echo "0" ;;
  esac
}

DOTFILES_BOOTSTRAP_SKIP_GIT_PULL="$(normalize_bool "$DOTFILES_BOOTSTRAP_SKIP_GIT_PULL")"

detect_default_branch() {
  local remote_head
  remote_head="$(git ls-remote --symref "$REPO_URL" HEAD 2>/dev/null | awk '/^ref:/ {sub("refs/heads/", "", $2); print $2; exit}')"
  if [[ -n "$remote_head" ]]; then
    printf '%s\n' "$remote_head"
  else
    printf '%s\n' "$DEFAULT_BRANCH"
  fi
}

prepare_repo() {
  local target_branch current_remote backup_dir

  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    echo "📁 Dotfiles repository already exists at $DOTFILES_DIR"
    if [[ "$DOTFILES_BOOTSTRAP_SKIP_GIT_PULL" == "1" ]]; then
      echo "ℹ️  Skipping git pull (DOTFILES_BOOTSTRAP_SKIP_GIT_PULL=1)"
      return 0
    fi

    current_remote="$(git -C "$DOTFILES_DIR" config --get remote.origin.url 2>/dev/null || true)"
    if [[ -n "$current_remote" && "$current_remote" != "$REPO_URL" && "$current_remote" != "git@github.com:attaradev/dotfiles.git" ]]; then
      echo "⚠️  Existing repo origin is '$current_remote' (expected '$REPO_URL'); skipping pull."
      return 0
    fi

    target_branch="$(git -C "$DOTFILES_DIR" symbolic-ref --short HEAD 2>/dev/null || true)"
    if [[ -z "$target_branch" ]]; then
      target_branch="$(detect_default_branch)"
    fi

    echo "🔄 Pulling latest changes on branch '$target_branch'..."
    git -C "$DOTFILES_DIR" pull --ff-only origin "$target_branch" || {
      echo "⚠️  Warning: Could not fast-forward pull. Continuing with existing local state..."
    }
    return 0
  fi

  if [[ -e "$DOTFILES_DIR" ]]; then
    if [[ -d "$DOTFILES_DIR" && -z "$(find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 2>/dev/null)" ]]; then
      rmdir "$DOTFILES_DIR" || true
    else
      backup_dir="${DOTFILES_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
      echo "⚠️  $DOTFILES_DIR exists but is not a git repo. Moving it to $backup_dir"
      mv "$DOTFILES_DIR" "$backup_dir"
    fi
  fi

  target_branch="$(detect_default_branch)"
  echo "📦 Cloning dotfiles repository (branch: $target_branch)..."
  git clone --branch "$target_branch" "$REPO_URL" "$DOTFILES_DIR"
}

echo "🚀 Bootstrapping dotfiles setup..."

# Ensure Xcode Command Line Tools are present before proceeding
if ! xcode-select -p >/dev/null 2>&1; then
  echo "⚙️  Installing Xcode Command Line Tools (required for git/Homebrew)..."
  xcode-select --install || true
  echo "➡️  Re-run this bootstrap after the tools finish installing."
  exit 1
fi

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
  echo "❌ Error: git is not installed. Please install git first."
  exit 1
fi

prepare_repo

cd "$DOTFILES_DIR"

# Make top-level scripts executable
shopt -s nullglob
for script in "$DOTFILES_DIR"/*.sh; do
  chmod +x "$script"
done
shopt -u nullglob

# Run full setup (Homebrew, Brewfile packages, mise, stow, GPG, VSCode)
echo "⚙️  Running full setup..."
"$DOTFILES_DIR/setup.sh"

echo ""
echo "✅ Bootstrap complete!"
echo "💡 To reload your shell configuration, run: exec $SHELL"
