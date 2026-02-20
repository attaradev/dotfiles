#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

pattern='/(Users|home)/[A-Za-z0-9._-]+/'

scan_files=()
while IFS= read -r file; do
  [[ "$file" == "scripts/check-no-absolute-host-paths.sh" ]] && continue
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
