# v4.5 Controlled Pilot Launch Runbook

## Gate 0 — Scope and ownership
- [ ] Name a pilot owner and an incident contact.
- [ ] Select 2–5 consenting businesses across clearly defined workflows.
- [ ] Agree on data categories, retention, support hours, success measures and exit criteria.
- [ ] Document what the platform does not do: no custody of customer funds and no unapproved external actions.

## Gate 1 — Staging infrastructure
- [ ] Provision a supported host, private network, TLS reverse proxy and firewall.
- [ ] Configure unique staging PostgreSQL credentials and a separate staging database.
- [ ] Create `.env` from `.env.example`; set `APP_ENV=staging`, PostgreSQL URL, HTTPS public URL, SMTP and cryptographic secrets.
- [ ] Restrict `.env` to owner read/write (`chmod 600 .env`). Use a secrets manager for shared/production environments.
- [ ] Run `scripts/deploy_preflight.sh` and resolve every failure/warning.
- [ ] Build and start the Compose stack; verify `/health` and `/ready` through the trusted edge.
- [ ] Run migrations once through the migration service; verify migration head.

## Gate 2 — Security and recovery
- [ ] Verify HTTPS, proxy header handling, cookie flags, CSRF controls, MFA enrollment and recovery.
- [ ] Confirm database is not publicly reachable and application services run unprivileged.
- [ ] Confirm logs contain no tokens, secrets, message bodies or unnecessary customer identifiers.
- [ ] Run PostgreSQL integration and multi-worker concurrency tests against disposable databases.
- [ ] Create an encrypted off-host backup and perform a restore into an isolated disposable database.
- [ ] Verify login, tenant isolation, inquiry workflow, email and audit trail after restore.
- [ ] Complete dependency/container scanning and independent security review before sensitive or broad production use.

## Gate 3 — Pilot acceptance
- [ ] Test one end-to-end workflow with each pilot business and obtain explicit sign-off.
- [ ] Train users and explain AI limitations, human approval points and support process.
- [ ] Record baseline response time and workflow effort before activation.
- [ ] Review results weekly: response time, time saved, completion/failure, edits/approvals/rejections, repeat usage and cost per run.
- [ ] Pause a workflow on cross-tenant data exposure, unauthorized action, unrecoverable data loss or repeated critical failure.

## Rollback
1. Stop routing new user traffic to the affected release.
2. Disable external connectors/webhook delivery and preserve audit logs.
3. Capture incident timestamps and relevant redacted diagnostics.
4. Restore the last known-good application image and, only if required, a verified database backup into a controlled target.
5. Validate readiness, authentication, tenant boundaries and core inquiry workflow before reopening traffic.
6. Record recovery time, data-loss window, root cause and corrective action.

A checklist marked complete is evidence only when supported by recorded test output, configuration review or an owner sign-off. Never mark a gate complete based solely on this document.
