# v3.4 — Production Reliability & Observability

## Objective

Make the secure v3.3 webhook runtime diagnosable and operable without exposing secrets or cross-tenant delivery data.

## Implemented

- `webhook_delivery_attempts`: durable per-attempt records for outcome, HTTP response status, bounded error code, elapsed milliseconds and timestamp.
- `webhook_worker_heartbeats`: worker identity, running/idle/stopped state, last-seen time, processed/failure counters and runtime version.
- `GET /v1/integrations/webhooks/deliveries/{delivery_id}/attempts`: owner/admin-only, tenant-scoped attempt history.
- `GET /v1/integrations/webhooks/metrics`: owner/admin-only tenant metrics with queue counts, rolling 24-hour outcomes and recent worker presence.
- Frontend reliability panel surfaces the operational metrics.
- Migration `0019_webhook_observability`.

## Safety and limits

- Attempt records do not store payloads, secrets, full exception text or receiver response bodies.
- Worker presence is an aggregate indicator: at least one worker heartbeat must be newer than 90 seconds.
- Delivery remains disabled by default. A heartbeat proves a process recently reported, not that outbound delivery is healthy or production-ready.
- Delivery is at-least-once; receiver idempotency remains mandatory.

## Verification

See `docs/verification-v3.4.md`. PostgreSQL concurrency, Docker startup, frontend production build and live external HTTPS delivery are deployment gates, not inferred from unit tests.
