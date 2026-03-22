#!/usr/bin/env bash
# Collect GitHub PR context for review.
# Usage: collect-pr-context.sh <PR-number> [owner/repo]

set -euo pipefail

PR="${1:?Usage: collect-pr-context.sh <PR-number> [owner/repo]}"
REPO_SLUG="${2:-}"
R=""
[ -n "$REPO_SLUG" ] && R="-R $REPO_SLUG"

echo "=== PR SUMMARY ==="
gh pr view "$PR" $R

echo ""
echo "=== CHANGED FILES ==="
gh pr view "$PR" $R --json files \
  --jq '.files[] | "\(.additions)+\(.deletions)-\t\(.path)"'

echo ""
echo "=== LINKED ISSUES ==="
gh pr view "$PR" $R --json closingIssuesReferences \
  --jq '.closingIssuesReferences[] | "#\(.number) \(.title)"' 2>/dev/null || true

echo ""
echo "=== EXISTING REVIEWS ==="
gh pr view "$PR" $R --json reviews \
  --jq '.reviews[] | "[\(.state)] \(.author.login): \(.body)"' 2>/dev/null \
  | head -80 || true

echo ""
echo "=== FULL DIFF ==="
gh pr diff "$PR" $R
