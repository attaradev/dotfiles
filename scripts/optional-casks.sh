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

sync_optional_cask_env_vars() {
  local entry suffix brew_var bundle_var value

  for entry in "${OPTIONAL_CASK_SPECS[@]}"; do
    IFS='|' read -r suffix _ _ <<< "$entry"
    brew_var="BREW_INSTALL_${suffix}"
    bundle_var="HOMEBREW_BUNDLE_INSTALL_${suffix}"
    value="${!bundle_var:-${!brew_var:-0}}"
    export "$brew_var=$value"
    export "$bundle_var=$value"
  done
}
