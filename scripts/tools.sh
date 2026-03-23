#!/usr/bin/env bash
# Individual tool setup. Usage: tools.sh [stow|mise|gnupg|vscode] [args...]

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STOW_PACKAGES_FILE="$DOTFILES_DIR/scripts/stow-packages.txt"
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

_mise_add_shell_activation() {
  local shell="$1" rc_file="$2" local_fallback="$3" added_var="$4" ok_var="$5"
  local target; target=$(resolve_mutable_target "$rc_file" "$local_fallback" "$DOTFILES_DIR")
  [[ -f "$target" ]] || [[ "$target" == "$local_fallback" ]] || [[ "$target" == "$rc_file" ]] || return 0
  touch "$target"
  if _mise_has_activation "mise activate $shell" "$rc_file" "$target"; then
    eval "${ok_var}+=(\"\$shell\")"
  else
    { echo ""; echo "# mise (unified version manager)"; echo "eval \"\$(mise activate $shell)\""; } >> "$target"
    eval "${added_var}+=(\"\$shell\")"
  fi
}

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
  if [[ -f "$local_config" ]]; then return 0; fi
  if [[ -f "$tracked_template" ]]; then
    cp "$tracked_template" "$local_config"
    echo "✓ Created ~/.mise.toml from tracked template at $tracked_template"
    return 0
  fi
  echo "⚠️  $tracked_template not found; could not bootstrap ~/.mise.toml."
  return 1
}

