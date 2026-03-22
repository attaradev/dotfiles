---
name: prioritize
description: This skill should be used when the user asks to "prioritize these features", "RICE score this", "rank the backlog", "MoSCoW this", "help me decide what to build next", "prioritization framework", or "stack rank these". Applies a scoring framework (RICE, MoSCoW, or ICE) to a list of features or initiatives and surfaces the ranking with rationale.
disable-model-invocation: true
argument-hint: "[list of features or initiatives to prioritize, or a description of the backlog]"
---

# Feature Prioritization

Items to prioritize: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing roadmap or backlog docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(roadmap|backlog|priorit|rice|moscow)" 2>/dev/null | head -8 || true`

## Task

Read the items carefully. Before scoring, determine:
- What framework fits best? (See `references/prioritization-frameworks.md` for guidance on choosing)
- What is the strategic context — what goals or OKRs should the scoring reflect?
- What information is missing that would change the ranking?

Apply the selected framework. Show your work: scores alone without rationale are not actionable.

After scoring, produce:
1. Ranked list with scores
2. Rationale for the top 3 and bottom 2 items
3. Items that cannot be scored without more information (and what is needed)
4. Any sequencing constraints (dependencies, prerequisites) that override the score order
5. Your recommendation on what to do next

## Quality bar

- State the framework chosen and why it fits this context
- Flag assumptions made when data is missing — do not fabricate confidence values
- Surface at least one non-obvious insight from the ranking (something the team might not expect)
- If two items are clearly equivalent, say so rather than forcing an artificial rank
- A good prioritization output drives a decision — it should end with a clear recommendation

## Additional resources

- **`references/prioritization-frameworks.md`** — RICE, MoSCoW, ICE, and opportunity scoring with worked examples and framework selection guidance.
