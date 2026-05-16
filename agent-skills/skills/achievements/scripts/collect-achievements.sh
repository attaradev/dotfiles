#!/usr/bin/env bash
# Collect achievement signals for a time period across all local git repos.
# Usage: collect-achievements.sh [since] [until]
#   since: any git-understood date, e.g. "1 month ago", "2026-01-01" (default: 3 months ago)
#   until: optional upper bound (default: now)
#
# To customise which directories are scanned for git repos, set:
#   GIT_SEARCH_ROOTS  colon-separated root paths (default: ~/code:~/projects:~/src:~/dev:~/work)

set -euo pipefail

SINCE="${1:-3 months ago}"
UNTIL="${2:-}"

AUTHOR_EMAIL=$(git config --global user.email 2>/dev/null || git config user.email 2>/dev/null || echo "")
AUTHOR_NAME=$(git config --global user.name 2>/dev/null || git config user.name 2>/dev/null || echo "")

echo "=== IDENTITY ==="
echo "Name:   $AUTHOR_NAME"
echo "Email:  $AUTHOR_EMAIL"
echo "Period: since '$SINCE'${UNTIL:+ until '$UNTIL'}"

# Convert a human date string to ISO-8601 for gh search date filters
_date_to_iso() {
  python3 -c "
import re, sys
from datetime import date, timedelta
import calendar

s = sys.argv[1].lower().strip()
today = date.today()

if re.match(r'^\d{4}-\d{2}-\d{2}$', s):
    print(s)
elif re.match(r'(\d+)\s+months?\s+ago', s):
    n = int(re.match(r'(\d+)', s).group(1))
    y, mo = today.year, today.month - n
    while mo <= 0:
        mo += 12
        y -= 1
    d = min(today.day, calendar.monthrange(y, mo)[1])
    print(date(y, mo, d).isoformat())
elif re.match(r'(\d+)\s+weeks?\s+ago', s):
    n = int(re.match(r'(\d+)', s).group(1))
    print((today - timedelta(weeks=n)).isoformat())
elif re.match(r'(\d+)\s+days?\s+ago', s):
    n = int(re.match(r'(\d+)', s).group(1))
    print((today - timedelta(days=n)).isoformat())
else:
    print((today - timedelta(days=90)).isoformat())
" "$1" 2>/dev/null || echo ""
}

SINCE_ISO=$(_date_to_iso "$SINCE")
UNTIL_ISO="${UNTIL:+$(_date_to_iso "$UNTIL")}"

# --- Discover git repositories ---
DEFAULT_ROOTS="$HOME/code:$HOME/projects:$HOME/src:$HOME/dev:$HOME/work"
REPOS=()
IFS=':' read -ra ROOTS <<< "${GIT_SEARCH_ROOTS:-$DEFAULT_ROOTS}"
for root in "${ROOTS[@]}"; do
  [[ -d "$root" ]] || continue
  while IFS= read -r gitdir; do
    REPOS+=("${gitdir%/.git}")
  done < <(find "$root" -maxdepth 3 -name ".git" -type d 2>/dev/null | sort -u)
done

# Always include the current repo if it's outside the search roots
if git rev-parse --git-dir &>/dev/null; then
  CURRENT_REPO=$(git rev-parse --show-toplevel 2>/dev/null || true)
  if [[ -n "$CURRENT_REPO" ]]; then
    already=0
    if [[ "${#REPOS[@]}" -gt 0 ]]; then
      for r in "${REPOS[@]}"; do [[ "$r" == "$CURRENT_REPO" ]] && already=1 && break; done
    fi
    [[ $already -eq 0 ]] && REPOS+=("$CURRENT_REPO")
  fi
fi

echo ""
echo "=== REPOS SCANNED ==="
if [[ "${#REPOS[@]}" -eq 0 ]]; then
  echo "(no repos found — set GIT_SEARCH_ROOTS to point at your code directories)"
