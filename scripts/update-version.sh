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

# Files to update
declare -A VERSION_FILES=(
    ["VERSION"]="^.*$"
    ["dotfiles-plus.sh"]='export DOTFILES_PLUS_VERSION="[^"]*"'
    ["plugins/config.plugin.sh"]='echo "Dotfiles Plus v[^"]*"'
)

# Update VERSION file
echo -e "${BLUE}Updating version in files...${NC}"
echo "$NEW_VERSION" > VERSION
echo -e "  ✅ VERSION"

# Update dotfiles-plus.sh
sed -i.bak "s/export DOTFILES_PLUS_VERSION=\"[^\"]*\"/export DOTFILES_PLUS_VERSION=\"$NEW_VERSION\"/" dotfiles-plus.sh && rm dotfiles-plus.sh.bak
echo -e "  ✅ dotfiles-plus.sh"

# Update config.plugin.sh if it has version display
if grep -q 'echo "Dotfiles Plus v' plugins/config.plugin.sh 2>/dev/null; then
    sed -i.bak "s/echo \"Dotfiles Plus v[^\"]*\"/echo \"Dotfiles Plus v$NEW_VERSION\"/" plugins/config.plugin.sh && rm plugins/config.plugin.sh.bak
    echo -e "  ✅ plugins/config.plugin.sh"
fi

# Update CLAUDE.md
if grep -q "# Claude AI Context - Dotfiles Plus v" CLAUDE.md 2>/dev/null; then
    sed -i.bak "s/# Claude AI Context - Dotfiles Plus v.*/# Claude AI Context - Dotfiles Plus v$NEW_VERSION/" CLAUDE.md && rm CLAUDE.md.bak
    echo -e "  ✅ CLAUDE.md (header)"
fi

if grep -q "Version [0-9]\+\.[0-9]\+\.[0-9]\+" CLAUDE.md 2>/dev/null; then
    sed -i.bak "s/Version [0-9]\+\.[0-9]\+\.[0-9]\+/Version $NEW_VERSION/" CLAUDE.md && rm CLAUDE.md.bak
    echo -e "  ✅ CLAUDE.md (version references)"
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

# Update Homebrew formula on homebrew-tap branch if it exists
if git show-ref --verify --quiet refs/heads/homebrew-tap; then
    echo ""
    echo -e "${BLUE}Updating Homebrew formula...${NC}"
    echo -e "${YELLOW}  ⚠️  Note: You'll need to update the SHA256 after creating the release${NC}"
    
    # Stash any current changes
    git stash push -m "Version update stash" --include-untracked --quiet || true
    
    # Switch to homebrew-tap branch
    git checkout homebrew-tap --quiet
    
    # Update version in formula
    if [ -f Formula/dotfiles-plus.rb ]; then
        sed -i.bak "s/version \"[^\"]*\"/version \"$NEW_VERSION\"/" Formula/dotfiles-plus.rb && rm Formula/dotfiles-plus.rb.bak
        sed -i.bak "s|/v[0-9]\+\.[0-9]\+\.[0-9]\+\.tar\.gz|/v$NEW_VERSION.tar.gz|" Formula/dotfiles-plus.rb && rm Formula/dotfiles-plus.rb.bak
        echo -e "  ✅ Formula/dotfiles-plus.rb (version and URL)"
        echo -e "  ❗ Remember to update SHA256 after release"
        
        # Commit the change
        git add Formula/dotfiles-plus.rb
        git commit -m "chore: update formula version to v$NEW_VERSION (SHA256 pending)" --quiet || true
    fi
    
    # Switch back to original branch
    git checkout - --quiet
    
    # Pop stash if it exists
    git stash pop --quiet 2>/dev/null || true
fi

echo ""
echo -e "${BLUE}Preparing CHANGELOG entry...${NC}"

# Check if version already exists in CHANGELOG
if grep -q "## \[$NEW_VERSION\]" CHANGELOG.md 2>/dev/null; then
    echo -e "  ℹ️  Version $NEW_VERSION already exists in CHANGELOG.md"
else
    # Get today's date
    TODAY=$(date +%Y-%m-%d)
    
    # Create a new changelog entry template
    cat > /tmp/changelog_entry.tmp << EOF
## [$NEW_VERSION] - $TODAY

### Added
- 

### Changed
- 

### Fixed
- 

### Removed
- 

EOF
    
    # Insert the new entry after the header section
    awk '/^## \[/ && !found {print "'"$(cat /tmp/changelog_entry.tmp)"'"; found=1} 1' CHANGELOG.md > CHANGELOG.md.tmp
    mv CHANGELOG.md.tmp CHANGELOG.md
    rm /tmp/changelog_entry.tmp
    
    echo -e "  ✅ Added template for version $NEW_VERSION in CHANGELOG.md"
    echo -e "  ${YELLOW}📝 Please update the CHANGELOG with your changes${NC}"
fi

echo ""
echo -e "${GREEN}✨ Version update complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Review and test the changes"
echo "2. Update CHANGELOG.md with actual changes"
echo "3. Commit the version updates:"
echo -e "   ${YELLOW}git add -A${NC}"
echo -e "   ${YELLOW}git commit -m \"chore: bump version to v$NEW_VERSION\"${NC}"
echo "4. Create and push the tag:"
echo -e "   ${YELLOW}git tag -a v$NEW_VERSION -m \"Release v$NEW_VERSION\"${NC}"
echo -e "   ${YELLOW}git push origin main${NC}"
echo -e "   ${YELLOW}git push origin v$NEW_VERSION${NC}"
echo "5. After release, update Homebrew formula SHA256:"
echo -e "   ${YELLOW}./scripts/update-homebrew-sha.sh v$NEW_VERSION${NC}"