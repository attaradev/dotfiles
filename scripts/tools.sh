#!/usr/bin/env bash
# Individual tool setup. Usage: tools.sh [stow|mise|gnupg|vscode] [args...]

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=./lib.sh
source "$DOTFILES_DIR/scripts/lib.sh"

COMMAND="${1:-}"
shift || true

# ===========================================================================
# stow helpers
# ===========================================================================

_stow_path_contains_symlink() {
  local path=$1
  local current="$path"
  while [[ "$current" != "$HOME" && "$current" != "/" ]]; do
    if [[ -L "$current" ]]; then return 0; fi
    current="$(dirname "$current")"
  done
  return 1
}

_stow_backup_if_exists() {
  local file=$1
  if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
    if _stow_path_contains_symlink "$file"; then
      echo "⚠️  $file is inside a symlinked path; skipping backup."
      return
    fi
    echo "📦 Backing up existing $file to ${file}.backup"
    mv "$file" "${file}.backup"
  fi
}

_stow_backup_package_files() {
  local package=$1
  local package_dir="$DOTFILES_DIR/$package"
  local source_file rel_path
  if [[ ! -d "$package_dir" ]]; then return; fi
  while IFS= read -r source_file; do
    rel_path="${source_file#"$package_dir/"}"
    _stow_backup_if_exists "$HOME/$rel_path"
  done < <(find "$package_dir" -type f)
}

_stow_ensure_dir() {
  local dir=$1 mode="${2:-}"
  if [[ -L "$dir" && ! -d "$dir" ]]; then echo "⚠️  $dir exists as a symlink that is not a directory; skipping."; return; fi
  if [[ -e "$dir" && ! -d "$dir" ]]; then echo "⚠️  $dir exists but is not a directory; skipping."; return; fi
  if [[ ! -d "$dir" ]]; then echo "📁 Creating $dir"; mkdir -p "$dir"; fi
  if [[ -n "$mode" ]]; then chmod "$mode" "$dir"; fi
}

_stow_ensure_knowledge_dir() {
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
  _stow_ensure_dir "$dir"
}

# ===========================================================================
# mise helpers
# ===========================================================================

_mise_has_activation() {
  local pattern="$1"; shift
  local file
  for file in "$@"; do
    if [[ -f "$file" ]] && grep -q "$pattern" "$file"; then return 0; fi
  done
  return 1
}

_mise_ensure_local_config() {
  local local_config="$1" tracked_template="$2"
  local tmp_config
  if [[ -L "$local_config" ]]; then
    if [[ -f "$tracked_template" && "$local_config" -ef "$tracked_template" ]]; then
      tmp_config="$(mktemp "${local_config}.tmp.XXXXXX")"
      cp "$local_config" "$tmp_config"
      rm "$local_config"
      mv "$tmp_config" "$local_config"
      echo "✓ Migrated ~/.mise.toml from stowed symlink to local file"
    else
      echo "ℹ️  ~/.mise.toml is a symlink not managed by this repo; leaving as-is."
      return 0
    fi
  fi
  if [[ -f "$local_config" ]]; then echo "✓ Using existing local mise config at ~/.mise.toml"; return 0; fi
  if [[ -f "$tracked_template" ]]; then
    cp "$tracked_template" "$local_config"
    echo "✓ Created ~/.mise.toml from tracked template at $tracked_template"
    return 0
  fi
  echo "⚠️  $tracked_template not found; could not bootstrap ~/.mise.toml."
  return 1
}

