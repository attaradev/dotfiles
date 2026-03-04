#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

TEST_HOME="$TMP_DIR/home"
MOCK_BIN="$TMP_DIR/mock-bin"
OBSIDIAN_APP_CONFIG_DIR="$TEST_HOME/Library/Application Support/obsidian"
mkdir -p "$TEST_HOME" "$MOCK_BIN"
mkdir -p "$TEST_HOME/.config"

# Seed common pre-existing files to validate non-destructive stow behavior.
echo "existing hushlogin" > "$TEST_HOME/.hushlogin"
echo "existing starship config" > "$TEST_HOME/.config/starship.toml"

write_mock() {
  local name="$1"
  shift
  cat > "$MOCK_BIN/$name"
  chmod +x "$MOCK_BIN/$name"
}

file_state() {
  local file="$1"

  if stat --format '%n|%i|%Y' "$file" >/dev/null 2>&1; then
    stat --format '%n|%i|%Y' "$file"
  else
    stat -f '%N|%i|%m' "$file"
  fi
}

search_q() {
  local pattern="$1"
  local file="$2"

  if command -v rg >/dev/null 2>&1; then
    rg -q -- "$pattern" "$file"
  else
    grep -Eq -- "$pattern" "$file"
  fi
}

search_count() {
  local pattern="$1"
  local file="$2"

  if command -v rg >/dev/null 2>&1; then
    rg -c -- "$pattern" "$file" || true
  else
    grep -Ec -- "$pattern" "$file" || true
  fi
}

assert_symlink_pair() {
  local left="$1"
  local right="$2"

  if [[ -L "$left" || -L "$right" ]]; then
    return 0
  fi

  echo "❌ Expected one of these files to be a symlink:"
  echo "   $left"
  echo "   $right"
  ls -l "$left" "$right" 2>/dev/null || true
  exit 1
}

write_mock xcode-select <<'EOF'
#!/usr/bin/env bash
if [[ "${1:-}" == "-p" ]]; then
  echo "/Library/Developer/CommandLineTools"
  exit 0
fi
if [[ "${1:-}" == "--install" ]]; then
  exit 0
fi
exit 0
EOF

write_mock brew <<'EOF'
#!/usr/bin/env bash
cmd="${1:-}"

if [[ -n "${MOCK_BREW_LOG:-}" && "$cmd" == "bundle" && "${2:-}" == "check" ]]; then
  printf 'bundle_check HOMEBREW_BUNDLE_INSTALL_ANTIGRAVITY=%s BREW_INSTALL_ANTIGRAVITY=%s args=%s\n' \
    "${HOMEBREW_BUNDLE_INSTALL_ANTIGRAVITY:-unset}" \
    "${BREW_INSTALL_ANTIGRAVITY:-unset}" \
    "$*" >> "$MOCK_BREW_LOG"
fi

case "$cmd" in
  --version)
    echo "Homebrew 4.99.0"
    ;;
  shellenv)
    cat <<'SHENV'
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
SHENV
    ;;
  --prefix)
    if [[ -n "${2:-}" ]]; then
      echo "/opt/homebrew/opt/${2}"
    else
      echo "/opt/homebrew"
    fi
    ;;
  bundle|doctor|update|upgrade|cleanup)
    ;;
  *)
    ;;
esac
exit 0
EOF

write_mock mise <<'EOF'
#!/usr/bin/env bash
cmd="${1:-}"
case "$cmd" in
  --version)
    echo "mise 2026.0.0"
    ;;
  activate)
    echo 'export PATH="$PATH"'
    ;;
  install|upgrade|doctor|prune)
    ;;
  list|ls)
    echo "node 24.0.0 ~/.mise.toml 24"
    ;;
  ls-remote)
    echo "24.0.0"
    ;;
  *)
    ;;
esac
exit 0
EOF

write_mock stow <<'EOF'
#!/usr/bin/env bash
package=""
target="$HOME"

for arg in "$@"; do
  if [[ "$arg" == --target=* ]]; then
    target="${arg#--target=}"
    continue
  fi

  if [[ "$arg" != -* && -z "$package" ]]; then
    package="$arg"
  fi
done

if [[ -n "${MOCK_STOW_LOG:-}" ]]; then
  printf 'stow %s\n' "$*" >> "$MOCK_STOW_LOG"
fi

