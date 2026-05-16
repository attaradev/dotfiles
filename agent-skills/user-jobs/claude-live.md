## Live context

- Working directory: !`pwd`
- Existing product docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(user story|persona|prd|job to be done|jtbd)" 2>/dev/null | head -8 || true`
