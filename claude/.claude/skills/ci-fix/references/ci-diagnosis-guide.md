# CI Diagnosis Guide

## Step 1: Identify the failure precisely

Read the log from the bottom up — the terminal error is usually the most specific.

Find:
1. **Which job failed** — `build`, `test`, `lint`, `deploy`
2. **Which step failed** — `Run tests`, `Install dependencies`, `Build Docker image`
3. **The exact error message** — the last non-noise line before the red ✗

Do not read the entire log first. Jump to the failed step.

---

## Step 2: Classify the root cause

| Class | Signals | Common fix |
|-------|---------|-----------|
| **Test failure** | Assertion error, expected X got Y | Fix the code or the test |
| **Compilation / type error** | Syntax error, type mismatch, import not found | Fix the code |
| **Dependency failure** | Package not found, version conflict, registry timeout | Pin version, update lockfile, or fix registry config |
| **Environment drift** | Works locally, fails in CI; different OS, Node/Go/Python version | Pin runtime version in workflow; check env var differences |
| **Flaky test** | Fails intermittently, passes on re-run, involves timing or concurrency | Fix the race condition or timing assumption; do not retry-suppress |
| **Config / workflow error** | YAML parse error, wrong action version, missing secret | Fix the workflow file |
| **Auth / permissions** | 401, 403, missing secret, expired token | Rotate or add secret in repo settings |
| **Resource exhaustion** | OOM killed, disk full, timeout | Increase limits, optimise resource usage |
| **Upstream outage** | External service unavailable, DNS failure | Wait and re-run; add retry logic if recurring |

---

## Failure patterns by category

### Test failures

```
FAIL: TestPaymentProcessor/concurrent_charge (0.43s)
    payment_test.go:142: expected amount 5000, got 4999
```

- Read the test at the indicated line
- Read the implementation being tested
- Understand whether the test or the implementation is wrong

**Never** fix a test failure by relaxing the assertion without understanding why the value changed.

### Dependency / lockfile failures

```
npm error ERESOLVE unable to resolve dependency tree
```
```
go: golang.org/x/net@v0.21.0: reading golang.org/x/net/go.mod: ...
```

- Check if a dependency was added without updating the lockfile
- Check for version conflicts between direct and transitive dependencies
- Regenerate the lockfile locally and commit

### Environment drift

```
Error: node: /lib/x86_64-linux-gnu/libc.so.6: version GLIBC_2.28 not found
```
```
python3: command not found
```

- Compare the CI workflow's `runs-on`, language version, and OS with your local environment
- Pin the exact runtime version in the workflow: `node-version: '20.11.0'` not `'20'`
- Check for env vars present locally but not in CI secrets

### Flaky test signals

- Fails on one platform but not another
- Fails when tests run in parallel but not serially
- Fails with a timeout or "context deadline exceeded"
- Error message mentions time, goroutine, thread, or race
- Re-running passes without any code change

Fix: remove the timing assumption (fixed sleep → wait for condition), add proper synchronisation, or use deterministic test data.

**Do not:** add `t.Skip("flaky")`, increase sleep duration, or add `--retry-flaky-test` flags. These hide the bug.

### Workflow configuration errors

```
Error: .github/workflows/ci.yml (Line: 14, Col: 7): Unexpected value 'runs-on'
```
```
Error: Input required and not supplied: token
```

- Validate YAML syntax locally: `python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))"`
- Check action versions — pin to a specific SHA or tag, not `@main`
- Verify all `secrets.X` references exist in repo/org settings

---

## Environment parity checklist

When "works locally, fails in CI":

- [ ] OS: CI uses Linux (ubuntu-latest); local may be macOS or Windows
- [ ] Runtime version: is the same Node/Go/Python/Ruby version pinned in the workflow?
- [ ] Env vars: are all required env vars set as secrets or workflow env?
- [ ] File paths: are paths case-sensitive? (Linux is; macOS is not by default)
- [ ] File permissions: are executable bits set? (`git update-index --chmod=+x`)
- [ ] Build cache: is CI using a stale cache? Try clearing it
- [ ] Network access: does the test make real network calls that CI blocks?
- [ ] Time zone: CI is typically UTC; local may differ

---

## Reading GitHub Actions logs efficiently

```sh
# List recent runs for the current branch
gh run list --branch $(git branch --show-current) --limit 5

# View failed steps only (most useful)
gh run view <run-id> --log-failed

# Watch a running workflow
gh run watch <run-id>

# Re-run only failed jobs
gh run rerun <run-id> --failed

# Download full logs
gh run view <run-id> --log > ci.log
```

---

## Fix verification

Before pushing, state the command that proves the fix works locally:

| Failure type | Local verification command |
|-------------|--------------------------|
| Test failure | `go test ./... -run TestPaymentProcessor` |
| Lint failure | `npm run lint` / `golangci-lint run` |
| Build failure | `npm run build` / `go build ./...` |
| Type error | `npx tsc --noEmit` |
| Workflow syntax | `act --dryrun` (if `act` is installed) |

Do not push "should be fine" — verify.
