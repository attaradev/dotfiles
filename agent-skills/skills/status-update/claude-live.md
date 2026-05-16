## Live context

- Working directory: !`pwd`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Recent commits — current repo (last 7 days): !`git log --since='7 days ago' --oneline --decorate 2>/dev/null || true`
- Changed files vs main: !`git diff --name-status origin/HEAD...HEAD 2>/dev/null || git diff --name-status HEAD~5...HEAD 2>/dev/null || true`
- Open PRs — current repo: !`gh pr list --state open --limit 10 2>/dev/null || true`
- Recently merged PRs — current repo: !`gh pr list --state merged --limit 10 2>/dev/null || true`
- Recent activity across all repos (last 7 days): run via Bash tool: `bash "$HOME/.claude/skills/status-update/scripts/collect-activity.sh" 2>/dev/null || git log --oneline --since='7 days ago' 2>/dev/null | head -20 || true`
