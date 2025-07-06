#!/usr/bin/env bash
# Update version numbers across all files in Dotfiles Plus
# Usage: ./scripts/update-version.sh <new-version>
# Example: ./scripts/update-version.sh 2.0.2

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the new version from command line argument
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No version provided${NC}"
    echo "Usage: $0 <new-version>"
    echo "Example: $0 2.0.2"
    exit 1
fi

NEW_VERSION="$1"

# Validate version format (basic semver)
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version format${NC}"
    echo "Please use semantic versioning (e.g., 2.0.2)"
    exit 1
fi

echo -e "${BLUE}🔄 Updating Dotfiles Plus to version ${GREEN}${NEW_VERSION}${NC}"
echo ""

# Get current version from VERSION file
CURRENT_VERSION=$(cat VERSION 2>/dev/null || echo "unknown")
echo -e "Current version: ${YELLOW}${CURRENT_VERSION}${NC}"
echo -e "New version: ${GREEN}${NEW_VERSION}${NC}"
echo ""

# Update VERSION file
echo -e "${BLUE}Updating version in files...${NC}"
echo "$NEW_VERSION" > VERSION
echo -e "  ✅ VERSION"

# Update CLAUDE.md if it has version references
if grep -q "Version [0-9]\+\.[0-9]\+\.[0-9]\+" CLAUDE.md 2>/dev/null; then
    sed -i.bak "s/Version [0-9]\+\.[0-9]\+\.[0-9]\+/Version $NEW_VERSION/" CLAUDE.md && rm CLAUDE.md.bak
    echo -e "  ✅ CLAUDE.md"
fi

# Update _config.yml on gh-pages branch if it exists
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo ""
    echo -e "${BLUE}Updating GitHub Pages configuration...${NC}"
    
    # Stash any current changes
    git stash push -m "Version update stash" --include-untracked --quiet || true
    
    # Switch to gh-pages branch
    git checkout gh-pages --quiet
    
    # Update version references in _config.yml
    if [ -f _config.yml ]; then
        sed -i.bak "s/v[0-9]\+\.[0-9]\+\.[0-9]\+/v$NEW_VERSION/g" _config.yml && rm _config.yml.bak
        echo -e "  ✅ _config.yml"
        
        # Commit the change
        git add _config.yml
        git commit -m "chore: update version to v$NEW_VERSION in GitHub Pages config" --quiet || true
    fi
    
    # Switch back to original branch
    git checkout - --quiet
    
    # Pop stash if it exists
    git stash pop --quiet 2>/dev/null || true
fi

# Update homebrew-tap branch if it exists
if git show-ref --verify --quiet refs/heads/homebrew-tap; then
    echo ""
    echo -e "${BLUE}Updating Homebrew tap configuration...${NC}"
    
    # Stash any current changes
    git stash push -m "Version update stash for homebrew" --include-untracked --quiet || true
    
    # Switch to homebrew-tap branch
    git checkout homebrew-tap --quiet
    
    # Update Formula
    if [ -f Formula/dotfiles-plus.rb ]; then
        sed -i.bak "s/version \"[0-9]\+\.[0-9]\+\.[0-9]\+\"/version \"$NEW_VERSION\"/" Formula/dotfiles-plus.rb && rm Formula/dotfiles-plus.rb.bak
        echo -e "  ✅ Formula/dotfiles-plus.rb"
        
        # Note: SHA256 will be updated by the release process
        echo -e "  ℹ️  Note: SHA256 will be updated after release"
    fi
    
    # Switch back to original branch
    git checkout - --quiet
    
    # Pop stash if it exists
    git stash pop --quiet 2>/dev/null || true
fi

# Update CHANGELOG template
CHANGELOG_TEMPLATE="

## [$NEW_VERSION] - $(date +%Y-%m-%d)

### Added
- 

### Changed
- 

### Fixed
- "

if [ -f CHANGELOG.md ]; then
    # Check if this version already exists
    if ! grep -q "\[$NEW_VERSION\]" CHANGELOG.md; then
        echo ""
        echo -e "${BLUE}Adding version template to CHANGELOG.md...${NC}"
        
        # Create temp file with new entry after the header
        awk -v template="$CHANGELOG_TEMPLATE" '
            /^# Changelog/ { print; print template; next }
            { print }
        ' CHANGELOG.md > CHANGELOG.md.tmp
        
        mv CHANGELOG.md.tmp CHANGELOG.md
        echo -e "  ✅ CHANGELOG.md template added"
    fi
fi

echo ""
echo -e "${GREEN}✅ Version update complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Update CHANGELOG.md with actual changes"
echo "2. Commit changes: git add -A && git commit -m \"chore: bump version to v$NEW_VERSION\""
echo "3. Create tag: git tag -a v$NEW_VERSION -m \"Release v$NEW_VERSION\""
echo "4. Push: git push origin main --tags"