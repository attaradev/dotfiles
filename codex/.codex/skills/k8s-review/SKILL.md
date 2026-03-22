---
name: "k8s-review"
description: "Review Kubernetes manifests and Helm values for correctness, security, reliability, and operational readiness. Use when the user asks to review Kubernetes YAML, Helm, or pod specs."
---

# Kubernetes Manifest Review

Use this skill to review Kubernetes resources against operational and security best practices.

## Workflow

1. Read the manifest carefully and identify the resource type and scope.
2. Review it against the Kubernetes checklist.
3. Cover security, reliability, resource management, networking, observability, and operational readiness.
4. Provide a concrete fix for each finding.

## Quality rules

- Skip issues that are irrelevant to the resource type.
- Make severity reflect real operational risk.
- Flag hard-coded values that should be parameterised in templates.
- Always include a corrected YAML snippet.

## Resource map

- `references/k8s-checklist.md` -> review checklist for probes, limits, RBAC, network policy, and observability
