# v4.8 Staging Operations & Evidence Record

## Non-destructive readiness command

```bash
STAGING_BASE_URL=https://staging.example.com \
APPROVED_STAGING_OWNER='operator name' \
INCIDENT_CONTACT='incident contact' \
BACKUP_OFFSITE_URI='vault://team/staging-backup-record' \
RESTORE_DRILL_EVIDENCE='ticket-or-record-id' \
SECURITY_REVIEW_EVIDENCE='ticket-or-report-id' \
python scripts/pilot_gate.py
```

The command performs HTTPS GET checks against `/health` and `/ready`, expects API version `4.8.0`, and reports missing evidence. It does not validate that operator-supplied evidence references are genuine; an accountable reviewer must inspect them.

## Required evidence before inviting pilot businesses

- [ ] Staging host, firewall, TLS termination and DNS reviewed.
- [ ] Separate staging PostgreSQL database and credentials confirmed.
- [ ] Deployment preflight and Compose configuration pass on the target host.
- [ ] Migration applied once through the designated migration service; recorded head is `0024_business_discovery_matching`.
- [ ] `/health` and `/ready` pass over HTTPS and report `4.8.0`.
- [ ] Disposable PostgreSQL integration and multi-worker concurrency tests pass.
- [ ] Off-host backup created; checksum recorded; isolated restore completed; application smoke checks pass after restore.
- [ ] Tenant-isolation tests and privileged-access/MFA checks reviewed.
- [ ] SMTP delivery tested with a controlled mailbox; outbound webhook delivery remains disabled until receiver idempotency and egress are approved.
- [ ] Security review, incident owner, support path and rollback owner recorded.
- [ ] Each pilot business signs off on its bounded workflow, data handling, baseline metrics and exit criteria.

## Evidence record

| Item | Evidence reference | Owner | Date (UTC) | Result |
|---|---|---|---|---|
| Staging deployment | | | | Not run |
| PostgreSQL integration | | | | Not run |
| Multi-worker delivery | | | | Not run |
| Off-host backup | | | | Not run |
| Isolated restore drill | | | | Not run |
| Tenant isolation review | | | | Not run |
| TLS / SMTP checks | | | | Not run |
| Security review | | | | Not run |
| Pilot business sign-off | | | | Not run |

## Stop conditions
Immediately pause pilot traffic for cross-tenant exposure, unauthorized external action, failed restore, unexplained data loss, compromised credentials, or repeated critical workflow failure. Preserve redacted logs and audit evidence; do not reopen traffic until an accountable operator signs off recovery.