_mise_extract_tool_tracks() {
  local config_path="$1"
  local in_tools=0 line tool track
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^[[:space:]]*\[tools\][[:space:]]*$ ]]; then in_tools=1; continue; fi
    if [[ $in_tools -eq 1 && "$line" =~ ^[[:space:]]*\[[^]]+\][[:space:]]*$ ]]; then break; fi
    [[ $in_tools -eq 0 ]] && continue
    if [[ "$line" =~ ^[[:space:]]*\"?([A-Za-z0-9:_-]+)\"?[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
      tool="${BASH_REMATCH[1]}"; track="${BASH_REMATCH[2]}"
      printf '%s@%s\n' "$tool" "$track"
    fi
  done < "$config_path"
}

_mise_sync_global_tracks() {
  local config_path="$1"
  if [[ ! -f "$config_path" ]]; then return 0; fi
  local specs=() spec
  while IFS= read -r spec; do [[ -n "$spec" ]] && specs+=("$spec"); done \
    < <(_mise_extract_tool_tracks "$config_path")
  if (( ${#specs[@]} == 0 )); then return 0; fi
  local batch_output
  if batch_output=$(mise use -g "${specs[@]}" 2>&1); then
    echo "✓ Synced ${#specs[@]} global mise tool track(s) from ~/.mise.toml"
  else
    echo "⚠️  Batch sync failed; falling back to per-tool sync."
    [[ -n "$batch_output" ]] && echo "    $batch_output"
    local synced=0 failed=0
    for spec in "${specs[@]}"; do
      if mise use -g "$spec" >/dev/null 2>&1; then synced=$((synced + 1))
      else failed=$((failed + 1)); echo "⚠️  Failed to sync global mise track: $spec"
      fi
    done
    (( synced > 0 )) && echo "✓ Synced $synced global mise tool track(s) from ~/.mise.toml"
    (( failed > 0 )) && echo "⚠️  Unable to sync $failed global mise tool track(s); continuing."
  fi
}

# ===========================================================================
# gnupg helpers
# ===========================================================================

_gpg_backup_if_changed() {
  # Call before modifying $file. Pass a snapshot taken before changes.
  # If the file differs from the snapshot, rename snapshot to .bak.TIMESTAMP.
  # If unchanged, discard snapshot. Returns 0 either way.
  local file="$1" snapshot="$2"
  [[ -f "$snapshot" ]] || return 0
  if cmp -s "$file" "$snapshot"; then
    rm -f "$snapshot"
    return 0
  fi
  local ts; ts=$(date +%Y%m%d%H%M%S)
  local backup="${file}.bak.${ts}"
  mv "$snapshot" "$backup"
  echo "📦 Backed up $(basename "$file") to $(basename "$backup")"
}

_gpg_materialize_local_file() {
  local file="$1"
  if [[ -L "$file" ]]; then
    local tmp; tmp="$(mktemp)"
    cat "$file" > "$tmp"
    echo "🔁 Replacing symlinked $(basename "$file") with a local machine-specific file"
    rm "$file"; cat "$tmp" > "$file"; rm -f "$tmp"
  fi
}

_gpg_append_setting_if_missing() {
  local file="$1" pattern="$2" line="$3"
  if grep -Eq "$pattern" "$file"; then return 1; fi
  printf '%s\n' "$line" >> "$file"
  return 0
}

_gpg_find_pinentry_mac() {
  local candidates=(
    "$(command -v pinentry-mac 2>/dev/null || true)"
    "/opt/homebrew/bin/pinentry-mac"
    "/usr/local/bin/pinentry-mac"
  )
  local candidate
  for candidate in "${candidates[@]}"; do
    if [[ -n "$candidate" && -x "$candidate" ]]; then echo "$candidate"; return; fi
  done
}

# ===========================================================================
# vscode helpers
# ===========================================================================

_vscode_is_extension_installed() {
  local ext_id="$1" installed_exts="$2"
  if printf '%s\n' "$installed_exts" | grep -Fxqi "$ext_id"; then return 0; fi
  local ext_id_lc; ext_id_lc="$(printf '%s' "$ext_id" | tr '[:upper:]' '[:lower:]')"
  if [[ "$ext_id_lc" == "github.copilot" ]] && printf '%s\n' "$installed_exts" | grep -Fxqi "github.copilot-chat"; then
    return 0
  fi
  return 1
}

# ===========================================================================
# Commands
# ===========================================================================

cmd_stow() {
  echo "🔗 Setting up dotfiles with GNU Stow..."

  if ! command -v stow &>/dev/null; then
    echo "❌ GNU Stow not found. Please run 'brew bundle install' first."
    exit 1
  fi

  local target_dir="$HOME/.dotfiles"
  if [[ ! -d "$target_dir" ]]; then
    echo "🔗 Creating symlink $target_dir -> $DOTFILES_DIR"
    ln -s "$DOTFILES_DIR" "$target_dir"
  fi

  cd "$DOTFILES_DIR"

  local default_packages=("zsh" "git" "npm" "starship" "ssh" "gpg" "claude" "codex")
  local packages full_run
  if [[ "$#" -gt 0 ]]; then
    packages=("$@"); full_run=0
    echo "ℹ️  Targeted stow run for packages: ${packages[*]}"
  else
    packages=("${default_packages[@]}"); full_run=1
  fi

  local pkg
  for pkg in "${packages[@]}"; do _stow_backup_package_files "$pkg"; done

  if printf '%s\n' "${packages[@]}" | grep -Fxq "ssh" && [[ -d "$DOTFILES_DIR/ssh" ]]; then
    _stow_ensure_dir "$HOME/.ssh" 700
    _stow_ensure_dir "$HOME/.ssh/sockets" 700
  fi
  if printf '%s\n' "${packages[@]}" | grep -Fxq "gpg" && [[ -d "$DOTFILES_DIR/gpg" ]]; then
    _stow_ensure_dir "$HOME/.gnupg" 700
  fi

  local skip_gpg=0
  if [[ "$full_run" == "1" ]] && [[ -d "$DOTFILES_DIR/obsidian" ]]; then
    _stow_ensure_knowledge_dir
  fi
  if printf '%s\n' "${packages[@]}" | grep -Fxq "gpg" && [[ -d "$DOTFILES_DIR/gpg" ]]; then
    if [[ -e "$HOME/.gnupg/gpg-agent.conf" && ! -L "$HOME/.gnupg/gpg-agent.conf" ]] || \
       [[ -e "$HOME/.gnupg/gpg.conf" && ! -L "$HOME/.gnupg/gpg.conf" ]]; then
      echo "ℹ️  Preserving local GPG config files in ~/.gnupg; skipping gpg stow package."
      skip_gpg=1
    fi
  fi

  echo ""; echo "📂 Stowing configuration packages..."
  local stowed=() skipped=()
  for pkg in "${packages[@]}"; do
    if [[ "$pkg" == "gpg" && "$skip_gpg" == "1" ]]; then
      echo "  ⚠️  Skipping gpg to preserve local ~/.gnupg/*.conf settings."
      skipped+=("$pkg"); continue
    fi
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
      echo "  ✓ Stowing $pkg..."
      local stow_args=(--target="$HOME" --restow)
      [[ "$pkg" == "obsidian" ]] && stow_args+=(--no-folding)
      stow -v "$pkg" "${stow_args[@]}"
      stowed+=("$pkg")
    else
      echo "  ⚠️  Package directory '$pkg' not found in $DOTFILES_DIR, skipping..."
      skipped+=("$pkg")
    fi
  done

  echo ""; echo "✅ Stow setup complete!"
  echo "  (Existing dotfiles are backed up to <file>.backup when replaced.)"
  if [[ ${#stowed[@]} -gt 0 ]]; then
    echo ""; echo "Symlinks created:"
    for pkg in "${stowed[@]}"; do
      case "$pkg" in
        zsh)      echo "  ~/.zshrc -> $DOTFILES_DIR/zsh/.zshrc" ;;
        git)      echo "  ~/.gitconfig -> $DOTFILES_DIR/git/.gitconfig" ;;
        npm)      echo "  ~/.npmrc -> $DOTFILES_DIR/npm/.npmrc" ;;
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
  if [[ ${#skipped[@]} -gt 0 ]]; then echo ""; echo "Skipped packages: ${skipped[*]}"; fi
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
}

cmd_mise() {
  local local_config="$HOME/.mise.toml"
  local tracked_template="$DOTFILES_DIR/mise/.mise.toml"

  echo "🔧 Setting up mise (unified version manager)..."

  if command -v mise &>/dev/null; then
    echo "✓ mise is already installed ($(mise --version))"
  else
    echo "❌ mise not found. Please run 'brew bundle install' first to install mise."
    exit 1
  fi

  local zshrc="$HOME/.zshrc" bashrc="$HOME/.bashrc"
  local zshrc_target; zshrc_target=$(resolve_mutable_target "$zshrc" "$HOME/.zshrc.local" "$DOTFILES_DIR")
  if [[ -f "$zshrc_target" ]] || [[ "$zshrc_target" == "$HOME/.zshrc.local" ]] || [[ "$zshrc_target" == "$HOME/.zshrc" ]]; then
    touch "$zshrc_target"
    if ! _mise_has_activation 'mise activate zsh' "$zshrc" "$zshrc_target"; then
      { echo ""; echo "# mise (unified version manager)"; echo 'eval "$(mise activate zsh)"'; } >> "$zshrc_target"
      echo "✓ Added mise to ${zshrc_target/#$HOME/~}"
    else
      echo "✓ mise already configured in ${zshrc_target/#$HOME/~}"
    fi
  fi

  local bashrc_target; bashrc_target=$(resolve_mutable_target "$bashrc" "$HOME/.bashrc.local" "$DOTFILES_DIR")
  if [[ -f "$bashrc_target" ]] || [[ "$bashrc_target" == "$HOME/.bashrc.local" ]] || [[ "$bashrc_target" == "$HOME/.bashrc" ]]; then
    touch "$bashrc_target"
    if ! _mise_has_activation 'mise activate bash' "$bashrc" "$bashrc_target"; then
      { echo ""; echo "# mise (unified version manager)"; echo 'eval "$(mise activate bash)"'; } >> "$bashrc_target"
      echo "✓ Added mise to ${bashrc_target/#$HOME/~}"
    else
      echo "✓ mise already configured in ${bashrc_target/#$HOME/~}"
    fi
  fi

  echo ""; echo "📦 Installing runtimes from local config (~/.mise.toml)..."
  _mise_ensure_local_config "$local_config" "$tracked_template" || true

  if [[ -f "$local_config" ]]; then
    _mise_sync_global_tracks "$local_config"
    (
      cd "$HOME"
      local libyaml_prefix openssl_prefix ruby_opts_extra=""
      libyaml_prefix="$(brew --prefix libyaml 2>/dev/null || true)"
      openssl_prefix="$(brew --prefix openssl@3 2>/dev/null || true)"
      [[ -n "$libyaml_prefix" ]] && ruby_opts_extra+=" --with-libyaml-dir=${libyaml_prefix}"
      [[ -n "$openssl_prefix" ]] && ruby_opts_extra+=" --with-openssl-dir=${openssl_prefix}"
      export RUBY_CONFIGURE_OPTS="${RUBY_CONFIGURE_OPTS:-}${ruby_opts_extra}"
      mise install
      mise reshim || true
    )
    echo "✓ Installed runtimes from ~/.mise.toml"
  else
    echo "⚠️  ~/.mise.toml not found; skipping runtime install."
  fi

  echo ""; echo "📋 Installed mise tool versions:"; mise list
  echo ""
  echo "✅ mise setup complete!"
  echo ""
  echo "Installed runtimes come from:"
  echo "  • ~/.mise.toml (bootstrapped from $tracked_template only when missing)"
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
  echo "  mise upgrade          - Upgrade installed tools within configured constraints"
  echo ""
}

cmd_gnupg() {
  echo "🔐 Setting up GnuPG (GPG)..."

  if ! command -v gpg &>/dev/null; then
    echo "❌ GPG not found. Please run 'brew bundle install' first."
    exit 1
  fi
  echo "✓ GPG found: $(gpg --version | head -n 1)"

  local gpg_dir="$HOME/.gnupg"
  if [[ ! -d "$gpg_dir" ]]; then echo "📁 Creating GPG directory at $gpg_dir..."; mkdir -p "$gpg_dir"
  else echo "✓ GPG directory already exists"; fi
  chmod 700 "$gpg_dir"

  local gpg_agent_conf="$gpg_dir/gpg-agent.conf"
  echo "📝 Configuring GPG agent..."

  local pinentry_bin; pinentry_bin="$(_gpg_find_pinentry_mac)"
  if [[ -z "$pinentry_bin" ]]; then
    echo "❌ pinentry-mac not found. Install with: brew install pinentry-mac"; exit 1
  fi
  echo "✓ Using pinentry: $pinentry_bin"

  _gpg_materialize_local_file "$gpg_agent_conf"
  touch "$gpg_agent_conf"

  local -a agent_patterns=(
    "^[[:space:]]*default-cache-ttl([[:space:]]+|$)"
    "^[[:space:]]*max-cache-ttl([[:space:]]+|$)"
    "^[[:space:]]*pinentry-program[[:space:]]+$pinentry_bin[[:space:]]*$"
  )
  local -a agent_lines=(
    "default-cache-ttl 3600"
    "max-cache-ttl 86400"
    "pinentry-program $pinentry_bin"
  )
  local needs_update=0 i
  for (( i=0; i<${#agent_patterns[@]}; i++ )); do
    grep -Eq "${agent_patterns[$i]}" "$gpg_agent_conf" || needs_update=1
  done

  if (( needs_update == 1 )); then
    local agent_snapshot; agent_snapshot="$(mktemp)"
    cp "$gpg_agent_conf" "$agent_snapshot"
    # Remove stale pinentry-program line so the correct path gets written
    sed -i '' '/^[[:space:]]*pinentry-program/d' "$gpg_agent_conf" || true
    for (( i=0; i<${#agent_patterns[@]}; i++ )); do
      _gpg_append_setting_if_missing "$gpg_agent_conf" "${agent_patterns[$i]}" "${agent_lines[$i]}" \
        && echo "✓ Added ${agent_lines[$i]%% *} to gpg-agent.conf"
    done
    _gpg_backup_if_changed "$gpg_agent_conf" "$agent_snapshot"
  else
    echo "✓ Preserving existing gpg-agent.conf settings"
  fi
  chmod 600 "$gpg_agent_conf"
  echo "✓ GPG agent configured at $gpg_agent_conf"

  local gpg_conf="$gpg_dir/gpg.conf"
  echo "📝 Configuring GPG..."
  _gpg_materialize_local_file "$gpg_conf"
  touch "$gpg_conf"

  local -a gpg_patterns=(
    "^[[:space:]]*keyid-format([[:space:]]+|$)"
    "^[[:space:]]*with-fingerprint([[:space:]]+|$)"
    "^[[:space:]]*auto-key-retrieve([[:space:]]+|$)"
    "^[[:space:]]*use-agent([[:space:]]+|$)"
  )
  local -a gpg_lines=(
    "keyid-format 0xlong"
    "with-fingerprint"
    "auto-key-retrieve"
    "use-agent"
  )
  needs_update=0
  for (( i=0; i<${#gpg_patterns[@]}; i++ )); do
    grep -Eq "${gpg_patterns[$i]}" "$gpg_conf" || needs_update=1
  done

  if (( needs_update == 1 )); then
    local gpg_snapshot; gpg_snapshot="$(mktemp)"
    cp "$gpg_conf" "$gpg_snapshot"
    for (( i=0; i<${#gpg_patterns[@]}; i++ )); do
      _gpg_append_setting_if_missing "$gpg_conf" "${gpg_patterns[$i]}" "${gpg_lines[$i]}" \
        && echo "✓ Added ${gpg_lines[$i]%% *} to gpg.conf"
    done
    _gpg_backup_if_changed "$gpg_conf" "$gpg_snapshot"
  else
    echo "✓ Preserving existing gpg.conf settings"
  fi
  chmod 600 "$gpg_conf"
  echo "✓ GPG configured at $gpg_conf"

  echo "🔄 Restarting GPG agent..."
  gpgconf --kill gpg-agent
  gpg-agent --daemon &>/dev/null || true
  echo "✓ GPG agent restarted"

  echo ""; echo "🔑 Checking for existing GPG keys..."
  local key_count; key_count=$(gpg --list-secret-keys --keyid-format LONG 2>/dev/null | grep -c "^sec" || true)
  key_count="${key_count:-0}"; key_count="${key_count//$'\n'/}"
  if (( key_count > 0 )); then
    echo "✓ Found $key_count existing GPG key(s):"; gpg --list-secret-keys --keyid-format LONG
  else
    echo "ℹ️  No GPG keys found. You can generate one with:"
    echo ""; echo "  gpg --full-generate-key"; echo ""
    echo "Recommended settings:"
    echo "  - Key type: RSA and RSA"; echo "  - Key size: 4096 bits"
    echo "  - Expiration: 1-2 years (you can extend later)"
    echo "  - Real name: Your full name"; echo "  - Email: Your GitHub/GitLab email"
  fi

  echo ""; echo "🔧 Git Integration"; echo ""
  local git_signing_key git_commit_gpgsign
  git_signing_key=$(git config --get user.signingkey 2>/dev/null || true)
  git_commit_gpgsign=$(git config --type=bool --get commit.gpgsign 2>/dev/null || true)
  if [[ -n "$git_signing_key" && "$git_commit_gpgsign" == "true" ]]; then
    echo "✓ Git commit signing is configured with GPG key: $git_signing_key"
  elif [[ -n "$git_signing_key" ]]; then
    echo "ℹ️  Git has a signing key configured: $git_signing_key"
    echo "ℹ️  Enable commit signing by default with:"
    echo "   git config --global commit.gpgsign true"
  else
    echo "ℹ️  Git is not configured for commit signing"
    echo ""; echo "To enable Git commit signing:"
    echo "  1. Get your GPG key ID:"; echo "     gpg --list-secret-keys --keyid-format LONG"; echo ""
    echo "  2. Configure Git to use your GPG key:"
    echo "     git config --global user.signingkey <YOUR_KEY_ID>"; echo ""
    echo "  3. Enable commit signing by default:"
    echo "     git config --global commit.gpgsign true"; echo ""
    echo "  4. Add your GPG public key to GitHub/GitLab:"
    echo "     gpg --armor --export <YOUR_KEY_ID>"
  fi

  echo ""; echo "🐚 Shell Integration"; echo ""
  local zshrc="$HOME/.zshrc"
  local zshrc_target; zshrc_target=$(resolve_mutable_target "$zshrc" "$HOME/.zshrc.local" "$DOTFILES_DIR")
  if [[ -f "$zshrc_target" ]] || [[ "$zshrc_target" == "$HOME/.zshrc.local" ]] || [[ "$zshrc_target" == "$HOME/.zshrc" ]]; then
    touch "$zshrc_target"
    if grep -Eq '^[[:space:]]*export[[:space:]]+GPG_TTY=' "$zshrc_target" \
       || ([[ -f "$zshrc" ]] && grep -Eq '^[[:space:]]*export[[:space:]]+GPG_TTY=' "$zshrc"); then
      echo "✓ GPG_TTY already configured in ~/.zshrc or ~/.zshrc.local"
    else
      { echo ""; echo "# GPG TTY configuration for commit signing"; echo 'export GPG_TTY=$(tty)'; } >> "$zshrc_target"
      echo "✓ Added GPG_TTY export to ${zshrc_target/#$HOME/~}"
    fi
  else
    echo "⚠️  ${zshrc/#$HOME/~} not found. You may need to add manually:"
    echo "     export GPG_TTY=\$(tty)"
  fi

  echo ""; echo "✅ GnuPG setup complete!"; echo ""
  echo "📋 What was configured:"
  echo "  ✓ GPG directory prepared at ~/.gnupg (permissions enforced)"
  echo "  ✓ GPG agent configured with pinentry-mac"
  echo "  ✓ GPG defaults ensured without overwriting custom settings"
  echo "  ✓ Shell integration checked for GPG_TTY"; echo ""
  echo "🔐 Next Steps:"; echo ""
  echo "1. Generate a new GPG key (if you don't have one):"
  echo "   gpg --full-generate-key"; echo ""
  echo "2. List your GPG keys:"
  echo "   gpg --list-secret-keys --keyid-format LONG"; echo ""
  echo "3. Configure Git to use your GPG key:"
  echo "   git config --global user.signingkey <YOUR_KEY_ID>"
  echo "   git config --global commit.gpgsign true"; echo ""
  echo "4. Export your public key for GitHub/GitLab:"
  echo "   gpg --armor --export <YOUR_KEY_ID> | pbcopy"
  echo "   (This copies it to clipboard - paste in GitHub Settings)"; echo ""
  echo "5. Test GPG signing:"
  echo "   echo 'test' | gpg --clearsign"; echo ""
  echo "📖 Useful GPG commands:"
  echo "   gpg --list-keys              # List public keys"
  echo "   gpg --list-secret-keys       # List private keys"
  echo "   gpg --delete-key <KEY_ID>    # Delete a public key"
  echo "   gpg --delete-secret-key <ID> # Delete a private key"
  echo "   gpg --edit-key <KEY_ID>      # Edit a key (change expiry, etc.)"
  echo ""
}

cmd_vscode() {
  echo "🔧 Setting up VSCode extensions..."

  if ! command -v code &>/dev/null; then
    echo "❌ VSCode CLI 'code' not found in PATH"
    echo "Please install VSCode or ensure 'code' is in your PATH"
    echo "In VSCode: Cmd+Shift+P -> 'Shell Command: Install code command in PATH'"
    exit 1
  fi
  echo "✓ VSCode CLI found: $(code --version | head -n 1)"

  local installed_exts; installed_exts="$(code --list-extensions 2>/dev/null || true)"

  local extensions=(
    ms-python.python ms-python.vscode-pylance
    golang.go
    esbenp.prettier-vscode dbaeumer.vscode-eslint ms-vscode.vscode-typescript-next
    eamodio.gitlens donjayamanne.githistory GitHub.vscode-pull-request-github github.vscode-github-actions
    ms-azuretools.vscode-docker docker.docker
    hashicorp.terraform
    amazonwebservices.aws-toolkit-vscode
    figma.figma-vscode-extension
    EditorConfig.EditorConfig christian-kohler.path-intellisense kisstkondoros.vscode-codemetrics alefragnani.project-manager
    PKief.material-icon-theme
    GitHub.copilot GitHub.copilot-chat anthropic.claude-code openai.chatgpt
  )

  local installed_count=0 skipped_count=0 failed_count=0
  local failed_extensions=()
  local tls_ca_retry=0
  [[ -z "${NODE_EXTRA_CA_CERTS:-}" && -n "${SSL_CERT_FILE:-}" && -r "${SSL_CERT_FILE:-}" ]] && tls_ca_retry=1

  echo ""; echo "📦 Installing ${#extensions[@]} extensions..."; echo ""

  local ext install_output
  for ext in "${extensions[@]}"; do
    if _vscode_is_extension_installed "$ext" "$installed_exts"; then
      echo "  ⏭️  $ext (already installed)"; skipped_count=$((skipped_count + 1))
    else
      echo "  📥 Installing $ext..."
      if install_output="$(code --install-extension "$ext" --force 2>&1)"; then
        echo "  ✓ $ext installed successfully"; installed_count=$((installed_count + 1))
      else
        if [[ "$tls_ca_retry" -eq 1 && "$install_output" == *"unable to get local issuer certificate"* ]]; then
          echo "  ↻ Retrying $ext with NODE_EXTRA_CA_CERTS from SSL_CERT_FILE..."
          if NODE_EXTRA_CA_CERTS="$SSL_CERT_FILE" code --install-extension "$ext" --force >/dev/null 2>&1; then
            echo "  ✓ $ext installed successfully (CA retry)"; installed_count=$((installed_count + 1)); continue
          fi
        fi
        echo "  ❌ Failed to install $ext"; failed_count=$((failed_count + 1)); failed_extensions+=("$ext")
      fi
    fi
  done

  echo ""; echo "📊 Installation Summary:"
  echo "  ✓ Newly installed: $installed_count"
  echo "  ⏭️  Already installed: $skipped_count"
  echo "  ❌ Failed: $failed_count"
  if [[ $failed_count -gt 0 ]]; then
    echo ""; echo "Failed extensions:"
    for ext in "${failed_extensions[@]}"; do echo "  - $ext"; done
    echo ""; echo "You can manually install failed extensions with:"
    echo "  code --install-extension <extension-id>"
  fi
  echo ""; echo "✅ VSCode setup complete!"; echo ""
  echo "💡 Tip: Enable Settings Sync in VSCode to sync extensions across machines:"
  echo "   Cmd+Shift+P -> 'Settings Sync: Turn On'"; echo ""
}

# ===========================================================================
# Dispatch
# ===========================================================================

case "$COMMAND" in
  stow)   cmd_stow  "$@" ;;
  mise)   cmd_mise  ;;
  gnupg)  cmd_gnupg ;;
  vscode) cmd_vscode ;;
  *)
    echo "Usage: $(basename "$0") [stow|mise|gnupg|vscode] [args...]" >&2
    exit 1
    ;;
esac
