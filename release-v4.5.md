# IMPERIONX OS v4.5 — Production Validation & Pilot Readiness

## Release objective
Strengthen deployment defaults and prepare a controlled, measurable pilot without representing local tests as production certification.

## Delivered
- Backend API and webhook-worker containers run as an unprivileged UID/GID 10001.
- Frontend runtime container runs as unprivileged UID/GID 1001 with owned runtime assets.
- API, worker and frontend Compose services drop Linux capabilities and enable `no-new-privileges`.
- Added Docker build-context exclusions for secrets, dependency directories, caches and tests.
- Added repository exclusions for environment secrets, database dumps, local databases and generated artifacts.
- Strengthened deployment preflight to require SMTP configuration, deliverable sender address, a non-placeholder MFA key, HTTPS, PostgreSQL, a sufficiently long rate-limit HMAC key, and restrictive `.env` file permissions.
- API, frontend and worker version aligned to 4.5.0.
- Added deployment-hardening regression tests and a pilot launch checklist/runbook.
- No application database schema change; migration head remains `0024_business_discovery_matching`.

## Pilot operating model
- Start with a small number of consenting businesses and one bounded workflow per business.
- Use staging first, separate credentials and database, and synthetic/test data where possible.
- Keep outbound webhook delivery and consequential AI actions disabled until each connector has a documented approval, receiver idempotency and egress review.
- Measure inquiry response time, time saved, workflow completion, human edit/approval/rejection rates, failures, repeat weekly use and cost per run.
- Provide a named operator, support channel, incident escalation path and documented rollback for the pilot.

## Verification boundary
Local tests and static configuration checks do not prove container images build, PostgreSQL concurrency works, TLS/proxy settings are correct, backups can be restored, email is delivered, or the platform is safe for production. Complete the pilot gate in `docs/pilot-launch-runbook-v4.5.md` on the target staging infrastructure before inviting businesses.
