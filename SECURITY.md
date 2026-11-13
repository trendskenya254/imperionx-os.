# Security policy

## Reporting a vulnerability

Please do not report exploitable vulnerabilities in public issues. Until a private security contact is published, contact the repository owner through a private channel and include steps to reproduce, affected versions, and potential impact. Do not include real customer data or secrets in the report.

## Secret handling

- Keep the repository private during initial setup.
- Never commit `.env`, credentials, tokens, private keys, database dumps, or production data.
- Store deployment secrets in the hosting provider's secret/environment settings.
- Rotate any credential that may have been exposed.

## Deployment posture

The v5.0 baseline keeps webhook delivery disabled by default and uses a safe-demo AI provider. Review `docs/deployment-render-v5.0.md` and `docs/production-readiness.md` before deployment. Passing repository tests does not by itself establish production security or readiness.