case "$package" in
  obsidian)
    mkdir -p \
      "$target/.knowledge/setup" \
      "$target/.knowledge/projects" \
      "$target/.knowledge/reading" \
      "$target/.knowledge/learning" \
      "$target/.knowledge/career" \
      "$target/.knowledge/_templates"
    ;;
  claude)
    mkdir -p "$target/.claude"
    touch "$target/.claude/CLAUDE.md" "$target/.claude/settings.json"
    ;;
  codex)
    mkdir -p "$target/.codex"
    touch "$target/.codex/config.toml" "$target/.codex/AGENTS.md"
    ;;
esac

exit 0
EOF

write_mock gpg <<'EOF'
#!/usr/bin/env bash
if [[ "${1:-}" == "--version" ]]; then
  echo "gpg (GnuPG) 2.4.0"
  exit 0
fi
if [[ "${1:-}" == "--list-secret-keys" ]]; then
  exit 0
fi
exit 0
EOF

write_mock gpgconf <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

write_mock gpg-agent <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

write_mock pinentry-mac <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

write_mock code <<'EOF'
#!/usr/bin/env bash
cmd="${1:-}"
case "$cmd" in
  --version)
    echo "1.99.0"
    ;;
  --list-extensions)
    printf '%s\n' "ms-python.python" "golang.go"
    ;;
  --install-extension)
    ;;
  *)
    ;;
esac
exit 0
EOF

PATH="$MOCK_BIN:$PATH" \
HOME="$TEST_HOME" \
OBSIDIAN_APP_CONFIG_DIR="$OBSIDIAN_APP_CONFIG_DIR" \
MOCK_STOW_LOG="$TMP_DIR/mock-stow.log" \
DOTFILES_NONINTERACTIVE=1 \
DOTFILES_SETUP_OBSIDIAN_PLUGINS=0 \
SKIP_VSCODE_EXTENSIONS=0 \
OSTYPE=darwin \
bash ./setup.sh

test -f "$TEST_HOME/.config/dotfiles/brew-optional.env"
test -f "$TEST_HOME/.gitconfig.local"
test -f "$TEST_HOME/.gnupg/gpg-agent.conf"
test -f "$TEST_HOME/.gnupg/gpg.conf"
test -f "$TEST_HOME/.hushlogin.backup"
test -f "$TEST_HOME/.config/starship.toml.backup"
test -f "$TEST_HOME/.mise.toml"
if [[ -L "$TEST_HOME/.mise.toml" ]]; then
  echo "❌ Expected ~/.mise.toml to be a local file, not a symlink"
  exit 1
fi
test -f "$TEST_HOME/.codex/config.toml"
test -f "$TEST_HOME/.codex/AGENTS.md"
test -f "$TEST_HOME/.knowledge/hub.md"
test -f "$TEST_HOME/.knowledge/tasks.md"
test -f "$TEST_HOME/.knowledge/career/achievement-log.md"

OPTIONAL_CASK_ENV_FILE="$TMP_DIR/optional-casks.env"
cat > "$OPTIONAL_CASK_ENV_FILE" <<'EOF'
export BREW_INSTALL_ANTIGRAVITY=0
export HOMEBREW_BUNDLE_INSTALL_ANTIGRAVITY=1
EOF

MOCK_BREW_LOG="$TMP_DIR/mock-brew.log"
: > "$MOCK_BREW_LOG"

PATH="$MOCK_BIN:$PATH" \
HOME="$TEST_HOME" \
BUNDLE_ENV_FILE="$OPTIONAL_CASK_ENV_FILE" \
MOCK_BREW_LOG="$MOCK_BREW_LOG" \
make -s brew-check

PATH="$MOCK_BIN:$PATH" \
HOME="$TEST_HOME" \
BUNDLE_ENV_FILE="$OPTIONAL_CASK_ENV_FILE" \
MOCK_BREW_LOG="$MOCK_BREW_LOG" \
make -s test

bundle_check_count="$(grep -c '^bundle_check ' "$MOCK_BREW_LOG" || true)"
if [[ "$bundle_check_count" != "2" ]]; then
  echo "❌ Expected 2 bundle check calls from make brew-check/test, got: $bundle_check_count"
  cat "$MOCK_BREW_LOG"
  exit 1
fi

