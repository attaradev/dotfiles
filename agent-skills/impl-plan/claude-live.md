## Live context

- Working directory: !`pwd`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Status: !`git status --short --branch 2>/dev/null || true`
- Repository structure: !`find . -maxdepth 3 -not -path './.git/*' -not -path './node_modules/*' -not -path './.venv/*' -type f | head -100 2>/dev/null || true`
- Recent commits: !`git log --oneline -n 15 2>/dev/null || true`
- Key manifests: !`ls -1 *.json *.toml *.yaml *.yml Makefile go.mod pyproject.toml package.json 2>/dev/null | head -15 || true`
