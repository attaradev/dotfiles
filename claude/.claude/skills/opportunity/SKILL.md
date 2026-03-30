---
name: opportunity
description: This skill should be used when the user asks to "assess this opportunity", "evaluate this problem space", "is this worth building", "size this market", "opportunity assessment", or "should we invest in this". Produces a structured opportunity assessment covering problem size, target users, current alternatives, and investment rationale.
argument-hint: "[feature idea, problem area, or market opportunity to assess]"
---

# Opportunity Assessment

Topic: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing product docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(opportunity|problem statement|prd|strategy)" 2>/dev/null | head -8 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the topic carefully. Think like a senior PM who has seen hundreds of features ship and fail — your job is to interrogate the opportunity, not to validate it.

Produce a structured opportunity assessment following the template in `references/opportunity-framework.md`.

Be honest about unknowns. Quantify where possible; flag where you cannot. A good assessment makes the investment case OR argues against it.

Suggest saving the output to `docs/opportunity-<slug>.md`.

## Quality bar

- Do not restate the request — interrogate it
- Explicitly name what you do NOT know and what evidence would change the analysis
- Distinguish between market risk (is the problem real?), feasibility risk (can we build it?), and viability risk (can we capture value?)
- The recommendation must be actionable: proceed / do not proceed / run this experiment first

## Additional resources

- **`references/opportunity-framework.md`** — Document structure, key questions per section, and scoring guidance.
