# IMPERIONX OS v5.0 — Universal Deployment & First Business Launch

## Scope

- Adds a Render Blueprint for a Frankfurt deployment with private managed PostgreSQL, a Dockerized FastAPI service, and a Dockerized Next.js frontend.
- Runs Alembic migrations as the API's pre-deploy command and uses `/ready` as the traffic health check.
- Uses private service-to-service networking for the frontend API proxy and private database connectivity.
- Generates MFA encryption and rate-limit HMAC secrets at the hosting provider; SMTP and the temporary frontend HTTPS base URL are prompted as secrets/configuration.
- Adds GitHub Actions CI for backend tests, disposable PostgreSQL migration/concurrency verification, frontend production build, Docker builds, and Blueprint validation.
- Adds a migration-head wait utility for an optional separately deployed webhook worker.
- Keeps outbound webhook delivery disabled and excludes the worker from initial deployment until egress/security review.
- Keeps custom-domain setup optional and deferred until after the temporary HTTPS deployment is healthy.

## Source provenance

This release is based on the recoverable v4.9 Library archive. It does not claim to contain unrecovered v4.6/v4.7 changes. The v5.0 deployment profile is a clean provider-specific deployment layer over the actual v4.9 source. Review the included CI workflow and runbooks before treating earlier milestone summaries as evidence of current repository contents.

## Verification boundaries

Local checks validate Python source, SQLite migrations, the Render Blueprint structure, GitHub Actions YAML, frontend syntax/configuration, and archive integrity. They do not prove that Render resources have been provisioned, GitHub CI has passed, SMTP works, the service is publicly reachable, or production backup restoration/security controls have passed.

See `docs/deployment-render-v5.0.md` and `docs/verification-v5.0.md`.
