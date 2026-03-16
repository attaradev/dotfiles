#!/usr/bin/env bash
# Shared utility functions sourced by setup scripts.

# ---------------------------------------------------------------------------
# General utilities
# ---------------------------------------------------------------------------

# Normalise a boolean-ish string to "1" or "0".
normalize_bool() {
  local raw
  raw="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')"
  case "$raw" in
    1|y|yes|true|on) echo "1" ;;
    *) echo "0" ;;
  esac
}

# Exit with an error if a required command is not on PATH.
require_cmd() {
  local cmd=$1
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Missing required command: $cmd"
    exit 1
  fi
}

# Return the path that should be written to: if $primary is a symlink or lives
# inside the dotfiles dir, return $fallback (a local untracked copy); otherwise
# return $primary unchanged.
resolve_mutable_target() {
  local primary="$1"
  local fallback="$2"
  local dotfiles_dir="${3:-}"

  if [[ -L "$primary" ]] || [[ -n "$dotfiles_dir" && "$primary" == "$dotfiles_dir"* ]]; then
    printf '%s\n' "$fallback"
  else
    printf '%s\n' "$primary"
  fi
}

# ---------------------------------------------------------------------------
# Optional Homebrew cask management
# ---------------------------------------------------------------------------

# Metadata for optional casks. Format: "<SUFFIX>|<Label>|<Description>"
OPTIONAL_CASK_SPECS=(
  "ANTIGRAVITY|Antigravity|AI coding agent IDE"
  "VIRTUALBOX|VirtualBox|Full VM hypervisor"
  "BRAVE_BROWSER|Brave Browser|Privacy-focused browser"
  "VLC|VLC|Versatile media player"
  "SPOTIFY|Spotify|Music streaming client"
)

# Load optional cask preferences from an env file, exporting only recognised
# BREW_INSTALL_* / HOMEBREW_BUNDLE_INSTALL_* keys with normalised values.
load_optional_cask_env_file() {
  local env_file="${1:-}"
  local line key value entry suffix brew_var bundle_var allowed

  [[ -n "$env_file" && -f "$env_file" ]] || return 0

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -n "$line" ]] || continue

    if [[ "$line" =~ ^export[[:space:]]+([A-Z0-9_]+)=(.*)$ ]]; then
      key="${BASH_REMATCH[1]}"
      value="${BASH_REMATCH[2]}"
    elif [[ "$line" =~ ^([A-Z0-9_]+)=(.*)$ ]]; then
      key="${BASH_REMATCH[1]}"
      value="${BASH_REMATCH[2]}"
    else
      continue
    fi

    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"

    allowed=0
    for entry in "${OPTIONAL_CASK_SPECS[@]}"; do
      IFS='|' read -r suffix _ _ <<< "$entry"
      brew_var="BREW_INSTALL_${suffix}"
      bundle_var="HOMEBREW_BUNDLE_INSTALL_${suffix}"
      if [[ "$key" == "$brew_var" || "$key" == "$bundle_var" ]]; then
        allowed=1
        break
      fi
    done

    if [[ "$allowed" == "1" ]]; then
      export "$key=$(normalize_bool "$value")"
    fi
  done < "$env_file"
}

# Sync BREW_INSTALL_* and HOMEBREW_BUNDLE_INSTALL_* pairs to a consistent
# normalised value, so both naming conventions agree.
sync_optional_cask_env_vars() {
  local entry suffix brew_var bundle_var value

  for entry in "${OPTIONAL_CASK_SPECS[@]}"; do
    IFS='|' read -r suffix _ _ <<< "$entry"
    brew_var="BREW_INSTALL_${suffix}"
    bundle_var="HOMEBREW_BUNDLE_INSTALL_${suffix}"
    value="$(normalize_bool "${!bundle_var:-${!brew_var:-0}}")"
    export "$brew_var=$value"
    export "$bundle_var=$value"
  done
}
