## Live context

- Working directory: !`pwd`
- Existing specs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(user story|acceptance criteria|given when then|epic)" 2>/dev/null | head -8 || true`
