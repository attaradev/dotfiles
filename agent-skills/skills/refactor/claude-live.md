## Live context

- Working directory: !`pwd`
- Language/framework: !`ls go.mod package.json pyproject.toml Cargo.toml pom.xml 2>/dev/null | head -3 || true`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Status: !`git status --short --branch 2>/dev/null || true`
- Recent commits: !`git log --oneline -8 2>/dev/null || true`
- Test coverage data: !`find . -maxdepth 3 \( -name "coverage.out" -o -name ".coverage" -o -name "lcov.info" \) 2>/dev/null | grep -vE "(node_modules|vendor)" | head -3 || true`
