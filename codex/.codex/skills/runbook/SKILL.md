---
name: "runbook"
description: "Draft an operational runbook for a service or process. Use when the user asks for an ops guide, on-call procedure, troubleshooting playbook, or other operational documentation."
---

# Runbook

Use this skill to write practical operational documentation for engineers responding to incidents or routine service work.

## Workflow

1. Read the relevant service code, configuration, and existing operational docs before writing.
2. Match the established runbook location and style in the repository.
3. Document the system overview, dependencies, common operations, and troubleshooting steps.
4. Leave clear TODO markers for team-specific details that cannot be inferred from code.

## Quality rules

- Commands must be actionable and copy-pasteable.
- Troubleshooting should read like a decision tree, not a list of hints.
- Be explicit about blast radius and escalation paths.
- Do not invent operational facts that the repository does not support.

## Resources

- `references/runbook-template.md` provides the canonical runbook structure.
