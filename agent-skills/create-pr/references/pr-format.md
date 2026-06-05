# PR Body Format

## Template

```markdown
## What

[The value being delivered. One to three sentences. Describe outcomes and decisions — not a file tour.]

## Why

[The rationale. One to two sentences. Explain why this approach was chosen, not just what problem exists.]

## Risks

[What could break or needs attention. Write "None" if genuinely risk-free.]

## Validation

- [ ] [Specific test or manual step that confirms the happy path works]
- [ ] [Edge case verified]
- [ ] [Existing tests pass / no regressions]
```

---

## Title format

Follow the same Conventional Commits convention as commit messages:

```
<type>(<scope>): <imperative description under 72 chars>
```

Examples:
- `fix(auth): prevent session token reuse after logout`
- `feat(billing): add proration support for mid-cycle plan changes`
- `refactor(api): consolidate error response shape across endpoints`
- `chore(deps): upgrade postgres driver to v5`

---

## Section guidance

### What

Lead with value — what does the user or system gain from this change? The diff shows files; the description explains outcomes and the decisions that produced them.

**Good:** "Checkout now enforces coupon expiry at the service layer, closing a gap that let expired coupons apply indefinitely. Centralising the check in `IsExpired()` means all entry points (web, API, mobile) are covered without per-handler duplication."

**Bad:** "Modified checkout_handler.go and coupon.go. Added IsExpired method." (File tour with no stated value.)

Note design decisions and trade-offs for non-obvious choices; skip anything the diff already makes obvious.

### Why

Rationale answers *why this approach* — the constraint, business need, or decision driver that makes this the right solution. A reviewer who understands the rationale can judge whether the trade-offs are sound.

**Good:** "The service layer was chosen over handler-level checks because it enforces the rule for all callers (web, API, mobile) without requiring each to duplicate the logic independently."

**Bad:** "This PR adds coupon validation." (Restates the What; gives no rationale.)

Include a link to the issue, bug report, or incident if one exists.

### Risks

Surface anything that might concern a reviewer or require action before/after merge:
- Known limitations or deferred edge cases ("OAuth provider rate limiting not yet handled — tracked in #456")
- Deployment instructions ("Run migration before deploying: `make migrate`")
- Breaking changes that callers need to know about
- Areas of elevated risk ("The session invalidation logic in `auth/session.go` is the riskiest part")

If there are genuinely no risks, write "None" — don't omit the section, as its absence is ambiguous.

### Validation

Every item should be something a reviewer can verify or reproduce. Vague entries erode trust.

**Good:**
- [ ] `go test ./billing/...` passes
- [ ] Manually tested expired coupon at checkout — returns 422 with `coupon_expired` error
- [ ] Tested valid coupon still applies correctly

**Bad:**
- [ ] Tested
- [ ] Looks good

---

## Scope calibration

| Change size | What | Why | Risks | Validation |
|-------------|------|-----|-------|------------|
| One-liner fix | 1 sentence | 1 sentence | None or 1 item | 1–2 items |
| Small feature | 2–3 sentences | 1–2 sentences | If any | 2–3 items |
| Large feature | 1 short paragraph | 2–3 sentences | Required | Full checklist |
| Breaking change | Required | Required | Required | Required |

Write to the size of the change. Be concise, clear, and accurate — every sentence must carry information not already visible in the diff. Trim anything that restates the obvious or adds filler.

---

## Anti-patterns

| Pattern | Problem |
|---------|---------|
| "This PR fixes the bug" | Says nothing about what the bug was |
| "See commit history for details" | Lazy — commits exist for git blame, not PR context |
| "Tested locally" | Unverifiable and unconvincing |
| Listing every file changed | The diff shows files; describe decisions instead |
| AI attribution ("As an AI assistant...") | Never include |
| Present tense for problems ("The bug causes...") | Use past tense once fixed: "The bug caused..." |
| Padding with context the diff already shows | Reduces signal-to-noise; reviewers stop reading carefully |
| Vague qualifiers ("somewhat", "generally", "may") | Weakens trust; say what's true or omit it |
