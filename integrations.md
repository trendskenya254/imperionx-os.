# IMPERIONX OS Integration API

## Credential model

An organization owner/admin with MFA can create API credentials. The opaque key is returned once and is stored only as a SHA-256 digest. Keys are organization-bound, scope-limited, expire after 1–365 days, and can be revoked. Send the key in `X-API-Key`; never put it in a URL, browser bundle, source repository or logs.

Supported read scopes:
- `network:read` — `GET /v1/integrations/network/overview`
- `commerce:read` — `GET /v1/integrations/commerce/summary`

Example:

```bash
curl https://api.example.com/v1/integrations/network/overview \
  -H 'X-API-Key: ixx_live_REPLACE_WITH_SECRET'
```

Create credentials through the authenticated organization workspace:

```http
POST /v1/integrations/credentials
Authorization: Bearer <user-session>
X-Organization-ID: <organization-id>
Content-Type: application/json

{"name":"Accounting read sync","scopes":["commerce:read"],"expires_in_days":90}
```

## Webhook subscriptions

Owners/admins can create HTTPS subscriptions for allowlisted event types. The signing secret is generated once and encrypted at rest. Test events are canonical-JSON serialized and HMAC-SHA256 signed; the resulting event and signature are persisted in a tenant-scoped queue with an idempotency key.

Supported event types:
- `network.connection.accepted`
- `commerce.purchase_request.created`
- `commerce.quote.submitted`
- `commerce.transaction.updated`

**Outbound delivery remains disabled in v3.2.** The application does not make outbound HTTP requests. Before enabling a worker, re-resolve DNS immediately before every attempt, reject loopback/private/link-local/reserved/multicast IPs, block redirects, enforce TLS certificate validation, apply strict connect/read timeouts, bounded retries with jitter, dead-letter handling, per-subscription quotas and observable delivery outcomes. DNS rebinding must be addressed at dispatch time, not only when a subscription is created.

## Operational requirements before third-party launch

- Add edge and per-credential rate limits and usage quotas.
- Ensure API keys and webhook secrets are redacted from logs and support tooling.
- Rotate encryption keys using a documented key-versioning migration plan.
- Define data retention, deletion, incident response and customer key-compromise procedures.
- Run PostgreSQL concurrency tests for idempotency and credential revocation.
- Complete external security review and integration partner testing.


In v3.2, real business events are atomically added to the outbox for matching active subscriptions. The event is committed or rolled back with its business record. Supported event sources are accepted connections, purchase requests, submitted quotes and quote acceptance/transaction creation. Payloads contain identifiers and status only.

## Secure webhook delivery (v3.3–v3.4)

Webhook events remain transactionally queued by the API. A separate worker performs outbound delivery only when `WEBHOOK_DELIVERY_ENABLED=true` in that worker's environment. Keep the API setting false. The worker permits HTTPS on port 443 only, resolves and validates public DNS addresses on each attempt, pins the connection to a validated IP, verifies TLS against the original hostname, and never follows redirects. It signs canonical JSON with HMAC-SHA256 and sends a stable idempotency key. Retries are bounded; exhausted or unsafe deliveries enter the dead-letter queue and can be replayed by an organization owner/admin. Delivery is at-least-once, so receivers must verify signatures and deduplicate.


### v3.4 operational visibility

The worker writes a durable `webhook_delivery_attempts` row for each network/signature attempt, including attempt number, outcome, HTTP status, bounded error code and elapsed milliseconds. `webhook_worker_heartbeats` records process state and last-seen time. Owner/admin endpoints expose tenant-scoped attempt history (`GET /v1/integrations/webhooks/deliveries/{id}/attempts`) and 24-hour queue/outcome metrics (`GET /v1/integrations/webhooks/metrics`). The dashboard shows queue counts and whether a worker has been observed in the last 90 seconds. Worker presence is a liveness hint, not a guarantee of successful external delivery.

Attempt diagnostics deliberately omit payloads, signing secrets, full exception strings and receiver response bodies. Delivery remains at-least-once; receivers must deduplicate idempotency keys.
