## Live context

- Working directory: !`pwd`
- Repository structure: !`find . -maxdepth 3 -not -path './.git/*' -not -path './node_modules/*' -not -path './.venv/*' -type f | head -80 2>/dev/null || true`
- Existing design docs: !`find . -iname "*.md" \( -path "*/design*" -o -path "*/spec*" -o -path "*/rfc*" -o -path "*/docs*" \) 2>/dev/null | grep -v node_modules | head -15 || true`
- Recent commits (for context): !`git log --oneline -15 2>/dev/null || true`
- Key manifests: !`ls -1 go.mod package.json pyproject.toml Cargo.toml 2>/dev/null | head -5 || true`
