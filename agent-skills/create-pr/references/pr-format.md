# PR Body Format

## Template

```markdown
## What

[The approach and key decisions. One to three sentences. Skip anything the diff makes obvious.]

## Why

[The problem or need this addresses. One to two sentences. State impact, not implementation.]

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

Describe the approach, not a tour of the files changed. The diff shows the files — the description should explain the thinking.

**Good:** "Validation is now applied at the service layer rather than the handler, so it runs regardless of which endpoint initiates checkout. The coupon model gains an `IsExpired()` method to keep the logic centralized."

**Bad:** "Modified checkout_handler.go and coupon.go. Added IsExpired method."

Note design decisions and trade-offs for non-obvious choices.

### Why

The most important section. A reviewer who understands the problem can evaluate the solution. One who doesn't cannot.

**Good:** "The checkout flow did not validate coupon expiry before applying the discount, allowing expired coupons to be used indefinitely."

**Bad:** "This PR adds coupon validation." (That's the solution, not the problem.)

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

Write to the size of the change. No filler — every sentence must carry information not already visible in the diff.

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
