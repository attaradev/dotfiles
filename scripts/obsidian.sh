#!/usr/bin/env bash

set -euo pipefail

VAULT_DIR="${OBSIDIAN_VAULT_DIR:-$HOME/.knowledge}"
OBSIDIAN_CONFIG_DIR="$VAULT_DIR/.obsidian"
PLUGINS_DIR="$OBSIDIAN_CONFIG_DIR/plugins"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLIC_VAULT_SOURCE_DIR="$DOTFILES_DIR/obsidian/.knowledge"
PLUGIN_LOCK_FILE="${DOTFILES_OBSIDIAN_PLUGIN_LOCK_FILE:-$DOTFILES_DIR/obsidian/community-plugin-lock.json}"
TEMPLATES_FOLDER="_templates"
VISIBLE_VAULT_ALIAS="${OBSIDIAN_VISIBLE_VAULT_ALIAS:-$HOME/Knowledge}"
# shellcheck source=./lib.sh
source "$DOTFILES_DIR/scripts/lib.sh"

COMMAND="${1:-setup}"
require_cmd jq

remove_path_if_exists() {
  local target=$1
  if [[ ! -e "$target" ]]; then
    return 0
  fi
  rm -rf "$target"
}

ensure_local_vault_directory() {
  local backup_dir

  if [[ -L "$VAULT_DIR" ]]; then
    backup_dir="${VAULT_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
    print_warning "Converting symlinked vault path to a local directory: $VAULT_DIR"
    mkdir -p "$backup_dir"
    cp -a "$VAULT_DIR/." "$backup_dir/" 2>/dev/null || true
    rm "$VAULT_DIR"
    mkdir -p "$VAULT_DIR"
    cp -a "$backup_dir/." "$VAULT_DIR/" 2>/dev/null || true
    print_info "Created vault backup from symlink target at: $backup_dir"
    return 0
  fi

  if [[ -e "$VAULT_DIR" && ! -d "$VAULT_DIR" ]]; then
    echo "❌ Obsidian vault path exists but is not a directory: $VAULT_DIR"
    exit 1
  fi

  mkdir -p "$VAULT_DIR"
}

obsidian_global_config_file() {
  local app_config_dir

  if [[ -n "${OBSIDIAN_APP_CONFIG_DIR:-}" ]]; then
    app_config_dir="$OBSIDIAN_APP_CONFIG_DIR"
  else
    case "${OSTYPE:-}" in
      darwin*)
        app_config_dir="$HOME/Library/Application Support/obsidian"
        ;;
      linux*)
        app_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/obsidian"
        ;;
      *)
        print_warning "Skipping Obsidian UI vault registration on unsupported OS: ${OSTYPE:-unknown}"
        return 1
        ;;
    esac
  fi

  printf '%s\n' "$app_config_dir/obsidian.json"
}

ensure_visible_vault_alias() {
  local alias_path=$1
  local vault_real alias_real

  [[ -n "$alias_path" ]] || return 1

  vault_real="$(cd "$VAULT_DIR" && pwd -P)"
  alias_path="${alias_path/#\~/$HOME}"

  if [[ "$alias_path" == "$VAULT_DIR" ]]; then
    return 1
  fi

  if [[ -e "$alias_path" ]]; then
    if [[ -L "$alias_path" ]]; then
      if alias_real="$(cd "$alias_path" && pwd -P 2>/dev/null)" && [[ "$alias_real" == "$vault_real" ]]; then
        printf '%s\n' "$alias_path"
        return 0
      fi
      print_warning "Visible vault alias points elsewhere, skipping: $alias_path" >&2
      return 1
    fi

    if [[ -d "$alias_path" ]]; then
      if alias_real="$(cd "$alias_path" && pwd -P 2>/dev/null)" && [[ "$alias_real" == "$vault_real" ]]; then
        printf '%s\n' "$alias_path"
        return 0
      fi
    fi

    print_warning "Visible vault alias path exists and is not managed, skipping: $alias_path" >&2
    return 1
  fi

  mkdir -p "$(dirname "$alias_path")"
  ln -s "$VAULT_DIR" "$alias_path"
  print_success "Created visible vault alias: $alias_path -> $VAULT_DIR" >&2
  printf '%s\n' "$alias_path"
  return 0
}

