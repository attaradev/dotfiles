# Refactor Checklist

Work through these before writing a single line. Skipping pre-flight is how refactors introduce bugs.

---

## Pre-flight

- [ ] Read the target code completely — not skimmed, read
- [ ] Identify all callers using search (`rg`, `grep`, IDE) — do not rely on memory
- [ ] Check for callers in other repos, services, or packages if this is a shared interface
- [ ] Identify what tests cover the target — run them and confirm they pass before touching anything
- [ ] Confirm what behavior must be preserved (invariants, return values, error semantics)
- [ ] Identify what behavior is *allowed* to change (if any)

---

## Risk classification

**Low risk** — all of the following:
- Internal function, not part of a public API
- Covered by tests that verify behavior (not implementation)
- Changes fewer than 3 files
- No database, network, or file system interaction

**Medium risk** — any of the following:
- Public interface within a single service
- Touches error handling or error types
- Changes 3–10 files
- Covered by tests, but tests are thin

**High risk** — any of the following:
- Public API consumed by external callers or other services
- Serialization format or wire protocol change
- Changes to shared utilities used across many modules
- No meaningful test coverage
- Database schema or migration involved

For high-risk refactors: state the risk explicitly and confirm scope before proceeding.

---

## Common failure modes

### Missed call site
The most common refactor bug. Mitigation: use `rg` or `grep -r` to find every reference. For dynamically typed languages, search for string literals and dynamic dispatch patterns too.

### Silent behavior change
The code looks equivalent but handles an edge case differently — usually nil/null, empty collection, or error path. Mitigation: write a test that exercises the edge case before refactoring, verify it passes after.

### Refactoring and fixing at the same time
Mixing two concerns makes the diff hard to review and harder to bisect if something breaks. Keep behavior-preserving refactors separate from bug fixes. Commit them separately.

### Assuming tests prove correctness
Tests prove the code matches test expectations — not that the expectations are correct. After refactoring, re-read the tests to confirm they test behavior, not implementation details.

### Interface change without updating all callers
Especially in dynamically typed languages or across service boundaries. Mitigation: grep, build, run — in that order.

### Abstracting prematurely
A refactor that introduces a new abstraction "for future use" is a feature, not a refactor. If the abstraction has exactly one call site after the refactor, question whether it is warranted.

---

## Safe execution patterns

**Strangler fig** — for large rewrites: add the new implementation alongside the old, migrate callers one at a time, delete the old when all callers are migrated. Never a big-bang cutover.

**Parallel change** — add new parameter or return value while keeping old behavior, migrate callers, remove old behavior. Useful for interface changes.

**Extract, then simplify** — extract the code into its own unit first (behavior-preserving), then simplify it. Two commits, two reviews. Easier to reason about each step.

**Red-green-refactor** — for test-covered code: confirm tests pass (green), make the refactor, confirm tests still pass (still green). If tests go red, you changed behavior.

---

## Verification steps

After completing the refactor:

1. Run the specific test suite for the changed module
2. Run the full project test suite if feasible
3. Check that no existing tests were modified as part of the refactor (a test change that makes a refactor "pass" is a red flag)
4. Do a final diff review — read it as a reviewer would. Does every change make sense? Is anything unexpected?
5. If the refactor touches a public interface, verify that dependent packages or services still build
