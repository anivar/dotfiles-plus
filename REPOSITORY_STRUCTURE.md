# 📂 Repository Structure

This document explains what's included in the Dotfiles Plus repository and why.

## 🎯 What's Included

### Core Functionality (Required for End Users)
- `dotfiles-plus.sh` - Main entry point
- `install.sh` - Installation script
- `init.sh` - Project initialization
- `uninstall.sh` - Clean uninstallation
- `plugins/` - Core plugins (AI, Git, Config, Security, Performance)
- `lib/` - Core libraries
- `ai/`, `core/`, `system/` - System components

### Documentation (Helpful for All Users)
- `README.md` - Project overview
- `INSTALL.md` - Installation guide
- `COMMANDS.md` - Command reference
- `CONFIGURATION.md` - Configuration guide
- `FEATURES.md` - Feature documentation
- Other `*.md` files - Various guides

### Development Tools (For Contributors)
- `scripts/` - Release automation and maintenance scripts
  - Not needed for normal use
  - Helpful for contributors and maintainers
  - Includes version update and release tools
- `tests/` - Test suites
- `examples/` - Example configurations

## 🚫 What's Excluded (.gitignore)

### Runtime Data (Created During Use)
- `config/`, `contexts/`, `sessions/`, `memory/` - User data
- `*.log` - Log files
- `cache/`, `backups/` - Temporary data

### Development Files
- Session summaries (`SESSION_SUMMARY.md`, etc.)
- IDE configurations (`.vscode/`, `.idea/`)
- Editor temporary files (`*.swp`, `*~`)
- OS files (`.DS_Store`, `Thumbs.db`)

### Security
- API keys, secrets, credentials
- `.env` files
- Private configurations

## 💡 Why Include Development Scripts?

The `scripts/` directory contains tools for:
1. **Version management** - Ensures consistency across releases
2. **Release automation** - Streamlines the release process
3. **Repository maintenance** - Keeps the codebase clean

While end users don't need these for normal operation, they're included because:
- They help contributors maintain quality
- They document the release process
- They're small and don't impact installation
- They can be ignored by end users

## 📦 Clean Installation

When installed via:
- **Homebrew**: Only necessary files are installed
- **install.sh**: Script handles proper setup
- **Git clone**: You get everything (including dev tools)

End users can safely ignore:
- `scripts/` directory
- `tests/` directory  
- `*.md` files (except README for reference)

## 🔍 Verifying Cleanliness

Run this to check repository state:
```bash
./scripts/check-repo-cleanliness.sh
```

This ensures:
- No development artifacts
- No sensitive information
- No unnecessary files

## 📝 Summary

The repository includes everything needed for:
- ✅ End users to install and use Dotfiles Plus
- ✅ Contributors to develop and maintain it
- ✅ Maintainers to release new versions

Nothing included poses security risks or significantly increases download size.