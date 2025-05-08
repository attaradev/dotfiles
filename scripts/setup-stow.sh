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
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$HOME/.dotfiles"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "🔗 Creating symlink $TARGET_DIR -> $DOTFILES_DIR"
  ln -s "$DOTFILES_DIR" "$TARGET_DIR"
fi

cd "$DOTFILES_DIR"

# ============================================
# Backup existing configs
# ============================================

path_contains_symlink() {
  local path=$1
  local current="$path"

  while [[ "$current" != "$HOME" && "$current" != "/" ]]; do
    if [[ -L "$current" ]]; then
      return 0
    fi
    current="$(dirname "$current")"
  done

  return 1
}

backup_if_exists() {
  local file=$1

  if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
    if path_contains_symlink "$file"; then
      echo "⚠️  $file is inside a symlinked path; skipping backup."
      return
    fi
    echo "📦 Backing up existing $file to ${file}.backup"
    mv "$file" "${file}.backup"
  fi
}

backup_package_files() {
  local package=$1
  local package_dir="$DOTFILES_DIR/$package"
  local source_file rel_path

  if [[ ! -d "$package_dir" ]]; then
    return
  fi

  while IFS= read -r source_file; do
    rel_path="${source_file#"$package_dir/"}"
    backup_if_exists "$HOME/$rel_path"
  done < <(find "$package_dir" -type f)
}

# Backup existing configs before symlinking.
# This keeps stow non-destructive for package-managed files such as
# ~/.hushlogin and ~/.config/starship.toml.
for package in zsh git npm mise starship ssh claude codex; do
  backup_package_files "$package"
done

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

ensure_dir() {
  local dir=$1

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
}

ensure_knowledge_dir() {
  local dir="$HOME/.knowledge"
  local backup_dir

  if [[ -L "$dir" ]]; then
    backup_dir="${dir}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "📦 Converting symlinked $dir to a user-owned directory"
    mkdir -p "$backup_dir"
    cp -a "$dir/." "$backup_dir/" 2>/dev/null || true
    rm "$dir"
    mkdir -p "$dir"
    cp -a "$backup_dir/." "$dir/" 2>/dev/null || true
    echo "  Backup created at $backup_dir"
    return 0
  fi

  ensure_dir "$dir"
}

if [[ -d "$DOTFILES_DIR/ssh" ]]; then
  ensure_secure_dir "$HOME/.ssh" 700
  ensure_secure_dir "$HOME/.ssh/sockets" 700
fi

if [[ -d "$DOTFILES_DIR/gpg" ]]; then
  ensure_secure_dir "$HOME/.gnupg" 700
fi

SKIP_GPG=0
if [[ -d "$DOTFILES_DIR/obsidian" ]]; then
  ensure_knowledge_dir
fi

if [[ -d "$DOTFILES_DIR/gpg" ]]; then
  if [[ -e "$HOME/.gnupg/gpg-agent.conf" && ! -L "$HOME/.gnupg/gpg-agent.conf" ]] || \
    [[ -e "$HOME/.gnupg/gpg.conf" && ! -L "$HOME/.gnupg/gpg.conf" ]]; then
    echo "ℹ️  Preserving local GPG config files in ~/.gnupg; skipping gpg stow package."
    SKIP_GPG=1
  fi
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
  "claude"
  "codex"
)

STOWED=()
SKIPPED=()

# Stow each package
for package in "${PACKAGES[@]}"; do
  if [[ "$package" == "gpg" && "$SKIP_GPG" == "1" ]]; then
    echo "  ⚠️  Skipping gpg to preserve local ~/.gnupg/*.conf settings."
    SKIPPED+=("$package")
    continue
  fi

  if [[ -d "$DOTFILES_DIR/$package" ]]; then
    echo "  ✓ Stowing $package..."
    STOW_ARGS=(--target="$HOME" --restow)
    if [[ "$package" == "obsidian" ]]; then
      STOW_ARGS+=(--no-folding)
    fi
    stow -v "$package" "${STOW_ARGS[@]}"
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
      claude)   echo "  ~/.claude/CLAUDE.md -> $DOTFILES_DIR/claude/.claude/CLAUDE.md"; echo "  ~/.claude/settings.json -> $DOTFILES_DIR/claude/.claude/settings.json" ;;
      codex)    echo "  ~/.codex/config.toml -> $DOTFILES_DIR/codex/.codex/config.toml"; echo "  ~/.codex/AGENTS.md -> $DOTFILES_DIR/codex/.codex/AGENTS.md" ;;
    esac
  done
fi

if [[ -d "$DOTFILES_DIR/obsidian" ]]; then
  echo "  ~/.knowledge is user-owned local content (seed via make obsidian)"
fi
if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo ""
  echo "Skipped packages: ${SKIPPED[*]}"
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
