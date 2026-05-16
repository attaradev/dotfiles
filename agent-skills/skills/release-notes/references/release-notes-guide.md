# Release Notes Guide

## Format template

```markdown
## [1.4.0] — 2026-03-22

### Highlights
This release focuses on export capabilities and performance improvements to the
reports dashboard. Search is now 3× faster for large datasets.

### What's new
- **CSV export**: Export any report as a CSV file from the report actions menu.
- **Scheduled reports**: Set up daily or weekly email delivery for any saved report.
- **API key scoping**: API keys can now be scoped to specific projects, reducing blast radius if a key is leaked.

### Improvements
- **Search**: Report search is now 3× faster for workspaces with 10,000+ records.
- **Dashboard load time**: Initial load reduced from 2.1s to 0.4s by lazy-loading chart data.
- **Error messages**: Validation errors in forms now point to the specific field that failed.

### Bug fixes
- Fixed: date filters in reports were off by one day in UTC+12 timezones.
- Fixed: clicking "Export" on an empty report no longer produces a corrupt file.
- Fixed: the sidebar collapsed unexpectedly when resizing to exactly 1280px width.

### Breaking changes
**`/api/v1/reports` response format changed**

The `created_by` field is now an object instead of a string:

```json
// Before
{ "created_by": "user_abc123" }

// After
{ "created_by": { "id": "user_abc123", "name": "Alice" } }
```

Migration: update your client code to access `created_by.id` instead of `created_by`.

### Deprecations
- `GET /api/v1/export` is deprecated in favour of `POST /api/v2/exports`. The v1 endpoint will be removed in v1.6.0 (approximately 2026-06-01).
```

---

## Categorization rules

| Include | Omit |
|---------|------|
| New user-facing features | Internal refactors |
| Performance improvements users will notice | Test-only changes |
| Bug fixes that affected real users | CI/CD pipeline changes |
| Breaking API or config changes | Dependency version bumps (unless they fix a security issue) |
| Deprecation notices | Code style / linting changes |
| Security fixes (without exploitable details) | Minor copy/label changes |

If a dependency bump fixes a CVE, include it:
```
- Updated `libssl` to 3.2.1 to address CVE-2026-XXXX (information disclosure).
```

---

## Writing in user voice

Every item should describe what the user can do, not what the developer changed.

| Developer voice (avoid) | User voice (use) |
|------------------------|-----------------|
| Added CSV export endpoint to `/api/reports` | Export any report as a CSV from the report actions menu |
| Fixed off-by-one error in date filter | Fixed: date filters were off by one day in UTC+12 timezones |
| Refactored chart loading to use lazy evaluation | Dashboard initial load is now 400ms, down from 2.1s |
| Deprecated v1 export API | `GET /api/v1/export` is deprecated — migrate to `POST /api/v2/exports` before v1.6.0 |

---

## Breaking change format

Breaking changes need three things:
1. **What changed** — the specific API, config key, or behaviour
2. **Before/after** — show the exact difference
3. **Migration step** — what the user must do

```markdown
### Breaking changes

**Config key renamed: `db_url` → `database_url`**

The `db_url` configuration key has been renamed to `database_url` for consistency with other connection settings.

Before (`.env`):
```
db_url=postgres://localhost/myapp
```

After:
```
database_url=postgres://localhost/myapp
```

Migration: rename the key in your `.env` and any deployment configuration before upgrading.
```

---

## Grouping by product area

For releases with many changes, group under subheadings instead of one flat list:

```markdown
### What's new

#### Reports
- CSV and PDF export from the report actions menu
- Scheduled email delivery (daily or weekly)

#### API
- API key scoping: restrict keys to specific projects
- New `POST /api/v2/exports` endpoint with async job support

#### Integrations
- Slack: post report summaries directly to a channel
- Webhooks: new `report.completed` event type
```

---

## Commit-to-note mapping

When generating from git history:

| Conventional commit prefix | Release notes section |
|--------------------------|----------------------|
| `feat:` | What's new |
| `fix:` | Bug fixes |
| `perf:` | Improvements |
| `refactor:` | Omit (unless user-visible) |
| `docs:` | Omit |
| `test:` | Omit |
| `chore:` | Omit (unless dependency security fix) |
| `BREAKING CHANGE:` footer | Breaking changes |
| `deprecate:` | Deprecations |

Read the PR description or commit body for context — the subject line alone is rarely enough to write a user-facing entry.

---

## Tone and style

- Present tense for new features: "You can now export reports as CSV"
- Past tense for fixes: "Fixed: date filters were off by one day"
- No passive voice: "Reports can be exported" → "Export reports from the actions menu"
- No filler: "We're excited to announce" → just describe the feature
- Quantify improvements: "3× faster", "reduced from 2.1s to 0.4s", not "significantly faster"
- Audience: the user operating the product, not the developer reading the code

---

## Example: good vs bad entries

**Bug fix — bad:**
```
- Fixed a bug in the date parsing logic that was causing incorrect results in certain edge cases
```

**Bug fix — good:**
```
- Fixed: date filters in reports showed the wrong results for users in UTC+12 and UTC+13 timezones
```

---

**Feature — bad:**
```
- Added support for the ability to export data in CSV format from the reports section of the application
```

**Feature — good:**
```
- **CSV export**: Download any report as a CSV from the report actions menu (three-dot icon → Export → CSV)
```

---

**Performance — bad:**
```
- Improved the performance of the search functionality
```

**Performance — good:**
```
- Search is now 3× faster for workspaces with more than 10,000 records (from ~800ms to ~250ms p99)
```
