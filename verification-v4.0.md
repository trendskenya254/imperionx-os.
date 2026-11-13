# v4.0 Verification Record

## Passed
- Full backend suite: **103 passed** (`PYTHONPATH=backend python -m pytest -q backend/tests`).
- Python compilation: passed.
- Fresh SQLite Alembic migration chain: passed through `0023_universal_trust_graph` (head).
- Migration downgrade from `0023` to `0022` and re-upgrade to `0023`: passed.
- Frontend `package.json` and `tsconfig.json` JSON validation: passed.
- Frontend package version aligned to `4.0.0`.
- Focused trust graph tests: direct accepted connections, opt-in second-degree discovery, opt-out, validation and authentication.

## Not run
- Frontend production build: dependencies were not provisioned; npm registry access was not used.
- PostgreSQL integration/multi-worker tests: no disposable PostgreSQL database was available.
- Docker build/startup: Docker is not installed in this environment.
- Live staging, external security review and backup restore drill: not run.

These are outstanding deployment gates. This release is locally verified, not production-deployed.
