---
name: k8s-review
description: This skill should be used when the user asks to "review this Kubernetes manifest", "check my k8s config", "is this Deployment safe", "review these Helm values", "audit this k8s yaml", "k8s best practices", "review my pod spec", or "harden this k8s resource". Reviews Kubernetes manifests for correctness, security, reliability, and operational readiness.
argument-hint: "[path to manifest(s) or paste the YAML to review]"
---

# Kubernetes Manifest Review

Manifest(s): $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Manifests found: !`find . -maxdepth 6 -name "*.yaml" -o -name "*.yml" | xargs grep -l -E "^kind:" 2>/dev/null | grep -vE "(node_modules|\.git|Chart\.yaml)" | head -10 || true`
- Helm charts: !`find . -maxdepth 4 -name "Chart.yaml" 2>/dev/null | head -5 || true`
- Kustomize: !`find . -maxdepth 4 -name "kustomization.yaml" 2>/dev/null | head -5 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

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