if grep '^bundle_check ' "$MOCK_BREW_LOG" | grep -vq 'HOMEBREW_BUNDLE_INSTALL_ANTIGRAVITY=1 BREW_INSTALL_ANTIGRAVITY=1'; then
  echo "❌ Optional cask env normalization failed for make wrapper path"
  cat "$MOCK_BREW_LOG"
  exit 1
fi

# Validate Obsidian setup mode that skips plugin downloads.
OBSIDIAN_TEST_VAULT="$TMP_DIR/obsidian-vault"
mkdir -p "$OBSIDIAN_TEST_VAULT"
mkdir -p \
  "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/quickadd" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/omnisearch" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/templater-obsidian"
mkdir -p "$OBSIDIAN_TEST_VAULT/.obsidian"
echo '{"folder":"_templates"}' > "$OBSIDIAN_TEST_VAULT/.obsidian/templates.json"

PATH="$MOCK_BIN:$PATH" \
HOME="$TEST_HOME" \
OBSIDIAN_VAULT_DIR="$OBSIDIAN_TEST_VAULT" \
OBSIDIAN_APP_CONFIG_DIR="$OBSIDIAN_APP_CONFIG_DIR" \
DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1 \
bash ./scripts/setup-obsidian.sh

OBSIDIAN_APP_CONFIG_FILE="$TEST_HOME/Library/Application Support/obsidian/obsidian.json"
OBSIDIAN_TEST_VAULT_REAL="$(cd "$OBSIDIAN_TEST_VAULT" && pwd -P)"
OBSIDIAN_VISIBLE_VAULT_ALIAS="$TEST_HOME/Knowledge"

test -f "$OBSIDIAN_TEST_VAULT/hub.md"
test -f "$OBSIDIAN_TEST_VAULT/tasks.md"
test -f "$OBSIDIAN_TEST_VAULT/setup/obsidian-plugins.md"
test -f "$OBSIDIAN_APP_CONFIG_FILE"
test -L "$OBSIDIAN_VISIBLE_VAULT_ALIAS"
jq -e --arg path "$OBSIDIAN_VISIBLE_VAULT_ALIAS" \
  '[.vaults // {} | to_entries[]? | select((.value.path // "") == $path)] | length == 1' \
  "$OBSIDIAN_APP_CONFIG_FILE" >/dev/null
test -f "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/dataview/data.json"
test -f "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/metadata-menu/data.json"
jq -e 'if type == "object" then .templates == true else index("templates") != null end' \
  "$OBSIDIAN_TEST_VAULT/.obsidian/core-plugins.json" >/dev/null
jq -e '.folder == "_templates"' \
  "$OBSIDIAN_TEST_VAULT/.obsidian/templates.json" >/dev/null
jq -e 'index("templater-obsidian") | not' \
  "$OBSIDIAN_TEST_VAULT/.obsidian/community-plugins.json" >/dev/null
jq -e 'index("quickadd") != null' \
  "$OBSIDIAN_TEST_VAULT/.obsidian/community-plugins.json" >/dev/null
jq -e 'index("omnisearch") | not' \
  "$OBSIDIAN_TEST_VAULT/.obsidian/community-plugins.json" >/dev/null
test ! -e "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/templater-obsidian"
test -e "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/quickadd"
test ! -e "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/omnisearch"

# Validate symlinked vault paths are converted to local directories.
OBSIDIAN_SYMLINK_TARGET="$TMP_DIR/obsidian-symlink-target"
OBSIDIAN_SYMLINK_VAULT="$TMP_DIR/obsidian-vault-symlink"
mkdir -p "$OBSIDIAN_SYMLINK_TARGET"
ln -s "$OBSIDIAN_SYMLINK_TARGET" "$OBSIDIAN_SYMLINK_VAULT"

PATH="$MOCK_BIN:$PATH" \
HOME="$TEST_HOME" \
OBSIDIAN_VAULT_DIR="$OBSIDIAN_SYMLINK_VAULT" \
OBSIDIAN_APP_CONFIG_DIR="$OBSIDIAN_APP_CONFIG_DIR" \
DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1 \
bash ./scripts/setup-obsidian.sh

