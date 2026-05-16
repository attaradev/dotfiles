## Live context

- Working directory: !`pwd`
- Existing positioning or messaging docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(positioning|value.prop|messaging|tagline|headline|differenti|competitor|alternative)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
