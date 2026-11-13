# IMPERIONX OS — Universal Business Operating System

IMPERIONX OS is a tenant-aware business operating system foundation and the first step toward the Universal Business Network.

## Current release: v5.0

- API, frontend and worker version `4.9.0`.
- Explainable commercial decision intelligence for overdue opportunities, quote decisions and stale active deals.
- Tenant-scoped action evidence, aging, supplier quote response-time measurement and recommended next steps.
- Human-controlled decisions; no automated messages, record changes, payments or escrow.
- HTTPS staging liveness/readiness smoke test (`scripts/staging_smoke.py`).
- Non-destructive PostgreSQL backup archive verification and SHA-256 checksum (`scripts/verify_backup.sh`).
- Staging, canary, rollback and recovery-drill runbooks.
- Explicit verification boundaries: local tests do not certify live PostgreSQL, Docker, TLS, restore, production capacity or compliance.

## Quick start

1. Copy `.env.example` to `.env` and replace all placeholders with unique secrets.
2. Follow `docs/staging-runbook-v3.6.md` on an isolated Docker-capable staging host.
3. Keep outbound webhook delivery disabled until the controlled receiver and egress checks pass.
4. Run `scripts/verify_release.sh` for local checks.

## Key documents

- `docs/release-v3.6.md` — milestone scope and release gates.
- `docs/staging-runbook-v3.6.md` — deployment, backup, restore and canary procedure.
- `docs/verification-v3.6.md` — what is and is not verified.
- `docs/production-readiness.md` — broader security and operational checklist.

## Important

This archive is an engineering release, not a claim of production deployment. PostgreSQL concurrency, Docker startup, frontend production compilation, staging HTTPS, backup restoration, receiver-side idempotency, and controlled rollback must be tested in the target environment before production use.


## v3.8 Transaction Reputation
Transaction-linked bilateral feedback is available after buyer-confirmed completion. Reputation summaries are limited to accepted network connections, show separate rating dimensions and completed transaction counts, and do not expose reviewer comments or identities. No composite trust score is produced. See `docs/release-v3.8.md`.


## Latest release: v3.9
See [v3.9 release notes](docs/release-v3.9.md) and [v3.9 verification record](docs/verification-v3.9.md).


## v4.0 network intelligence

The trust graph supports direct accepted connections and opt-in second-degree discovery. See `docs/release-v4.0.md` for API, privacy boundaries, and migration details.

## v4.1 business discovery and matching

Business profiles can publish `offers` and `seeks` alongside capabilities. Authenticated organizations can use `/v1/discovery/matches` to find potential suppliers, buyers or complementary partners with transparent capability-overlap explanations. Matching returns only published profile fields and never exposes private contact information. Introductions require a separate connection request and recipient approval. See `docs/release-v4.1.md`.

## v4.2 opportunity and deal pipeline

The commerce workflow now supports buyer-controlled purchase-request closure, supplier quote withdrawal, buyer quote rejection, quote-expiry enforcement, and terminal quote decisions when a request is awarded. Accepting a quote rejects competing submitted quotes for that request, preventing stale proposals from remaining actionable. Purchase-request closure and quote decisions are audited; closure emits the `commerce.purchase_request.closed` webhook event. The existing transaction lifecycle, supplier fulfillment milestones, buyer-confirmed completion, disputes, and reputation workflow remain the downstream path. IMPERIONX OS does not hold customer funds. See `docs/release-v4.2.md`.


## v4.4 Universal Business Intelligence & Decision Engine

The business command center now highlights aged buyer opportunities, unanswered supplier requests, quotations awaiting buyer decisions and active transactions with no recent recorded update. Every item includes its evidence and a suggested next step. Supplier quote response-time metrics are calculated from recorded request and quote timestamps. The intelligence is transparent and rules-based; it is not presented as a predictive AI forecast. All suggestions are advisory and execute no external actions. See `docs/release-v4.4.md` and `docs/verification-v4.4.md`.

## v4.8 — Real Staging Execution & Operational Validation

See `docs/release-v4.8.md`, `docs/verification-v4.8.md`, and `docs/staging-operations-v4.8.md` for the recovery-branch provenance, evidence gate, and explicit external validation requirements.


## v4.9 — Pilot Activation Control & Cohort Governance
Owners and administrators can explicitly activate a controlled pilot only after all tenant setup readiness steps are complete. Activation is audited and refuses incomplete workspaces with a structured list of missing prerequisites. The existing manual enrollment endpoint remains available for draft planning; the guarded activation endpoint is the only route that certifies readiness for active pilot participation. See `docs/release-v4.9.md` and `docs/verification-v4.9.md`.


## v5.0 — Universal Deployment & First Business Launch

The repository now includes a Render Blueprint for a private PostgreSQL database, API, and frontend in Frankfurt; a CI workflow that gates deployments on backend/PostgreSQL, frontend, and container checks; and an optional separately enabled webhook worker. The initial public deployment keeps outbound webhook delivery disabled. See `docs/deployment-render-v5.0.md`, `docs/release-v5.0.md`, and `docs/verification-v5.0.md`. This is deployment configuration, not evidence that a live Render deployment has already occurred.
