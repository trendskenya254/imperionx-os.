# IMPERIONX OS — Technical Architecture v0.1

## 1. Architecture decision
Start with a **modular monolith**, not microservices. It minimizes operational overhead for a bootstrapped team while preserving clear domain boundaries. Extract services only when load, team ownership or isolation requirements justify it.

## 2. Logical components
- Experience: responsive web app, later mobile app and messaging interfaces.
- API edge: REST API, versioning, rate limiting, request validation.
- Identity & tenancy: users, organizations, memberships, roles, permissions.
- AI orchestration: model gateway, prompt/version registry, structured output validation, evaluation and policy checks.
- Workflow engine: triggers, steps, retries, idempotency, schedules, run history.
- Approval service: human-in-the-loop queue and policy-based approval requirements.
- Connector framework: OAuth credentials, scoped permissions, webhooks, provider adapters.
- Business graph: organization identity, verified profiles, relationships, catalog and discovery.
- Data: PostgreSQL as system of record; object storage for files; Redis for cache/short-lived jobs.
- Async processing: start with a PostgreSQL-backed job table; add a queue (e.g. Redis/Celery or Kafka) only when required.
- Observability: structured logs, metrics, traces, audit trail and alerting.

## 3. Domain boundaries
1. Identity & organizations
2. Business profile and verification
3. AI assistant and knowledge
4. Workflow definitions and runs
5. Approvals and policy
6. Connector registry
7. Commerce and transactions (later)
8. Network discovery and business graph (later)
9. Billing and entitlements (later)

## 4. Multi-tenancy and security
- Every tenant-owned row carries organization_id.
- Enforce tenant scope in the data-access layer, not only in UI filters.
- Production: OIDC authentication, membership checks, RBAC/ABAC, MFA for privileged roles.
- PostgreSQL row-level security is a defense-in-depth option; apply and test it before external production access.
- Encrypt data in transit and at rest; store connector secrets in a managed secrets vault.
- Never put API keys in source code or browser bundles.
- Record immutable audit events for access to sensitive data and consequential actions.
- Use idempotency keys for external actions and signed webhooks with replay protection.
- Define retention, deletion, export and data residency policies by jurisdiction.
- Treat all external content as untrusted input; defend against prompt injection and data exfiltration.

## 5. AI safety and control plane
Request → tenant authorization → data minimization → model gateway → schema validation →
policy checks → risk classification → approval queue → connector execution → audit record.

Default autonomy:
- Read-only analysis: permitted within granted scope.
- Drafting: allowed, visibly marked as AI-generated.
- Sending messages, spending money, changing records, signing agreements: approval required by default.
- High-risk or regulated decisions: no autonomous execution; route to qualified humans.
- AI must not train on one tenant's private data for another tenant without explicit lawful permission.

## 6. Global-first requirements
- Store timestamps in UTC; display in user locale.
- Use ISO country codes and international phone/address formats.
- Support multiple currencies using explicit currency codes and source timestamps for FX.
- Externalize UI strings for localization.
- Design for regional privacy, consumer, tax, payments and data-residency rules.
- Do not claim global legal compliance until jurisdiction-specific review is complete.

## 7. Scale and reliability
Initial target: a pilot of 5–10 businesses and a few hundred workflow runs per day.
- Stateless API containers.
- PostgreSQL backups and restore drills.
- Timeouts, retries with backoff and dead-letter handling for async jobs.
- Rate limits and per-tenant quotas.
- SLOs established after pilot measurements; do not promise arbitrary uptime.
- Load-test before increasing customer volume.

## 8. Deployment topology
Local: Docker Compose + PostgreSQL.
Pilot: managed PostgreSQL, managed container runtime, object storage, secrets manager, central logs/metrics.
Scale: separate worker pool, cache, queue, read replicas and service extraction based on measured bottlenecks.
