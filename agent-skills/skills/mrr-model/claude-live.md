## Live context

- Working directory: !`pwd`
- Existing financial model files: !`find . -maxdepth 4 -type f -name "*.md" -o -name "*.csv" | xargs grep -l -iE "(mrr|arr|cac|ltv|churn|revenue|arpu)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
