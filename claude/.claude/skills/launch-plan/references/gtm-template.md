# Go-to-Market Brief Template

---

**GTM Brief: [Feature / Product Name]**
**Author:** [Name] | **Date:** YYYY-MM-DD | **Target launch date:** YYYY-MM-DD
**Owner:** [PM] | **Stakeholders:** [Eng, Design, Marketing, CS, Sales]

---

## What it is

One sentence. What does this do, for whom?

Example: "Bulk user provisioning via CSV upload for admins managing teams of 50+ users."

## Problem it solves

Two to three sentences. What was the user's pain before this feature? What did they have to do instead?

## Target audience

**Primary:** [Specific segment — role, plan, behaviour, or signal that identifies them]
**Size:** [Estimated number of users or accounts in this segment]

**Secondary:** [Users who will benefit but are not the primary launch target]

**Not targeted in this launch:** [Segments explicitly excluded, and why]

## Positioning

One sentence that a non-technical user would understand. Lead with the outcome, not the feature.

Format: "[Feature name] helps [audience] [accomplish outcome] without [pain they had before]."

Example: "Bulk provisioning helps IT admins onboard their entire team in minutes instead of adding users one by one."

## Launch sequencing

| Phase | Who | Duration | Entry criteria | Exit criteria |
|-------|-----|----------|---------------|--------------|
| Internal dogfood | [Team / N internal users] | [N days] | Feature is deployed behind flag | No P0/P1 bugs after [N days] |
| Private beta | [N accounts / specific segment] | [N weeks] | Dogfood passed | [N] beta users have used core flow; NPS > [threshold] |
| Limited rollout | [N% of target segment] | [N weeks] | Beta passed | Error rate < [X]%; support tickets < [Y]/day |
| GA | All target users | — | Limited rollout passed | — |

## Channels and messaging

| Channel | Audience | Message | Owner | Timing |
|---------|---------|---------|-------|--------|
| In-app tooltip / callout | All target users on first login | [Key benefit in 10 words] | PM/Design | GA day |
| Email | [Specific segment — e.g., admins with >50 seats] | [Subject line + body summary] | Marketing | GA day |
| Changelog / release notes | Customers who follow updates | Feature summary + link to docs | PM | GA day |
| Help centre article | Users who search for [workflow] | How-to with screenshots | CS | Before GA |
| Sales enablement | AEs with relevant accounts | Problem/solution one-pager | PM | Before limited rollout |

## Success criteria

Pre-commit these before launch. Do not adjust after seeing the data.

| Phase | Metric | Target | Measurement window |
|-------|--------|--------|-------------------|
| Beta | [Usage metric] | [N] users complete core flow | Within [N] days of beta invite |
| GA week 1 | [Adoption metric] | [X]% of target segment has tried it | 7 days post-GA |
| GA month 1 | [Retention / value metric] | [X]% of users who tried it use it again | 30 days post-GA |
| Guardrail | Support ticket volume | < [Y] tickets/day related to this feature | Ongoing |

## Launch risks and mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Feature flag needed for rollback | — | High | Ensure flag is in place before any rollout |
| Data migration required | [H/M/L] | [H/M/L] | Run migration in dry-run mode; validate counts before cutover |
| Customer comms required | [H/M/L] | [H/M/L] | Draft comms template; CS briefed before launch |
| Performance regression at scale | [H/M/L] | [H/M/L] | Load test with [N]x expected volume before GA |

## Rollback plan

[What happens if a P0 is discovered post-launch? Who makes the call to roll back? What is the communication plan?]

## Open questions

| Question | Owner | Due |
|---------|-------|-----|
| [Question] | [Name] | YYYY-MM-DD |