register_vault_with_obsidian_ui() {
  local global_file global_dir canonical_vault_path ui_vault_path
  local existing_id existing_path existing_path_real
  local key path vault_id now_ts suffix tmp_file

  if ! global_file="$(obsidian_global_config_file)"; then
    return 0
  fi

  global_dir="$(dirname "$global_file")"
  mkdir -p "$global_dir"
  canonical_vault_path="$(cd "$VAULT_DIR" && pwd -P)"
  ui_vault_path="$canonical_vault_path"

  if ui_vault_path="$(ensure_visible_vault_alias "$VISIBLE_VAULT_ALIAS")"; then
    :
  else
    ui_vault_path="$canonical_vault_path"
  fi

  if [[ -f "$global_file" ]]; then
    if ! jq -e 'type == "object"' "$global_file" >/dev/null 2>&1; then
      print_warning "Skipping Obsidian UI vault registration; invalid global config: $global_file"
      return 0
    fi

    while IFS=$'\t' read -r key path; do
      [[ -n "$key" ]] || continue
      [[ -n "$path" ]] || continue

      if [[ "$path" == "$ui_vault_path" ]]; then
        existing_id="$key"
        existing_path="$path"
        break
      fi

      if existing_path_real="$(cd "$path" 2>/dev/null && pwd -P)"; then
        if [[ "$existing_path_real" == "$canonical_vault_path" ]]; then
          existing_id="$key"
          existing_path="$path"
          break
        fi
      fi
    done < <(jq -r '.vaults // {} | to_entries[]? | "\(.key)\t\(.value.path // "")"' "$global_file")
  fi

  if [[ -n "${existing_id:-}" ]]; then
    if [[ "$existing_path" == "$ui_vault_path" ]]; then
      return 0
    fi

    tmp_file="$(mktemp)"
    jq --arg id "$existing_id" --arg path "$ui_vault_path" \
      '.vaults = (.vaults // {}) | .vaults[$id].path = $path' \
      "$global_file" >"$tmp_file"

    if replace_file_if_changed "$tmp_file" "$global_file"; then
      print_success "Updated Obsidian UI vault path: $existing_path -> $ui_vault_path"
    else
      : # vault already registered
    fi
    return 0
  fi

  now_ts="$(date +%s)"
  vault_id="vault-${now_ts}"
  suffix=0

  if [[ -f "$global_file" ]]; then
    while jq -e --arg id "$vault_id" '.vaults // {} | has($id)' "$global_file" >/dev/null 2>&1; do
      suffix=$((suffix + 1))
      vault_id="vault-${now_ts}-${suffix}"
    done
  fi

  tmp_file="$(mktemp)"
  if [[ -f "$global_file" ]]; then
    jq --arg id "$vault_id" --arg path "$ui_vault_path" --argjson ts "$now_ts" \
      '.vaults = (.vaults // {}) | .vaults[$id] = {path: $path, ts: $ts}' \
      "$global_file" >"$tmp_file"
  else
    jq -n --arg id "$vault_id" --arg path "$ui_vault_path" --argjson ts "$now_ts" \
      '{vaults: {($id): {path: $path, ts: $ts}}}' >"$tmp_file"
  fi

  if replace_file_if_changed "$tmp_file" "$global_file"; then
    print_success "Registered Knowledge vault in Obsidian UI list: $ui_vault_path"
  else
    print_info "Obsidian UI vault registration already up to date: $ui_vault_path"
  fi
}

seed_public_vault_file_if_missing() {
  local rel_path="$1"
  copy_file_if_missing "$VAULT_DIR/$rel_path" "$PUBLIC_VAULT_SOURCE_DIR/$rel_path"
}

