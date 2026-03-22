---
name: refactor
description: This skill should be used when the user asks to "refactor this", "clean this up", "extract this function", "rename this across the codebase", "consolidate this pattern", "dedup this", or "restructure this module". Scopes and executes a targeted refactor safely — read, find all call sites, plan, execute incrementally, verify correctness.
disable-model-invocation: true
argument-hint: "[what to refactor and the goal]"
---

# Refactor

Scope: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Status: !`git status --short --branch 2>/dev/null || true`
- Recent commits: !`git log --oneline -8 2>/dev/null || true`

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

Run the test suite for affected modules. If no tests exist, note this explicitly as a risk.

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

## Additional resources

- **`references/refactor-checklist.md`** — Pre-flight checks, common refactor failure modes, and safe execution patterns.
