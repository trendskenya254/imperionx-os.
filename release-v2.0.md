# IMPERIONX OS v2.0 — Controlled Business Pilot Foundation

## Scope

v2.0 introduces a tenant-scoped pilot readiness endpoint for an industry-neutral business onboarding process. It reports completion of four setup steps: business profile, team access, first customer inquiry, and response workflow. It also reports pending human reviews and explicitly states that external actions remain disabled.

## API

`GET /v1/pilot/readiness`

Requires a valid bearer session and `X-Organization-ID` for an organization the user belongs to. The response contains a setup percentage, step-by-step status, pending human review count, and the fixed `external_actions_enabled: false` guard. It does not expose customer contact data.

## Safety boundaries

- Readiness is a setup checklist, not a security certification or production approval.
- No customer messages are sent and no external actions are enabled.
- All counts and organization details are scoped to the authenticated tenant.
- Industry and country are descriptive profile fields, not eligibility restrictions.

## Verification

Run `cd backend && pytest -q`. This release must still be tested against a real PostgreSQL service and through a deployed browser flow before a live pilot. Frontend production build and backup/restore drill remain environment-dependent release gates.
