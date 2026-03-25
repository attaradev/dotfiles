#!/usr/bin/env bash
# Homebrew helpers. Usage: brew.sh [bundle|upgrade] [args...]

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=./lib.sh
source "$ROOT_DIR/scripts/lib.sh"

COMMAND="${1:-}"
shift || true

# ===========================================================================
# bundle command
# ===========================================================================

cmd_bundle() {
  local env_file="${OPTIONAL_CASK_ENV_FILE:-$HOME/.config/dotfiles/brew-optional.env}"

  if [[ -f "$env_file" ]]; then
    load_optional_cask_env_file "$env_file"
  fi

  exec brew bundle "$@"
}

# ===========================================================================
# upgrade command
# ===========================================================================

_brewup_log() {
  printf 'brewup: %s\n' "$*" >&2
}

_brewup_cleanup_sudo_session() {
  if [[ "${_BREWUP_SUDO_ASKPASS_CREATED:-0}" -eq 1 ]]; then
    unset SUDO_ASKPASS
  fi

  if [[ -z "${_BREWUP_SUDO_SESSION_DIR:-}" ]]; then
    return 0
  fi

  rm -rf "$_BREWUP_SUDO_SESSION_DIR"
  _BREWUP_SUDO_SESSION_DIR=""
}

_brewup_prompt_password() {
  local prompt="${1:-Password: }"
  local password tty_state

  tty_state="$(stty -g </dev/tty)"
  printf '%s' "$prompt" >/dev/tty
  stty -echo </dev/tty

  if ! IFS= read -r password </dev/tty; then
    stty "$tty_state" </dev/tty
    printf '\n' >/dev/tty
    return 1
  fi

  stty "$tty_state" </dev/tty
  printf '\n' >/dev/tty
  printf '%s\n' "$password"
}

_brewup_setup_askpass() {
  local password_file askpass_script password attempt

  if [[ -n "${SUDO_ASKPASS:-}" ]]; then
    sudo -A -v
    return 0
  fi

  _BREWUP_SUDO_SESSION_DIR="$(mktemp -d "${TMPDIR:-/tmp}/brewup-sudo.XXXXXX")"
  chmod 700 "$_BREWUP_SUDO_SESSION_DIR"
  password_file="$_BREWUP_SUDO_SESSION_DIR/password"
  askpass_script="$_BREWUP_SUDO_SESSION_DIR/askpass.sh"

  cat >"$askpass_script" <<EOF
#!/usr/bin/env bash
exec /bin/cat "$password_file"
EOF
  chmod 700 "$askpass_script"

  export SUDO_ASKPASS="$askpass_script"
  _BREWUP_SUDO_ASKPASS_CREATED=1

  for attempt in 1 2 3; do
    password="$(_brewup_prompt_password)"
    printf '%s\n' "$password" >"$password_file"
    chmod 600 "$password_file"
    if sudo -A -v; then return 0; fi
    _brewup_log "Incorrect password; try again."
  done

  _brewup_log "Failed to authenticate with sudo after 3 attempts."
  return 1
}

_brewup_prepare_sudo() {
  if [[ ! -t 0 || ! -t 1 ]]; then return 0; fi
  if ! command -v sudo >/dev/null 2>&1; then return 0; fi
  if sudo -n -v 2>/dev/null; then return 0; fi
  _brewup_setup_askpass
}

_brewup_is_installed_cask() {
  brew info --json=v2 --cask "$1" >/dev/null 2>&1
}

_brewup_cask_targets() {
  local token
  if [[ $# -gt 0 ]]; then
    for token in "$@"; do
      [[ "$token" == -* ]] && continue
      if _brewup_is_installed_cask "$token"; then printf '%s\n' "$token"; fi
    done
    return 0
  fi
  brew outdated --cask --greedy
}

_brewup_cask_needs_repair() {
  local token="$1" info_json installed_version brew_prefix caskroom_path app_path

  info_json="$(brew info --json=v2 --cask "$token")"
  installed_version="$(jq -r '.casks[0].installed // empty' <<<"$info_json")"

  if [[ -z "$installed_version" ]]; then return 1; fi

  brew_prefix="$(brew --prefix)"
  caskroom_path="$brew_prefix/Caskroom/$token/$installed_version"

  if [[ ! -d "$caskroom_path" ]]; then return 0; fi

  while IFS= read -r app_path; do
    [[ -z "$app_path" ]] && continue
    [[ "$app_path" != /* ]] && app_path="/Applications/$app_path"
    [[ ! -e "$app_path" ]] && return 0
  done < <(jq -r '.casks[0].artifacts[]? | .app?[]?' <<<"$info_json")

  return 1
}

_brewup_repair_cask() {
  local token="$1"
  _brewup_log "Detected broken cask state for $token; reinstalling before upgrade."
  if brew reinstall --cask "$token"; then return 0; fi
  _brewup_log "brew reinstall failed for $token; retrying with force uninstall + install."
  brew uninstall --cask --force "$token" || true
  brew install --cask "$token"
}

_brewup_fix_brew_symlink_permissions() {
  # Homebrew calls rb_readlink on managed symlinks during cask uninstall.
  # If any symlink in /usr/local/bin is not world-readable (e.g. lrwx------
  # owned by root), that syscall fails with Permission denied and the cask
  # upgrade aborts. Scan for such symlinks and chmod them to 755.
  local f
  while IFS= read -r f; do
    _brewup_log "Fixing world-unreadable symlink: $f"
    sudo chmod -h 755 "$f" || _brewup_log "Warning: could not chmod $f"
  done < <(find /usr/local/bin -maxdepth 1 -type l ! -perm -o+r 2>/dev/null)
}

_brewup_repair_broken_casks() {
  local token
  if ! command -v jq >/dev/null 2>&1; then return 0; fi
  while IFS= read -r token; do
    [[ -z "$token" ]] && continue
    if _brewup_cask_needs_repair "$token"; then _brewup_repair_cask "$token"; fi
  done < <(_brewup_cask_targets "$@")
}

cmd_upgrade() {
  if ! command -v brew >/dev/null 2>&1; then
    _brewup_log "brew is not installed."
    return 1
  fi

  _BREWUP_SUDO_SESSION_DIR=""
  _BREWUP_SUDO_ASKPASS_CREATED=0

  trap _brewup_cleanup_sudo_session EXIT
  _brewup_prepare_sudo

  _brewup_fix_brew_symlink_permissions
  _brewup_repair_broken_casks "$@"
  brew upgrade --greedy --overwrite "$@"
  brew cleanup
}

# ===========================================================================
# Dispatch
# ===========================================================================

case "$COMMAND" in
  bundle)  cmd_bundle  "$@" ;;
  upgrade) cmd_upgrade "$@" ;;
  *)
    echo "Usage: $(basename "$0") [bundle|upgrade] [args...]" >&2
    exit 1
    ;;
esac
