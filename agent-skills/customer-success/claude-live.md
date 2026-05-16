## Live context

- Working directory: !`pwd`
- Existing CS or account management docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(customer.success|health.score|qbr|expansion|upsell|churn|account)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
