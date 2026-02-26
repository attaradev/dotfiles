#!/usr/bin/env bash

set -euo pipefail

VAULT_DIR="${OBSIDIAN_VAULT_DIR:-$HOME/.knowledge}"
OBSIDIAN_CONFIG_DIR="$VAULT_DIR/.obsidian"
PLUGINS_DIR="$OBSIDIAN_CONFIG_DIR/plugins"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_LOCK_FILE="${DOTFILES_OBSIDIAN_PLUGIN_LOCK_FILE:-$DOTFILES_DIR/obsidian/community-plugin-lock.json}"

normalize_bool() {
  local raw
  raw="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')"
  case "$raw" in
    1|y|yes|true|on) echo "1" ;;
    *) echo "0" ;;
  esac
}

require_cmd() {
  local cmd=$1
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Missing required command: $cmd"
    exit 1
  fi
}

require_cmd jq

if [[ ! -d "$PLUGINS_DIR" ]]; then
  echo "ℹ No Obsidian plugin directory found at $PLUGINS_DIR"
  exit 0
fi

if [[ ! -f "$PLUGIN_LOCK_FILE" ]]; then
  echo "❌ Missing Obsidian plugin lock file: $PLUGIN_LOCK_FILE"
  exit 1
fi

if ! jq -e '.schema_version == 1 and (.plugins | type == "object")' "$PLUGIN_LOCK_FILE" >/dev/null 2>&1; then
  echo "❌ Invalid Obsidian plugin lock file format: $PLUGIN_LOCK_FILE"
  exit 1
fi

keep_ids_json="$(jq -c '.plugins | keys' "$PLUGIN_LOCK_FILE")"
dry_run="$(normalize_bool "${DOTFILES_OBSIDIAN_CLEAN_DRY_RUN:-0}")"

removed=0
kept=0

shopt -s nullglob
for path in "$PLUGINS_DIR"/*; do
  if [[ ! -d "$path" && ! -L "$path" ]]; then
    continue
  fi

  plugin_id="$(basename "$path")"
  if jq -n -e --arg id "$plugin_id" --argjson keep "$keep_ids_json" '$keep | index($id) != null' >/dev/null; then
    kept=$((kept + 1))
    continue
  fi

  if [[ "$dry_run" == "1" ]]; then
    echo "ℹ Would remove unmanaged plugin: $plugin_id"
  else
    rm -rf "$path"
    echo "✓ Removed unmanaged plugin: $plugin_id"
  fi
  removed=$((removed + 1))
done

if [[ "$dry_run" == "1" ]]; then
  echo "ℹ Obsidian plugin cleanup dry-run complete (removed=$removed kept=$kept)."
else
  echo "✓ Obsidian plugin cleanup complete (removed=$removed kept=$kept)."
fi
