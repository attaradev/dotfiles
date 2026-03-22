#!/usr/bin/env bash
# Collect structured commit data since the last git tag.
# Output is formatted for changelog classification.

set -euo pipefail

LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

if [ -n "$LAST_TAG" ]; then
  RANGE="${LAST_TAG}..HEAD"
  echo "=== CHANGES SINCE ${LAST_TAG} ==="
else
  RANGE="HEAD~30..HEAD"
  echo "=== LAST 30 COMMITS (no tags found) ==="
fi

echo ""
echo "=== COMMIT LOG (subject + body) ==="
git log "$RANGE" \
  --format="--- %H%nDate: %ad%nAuthor: %an%nSubject: %s%nBody: %b%n" \
  --date=short \
  2>/dev/null || true

echo ""
echo "=== BREAKING CHANGES ==="
git log "$RANGE" --format="%s%n%b" 2>/dev/null \
  | grep -i "BREAKING CHANGE\|^feat!\|^fix!\|^refactor!" || echo "(none)"

echo ""
echo "=== MERGED PRS ==="
git log "$RANGE" --oneline --merges 2>/dev/null | head -20 || echo "(none)"

echo ""
echo "=== FILES CHANGED ==="
git diff "${LAST_TAG:-HEAD~30}..HEAD" --stat 2>/dev/null | tail -3 || true
