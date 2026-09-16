# Reward pillar

A reward is the emotional outcome of a screen: what the user feels. The best reward is contextual and proportional: right feeling, right moment, right intensity. It is not decoration.

## The Reward Trifecta

A design adaptation of Self-Determination Theory: people are motivated by feeling in control and safe, competent and improving, and recognised and connected. A screen can land anywhere on the triangle, and the outcome can be a blend.

### Control: "I'm safe / certain / in charge"

| Sub-type | Definition | In UI terms |
|---|---|---|
| Safety | Reduced perceived threat or loss. | Protection, privacy, fraud-prevention, guarantee cues ("you're covered"). |
| Certainty | Predictability about current state and outcome. | Status, ETAs, confirmations, "what's happening now" and "what happens next". |
| Agency | Ability to influence or reverse. | Undo, cancel, edit, preferences, branching choices, "you can still change this". |

| Moment | Silent question | Design moves |
|---|---|---|
| Post-action (checkout, submit) | Did it work? What happens next? | Confirmation, receipt, next step, predictable timeline. |
| Waiting (shipping, processing, approvals) | What's happening now? When will it finish? | Status, ETA, milestones, proactive updates. |
| High stakes (money, privacy, irreversible) | Is this safe? Can I undo it? | Preview, warnings, safeguards, verification, undo or cancel window. |
| Recovery (errors, edge cases) | How do I fix this? Did I lose anything? | Explain what happened, preserve work, offer a clear fix and an escape hatch, route to support. |

Consistent Control moments become trust.

### Competence: "I'm improving / I can do this"

| Sub-type | Definition | In UI terms |
|---|---|---|
| Completion | Clear evidence a task is finished. | Done states, checkmarks, receipts, "you're all set". |
| Progress | Evidence of moving toward a goal. | Milestones, progress bars, streaks, step indicators, "X% complete". |
| Mastery | Signals of getting better. | Tips that improve performance, personal bests, quality scores. |

| Moment | Silent question | Design moves |
|---|---|---|
| Task completion | Did I finish? Did it go through? | Clear done state, confirmation copy, summary, next milestone. |
| Long or multi-step (onboarding, forms) | How far am I? What's left? | Steps, checkpoints, progress indicators, save and continue. |
| Performance feedback (analytics, habits) | Am I improving? Is this working? | Trends, deltas, benchmarks, personal bests, effort → outcome insights. |
| After friction (fixes, retries) | Did I handle it? | Acknowledge effort, show recovery ("back on track"), reinforce capability. |

### Recognition: "My work is recognised / I feel seen"

| Sub-type | Definition | In UI terms |
|---|---|---|
| Acknowledgment | Explicit feedback that the action counts socially. | Praise, badges, credentials, "verified", shareable proof. |
| Belonging | Cues of membership in a group or role. | Teams, roles, member status, cohort markers, "welcome back". |
| Reciprocity | Another person saw and responded. | Replies, reactions, approvals, "seen", "merged", "assigned". |

| Moment | Silent question | Design moves |
|---|---|---|
| After an outcome (publish, ship) | Did this matter? Does it count? | Praise plus proof: badge, certificate, credibility marker, share action. |
| Social surfaces (profiles, feeds) | Can people see this? | Public, verifiable signals; contextualised counts. |
| Group spaces (teams, communities) | Do I belong? What's my role? | Identity cues, rituals, cohort markers, shared language. |
| Collaboration loops (requests, reviews) | Did anyone respond? | Reactions, replies, approvals, "accepted", "merged". |

## The 30-second reward test

Users silently ask: "What's going on, am I safe?" (Control), "Am I improving, did I do well?" (Competence), "Do others see this?" (Recognition). If the UI answers none of them, it feels emotionally flat even when perfectly usable.

To add a reward: decide which payoff the screen should deliver, then check whether the UI actually delivers it. Confetti works only when it reinforces a real payoff; otherwise it feels random or manipulative.

## Three mistakes to look for

| Mistake | Problem | Fix |
|---|---|---|
| **Wrong reward** | A payoff the user does not care about in that moment ("Congrats!" when they are anxious). | Match the dominant emotion: anxiety → Control, effort → Competence, pride → Recognition. |
| **Shy reward** | The payoff exists (time saved, status changed) but is invisible or is generic praise with no evidence. | Surface it explicitly and concretely ("Saved 1 hour", "Delivered today", "Share credential"); use the Emphasis dials. |
| **Over-reward** | Intensity or frequency is off (full-screen confetti on every small action). | Keep it proportional; save big celebration for real milestones. |

## Worked example (OTP screen)

The moment calls for Control (Safety and Certainty) with a touch of Competence at the end. Changes: reframe "validate your identity" as a quick security check (Safety, Certainty); a small lock cue on the confirm button as feedforward (Safety); a visible countdown for the expiry (Certainty); a clear "verifying you securely" waiting state instead of a silent spinner (Certainty); a simple checkmark success state, no celebration (Competence); edit, retry, and resend kept nearby (Agency). The reward is mostly answering the user's questions at the right moment.

Related: the goal-gradient effect. People accelerate as they approach a goal, and even illusory progress (a head start on a progress indicator) increases completion. Use it honestly.
