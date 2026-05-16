## Live context

- Working directory: !`pwd`
- Existing research or experiment docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(hypothesis|experiment|validate|riskiest assumption|lean)" 2>/dev/null | head -8 || true`
