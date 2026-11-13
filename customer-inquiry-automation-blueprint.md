# IMPERIONX OS — Customer Inquiry Automation Blueprint

**Status:** Approved implementation direction  
**Product milestone:** First usable pilot workflow  
**Scope:** Multi-industry small businesses; manual submission first, channel integrations later.

## 1. Product outcome

A business user submits a customer inquiry. IMPERIONX classifies the request, extracts useful details, drafts a response using only authorized business context, and places the draft in an approval queue. A human can edit, approve, or reject it. In the first release, approval records the decision; it does not send a message. Sending is a later connector milestone requiring explicit authorization and an auditable execution record.

## 2. User journey

1. A business owner creates a workspace and supplies its name, industry, country, service description, business hours, and response tone.
2. An authorized user opens **Customer Inquiries** and submits an inquiry with source, customer message, and optional customer reference.
3. The system validates and stores the inquiry under the user's organization.
4. The workflow creates a run and requests a structured AI proposal.
5. The policy layer checks required fields, output schema, tenant context, and whether the proposal is within the draft-only permission boundary.
6. The run enters `pending_approval` and appears in the review queue.
7. An authorized reviewer edits the draft, approves it, or rejects it with an optional reason.
8. The system stores the decision and audit event. No external message is sent in this milestone.

## 3. Functional scope

### P0 — required for the first pilot
- Organization workspace and authenticated membership; roles: `owner`, `admin`, `operator`, `viewer`.
- Business profile sufficient to ground responses: description, products/services, operating hours, contact details, response tone, supported languages.
- Inquiry intake API and basic dashboard form.
- Inquiry status: `new`, `processing`, `needs_review`, `approved`, `rejected`, `failed`, `archived`.
- Workflow run states: `queued`, `running`, `pending_approval`, `approved`, `rejected`, `failed`, `cancelled`.
- Structured AI output validated against a versioned schema.
- Approval queue, reviewer identity, decision timestamp, optional note, and audit history.
- Tenant isolation at every read/write boundary.
- Idempotency for inquiry submission and run creation.
- Safe failure behavior: if the model fails, returns invalid output, or policy checks fail, retain the inquiry and mark the run failed or needing review; never send anything.

### Explicitly out of scope
- Automatic email, SMS, WhatsApp, or social-message sending.
- Payments, refunds, pricing commitments, legal promises, or contract acceptance.
- Autonomous customer account changes.
- Training a shared model on private tenant data.
- Marketplace, business discovery, and network transactions.

## 4. Proposed data model

All tenant-owned records include `organization_id`, indexed and enforced in the service/data-access layer. Use UUID primary keys and UTC timestamps.

### `business_profiles`
- `id`, `organization_id` (unique per organization)
- `description`, `services` (JSON), `products` (JSON)
- `business_hours` (JSON), `contact_details` (JSON)
- `response_tone`, `supported_languages` (JSON)
- `created_at`, `updated_at`

### `inquiries`
- `id`, `organization_id`, `source` (`manual` initially)
- `customer_name` (nullable), `customer_contact` (nullable), `external_reference` (nullable)
- `subject` (nullable), `message` (required), `language` (nullable)
- `status`, `created_by_user_id`, `created_at`, `updated_at`

### `workflow_runs` additions
- `organization_id`, `workflow_id`, `inquiry_id`
- `status`, `input_data`, `proposed_action`
- `model_provider`, `model_name`, `prompt_version`, `schema_version` (nullable metadata)
- `error_code` (safe machine code; no secrets or raw provider credentials)
- `created_at`, `updated_at`, `completed_at`

### `approvals`
- `id`, `organization_id`, `workflow_run_id`
- `decision` (`approved` or `rejected`), `reviewer_user_id`
- `note`, `created_at`

### `audit_events`
- `id`, `organization_id`, `actor_user_id` (nullable for system events)
- `event_type`, `resource_type`, `resource_id`
- `metadata` (allow-listed, no secrets), `created_at`

Add foreign keys, indexes, unique constraints, and migrations before shared environments. Avoid storing unnecessary customer personal data. Define retention and deletion behavior before onboarding real customer data.

## 5. API contract (versioned under `/v1`)

Authentication is mandatory before pilot use. The development-only `X-Organization-ID` selector must not be accepted in staging or production.

