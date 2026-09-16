# Accessibility pillar

Accessibility is not only compliance. A UI must still work when someone is tired, rushed, or one-handed, and for people with vision, hearing, mobility, speech, cognitive, and neurological differences. This pillar is design-level; a technical audit (focus states, keyboard support, alt text, predictable form errors) is still needed in production.

## Three realities to design for

- **Permanent**: long-term limitations.
- **Temporary**: short-term limitations (an injury, a new environment).
- **Situational**: "life is happening" (bright sunlight, a baby on one arm, end of a long day).

## Seven mistakes to look for

1. **Tiny and close targets**: small controls in crowded areas get missed or mis-tapped.
2. **Low contrast text**: nobody wants to squint.
3. **Actions that do not look clickable**: people will not guess correctly.
4. **Missing hints**: hidden key actions are never found.
5. **Colour-only meaning**: for some people it is all the same colour.
6. **Too many patterns in one view**: each new pattern adds cognitive load.
7. **"They'll figure it out" assumptions**: never assume prior knowledge.

## Three principles

| Principle | Question to ask |
|---|---|
| **Visible without searching** | Can you see the main action without digging, scrolling, or guessing? Is it above the fold? |
| **Operable without precision** | Can you hit it with a thumb, with reduced motion, or when fatigued? |
| **Actionable without guessing** | Do actions look like actions and explain themselves? |

A visible action that is self-explanatory and easy to activate is almost always the most accessible choice.

## Error prevention

Most accessibility failures are slips: people know what to do but the UI makes the wrong thing easy.
- Remove impossible choices; disable invalid states instead of letting people fail.
- Always offer undo.
- If undo is impossible, confirm destructive actions.

## Worked examples

**Smart-blind controls.** Each tile spent its area on a grey box and placeholder icon while the actual controls were tiny and awkwardly placed. Fix: make obvious which blind is selected, its current position, and how to move it, with generously sized controls.

**OTP screen.** A single blank text field can be mistaken for a password field. Fix: six separate boxes (communicates "6-digit code"), first box pre-focused with an obvious focus state, faint digit placeholders showing the format, numeric input mode so mobile shows a number keypad and desktop rejects non-digits, optional auto-submit on the sixth digit with the button kept as a visible affordance and fallback.
