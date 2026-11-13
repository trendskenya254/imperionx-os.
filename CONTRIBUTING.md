# Contributing to IMPERIONX OS

Thank you for helping improve IMPERIONX OS.

## Before submitting changes

1. Open an issue describing the problem or proposed change.
2. Keep changes focused and preserve tenant isolation, authorization, auditability, and safe defaults.
3. Never commit credentials, API keys, private keys, production data, or customer information.
4. Add or update tests for behavior changes.
5. Run the relevant backend tests and frontend production build locally when possible.
6. Describe verification performed and anything not verified in the pull request.

## Pull requests

- Target `main` unless the maintainers specify otherwise.
- Explain the user impact and security implications.
- Include migration and rollback notes for database changes.
- Do not enable outbound webhooks or external actions by default.
- External actions that send messages, spend money, sign, or modify records must retain explicit approval controls.

All contributions are subject to maintainer review. A license has not yet been selected; do not assume that this repository grants permission to redistribute or use the code.
