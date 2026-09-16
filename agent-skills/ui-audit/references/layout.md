# Layout pillar

Layout creates clarity without shouting. People perceive structure (grouping, alignment, regions) before they read, so layout decides whether the screen is understood at a glance.

## Six principles (from Gestalt psychology)

| Principle | Perception rule | Tactics |
|---|---|---|
| **Similarity** | Elements that look alike are read as related. | Same role → same look. Standardise text, icon, button, and spacing styles; reuse components; minimise variants. |
| **Proximity** | Elements close together are read as belonging together. | Tight spacing within a group, larger spacing between groups; keep labels, inputs, and their actions visually attached. |
| **Simplicity** | Lower visual complexity lowers cognitive load and speeds scanning. | Remove styling that carries no meaning; merge redundant controls; one clear primary action per region; prefer repeatable patterns. |
| **Alignment** | Aligned edges read as order; misalignment reads as friction. | Pick a grid and commit; align key edges (left edges do most of the work); reuse spacing values in a fixed step. |
| **Common region** | Elements inside the same bounded area are read as a group. | Group with sections or cards; prefer subtle background plus spacing over many borders; constrain overly wide layouts with a max width. |
| **Continuity** | Eyes follow the smoothest path; broken paths break reading order. | Design one obvious scan path (usually top-left to bottom); consistent edges and landmarks; avoid zig-zag layouts. |

## Three mistakes to look for

| Mistake | Problem | Solution |
|---|---|---|
| **Sloppy spacing** | Spacing is inconsistent or missing. | Start with "too much" padding, then reduce. |
| **Border bloat** | Borders doing the work spacing should do. | Define areas with subtle container colour and whitespace. |
| **Content cramming** | Too much information on one screen. | Remove elements (see Copywriting); use progressive disclosure. |

## Why it matters

Clutter is costly, not just ugly. Working memory is limited, and every visual mismatch forces re-interpretation. Layout turns pixels into predictable structure so that effort is not spent.

## Worked example (OTP screen)

Before: instructions on the left, the input floating elsewhere, the main action far away; everything present but scattered.
After: input and confirm button pulled into one cluster (Proximity); everything on one left edge (Alignment); input and button matched in height and style (Similarity); borders, duplicate logo, and a stray "Print" action removed (Simplicity); a single bounded task panel using the empty right-hand space (Common region); headline → instruction → form row → secondary options (Continuity).