seed_vault_files() {
  local source_file rel_path

  if [[ ! -d "$PUBLIC_VAULT_SOURCE_DIR" ]]; then
    print_warning "Public vault seed directory not found: $PUBLIC_VAULT_SOURCE_DIR"
    return 1
  fi

  mkdir -p "$VAULT_DIR"

  while IFS= read -r source_file; do
    rel_path="${source_file#"$PUBLIC_VAULT_SOURCE_DIR/"}"
    seed_public_vault_file_if_missing "$rel_path"
  done < <(find "$PUBLIC_VAULT_SOURCE_DIR" -type f | sort)
}

seed_local_vault_note_if_missing() {
  local rel_path="$1"
  local title="$2"
  local description="$3"
  local target="$VAULT_DIR/$rel_path"

  if [[ -e "$target" ]]; then
    return 0
  fi

  mkdir -p "$(dirname "$target")"
  cat >"$target" <<EOF
# $title

$description
EOF
}

seed_local_vault_defaults() {
  seed_local_vault_note_if_missing \
    "tasks.md" \
    "Active Tasks" \
    "Capture current priorities, next actions, blockers, and follow-ups here."
  seed_local_vault_note_if_missing \
    "projects/projects.md" \
    "Projects Tracker" \
    "Track active projects, current status, and the next milestone for each effort."
  seed_local_vault_note_if_missing \
    "reading/books.md" \
    "Books Tracker" \
    "Track books to read, in progress, and finished reading notes."
  seed_local_vault_note_if_missing \
    "reading/articles.md" \
    "Articles Tracker" \
    "Capture articles to review, summarize, and revisit later."
  seed_local_vault_note_if_missing \
    "learning/courses.md" \
    "Courses Tracker" \
    "Track active courses, progress, and the next lesson to complete."
  seed_local_vault_note_if_missing \
    "learning/studies.md" \
    "Study Log" \
    "Capture focused study sessions, topics covered, and key takeaways."
  seed_local_vault_note_if_missing \
    "learning/lessons.md" \
    "Lessons Learned" \
    "Record mistakes, decisions, and rules to reuse in future work."
  seed_local_vault_note_if_missing \
    "career/achievement-log.md" \
    "Achievement Log" \
    "Capture outcomes, impact, and evidence for reviews, resumes, and retrospectives."
  seed_local_vault_note_if_missing \
    "career/achievement-inbox.md" \
    "Achievement Inbox" \
    "Capture raw wins, impact snippets, and metrics before promoting them to the log."
  seed_local_vault_note_if_missing \
    "setup/claude-activity-log.md" \
    "Claude Activity Log" \
    "Capture notable Claude sessions, outcomes, and follow-up items."
  seed_local_vault_note_if_missing \
    "setup/codex-activity-log.md" \
    "Codex Activity Log" \
    "Capture notable Codex sessions, outcomes, and follow-up items."
}

write_array_union() {
  local file=$1
  shift
  local tmp_file values_json
  tmp_file="$(mktemp)"

  values_json="$(
    printf '%s\n' "$@" \
      | jq -R . \
      | jq -s 'map(select(length > 0)) | unique'
  )"

  if [[ -f "$file" ]] && jq -e 'type == "array"' "$file" >/dev/null 2>&1; then
    jq -n --slurpfile existing "$file" --argjson add "$values_json" '$existing[0] + $add | unique' >"$tmp_file"
  else
    jq -n --argjson add "$values_json" '$add | unique' >"$tmp_file"
  fi

  replace_file_if_changed "$tmp_file" "$file" >/dev/null || true
}

write_array_without_values() {
  local file=$1
  shift
  local tmp_file remove_json
  tmp_file="$(mktemp)"

  remove_json="$(
    printf '%s\n' "$@" \
      | jq -R . \
      | jq -s 'map(select(length > 0)) | unique'
  )"

  if [[ -f "$file" ]] && jq -e 'type == "array"' "$file" >/dev/null 2>&1; then
    jq --argjson remove "$remove_json" \
      '[ .[] as $id | select(($remove | index($id)) == null) | $id ]' \
      "$file" >"$tmp_file"
  else
    jq -n '[]' >"$tmp_file"
  fi

  replace_file_if_changed "$tmp_file" "$file" >/dev/null || true
}

