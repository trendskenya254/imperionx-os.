# IMPERIONX OS v3.6 — Verification Record

**Verification date:** 2026-11-13

## Completed in this environment

- Backend unit/API suite: **92 passed** (`PYTHONPATH=backend python -m pytest -q backend/tests`).
- Python compilation: passed for backend application, migrations, tests and staging smoke script.
- Fresh SQLite migration chain: passed through `0019_webhook_observability` (head).
- Frontend package and TypeScript configuration JSON: valid.
- Shell syntax checks: passed for all `scripts/*.sh`.
- Compose YAML: parsed successfully.
- Release verification script: completed successfully with the same 92 passing tests and migration head.
- ZIP integrity: passed (`unzip -t`).

## Not run / not certified

- Frontend production build: skipped; dependency installation/build was not run.
- PostgreSQL integration and multi-worker test: skipped; no disposable PostgreSQL service/URL was available.
- Docker image build and service startup: skipped; Docker is not installed in this environment.
- Staging HTTPS smoke checks: not run against a live staging host.
- Backup restore drill: not run against a disposable PostgreSQL target.
- Controlled external webhook receiver, TLS edge, egress restrictions and rollback rehearsal: not run.

## Release rule

Do not mark production-ready solely because unit tests pass. Attach dated evidence for PostgreSQL concurrency, staging health/readiness, backup restore, TLS/egress controls, and rollback rehearsal before enabling customer traffic.
