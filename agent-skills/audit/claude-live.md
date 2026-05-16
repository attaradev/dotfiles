## Live context

- Working directory: !`pwd`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Changed files: !`git diff --name-status HEAD 2>/dev/null || true`
- Diff: !`git diff HEAD 2>/dev/null || true`
- Dependencies (for known-vuln check): !`cat go.sum package-lock.json requirements.txt Cargo.lock 2>/dev/null | head -50 || true`

If `$ARGUMENTS` is a PR number or URL, fetch the diff with: `gh pr diff <number> 2>/dev/null`