configure_core_plugins() {
  local file="$OBSIDIAN_CONFIG_DIR/core-plugins.json"
  local tmp_file required_json
  tmp_file="$(mktemp)"

  required_json="$(
    printf '%s\n' "$@" \
      | jq -R . \
      | jq -s 'map(select(length > 0)) | unique'
  )"

  if [[ -f "$file" ]] && jq -e 'type == "object"' "$file" >/dev/null 2>&1; then
    jq --argjson required "$required_json" \
      'reduce $required[] as $id (. ; .[$id] = true)' \
      "$file" >"$tmp_file"
  elif [[ -f "$file" ]] && jq -e 'type == "array"' "$file" >/dev/null 2>&1; then
    jq -n --slurpfile existing "$file" --argjson required "$required_json" \
      '$existing[0] + $required | unique' >"$tmp_file"
  else
    jq -n --argjson required "$required_json" \
      'reduce $required[] as $id ({}; .[$id] = true)' >"$tmp_file"
  fi

  replace_file_if_changed "$tmp_file" "$file" >/dev/null || true
}

configure_templates_settings() {
  local file="$OBSIDIAN_CONFIG_DIR/templates.json"
  local tmp_file
  tmp_file="$(mktemp)"
  mkdir -p "$OBSIDIAN_CONFIG_DIR"

  if [[ -f "$file" ]] && jq -e 'type == "object"' "$file" >/dev/null 2>&1; then
    jq --arg folder "$TEMPLATES_FOLDER" '.folder = $folder' "$file" >"$tmp_file"
  else
    jq -n --arg folder "$TEMPLATES_FOLDER" '{"folder": $folder}' >"$tmp_file"
  fi

  replace_file_if_changed "$tmp_file" "$file" >/dev/null || true
}

configure_dataview_plugin() {
  local file="$PLUGINS_DIR/dataview/data.json"
  local tmp_file
  tmp_file="$(mktemp)"
  mkdir -p "$(dirname "$file")"

  if [[ -f "$file" ]] && jq -e 'type == "object"' "$file" >/dev/null 2>&1; then
    jq '.enableDataviewJs = true | .enableInlineDataviewJs = true' "$file" >"$tmp_file"
  else
    jq -n '{"enableDataviewJs": true, "enableInlineDataviewJs": true}' >"$tmp_file"
  fi

  replace_file_if_changed "$tmp_file" "$file" >/dev/null || true
}

configure_metadata_menu_plugin() {
  local file="$PLUGINS_DIR/metadata-menu/data.json"
  local tmp_file
  tmp_file="$(mktemp)"
  mkdir -p "$(dirname "$file")"

  if [[ -f "$file" ]] && jq -e 'type == "object"' "$file" >/dev/null 2>&1; then
    jq '.disableDataviewPrompt = true' "$file" >"$tmp_file"
  else
    jq -n '{"disableDataviewPrompt": true}' >"$tmp_file"
  fi

  replace_file_if_changed "$tmp_file" "$file" >/dev/null || true
}

