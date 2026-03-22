# User Story Format

## Story statement

**As a** [specific persona or role],
**I want to** [action or capability],
**So that** [the outcome or value I get].

Rules:
- "As a" — use a specific role, not "user": "admin", "first-time visitor", "billing manager"
- "I want to" — describe the capability, not the UI: "filter by date range" not "click the date picker"
- "So that" — describe the real goal: "make informed decisions" not "see the chart"

---

## Acceptance criteria (Given / When / Then)

Each criterion follows this form:

- **Given** [precondition or context]
- **When** [action or event]
- **Then** [expected outcome, verifiable and specific]

Always cover:
1. Happy path — the normal, successful case
2. Validation failure — invalid or missing input
3. Permission / auth edge case — what happens when the user lacks access
4. Empty state — what happens when there is no data
5. Error / system failure — what happens when a dependency fails

---

## Example

**Story: Export transaction history**
As a finance manager, I want to export my transaction history to CSV so that I can import it into our accounting software without manual data entry.

Acceptance criteria:
- Given I am on the transactions page with at least one transaction, when I click "Export CSV", then a CSV file downloads with all visible transactions within the current filter
- Given I have applied a date filter, when I export, then only transactions within that date range are included
- Given there are no transactions matching the current filter, when I click "Export CSV", then the button is disabled and a tooltip explains why
- Given the export contains more than 10,000 rows, when I initiate the export, then I receive an email with a download link within 5 minutes instead of an immediate download
- Given I do not have the "export" permission, when I visit the transactions page, then the export button is not shown
- Given the export service is unavailable, when I click "Export CSV", then an error message explains the issue and suggests trying again later

---

## Story sizing guide

| Size | Points | Description |
|------|--------|-------------|
| XS | 1 | Trivial change — config, copy, minor UI tweak |
| S | 2 | Well-understood, no unknowns, < 1 day |
| M | 3–5 | Some complexity, a few moving parts, 1–3 days |
| L | 8 | Complex, multiple systems, > 3 days — consider splitting |
| XL | 13+ | Too large to estimate reliably — must split before sprint |

---

## Story splitting patterns

When a story is too large, split it using these patterns (not by layer or component):

| Pattern | Example |
|---------|---------|
| Happy path first | Ship the working case; error handling in the next story |
| By data type | Support images first, then video |
| By user type | Admin capability first, then self-serve |
| By operation | Read first (list, view), then write (create, edit, delete) |
| By rule complexity | Simple rules first, complex rules in follow-up |
| Spike story | "Investigate X so we can estimate Y" — timebox and deliver findings |

Never split by layer: "frontend story" + "backend story" creates dependencies and delivers no standalone value.

---

## Anti-patterns

| Pattern | Problem |
|---------|---------|
| "As a user, I want a dashboard" | Too vague — what job does the dashboard do? |
| "So that the feature works" | Not a user goal — restates the story, not the outcome |
| Acceptance criteria that reference UI elements only | "The button is blue" is not an AC — it belongs in design |
| Missing error states | Engineers will not build them without explicit ACs |
| One AC per story | Real features have multiple scenarios — if you have one, you probably haven't thought it through |
| Story per screen | Screens are implementation details; stories are about user goals |
