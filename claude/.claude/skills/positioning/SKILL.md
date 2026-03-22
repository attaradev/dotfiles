---
name: positioning
description: This skill should be used when the user asks to "define our positioning", "write our value proposition", "how should we message this", "positioning statement", "what makes us different", "website messaging", "how do we talk about our product", or "product positioning vs competitors". Produces a complete positioning framework covering differentiation, value proposition, and messaging hierarchy.
disable-model-invocation: true
argument-hint: "[your product, target customer, and key competitors or alternatives]"
---

# Product Positioning

Product / context: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing positioning or messaging docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(positioning|value.prop|messaging|tagline|headline|differenti)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the product and competitive context carefully. Develop a complete positioning framework following `references/positioning-guide.md`.

Produce:
1. **Positioning statement** — structured: For [ICP], [product] is the [category] that [key benefit] because [proof point]
2. **Differentiated value** — what you do that alternatives cannot or do not (must be true, specific, and defensible)
3. **Category** — the mental category you want to own; define or redefine if needed
4. **Message hierarchy** — headline → subheadline → three supporting value statements → CTA
5. **Proof points** — specific evidence for each claim (metrics, customer stories, capabilities)
6. **What to avoid saying** — claims that are generic, unverifiable, or shared with every competitor

## Quality bar

- Positioning must be true: do not claim differentiation you cannot defend in a sales call
- "Easy to use", "powerful", and "all-in-one" are not differentiators — they are defaults
- The category framing determines who you compete with; choose it deliberately
- Every claim in the message hierarchy must have a corresponding proof point
- Test the headline: would your three closest competitors say the exact same thing? If yes, it is not positioned.

## Additional resources

- **`references/positioning-guide.md`** — Positioning statement structure, category design, differentiation types, message hierarchy, proof point formats, and the "same as everyone else" trap.
