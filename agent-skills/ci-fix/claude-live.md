## Live context

- Current branch: !`git branch --show-current 2>/dev/null || true`
- CI platform: !`find . -maxdepth 3 \( -path "*/.github/workflows" -o -name ".gitlab-ci.yml" -o -name "Jenkinsfile" -o -path "*/.circleci/config.yml" \) -print 2>/dev/null | head -5 || echo "(no CI config detected)"`
- Workflow files: !`ls .github/workflows/ 2>/dev/null || true`
- Recent CI runs: !`gh run list --limit 5 2>/dev/null || true`
- Failed run details: !`gh run list --status failure --limit 3 --json databaseId,name,conclusion,headBranch,createdAt 2>/dev/null || true`
- Latest failed run log: !`gh run list --status failure --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null | xargs -I{} gh run view {} --log-failed 2>/dev/null | head -100 || true`
- Recent local test run: !`cat .last-test-output 2>/dev/null | tail -50 || true`