else
  for r in "${REPOS[@]}"; do echo "  ${r/#$HOME/~}"; done
fi

# --- Commits authored across all repos ---
echo ""
echo "=== COMMITS AUTHORED (no merges) ==="
TOTAL_COMMITS=0
TOTAL_ADDED=0
TOTAL_REMOVED=0

if [[ "${#REPOS[@]}" -gt 0 ]]; then
  for repo in "${REPOS[@]}"; do
    [[ -d "$repo/.git" ]] || continue
    REPO_NAME=$(basename "$repo")

    # Single pass: extract commit list and line stats together
    RAW=$(git -C "$repo" log \
      --author="$AUTHOR_EMAIL" \
      --since="$SINCE" \
      ${UNTIL:+--until="$UNTIL"} \
      --no-merges \
      --format="COMMIT %h %s" \
      --numstat \
      2>/dev/null || true)

    [[ -z "$RAW" ]] && continue

    COMMIT_LINES=$(echo "$RAW" | grep '^COMMIT ' | sed 's/^COMMIT //')
    COUNT=$(echo "$COMMIT_LINES" | wc -l | tr -d ' ')
    read -r ADDED REMOVED < <(echo "$RAW" | awk 'NF==3 && $1~/^[0-9]+$/ {add+=$1; rem+=$2} END {print add+0, rem+0}')

    TOTAL_COMMITS=$((TOTAL_COMMITS + COUNT))
    TOTAL_ADDED=$((TOTAL_ADDED + ${ADDED:-0}))
    TOTAL_REMOVED=$((TOTAL_REMOVED + ${REMOVED:-0}))

    echo ""
    echo "-- [$REPO_NAME] $COUNT commits --"
    echo "$COMMIT_LINES"
  done
fi

echo ""
echo "=== COMMIT VOLUME ==="
echo "$TOTAL_COMMITS commits across ${#REPOS[@]} repos"
echo "${TOTAL_ADDED} lines added, ${TOTAL_REMOVED} lines removed"

# --- PRs authored across all repos (gh search = cross-org) ---
echo ""
echo "=== PRS AUTHORED AND MERGED ==="
gh search prs \
  --author "@me" \
  --merged \
  ${SINCE_ISO:+--merged-at ">=$SINCE_ISO"} \
  ${UNTIL_ISO:+--merged-at "<=$UNTIL_ISO"} \
  --limit 100 \
  --json number,title,closedAt,repository,url \
  --jq '.[] | "#\(.number)  \(.title)  [\(.repository.nameWithOwner)]  merged \(.closedAt[:10])"' \
  2>/dev/null || echo "(gh not available or no merged PRs)"

# --- PRs reviewed across all repos (gh search = cross-org) ---
echo ""
echo "=== PRS REVIEWED (approved or commented) ==="
gh search prs \
  --reviewed-by "@me" \
  --merged \
  ${SINCE_ISO:+--merged-at ">=$SINCE_ISO"} \
  ${UNTIL_ISO:+--merged-at "<=$UNTIL_ISO"} \
  --limit 100 \
  --json number,title,closedAt,repository \
  --jq '.[] | "#\(.number)  \(.title)  [\(.repository.nameWithOwner)]  merged \(.closedAt[:10])"' \
  2>/dev/null || echo "(gh search not available)"

# --- Issues closed across all repos (gh search = cross-org) ---
echo ""
echo "=== ISSUES CLOSED (assigned to me) ==="
gh search issues \
  --assignee "@me" \
  --state closed \
  ${SINCE_ISO:+--closed ">=$SINCE_ISO"} \
  ${UNTIL_ISO:+--closed "<=$UNTIL_ISO"} \
  --limit 50 \
  --json number,title,closedAt,repository,url \
  --jq '.[] | "#\(.number)  \(.title)  [\(.repository.nameWithOwner)]  closed \(.closedAt[:10])"' \
  2>/dev/null || echo "(gh not available or no issues)"
