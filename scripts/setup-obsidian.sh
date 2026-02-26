#!/usr/bin/env bash

set -euo pipefail

VAULT_DIR="${OBSIDIAN_VAULT_DIR:-$HOME/.knowledge}"
OBSIDIAN_CONFIG_DIR="$VAULT_DIR/.obsidian"
PLUGINS_DIR="$OBSIDIAN_CONFIG_DIR/plugins"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLIC_VAULT_SOURCE_DIR="$DOTFILES_DIR/obsidian/.knowledge"

normalize_bool() {
  local raw
  raw="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')"
  case "$raw" in
    1|y|yes|true|on) echo "1" ;;
    0|n|no|false|off) echo "0" ;;
    *) echo "0" ;;
  esac
}

print_info() {
  echo "ℹ $1"
}

print_success() {
  echo "✓ $1"
}

print_warning() {
  echo "⚠ $1"
}

write_if_missing() {
  local file=$1
  detach_if_symlink "$file"
  if [[ -e "$file" ]]; then
    return 0
  fi

  mkdir -p "$(dirname "$file")"
  cat >"$file"
}

copy_if_missing() {
  local target=$1
  local source=$2

  detach_if_symlink "$target"
  if [[ -e "$target" ]]; then
    return 0
  fi

  if [[ -f "$source" ]]; then
    mkdir -p "$(dirname "$target")"
    cp "$source" "$target"
  fi
}

replace_if_changed() {
  local tmp_file=$1
  local target=$2

  detach_if_symlink "$target"
  mkdir -p "$(dirname "$target")"

  if [[ -f "$target" ]] && cmp -s "$tmp_file" "$target"; then
    rm -f "$tmp_file"
    return 1
  fi

  mv "$tmp_file" "$target"
  return 0
}

detach_if_symlink() {
  local file=$1
  local tmp_file

  if [[ ! -L "$file" ]]; then
    return 0
  fi

  tmp_file="$(mktemp)"
  cat "$file" >"$tmp_file" 2>/dev/null || true
  rm -f "$file"
  mkdir -p "$(dirname "$file")"
  cp "$tmp_file" "$file"
  rm -f "$tmp_file"
}

