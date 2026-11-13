# IMPERIONX OS v2.2 — Pilot Activation & Outcome Metrics

## Scope

v2.2 adds a tenant-scoped pilot outcome endpoint and a dashboard panel to help a business evaluate early adoption using measurable operational signals.

## New API

`GET /v1/pilot/metrics?days=30`

- `days` is bounded to 7–90.
- Returns inquiry counts grouped by status, open inquiry count, sales counts and revenue grouped by currency, workflow-run counts, active team members inferred from audit activity, and pending human reviews.
- Returns aggregate counts only; it does not return customer names, contact details, inquiry messages, or other customer identifiers.
- Requires authenticated organization membership and scopes every query to the selected organization.
- Explicitly reports `external_actions_executed: false`.

## Dashboard

Adds a Pilot Outcomes panel with 30-day inquiry, open-work, sales, team activity and pending-review indicators. Revenue remains separated by currency; no cross-currency total is calculated.

## Data and safety

- No schema migration is required; existing inquiries, sales, workflow runs and audit events are aggregated.
- Metrics are operational signals, not causal evidence of time saved or business impact. Pilot interviews and baseline comparisons are still required to measure those outcomes.
- Customer messaging and external actions remain disabled; human approval remains required.

## Verification

- Backend API tests: 52 passed.
- Python compilation: passed.
- Fresh SQLite migration chain: passed through `0009_universal_intelligence`.
- Frontend manifests: valid.
- Frontend production build: not run; package installation/network access unavailable.
- PostgreSQL integration and Docker deployment: not run; no PostgreSQL service/client or Docker executable available in the verification environment.
