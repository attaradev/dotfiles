# C.L.E.A.R. Scorecard

Adapted from the Growth.Design course "The Psychology of UI Design" (C.L.E.A.R. framework). Scores are a conversation starter, not a verdict: they show where a screen is strong and weak so the next iteration has a target.

## The five pillars in one line each

| Pillar | Question it answers | Guiding rule |
|---|---|---|
| **C**opywriting | Why should I care, right now? | Be conversational; a real person is on the other side of the screen. |
| **L**ayout | Can I understand the structure before I read? | Be ruthless about what goes on the screen and intentional about where. |
| **E**mphasis | What is the one thing I cannot miss? | One unmissable thing. Everything else is support. |
| **A**ccessibility | Does it still work when I am tired, rushed, or one-handed? | Make things bigger than you think they need to be. |
| **R**eward | Do I feel safe, competent, or seen at the moment that matters? | Secure, help, and recognise effort. Celebrate only when it is earned. |

## Scoring rubric (0–5 per pillar, total out of 25)

Use the same scale for every pillar:

| Score | Meaning |
|---|---|
| 0 | Pillar is absent or actively working against the user (e.g. emphasis points at a dangerous action). |
| 1 | Serious problems dominate; the user has to hunt, guess, or squint. |
| 2 | Works with effort; several clear mistakes from the pillar's mistake list. |
| 3 | Adequate; nothing broken, but nothing intentional either. |
| 4 | Good; one or two specific improvements would finish it. |
| 5 | Nothing to change; the pillar is doing its job invisibly. |

Per-pillar anchors for a 5:

- **Copywriting 5**: every line has a benefit, a clear verb, and feedforward; nothing could be cut; a competitor could not reuse the words.
- **Layout 5**: groups are obvious at a glance; one scan path; consistent spacing rhythm; no borders doing the work spacing should do.
- **Emphasis 5**: blur the screen and the primary message and action are still obvious; secondary items are visibly quieter.
- **Accessibility 5**: main action visible without scrolling, targets generous and separated, text readable, actions look like actions, meaning never carried by colour alone.
- **Reward 5**: the dominant emotion of the moment is answered concretely (status, proof, closure, escape hatch) at the right intensity.

## How to use the scores

- **Prioritise**: fix the lowest pillar first. A 1 → 3 is worth more than a 4 → 5.
- **Align**: when several people score the same screen, differences reveal disagreements worth discussing.
- **Iterate**: re-score after each change to see what moved.
- For every pillar ask: *what would make this a 5?* The answer is the fix.

## Worked examples (summarised from the course)

**SaaS security dashboard redesign — 21/25.** It tells the user the current state, what to do, and where to look; a health score gives a sense of control while nudging the next step. Points lost: labels, click targets, and body text still small in places (Accessibility); the wording around "challenges" is hard to grasp for anyone who did not set up the integration (Copywriting); the data filters are easy to miss, so someone could act on the wrong data (Layout/Emphasis).

**Used-car marketplace search results — 11/25.** Reads as a list built for endless scrolling rather than for choosing. Tiny photos in a marketplace (Emphasis → Size, Visualization); a loud red header that makes the page feel like an alert (Emphasis → Screaming Dial); controls scattered across the header, a floating bottom bar, and stacked top bars (Layout → Proximity, Continuity); large unused blocks of space; inside each listing the favourite icon competes with the title and the photo count covers the image (Emphasis → Placement). The redesign grouped the list actions at the top, enlarged photos into swipeable slideshows, surfaced the discount and "rare find" badge, and turned down the trade-in tag. Trade-off accepted: fewer listings per screen, each more legible and desirable, which is right when the goal is browsing rather than speed-scrolling. Swipe interactions need a discoverability hint.

## Closing check

Let the design rest before the final score if you can. Then ask: is the copy still impactful and can it be shorter? Is the emphasis in the right spot and can it be more obvious? Does the interaction make you feel good?
