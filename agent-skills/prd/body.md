## Task

Read the feature description carefully. Before writing, consider:
- Who is this for and what job does it help them do?
- What does success look like in six months?
- What is explicitly out of scope?

Produce a complete PRD following the template in `references/prd-template.md`. Calibrate depth to the scope of the feature — a small UX tweak needs less than a major new capability.

Do not invent requirements. Where information is missing, flag it as an open question.

Suggest saving the output to `docs/prd-<slug>.md`.

## Quality bar

- Every goal must have a metric and a target value — "improve onboarding" is not a goal; "increase day-7 activation rate from 40% to 60% by Q3" is
- Non-goals are as important as goals — they prevent scope creep
- User stories must cover the happy path, error states, and edge cases
- Every constraint must have a reason — "must support IE11 because 18% of our enterprise users are on it"
- Open questions must be assigned to an owner and have a resolution date

## Additional resources

- **`references/prd-template.md`** — Full PRD template with section guidance, examples, and scope calibration.
