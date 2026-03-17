#!/usr/bin/env bash
# Repository quality checks. Run via `make check`.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# ---------------------------------------------------------------------------
# Local-override enforcement
# ---------------------------------------------------------------------------

require_fixed_line() {
  local file="$1"
  local expected="$2"
  local message="$3"

  if ! grep -Fqx "$expected" "$file"; then
    echo "❌ $message"
    exit 1
  fi
}

require_fixed_line "git/.gitconfig" $'\tpath = ~/.gitconfig.local' \
  "git/.gitconfig must include ~/.gitconfig.local for machine-specific Git settings."

require_fixed_line "ssh/.ssh/config" "Include ~/.ssh/config.local ~/.ssh/config.local.d/*.conf" \
  "ssh/.ssh/config must include local override files for host-specific SSH settings."

require_fixed_line "npm/.npmrc" 'globalconfig=${HOME}/.npmrc.local' \
  "npm/.npmrc must delegate machine-local npm auth/settings to ~/.npmrc.local."

require_fixed_line "zsh/.zshrc" 'if [[ -r "$HOME/.zshrc.local" ]]; then' \
  "zsh/.zshrc must source ~/.zshrc.local for machine-specific shell customizations."

require_fixed_line "zsh/.zshrc" 'for zsh_local_snippet in "$HOME"/.zshrc.local.d/*.zsh(N); do' \
  "zsh/.zshrc must source ~/.zshrc.local.d/*.zsh snippets for machine-specific shell customizations."

require_fixed_line "zsh/.zshrc" '# The following lines have been added by Docker Desktop to enable Docker CLI completions.' \
  "zsh/.zshrc must include Docker Desktop's completion marker so Docker Desktop detects completions as installed."

require_fixed_line "zsh/.zshrc" 'fpath=("${HOME:A}/.docker/completions" $fpath)' \
  "zsh/.zshrc must include Docker Desktop's runtime-absolute completion path."

git_violations="$(
  awk '
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*$/ { next }
    /^\[/ { section = $0; next }
    section == "[user]" && /^[[:space:]]*(name|email|signingkey)[[:space:]]*=/ { print NR ":" $0 }
    section == "[commit]" && /^[[:space:]]*gpgsign[[:space:]]*=/ { print NR ":" $0 }
    section == "[tag]" && /^[[:space:]]*(gpgSign|forceSignAnnotated)[[:space:]]*=/ { print NR ":" $0 }
  ' git/.gitconfig
)"

if [[ -n "$git_violations" ]]; then
  echo "❌ git/.gitconfig contains machine-specific settings that belong in ~/.gitconfig.local:"
  echo "$git_violations"
  exit 1
fi

npm_violations="$(grep -nE '(^|[:[:space:]])_authToken[[:space:]]*=|_password[[:space:]]*=' npm/.npmrc || true)"

if [[ -n "$npm_violations" ]]; then
  echo "❌ npm/.npmrc contains auth secrets that belong in ~/.npmrc.local:"
  echo "$npm_violations"
  exit 1
fi

echo "✓ Local override enforcement checks passed"

# ---------------------------------------------------------------------------
# Docs ↔ Makefile target consistency
# ---------------------------------------------------------------------------

doc_files=(README.md SECURITY.md)
if [[ -d "docs" ]]; then
  while IFS= read -r file; do
    doc_files+=("$file")
  done < <(find docs -type f -name '*.md' | sort)
fi

make_targets="$(awk -F':' '/^[A-Za-z0-9_.-]+:/ {print $1}' Makefile | sort -u)"

referenced_targets="$(awk '
  {
    line = $0
    while (match(line, /`make[[:space:]]+[A-Za-z0-9_.-]+`/)) {
      cmd = substr(line, RSTART + 1, RLENGTH - 2)
      sub(/^make[[:space:]]+/, "", cmd)
      split(cmd, parts, /[[:space:]]+/)
      print parts[1]
      line = substr(line, RSTART + RLENGTH)
    }

    if (match($0, /^[[:space:]]*make[[:space:]]+[A-Za-z0-9_.-]+/)) {
      cmd = substr($0, RSTART, RLENGTH)
      sub(/^[[:space:]]*make[[:space:]]+/, "", cmd)
      split(cmd, parts, /[[:space:]]+/)
      print parts[1]
    }
  }
' "${doc_files[@]}" | sort -u)"

missing=0
while IFS= read -r target; do
  [[ -z "$target" ]] && continue
  if ! printf '%s\n' "$make_targets" | grep -Fxq "$target"; then
    if [[ "$missing" -eq 0 ]]; then
      echo "❌ Docs reference make targets not found in Makefile:"
    fi
    echo "  - $target"
    missing=1
  fi
done <<< "$referenced_targets"

if [[ "$missing" -eq 1 ]]; then
  exit 1
fi

echo "✓ Docs reference valid make targets"

# ---------------------------------------------------------------------------
# No absolute host-specific paths in tracked files
# ---------------------------------------------------------------------------

pattern='/(Users|home)/[A-Za-z0-9._-]+/'

scan_files=()
while IFS= read -r file; do
  [[ "$file" == "scripts/check.sh" ]] && continue
  [[ "$file" == "scripts/smoke.sh" ]] && continue
  [[ -e "$file" ]] || continue
  scan_files+=("$file")
done < <(git ls-files)

if [[ ${#scan_files[@]} -eq 0 ]]; then
  echo "✓ No tracked files to scan"
  exit 0
fi

matches="$(grep -nHE "$pattern" "${scan_files[@]}" || true)"

if [[ -n "$matches" ]]; then
  echo "❌ Absolute host-specific paths found in tracked files:"
  echo "$matches"
  echo "Use \$HOME or relative paths instead of user-specific absolute paths."
  exit 1
fi

echo "✓ No host-specific absolute paths found"
