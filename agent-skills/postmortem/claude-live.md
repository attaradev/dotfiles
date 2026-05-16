## Live context

- Working directory: !`pwd`
- Existing incident docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(incident|outage|postmortem|p0|p1|sev)" 2>/dev/null | head -8 || true`
- Recent git log around incident time: !`git log --oneline --since="7 days ago" 2>/dev/null | head -20 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
