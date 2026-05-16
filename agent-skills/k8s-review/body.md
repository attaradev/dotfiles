## Task

Read the manifest(s) carefully. Review against the checklist in `references/k8s-checklist.md`.

For each finding, state:
1. **Severity** — Critical / High / Medium / Low
2. **Resource** — kind/name
3. **Issue** — what is wrong and why it matters
4. **Fix** — the corrected YAML snippet

Cover all six domains: security, reliability, resource management, networking, observability, and operational readiness.

## Quality bar

- Do not flag issues that are irrelevant to the resource type (e.g., health probes on a ConfigMap)
- Severity must reflect real operational risk, not style preference
- Every finding must include a concrete fix, not just a description of the problem
- If the manifest is a template (Helm), flag values that should be parameterised but are hard-coded

## Additional resources

- **`references/k8s-checklist.md`** — Checklist across security contexts, resource limits, probes, networking policies, RBAC, PodDisruptionBudgets, and observability.
