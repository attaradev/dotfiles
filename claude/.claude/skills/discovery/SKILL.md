---
name: discovery
description: This skill should be used when the user asks to "write discovery questions", "create an interview guide", "user research questions for this", "what should I ask users", "prepare for user interviews", "discovery interview script", or "research guide". Generates a structured user research interview guide with screener, core questions, and follow-up probes calibrated to the research goal.
argument-hint: "[the assumption or hypothesis you are trying to test, or the problem area to explore]"
---

# Discovery Interview Guide

Research goal: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing research or product docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(persona|user research|interview|discovery|hypothesis)" 2>/dev/null | head -8 || true`

## Task

Read the research goal carefully. Determine:
- Is this **exploratory** (we do not know the problem yet) or **evaluative** (we are testing a specific assumption)?
- Who is the right participant to talk to?
- What would change our thinking — what do we need to hear?

Produce a complete interview guide following the structure in `references/discovery-guide-template.md`.

Write questions in open-ended form. Never write yes/no questions. Never ask users what they want — ask about their behaviour and past experiences.

Suggest saving the output to `docs/discovery-guide-<slug>.md`.

## Quality bar

- Every question must surface evidence about real behaviour, not hypothetical preference
- "Would you use a feature that..." is banned — replace with "Tell me about the last time you..."
- The guide must have a clear through-line: every question connects back to the research goal
- Include at least three "5 whys" follow-up probes to go deeper than surface answers
- Flag any questions that are leading or that assume the problem exists

## Additional resources

- **`references/discovery-guide-template.md`** — Interview structure, question types, probing techniques, and anti-patterns.
