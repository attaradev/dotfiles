#!/usr/bin/env bash

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
