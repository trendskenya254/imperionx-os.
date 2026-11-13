# IMPERIONX OS v4.9 — Pilot Activation Control & Cohort Governance

## Objective
Move pilot onboarding from a descriptive checklist to an enforceable activation gate. A workspace may prepare its pilot enrollment at any time, but the explicit activation action is only allowed after the tenant readiness checklist is complete.

## Delivered
- API, frontend package, worker version defaults, staging smoke check and pilot gate are aligned to `4.9.0`.
- Added `POST /v1/pilot/activate`, restricted to organization owners and administrators.
- Activation reuses the tenant-scoped readiness assessment and returns HTTP 409 with structured `incomplete_steps` when prerequisites are missing.
- A successful activation sets the enrollment status to `active`, preserves the original activation timestamp on repeated calls, and records `pilot.activated` in the tenant audit trail.
- A completed cohort cannot be reactivated through the same activation endpoint.
- Kept the existing `PUT /v1/pilot/enrollment` planning/update path intact for backward compatibility.
- Added regression coverage for incomplete activation, unauthenticated access, successful activation, and audit evidence.
- Aligned API, frontend package, worker defaults, staging smoke and pilot gate to `4.9.0`.
- No schema migration required; migration head remains `0024_business_discovery_matching`.

## API behavior
`POST /v1/pilot/activate` has no request body. On incomplete setup it returns `409` with `message` and `incomplete_steps`. On success it returns the enrollment, activation timestamp and readiness snapshot.

## Safety boundary
Activation is an internal pilot state transition, not a production certification. It does not deploy infrastructure, enable outbound webhooks, send customer messages, process payments, or waive security and operational checks. The readiness checklist is tenant-specific and does not replace a platform security review or staging evidence.
