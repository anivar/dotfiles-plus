# 🛠️ Scripts Directory

This directory contains maintenance and release automation scripts for Dotfiles Plus.

## 🚀 Release Automation

We use a combination of GitHub Actions and optional local hooks for release management:

### GitHub Actions (Primary)

1. **Release Workflow** (`.github/workflows/release.yml`)
   - Triggered manually via GitHub UI
   - Updates version numbers across all branches
   - Creates a PR with all changes
   - Ensures consistency before release

2. **Homebrew Update** (`.github/workflows/update-homebrew.yml`)
   - Automatically triggered when a release is published
   - Updates SHA256 in homebrew formula
   - No manual intervention needed

### Local Scripts

1. **Version Update** (`update-version.sh`)
   ```bash
   ./scripts/update-version.sh 2.0.3
   ```
   - Updates version in all files
   - Handles multiple branches (main, gh-pages, homebrew-tap)
   - Creates CHANGELOG template

2. **Homebrew SHA Update** (`update-homebrew-sha.sh`)
   ```bash
   ./scripts/update-homebrew-sha.sh v2.0.3
   ```
   - Downloads release tarball
   - Calculates SHA256
   - Updates homebrew formula

3. **Release Checklist** (`release-checklist.sh`)
   ```bash
   ./scripts/release-checklist.sh
   ```
   - Interactive release guide
   - Pre-flight checks
   - Step-by-step instructions

### Optional Git Hooks

For developers who want extra safety checks:

```bash
./scripts/install-hooks.sh
```

**Features:**
- **Non-blocking**: Only provides warnings, never blocks commits
- **Configurable**: Enable/disable specific checks via environment variables
- **Helpful**: Suggests fixes for common issues

**Hooks installed:**
- `pre-commit`: Warns about version inconsistencies and debug statements
- `commit-msg`: Suggests conventional commit format

**Configuration:**
```bash
# Skip all hooks
export SKIP_HOOKS=1

# Enable specific features
export RUN_TESTS_ON_COMMIT=1           # Run tests before commit
export ENFORCE_CONVENTIONAL_COMMITS=1  # Enforce commit format

# Hide suggestions
export HIDE_COMMIT_SUGGESTIONS=1
```

## 📋 Release Process

### Automated (Recommended)

1. Go to GitHub Actions → Release Automation
2. Click "Run workflow"
3. Enter version number (e.g., 2.0.3)
4. Select release type (patch/minor/major)
5. Review and merge the created PR
6. Create and push tag
7. Homebrew formula updates automatically

### Manual (If Needed)

1. **Update versions:**
   ```bash
   ./scripts/update-version.sh 2.0.3
   ```

2. **Update CHANGELOG.md**

3. **Commit changes:**
   ```bash
   git add -A
   git commit -m "chore: bump version to v2.0.3"
   ```

4. **Create tag:**
   ```bash
   git tag -a v2.0.3 -m "Release v2.0.3"
   git push origin main
   git push origin v2.0.3
   ```

5. **Create GitHub release**

6. **Update Homebrew (if automation fails):**
   ```bash
   ./scripts/update-homebrew-sha.sh v2.0.3
   git push origin homebrew-tap
   ```

## 🔒 Safety Features

1. **Version Consistency**: Scripts ensure version numbers match across all files
2. **Branch Safety**: Scripts stash changes and restore state
3. **Non-Blocking Hooks**: Local hooks never prevent commits
4. **GitHub Actions**: Critical checks run in CI, not locally
5. **Manual Override**: All automation can be bypassed if needed

## 📝 Best Practices

1. **Use GitHub Actions** for releases when possible
2. **Install hooks** if you're a frequent contributor
3. **Run release checklist** before major releases
4. **Keep scripts updated** when adding new version references
5. **Test locally** before pushing to main

## 🆘 Troubleshooting

**Hook Issues:**
```bash
# Disable hooks temporarily
SKIP_HOOKS=1 git commit -m "emergency fix"

# Remove hooks
rm .git/hooks/pre-commit .git/hooks/commit-msg
```

**Version Mismatch:**
```bash
# Fix all versions at once
./scripts/update-version.sh $(cat VERSION)
```

**Failed Release:**
```bash
# Run checklist to diagnose
./scripts/release-checklist.sh
```