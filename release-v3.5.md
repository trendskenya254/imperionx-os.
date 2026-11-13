# IMPERIONX OS v3.5 — Production Deployment & Multi-Worker Reliability

## Scope

- Move Alembic migrations out of the API container startup path into a dedicated one-shot `migrate` service.
- Gate API and webhook-worker startup on successful migration completion and PostgreSQL health.
- Keep webhook delivery disabled by default, including in Compose. Enable explicitly with `WEBHOOK_WORKER_ENABLED=true` only after staging sign-off.
- Add bounded SQLAlchemy connection-pool configuration for PostgreSQL deployments.
- Add graceful SIGTERM/SIGINT handling so workers stop claiming new work and publish a stopped heartbeat.
- Preserve PostgreSQL `FOR UPDATE SKIP LOCKED` queue claiming for safe concurrent worker replicas.
- Add deployment preflight checks and rollout guidance.

## Delivery semantics

Webhook delivery is **at-least-once**, not exactly-once. A worker can send successfully and crash before committing the delivered state. In that case the event may be sent again after its processing lease expires. Receivers must deduplicate using the stable `Idempotency-Key` header. The platform does not promise exactly-once network delivery.

`SKIP LOCKED` prevents two healthy PostgreSQL workers from claiming the same queued row concurrently. It does not prevent a duplicate after a worker crashes during an in-flight request. The 120-second stale-processing recovery window is longer than the configured connect/read timeout budget.

## Deployment sequence

1. Create `.env` from `.env.example`; use unique staging secrets and a separate staging database.
2. Set `APP_ENV=staging`, `PUBLIC_BASE_URL=https://...`, PostgreSQL `DATABASE_URL`, and valid secret values.
3. Keep `WEBHOOK_WORKER_ENABLED=false` for initial staging.
4. Run `scripts/deploy_preflight.sh`.
5. Run `docker compose up -d db` and wait for PostgreSQL health.
6. Run `docker compose run --rm migrate` and confirm it exits successfully.
7. Run `docker compose up -d api frontend` and verify `/health` and `/ready` through the trusted TLS edge.
8. Only after receiver idempotency, DNS/IP egress controls, TLS, alerting and approval tests pass, set `WEBHOOK_WORKER_ENABLED=true` and start the worker.
9. Scale workers with `docker compose up -d --scale webhook-worker=2 webhook-worker`. Confirm distinct worker heartbeats and no duplicate concurrent claims in PostgreSQL tests.
10. Before production, take and verify a backup, rehearse rollback, and use a maintenance window for schema changes that are not backward compatible.

## Multi-worker operating limits

- PostgreSQL is required for multi-worker delivery. SQLite is for local development and unit tests only.
- Budget database connections: `((API replicas × Uvicorn workers per API replica) + worker replicas) × (DB_POOL_SIZE + DB_MAX_OVERFLOW) + migration/admin reserve` must remain below the PostgreSQL connection budget.
- Start with one worker, then two; increase only after measuring queue age, throughput, lock waits and DB pool saturation.
- Receiver systems must implement idempotency using the supplied stable delivery key.
- Keep worker outbound network egress restricted; the application still performs per-delivery DNS/IP checks and TLS verification.

## Verification boundaries

SQLite tests and migration checks do not prove PostgreSQL lock behavior or real multi-container startup. Run `scripts/test_postgres.sh` against a disposable PostgreSQL database. It includes an eight-process, 100-event concurrent claim test. Also perform a staging multi-worker end-to-end delivery test before enabling production delivery. Frontend production compilation, Docker image build/startup, reverse-proxy TLS, backup restore, and external receiver tests remain separate release gates unless explicitly recorded in `docs/verification-v3.5.md`.
