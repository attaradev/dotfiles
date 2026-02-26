#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

TEST_HOME="$TMP_DIR/home"
MOCK_BIN="$TMP_DIR/mock-bin"
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

PATH="$MOCK_BIN:$PATH" \
HOME="$TEST_HOME" \
OBSIDIAN_VAULT_DIR="$OBSIDIAN_TEST_VAULT" \
DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1 \
bash ./scripts/setup-obsidian.sh

test -f "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/dataview/data.json"
test -f "$OBSIDIAN_TEST_VAULT/.obsidian/plugins/metadata-menu/data.json"

echo "✓ setup.sh smoke test passed with mocked toolchain"
