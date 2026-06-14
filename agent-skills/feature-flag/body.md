## Task

Read `references/feature-flag-guide.md` before writing anything. Then read the feature description and design a complete feature flag implementation following the guide.

Produce:
1. **Flag definition** — name, type, targeting rules, and default value
2. **Evaluation logic** — where and how the flag is evaluated in code
3. **Rollout strategy** — the phased plan from off → internal → beta → GA → cleanup
4. **Cleanup plan** — when and how the flag is removed after reaching GA
5. **Test strategy** — how to test both flag states

If the request is to **clean up** an existing flag:
1. Find all call sites: `grep -rn "<flagName>"` across the codebase
2. Verify no production traffic is still evaluated on the flag (check metrics or logs before removing)
3. Remove evaluation code first, then the flag definition, then the flag from the provider
4. Confirm: no dead code paths remain, all tests pass with the flag code gone

## Output format

Produce in this order:

**Flag definition**
```
Name: <flag-name>
Type: boolean | multivariate
Default: <value when flag is off>
Targeting: <rule — e.g. user.role == "beta" | percentage(user.id, 10%)>
Cleanup date: <date or trigger condition>
Owner: <team or person responsible>
```

**Evaluation code** — snippet using the project's existing flag client (match the pattern found in the codebase)

**Rollout plan** — phased steps (off → internal → beta → GA → cleanup) with criteria to advance each gate

**Cleanup plan** — linked ticket or concrete removal date, files to change when the flag is retired

**Test coverage** — confirm both enabled and disabled paths are tested; list the test cases for each

## Quality bar

- Every flag must have a defined lifetime — flags are technical debt from day one
- Targeting rules must be specific and use an explicit predicate — `user.role == "admin"` not just `"admins"`; percentage rollout must hash on a stable identifier (user ID, not session ID)
- The cleanup date must be set before the flag ships
- Flag evaluation must be in one place — scattered `if flag_enabled` calls across many layers is an anti-pattern
- Test both flag states: do not only test the "enabled" path
- Flags that cannot be removed without a code change are a liability — the cleanup plan must include a target date or trigger condition

## Anti-patterns

- **Flag soup** — too many flags in flight simultaneously. Set a team limit (e.g. ≤ 5 active flags per service); retiring a flag before adding a new one enforces this naturally.
- **No cleanup date** — shipping a flag without a linked ticket or removal date. The flag's end-of-life must be decided before it merges, not after GA.
- **Session-scoped targeting** — evaluating on session ID instead of user ID. Sessions are ephemeral; users get different variants mid-session and the experiment is invalid.
- **Testing only the enabled path** — the disabled/control path must be tested too. Untested control paths are silent regressions waiting to happen when the flag is cleaned up.
- **Flag-in-flag nesting** — flag A's evaluation code checks flag B. Untangle into independent flags with separate rollout plans; nested flags make rollback unpredictable.
- **Logging flag name but not variant** — traces must record both the flag name and the evaluated variant. Without the variant, logs are useless for debugging rollout incidents.

## Additional resources

- **`references/feature-flag-guide.md`** — Flag types, naming conventions, evaluation patterns, rollout strategies, targeting rules, lifetime targets, and cleanup checklist.
