## Live context

- Working directory: !`pwd`
- Recent commits: !`git log --oneline -30 2>/dev/null || true`
- Existing changelog: !`find . -maxdepth 2 -name "CHANGELOG*" -o -name "RELEASES*" 2>/dev/null | head -3 || true`
- Latest tag: !`git describe --tags --abbrev=0 2>/dev/null || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
