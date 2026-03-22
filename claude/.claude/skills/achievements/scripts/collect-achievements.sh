#!/usr/bin/env bash
# Collect achievement signals for a time period.
# Usage: collect-achievements.sh [since] [until]
#   since: any git-understood date, e.g. "1 month ago", "2026-01-01", "3 weeks ago" (default: 3 months ago)
#   until: optional upper bound (default: now)

set -euo pipefail

SINCE="${1:-3 months ago}"
UNTIL="${2:-}"

AUTHOR_EMAIL=$(git config user.email 2>/dev/null || echo "")
AUTHOR_NAME=$(git config user.name 2>/dev/null || echo "")

echo "=== IDENTITY ==="
echo "Name:   $AUTHOR_NAME"
echo "Email:  $AUTHOR_EMAIL"
echo "Period: since '$SINCE'${UNTIL:+ until '$UNTIL'}"

echo ""
echo "=== COMMITS AUTHORED (no merges) ==="
git log \
  --author="$AUTHOR_EMAIL" \
  --since="$SINCE" \
  ${UNTIL:+--until="$UNTIL"} \
  --no-merges \
  --oneline \
  --decorate \
  2>/dev/null || echo "(no git repo or no commits in range)"

echo ""
echo "=== COMMIT VOLUME ==="
COMMIT_COUNT=$(git log \
  --author="$AUTHOR_EMAIL" \
  --since="$SINCE" \
  ${UNTIL:+--until="$UNTIL"} \
  --no-merges --oneline 2>/dev/null | wc -l | tr -d ' ')
echo "$COMMIT_COUNT commits"
git log \
  --author="$AUTHOR_EMAIL" \
  --since="$SINCE" \
  ${UNTIL:+--until="$UNTIL"} \
  --no-merges --numstat 2>/dev/null \
  | awk 'NF==3 && $1~/^[0-9]+$/ {add+=$1; del+=$2} END {print add+0" lines added, "del+0" lines removed"}' \
  || true

echo ""
echo "=== PRS AUTHORED AND MERGED ==="
gh pr list \
  --author "@me" \
  --state merged \
  --limit 100 \
  --json number,title,mergedAt,baseRefName,additions,deletions,url \
  --jq '.[] | "#\(.number)  \(.title)  [→ \(.baseRefName)]  +\(.additions)/-\(.deletions)  merged \(.mergedAt[:10])"' \
  2>/dev/null || echo "(gh not available or no merged PRs)"

echo ""
echo "=== PRS REVIEWED (approved or commented) ==="
gh search prs \
  --reviewed-by "@me" \
  --state merged \
  --limit 50 \
  --json number,title,mergedAt,repository \
  --jq '.[] | "#\(.number)  \(.title)  [\(.repository.name)]  merged \(.mergedAt[:10])"' \
  2>/dev/null | head -30 || echo "(gh search not available)"

echo ""
echo "=== ISSUES CLOSED (assigned to me) ==="
gh issue list \
  --assignee "@me" \
  --state closed \
  --limit 50 \
  --json number,title,closedAt,url \
  --jq '.[] | "#\(.number)  \(.title)  closed \(.closedAt[:10])"' \
  2>/dev/null || echo "(gh not available or no issues)"

echo ""
echo "=== REPOS WITH COMMITS ==="
git log \
  --author="$AUTHOR_EMAIL" \
  --since="$SINCE" \
  ${UNTIL:+--until="$UNTIL"} \
  --no-merges --format="%H" 2>/dev/null | wc -l | tr -d ' ' \
  | xargs -I{} bash -c 'echo "{} commits in $(basename $(git rev-parse --show-toplevel 2>/dev/null || echo unknown))"' \
  || true
