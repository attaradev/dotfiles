## Task

Read `references/security-checklist.md` first, then read the full target before forming any findings. If the target is a directory with more than 50 files, focus on the highest-risk categories (auth, crypto, injection points) and note the scope limit explicitly.

Work through every category in `references/security-checklist.md`. Weight depth by relevance — an auth change warrants full coverage of sections 2, 3, and 8; a CLI tool with no network exposure can skip section 7 entirely.

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

## Quality bar

- All findings must be traceable to specific code — no theoretical risks without evidence
- Every finding must name the file and line number
- Critical and High findings must include a concrete fix, not just a description of the problem — "parameterize the query at line 42" not "avoid SQL injection"
- Omit an entire severity section rather than writing "None found" — empty sections create noise
- Stay security-focused — do not conflate security findings with general code quality

## Anti-patterns

- **Generic advisories without code evidence** — "this endpoint could be vulnerable to CSRF" with no token check shown in the code. Every finding must cite a specific line.
- **Duplicate escalation** — listing the same issue at both Critical and High because it has two related components. Pick the highest applicable severity and mention the related component in the fix.
- **Code quality disguised as security** — flagging missing comments, poor naming, or test coverage in a security review. These are not security findings.
- **Fix descriptions that restate the problem** — "fix by not doing SQL injection" is not a fix. The fix must name the precise change: which line, which API or pattern to use instead.
- **Invented severity inflation** — raising a Low finding to Critical because the consequence sounds bad hypothetically. Severity must reflect actual exploitability given the code as written.

## Additional resources

- **`references/security-checklist.md`** — OWASP-aligned checklist of vulnerability categories with signals to look for.
