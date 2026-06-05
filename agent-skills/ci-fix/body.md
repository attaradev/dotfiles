## Task

Read `references/ci-diagnosis-guide.md` before writing anything.

Then read the CI logs. Identify the failing step, the error message, and the root cause.

Follow the diagnostic approach in `references/ci-diagnosis-guide.md`:

1. **Identify the failure** — which job, which step, what error
2. **Classify the root cause** — flaky test, dependency issue, config error, code bug, environment drift
3. **Apply the fix** — edit the failing code, config, or workflow file
4. **Verify locally** — suggest the command to reproduce and confirm the fix before pushing

Do not propose a fix before reading the actual log output and the relevant source files.

## Output

Produce in order:
1. **Root cause** — one sentence: "Step `X` fails because `Y`" (job → step → exact error → cause)
2. **Classification** — one of the classes from the diagnosis guide
3. **Fix** — the edited file(s) with a diff-level explanation of what changed and why
4. **Verification** — the exact local command that confirms the fix (from the fix verification table)

If the failure is a flaky test (non-deterministic), do not suppress it — investigate and fix the underlying race condition or timing assumption. If a test is suspected flaky, note that it requires local run repetition to confirm non-determinism before assuming a race condition.

## Quality bar

- Root cause must be identified, not just the symptom
- Fix must address the cause, not suppress the error (no `|| true`, no skip flags, no `--no-verify`)
- If the fix requires a code change, read the relevant source files before editing
- If the CI environment differs from local (OS, Node version, env vars), identify the gap explicitly
- After applying the fix, state what command proves it works locally
- Flag if the fix requires secrets, external services, or a specific OS/architecture — document the assumption rather than silently baking it in

## Anti-patterns

- **Suppression fix** — adding `|| true`, `--no-verify`, `t.Skip(...)`, or `continue-on-error: true` to make the log green without fixing the cause
- **Symptom-only diagnosis** — "the test failed" without identifying why the assertion is wrong or what code change caused it
- **Untargeted lockfile regeneration** — running `npm install` or `go mod tidy` without explaining which dependency conflict caused the failure
- **Flaky test suppression** — adding retry flags or increasing `time.Sleep` instead of fixing the race condition or timing assumption
- **Assuming local parity** — proposing a fix without checking whether CI uses a different OS, runtime version, or env var than local

## Additional resources

- **`references/ci-diagnosis-guide.md`** — Failure classification, common CI failure patterns, log reading strategy, and environment parity checklist.
