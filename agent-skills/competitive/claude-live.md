## Live context

- Working directory: !`pwd`
- Existing competitive docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(competitor|competitive|market|landscape|alternative)" 2>/dev/null | head -8 || true`
