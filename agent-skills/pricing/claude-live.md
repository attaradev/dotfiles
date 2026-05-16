## Live context

- Working directory: !`pwd`
- Existing pricing references: !`find . -maxdepth 4 -type f -name "*.md" -o -name "*.txt" | xargs grep -l -iE "(pricing|tier|plan|freemium|trial)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
