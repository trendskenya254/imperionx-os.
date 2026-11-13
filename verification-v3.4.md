# v3.4 Verification Record

Date: 2026-11-13

## Passed

- Backend test suite: **84 passed** (`PYTHONPATH=backend python -m pytest -q backend/tests`).
- Python compilation: passed (`python -m compileall -q backend/app backend/migrations backend/tests`).
- Fresh SQLite Alembic migration chain: passed through `0019_webhook_observability`.
- Migration downgrade from `0019` to `0018` and re-upgrade: passed (see release verification run).
- Frontend `package.json` and `tsconfig.json`: valid JSON.
- Frontend TSX syntax transpilation: passed for `frontend/app/page.tsx` and `frontend/app/layout.tsx` using the installed TypeScript compiler API.
- Docker Compose YAML validation: attempted only if Docker CLI is present; Docker is unavailable in this environment.
- Archive integrity: checked during packaging.

## Not run / not claimed

- Frontend production build: not run; npm dependencies were not installed.
- PostgreSQL multi-worker concurrency/integration: not run; no disposable PostgreSQL service was provided.
- Docker image build or container startup: not run; Docker is unavailable.
- Live external HTTPS webhook delivery: not exercised. Do not enable live delivery solely on the basis of unit tests.
- Production deployment, certification or security audit: not claimed.

## Release decision

The v3.4 package is suitable for continued staging validation. Production enablement remains gated on PostgreSQL concurrency, container deployment, frontend production build, controlled HTTPS receiver testing and operational egress review.