test ! -L "$OBSIDIAN_SYMLINK_VAULT"
test -d "$OBSIDIAN_SYMLINK_VAULT"
test -f "$OBSIDIAN_SYMLINK_VAULT/hub.md"
OBSIDIAN_SYMLINK_VAULT_REAL="$(cd "$OBSIDIAN_SYMLINK_VAULT" && pwd -P)"
jq -e --arg path "$OBSIDIAN_SYMLINK_VAULT_REAL" \
  '[.vaults // {} | to_entries[]? | select((.value.path // "") == $path)] | length == 1' \
  "$OBSIDIAN_APP_CONFIG_FILE" >/dev/null
if ! compgen -G "$OBSIDIAN_SYMLINK_VAULT.backup.*" >/dev/null; then
  echo "❌ Expected backup when converting symlinked Obsidian vault path"
  exit 1
fi

mkdir -p "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/unmanaged-plugin"

PATH="$MOCK_BIN:$PATH" \
HOME="$TEST_HOME" \
OBSIDIAN_VAULT_DIR="$OBSIDIAN_TEST_VAULT" \
make -s obsidian-clean

test ! -e "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/unmanaged-plugin"
test -e "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/dataview"
test -e "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/quickadd"

OBS_STATE_BEFORE="$TMP_DIR/obs-state-before.txt"
OBS_STATE_AFTER="$TMP_DIR/obs-state-after.txt"

for file in \
  "$OBSIDIAN_APP_CONFIG_FILE" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/core-plugins.json" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/templates.json" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/community-plugins.json" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/dataview/data.json" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/metadata-menu/data.json"; do
  file_state "$file" >> "$OBS_STATE_BEFORE"
done

sleep 1

PATH="$MOCK_BIN:$PATH" \
HOME="$TEST_HOME" \
OBSIDIAN_VAULT_DIR="$OBSIDIAN_TEST_VAULT" \
OBSIDIAN_APP_CONFIG_DIR="$OBSIDIAN_APP_CONFIG_DIR" \
DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1 \
bash ./scripts/setup-obsidian.sh

for file in \
  "$OBSIDIAN_APP_CONFIG_FILE" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/core-plugins.json" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/templates.json" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/community-plugins.json" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/dataview/data.json" \
  "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/metadata-menu/data.json"; do
  file_state "$file" >> "$OBS_STATE_AFTER"
done

if ! cmp -s "$OBS_STATE_BEFORE" "$OBS_STATE_AFTER"; then
  echo "❌ Obsidian setup is not idempotent; file metadata changed on second run"
  diff -u "$OBS_STATE_BEFORE" "$OBS_STATE_AFTER" || true
  exit 1
fi

# Validate human-readable hook output for activity reports and achievements.
HOOK_VAULT="$TMP_DIR/hook-vault"
mkdir -p "$HOOK_VAULT"
HOOK_CLAUDE_REPO="$TMP_DIR/hook-claude-repo"
HOOK_CLAUDE_REPO_WORKDIR="$HOOK_CLAUDE_REPO/src/app"
HOOK_CLAUDE_WORKSPACE="$TMP_DIR/hook-claude-workspace"
HOOK_REPO="$TMP_DIR/hook-repo"
HOOK_REPO_WORKDIR="$HOOK_REPO/src/app"
HOOK_WORKSPACE="$TMP_DIR/hook-workspace"

mkdir -p "$HOOK_CLAUDE_REPO_WORKDIR"
mkdir -p "$HOOK_CLAUDE_WORKSPACE"
mkdir -p "$HOOK_REPO_WORKDIR"
mkdir -p "$HOOK_WORKSPACE"
git -C "$HOOK_CLAUDE_REPO" init -q
git -C "$HOOK_REPO" init -q

printf '{"task":"achievement: Wrote a clearer deployment report for teammates","session_id":"session-1234567890"}' \
  | OBSIDIAN_VAULT_DIR="$HOOK_VAULT" python3 ./scripts/claude-obsidian-hook.py task-completed >/dev/null

test -f "$HOOK_VAULT/setup/claude-activity-log.md"
test -f "$HOOK_VAULT/career/achievement-inbox.md"
search_q "Task completed" "$HOOK_VAULT/setup/claude-activity-log.md"
search_q "^### .*\\| Candidate Achievement$" "$HOOK_VAULT/career/achievement-inbox.md"
search_q "^- Outcome: Wrote a clearer deployment report for teammates$" "$HOOK_VAULT/career/achievement-inbox.md"
search_q "^- Source: Claude task completed" "$HOOK_VAULT/career/achievement-inbox.md"

