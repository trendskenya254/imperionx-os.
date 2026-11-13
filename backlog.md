# Development Backlog

Priority: P0 = release blocker; P1 = next; P2 = later.

## Epic A — Foundation
- [P0] Repository, environment configuration, Docker Compose
- [P0] PostgreSQL persistence and migrations (replace create_all with Alembic before shared environments)
- [P0] API health and versioning
- [P0] CI pipeline, linting, dependency scanning
- [P1] Infrastructure as code and deployment environments

## Epic B — Identity and tenancy
- [P0] OIDC login and secure sessions
- [P0] Organization membership and invitation
- [P0] RBAC roles: owner, admin, operator, viewer
- [P0] Tenant isolation tests and database policies
- [P1] Business verification workflow and evidence review
- [P1] Export and deletion workflows

## Epic C — AI orchestration
- [P0] Provider-independent model gateway
- [P0] Structured JSON outputs with schema validation
- [P0] Prompt versioning and evaluation set
- [P0] Input minimization and tenant-context boundaries
- [P0] Prompt-injection and data-exfiltration tests
- [P1] Model routing, budget caps and per-tenant quotas
- [P1] Feedback capture and quality evaluation

## Epic D — Workflow engine
- [P0] Workflow templates and versioning
- [P0] Run state machine and idempotency
- [P0] Approval policies and reviewer queue
- [P0] Retry/backoff and failure handling
- [P1] Scheduled and event-based triggers
- [P1] Workflow visual builder

## Epic E — Connectors
- [P0] Connector permission model and credential vault
- [P1] First email connector (draft-only)
- [P1] Webhook connector with signature verification
- [P1] Accounting/CRM connector
- [P2] POS, ERP, logistics and commerce integrations

## Epic F — Network
- [P1] Universal business profile and stable business ID
- [P1] Business directory and search
- [P1] Connection requests and consent
- [P2] Product/service catalog
- [P2] RFQ, quotation and purchase order exchange

## Epic G — Trust, operations and launch
- [P0] Audit events and security monitoring
- [P0] Backups and restore drill
- [P0] Privacy notice, terms and data processing map
- [P0] Threat model and penetration test before public launch
- [P1] Localization, currency and timezone support
- [P1] Support and incident response process
- [P1] Pilot with 5–10 design partners

## Immediate execution sequence — Customer Inquiry Automation
1. [P0] Make test/dependency setup reproducible; document one-command local test run.
2. [P0] Add Alembic migrations and remove startup `create_all` from non-test environments.
3. [P0] Implement authenticated users, organization memberships, and owner/admin/operator/viewer permissions.
4. [P0] Add business profiles, inquiry records, approval records, and audit events.
5. [P0] Add inquiry workflow state machine, idempotency, and safe failure handling.
6. [P0] Add provider-independent model gateway with structured output validation and prompt-injection tests.
7. [P1] Build responsive inquiry inbox and draft-review dashboard.
8. [P1] Pilot with 5–10 businesses; measure time saved, approval/edit/rejection, failure rate, and weekly retention.

See `customer-inquiry-automation-blueprint.md` for the product, data, API, AI, security, UI, test, and release specification.

## Milestone 0.2 — Customer inquiry backend slice
- [x] Add tenant-scoped inquiry persistence and list endpoint.
- [x] Add inquiry-to-workflow-run proposal endpoint.
- [x] Add provider-independent AI gateway boundary and safe local demo provider.
- [x] Record approval/rejection back onto inquiry status.
- [x] Add idempotency-key handling for inquiry intake.
- [x] Add SQLite-backed automated API tests for happy path and tenant boundary.
- [ ] Add Alembic migrations and migration-based startup.
- [ ] Replace development tenant header with OIDC authentication and membership roles.
- [ ] Add audit events and reviewer identity.
- [ ] Select and integrate a live AI provider after privacy/cost review.
- [ ] Add real PostgreSQL integration test in Docker.

## Milestone 003 — Security and identity foundation

- [x] Password-based account registration with scrypt password hashing
- [x] Opaque bearer sessions stored as SHA-256 token digests with expiry and logout revocation
- [x] Organization membership and admin/staff/viewer role checks
- [x] Organization-scoped API authorization
- [x] Membership administration for already-registered users
- [x] Organization-scoped audit event records and admin-only audit endpoint
- [x] Alembic baseline and security migrations
- [x] Automated auth, role, logout, tenant-isolation and inquiry workflow tests
- [ ] PostgreSQL integration test run
- [ ] Rate limiting, email verification, MFA, recovery and production secrets management
- [ ] External security review and deployment hardening


