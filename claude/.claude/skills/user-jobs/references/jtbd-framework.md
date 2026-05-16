# Jobs-to-be-Done Framework

## Core job statement syntax

A job statement follows this canonical form:

**[Action verb] + [object of the action] + [contextual clarifier]**

- "Help me track where my money goes each month so I can make confident decisions"
- "Get my team aligned on priorities before the sprint starts without running another meeting"
- "Prove to my manager that my infrastructure changes won't break production"

Rules:
- Start with a verb describing what the user is trying to accomplish — not what the product does
- The job is about progress, not features: "feel confident" not "see a dashboard"
- Include context ("each month", "before the sprint") to bound the job
- Avoid solution language ("use a tool", "click a button", "sync via API")

---

## Job dimensions

### Functional job
The practical task — what they are literally trying to do.
Example: "Track all my household expenses in one place."

### Social job
How they want to be seen by others as a result of doing the job.
Example: "Be seen as financially responsible by my partner."

### Emotional job
How they want to feel when the job is done.
Example: "Feel in control of my finances, not anxious about the end of the month."

> Social and emotional jobs often explain why users choose one solution over a technically superior alternative. They are the real switching costs.

---

## Job map (8 stages)

Every job follows a predictable execution arc. Map the job across these eight stages to find where friction lives:

| Stage | Description | Key question |
|-------|-------------|-------------|
| 1. Define | Figure out what needs to be done and what success looks like | What must the user understand or decide before starting? |
| 2. Locate | Find the inputs and resources needed to do the job | What information, tools, or people does the user need to gather? |
| 3. Prepare | Set up the environment and inputs | What must be configured, formatted, or arranged before the job can start? |
| 4. Confirm | Verify everything is in order before proceeding | What does the user check to ensure they are ready? |
| 5. Execute | Carry out the core task | What is the primary action the user takes? |
| 6. Monitor | Track progress and detect problems | What does the user watch for while the job is running? |
| 7. Modify | Adjust mid-course if something is not working | What does the user do when the expected result does not materialise? |
| 8. Conclude | Wrap up, verify the outcome, and clean up | How does the user know the job is done? What loose ends remain? |

---

## Outcome statements

Outcome statements describe what "done well" means from the user's perspective. They follow this format:

**[Direction] + [metric] + [object] + [context]**

- Minimise the time it takes to reconcile expenses at month-end
- Increase the likelihood that my budget reflects actual spending, not estimates
- Reduce the number of transactions I have to categorise manually each week
- Minimise the risk of missing a large expense that blows the budget

Outcome statements are the raw material for prioritisation. When you have fifty of them, you can survey users on importance and satisfaction to find underserved opportunities (high importance, low satisfaction).

---

## Competing solutions (the "hired" lens)

List everything a user might hire instead of your product to do the same job. Include:
- Direct competitors (other products in the same category)
- Indirect substitutes (spreadsheets, paper, workarounds)
- Non-consumption (living with the problem)

For each, note: what does the user gain by hiring it? What do they give up?

This reveals your real competitive set and what switching costs you must overcome.

---

## Worked example

**Topic:** A feature request for "export to CSV"

**Core job:** Share my data with someone who does not use this tool so I can collaborate without asking them to sign up for another account.

**Functional job:** Get data out of the product in a format my colleague can open.
**Social job:** Look organised and in control to my stakeholder.
**Emotional job:** Feel like I am not creating extra work for my team.

**Job map highlights:**
- Define: user decides what slice of data is relevant to share
- Locate: user finds the right view or filter
- Prepare: user formats or cleans data before exporting
- Confirm: user previews what will be exported
- Execute: clicks export
- Conclude: user verifies the file opens correctly in Excel / Google Sheets

**Key insight:** The job is about collaboration, not CSV. A shared link, a live embed, or a scheduled email delivery might serve the job better than a file download. Build for the job, not the feature request.
