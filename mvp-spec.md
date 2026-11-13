# MVP Specification — IMPERIONX OS v0.1

## Target user
Owner/operator or operations manager at a small or mid-sized business, across any industry.

## Core promise
"Describe a repetitive business task, receive an AI-assisted proposed workflow, review it, and approve the next step."

## Primary user journey
1. Create organization workspace.
2. Add business name, industry and country.
3. Create a workflow from a template or plain-language description.
4. Submit a sample input (customer inquiry, supplier request, internal task).
5. AI layer proposes a structured draft or action.
6. User reviews, edits externally if needed, approves or rejects.
7. System stores the result and audit context.

## MVP features
P0:
- Organization/workspace creation
- Tenant-scoped workflow CRUD (create/list initially)
- Manual workflow trigger
- AI adapter boundary
- Structured proposed action
- Human approval/rejection
- Run history
- Health endpoint and basic API documentation

P1:
- Production authentication and RBAC
- Audit log
- Workflow templates: customer inquiry triage, quote drafting, supplier follow-up, meeting summary
- Connector framework (start with one email/calendar provider)
- Notification preferences
- Usage limits and metering

Out of scope for v0.1:
- Custody of funds or payment processing
- Autonomous email sending or contract signing
- Universal marketplace
- Credit scoring, hiring or other high-impact automated decisions
- Full ERP replacement
- Claims of compliance across every country

## Acceptance criteria
- A user can create an organization and workflow.
- A workflow run is persisted and visible in run history.
- A proposed action is generated without executing external side effects.
- Only a member authorized for that organization can approve/reject its runs (production auth is a release blocker).
- Cross-tenant access tests return 404/403.
- All consequential actions have an audit record before production.
- API errors are structured and secrets never appear in logs.

## Pilot success metrics
- Time from signup to first useful workflow.
- Percentage of runs approved, edited, rejected.
- Repeat weekly active organizations.
- Minutes of work saved (self-reported and sampled).
- Workflow failure rate.
- Connector authorization revocation rate.
- Support requests per active organization.