seed_vault_files() {
  local template

  mkdir -p \
    "$VAULT_DIR" \
    "$VAULT_DIR/setup" \
    "$VAULT_DIR/projects" \
    "$VAULT_DIR/reading" \
    "$VAULT_DIR/learning" \
    "$VAULT_DIR/career" \
    "$VAULT_DIR/_templates"

  copy_if_missing "$VAULT_DIR/hub.md" "$PUBLIC_VAULT_SOURCE_DIR/hub.md"
  write_if_missing "$VAULT_DIR/hub.md" <<'EOF'
# Knowledge Hub

Use this as the landing page in Obsidian.

## Areas

- [Active Tasks](tasks.md)
- [Projects Tracker](projects/projects.md)
- [Learning and Studies](learning/studies.md)
- [Courses Tracker](learning/courses.md)
- [Books Tracker](reading/books.md)
- [Articles Tracker](reading/articles.md)
- [Lessons Learned](learning/lessons.md)
- [Achievement Inbox](career/achievement-inbox.md)
- [Achievement Log](career/achievement-log.md)
- [Plugin Setup](setup/obsidian-plugins.md)
EOF
  copy_if_missing \
    "$VAULT_DIR/setup/obsidian-plugins.md" \
    "$PUBLIC_VAULT_SOURCE_DIR/setup/obsidian-plugins.md"
  write_if_missing "$VAULT_DIR/setup/obsidian-plugins.md" <<'EOF'
# Obsidian Plugin Operator Notes

Plugin defaults are configured by `scripts/setup-obsidian.sh`.
EOF

  for template in \
    task-plan-template.md \
    project-entry-template.md \
    study-entry-template.md \
    course-entry-template.md \
    book-entry-template.md \
    article-entry-template.md \
    lesson-entry-template.md \
    achievement-entry-template.md; do
    copy_if_missing \
      "$VAULT_DIR/_templates/$template" \
      "$PUBLIC_VAULT_SOURCE_DIR/_templates/$template"
  done

  write_if_missing "$VAULT_DIR/tasks.md" <<'EOF'
# Active Tasks

Track active execution here when a repository does not provide its own task file.

## In Progress

### YYYY-MM-DD | Context | Objective

- Status: planned | in_progress | blocked | done
- Scope:
- Checklist:
  - [ ] Item 1
  - [ ] Item 2
  - [ ] Item 3
- Verification:
  - Commands/tests run:
  - Expected behavior:
  - Actual behavior:
- Notes:

## Completed

### YYYY-MM-DD | Context | Objective

- Outcome:
- Verification summary:
- Follow-ups:
EOF

  write_if_missing "$VAULT_DIR/projects/projects.md" <<'EOF'
# Projects Tracker

Track your work across all projects, not just Claude sessions.

## Active Projects

### Project Name

- Status: ideation | active | blocked | maintenance | complete
- Goal:
- Current milestone:
- Next milestone:
- Risks:
- Links: repo, board, docs, PRs
- Last updated: YYYY-MM-DD

## Backlog Ideas

- Idea:
- Why it matters:
- First actionable step:

## Completed Projects

### Project Name | YYYY

- Summary:
- Outcome:
- Evidence:
- Key lesson:
EOF

  write_if_missing "$VAULT_DIR/reading/books.md" <<'EOF'
# Books Tracker

Track books you want to read, are actively reading, and completed.

## Want To Read

### Book Title | Author

- Status: want_to_read
- Why read:
- Priority: low | medium | high
- Next action:
- Related lessons:

## Reading Now

### Book Title | Author

- Status: reading
- Started: YYYY-MM-DD
- Focus:
- Notes:
- Related lessons:

## Finished

### Book Title | Author

- Status: finished
- Started: YYYY-MM-DD
- Finished: YYYY-MM-DD
- Key takeaways:
- Related lessons:
EOF

  write_if_missing "$VAULT_DIR/reading/articles.md" <<'EOF'
# Articles Tracker

Track articles and papers you want to read, are reading, and completed.

## Queue

### Article Title | Author/Publisher

- Status: queued
- URL:
- Why read:
- Priority: low | medium | high
- Next action:
- Related lessons:

## Reading Now

### Article Title | Author/Publisher

- Status: reading
- URL:
- Started: YYYY-MM-DD
- Notes:
- Related lessons:

## Archived

### Article Title | Author/Publisher

- Status: archived
- URL:
- Finished: YYYY-MM-DD
- Key takeaways:
- Related lessons:
EOF

  write_if_missing "$VAULT_DIR/learning/courses.md" <<'EOF'
# Courses Tracker

Track courses you want to take, are currently taking, and completed.

## Backlog

### Course Title | Provider

- Status: backlog
- Link:
- Why take:
- Priority: low | medium | high
- Target start: YYYY-MM-DD
- Related lessons:

## In Progress

### Course Title | Provider

- Status: in_progress
- Link:
- Started: YYYY-MM-DD
- Current module:
- Notes:
- Next milestone:
- Related lessons:

## Completed

### Course Title | Provider

- Status: completed
- Link:
- Started: YYYY-MM-DD
- Finished: YYYY-MM-DD
- Completion proof: certificate, project, notes
- Key takeaways:
- Related lessons:
EOF

  write_if_missing "$VAULT_DIR/learning/studies.md" <<'EOF'
# Learning and Studies Tracker

Track intentional learning (courses, labs, certifications, experiments).

## Active Focus Areas

- Topic:
- Why now:
- Success criteria:
- Time allocation:

## Study Log

### YYYY-MM-DD | Topic | Session Title

- Source: course/book/article/lab/cert
- Time spent:
- What I learned:
- What I practiced:
- Open questions:
- Next study action:
- Related lessons:

## Completed Learning Outcomes

### Topic | YYYY-MM-DD

- Outcome:
- Proof: project, notes, cert, demo, assessment
- Practical application:
EOF

  write_if_missing "$VAULT_DIR/learning/lessons.md" <<'EOF'
# Lessons Learned

Capture repeatable lessons from mistakes, regressions, and rework.

## Entry Template

```md
### YYYY-MM-DD | Context
- Mistake:
- Signal:
- Root cause:
- New rule:
- Enforcement check:
```

## Entries
EOF

  write_if_missing "$VAULT_DIR/career/achievement-inbox.md" <<'EOF'
# Achievement Inbox

Auto-captured achievement candidates from Claude task completion events and
Codex notify events.
Keep this as an intake queue and promote polished entries into
`achievement-log.md`.

## How To Use

- Capture only intentional wins by prefixing task-complete titles with
  `achievement:`, `win:`, or `impact:`.
- Keep entries concise and outcome-first.
- Promote final, evidence-backed entries to `achievement-log.md`.
- Prune stale or low-value candidates during weekly review.

## Entries
EOF

  write_if_missing "$VAULT_DIR/career/achievement-log.md" <<'EOF'
# Personal Achievement Log

Use this file to keep an evidence-backed record of high-impact outcomes.

## Entry Template

```md
### YYYY-MM-DD | Project | Short Win Title
- Context: What problem or opportunity existed?
- Actions: What did I specifically do?
- Impact: What changed? Include numbers when possible.
- Evidence: <link1>, <link2>, <link3>
- Competencies: execution, ownership, leadership, reliability, product, mentoring
- Reusable bullet: One sentence suitable for review/resume packets.
```
EOF
}

