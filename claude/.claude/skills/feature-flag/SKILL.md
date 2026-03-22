---
name: feature-flag
description: This skill should be used when the user asks to "add a feature flag", "design a flag for this", "flag lifecycle", "clean up this flag", "feature toggle", "implement a feature gate", "rollout strategy with flags", or "remove this flag". Designs feature flag implementation, evaluation logic, rollout strategy, and cleanup plan.
disable-model-invocation: true
argument-hint: "[the feature to flag, or the flag to clean up]"
---

# Feature Flag Design

Feature / flag: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing flags: !`grep -r -iE "(feature.?flag|feature.?toggle|is_enabled|flag\.|LaunchDarkly|unleash|flipt|posthog\.isFeatureEnabled)" . --include="*.go" --include="*.ts" --include="*.py" --include="*.rb" --include="*.js" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -15 || true`
- Flag config files: !`find . -maxdepth 4 -name "flags.*" -o -name "features.*" -o -name "toggles.*" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

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

## Additional resources

- **`references/feature-flag-guide.md`** — Flag types, naming conventions, evaluation patterns, rollout strategies, targeting rules, and cleanup checklist.
