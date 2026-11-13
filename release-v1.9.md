# IMPERIONX OS v1.9 — Reliability & Deployment Verification

## Purpose

v1.9 establishes a repeatable release-verification workflow and makes the distinction between local checks and infrastructure-dependent checks explicit. It does not claim production certification.

## Release changes

- API health and readiness responses identify version `1.9.0`.
- Added `scripts/verify_release.sh` to run Python compilation, backend tests, a fresh SQLite migration chain, frontend manifest validation, and optional frontend/PostgreSQL/Docker checks.
- Kept PostgreSQL integration testing opt-in through `TEST_DATABASE_URL`, which must point to a disposable PostgreSQL database.
- Kept frontend production build opt-in through `VERIFY_FRONTEND=1`; dependency installation requires npm registry access.
- Existing PostgreSQL backup and restore scripts remain available. A real restore drill requires a separate disposable PostgreSQL target and must never be run against production.

## Run locally

```bash
scripts/verify_release.sh
```

For PostgreSQL integration, provision a disposable PostgreSQL database and run:

```bash
TEST_DATABASE_URL='postgresql+psycopg://USER:PASSWORD@HOST:5432/imperionx_test' scripts/test_postgres.sh
```

For the frontend production build, in an environment with npm registry access:

```bash
VERIFY_FRONTEND=1 scripts/verify_release.sh
```

## Verification status in the current build environment

- Backend suite: verified against isolated SQLite fixtures.
- Python compilation: verified.
- Full Alembic chain: verified on a fresh SQLite database through `0009_universal_intelligence`.
- Frontend manifests: verified; dependency installation and production build remain unverified because npm installation timed out.
- Live PostgreSQL integration: not run; no PostgreSQL server/client or Docker runtime is available.
- Backup/restore drill: not run; requires a disposable live PostgreSQL target.
- Docker image build and multi-container startup: not run; Docker is unavailable.
- Browser end-to-end tests and independent security review: outstanding.

## Production gate

Do not treat this release as production-certified until PostgreSQL integration tests, frontend build, browser authentication/tenant-isolation tests, backup restoration, deployment smoke tests, monitoring/alerting, and independent security review have passed in a controlled staging environment.
