# IMPERIONX OS v1.8 — Production Readiness Foundation

## Deployment boundary

This release improves deployment safety and observability. It is not a production certification. Run behind a TLS-terminating reverse proxy, restrict database access to the private network, and keep `.env`, SMTP credentials, database credentials, and `MFA_ENCRYPTION_KEY` out of source control.

## Environments

- Local/test: SQLite is supported for fast isolated tests.
- Staging/production: set `APP_ENV=production`, use PostgreSQL, set an HTTPS `PUBLIC_BASE_URL`, configure SMTP, and provide a stable Fernet `MFA_ENCRYPTION_KEY` from a secrets manager.
- Production startup fails closed if those required settings are missing. Do not rotate the MFA key without a planned re-encryption/migration procedure.
- Use separate databases, credentials, SMTP credentials, and encryption keys for staging and production.

## Health probes and logs

- `GET /health` is a liveness probe; it does not prove dependencies are ready.
- `GET /ready` executes `SELECT 1` against the configured database and returns 503 when the database is unavailable.
- HTTP request logs are JSON and include request ID, method, path, status, and duration. Authorization headers, cookies, request bodies, query strings, and email addresses are deliberately excluded.
- Forward `X-Request-ID` from a trusted edge only; configure the proxy to overwrite client-supplied values. Export logs to a protected centralized log service with access controls and retention.

## Database migrations

Run from `backend/`:

```bash
DATABASE_URL="$DATABASE_URL" PYTHONPATH=. alembic upgrade head
PYTHONPATH=. alembic current
```

Take a verified backup before applying migrations. Test migrations against a copy of staging data before production. Do not use `Base.metadata.create_all()` as a production migration strategy.

## Backup and restore

Install PostgreSQL client tools matching the server major version. Set `DATABASE_URL` to the target PostgreSQL URL, then run:

```bash
./scripts/backup_postgres.sh
sha256sum backups/*.dump
```

Copy backups to encrypted off-host storage with restricted access and retention. A local dump alone is not disaster recovery. Periodically restore into an isolated database:

```bash
DATABASE_URL="$RESTORE_DATABASE_URL" BACKUP_FILE="backups/imperionx-YYYYMMDDTHHMMSSZ.dump" CONFIRM_RESTORE=YES ./scripts/restore_postgres.sh
```

The restore script is destructive to conflicting objects in the target database. Verify the target carefully and never point it at production during a drill. After restore, run migrations if required and perform health, login, tenant-isolation, and inquiry workflow smoke tests. Record recovery time and data-loss window.

## Pre-launch checklist

- [ ] Real PostgreSQL staging deployment and full integration/concurrency suite pass.
- [ ] TLS, trusted proxy, firewall, secrets manager, and least-privilege DB credentials configured.
- [ ] SMTP delivery, retries, bounce handling, and abuse throttles tested.
- [ ] MFA key backed up securely and recovery procedure tested.
- [ ] Encrypted off-host backups and scheduled restore drills proven.
- [ ] Centralized logs, alerts, access controls, and retention configured.
- [ ] Rate limits applied at edge and application layers.
- [ ] Independent security review and incident response runbook completed.
- [ ] Frontend contract and end-to-end customer inquiry journey tested.
- [ ] Validate BFF login, MFA, cookie flags, refresh rotation/reuse revocation, logout, CSRF rejection, organization preservation, and session restore in a real browser.
- [ ] Review CSP against the built Next.js application; use a nonce-based script policy if required by the final deployment.
- [ ] Run dependency, container-image, SAST, DAST, and independent penetration/security testing.

## API contract

FastAPI's OpenAPI document is available at `/openapi.json` and interactive docs at `/docs` when enabled. Export and review the OpenAPI document per release; treat breaking schema changes as versioned API changes. Do not expose interactive docs publicly in production without an explicit access policy.


## Browser session boundary (v1.8)

The dashboard must call only the same-origin `/api/*` BFF. Owners and administrators must complete authenticator enrollment and store recovery codes before privileged operations are enabled. The browser must never persist access/refresh tokens, read them from JavaScript, or construct Authorization headers. The BFF stores tokens in HttpOnly, SameSite=Strict cookies, adds bearer authorization only on server-to-server requests, and rotates refresh tokens after an expired access token. The selected organization is kept separately from refresh responses so token rotation cannot silently change tenant context. Mutating requests are rejected unless their Origin exactly matches the BFF origin; cross-site Fetch Metadata is rejected as a second signal.

Before production, verify these controls in a browser and through a reverse proxy. Confirm Secure cookies are emitted only over HTTPS, cookies are host-only and scoped to `/api`, login/MFA responses never contain token values, logout revokes the server session family, refresh-token reuse invalidates the family, and CSRF attempts fail. CSP currently allows inline scripts for Next.js compatibility; review the production build and prefer nonce-based script authorization if feasible.


## Webhook operations (v3.4)

- Monitor `GET /v1/integrations/webhooks/metrics` per organization for queued, processing, retry, delivered and dead-lettered counts.
- Investigate dead-lettered events using the tenant-scoped `/deliveries/{id}/attempts` history; do not copy payloads or signing secrets into tickets or logs.
- Treat worker presence as stale after 90 seconds. A stale heartbeat should trigger process/container inspection, database connectivity checks and queue-age review.
- Replay only after correcting the underlying receiver or endpoint issue; replay is owner/admin-only and preserves the delivery idempotency key.
- Keep outbound delivery disabled until PostgreSQL multi-worker claims, DNS/IP egress policy, TLS, receiver idempotency and controlled staging delivery are proven.
