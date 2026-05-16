## Task

Read the system description and any existing code carefully. Understand the data flows before identifying threats.

Produce a STRIDE threat model following `references/threat-model-framework.md`:

1. **Assets** — what data or capabilities are worth protecting?
2. **Trust boundaries** — where does data cross a trust boundary (network, process, user/service)?
3. **Data flow diagram** — the key flows with trust boundaries marked (text or Mermaid)
4. **STRIDE analysis** — for each component or data flow, enumerate threats across all six categories
5. **Mitigations** — the control that addresses each threat. For each mitigation, specify the control type: code, policy, infrastructure, or third-party dependency. Flag third-party controls explicitly — they are outside your direct control.
6. **Residual risk** — threats that are accepted or partially mitigated, with rationale

Think like an attacker. For each threat, ask: how would I exploit this, and what would I gain? Rate each threat:
- **HIGH** — exploitation grants unauthorized access to data or capabilities, or causes data loss
- **MEDIUM** — exploitation causes denial of service or limited information disclosure
- **LOW** — requires user interaction, physical access, or has limited blast radius

## Quality bar

- Every HIGH severity threat must have a mitigation — accepting a HIGH risk requires explicit sign-off
- Mitigations must be specific: "use parameterised queries" not "sanitise input"
- Trust boundaries must be drawn at every network hop, process boundary, and privilege level change
- Do not skip the "Elevation of Privilege" category — it is the most commonly overlooked
- Flag any threat where the mitigation cannot be verified (e.g., depends on a third-party's security posture)

## Additional resources

- **`references/threat-model-framework.md`** — STRIDE categories, trust boundary identification, threat enumeration, severity scoring, and common web/API threat patterns.
