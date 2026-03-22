---
name: "ci-fix"
description: "Diagnose failing CI runs, read the actual logs, identify the root cause, and fix the workflow, dependency, or code issue behind red checks."
---

# CI Fix

Use this skill to find the failing job and step in CI, classify the root cause, and apply the real fix.

## Workflow

1. Identify the CI platform from project files (.github/workflows → GitHub Actions, .gitlab-ci.yml → GitLab CI, .circleci/config.yml → CircleCI, Jenkinsfile → Jenkins).
2. Inspect the latest failed run and read the failure from the bottom up.
3. Identify the exact job, step, and error message that caused the failure.
4. Classify the issue as a test failure, config problem, dependency drift, environment mismatch, auth issue, resource limit, or upstream outage.
5. Fix the underlying cause in code or workflow configuration.
6. Verify the fix locally with the closest reproducible command.

## Quality rules

- Do not guess from the summary alone; read the logs.
- Do not suppress the failure with retries, skips, or `|| true`.
- If the CI environment differs from local, call out the gap explicitly.
- After the fix, name the command that proves it works.

## Resources

- `references/ci-diagnosis-guide.md` covers failure classification, log-reading strategy, environment parity, and verification commands.
