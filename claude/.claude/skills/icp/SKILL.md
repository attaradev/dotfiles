---
name: icp
description: This skill should be used when the user asks to "define our ICP", "who is our ideal customer", "narrow our target market", "ICP definition", "ideal customer profile", "who should we sell to", "customer segmentation", or "who gets the most value from our product". Defines a tight Ideal Customer Profile with firmographic, behavioral, and situational attributes.
disable-model-invocation: true
argument-hint: "[your product, what it does, and what you know about your best customers so far]"
---

# Ideal Customer Profile

Product / context: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing customer or persona docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(persona|customer|segment|icp|buyer)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the product and customer description carefully. Define a tight ICP following `references/icp-guide.md`.

Produce:
1. **ICP statement** — one sentence: who they are, what they're trying to do, and why they buy from you
2. **Firmographic attributes** — company size, industry, stage, geography, tech stack (B2B) or demographics (B2C)
3. **Behavioral attributes** — what they do that signals they are a fit (actions, patterns, triggers)
4. **Situational triggers** — the event that makes them start looking for a solution now
5. **Anti-ICP** — who looks like a fit but is not (common mismatches that waste sales/support cycles)
6. **ICP scoring criteria** — a simple rubric to qualify or disqualify a prospect

## Quality bar

- Be specific enough to be useful: "B2B SaaS companies with 10–200 employees" is better than "small businesses"
- The situational trigger is the most important attribute — it explains why they buy now, not someday
- The anti-ICP is not optional — it prevents wasted cycles on bad-fit customers who churn early
- If you cannot name 3 real customers who fit the ICP, it is too abstract

## Additional resources

- **`references/icp-guide.md`** — ICP vs persona distinction, attribute taxonomy, trigger identification, scoring matrix, narrow-ICP-first strategy, and how ICP shapes pricing/positioning/channel.
