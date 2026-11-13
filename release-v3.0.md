# Release v3.0 — Universal Business Network Core

## Purpose
Consolidate the existing business identity, discovery, relationship and commerce capabilities into one tenant-scoped network interface and summary API.

## API
`GET /v1/network/overview` requires the normal bearer session and `X-Organization-ID` membership context. It returns:
- current organization's basic identity, public profile publication state and verification status;
- accepted connection counts and pending incoming/outgoing requests;
- accepted counterparties as basic identity graph nodes and connection edges;
- referral, purchase request, transaction and open-dispute counts;
- explicit flags that IMPERIONX OS holds no funds and performs no currency conversion.

The endpoint does not return private account email, public contact email, customer records, transaction amounts, or unshared profile fields. The graph is built only from accepted connections and is scoped to the requesting organization.

## Data and migrations
No schema migration is required for v3.0. It consolidates existing v2.4-v2.9 records and APIs. Current Alembic head remains `0015_commerce_intelligence`.

## Verification
- Backend suite: 74 tests passed.
- Python compilation: passed.
- Fresh SQLite migration chain: passed through `0015_commerce_intelligence`.
- Frontend TSX transpilation: passed.
- Frontend package and TypeScript configuration JSON: validated.
- Docker Compose YAML: validated.
- Release archive integrity: verified.

## Not verified
Next.js production build, full TypeScript type-check, live PostgreSQL integration, Docker startup, browser end-to-end behavior, real email delivery, external payment integrations and independent security review.
