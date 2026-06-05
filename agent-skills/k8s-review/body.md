## Task

Read `references/k8s-checklist.md` first, then read the manifest(s). Review the manifests against every applicable check in the checklist.

For each finding, state:
1. **Severity** — Critical / High / Medium / Low
2. **Resource** — kind/name
3. **Issue** — what is wrong and why it matters
4. **Fix** — the corrected YAML snippet

Cover all seven domains: security, reliability, resource management, networking, RBAC, observability, and operational readiness.

## Quality bar

- Do not flag issues that are irrelevant to the resource type (e.g., health probes on a ConfigMap)
- Severity must reflect real operational risk, not style preference
- Every finding must include a concrete fix, not just a description of the problem
- If the manifest is a template (Helm), flag values that should be parameterised but are hard-coded

## Anti-patterns

- **Flagging inapplicable checks** — do not report a missing `readinessProbe` on a Job or CronJob; do not report missing NetworkPolicy on a non-networked batch workload
- **Severity inflation** — do not mark every missing optional field Critical; match severity to the table in the checklist
- **Fix-free findings** — every finding must include a corrected YAML snippet, not just a description of what to add
- **Duplicate findings** — if the same misconfiguration appears in multiple containers of the same pod, report it once with a note that it applies to all containers
- **Style findings disguised as security findings** — label naming conventions and annotation formatting are Low at most; do not conflate them with privilege escalation or secret exposure

## Additional resources

- **`references/k8s-checklist.md`** — Checklist across security contexts, resource limits, probes, networking policies, RBAC, PodDisruptionBudgets, and observability.
