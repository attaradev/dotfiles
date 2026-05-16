## Live context

- Working directory: !`pwd`
- Language/framework: !`ls go.mod package.json pyproject.toml Cargo.toml pom.xml build.gradle requirements.txt Gemfile 2>/dev/null | head -3 || true`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Status: !`git status --short 2>/dev/null || true`
- Recent changes (may have introduced the bug): !`git log --oneline -10 2>/dev/null || true`
- Recent diff: !`git diff HEAD~1..HEAD --stat 2>/dev/null || true`
