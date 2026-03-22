---
name: retro
description: This skill should be used when the user asks to "run a retro", "retrospective for this sprint", "4Ls for this", "starfish retro", "team retrospective", "facilitate a retro", "what went well what went wrong", or "sprint review". Produces a retrospective facilitation guide with format selection, structured prompts, and action item capture.
disable-model-invocation: true
argument-hint: "[sprint, project, quarter, or incident to retrospect on; optionally specify format: 4Ls | starfish | start-stop-continue | sailboat]"
---

# Retrospective

Context: $ARGUMENTS

## Live context

- Current branch / recent work: !`git log --oneline --since="2 weeks ago" 2>/dev/null | head -20 || true`
- Recent commits summary: !`git log --format="%s" --since="2 weeks ago" 2>/dev/null | head -30 || true`
- Open issues or recent incidents: !`gh issue list --state open --limit 10 2>/dev/null || true`

## Task

Read the context. Select the most appropriate retrospective format from `references/retro-formats.md` based on the situation (or use the format specified in `$ARGUMENTS`).

Produce:
1. **Facilitation guide** — agenda, timing, and instructions for the facilitator
2. **Prompt cards** — the specific questions for each section of the chosen format
3. **Warm-up activity** — a one-minute exercise to get the team into a reflective mindset
4. **Action item template** — a structured format for capturing commitments at the end
5. **Retrospective on the retrospective** — two questions to close the session and improve the next one

If git context is available, seed each section with 2–3 concrete observations from the commit history or recent work — this helps the team remember what actually happened rather than recalling only the most recent events.

## Quality bar

- Every retrospective must end with specific, owned action items — not "we should improve X"
- Action items: one owner, one concrete action, one due date
- Prompts must be open-ended — not "was the sprint good?" but "what made progress feel easy or hard?"
- The facilitator guide must include a timeboxing schedule — retros without time limits run long
- Include a psychological safety note: the facilitator should state that the retro is blameless

## Additional resources

- **`references/retro-formats.md`** — Format descriptions, timing, when to use each, prompt libraries, and action item structure.
