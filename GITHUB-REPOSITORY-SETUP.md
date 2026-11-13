# GitHub repository setup — IMPERIONX OS v5.0

## Recommended repository settings

- Repository name: `imperionx-os`
- Visibility: **Private**
- Description: `IMPERIONX OS — universal business operations platform (v5.0)`
- Initialize with a README: **No** (this source package already includes one)
- Add a license: **No, until the project owner selects one**

## Upload using GitHub's website

1. Sign in to GitHub and choose **New repository**.
2. Enter `imperionx-os`, select **Private**, and create it without adding a README, `.gitignore`, or license.
3. Extract the supplied `imperionx-os-v5.0-github-source.zip` on your computer.
4. Open the new empty repository and choose **Add file → Upload files**.
5. Upload the extracted project contents (the files and folders inside the package, not the ZIP itself).
6. Use commit message `Add IMPERIONX OS v5.0 source baseline` and commit to `main`.
7. Confirm the repository is still private and that the root contains `README.md`, `render.yaml`, `backend/`, `frontend/`, `scripts/`, and `.github/`.

For larger uploads or future engineering work, use GitHub Desktop or Git from a computer instead of the browser uploader.

## Git command-line alternative

After extracting the package and creating an empty private repository on GitHub, run these commands from the extracted project folder, replacing the URL with the HTTPS URL shown by GitHub:

```bash
git init
git add .
git commit -m "Add IMPERIONX OS v5.0 source baseline"
git branch -M main
git remote add origin https://github.com/YOUR-ACCOUNT/imperionx-os.git
git push -u origin main
```

Git will ask you to authenticate through GitHub's supported sign-in flow. Never paste a password, personal access token, or deployment secret into this project or this chat.

## After the first push

1. Open **Actions** and confirm the `IMPERIONX OS CI` workflow is enabled.
2. Let the first workflow run finish; inspect failures rather than bypassing checks.
3. In **Settings → Branches**, add a `main` branch protection rule. Require pull requests and the CI status checks before merging. Select the actual check names shown by the first successful workflow run.
4. Keep Render and SMTP secrets out of GitHub source files. Add deployment credentials only in the hosting provider's secure settings when needed.
5. Do not create the Render services until the CI checks and deployment inputs have been reviewed.

## Provenance and verification

This v5.0 source package is based on the recoverable v4.9 baseline. It does not claim to include source changes from unrecovered intermediate archives. See `docs/release-v5.0.md` and `docs/verification-v5.0.md` for the release scope, verification performed, and outstanding checks.
