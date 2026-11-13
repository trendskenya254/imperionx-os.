# v3.7 verification record

- Version: 3.7.0
- Backend automated tests: 95 passed (SQLite-backed API/unit suite).
- Python compilation: included in release verification script; run result recorded in release output.
- Fresh SQLite migration chain: included in release verification script; run result recorded in release output.
- Frontend production build: not run unless explicitly enabled with `VERIFY_FRONTEND=1` in an environment with dependency access.
- PostgreSQL integration/concurrency: not run unless `TEST_DATABASE_URL` points to a disposable PostgreSQL database.
- Docker build/startup: environment-dependent; Docker availability is checked by the release script.
- Live staging deployment, restore drill, secret rotation rehearsal and external security review: not performed by this local verification.

No government registry verification, regulatory KYC/AML certification, document vault, or public-key verifiable credential network is claimed.
