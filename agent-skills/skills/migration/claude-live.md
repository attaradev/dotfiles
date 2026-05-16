## Live context

- Working directory: !`pwd`
- Existing architecture or migration docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(migration|migrate|cutover|strangler|re-platform)" 2>/dev/null | head -8 || true`
- Infrastructure config: !`find . -maxdepth 4 -name "*.tf" -o -name "docker-compose*.yml" 2>/dev/null | head -10 || true`
