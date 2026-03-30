# PR Body Format

## Template

```markdown
## What

[What was changed and the key decisions made. Explain *why* this approach over alternatives
if the choice is non-obvious. Two to five sentences for a typical PR; more for large changes.]

## Why

[Why this change is needed. What breaks, fails, is missing, or is suboptimal without it.
One to three sentences. Frame in terms of impact, not implementation.]

## Risks

[What could go wrong, break, or need monitoring. Known limitations, edge cases not handled,
deployment order, migration steps, or follow-up work. Omit only if genuinely risk-free.]

## Validation

- [ ] [Specific test run or manual step that confirms the fix/feature works]
- [ ] [Edge case verified]
- [ ] [Regression checked — existing tests pass]
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

| Change size | Title | What | Why | Risks | Validation |
|-------------|-------|------|-----|-------|------------|
| One-liner fix | Required | 1 sentence | 1 sentence | None or 1 item | 1–2 items |
| Small feature | Required | 3–5 sentences | 2–3 sentences | If any | 3–5 items |
| Large feature | Required | 2–3 paragraphs | 1 paragraph | Required | Full checklist |
| Breaking change | Required | Required | Required | Required | Required |

Do not write a five-paragraph description for a two-line fix. Do not write two sentences for a week of work.

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
