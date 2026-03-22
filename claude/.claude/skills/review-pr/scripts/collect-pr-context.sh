#!/usr/bin/env bash
# Collect GitHub PR context for review.
# Usage: collect-pr-context.sh <PR-number> [owner/repo]

set -euo pipefail

# Accept either: <PR-number> [owner/repo]  OR  a raw spec like "#3258" / "owner/repo#3258"
RAW="${1:?Usage: collect-pr-context.sh <PR-spec> [owner/repo]}"
PR=$(echo "$RAW" | grep -oE '[0-9]+' | tail -1)
REPO_SLUG="${2:-$(echo "$RAW" | grep -oE '^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+' | head -1)}"
R=()
[ -n "$REPO_SLUG" ] && R=(-R "$REPO_SLUG")

echo "=== PR SUMMARY ==="
gh pr view "$PR" "${R[@]}"

echo ""
echo "=== CHANGED FILES ==="
gh pr view "$PR" "${R[@]}" --json files \
  --jq '.files[] | "\(.additions)+\(.deletions)-\t\(.path)"'

echo ""
echo "=== LABELS ==="
gh pr view "$PR" "${R[@]}" --json labels \
  --jq '.labels[] | .name' 2>/dev/null || true

echo ""
echo "=== LINKED ISSUES ==="
gh pr view "$PR" "${R[@]}" --json closingIssuesReferences \
  --jq '.closingIssuesReferences[] | "#\(.number) \(.title)"' 2>/dev/null || true

echo ""
echo "=== EXISTING REVIEWS ==="
gh pr view "$PR" "${R[@]}" --json reviews \
  --jq '.reviews[] | "[\(.state)] \(.author.login): \(.body)"' 2>/dev/null \
  | head -80 || true

echo ""
echo "=== FULL DIFF ==="
gh pr diff "$PR" "${R[@]}"
