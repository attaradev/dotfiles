---
name: audit
description: This skill should be used when the user asks to "sec audit", "security audit this", "check this for vulnerabilities", "audit the auth code", "check for security issues", "threat model this", or "do a security pass on". Performs a focused security audit with security as the primary lens — not one of eight review categories, but the entire focus.
disable-model-invocation: true
argument-hint: "[file, PR number, or scope to audit]"
---

# Security Review

Target: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Changed files: !`git diff --name-status HEAD 2>/dev/null || true`
- Diff: !`git diff HEAD 2>/dev/null || true`
- Dependencies (for known-vuln check): !`cat go.sum package-lock.json requirements.txt Cargo.lock 2>/dev/null | head -50 || true`

If `$ARGUMENTS` is a PR number, run:
```
!`PR=$(echo "$ARGUMENTS" | grep -oE '[0-9]+' | tail -1); [ -n "$PR" ] && gh pr diff "$PR" 2>/dev/null || true`
```

## Task

Read the full target before forming any findings. Work through every category in `references/security-checklist.md`. Be thorough on categories relevant to what the code does — an auth change needs deeper scrutiny on authn/authz than a CLI tool does.

Only surface findings that are traceable to the code. Do not invent theoretical risks without evidence. Do cite uncertainty when the risk depends on context you cannot see.

## Output format

### Threat surface

One paragraph: what the code does, who the potential attackers are, and what assets are at risk. This frames the rest of the review.

### Critical findings

Exploitable vulnerabilities — injection, auth bypass, data exposure, broken crypto. Must be fixed before shipping.

**[LABEL]** — `path/file.ext` (line N)
> What the vulnerability is, how it could be exploited, and the concrete fix.

### High findings

Not immediately exploitable but creates real risk — missing rate limiting on sensitive endpoints, overly broad permissions, secrets in logs. Should be fixed before shipping.

### Medium findings

Defense-in-depth gaps — missing security headers, verbose error messages, weak input validation that isn't currently reachable. Fix soon.

### Low / informational

Best-practice deviations with low direct impact. Fix when convenient.

### Positive observations

Security controls that are correctly implemented and worth calling out. Balanced reviews build trust.

### Recommended next steps

Prioritized list of what to fix, in order. Include a one-line rationale for each.

## Additional resources

- **`references/security-checklist.md`** — OWASP-aligned checklist of vulnerability categories with signals to look for.
