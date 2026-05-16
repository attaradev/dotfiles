## Live context

- Working directory: !`pwd`
- Recent commits that may have triggered the incident: !`git log --oneline --since='7 days ago' 2>/dev/null | head -20 || true`
- Recent deployments (tags): !`git tag --sort=-creatordate 2>/dev/null | head -10 || true`
