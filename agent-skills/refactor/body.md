## Task

Work through the checklist in `references/refactor-checklist.md` before writing any code. The most dangerous refactors are the ones where call sites were missed or behavior was silently changed.

### Phase 1 — Understand before touching

Read the target code completely. Understand:
- What it does and what invariants it maintains
- Who calls it (find all usages)
- What tests cover it
- What the intended end state looks like

Do not begin edits until this phase is complete.

### Phase 2 — Plan

State the plan explicitly:
- What changes, what does not
- Which files are affected
- What the behavior-preserving invariant is
- How to verify nothing broke

If the plan touches more than 5 files or changes a public interface, flag this as high-risk and confirm before proceeding.

### Phase 3 — Execute incrementally

Make changes in small, logical steps. After each step, the code should be in a valid (ideally runnable) state. Prefer multiple small commits over one large one.

### Phase 4 — Verify

Run the test suite for affected modules. If test coverage for affected code is <20%, escalate to HIGH risk and require manual verification of at least one call site before marking complete. If no tests exist, note this explicitly as a risk.

## Output format

Before making any changes, state:

1. **Scope confirmed** — what will change and what is out of scope
2. **Call sites found** — list of files and locations that use the target
3. **Risk level** — low / medium / high, with rationale
4. **Plan** — the sequence of changes

Then execute. After completing:

5. **Changes made** — summary of what was changed
6. **Verification** — test results or manual verification steps performed
7. **Residual risk** — anything not covered by the refactor or tests

## Quality bar

- All call sites must be found and updated before the refactor is complete
- Behavior must be preserved — no logic fixes, performance improvements, or new features in the same commit as structural changes; if a bug is found, note it and fix it in a separate commit
- Verification must include running the test suite for affected modules
- If test coverage is thin, flag it explicitly as residual risk rather than claiming correctness
- HIGH risk threshold: >5 files changed, OR a public interface modified, OR test coverage <20% for affected code, OR ≥10 call sites refactored — confirm with user before proceeding in any of these cases

## Anti-patterns

- **Missed call site** — declaring a refactor complete without searching every reference with `rg`/`grep -r`; in dynamic languages, also search string literals and dynamic dispatch patterns
- **Silent behavior change** — returning early from an error path that previously fell through, changing nil/null handling, or altering collection-empty behavior while "just renaming"
- **Refactor + fix in one commit** — mixing a behavior change into a structural refactor makes the diff unreviable and impossible to bisect; always separate them
- **Abstraction with one call site** — introducing a new interface, base class, or helper that has exactly one consumer after the refactor is a feature, not a refactor
- **Modifying tests to make the refactor pass** — if tests go red after a behavior-preserving refactor, the right fix is to restore the behavior, not update the test expectations

## Additional resources

- **`references/refactor-checklist.md`** — Pre-flight checks, common refactor failure modes, and safe execution patterns.
