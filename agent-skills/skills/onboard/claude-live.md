## Live context

- Working directory: !`pwd`
- Root files: !`ls -1 2>/dev/null | head -40 || true`
- Repository structure (depth 3): !`find . -maxdepth 3 -not -path './.git/*' -not -path './node_modules/*' -not -path './.venv/*' -not -path './vendor/*' -type f | head -150 2>/dev/null || true`
- README: !`cat README.md 2>/dev/null | head -100 || cat readme.md 2>/dev/null | head -100 || echo "(no README)"`
- Key manifests: !`cat go.mod 2>/dev/null | head -20 || cat package.json 2>/dev/null | head -30 || cat pyproject.toml 2>/dev/null | head -20 || cat Cargo.toml 2>/dev/null | head -20 || true`
- Recent commits: !`git log --oneline -15 2>/dev/null || true`
- Top contributors: !`git shortlog -sn --no-merges 2>/dev/null | head -8 || true`
