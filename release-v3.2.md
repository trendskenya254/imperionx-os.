# IMPERIONX OS v3.2 — Domain Event Outbox

## Delivered

- Business-domain events are now emitted from the same database transaction as the underlying business change.
- Accepted business connections fan out to active subscriptions owned by both participating organizations.
- Purchase-request creation, quote submission and quote acceptance/transaction creation fan out to relevant buyer/supplier subscriptions.
- Event payloads are deliberately minimal: stable record identifiers and organization identifiers only; no customer contact details or free-text business descriptions.
- Each subscription receives its own idempotency key and HMAC-SHA256 signature. Delivery records remain tenant-scoped.
- Outbox lifecycle metadata now supports scheduled retry, delivered timestamp, response status and dead-letter timestamp.

## Verification boundary

The application persists events; it does **not** send outbound webhook requests. The retry/dead-letter columns are schema foundations, not a running dispatcher. A production dispatcher must use DNS resolution and IP pinning at dispatch time to prevent DNS rebinding, reject all non-public destinations, disable redirects, verify TLS, enforce response-size and timeout limits, apply bounded exponential backoff with jitter, and expose a dead-letter/replay workflow. Do not enable network delivery until these controls and dedicated tests are implemented.

## Release checks

Run `scripts/verify_release.sh`. The release must pass backend tests, Python compilation, fresh SQLite migration chain and archive integrity. Frontend production build, PostgreSQL and Docker checks are reported separately when unavailable.