if search_q "event=" "$HOOK_VAULT/setup/claude-activity-log.md"; then
  echo "❌ Claude activity log still contains machine-style event fields"
  cat "$HOOK_VAULT/setup/claude-activity-log.md"
  exit 1
fi

printf '{"cwd":"%s","session_id":"session-claude-repo-1234567890"}' "$HOOK_CLAUDE_REPO_WORKDIR" \
  | OBSIDIAN_VAULT_DIR="$HOOK_VAULT" python3 ./scripts/claude-obsidian-hook.py session-start >/dev/null

printf '{"cwd":"%s","session_id":"session-claude-workspace-1234567890"}' "$HOOK_CLAUDE_WORKSPACE" \
  | OBSIDIAN_VAULT_DIR="$HOOK_VAULT" python3 ./scripts/claude-obsidian-hook.py session-start >/dev/null

test -f "$HOOK_CLAUDE_REPO/.claude/tasks.md"
test -f "$HOOK_CLAUDE_REPO/.claude/lessons.md"
test -f "$HOOK_CLAUDE_WORKSPACE/.claude/tasks.md"
test -f "$HOOK_CLAUDE_WORKSPACE/.claude/lessons.md"
test -f "$HOOK_CLAUDE_REPO/.agent/tasks.md"
test -f "$HOOK_CLAUDE_REPO/.agent/lessons.md"
test -f "$HOOK_CLAUDE_WORKSPACE/.agent/tasks.md"
test -f "$HOOK_CLAUDE_WORKSPACE/.agent/lessons.md"
cmp -s "$HOOK_CLAUDE_REPO/.claude/tasks.md" "$HOOK_CLAUDE_REPO/.agent/tasks.md"
cmp -s "$HOOK_CLAUDE_REPO/.claude/lessons.md" "$HOOK_CLAUDE_REPO/.agent/lessons.md"
cmp -s "$HOOK_CLAUDE_WORKSPACE/.claude/tasks.md" "$HOOK_CLAUDE_WORKSPACE/.agent/tasks.md"
cmp -s "$HOOK_CLAUDE_WORKSPACE/.claude/lessons.md" "$HOOK_CLAUDE_WORKSPACE/.agent/lessons.md"
assert_symlink_pair "$HOOK_CLAUDE_REPO/.claude/tasks.md" "$HOOK_CLAUDE_REPO/.agent/tasks.md"
assert_symlink_pair "$HOOK_CLAUDE_REPO/.claude/lessons.md" "$HOOK_CLAUDE_REPO/.agent/lessons.md"
assert_symlink_pair "$HOOK_CLAUDE_WORKSPACE/.claude/tasks.md" "$HOOK_CLAUDE_WORKSPACE/.agent/tasks.md"
assert_symlink_pair "$HOOK_CLAUDE_WORKSPACE/.claude/lessons.md" "$HOOK_CLAUDE_WORKSPACE/.agent/lessons.md"
search_q "^# Active Tasks$" "$HOOK_CLAUDE_REPO/.claude/tasks.md"
search_q "^# Lessons Learned$" "$HOOK_CLAUDE_REPO/.claude/lessons.md"
search_q "^# Active Tasks$" "$HOOK_CLAUDE_WORKSPACE/.claude/tasks.md"
search_q "^# Lessons Learned$" "$HOOK_CLAUDE_WORKSPACE/.claude/lessons.md"

codex_payload="$(jq -cn --arg cwd "$HOOK_REPO_WORKDIR" '{
  "type":"agent-turn-complete",
  "thread-id":"thread-abcdef1234567890",
  "cwd":$cwd,
  "input-messages":["impact: Reduced CI rerun rate with clearer reports"],
  "last-assistant-message":"Added a concise summary section and evidence bullets."
}')"

OBSIDIAN_VAULT_DIR="$HOOK_VAULT" python3 ./scripts/claude-obsidian-hook.py codex-notify "$codex_payload" >/dev/null