- `GET /v1/business-profile` — retrieve the current organization's profile.
- `PUT /v1/business-profile` — create/update profile (owner/admin).
- `POST /v1/inquiries` — submit an inquiry; accept `Idempotency-Key`.
- `GET /v1/inquiries` — list/filter inquiries within the authorized organization.
- `GET /v1/inquiries/{inquiry_id}` — retrieve one inquiry within tenant scope.
- `POST /v1/inquiries/{inquiry_id}/runs` — start draft generation; idempotent.
- `GET /v1/approvals` — list pending approvals for the organization.
- `GET /v1/runs/{run_id}` — inspect proposal and run state.
- `POST /v1/runs/{run_id}/approve` — approve proposal; reviewer permission required.
- `POST /v1/runs/{run_id}/reject` — reject proposal; reviewer permission required.

Return `404` for resources outside the caller's tenant to avoid disclosing their existence. Use consistent structured error responses and pagination for list endpoints.

## 6. AI proposal contract

The model must return JSON matching a server-owned schema, for example:

```json
{
  "category": "product_question",
  "priority": "normal",
  "language": "en",
  "summary": "Customer asks whether the item is available.",
  "missing_information": [],
  "draft_response": "Thank you for contacting us...",
  "suggested_next_step": "Confirm current stock before making an availability promise.",
  "confidence": 0.82,
  "requires_human_review": true
}
```

The values above are illustrative only. The server validates enums, lengths, required fields, and confidence bounds. The model cannot select tools, permissions, recipients, or execute actions. Treat inquiry text and retrieved business content as untrusted data, not instructions. Do not let an inquiry override system policy or request disclosure of another customer's information. If facts are missing, the model must say so rather than invent stock, prices, delivery dates, policies, or guarantees.

## 7. Security and approval policy

- Authenticate users with OIDC/OAuth2; authorize each request through organization membership and role.
- Enforce tenant scope in every query and mutation; add cross-tenant tests.
- Keep provider keys server-side in environment secrets for local development and a managed secret store in hosted environments.
- Minimize personal data sent to the model; document provider retention/training settings.
- Log actor, resource, decision, timestamps, and policy outcome; redact message/contact data from routine logs.
- Approval is bound to the exact proposal version/hash. If the proposal changes, invalidate the old approval.
- Only a later, separately authorized connector may send messages. Require explicit recipient, content preview, permission scope, idempotency key, and execution audit event.
- Add rate limits, request size limits, timeouts, bounded retries, and per-organization usage caps.

## 8. Frontend screens

1. **Workspace setup:** organization and business profile.
2. **Inquiry inbox:** inquiry list, status, source, age, priority.
3. **Inquiry detail:** original message, AI summary, category, missing facts, suggested next step.
4. **Draft review:** editable draft, approve/reject controls, reviewer note.
5. **Activity history:** status changes, model proposal metadata, decisions, failures.
6. **Settings:** members/roles, business profile, AI usage and privacy controls.

Responsive web app first. Do not build native mobile until pilot usage demonstrates the need.

## 9. Test and release gates

### Automated tests
- Organization and membership authorization for every endpoint.
- Cross-tenant inquiry/run/approval reads and writes are denied.
- Duplicate idempotency keys do not create duplicate inquiries or runs.
- Invalid model JSON, missing fields, hallucinated unsupported claims, provider timeout, and prompt-injection attempts fail safely.
- Approval requires the correct role and exact proposal version.
- Rejected/approved runs cannot be decided again.
- No external connector call occurs in this milestone.
- Audit events are created for submission, generation outcome, approval, and rejection.

### Pilot acceptance
- A new user can create a workspace and complete the first inquiry workflow without developer assistance.
- At least 90% of test inquiries produce a schema-valid proposal or a clearly handled safe failure.
- No cross-tenant access in the automated test suite.
- Every decision is attributable to a user and timestamp.
- Pilot users report measurable time saved; track review/edit/reject rates and repeat weekly use.

## 10. Implementation order

1. Repair reproducible local test setup and dependency installation.
2. Add Alembic migrations; remove production reliance on `create_all`.
3. Add users, memberships, authentication integration, and role checks.
4. Add business profile, inquiries, approvals, and audit events.
5. Add workflow state machine, idempotency, and safe failure handling.
6. Add provider-independent AI gateway and schema validation; start with a low-cost provider selected after evaluating privacy, regional availability, latency, and cost.
7. Build responsive inbox and review screens.
8. Run security and pilot acceptance tests; onboard 5–10 design partners.

**Release rule:** Do not onboard real customer inquiries until authentication, tenant isolation, data handling, auditability, and safe-failure tests pass.
