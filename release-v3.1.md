# IMPERIONX OS v3.1 — Universal Integration & API Platform

## Delivered
- Organization-owned API credentials with opaque random secrets, SHA-256 hashes at rest, one-time display, supported read scopes, 1–365 day expiry, last-used timestamps and owner/admin revocation.
- API-key authentication isolated to integration endpoints; credentials do not impersonate users or gain browser/session privileges.
- Scoped read endpoints for the organization's own network overview and commerce summary.
- Owner/admin webhook subscriptions with HTTPS endpoint validation, event allowlists, encrypted signing secrets and revocation.
- Signed test-event outbox with per-subscription idempotency and queue visibility.
- Workspace integration panel for credential and webhook administration.

## Deliberate limits
- Webhook events are persisted and signed but are **not sent**. No outbound HTTP delivery worker is included. Before enabling delivery, implement DNS resolution and public-IP validation at dispatch time (including redirect blocking/revalidation), TLS verification, strict timeouts, bounded retries with jitter, dead-letter handling, per-tenant quotas and delivery observability.
- Endpoint hostname validation at subscription creation is not sufficient SSRF protection for future delivery. The worker must re-resolve and validate every destination immediately before each request.
- API rate limiting and usage quotas must be enforced at the edge and per credential before external launch.
- No public developer portal, OAuth authorization-code flow, customer-facing SDK or third-party production integration has been certified.

## Verification
- Backend suite: 77 tests.
- SQLite migration chain reaches `0016_integration_platform`.
- Python compile, frontend syntax transpilation, config validation and ZIP integrity checked for this release.
- Live PostgreSQL, frontend production build, Docker startup and real webhook delivery remain unverified.
