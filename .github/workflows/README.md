# GitHub Actions Workflows

This directory contains automated workflows for the Cobble Friends modpack.

## Available Workflows

### 1. Release Workflow (`release.yml`)

**Purpose:** Automatically creates a new GitHub release when the modpack version is updated.

**Triggers:**
- Push to `main`, `master`, or `pre` branch
- Changes in `modpack/**` directory

**What it does:**
1. ✅ Validates and refreshes the modpack index
2. 📦 Extracts version from `modpack/pack.toml`
3. 🔍 Checks if a release for this version already exists
4. 📝 Generates a changelog from git commits
5. 🚀 Creates a GitHub release with:
   - Version tag (e.g., `v1.0.0`)
   - Changelog
   - Downloadable modpack ZIP file

**How to create a new release:**

**Method 1: Stable Release (main/master branch)**
1. Update the version in `modpack/pack.toml`:
   ```toml
   version = "1.1.0"  # Increment from 1.0.0
   ```
2. Commit and push to main:
   ```bash
   git add modpack/pack.toml
   git commit -m "Release version 1.1.0"
   git push origin main
   ```
3. The workflow automatically creates a stable release!

**Method 2: Pre-release (pre branch) - Recommended for testing**
1. Switch to the `pre` branch (or merge your changes into it):
   ```bash
   git checkout pre
   git merge main  # or make your changes directly
   ```
2. Push to the pre branch:
   ```bash
   git push origin pre
   ```
3. The workflow automatically creates a pre-release with version `X.Y.Z-pre.{commit-hash}`

**Method 3: Pre-release (version identifier)**
1. Update the version in `modpack/pack.toml` with a pre-release identifier:
   ```toml
   version = "1.1.0-beta.1"  # or -alpha.1, -rc.1, etc.
   ```
2. Commit and push to main:
   ```bash
   git add modpack/pack.toml
   git commit -m "Release version 1.1.0-beta.1"
   git push origin main
   ```
3. The workflow creates a pre-release (marked with 🚧 badge)

**Notes:**
- Stable versions must follow: `X.Y.Z` (e.g., `1.0.0`, `1.2.3`)
- Pre-release versions must follow: `X.Y.Z-identifier` (e.g., `1.0.0-alpha.1`, `1.0.0-beta.2`, `1.0.0-rc.1`)
- **Pushing to the `pre` branch automatically creates a pre-release** (no version change needed!)
- Pre-releases from the `pre` branch append `-pre.{commit}` to the version automatically
- Pre-releases are automatically marked as "pre-release" in GitHub and include a warning
- If a release already exists for the current version, the workflow skips release creation
- The changelog is auto-generated from git commit messages

**Recommended workflow:**
- Use the `pre` branch for testing and development builds
- Merge to `main` when ready for a stable release
- Update version numbers only for major releases

---

### 2. CI Validation Workflow (`ci.yml`)

**Purpose:** Validates the modpack structure on every push and pull request.

**Triggers:**
- Push to any branch
- Pull requests to `main` or `master`

**What it does:**
1. ✅ Validates modpack structure (`pack.toml`, `index.toml`)
2. 🔢 Checks version format (must be `X.Y.Z`)
3. 📊 Displays mod count
4. ⚡ Runs packwiz refresh to ensure integrity

**Benefits:**
- Catches configuration errors early
- Ensures version format is correct
- Validates all mod references are valid
- Runs on all branches and PRs for quality control

---

## Workflow Status

You can view the status of all workflows in the **Actions** tab of your GitHub repository.

### Quick Links:
- 🟢 **Workflows:** `https://github.com/<username>/<repository>/actions`
- 📦 **Releases:** `https://github.com/<username>/<repository>/releases`

---

## Troubleshooting

### Release workflow isn't creating a release
- ✅ Check that you updated the version in `modpack/pack.toml`
- ✅ Ensure the version follows format `X.Y.Z` (e.g., `1.0.0`)
- ✅ Verify a release doesn't already exist for this version
- ✅ Check the Actions tab for error messages

### CI validation is failing
- ✅ Run `packwiz refresh` locally in the `modpack/` directory
- ✅ Ensure `pack.toml` and `index.toml` exist
- ✅ Verify version format in `pack.toml` is `X.Y.Z`

---

## Customization

### Changing release branch
Edit `.github/workflows/release.yml`:
```yaml
on:
  push:
    branches:
      - your-branch-name  # Change this
```

### Disabling a workflow
Add this to the top of any workflow file:
```yaml
on:
  workflow_dispatch:  # Only manual triggers
```

---

## Best Practices

1. **Version Management:**
   - Use semantic versioning: `MAJOR.MINOR.PATCH`
   - Increment MAJOR for breaking changes
   - Increment MINOR for new features
   - Increment PATCH for bug fixes
   
   **Pre-release identifiers:**
   - `alpha` - Early development, may be unstable
   - `beta` - Feature complete, but needs testing
   - `rc` (release candidate) - Nearly ready for production
   - Examples: `1.0.0-alpha.1`, `1.0.0-beta.2`, `1.0.0-rc.1`
   
   **Version progression example:**
   ```
   1.0.0-alpha.1 → 1.0.0-alpha.2 → 1.0.0-beta.1 → 1.0.0-rc.1 → 1.0.0
   ```

2. **Commit Messages:**
   - Write clear commit messages (they appear in changelogs)
   - Format: `type: description` (e.g., `feat: add sodium mod`, `fix: remove conflicting mod`)

3. **Testing:**
   - Make changes in a branch first
   - Create a pull request to see CI validation
   - Merge to main only after CI passes

---

## Security Notes

- ✅ Workflows use `GITHUB_TOKEN` which is automatically provided by GitHub
- ✅ No secrets or tokens need to be configured manually
- ✅ Workflows only have write access to releases (not code)
- ✅ All actions use specific versions (e.g., `@v4`) for security

---

For more information about GitHub Actions, visit: https://docs.github.com/en/actions