configure_workspace_defaults() {
  local file="$OBSIDIAN_CONFIG_DIR/workspace.json"
  local should_reset=0

  if [[ ! -f "$file" ]] || ! jq -e 'type == "object"' "$file" >/dev/null 2>&1; then
    should_reset=1
  else
    if jq -e '[.. | objects | select(.type? == "file-explorer")] | length == 0' "$file" >/dev/null 2>&1; then
      should_reset=1
    fi
    if jq -e '[.. | objects | select(.type? == "empty")] | length > 0' "$file" >/dev/null 2>&1; then
      should_reset=1
    fi
  fi

  if [[ "$should_reset" == "0" ]]; then
    return 0
  fi

  cat >"$file" <<'JSON'
{
  "main": {
    "id": "main-root",
    "type": "split",
    "children": [
      {
        "id": "main-tabs",
        "type": "tabs",
        "children": [
          {
            "id": "hub-leaf",
            "type": "leaf",
            "state": {
              "type": "markdown",
              "state": {
                "file": "hub.md",
                "mode": "source",
                "source": false
              },
              "icon": "lucide-file",
              "title": "hub.md"
            }
          }
        ]
      }
    ],
    "direction": "vertical"
  },
  "left": {
    "id": "left-root",
    "type": "split",
    "children": [
      {
        "id": "left-tabs",
        "type": "tabs",
        "children": [
          {
            "id": "explorer-leaf",
            "type": "leaf",
            "state": {
              "type": "file-explorer",
              "state": {},
              "icon": "lucide-folder-closed",
              "title": "Files"
            }
          },
          {
            "id": "bookmarks-leaf",
            "type": "leaf",
            "state": {
              "type": "bookmarks",
              "state": {},
              "icon": "lucide-bookmark",
              "title": "Bookmarks"
            }
          }
        ],
        "currentTab": 0
      }
    ],
    "direction": "horizontal",
    "width": 320
  },
  "right": {
    "id": "right-root",
    "type": "split",
    "children": [
      {
        "id": "right-tabs",
        "type": "tabs",
        "children": [
          {
            "id": "backlinks-leaf",
            "type": "leaf",
            "state": {
              "type": "backlink",
              "state": {
                "collapseAll": false,
                "extraContext": false,
                "sortOrder": "alphabetical",
                "showSearch": false,
                "searchQuery": "",
                "backlinkCollapsed": false,
                "unlinkedCollapsed": true
              },
              "icon": "links-coming-in",
              "title": "Backlinks"
            }
          },
          {
            "id": "outgoing-leaf",
            "type": "leaf",
            "state": {
              "type": "outgoing-link",
              "state": {
                "linksCollapsed": false,
                "unlinkedCollapsed": true
              },
              "icon": "links-going-out",
              "title": "Outgoing links"
            }
          },
          {
            "id": "tags-leaf",
            "type": "leaf",
            "state": {
              "type": "tag",
              "state": {
                "sortOrder": "frequency",
                "useHierarchy": true,
                "showSearch": false,
                "searchQuery": ""
              },
              "icon": "lucide-tags",
              "title": "Tags"
            }
          }
        ],
        "currentTab": 0
      }
    ],
    "direction": "horizontal",
    "width": 300
  },
  "active": "hub-leaf",
  "lastOpenFiles": [
    "hub.md"
  ]
}
JSON

  print_info "Reset Obsidian workspace to default layout (Files + hub.md)."
}

download_with_retry() {
  local url=$1
  local output=$2
  local curl_args=(
    --fail
    --silent
    --show-error
    --location
    --retry 3
    --retry-delay 1
    --retry-all-errors
  )

  curl "${curl_args[@]}" "$url" --output "$output"
}

ensure_plugin_lock_file() {
  if [[ ! -f "$PLUGIN_LOCK_FILE" ]]; then
    echo "❌ Missing Obsidian plugin lock file: $PLUGIN_LOCK_FILE"
    return 1
  fi

  if ! jq -e '.schema_version == 1 and (.plugins | type == "object")' "$PLUGIN_LOCK_FILE" >/dev/null 2>&1; then
    echo "❌ Invalid Obsidian plugin lock file format: $PLUGIN_LOCK_FILE"
    return 1
  fi
}

normalize_sha256() {
  local value
  value="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')"
  if [[ "$value" =~ ^[0-9a-f]{64}$ ]]; then
    printf '%s\n' "$value"
  fi
}

sha256_file() {
  shasum -a 256 "$1" | awk '{print tolower($1)}'
}

