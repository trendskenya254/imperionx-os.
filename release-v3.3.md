# IMPERIONX OS v3.3 — Secure Webhook Delivery Engine

## Scope

v3.3 adds an independently operated outbound webhook worker to the v3.2 transactional event outbox. API requests only persist events; they do not make outbound network calls.

## Delivered capabilities

- Separate `webhook-worker` Compose service; API process does not perform outbound webhook delivery.
- Worker is fail-closed behind `WEBHOOK_DELIVERY_ENABLED` (default `false`). The Compose worker service explicitly opts in; the API remains disabled.
- Dispatch-time DNS resolution and rejection of any loopback, private, link-local, reserved, multicast, or otherwise non-global address. Mixed public/private DNS answer sets are rejected.
- TCP connection pinned to a validated resolved IP, while TLS SNI and certificate verification use the original hostname. DNS is re-resolved on every attempt.
- HTTPS only, default port 443 only, no credentials/fragments, no redirects, bounded connect/read timeouts, bounded response body.
- HMAC-SHA256 signature re-verification immediately before sending; stable delivery ID and idempotency headers.
- Bounded retry policy (8 attempts maximum), capped exponential backoff, dead-letter state, and owner/admin manual replay.
- Tenant-scoped delivery history and health counts; maximum 10 active webhook subscriptions per organization.

## Worker operations

The worker runs separately from the API:

```bash
cd backend
python -m app.webhook_delivery --once
python -m app.webhook_delivery
```

Set `WEBHOOK_DELIVERY_ENABLED=true` only in the dedicated worker environment after reviewing outbound network policy. Never expose worker credentials or the encryption key in frontend code. The API's setting should remain false.

## Delivery contract

Headers include `X-ImperionX-Event`, `X-ImperionX-Delivery`, `X-ImperionX-Signature`, and `Idempotency-Key`. The signature is `sha256=<hex HMAC>` over canonical compact JSON (`sort_keys=true`, separators `(',', ':')`). Receivers should verify the signature using the one-time-displayed signing secret and deduplicate using `Idempotency-Key`.

Only 2xx responses count as delivered. Non-2xx and transient transport failures retry with bounded backoff. Unsafe targets, invalid persisted signatures, and exhausted retries are dead-lettered. Redirects are not followed. Manual replay resets the delivery attempt counter but preserves its original event and idempotency identity; receivers must therefore remain idempotent.

## API

- `POST /v1/integrations/webhooks/{subscription_id}/test-event`
- `GET /v1/integrations/webhooks/deliveries`
- `GET /v1/integrations/webhooks/health`
- `POST /v1/integrations/webhooks/deliveries/{delivery_id}/replay`
- `POST /v1/integrations/webhooks/{subscription_id}/revoke`

All management and replay routes require organization owner/admin authorization and scope records to the authenticated organization.

## Limitations / production gates

- Delivery is at-least-once, not exactly-once. Receiver-side idempotency is mandatory.
- PostgreSQL multi-worker behavior must be validated in the target deployment; SQLite is for local development/tests only.
- DNS pinning and TLS behavior have unit-level coverage; a live external endpoint integration test and infrastructure egress policy review remain deployment gates.
- No production deployment is claimed by this release.
