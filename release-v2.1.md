# IMPERIONX OS v2.1 — Universal Business Onboarding Experience

## Delivered

- Added a public business registration flow collecting owner name, business name, free-text industry, two-letter country code, email and a 12-character-minimum password.
- Registration uses the existing backend identity endpoint; accounts remain unable to sign in until email verification succeeds.
- Added a verification-token screen for the one-time token delivered by the configured email adapter.
- Added a tenant-scoped pilot setup panel showing the existing readiness endpoint's four milestones and completion percentage.
- Added organization invitation and starter manual response-workflow creation from the onboarding panel.
- Team invitations and workflow creation remain role-protected by the API.
- Workflow drafts continue to require human approval; external actions remain disabled.

## Configuration and limitations

- Email verification and invitation delivery require working SMTP configuration and a correct public base URL.
- The verification page accepts a pasted one-time token and automatically reads the token from the email link URL fragment when opened in the same browser.
- The registration form accepts any two-letter country code and free-text industry. Industry is descriptive and is not an eligibility restriction. The form requires industry and country code so the initial business profile can complete its readiness step.
- This release does not claim a completed frontend production build or live deployment.

## Verification

Run backend tests with `cd backend && pytest -q`. Run frontend checks in an environment with dependencies installed using `cd frontend && npm run build`.
