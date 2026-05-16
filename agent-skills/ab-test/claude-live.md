## Live context

- Working directory: !`pwd`
- Existing experiment or analytics docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(experiment|a/b test|split test|hypothesis|sample size)" 2>/dev/null | head -8 || true`
