---
name: "feature-flag"
description: "Design or clean up feature flags, rollout logic, targeting rules, cleanup plans, and test coverage when the user asks about flags or gated rollouts."
---

# Feature Flag Design

Use this skill to design a safe flag, evaluate it once, roll it out in phases, and remove it cleanly after GA.

## Workflow

1. Define the flag type, name, default value, and targeting rule.
2. Place evaluation at the outermost entry point and pass the resolved value downward.
3. Plan rollout from off to internal to beta to gradual to GA.
4. Set the cleanup date before the flag ships.
5. Test both enabled and disabled states in every change that adds a flag.

## Quality rules

- Prefer stable user or org identifiers for targeting.
- Keep the disabled path real; do not duplicate the new code on both branches.
- Treat long-lived permission or ops flags differently from release flags.
- Remove the flag from code, config, dashboards, and tests after GA.

## Resources

- `references/feature-flag-guide.md` documents flag types, naming, rollout phases, cleanup, and test strategy.
