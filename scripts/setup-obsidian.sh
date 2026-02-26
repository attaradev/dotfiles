#!/usr/bin/env bash

set -euo pipefail

VAULT_DIR="${OBSIDIAN_VAULT_DIR:-$HOME/.knowledge}"
OBSIDIAN_CONFIG_DIR="$VAULT_DIR/.obsidian"
PLUGINS_DIR="$OBSIDIAN_CONFIG_DIR/plugins"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLIC_VAULT_SOURCE_DIR="$DOTFILES_DIR/obsidian/.knowledge"
PLUGIN_LOCK_FILE="${DOTFILES_OBSIDIAN_PLUGIN_LOCK_FILE:-$DOTFILES_DIR/obsidian/community-plugin-lock.json}"

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
  replace_if_changed "$tmp_file" "$plugin_dir/.dotfiles-release-id" >/dev/null || true
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

  repo="$(printf '%s' "$lock_entry" | jq -r '.repo // empty')"
  tag_name="$(printf '%s' "$lock_entry" | jq -r '.tag // empty')"
  release_id="$(printf '%s' "$lock_entry" | jq -r '.release_id // empty')"
  manifest_url="$(printf '%s' "$lock_entry" | jq -r '.assets["manifest.json"].url // empty')"
  manifest_sha="$(printf '%s' "$lock_entry" | jq -r '.assets["manifest.json"].sha256 // empty')"
  main_url="$(printf '%s' "$lock_entry" | jq -r '.assets["main.js"].url // empty')"
  main_sha="$(printf '%s' "$lock_entry" | jq -r '.assets["main.js"].sha256 // empty')"
  styles_url="$(printf '%s' "$lock_entry" | jq -r '.assets["styles.css"].url // empty')"
  styles_sha="$(printf '%s' "$lock_entry" | jq -r '.assets["styles.css"].sha256 // empty')"

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
    print_info "Plugin already up to date: $plugin_id"
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

  if ! ensure_plugin_lock_file; then
    return 1
  fi

  if [[ "$update_plugins" == "1" ]]; then
    print_info "Re-checking community plugins from pinned lock (refresh lock file to change versions)."
  fi

  for plugin_id in "${COMMUNITY_PLUGINS[@]}"; do
    print_info "Installing Obsidian plugin from lock: $plugin_id"
    if install_community_plugin "$plugin_id" "$update_plugins"; then
      print_success "Installed: $plugin_id"
    else
      status=$?
      if [[ "$status" -eq 3 ]]; then
        print_info "Verified existing install: $plugin_id"
        continue
      fi
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
require_cmd shasum

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
print_success "Community plugin assets verified using lock file: $PLUGIN_LOCK_FILE"