require_cmd() {
  local cmd=$1
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Missing required command: $cmd"
    exit 1
  fi
}

community_plugin_repo() {
  local plugin_id=$1
  case "$plugin_id" in
    auto-classifier) echo "HyeonseoNam/auto-classifier" ;;
    templater-obsidian) echo "SilentVoid13/Templater" ;;
    quickadd) echo "chhoumann/quickadd" ;;
    dataview) echo "blacksmithgu/obsidian-dataview" ;;
    metadata-menu) echo "mdelobelle/metadatamenu" ;;
    obsidian-tasks-plugin) echo "obsidian-tasks-group/obsidian-tasks" ;;
    periodic-notes) echo "liamcain/obsidian-periodic-notes" ;;
    calendar) echo "liamcain/obsidian-calendar-plugin" ;;
    obsidian-kanban) echo "mgmeyers/obsidian-kanban" ;;
    obsidian-linter) echo "platers/obsidian-linter" ;;
    omnisearch) echo "scambier/obsidian-omnisearch" ;;
    *)
      return 1
      ;;
  esac
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

  replace_if_changed "$tmp_file" "$file" >/dev/null || true
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

  replace_if_changed "$tmp_file" "$file" >/dev/null || true
}

configure_templates_plugin() {
  local file="$OBSIDIAN_CONFIG_DIR/templates.json"
  local tmp_file
  tmp_file="$(mktemp)"

  if [[ -f "$file" ]] && jq -e 'type == "object"' "$file" >/dev/null 2>&1; then
    jq '.folder = "_templates"' "$file" >"$tmp_file"
  else
    jq -n '{"folder":"_templates"}' >"$tmp_file"
  fi

  replace_if_changed "$tmp_file" "$file" >/dev/null || true
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

  replace_if_changed "$tmp_file" "$file" >/dev/null || true
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

  replace_if_changed "$tmp_file" "$file" >/dev/null || true
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

fetch_latest_release_json() {
  local repo=$1
  local curl_args=(
    --fail
    --silent
    --show-error
    --location
    --retry 3
    --retry-delay 1
    --retry-all-errors
  )

  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    curl_args+=(--header "Authorization: Bearer ${GITHUB_TOKEN}")
  fi

  curl "${curl_args[@]}" "https://api.github.com/repos/$repo/releases/latest"
}

install_plugin_assets_from_urls() {
  local plugin_dir=$1
  local manifest_url=$2
  local main_url=$3
  local styles_url=$4

  download_with_retry "$manifest_url" "$plugin_dir/manifest.json"
  download_with_retry "$main_url" "$plugin_dir/main.js"
  if [[ -n "$styles_url" ]]; then
    if ! download_with_retry "$styles_url" "$plugin_dir/styles.css"; then
      print_warning "styles.css not downloaded for $(basename "$plugin_dir"); continuing without it."
    fi
  fi
}

install_plugin_assets_from_zip() {
  local plugin_dir=$1
  local zip_url=$2
  local tmp_dir zip_path
  local manifest_src main_src styles_src

  tmp_dir="$(mktemp -d)"
  zip_path="$tmp_dir/plugin.zip"
  trap 'rm -rf "$tmp_dir"' RETURN

  download_with_retry "$zip_url" "$zip_path"
  unzip -q -o "$zip_path" -d "$tmp_dir/unpacked"

  manifest_src="$(find "$tmp_dir/unpacked" -type f -name manifest.json | head -n1 || true)"
  main_src="$(find "$tmp_dir/unpacked" -type f -name main.js | head -n1 || true)"
  styles_src="$(find "$tmp_dir/unpacked" -type f -name styles.css | head -n1 || true)"

  if [[ -z "$manifest_src" || -z "$main_src" ]]; then
    print_warning "Zip asset missing manifest.json or main.js in $zip_url"
    return 1
  fi

  cp "$manifest_src" "$plugin_dir/manifest.json"
  cp "$main_src" "$plugin_dir/main.js"
  if [[ -n "$styles_src" ]]; then
    cp "$styles_src" "$plugin_dir/styles.css"
  fi
}

plugin_release_up_to_date() {
  local plugin_dir=$1
  local release_id=$2
  local styles_required=$3
  local state_file="$plugin_dir/.dotfiles-release-id"
  local installed_release

  [[ -n "$release_id" ]] || return 1
  [[ -f "$state_file" ]] || return 1
  [[ -f "$plugin_dir/manifest.json" && -f "$plugin_dir/main.js" ]] || return 1

  if [[ "$styles_required" == "1" && ! -f "$plugin_dir/styles.css" ]]; then
    return 1
  fi

  installed_release="$(cat "$state_file" 2>/dev/null || true)"
  [[ "$installed_release" == "$release_id" ]]
}

record_plugin_release_state() {
  local plugin_dir=$1
  local release_id=$2
  local tmp_file

  [[ -n "$release_id" ]] || return 0

  tmp_file="$(mktemp)"
  printf '%s\n' "$release_id" >"$tmp_file"
  replace_if_changed "$tmp_file" "$plugin_dir/.dotfiles-release-id" >/dev/null || true
}

install_community_plugin() {
  local plugin_id=$1
  local repo=$2
  local plugin_dir="$PLUGINS_DIR/$plugin_id"
  local release_json
  local tag_name manifest_url main_url styles_url zip_url release_id styles_required

  release_json="$(fetch_latest_release_json "$repo")"
  release_id="$(printf '%s' "$release_json" | jq -r '.id // empty')"
  tag_name="$(printf '%s' "$release_json" | jq -r '.tag_name // empty')"
  manifest_url="$(printf '%s' "$release_json" | jq -r '.assets[]? | select(.name=="manifest.json") | .browser_download_url' | head -n1)"
  main_url="$(printf '%s' "$release_json" | jq -r '.assets[]? | select(.name=="main.js") | .browser_download_url' | head -n1)"
  styles_url="$(printf '%s' "$release_json" | jq -r '.assets[]? | select(.name=="styles.css") | .browser_download_url' | head -n1)"
  zip_url="$(printf '%s' "$release_json" | jq -r '.assets[]? | select(.name | test("\\.zip$")) | .browser_download_url' | head -n1)"

  mkdir -p "$plugin_dir"

  styles_required=0
  [[ -n "$styles_url" ]] && styles_required=1

  if [[ -z "$manifest_url" && -n "$tag_name" ]]; then
    manifest_url="https://raw.githubusercontent.com/$repo/$tag_name/manifest.json"
  fi
  if [[ -z "$main_url" && -n "$tag_name" ]]; then
    main_url="https://raw.githubusercontent.com/$repo/$tag_name/main.js"
  fi

  if plugin_release_up_to_date "$plugin_dir" "$release_id" "$styles_required"; then
    print_info "Plugin already up to date: $plugin_id"
    return 0
  fi

  if [[ -n "$manifest_url" && -n "$main_url" ]]; then
    if install_plugin_assets_from_urls "$plugin_dir" "$manifest_url" "$main_url" "$styles_url"; then
      record_plugin_release_state "$plugin_dir" "$release_id"
      return 0
    fi
    print_warning "Direct asset download failed for $plugin_id; trying zip asset fallback."
  fi

  if [[ -n "$zip_url" ]]; then
    if install_plugin_assets_from_zip "$plugin_dir" "$zip_url"; then
      record_plugin_release_state "$plugin_dir" "$release_id"
      return 0
    fi
  fi

  print_warning "Could not resolve downloadable assets for plugin: $plugin_id ($repo)"
  return 1
}

install_community_plugins() {
  local plugin_id repo
  local failures=()
  local install_downloads update_plugins

  install_downloads="$(normalize_bool "${DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS:-0}")"
  update_plugins="$(normalize_bool "${DOTFILES_OBSIDIAN_UPDATE_PLUGINS:-0}")"
  if [[ "$install_downloads" == "1" ]]; then
    print_info "Skipping community plugin downloads (DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1)"
    return 0
  fi
  if [[ "$update_plugins" == "1" ]]; then
    print_info "Checking for community plugin updates (DOTFILES_OBSIDIAN_UPDATE_PLUGINS=1)"
  fi

  for plugin_id in "${COMMUNITY_PLUGINS[@]}"; do
    if [[ "$update_plugins" != "1" ]] && [[ -f "$PLUGINS_DIR/$plugin_id/manifest.json" && -f "$PLUGINS_DIR/$plugin_id/main.js" ]]; then
      print_info "Plugin already installed: $plugin_id (set DOTFILES_OBSIDIAN_UPDATE_PLUGINS=1 to check for updates)"
      continue
    fi

    if ! repo="$(community_plugin_repo "$plugin_id")"; then
      print_warning "No repository mapping found for plugin: $plugin_id"
      failures+=("$plugin_id")
      continue
    fi

    print_info "Installing Obsidian plugin: $plugin_id ($repo)"
    if install_community_plugin "$plugin_id" "$repo"; then
      print_success "Installed: $plugin_id"
    else
      print_warning "Failed: $plugin_id"
      failures+=("$plugin_id")
    fi
  done

  if [[ ${#failures[@]} -gt 0 ]]; then
    echo "❌ Obsidian plugin install failures: ${failures[*]}"
    return 1
  fi
}

require_cmd jq
require_cmd curl
require_cmd unzip

if [[ ! -d "$VAULT_DIR" ]]; then
  mkdir -p "$VAULT_DIR"
fi

seed_vault_files

mkdir -p "$OBSIDIAN_CONFIG_DIR" "$PLUGINS_DIR"

CORE_PLUGINS=(
  "file-explorer"
  "global-search"
  "switcher"
  "daily-notes"
  "templates"
  "backlink"
  "outgoing-link"
  "tag-pane"
  "bookmarks"
  "command-palette"
)

COMMUNITY_PLUGINS=(
  "auto-classifier"
  "templater-obsidian"
  "quickadd"
  "dataview"
  "metadata-menu"
  "obsidian-tasks-plugin"
  "periodic-notes"
  "calendar"
  "obsidian-kanban"
  "obsidian-linter"
  "omnisearch"
)

configure_core_plugins "${CORE_PLUGINS[@]}"
write_array_union "$OBSIDIAN_CONFIG_DIR/community-plugins.json" "${COMMUNITY_PLUGINS[@]}"
configure_templates_plugin
install_community_plugins
configure_dataview_plugin
configure_metadata_menu_plugin
configure_workspace_defaults

print_success "Obsidian vault configured at $VAULT_DIR"
print_success "Core plugins enabled: ${CORE_PLUGINS[*]}"
print_success "Community plugins enabled: ${COMMUNITY_PLUGINS[*]}"
