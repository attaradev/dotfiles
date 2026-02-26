#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="${1:-$DOTFILES_DIR/obsidian/community-plugin-lock.json}"

require_cmd() {
  local cmd=$1
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Missing required command: $cmd"
    exit 1
  fi
}

require_cmd curl
require_cmd jq
require_cmd shasum

plugins=(
  "auto-classifier|HyeonseoNam/auto-classifier"
  "templater-obsidian|SilentVoid13/Templater"
  "quickadd|chhoumann/quickadd"
  "dataview|blacksmithgu/obsidian-dataview"
  "metadata-menu|mdelobelle/metadatamenu"
  "obsidian-tasks-plugin|obsidian-tasks-group/obsidian-tasks"
  "periodic-notes|liamcain/obsidian-periodic-notes"
  "calendar|liamcain/obsidian-calendar-plugin"
  "obsidian-kanban|mgmeyers/obsidian-kanban"
  "obsidian-linter|platers/obsidian-linter"
  "omnisearch|scambier/obsidian-omnisearch"
)

curl_common=(
  --fail
  --silent
  --show-error
  --location
  --retry 3
  --retry-delay 1
  --retry-all-errors
)

auth_config_file=""
tmp_lock_file=""

cleanup() {
  [[ -n "$auth_config_file" ]] && rm -f "$auth_config_file"
  [[ -n "$tmp_lock_file" ]] && rm -f "$tmp_lock_file" "${tmp_lock_file}.new"
}
trap cleanup EXIT

resolve_github_token() {
  if [[ -n "${GITHUB_TOKEN_FILE:-}" ]]; then
    if [[ ! -r "$GITHUB_TOKEN_FILE" ]]; then
      echo "❌ GITHUB_TOKEN_FILE is not readable: $GITHUB_TOKEN_FILE"
      exit 1
    fi
    head -n 1 "$GITHUB_TOKEN_FILE"
    return
  fi

  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    printf '%s\n' "$GITHUB_TOKEN"
  fi
}

configure_auth() {
  local token
  token="$(resolve_github_token || true)"
  token="${token%%[[:space:]]*}"

  if [[ -z "$token" ]]; then
    return 0
  fi

  auth_config_file="$(mktemp)"
  chmod 600 "$auth_config_file"
  printf 'header = "Authorization: Bearer %s"\n' "$token" > "$auth_config_file"
}

curl_fetch() {
  local url=$1
  if [[ -n "$auth_config_file" ]]; then
    curl "${curl_common[@]}" --config "$auth_config_file" "$url"
  else
    curl "${curl_common[@]}" "$url"
  fi
}

download_to_file() {
  local url=$1
  local output=$2
  if [[ -n "$auth_config_file" ]]; then
    curl "${curl_common[@]}" --config "$auth_config_file" "$url" --output "$output"
  else
    curl "${curl_common[@]}" "$url" --output "$output"
  fi
}

hash_url() {
  local url=$1
  local tmp_file
  tmp_file="$(mktemp)"
  download_to_file "$url" "$tmp_file"
  shasum -a 256 "$tmp_file" | awk '{print tolower($1)}'
  rm -f "$tmp_file"
}

configure_auth

tmp_lock_file="$(mktemp)"

jq -n '
  {
    schema_version: 1,
    plugins: {}
  }
' > "$tmp_lock_file"

for spec in "${plugins[@]}"; do
  IFS='|' read -r plugin_id repo <<< "$spec"
  echo "🔒 Resolving lock entry for $plugin_id ($repo)..."

  release_json="$(curl_fetch "https://api.github.com/repos/$repo/releases/latest")"

  tag_name="$(printf '%s' "$release_json" | jq -r '.tag_name // empty')"
  release_id="$(printf '%s' "$release_json" | jq -r '.id // empty')"

  manifest_url="$(printf '%s' "$release_json" | jq -r '.assets[]? | select(.name=="manifest.json") | .browser_download_url' | head -n1)"
  main_url="$(printf '%s' "$release_json" | jq -r '.assets[]? | select(.name=="main.js") | .browser_download_url' | head -n1)"
  styles_url="$(printf '%s' "$release_json" | jq -r '.assets[]? | select(.name=="styles.css") | .browser_download_url' | head -n1)"

  if [[ -z "$manifest_url" && -n "$tag_name" ]]; then
    manifest_url="https://raw.githubusercontent.com/$repo/$tag_name/manifest.json"
  fi
  if [[ -z "$main_url" && -n "$tag_name" ]]; then
    main_url="https://raw.githubusercontent.com/$repo/$tag_name/main.js"
  fi

  if [[ -z "$manifest_url" || -z "$main_url" ]]; then
    echo "❌ Failed to resolve mandatory assets for $plugin_id ($repo)"
    exit 1
  fi

  manifest_sha="$(hash_url "$manifest_url")"
  main_sha="$(hash_url "$main_url")"

  styles_sha=""
  if [[ -n "$styles_url" ]]; then
    styles_sha="$(hash_url "$styles_url")"
  fi

  entry_json="$(jq -n \
    --arg repo "$repo" \
    --arg tag "$tag_name" \
    --arg release_id "$release_id" \
    --arg manifest_url "$manifest_url" \
    --arg manifest_sha "$manifest_sha" \
    --arg main_url "$main_url" \
    --arg main_sha "$main_sha" \
    --arg styles_url "$styles_url" \
    --arg styles_sha "$styles_sha" \
    '
      {
        repo: $repo,
        tag: $tag,
        release_id: $release_id,
        assets: {
          "manifest.json": {
            url: $manifest_url,
            sha256: $manifest_sha
          },
          "main.js": {
            url: $main_url,
            sha256: $main_sha
          }
        }
      }
      | if ($styles_url | length) > 0 then
          .assets["styles.css"] = {
            url: $styles_url,
            sha256: $styles_sha
          }
        else
          .
        end
    ')"

  jq --arg id "$plugin_id" --argjson entry "$entry_json" '.plugins[$id] = $entry' "$tmp_lock_file" > "${tmp_lock_file}.new"
  mv "${tmp_lock_file}.new" "$tmp_lock_file"
done

mkdir -p "$(dirname "$LOCK_FILE")"
jq -S . "$tmp_lock_file" > "$LOCK_FILE"

echo "✅ Wrote Obsidian plugin lock file: $LOCK_FILE"
