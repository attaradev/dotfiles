---
name: runbook
description: This skill should be used when the user asks to "write a runbook", "create a runbook for", "document how to operate", "write the ops guide for", "document the on-call procedure for", or "create operational documentation for". Produces a structured operational runbook for a service or process — capturing procedures, troubleshooting steps, and escalation paths so on-call engineers can act without needing the original author.
disable-model-invocation: true
argument-hint: "[service, process, or operation to document]"
---

# Runbook

Service / process: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing runbooks: !`find . -iname "*.md" \( -path "*/runbook*" -o -path "*/playbook*" -o -path "*/ops*" -o -path "*/oncall*" \) 2>/dev/null | grep -v node_modules | head -10 || true`
- Repository structure: !`find . -maxdepth 3 -not -path './.git/*' -not -path './node_modules/*' -type f | sort | head -80 2>/dev/null || true`
- Deployment / infra config: !`ls -1 docker-compose* Dockerfile* k8s/ helm/ terraform/ .github/workflows/ Makefile 2>/dev/null | head -10 || true`
- Key config files: !`ls -1 *.yaml *.yml *.toml *.env.example 2>/dev/null | head -10 || true`

## Task

Read the live context to understand the service before writing the runbook. Read relevant source files (entry points, config loading, health check handlers) to accurately describe what the service does and how it behaves under failure.

Match the format and location of any existing runbooks found in the live context. If none exist, use the template in `references/runbook-template.md` and save to `docs/runbooks/`.

Populate sections from code and config where possible. Leave explicit `[TODO: ...]` placeholders for operational details (alert thresholds, dashboard URLs, escalation contacts) that require input from the team — do not invent them.

## Quality bar

- Every troubleshooting step must be actionable without prior knowledge of the system
- Commands must be copy-pasteable — include actual flags, not placeholders where values are known
- Escalation paths must name roles or teams, not just say "escalate if needed"
- Runbooks go stale fast — flag assumptions that require periodic review

## Additional resources

- **`references/runbook-template.md`** — Full runbook template with section guidance.
