# Staging Runbook — v3.6

## Before deployment

- Isolated staging account/project and disposable PostgreSQL database.
- Unique staging secrets; never copy production secrets into staging.
- HTTPS reverse proxy with certificate validation and restricted inbound access.
- Outbound egress allowlist; webhook delivery disabled at first.
- Known-good previous image tags and a documented rollback owner.

## Deploy

```bash
cp .env.example .env
# Edit .env securely: APP_ENV=staging, HTTPS PUBLIC_BASE_URL, strong unique keys.
scripts/deploy_preflight.sh
docker compose build
docker compose up -d
docker compose ps
STAGING_BASE_URL=https://staging.example.com python scripts/staging_smoke.py
```

## Backup and recovery drill

```bash
DATABASE_URL='postgresql+psycopg://...' scripts/backup_postgres.sh
BACKUP_FILE='./backups/imperionx-....dump' scripts/verify_backup.sh
```

Restore only into an isolated disposable database after confirming its target:

```bash
DATABASE_URL='postgresql+psycopg://.../imperionx_restore_drill' \
BACKUP_FILE='./backups/imperionx-....dump' CONFIRM_RESTORE=YES scripts/restore_postgres.sh
```

After restore, point an isolated application instance at the restored database and run the HTTPS smoke test. A successful `pg_restore --list` is archive validation, not a restore drill.

## Controlled canary

1. Start with test accounts and one worker.
2. Verify authentication, tenant boundaries, event creation, HMAC and idempotency at a controlled receiver.
3. Observe worker heartbeat, queue age, retries, dead letters, database pool metrics and API readiness.
4. Add worker replicas only after the disposable PostgreSQL multi-worker test passes.
5. Stop rollout immediately on data leakage, duplicate receiver-side effects, sustained readiness failures, unexplained queue growth, or database saturation.
6. Keep a record of release image tags, migration revision, operator, timestamps and evidence.

## Rollback

Stop promotion, disable webhook worker delivery, preserve logs and metrics, and restore the previous application image only if the current schema remains backward-compatible. Do not run destructive schema downgrades on a live database without an approved recovery plan. Prefer a forward fix where new writes have occurred.
