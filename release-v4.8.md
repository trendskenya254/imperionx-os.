# IMPERIONX OS v4.8 — Real Staging Execution & Operational Validation

## Release objective
Create a safe, evidence-oriented operational gate for a real staging environment. This release improves the ability to prove staging readiness; it does not claim a staging deployment has occurred.

## Delivered
- Aligned API, worker, model defaults, frontend package and existing version assertions to `4.8.0`.
- Corrected the staging smoke checker, which was still expecting API version `4.2.0`, to require `4.8.0` from both `/health` and `/ready`.
- Added `scripts/pilot_gate.py`, a non-destructive evidence gate that checks HTTPS health/readiness and requires named operational, backup/restore and security-review evidence references.
- Added regression tests for version alignment and the non-destructive gate contract.
- Added a staging evidence record template and explicit stop conditions.
- No database schema change; migration head remains `0024_business_discovery_matching`.

## Safety boundary
The gate does not deploy, run migrations, send email, mutate application data, or enable outbound integrations. Evidence references are recorded as operator-supplied references and are not independently certified by the script.

## Required external execution
Run the gate from the target environment after configuring the environment variables in `docs/staging-operations-v4.8.md`. A successful local test suite is not evidence of live staging, PostgreSQL restore, TLS, SMTP or security review.

## Source provenance note
The persistent Library contained v4.5 as the latest recoverable source archive when this release was assembled. The v4.6 and v4.7 archives described in earlier progress messages were not available in the Library, so this v4.8 recovery branch is based on v4.5 and does not claim to contain unverified v4.6/v4.7 changes. See `docs/verification-v4.8.md`.
