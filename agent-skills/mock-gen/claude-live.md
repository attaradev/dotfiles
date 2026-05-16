## Live context

- Working directory: !`pwd`
- Language/framework: !`ls *.go go.mod package.json requirements.txt Gemfile pyproject.toml 2>/dev/null | head -5 || true`
- Test framework: !`grep -r -iE "(testify|mockery|gomock|jest|vitest|pytest|rspec|mocha)" . --include="*.go" --include="*.json" --include="*.toml" --include="*.rb" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -5 || true`
- Existing mocks (capped): !`find . -maxdepth 5 -type f \( -name "*mock*" -o -name "*stub*" -o -name "*fake*" \) 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -5 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
