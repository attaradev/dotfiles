## Task

Read the feature description carefully. Design a complete feature flag implementation following `references/feature-flag-guide.md`.

Produce:
1. **Flag definition** — name, type, targeting rules, and default value
2. **Evaluation logic** — where and how the flag is evaluated in code
3. **Rollout strategy** — the phased plan from off → internal → beta → GA → cleanup
4. **Cleanup plan** — when and how the flag is removed after reaching GA
5. **Test strategy** — how to test both flag states

If the request is to clean up an existing flag: identify all call sites, produce the cleaned-up code with the flag removed, and list the files to change.

## Quality bar

- Every flag must have a defined lifetime — flags are technical debt from day one
- Targeting rules must be specific: user ID, org ID, percentage, or attribute — not "admins"
- The cleanup date must be set before the flag ships
- Flag evaluation must be in one place — scattered `if flag_enabled` calls across many layers is an anti-pattern
- Test both flag states: do not only test the "enabled" path
- Flags that cannot be removed without a code change are a liability — the cleanup plan must include a target date or trigger condition

## Additional resources

- **`references/feature-flag-guide.md`** — Flag types, naming conventions, evaluation patterns, rollout strategies, targeting rules, and cleanup checklist.
