#!/usr/bin/env bash
# Collect recent git activity across common code directories (last 7 days).
# Reads GIT_SEARCH_ROOTS (colon-separated) or defaults to ~/code:~/projects:~/src:~/dev:~/work

set -euo pipefail

AUTHOR=$(git config --global user.email 2>/dev/null || git config user.email 2>/dev/null || echo "")
DEFAULT_ROOTS="$HOME/code:$HOME/projects:$HOME/src:$HOME/dev:$HOME/work"

IFS=':' read -ra ROOTS <<< "${GIT_SEARCH_ROOTS:-$DEFAULT_ROOTS}"

for root in "${ROOTS[@]}"; do
  [[ -d "$root" ]] || continue
  find "$root" -maxdepth 3 -name ".git" -type d 2>/dev/null | while IFS= read -r g; do
    r="${g%/.git}"
    n=$(basename "$r")
    out=$(git -C "$r" log --author="$AUTHOR" --since='7 days ago' --no-merges --oneline 2>/dev/null)
    [[ -n "$out" ]] && echo "[$n] $out"
  done
done
