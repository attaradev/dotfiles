## Live context

- Working directory: !`pwd`
- Existing product docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(opportunity|problem statement|prd|strategy)" 2>/dev/null | head -8 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
