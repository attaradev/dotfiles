## Live context

- Working directory: !`pwd`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Status: !`git status --short --branch 2>/dev/null || true`
- Changed files (vs HEAD): !`git diff --name-status HEAD 2>/dev/null || true`
- Diff stat: !`git diff --stat HEAD 2>/dev/null || true`
- Recent commits: !`git log --oneline -n 10 2>/dev/null || true`

If `$ARGUMENTS` names a branch, compare against it (e.g., `git diff origin/main...HEAD`). If it names a file or directory, scope the diff accordingly.
