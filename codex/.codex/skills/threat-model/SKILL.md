---
name: "threat-model"
description: "Produce a STRIDE threat model with assets, trust boundaries, threats, mitigations, and residual risk when the user asks about security risks or attack surfaces."
---

# Threat Model

Use this skill to reason about attackers, trust boundaries, and security controls before a change ships.

## Workflow

1. Read the system description and data flows before identifying threats.
2. List the assets that matter and the boundaries they cross.
3. Draw the key flows with trust boundaries marked.
4. Enumerate STRIDE threats for each component or flow and assign severity.
5. Record specific mitigations and any residual risk that remains.

## Quality rules

- Cover all STRIDE categories, including elevation of privilege.
- Make mitigations specific and verifiable.
- Treat high-severity threats as requiring a mitigation or explicit acceptance.
- State when a mitigation depends on a third party or unseen context.

## Resources

- `references/threat-model-framework.md` documents STRIDE categories, severity scoring, data-flow templates, and common web/API threats.
