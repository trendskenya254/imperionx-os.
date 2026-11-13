# IMPERIONX OS v5.0 — First deployment on Render

This is a provider-specific deployment profile, not a completed deployment. It creates a managed PostgreSQL database, private API service, and public Next.js frontend. Render supplies temporary `onrender.com` HTTPS hostnames; attach a custom domain later.

## Why this topology

- API and database are in the same Frankfurt region; the database has an empty IP allow-list and is reached over Render's private network.
- The API uses a paid plan because Render's `preDeployCommand` (Alembic migrations) is only available on paid web services.
- The API readiness probe is `/ready`; Render routes traffic only after the probe passes.
- Frontend-to-API traffic uses the private service hostname, not the public API hostname.
- `autoDeployTrigger: checksPass` makes Render wait for repository CI checks before auto-deploying.
- Outbound webhook delivery stays disabled. The worker is an optional separate profile and is not part of the initial deployment.

## Before connecting Render

1. Put this release in a private GitHub repository. Do not commit `.env`, database dumps, SMTP credentials, model keys, or generated secrets.
2. Set the default branch to `main` and enable the `IMPERIONX OS CI` GitHub Actions workflow.
3. Require the CI status checks on the protected deployment branch. Confirm the backend/PostgreSQL job and frontend/container job are required before merging.
4. Review the current Render plans and pricing for your account and region. This topology uses paid compute and paid managed PostgreSQL; do not assume the free tier is suitable for a real pilot.

## Create the deployment

1. In Render, choose **New → Blueprint** and connect the private GitHub repository containing `render.yaml`.
2. Select the Frankfurt region when prompted; the Blueprint declares Frankfurt for every service and database.
3. Review the Blueprint before applying it. It creates `imperionx-db`, `imperionx-api`, and `imperionx-frontend`.
4. Supply the prompted values securely in Render's dashboard:
   - `PUBLIC_BASE_URL`: the frontend's generated `https://<service>.onrender.com` URL. Create the service first if necessary, then set this value and redeploy the API.
   - `SMTP_HOST`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_FROM_EMAIL`: credentials from a transactional email provider that supports SMTP. `SMTP_FROM_EMAIL` must be a verified sender address. Keep SMTP port 587 and TLS enabled unless your provider explicitly documents another secure configuration.
5. Render generates `MFA_ENCRYPTION_KEY` and `PUBLIC_RATE_LIMIT_HMAC_KEY`. Never copy them into source control or chat.
6. Confirm `DATABASE_URL` resolves to the private Render PostgreSQL connection string. Do not add a public database IP allow-list entry.
7. Deploy the API first. Its paid pre-deploy command runs `alembic upgrade head`; `/ready` must pass before it receives traffic.
8. Deploy the frontend and confirm it can load through the same-origin API proxy. The frontend's `IMPERIONX_API_INTERNAL` points to the API's private host and port.
9. Copy the generated frontend HTTPS URL into `PUBLIC_BASE_URL` on the API service and redeploy. This ensures account verification and recovery links use the temporary HTTPS hostname.
10. Run `STAGING_BASE_URL=https://<frontend-host>.onrender.com python scripts/staging_smoke.py` against the API's public URL only if the script is pointed to the API service URL. The smoke script expects `/health` and `/ready`, so use the API's generated URL, not the frontend URL.

## Email and identity gates

The backend deliberately refuses to start in production unless PostgreSQL, HTTPS `PUBLIC_BASE_URL`, SMTP, a valid Fernet MFA key, a 32-character rate-limit HMAC key, and a deliverable sender address are configured. Do not weaken these checks to force a deployment. First-owner MFA and account recovery must be exercised before inviting a pilot organization.

## Webhook worker — later, opt-in

Do not deploy `deploy/render-worker.yaml.example` during the first public launch. Only add it after outbound webhook receiver validation, HTTPS-only egress controls, DNS/IP pinning review, signing-secret handling, receiver-side idempotency, and incident ownership are confirmed. Set `WEBHOOK_DELIVERY_ENABLED=true` only after that review. The default remains false.

## Verification after deployment

- Check API `/health` and `/ready` over HTTPS.
- Confirm `/ready` reports version `5.0.0` and database connectivity.
- Register an owner, verify email, enroll MFA, sign out/in, and test account recovery.
- Create two separate organizations and verify cross-tenant reads/writes are denied.
- Complete one customer inquiry using safe-demo mode; review, edit, approve/reject. No external message is sent by this workflow.
- Create a database backup and perform a restore drill into a separate disposable database before importing real customer records.
- Record actual hostnames, commit SHA, migration head, CI run, backup evidence, and operator in the deployment register.

## Rollback

A code rollback does not automatically reverse database migrations. Stop traffic or put the service into maintenance mode, identify whether the deployed migration is backward compatible, restore a tested database backup only when required and approved, then redeploy the known-good commit. Never run `alembic downgrade` against production as an improvised rollback.

## Known limitations

This repository profile has not been deployed to a Render account from this environment. The GitHub Actions workflow has not run on GitHub. SMTP credentials, hostnames, service provisioning, live HTTPS, real account verification, PostgreSQL restore, and production security review remain operator actions. Render prices and plan availability can change; review the live dashboard before creating paid resources.
