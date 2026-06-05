## Task

Read `references/threat-model-framework.md` first. Then read the system description and any existing code. Map data flows before writing a single threat.

Produce a STRIDE threat model following `references/threat-model-framework.md`:

1. **Assets** — what data or capabilities are worth protecting?
2. **Trust boundaries** — where does data cross a trust boundary (network, process, user/service)?
3. **Data flow diagram** — the key flows with trust boundaries marked (text or Mermaid)
4. **STRIDE analysis** — for each component or data flow, enumerate threats across all six categories
5. **Mitigations** — the control that addresses each threat. For each mitigation, specify the control type: code, policy, infrastructure, or third-party dependency. Flag third-party controls explicitly — they are outside your direct control.
6. **Residual risk** — threats that are accepted or partially mitigated, with rationale

For each threat, write it as an exploit scenario: "An unauthenticated attacker sends a crafted request to X and gains Y." If you cannot state the exploit concretely, the threat is too vague — sharpen it or drop it. Rate each threat:
- **HIGH** — exploitation grants unauthorized access to data or capabilities, or causes data loss
- **MEDIUM** — exploitation causes denial of service or limited information disclosure
- **LOW** — requires user interaction, physical access, or has limited blast radius

## Quality bar

- Every HIGH severity threat must have a mitigation — accepting a HIGH risk requires explicit sign-off
- Mitigations must be specific: "use parameterised queries" not "sanitise input"
- Trust boundaries must be drawn at every network hop, process boundary, and privilege level change
- Do not skip the "Elevation of Privilege" category — it is the most commonly overlooked
- Flag any threat where the mitigation cannot be verified (e.g., depends on a third-party's security posture)

## Anti-patterns

- **Generic threats without exploit paths** — "attacker could gain access" is not a threat; "unauthenticated caller sends forged JWT with `alg: none` to bypass signature verification" is.
- **Mitigations that can't be verified** — "ensure proper validation" is not a mitigation; "validate against allowlist of 10 known currency codes; reject all others with 400" is.
- **Skipping Elevation of Privilege** — always enumerate EoP; it is the most commonly omitted STRIDE category.
- **Treating HTTPS as a full mitigation** — TLS in transit does not protect against IDOR, injection, or logic flaws; list residual threats explicitly.
- **Accepting HIGH severity without a named owner and review date** — a HIGH in the residual risk table with no owner is an unresolved finding, not a decision.

## Additional resources

- **`references/threat-model-framework.md`** — STRIDE categories, trust boundary identification, threat enumeration, severity scoring, and common web/API threat patterns.