download_verified_asset() {
  local url=$1
  local expected_sha=$2
  local output=$3
  local tmp_file actual_sha normalized_expected

  normalized_expected="$(normalize_sha256 "$expected_sha")"
  if [[ -z "$normalized_expected" ]]; then
    print_warning "Invalid checksum for $url"
    return 1
  fi

  tmp_file="$(mktemp)"
  if ! download_with_retry "$url" "$tmp_file"; then
    rm -f "$tmp_file"
    return 1
  fi

  actual_sha="$(sha256_file "$tmp_file")"
  if [[ "$actual_sha" != "$normalized_expected" ]]; then
    rm -f "$tmp_file"
    print_warning "Checksum mismatch for $url"
    return 1
  fi

  mkdir -p "$(dirname "$output")"
  mv "$tmp_file" "$output"
}

plugin_release_up_to_date() {
  local plugin_dir=$1
  local expected_state=$2
  local styles_required=$3
  local state_file="$plugin_dir/.dotfiles-release-id"
  local installed_release

  [[ -n "$expected_state" ]] || return 1
  [[ -f "$state_file" ]] || return 1
  [[ -f "$plugin_dir/manifest.json" && -f "$plugin_dir/main.js" ]] || return 1

  if [[ "$styles_required" == "1" && ! -f "$plugin_dir/styles.css" ]]; then
    return 1
  fi

  installed_release="$(cat "$state_file" 2>/dev/null || true)"
  [[ "$installed_release" == "$expected_state" ]]
}

record_plugin_release_state() {
  local plugin_dir=$1
  local release_id=$2
  local tmp_file

  [[ -n "$release_id" ]] || return 0

  tmp_file="$(mktemp)"
  printf '%s\n' "$release_id" >"$tmp_file"
  replace_file_if_changed "$tmp_file" "$plugin_dir/.dotfiles-release-id" >/dev/null || true
}

