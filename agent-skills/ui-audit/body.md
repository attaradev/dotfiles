## Task

Audit the target screen or component with the C.L.E.A.R. framework and return a scored, evidence-backed iteration plan.

Accept any of these inputs:
- A screenshot or image file: open it and describe what you see before scoring.
- A URL: capture the rendered page (browser tooling if available, otherwise ask for a screenshot).
- Source files (HTML/JSX/Vue/Svelte/CSS): read them and reason about the rendered result, flagging where you are inferring rather than seeing.
- A written description: score what is described, and list what you could not assess.

Read `references/scorecard.md` first for the rubric. Then walk the five pillars in order, consulting the matching reference for each:

1. **Copywriting** (`references/copywriting.md`) — does every line answer "why should I care, right now?" and say what happens next?
2. **Layout** (`references/layout.md`) — does grouping, alignment, and spacing make the structure obvious before anyone reads?
3. **Emphasis** (`references/emphasis.md`) — is there exactly one unmissable thing, with everything else in support?
4. **Accessibility** (`references/accessibility.md`) — is the main action visible without searching, operable without precision, and actionable without guessing?
5. **Reward** (`references/reward.md`) — does the screen answer the user's silent question at the moment that matters (safe? improving? seen?)

The pass is not a straight line. When a fix in a later pillar adds or removes an element, re-check the earlier pillars so the screen still holds together. Consult `references/psychology.md` when you need to explain *why* a fix works.

## Output format

### Scorecard

| Pillar | Score (0–5) | Evidence on screen | What would make this a 5 |
|---|---|---|---|
| Copywriting | | | |
| Layout | | | |
| Emphasis | | | |
| Accessibility | | | |
| Reward | | | |

**Total: N/25.** One sentence on the overall impression: what the screen is trying to do and whether it lands.

### Prioritised fixes

Start with the lowest-scoring pillar. For each fix give: the pillar, the principle or dial it applies (for example "Emphasis → Space" or "Layout → Proximity"), the concrete change, and the expected effect. Group into "do first" (moves the lowest pillar by at least 1 point) and "then" (polish).

### Before → after suggestions

Where the fix is copy, show the current line and a rewritten line. Where it is layout or emphasis, describe the change precisely enough to implement (which element, which dial, which direction).

### Re-check

Note any earlier pillar the fixes may have affected and what to verify after implementing.

## Quality bar

- Every score cites something visible on the screen; no score without evidence
- Exactly one primary action or message per screen; if you cannot name it, Emphasis cannot score above 2
- Fixes name the dial or principle they apply, so the reasoning is reusable
- Copy suggestions pass the Copy Swap Test (a competitor could not paste them unchanged)
- Accessibility findings are design-level (targets, contrast, affordance, hints, color reliance, pattern count); say when a technical audit is also needed
- Reward findings name the dominant emotion the moment calls for (Control, Competence, or Recognition) before suggesting any celebration
- Prefer fewer, bolder changes; most hierarchy comes from what you turn down, not up
- Distinguish what you saw from what you inferred from source code

## Anti-patterns

- Taste-only critiques ("feels dated", "needs more polish") without a pillar, a principle, and evidence
- Screaming Dial: recommending bigger + brighter + animated for one element instead of quieting its neighbours
- Border Bloat: fixing grouping with more borders instead of spacing and subtle container colour
- Generic praise as a reward fix (confetti or "Great job!" with no concrete payoff)
- Color-only meaning, icon-only actions, or tiny targets left unflagged because the screen "looks clean"
- Scoring a description as if it were a rendered screen without saying so
- Recommending a full redesign when a one-dial adjustment moves the pillar

## Additional resources

- **`references/scorecard.md`** — 0–5 rubric per pillar, how to use scores, two worked examples.
- **`references/copywriting.md`** — Copy mistakes, tips, and the Copy Swap Test.
- **`references/layout.md`** — Six Gestalt-based layout principles and three layout mistakes.
- **`references/emphasis.md`** — Six emphasis dials, the Foggy Glasses Test, three emphasis mistakes.
- **`references/accessibility.md`** — Three realities, seven mistakes, three principles, error prevention.
- **`references/reward.md`** — Reward Trifecta, moment → need → design move tables, three reward mistakes.
- **`references/psychology.md`** — The effects behind the framework, with citations.
