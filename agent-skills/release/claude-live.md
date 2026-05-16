## Live context

- Current branch: !`git branch --show-current 2>/dev/null || true`
- Latest tag: !`git describe --tags --abbrev=0 2>/dev/null || echo "(no tags yet)"`
- Commits since last tag: !`git log $(git describe --tags --abbrev=0 2>/dev/null)..HEAD --oneline 2>/dev/null || git log --oneline -20`
- Current version files: !`cat package.json 2>/dev/null | grep '"version"' | head -1 || cat go.mod 2>/dev/null | head -3 || cat pyproject.toml setup.py VERSION 2>/dev/null | head -5 || true`
- CHANGELOG exists: !`ls CHANGELOG.md CHANGELOG.rst HISTORY.md 2>/dev/null || echo "(none found)"`
- Unreleased CHANGELOG section: !`awk '/## \[Unreleased\]|## Unreleased/{found=1} found{print; if(/^## \[/ && !/Unreleased/) exit}' CHANGELOG.md 2>/dev/null | head -40 || true`
