---
name: ci-fix
description: This skill should be used when the user asks to "CI is failing", "fix the pipeline", "these checks are red", "fix failing CI", "why is the build failing", "fix the GitHub Actions workflow", or "CI is broken". Fetches failing CI run logs, diagnoses the root cause, and applies a fix.
disable-model-invocation: true
argument-hint: "[optional: PR number, run ID, or workflow name]"
---

# CI Fix

Target: $ARGUMENTS

## Live context

- Current branch: !`git branch --show-current 2>/dev/null || true`
- CI platform: !`[ -d ".github/workflows" ] && echo "GitHub Actions ($(ls .github/workflows/ 2>/dev/null | tr '\n' ' '))" || [ -f ".gitlab-ci.yml" ] && echo "GitLab CI" || [ -f ".circleci/config.yml" ] && echo "CircleCI" || [ -f "Jenkinsfile" ] && echo "Jenkins" || echo "(not detected)"`
- Recent CI runs: !`gh run list --limit 5 2>/dev/null || true`
- Failed run details: !`gh run list --status failure --limit 3 --json databaseId,name,conclusion,headBranch,createdAt 2>/dev/null || true`
- Latest failed run log: !`gh run view $(gh run list --status failure --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null) --log-failed 2>/dev/null | head -100 || true`
- Recent local test run: !`cat .last-test-output 2>/dev/null | tail -50 || true`

## Task

Read the CI logs carefully. Identify the failing step, the error message, and the root cause.

Follow the diagnostic approach in `references/ci-diagnosis-guide.md`:

1. **Identify the failure** — which job, which step, what error
2. **Classify the root cause** — flaky test, dependency issue, config error, code bug, environment drift
3. **Apply the fix** — edit the failing code, config, or workflow file
4. **Verify locally** — suggest the command to reproduce and confirm the fix before pushing

Do not guess. Read the actual log output before proposing a fix.

If the failure is a flaky test (non-deterministic), do not suppress it — investigate and fix the underlying race condition or timing assumption.

## Quality bar

- Root cause must be identified, not just the symptom
- Fix must address the cause, not suppress the error (no `|| true`, no skip flags, no `--no-verify`)
- If the fix requires a code change, read the relevant source files before editing
- If the CI environment differs from local (OS, Node version, env vars), identify the gap explicitly
- After applying the fix, state what command proves it works locally

## Additional resources

- **`references/ci-diagnosis-guide.md`** — Failure classification, common CI failure patterns, log reading strategy, and environment parity checklist.
