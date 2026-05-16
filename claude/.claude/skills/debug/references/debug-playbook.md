# Debug Playbook

Systematic investigation steps. Work through these in order. Do not skip to a fix before root cause is confirmed.

---

## Step 1: Read the signal completely

Before forming any hypothesis, read the full error message, stack trace, or test failure output. Note:

- The exact error type and message (not a paraphrase)
- The top frame in the stack trace (immediate site of failure)
- The deepest frame in *your* code (root of the call chain you control)
- Any assertion values ("expected X, got Y")

Common mistake: fixing the symptom at the top frame while the root cause is several frames deeper.

---

## Step 2: Form a falsifiable hypothesis

State the suspected root cause as a specific, testable claim:

> "The nil pointer dereference at line 42 is caused by `GetUser` returning nil when the user ID does not exist in the cache, and the caller does not check for nil before accessing `.Email`."

A hypothesis that cannot be proven false is not a hypothesis — it is a guess.

---

## Step 3: Read the failing code

Find the exact line(s) implicated by the stack trace. Read:

- The function containing the failure
- Its callers (one or two levels up)
- Any recent changes to this area (`git log -p -- path/to/file`)

Look for:
- Assumptions the code makes that may not hold
- Off-by-one errors, nil/null dereferences, wrong types
- Race conditions or ordering dependencies
- Recent commits that changed this path

---

## Step 4: Reproduce minimally

Construct the smallest possible input or sequence of steps that reliably triggers the failure. If you cannot reproduce it:

- The bug may be environmental (timing, state, external dependency)
- The bug may be data-dependent (specific input shape or value)
- Reproduction is itself a finding — report what you tried

A reproducible case is the most valuable artifact from a debugging session.

---

## Step 5: Isolate by elimination

Narrow the problem space:

- Comment out code, add early returns, or add logging to confirm where execution diverges from expectation
- Binary search the call stack: does the bug manifest at point A? At point B? Narrowing to a specific function eliminates everything above and below
- Check invariants: what does the code assume that you can verify is true or false at runtime?

---

## Step 6: Confirm root cause

The root cause is confirmed when:

1. You can explain the failure mechanism precisely ("X happens because Y, which causes Z")
2. Removing or changing the root cause prevents the failure
3. The fix does not require patching symptoms at multiple call sites

If the fix requires changes at more than two unrelated places, the root cause analysis is likely incomplete.

---

## Step 7: Fix minimally

Apply the smallest correct change. Avoid:

- Refactoring surrounding code that is not causing the problem
- Adding defensive checks that paper over rather than fix the root cause
- Introducing new abstractions as part of a bug fix

The fix should be reviewable in isolation. If it is not, it is too large.

---

## Step 8: Verify

After fixing:

- Run the specific failing test or reproduce the specific failure
- Run the full test suite for the affected module
- Check whether any related code has the same flaw (the fix may imply a broader audit)

---

## Common failure patterns

### Nil / null dereference
Look at callers that assume a return value is non-nil. Check error handling — is the error being swallowed before the nil check?

### Off-by-one
Draw the index range on paper. Check `<` vs `<=`, `0` vs `1` as loop starts, slice bounds.

### Stale state / cache
Check whether the value was read before or after the mutating operation. Check TTLs, invalidation logic, and concurrent writers.

### Wrong goroutine / thread / async context
Verify that shared state is accessed with appropriate locks or channels. Check that async callbacks execute in the expected context.

### Environment-specific failure
Compare the failing environment against working ones: OS, runtime version, environment variables, file system state, network access. Use the diff to narrow.

### Flaky test
If the failure is intermittent: look for shared global state, time-dependent assertions, random ordering, or external dependencies. Flaky tests hide real bugs — do not mark as skip.

### Dependency version regression
Check `git log` for recent dependency bumps. Run with the previous version to confirm.

---

## When you are stuck

- Read the code path from scratch, top to bottom, as if seeing it for the first time
- Add logging or print statements at each function boundary to trace actual vs expected values
- Search the issue tracker for the error message — someone may have hit it before
- Rubber duck: explain the problem out loud (or in writing) before asking for help
- Check whether the tests actually test what they claim to test
