## Live context

- Current branch: !`git branch --show-current 2>/dev/null || true`
- Base branch: !`git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}' || echo "main"`
- Jira ticket (from branch): !`git branch --show-current 2>/dev/null | grep -oE '[A-Z][A-Z0-9]+-[0-9]+' | head -1 || echo "(none)"`
- Commits on this branch (sequence context only — not content): !`git log --oneline origin/$ARGUMENTS..HEAD 2>/dev/null || git log --oneline origin/HEAD..HEAD 2>/dev/null || git log --oneline main..HEAD 2>/dev/null || git log --oneline -10`
- Diff stat: !`git diff --stat origin/$ARGUMENTS..HEAD 2>/dev/null || git diff --stat origin/HEAD..HEAD 2>/dev/null || git diff --stat main..HEAD 2>/dev/null || true`
- Full diff: !`git diff origin/$ARGUMENTS..HEAD 2>/dev/null || git diff origin/HEAD..HEAD 2>/dev/null || git diff main..HEAD 2>/dev/null || true`
- Existing open PR (if any): !`gh pr view --json title,body,url 2>/dev/null || echo "(no open PR)"`
