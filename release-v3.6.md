# IMPERIONX OS v3.6 — Staging Validation & Recovery Readiness

## Objective

v3.6 turns deployment instructions into repeatable, non-destructive staging checks and backup validation. It does not claim a production deployment or a successful restore until those operations are performed against an operator-controlled staging environment.

## Changes

1. API version advanced to `3.6.0` across health/readiness, network responses, worker heartbeat, and frontend package metadata.
2. `scripts/staging_smoke.py` checks HTTPS `/health` and `/ready`, validates the exact API version, enforces short timeouts, and prints no secrets.
3. `scripts/verify_backup.sh` validates custom-format PostgreSQL backup readability with `pg_restore --list` and emits a SHA-256 checksum without touching a database.
4. A staged rollout and rollback runbook defines a controlled canary, observation window, abort conditions, and recovery steps.
5. Existing outbound webhook delivery remains disabled unless explicitly enabled after receiver and egress validation.

## Staging procedure

1. Provision an isolated staging environment and a disposable PostgreSQL database. Do not use production customer data.
2. Create `.env` from `.env.example`, set `APP_ENV=staging`, use an HTTPS `PUBLIC_BASE_URL`, and generate unique secrets. Keep `WEBHOOK_WORKER_ENABLED=false` initially.
3. Run `scripts/deploy_preflight.sh`, then `docker compose build` and `docker compose up -d` on a Docker-capable host.
4. Run `STAGING_BASE_URL=https://your-staging-host python scripts/staging_smoke.py`.
5. Run `scripts/test_postgres.sh` only against a disposable database; it upgrades the schema and runs tests plus concurrent claims.
6. Create a backup using `scripts/backup_postgres.sh`; validate its archive and checksum using `BACKUP_FILE=... scripts/verify_backup.sh`.
7. Restore that backup into a separate disposable database using the documented restore procedure, then rerun health/readiness and application smoke tests against the restored environment.
8. Start with one API replica and one worker. Increase API replicas first, then worker replicas after PostgreSQL concurrency checks pass. Observe queue age, delivery failures, dead-letter counts, database pool saturation and worker heartbeats.
9. Enable outbound webhook delivery only after a controlled receiver test confirms TLS, HMAC verification, idempotency handling, retry behavior and egress restrictions.

## Canary and rollback policy

- Start with internal test organizations only; do not route general customer traffic during the first observation window.
- Promote only after health/readiness remain stable, migrations complete, no cross-tenant access is observed, and error/queue-age metrics remain within the operator's documented thresholds.
- Abort promotion on repeated readiness failures, unexpected migration errors, rising dead-letter volume, database pool exhaustion, duplicate side effects at a receiver, or any tenant-isolation concern.
- Roll back application images to the last known-good release only after checking schema compatibility. Never blindly downgrade a database after new writes; prefer forward fixes or restore into an isolated environment and follow an approved recovery plan.
- Preserve audit logs and sanitized diagnostic records during incident response.

## Verification boundaries

Local automated checks can validate code, SQLite migrations, endpoint behavior under test fixtures, scripts, and Compose syntax when Docker Compose is available. They cannot prove the live staging host, TLS edge, real PostgreSQL behavior, restore success, production capacity, or regulatory compliance. Record each external gate with date, environment, operator, result, and evidence before production approval.
