## Live context

- Working directory: !`pwd`
- Recent commits (for context): !`git log --oneline -10 2>/dev/null || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
- Existing docs: !`find . -maxdepth 3 -name "*.md" -o -name "*.mdx" 2>/dev/null | grep -vE "(node_modules|vendor|\.git|CHANGELOG|LICENSE)" | head -8 || true`
