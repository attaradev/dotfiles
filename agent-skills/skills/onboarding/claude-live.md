## Live context

- Working directory: !`pwd`
- Existing onboarding docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(onboard|activation|aha.moment|time.to.value|trial|welcome)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