_mise_sync_global_tracks() {
  local config_path="$1"
  if [[ ! -f "$config_path" ]]; then return 0; fi
  local specs=() tool track
  while IFS=$'\t' read -r tool track; do
    [[ -n "$tool" && -n "$track" ]] && specs+=("${tool}@${track}")
  done < <(mise_extract_tool_tracks "$config_path")
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

_gpg_append_setting_if_missing() {
  local file="$1" pattern="$2" line="$3"
  if grep -Eq "$pattern" "$file"; then return 0; fi
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

  local default_packages=()
  local package_name
  if [[ -f "$STOW_PACKAGES_FILE" ]]; then
    while IFS= read -r package_name || [[ -n "$package_name" ]]; do
      [[ -n "$package_name" ]] && default_packages+=("$package_name")
    done < "$STOW_PACKAGES_FILE"
  fi
  if (( ${#default_packages[@]} == 0 )); then
    echo "❌ No stow packages configured in $STOW_PACKAGES_FILE"
    exit 1
  fi
  local packages full_run
  if [[ "$#" -gt 0 ]]; then
    packages=("$@"); full_run=0
    echo "ℹ️  Targeted stow run for packages: ${packages[*]}"
  else
    packages=("${default_packages[@]}"); full_run=1
  fi

  local has_gpg=0 has_ssh=0
  printf '%s\n' "${packages[@]}" | grep -Fxq "gpg" && [[ -d "$DOTFILES_DIR/gpg" ]] && has_gpg=1
  printf '%s\n' "${packages[@]}" | grep -Fxq "ssh" && [[ -d "$DOTFILES_DIR/ssh" ]] && has_ssh=1

  # Determine skip_gpg BEFORE backup so materialized local files are detected correctly
  local skip_gpg=0
  if (( has_gpg )); then
    if [[ -e "$HOME/.gnupg/gpg-agent.conf" && ! -L "$HOME/.gnupg/gpg-agent.conf" ]] || \
       [[ -e "$HOME/.gnupg/gpg.conf" && ! -L "$HOME/.gnupg/gpg.conf" ]]; then
      skip_gpg=1
    fi
  fi

  local pkg
  for pkg in "${packages[@]}"; do
    [[ "$pkg" == "gpg" && "$skip_gpg" == "1" ]] && continue
    _stow_backup_package_files "$pkg"
  done

  if (( has_ssh )); then
    _stow_ensure_dir "$HOME/.ssh" 700
    _stow_ensure_dir "$HOME/.ssh/sockets" 700
  fi
  if (( has_gpg )); then
    _stow_ensure_dir "$HOME/.gnupg" 700
  fi

  if [[ "$full_run" == "1" ]] && [[ -d "$DOTFILES_DIR/obsidian" ]]; then
    _stow_ensure_knowledge_dir
  fi

  local stowed=() skipped=()
  for pkg in "${packages[@]}"; do
    if [[ "$pkg" == "gpg" && "$skip_gpg" == "1" ]]; then
      skipped+=("$pkg"); continue
    fi
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
      local stow_args=(--target="$HOME" --restow)
      [[ "$pkg" == "obsidian" ]] && stow_args+=(--no-folding)
      stow "$pkg" "${stow_args[@]}" 2>&1 | grep -v "^LINK:\|^UNLINK:" || true
      stowed+=("$pkg")
    else
      echo "  ⚠️  Package '$pkg' not found, skipping..."
      skipped+=("$pkg")
    fi
  done

  if [[ ${#stowed[@]} -gt 0 ]]; then
    local joined; joined=$(printf '%s · ' "${stowed[@]}"); joined="${joined% · }"
    echo "✓ $joined"
  fi
}

cmd_mise() {
  local local_config="$HOME/.mise.toml"
  local tracked_template="$DOTFILES_DIR/mise/.mise.toml"

  if command -v mise &>/dev/null; then
    echo "✓ mise $(mise --version | awk '{print $1}')"
  else
    echo "❌ mise not found — run: brew bundle install"
    exit 1
  fi

  local shells_added=() shells_ok=()
  _mise_add_shell_activation zsh  "$HOME/.zshrc"  "$HOME/.zshrc.local"  shells_added shells_ok
  _mise_add_shell_activation bash "$HOME/.bashrc" "$HOME/.bashrc.local" shells_added shells_ok

  if [[ ${#shells_added[@]} -gt 0 ]]; then
    echo "✓ Added mise activation to: ${shells_added[*]}"
  fi

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
      mise install 2>&1 || true
      mise reshim || true
    )
    echo "✓ tools installed"
  else
    echo "⚠️  ~/.mise.toml not found; skipping runtime install."
  fi
}

cmd_gnupg() {
  if ! command -v gpg &>/dev/null; then
    echo "❌ GPG not found. Please run 'brew bundle install' first."
    exit 1
  fi

  local gpg_dir="$HOME/.gnupg"
  if [[ ! -d "$gpg_dir" ]]; then echo "📁 Creating GPG directory at $gpg_dir..."; mkdir -p "$gpg_dir"; fi
  chmod 700 "$gpg_dir"

  local gpg_agent_conf="$gpg_dir/gpg-agent.conf"

  local pinentry_bin; pinentry_bin="$(_gpg_find_pinentry_mac)"
  if [[ -z "$pinentry_bin" ]]; then
    echo "❌ pinentry-mac not found — run: brew install pinentry-mac"; exit 1
  fi

  if materialize_local_file "$gpg_agent_conf"; then
    echo "🔁 Replacing symlinked $(basename "$gpg_agent_conf") with a local machine-specific file"
  fi
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

  local agent_updated=0
  if (( needs_update == 1 )); then
    agent_updated=1
    local agent_snapshot; agent_snapshot="$(mktemp)"
    cp "$gpg_agent_conf" "$agent_snapshot"
    # Remove stale pinentry-program line so the correct path gets written
    remove_lines_matching_regex "$gpg_agent_conf" '^[[:space:]]*pinentry-program([[:space:]]+|$)' || true
    for (( i=0; i<${#agent_patterns[@]}; i++ )); do
      _gpg_append_setting_if_missing "$gpg_agent_conf" "${agent_patterns[$i]}" "${agent_lines[$i]}"
    done
    _gpg_backup_if_changed "$gpg_agent_conf" "$agent_snapshot"
  fi
  chmod 600 "$gpg_agent_conf"

  local gpg_conf="$gpg_dir/gpg.conf"
  if materialize_local_file "$gpg_conf"; then
    echo "🔁 Replacing symlinked $(basename "$gpg_conf") with a local machine-specific file"
  fi
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

  local gpg_updated=0
  if (( needs_update == 1 )); then
    gpg_updated=1
    local gpg_snapshot; gpg_snapshot="$(mktemp)"
    cp "$gpg_conf" "$gpg_snapshot"
    for (( i=0; i<${#gpg_patterns[@]}; i++ )); do
      _gpg_append_setting_if_missing "$gpg_conf" "${gpg_patterns[$i]}" "${gpg_lines[$i]}"
    done
    _gpg_backup_if_changed "$gpg_conf" "$gpg_snapshot"
  fi
  chmod 600 "$gpg_conf"

  if (( agent_updated || gpg_updated )); then
    echo "✓ GPG config updated"
  else
    echo "✓ GPG config up to date"
  fi

  gpgconf --kill gpg-agent
  gpg-agent --daemon &>/dev/null || true

  local zshrc="$HOME/.zshrc"
  local zshrc_target; zshrc_target=$(resolve_mutable_target "$zshrc" "$HOME/.zshrc.local" "$DOTFILES_DIR")
  if [[ -f "$zshrc_target" ]] || [[ "$zshrc_target" == "$HOME/.zshrc.local" ]] || [[ "$zshrc_target" == "$HOME/.zshrc" ]]; then
    touch "$zshrc_target"
    if ! grep -Eq '^[[:space:]]*export[[:space:]]+GPG_TTY=' "$zshrc_target" \
       && ! ([[ -f "$zshrc" ]] && grep -Eq '^[[:space:]]*export[[:space:]]+GPG_TTY=' "$zshrc"); then
      { echo ""; echo "# GPG TTY configuration for commit signing"; echo 'export GPG_TTY=$(tty)'; } >> "$zshrc_target"
      echo "✓ Added GPG_TTY export to ${zshrc_target/#$HOME/~}"
    fi
  fi

  local git_signing_key git_commit_gpgsign
  git_signing_key=$(git config --get user.signingkey 2>/dev/null || true)
  git_commit_gpgsign=$(git config --type=bool --get commit.gpgsign 2>/dev/null || true)
  if [[ -z "$git_signing_key" ]]; then
    echo "⚠️  Git commit signing not configured (run: git config --global user.signingkey <KEY_ID>)"
  elif [[ "$git_commit_gpgsign" != "true" ]]; then
    echo "⚠️  Signing key set but gpgsign disabled (run: git config --global commit.gpgsign true)"
  fi
}

cmd_vscode() {
  if ! command -v code &>/dev/null; then
    echo "❌ VSCode CLI 'code' not found in PATH"
    echo "In VSCode: Cmd+Shift+P -> 'Shell Command: Install code command in PATH'"
    exit 1
  fi

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

  local ext install_output
  for ext in "${extensions[@]}"; do
    if _vscode_is_extension_installed "$ext" "$installed_exts"; then
      skipped_count=$((skipped_count + 1))
    else
      echo "  📥 Installing $ext..."
      if install_output="$(code --install-extension "$ext" --force 2>&1)"; then
        echo "  ✓ $ext installed"; installed_count=$((installed_count + 1))
      else
        if [[ "$tls_ca_retry" -eq 1 && "$install_output" == *"unable to get local issuer certificate"* ]]; then
          echo "  ↻ Retrying $ext with NODE_EXTRA_CA_CERTS..."
          if NODE_EXTRA_CA_CERTS="$SSL_CERT_FILE" code --install-extension "$ext" --force >/dev/null 2>&1; then
            echo "  ✓ $ext installed (CA retry)"; installed_count=$((installed_count + 1)); continue
          fi
        fi
        echo "  ❌ Failed to install $ext"; failed_count=$((failed_count + 1)); failed_extensions+=("$ext")
      fi
    fi
  done

  local summary="✓ $skipped_count extensions installed"
  [[ $installed_count -gt 0 ]] && summary+=" · $installed_count newly added"
  [[ $failed_count -gt 0 ]] && summary+=" · $failed_count failed"
  echo "$summary"
  if [[ $failed_count -gt 0 ]]; then
    echo "  Failed: ${failed_extensions[*]}"
    echo "  To retry: code --install-extension <extension-id>"
  fi
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