## Milestone 005 — Refresh-token hardening
- [x] Short-lived 15-minute access tokens
- [x] Opaque refresh tokens stored as SHA-256 digests
- [x] Refresh-token rotation with session-family tracking
- [x] Reuse detection revokes the active session family
- [x] Logout revokes all sessions in the current family
- [x] Alembic migration for refresh-token metadata; legacy sessions forced to re-authenticate
- [x] Automated rotation, replay, and logout-family tests
- [ ] Persistent login/register rate limiting and abuse monitoring
- [ ] Email verification and secure password recovery delivery
- [ ] MFA for privileged roles
- [ ] PostgreSQL integration and external security review


## v1.5 follow-up / next engineering priorities
- Validate sales reporting and migration against a live PostgreSQL service, including unique-inquiry sale race conditions.
- Add configurable currency minor-unit metadata instead of assuming two decimals for every currency.
- Add date-range trends, channel/source attribution, refunds/voids, and reconciliation workflows before treating the metrics as accounting data.
- Add conversion-stage timestamps and response-time/SLA metrics with explicit definitions.
- Replace browser `sessionStorage` bearer-token storage with a server-side session BFF and HttpOnly Secure SameSite cookies; add CSRF/CSP/security headers.
- Add frontend production build, browser tests, dependency scanning, and external security review.
- Keep AI recommendations explainable and aggregate-only until evaluated against pilot outcomes; never label deterministic rules as live AI.


## v1.6 delivered — Universal Business Intelligence
- [x] Privacy-preserving repeat customer and buyer aggregates
- [x] Product/service performance by currency
- [x] Daily sales trend endpoint
- [x] Clearly labelled historical run-rate illustration (not predictive forecasting)
- [x] Tenant-scoped tests for new intelligence endpoints

## Next engineering priorities
- Validate frontend production build and browser session hardening (HttpOnly Secure SameSite cookie BFF, CSRF, CSP).
- Run PostgreSQL integration tests and a backup/restore drill.
- Add product/service catalogue and explicit line items before treating descriptions as a full product catalogue.
- Add cost, refund and margin records before reporting profit or profitability.
- Build real predictive forecasting only after sufficient historical data, seasonality treatment and confidence intervals are available.


## v1.7 delivered — Intelligent Business Growth Engine
- [x] Organization-scoped, explainable inquiry follow-up action queue
- [x] Human-review and unassigned-inquiry recommendations
- [x] 24-hour and 72-hour inactivity thresholds, with high-priority escalation
- [x] Dashboard panel with links to the relevant inquiry
- [x] No autonomous messaging or inquiry mutation

## v1.7 follow-up / production priorities
- Validate Next.js production build and browser flows in an environment with dependency registry access.
- Replace sessionStorage bearer tokens with an HttpOnly Secure SameSite cookie BFF and add CSRF/CSP protections.
- Run PostgreSQL integration tests and a backup/restore drill.
- Add response-time/SLA event history and pilot-measured thresholds before introducing more growth scoring.


## v1.8 delivered — Secure Production Readiness Foundation
- [x] Same-origin Next.js BFF for authenticated API requests
- [x] HttpOnly, SameSite=Strict cookie storage for access and refresh tokens; Secure in production
- [x] Server-side bearer forwarding; browser no longer stores bearer tokens or creates Authorization headers
- [x] Refresh-token rotation on expiry/401, with selected-organization preservation
- [x] Same-origin Origin validation and cross-site Fetch Metadata rejection for mutations
- [x] Server-side logout and BFF session restoration
- [x] First-login owner/admin MFA enrollment flow and one-time recovery-code display
- [x] CSP and browser/API security headers; production HSTS
- [x] Production configuration validation for Fernet key format and SMTP credentials
- [x] Backend security-header and configuration tests

## v1.8 remaining release gates
- [ ] Install pinned frontend dependencies and complete `next build`; commit lockfile
- [ ] Browser E2E for login, MFA, cookie flags, refresh rotation, CSRF, logout and tenant preservation
- [ ] Live PostgreSQL integration/concurrency suite and backup/restore drill
- [ ] CSP nonce review, dependency/container scanning, and independent security review


## v3.6 follow-through / production gates

- [ ] Run PostgreSQL concurrency suite against disposable PostgreSQL.
- [ ] Build and start all Compose services on a Docker-capable staging host.
- [ ] Complete HTTPS staging smoke test.
- [ ] Complete isolated backup restore drill and post-restore smoke test.
- [ ] Verify receiver-side HMAC and idempotency with a controlled webhook sink.
- [ ] Rehearse rollback and capture dated evidence before production approval.