test -f "$HOOK_VAULT/setup/codex-activity-log.md"
test -f "$HOOK_REPO/.agent/tasks.md"
test -f "$HOOK_REPO/.agent/lessons.md"
test -f "$HOOK_REPO/.claude/tasks.md"
test -f "$HOOK_REPO/.claude/lessons.md"
cmp -s "$HOOK_REPO/.agent/tasks.md" "$HOOK_REPO/.claude/tasks.md"
cmp -s "$HOOK_REPO/.agent/lessons.md" "$HOOK_REPO/.claude/lessons.md"
assert_symlink_pair "$HOOK_REPO/.agent/tasks.md" "$HOOK_REPO/.claude/tasks.md"
assert_symlink_pair "$HOOK_REPO/.agent/lessons.md" "$HOOK_REPO/.claude/lessons.md"
search_q "Agent turn complete" "$HOOK_VAULT/setup/codex-activity-log.md"
search_q "User asked:" "$HOOK_VAULT/setup/codex-activity-log.md"
search_q "Assistant replied:" "$HOOK_VAULT/setup/codex-activity-log.md"
search_q "^- Source: Codex notify" "$HOOK_VAULT/career/achievement-inbox.md"
search_q "^# Active Tasks$" "$HOOK_REPO/.agent/tasks.md"
search_q "^# Lessons Learned$" "$HOOK_REPO/.agent/lessons.md"

codex_workspace_payload="$(jq -cn --arg cwd "$HOOK_WORKSPACE" '{
  "type":"agent-turn-complete",
  "thread-id":"thread-workspace-1234567890",
  "cwd":$cwd,
  "input-messages":["plain question in non-repo workspace"],
  "last-assistant-message":"Captured workspace-scoped planning files."
}')"

OBSIDIAN_VAULT_DIR="$HOOK_VAULT" python3 ./scripts/claude-obsidian-hook.py codex-notify "$codex_workspace_payload" >/dev/null

test -f "$HOOK_WORKSPACE/.agent/tasks.md"
test -f "$HOOK_WORKSPACE/.agent/lessons.md"
test -f "$HOOK_WORKSPACE/.claude/tasks.md"
test -f "$HOOK_WORKSPACE/.claude/lessons.md"
cmp -s "$HOOK_WORKSPACE/.agent/tasks.md" "$HOOK_WORKSPACE/.claude/tasks.md"
cmp -s "$HOOK_WORKSPACE/.agent/lessons.md" "$HOOK_WORKSPACE/.claude/lessons.md"
assert_symlink_pair "$HOOK_WORKSPACE/.agent/tasks.md" "$HOOK_WORKSPACE/.claude/tasks.md"
assert_symlink_pair "$HOOK_WORKSPACE/.agent/lessons.md" "$HOOK_WORKSPACE/.claude/lessons.md"
test ! -f "$HOOK_VAULT/tasks.md"
test ! -f "$HOOK_VAULT/learning/lessons.md"
search_q "^# Active Tasks$" "$HOOK_WORKSPACE/.agent/tasks.md"
search_q "^# Lessons Learned$" "$HOOK_WORKSPACE/.agent/lessons.md"

# Ensure achievements are not captured from every prompt:
# only latest explicit marker is captured and duplicates are suppressed.
codex_non_achievement_payload="$(jq -cn --arg cwd "$HOOK_REPO_WORKDIR" '{
  "type":"agent-turn-complete",
  "thread-id":"thread-abcdef1234567890",
  "cwd":$cwd,
  "input-messages":["achievement: old marker from previous turn","plain follow-up question"],
  "last-assistant-message":"No achievement marker here."
}')"

OBSIDIAN_VAULT_DIR="$HOOK_VAULT" python3 ./scripts/claude-obsidian-hook.py codex-notify "$codex_non_achievement_payload" >/dev/null
OBSIDIAN_VAULT_DIR="$HOOK_VAULT" python3 ./scripts/claude-obsidian-hook.py codex-notify "$codex_payload" >/dev/null

codex_achievement_count="$(search_count "^- Source: Codex notify" "$HOOK_VAULT/career/achievement-inbox.md")"
if [[ "$codex_achievement_count" != "1" ]]; then
  echo "❌ Codex achievement capture should be explicit and de-duplicated; expected 1 entry, got $codex_achievement_count"
  cat "$HOOK_VAULT/career/achievement-inbox.md"
  exit 1
fi

if search_q "user=|assistant=|event=" "$HOOK_VAULT/setup/codex-activity-log.md"; then
  echo "❌ Codex activity log still contains machine-style telemetry fields"
  cat "$HOOK_VAULT/setup/codex-activity-log.md"
  exit 1
fi

echo "✓ setup.sh smoke test passed with mocked toolchain"
