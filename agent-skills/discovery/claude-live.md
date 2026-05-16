## Live context

- Working directory: !`pwd`
- Existing research or product docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(persona|user research|interview|discovery|hypothesis)" 2>/dev/null | head -8 || true`
