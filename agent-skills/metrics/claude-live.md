## Live context

- Working directory: !`pwd`
- Existing metrics or analytics docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(metric|kpi|north star|analytics|measurement|okr)" 2>/dev/null | head -8 || true`
