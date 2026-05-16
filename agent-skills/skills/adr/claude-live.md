## Live context

- Working directory: !`pwd`
- Existing ADRs: !`find . -iname "*.md" -path "*/adr*" -o -iname "*.md" -path "*/decisions*" -o -iname "ADR-*.md" 2>/dev/null | sort | head -20 || true`
- Last ADR number: !`find . -iname "ADR-*.md" -o -iname "[0-9]*.md" -path "*/adr*" 2>/dev/null | sort | tail -1 || echo "(none found)"`
- Recent commits (for context): !`git log --oneline -10 2>/dev/null || true`
