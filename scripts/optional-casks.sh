#!/usr/bin/env bash

# Shared optional cask metadata.
# Format: "<SUFFIX>|<Label>|<Description>"
OPTIONAL_CASK_SPECS=(
  "ANTIGRAVITY|Antigravity|AI coding agent IDE"
  "VIRTUALBOX|VirtualBox|Full VM hypervisor"
  "BRAVE_BROWSER|Brave Browser|Privacy-focused browser"
  "VLC|VLC|Versatile media player"
  "SPOTIFY|Spotify|Music streaming client"
)

normalize_optional_cask_value() {
  local raw
  raw="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')"
  case "$raw" in
    1|y|yes|true|on) echo "1" ;;
    0|n|no|false|off) echo "0" ;;
    *) echo "0" ;;
  esac
}

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
      export "$key=$(normalize_optional_cask_value "$value")"
    fi
  done < "$env_file"
}

sync_optional_cask_env_vars() {
  local entry suffix brew_var bundle_var value

  for entry in "${OPTIONAL_CASK_SPECS[@]}"; do
    IFS='|' read -r suffix _ _ <<< "$entry"
    brew_var="BREW_INSTALL_${suffix}"
    bundle_var="HOMEBREW_BUNDLE_INSTALL_${suffix}"
    value="$(normalize_optional_cask_value "${!bundle_var:-${!brew_var:-0}}")"
    export "$brew_var=$value"
    export "$bundle_var=$value"
  done
}
