## Live context

- Working directory: !`pwd`
- Existing launch or GTM docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(launch|gtm|go.to.market|rollout|release plan)" 2>/dev/null | head -8 || true`
- Recent releases (for launch cadence reference): !`git tag --sort=-creatordate 2>/dev/null | head -5 || true`
