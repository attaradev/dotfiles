## Task

Read the CI logs carefully. Identify the failing step, the error message, and the root cause.

Follow the diagnostic approach in `references/ci-diagnosis-guide.md`:

1. **Identify the failure** — which job, which step, what error
2. **Classify the root cause** — flaky test, dependency issue, config error, code bug, environment drift
3. **Apply the fix** — edit the failing code, config, or workflow file
4. **Verify locally** — suggest the command to reproduce and confirm the fix before pushing

Do not guess. Read the actual log output before proposing a fix.

If the failure is a flaky test (non-deterministic), do not suppress it — investigate and fix the underlying race condition or timing assumption. If a test is suspected flaky, note that it requires local run repetition to confirm non-determinism before assuming a race condition.

## Quality bar

- Root cause must be identified, not just the symptom
- Fix must address the cause, not suppress the error (no `|| true`, no skip flags, no `--no-verify`)
- If the fix requires a code change, read the relevant source files before editing
- If the CI environment differs from local (OS, Node version, env vars), identify the gap explicitly
- After applying the fix, state what command proves it works locally
- Flag if the fix requires secrets, external services, or a specific OS/architecture — document the assumption rather than silently baking it in

## Additional resources

- **`references/ci-diagnosis-guide.md`** — Failure classification, common CI failure patterns, log reading strategy, and environment parity checklist.