install_community_plugin() {
  local plugin_id=$1
  local force_refresh="${2:-0}"
  local plugin_dir="$PLUGINS_DIR/$plugin_id"
  local lock_entry repo tag_name release_id release_state styles_required
  local manifest_url manifest_sha main_url main_sha styles_url styles_sha

  lock_entry="$(jq -c --arg plugin_id "$plugin_id" '.plugins[$plugin_id] // empty' "$PLUGIN_LOCK_FILE")"
  if [[ -z "$lock_entry" ]]; then
    print_warning "Plugin lock entry missing for: $plugin_id"
    return 1
  fi

  IFS=$'\t' read -r repo tag_name release_id manifest_url manifest_sha main_url main_sha styles_url styles_sha \
    < <(printf '%s' "$lock_entry" | jq -r '[
        .repo // "",
        .tag // "",
        (.release_id | tostring? // ""),
        .assets["manifest.json"].url // "",
        .assets["manifest.json"].sha256 // "",
        .assets["main.js"].url // "",
        .assets["main.js"].sha256 // "",
        .assets["styles.css"].url // "",
        .assets["styles.css"].sha256 // ""
      ] | @tsv')

  if [[ -z "$repo" || -z "$manifest_url" || -z "$manifest_sha" || -z "$main_url" || -z "$main_sha" ]]; then
    print_warning "Plugin lock entry incomplete for: $plugin_id"
    return 1
  fi

  release_state="$release_id"
  if [[ -z "$release_state" ]]; then
    release_state="$tag_name"
  fi
  if [[ -z "$release_state" ]]; then
    release_state="${manifest_sha}:${main_sha}"
  fi

  mkdir -p "$plugin_dir"

  styles_required=0
  if [[ -n "$styles_url" || -n "$styles_sha" ]]; then
    if [[ -z "$styles_url" || -z "$styles_sha" ]]; then
      print_warning "Plugin lock styles entry incomplete for: $plugin_id"
      return 1
    fi
    styles_required=1
  fi

  if [[ "$force_refresh" != "1" ]] && plugin_release_up_to_date "$plugin_dir" "$release_state" "$styles_required"; then
    return 3
  fi

  if ! download_verified_asset "$manifest_url" "$manifest_sha" "$plugin_dir/manifest.json"; then
    print_warning "Failed to install manifest.json for $plugin_id ($repo)"
    return 1
  fi
  if ! download_verified_asset "$main_url" "$main_sha" "$plugin_dir/main.js"; then
    print_warning "Failed to install main.js for $plugin_id ($repo)"
    return 1
  fi
  if [[ "$styles_required" == "1" ]]; then
    if ! download_verified_asset "$styles_url" "$styles_sha" "$plugin_dir/styles.css"; then
      print_warning "Failed to install styles.css for $plugin_id ($repo)"
      return 1
    fi
  fi

  record_plugin_release_state "$plugin_dir" "$release_state"
}

install_community_plugins() {
  local plugin_id
  local failures=()
  local install_downloads update_plugins status

  install_downloads="$(normalize_bool "${DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS:-0}")"
  update_plugins="$(normalize_bool "${DOTFILES_OBSIDIAN_UPDATE_PLUGINS:-0}")"
  if [[ "$install_downloads" == "1" ]]; then
    print_info "Skipping community plugin downloads (DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1)"
    return 0
  fi

  require_cmd curl
  require_cmd shasum

  if ! ensure_plugin_lock_file; then
    return 1
  fi

  if [[ "$update_plugins" == "1" ]]; then
    print_info "Re-checking community plugins from pinned lock (refresh lock file to change versions)."
  fi

  local installed_count=0 up_to_date_count=0
  for plugin_id in "${COMMUNITY_PLUGINS[@]}"; do
    if install_community_plugin "$plugin_id" "$update_plugins"; then
      print_success "Installed: $plugin_id"
      installed_count=$((installed_count + 1))
    else
      status=$?
      if [[ "$status" -eq 3 ]]; then
        up_to_date_count=$((up_to_date_count + 1))
        continue
      fi
      print_warning "Failed: $plugin_id"
      failures+=("$plugin_id")
    fi
  done
  if (( up_to_date_count > 0 )); then
    print_success "$up_to_date_count plugin(s) already up to date"
  fi

  if [[ ${#failures[@]} -gt 0 ]]; then
    echo "❌ Obsidian plugin install failures: ${failures[*]}"
    return 1
  fi
}


cmd_setup() {
  ensure_local_vault_directory

  seed_vault_files
  seed_local_vault_defaults
  register_vault_with_obsidian_ui

  mkdir -p "$OBSIDIAN_CONFIG_DIR" "$PLUGINS_DIR"

  CORE_PLUGINS=(
    "file-explorer"
    "global-search"
    "switcher"
    "templates"
    "daily-notes"
    "backlink"
    "outgoing-link"
    "tag-pane"
    "bookmarks"
    "command-palette"
  )

  COMMUNITY_PLUGINS=(
    "auto-classifier"
    "quickadd"
    "dataview"
    "metadata-menu"
    "obsidian-tasks-plugin"
    "periodic-notes"
    "calendar"
    "obsidian-kanban"
    "obsidian-linter"
  )

  CONFLICTING_COMMUNITY_PLUGINS=(
    "templater-obsidian"
    "omnisearch"
  )

  configure_core_plugins "${CORE_PLUGINS[@]}"
  write_array_union "$OBSIDIAN_CONFIG_DIR/community-plugins.json" "${COMMUNITY_PLUGINS[@]}"
  write_array_without_values "$OBSIDIAN_CONFIG_DIR/community-plugins.json" "${CONFLICTING_COMMUNITY_PLUGINS[@]}"
  for plugin_id in "${CONFLICTING_COMMUNITY_PLUGINS[@]}"; do
    remove_path_if_exists "$PLUGINS_DIR/$plugin_id"
  done
  configure_templates_settings
  install_community_plugins
  configure_dataview_plugin
  configure_metadata_menu_plugin
  configure_workspace_defaults

  print_success "Obsidian vault configured at $VAULT_DIR"
}

cmd_clean() {

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
}

# Lock subcommand globals (checked by cleanup trap)
_lock_auth_config_file=""
_lock_tmp_lock_file=""
_lock_cleanup() {
  [[ -n "$_lock_auth_config_file" ]] && rm -f "$_lock_auth_config_file"
  [[ -n "$_lock_tmp_lock_file" ]] && rm -f "$_lock_tmp_lock_file" "${_lock_tmp_lock_file}.new"
  true
}
trap _lock_cleanup EXIT

cmd_lock() {
  plugins=(
    "auto-classifier|HyeonseoNam/auto-classifier"
    "quickadd|chhoumann/quickadd"
    "dataview|blacksmithgu/obsidian-dataview"
    "metadata-menu|mdelobelle/metadatamenu"
    "obsidian-tasks-plugin|obsidian-tasks-group/obsidian-tasks"
    "periodic-notes|liamcain/obsidian-periodic-notes"
    "calendar|liamcain/obsidian-calendar-plugin"
    "obsidian-kanban|mgmeyers/obsidian-kanban"
    "obsidian-linter|platers/obsidian-linter"
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

  _lock_auth_config_file=""
  _lock_tmp_lock_file=""


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

    _lock_auth_config_file="$(mktemp)"
    chmod 600 "$_lock_auth_config_file"
    printf 'header = "Authorization: Bearer %s"\n' "$token" > "$_lock_auth_config_file"
  }

  curl_fetch() {
    local url=$1
    if [[ -n "$_lock_auth_config_file" ]]; then
      curl "${curl_common[@]}" --config "$_lock_auth_config_file" "$url"
    else
      curl "${curl_common[@]}" "$url"
    fi
  }

  select_release_json() {
    local repo=$1
    local releases_json release_json

    releases_json="$(curl_fetch "https://api.github.com/repos/$repo/releases?per_page=100")"
    release_json="$(printf '%s' "$releases_json" | jq -c '
      map(select(.draft | not)) as $all
      | (
          $all
          | map(select((.tag_name // "") | test("(?i)(alpha|beta|rc)") | not))
          | first
        )
        // (
          $all
          | map(select(.prerelease | not))
          | first
        )
        // ($all | first)
    ')"

    if [[ -z "$release_json" || "$release_json" == "null" ]]; then
      return 1
    fi

    printf '%s\n' "$release_json"
  }

  download_to_file() {
    local url=$1
    local output=$2
    if [[ -n "$_lock_auth_config_file" ]]; then
      curl "${curl_common[@]}" --config "$_lock_auth_config_file" "$url" --output "$output"
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

  _lock_tmp_lock_file="$(mktemp)"

  jq -n '
    {
      schema_version: 1,
      plugins: {}
    }
  ' > "$_lock_tmp_lock_file"

  for spec in "${plugins[@]}"; do
    IFS='|' read -r plugin_id repo <<< "$spec"
    echo "🔒 Resolving lock entry for $plugin_id ($repo)..."

    if ! release_json="$(select_release_json "$repo")"; then
      echo "❌ Failed to resolve release metadata for $plugin_id ($repo)"
      exit 1
    fi

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

    jq --arg id "$plugin_id" --argjson entry "$entry_json" '.plugins[$id] = $entry' "$_lock_tmp_lock_file" > "${_lock_tmp_lock_file}.new"
    mv "${_lock_tmp_lock_file}.new" "$_lock_tmp_lock_file"
  done

  mkdir -p "$(dirname "$PLUGIN_PLUGIN_LOCK_FILE")"
  jq -S . "$_lock_tmp_lock_file" > "$PLUGIN_PLUGIN_LOCK_FILE"

  echo "✅ Wrote Obsidian plugin lock file: $PLUGIN_LOCK_FILE"
}

case "$COMMAND" in
  setup) cmd_setup ;;
  clean) cmd_clean ;;
  lock)  cmd_lock  ;;
  *)
    echo "Usage: $(basename \"$0\") [setup|clean|lock]" >&2
    exit 1
    ;;
esac
