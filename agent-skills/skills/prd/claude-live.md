## Live context

- Working directory: !`pwd`
- Existing specs or docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(prd|requirements|spec|feature brief|acceptance criteria)" 2>/dev/null | head -8 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
