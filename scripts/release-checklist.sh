#!/usr/bin/env bash
# Release checklist for Dotfiles Plus
# Usage: ./scripts/release-checklist.sh

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}                        🚀 Dotfiles Plus Release Checklist${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Function to check if command succeeded
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
        return 0
    else
        echo -e "${RED}❌ $1${NC}"
        return 1
    fi
}

# Function to prompt for confirmation
confirm() {
    read -p "$1 (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Get current version
CURRENT_VERSION=$(cat VERSION 2>/dev/null || echo "unknown")
echo -e "${BLUE}Current version:${NC} ${YELLOW}${CURRENT_VERSION}${NC}"
echo ""

echo -e "${BLUE}📋 Pre-release Checklist:${NC}"
echo ""

# 1. Check git status
echo -e "${YELLOW}1. Checking git status...${NC}"
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${RED}   ❌ Working directory has uncommitted changes${NC}"
    git status --short
    echo -e "${YELLOW}   Please commit or stash changes before release${NC}"
else
    echo -e "${GREEN}   ✅ Working directory is clean${NC}"
fi

# 2. Check current branch
echo -e "${YELLOW}2. Checking current branch...${NC}"
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}   ❌ Not on main branch (currently on: $CURRENT_BRANCH)${NC}"
    echo -e "${YELLOW}   Please switch to main branch for release${NC}"
else
    echo -e "${GREEN}   ✅ On main branch${NC}"
fi

# 3. Check if up to date with remote
echo -e "${YELLOW}3. Checking if up to date with remote...${NC}"
git fetch origin main --quiet
LOCAL_HASH=$(git rev-parse HEAD)
REMOTE_HASH=$(git rev-parse origin/main)
if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
    echo -e "${RED}   ❌ Local branch differs from remote${NC}"
    echo -e "${YELLOW}   Please pull latest changes or push local commits${NC}"
else
    echo -e "${GREEN}   ✅ Up to date with remote${NC}"
fi

# 4. Run tests
echo -e "${YELLOW}4. Running tests...${NC}"
if [ -f "./test.sh" ]; then
    if ./test.sh > /dev/null 2>&1; then
        echo -e "${GREEN}   ✅ All tests passed${NC}"
    else
        echo -e "${RED}   ❌ Tests failed${NC}"
        echo -e "${YELLOW}   Please fix failing tests before release${NC}"
    fi
else
    echo -e "${YELLOW}   ⚠️  No test script found${NC}"
fi

# 5. Check version consistency
echo -e "${YELLOW}5. Checking version consistency...${NC}"
VERSION_FILE=$(cat VERSION)
VERSION_DOTFILES=$(grep 'DOTFILES_PLUS_VERSION=' dotfiles-plus.sh | cut -d'"' -f2)
ISSUES_FOUND=false

if [ "$VERSION_FILE" != "$VERSION_DOTFILES" ]; then
    echo -e "${RED}   ❌ Version mismatch:${NC}"
    echo -e "      VERSION file: $VERSION_FILE"
    echo -e "      dotfiles-plus.sh: $VERSION_DOTFILES"
    ISSUES_FOUND=true
fi

# Check CLAUDE.md header
CLAUDE_VERSION=$(grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+" CLAUDE.md | head -1 | sed 's/^v//')
if [ "$VERSION_FILE" != "$CLAUDE_VERSION" ]; then
    echo -e "${RED}   ❌ CLAUDE.md version mismatch: v$CLAUDE_VERSION${NC}"
    ISSUES_FOUND=true
fi

if [ "$ISSUES_FOUND" = false ]; then
    echo -e "${GREEN}   ✅ All version numbers are consistent${NC}"
fi

# 6. Check CHANGELOG
echo -e "${YELLOW}6. Checking CHANGELOG...${NC}"
if grep -q "## \[${VERSION_FILE}\]" CHANGELOG.md; then
    echo -e "${GREEN}   ✅ CHANGELOG entry exists for v${VERSION_FILE}${NC}"
else
    echo -e "${YELLOW}   ⚠️  No CHANGELOG entry for v${VERSION_FILE}${NC}"
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Ask if ready to proceed
if ! confirm "Ready to create a new release?"; then
    echo -e "${YELLOW}Release cancelled${NC}"
    exit 0
fi

# Get new version
echo ""
read -p "Enter new version number (current: $CURRENT_VERSION): " NEW_VERSION

if [ -z "$NEW_VERSION" ]; then
    echo -e "${RED}No version provided${NC}"
    exit 1
fi

# Validate version format
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Invalid version format. Please use semantic versioning (e.g., 2.0.2)${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}📝 Release Steps:${NC}"
echo ""
echo "1. Update version numbers:"
echo -e "   ${YELLOW}./scripts/update-version.sh $NEW_VERSION${NC}"
echo ""
echo "2. Update CHANGELOG.md with release notes"
echo ""
echo "3. Commit version changes:"
echo -e "   ${YELLOW}git add -A${NC}"
echo -e "   ${YELLOW}git commit -m \"chore: bump version to v$NEW_VERSION\"${NC}"
echo ""
echo "4. Create and push tag:"
echo -e "   ${YELLOW}git tag -a v$NEW_VERSION -m \"Release v$NEW_VERSION\"${NC}"
echo -e "   ${YELLOW}git push origin main${NC}"
echo -e "   ${YELLOW}git push origin v$NEW_VERSION${NC}"
echo ""
echo "5. Create GitHub release:"
echo "   - Go to https://github.com/anivar/dotfiles-plus/releases/new"
echo "   - Select tag v$NEW_VERSION"
echo "   - Copy CHANGELOG entries as release notes"
echo "   - Publish release"
echo ""
echo "6. Update Homebrew formula:"
echo -e "   ${YELLOW}./scripts/update-homebrew-sha.sh v$NEW_VERSION${NC}"
echo -e "   ${YELLOW}git push origin homebrew-tap${NC}"
echo ""
echo "7. Test installation:"
echo -e "   ${YELLOW}brew untap anivar/dotfiles-plus${NC}"
echo -e "   ${YELLOW}brew tap anivar/dotfiles-plus https://github.com/anivar/dotfiles-plus${NC}"
echo -e "   ${YELLOW}brew install dotfiles-plus${NC}"
echo ""
echo -e "${GREEN}🎉 Good luck with the release!${NC}"