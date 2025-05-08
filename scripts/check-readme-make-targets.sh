#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -f "Makefile" ]]; then
  echo "❌ Makefile not found"
  exit 1
fi

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
