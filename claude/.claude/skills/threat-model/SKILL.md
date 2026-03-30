---
name: threat-model
description: This skill should be used when the user asks to "threat model this", "STRIDE analysis", "what can go wrong security-wise", "attack surface analysis", "security threat model", "what are the security risks here", or "threat modelling for this feature". Produces a STRIDE threat model with assets, trust boundaries, threats, mitigations, and residual risk.
argument-hint: "[system, feature, or data flow to threat model]"
---

# Threat Model

System / feature: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Architecture docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(architecture|auth|security|api|endpoint)" 2>/dev/null | head -8 || true`
- Auth / security configuration: !`find . -maxdepth 4 -type f | xargs grep -l -iE "(jwt|oauth|cors|csp|rbac|permission|acl)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Data model: !`find . -maxdepth 5 -type f -name "*.sql" -o -name "schema.*" -o -name "*migration*" 2>/dev/null | head -8 || true`

## Task

Read the system description and any existing code carefully. Understand the data flows before identifying threats.

Produce a STRIDE threat model following `references/threat-model-framework.md`:

1. **Assets** — what data or capabilities are worth protecting?
2. **Trust boundaries** — where does data cross a trust boundary (network, process, user/service)?
3. **Data flow diagram** — the key flows with trust boundaries marked (text or Mermaid)
4. **STRIDE analysis** — for each component or data flow, enumerate threats across all six categories
5. **Mitigations** — the control that addresses each threat
6. **Residual risk** — threats that are accepted or partially mitigated, with rationale

Think like an attacker. For each threat, ask: how would I exploit this, and what would I gain?

## Quality bar

- Every HIGH severity threat must have a mitigation — accepting a HIGH risk requires explicit sign-off
- Mitigations must be specific: "use parameterised queries" not "sanitise input"
- Trust boundaries must be drawn at every network hop, process boundary, and privilege level change
- Do not skip the "Elevation of Privilege" category — it is the most commonly overlooked
- Flag any threat where the mitigation cannot be verified (e.g., depends on a third-party's security posture)

## Additional resources

- **`references/threat-model-framework.md`** — STRIDE categories, trust boundary identification, threat enumeration, severity scoring, and common web/API threat patterns.
