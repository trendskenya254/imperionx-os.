# IMPERIONX OS v2.3 — Pilot Management & Customer Acquisition Foundation

## Scope delivered

- Tenant-scoped pilot enrollment record with cohort label, status, primary goal, baseline daily minutes, target daily minutes saved, and activation timestamp.
- Owner/admin-controlled participation updates with validation and audit events.
- Authenticated team-member feedback intake for feedback, bugs, support requests, and ideas, with severity levels.
- Owner/admin-only feedback listing, scoped to the current organization.
- No cross-tenant pilot data access and no outbound marketing or autonomous customer contact.

## API

- `GET /v1/pilot/enrollment` — get or initialize the current organization's pilot record.
- `PUT /v1/pilot/enrollment` — update pilot status and goals (owner/admin; privileged roles must satisfy existing MFA policy).
- `POST /v1/pilot/feedback` — submit an organization-scoped feedback or issue item.
- `GET /v1/pilot/feedback` — list the organization's items (owner/admin).

Statuses: `interested`, `onboarding`, `active`, `paused`, `completed`.
Feedback categories: `feedback`, `bug`, `support`, `idea`.
Severity: `low`, `normal`, `high`, `critical`.

## Data and safety

Migration `0010_pilot_management` adds `pilot_enrollments` and `pilot_feedback`. Feedback text is visible only within the submitting organization to owners/admins. Avoid placing passwords, payment credentials, or unnecessary customer personal data in feedback. No customer acquisition campaigns are sent by this release. Any future outreach must be opt-in, consent-aware, rate-limited, auditable, and human-approved.

## Verification boundaries

Backend tests, Python compilation, SQLite migration-chain verification and ZIP integrity are local checks. They do not certify PostgreSQL deployment, browser production build, SMTP delivery, backup restoration, or independent security review. These remain deployment gates.
