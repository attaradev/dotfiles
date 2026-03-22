# Technical Blog Post Guide

## Post structure

```
Title
├── Introduction  (why this matters — problem, not solution)
├── Background    (optional — context readers need to follow along)
├── The approach  (what you built and why — the interesting decisions)
│   ├── Section: key decision 1
│   ├── Section: key decision 2
│   └── Section: key decision 3
├── Results       (quantified outcomes)
├── Lessons learned
└── Conclusion    (what's next / where to learn more)
```

Aim for 800–1500 words for most posts. Longer is fine if the topic requires it, but never pad.

---

## Title

Good titles are specific and outcome-focused:

| Weak | Strong |
|------|--------|
| "How we improved our API" | "Cutting API latency by 40% with connection pooling" |
| "Our new deployment system" | "Zero-downtime deploys for a stateful service: what we tried and what worked" |
| "Intro to feature flags" | "Feature flags at scale: how we ship to 1% without a flag service" |

Avoid: "A deep dive into X", "Everything you need to know about Y", "The ultimate guide to Z".

---

## Introduction anti-patterns

Do not open with:
- "Today we're going to talk about…" (announcement, not a hook)
- "Feature flags are an important concept in software engineering…" (textbook, not a story)
- "At [Company], we care deeply about reliability…" (corporate boilerplate)

Open with the problem:
```
Our checkout service was returning 5xx errors for 0.3% of requests — a number
that sounds small until you realise it meant 1,500 failed orders per day. This
is the story of how we found the root cause and reduced that error rate to 0.01%.
```

Or open with the stakes:
```
Rolling back a bad deploy used to take us 12 minutes. Twelve minutes of elevated
error rates, customer-facing failures, and on-call anxiety. We needed to fix that.
```

---

## Body: the interesting decisions

For each significant technical decision, answer:
1. What options did you consider?
2. Why did you choose this one?
3. What was the trade-off?

This is what makes a post worth reading — not the implementation details, but the reasoning behind the choices.

```
We considered three approaches:
1. A dedicated flag service (LaunchDarkly / Unleash) — fast to set up, but adds an
   external dependency that becomes a reliability risk.
2. Database-backed flags — simple but slow to evaluate at request time.
3. Config file in Git — zero dependencies, instant evaluation, but requires a deploy
   to change a flag.

We chose option 3 for now. Our flag lifecycle is short (weeks, not months), and
deploy time is under 2 minutes. We can revisit if the use case changes.
```

---

## Code snippets

Rules:
- Show only the relevant part — use `...` or comments to indicate omitted context
- Annotate non-obvious lines with inline comments
- Language-annotate every block (```go, ```sql, ```yaml)
- Maximum ~30 lines per snippet; split larger examples into multiple blocks with explanation between them

```go
// Before: one DB call per user in a loop (N+1 problem)
for _, order := range orders {
    user, _ := db.GetUser(order.UserID) // 1 query per order
    order.UserName = user.Name
}

// After: batch fetch, then look up from map
userIDs := extractUserIDs(orders)
users, _ := db.GetUsersByIDs(userIDs) // 1 query total
userMap := indexByID(users)
for _, order := range orders {
    order.UserName = userMap[order.UserID].Name
}
```

---

## Diagrams

Use diagrams to show:
- System architecture (before and after)
- Request flows
- Data flows through a pipeline

Keep diagrams simple. ASCII or Mermaid is fine for technical posts. Remove anything that doesn't directly support the explanation.

```
Before:                        After:

API → DB (per request)         API → Cache → DB (miss only)
      ↑ 200ms avg                     ↑ 2ms avg  ↑ 200ms (5% of requests)
```

---

## Results section

State numbers explicitly. Never use "significantly", "dramatically", or "much faster" without a number.

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| p99 API latency | 450ms | 38ms | 92% reduction |
| Error rate | 0.3% | 0.01% | 30× reduction |
| Deploy rollback time | 12 min | 90s | 8× faster |

If you don't have numbers, describe the qualitative outcome and be explicit that you don't have a measurement:
```
We don't have a before measurement for developer satisfaction, but in the two months
since launch, no one has asked to go back to the old system. That's probably signal.
```

---

## Lessons learned

Be honest. The most memorable posts are the ones that say "we were wrong about this":

- What was harder than you expected?
- What assumption turned out to be incorrect?
- What would you do differently if starting over?
- What surprised you (positively or negatively)?

```
What we got wrong: we assumed the bottleneck was CPU. Three hours of profiling
later, it turned out to be lock contention in the logger. Profile before
optimising — always.
```

---

## Tone guide

- Write like you're explaining to a capable peer engineer, not a student and not a conference audience
- Use "we" for team decisions, "I" for personal observations
- Contractions are fine ("we didn't", "it wasn't")
- Avoid passive voice: "the service was found to be slow" → "we found the service was slow"
- Avoid hedging: "this might possibly help in some cases" → cut it or commit to the claim

---

## Revision checklist

Before publishing:

- [ ] Does the intro lead with the problem, not the announcement?
- [ ] Is every performance claim backed by a specific number?
- [ ] Are all code snippets annotated and under 30 lines?
- [ ] Have you explained why you chose your approach, not just what you did?
- [ ] Is there a lessons-learned section with at least one honest admission?
- [ ] Have you removed all internal jargon (team names, internal tool names) that external readers won't understand?
- [ ] Is the conclusion brief and does it point to next steps or related reading?
- [ ] Title: specific and outcome-focused?
