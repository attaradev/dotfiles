## Live context

- Working directory: !`pwd`
- Analytics or metrics files: !`find . -maxdepth 4 -type f -name "*.md" -o -name "*.sql" | xargs grep -l -iE "(churn|cancel|retention|cohort|mrr)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
