## Live context

- Working directory: !`pwd`
- Existing roadmap or backlog docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(roadmap|backlog|priorit|rice|moscow)" 2>/dev/null | head -8 || true`
