## Live context

- Working directory: !`pwd`
- Existing customer or persona docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(persona|customer|segment|icp|buyer)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
