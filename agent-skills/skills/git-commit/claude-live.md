## Live context

- Status: !`git status --short --branch 2>/dev/null || true`
- Staged diff stat: !`git diff --cached --stat 2>/dev/null || true`
- Staged diff: !`git diff --cached 2>/dev/null || true`
- Recent commits (format/style reference only — not content): !`git log --oneline -8 2>/dev/null || true`
- Jira ticket (from branch): !`git branch --show-current 2>/dev/null | grep -oE '[A-Z][A-Z0-9]+-[0-9]+' | head -1 || echo "(none)"`
