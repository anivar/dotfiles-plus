#!/usr/bin/env bash
# Update Homebrew formula SHA256 after a release
# Usage: ./scripts/update-homebrew-sha.sh <version-tag>
# Example: ./scripts/update-homebrew-sha.sh v2.0.2

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the version tag from command line argument
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No version tag provided${NC}"
    echo "Usage: $0 <version-tag>"
    echo "Example: $0 v2.0.2"
    exit 1
fi

VERSION_TAG="$1"

# Validate version tag format
if ! [[ "$VERSION_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version tag format${NC}"
    echo "Please use format: v2.0.2"
    exit 1
fi

echo -e "${BLUE}🔄 Updating Homebrew formula SHA256 for ${GREEN}${VERSION_TAG}${NC}"
echo ""

# Construct the download URL
DOWNLOAD_URL="https://github.com/anivar/dotfiles-plus/archive/refs/tags/${VERSION_TAG}.tar.gz"
echo -e "Download URL: ${YELLOW}${DOWNLOAD_URL}${NC}"

# Download the tarball and calculate SHA256
echo -e "${BLUE}Downloading release tarball...${NC}"
TEMP_FILE=$(mktemp)
trap "rm -f $TEMP_FILE" EXIT

if ! curl -sL "$DOWNLOAD_URL" -o "$TEMP_FILE"; then
    echo -e "${RED}Error: Failed to download release tarball${NC}"
    echo "Make sure the release tag exists on GitHub"
    exit 1
fi

# Calculate SHA256
SHA256=$(shasum -a 256 "$TEMP_FILE" | awk '{print $1}')
echo -e "${GREEN}SHA256: ${SHA256}${NC}"

# Update the formula
if [ -f homebrew/dotfiles-plus.rb ]; then
    # Update SHA256
    sed -i.bak "s/sha256 \"[^\"]*\"/sha256 \"$SHA256\"/" homebrew/dotfiles-plus.rb && rm homebrew/dotfiles-plus.rb.bak
    echo -e "${GREEN}✅ Updated SHA256 in homebrew/dotfiles-plus.rb${NC}"
    
    # Also update version and URL
    VERSION_NUM="${VERSION_TAG#v}"
    sed -i.bak "s/version \"[^\"]*\"/version \"$VERSION_NUM\"/" homebrew/dotfiles-plus.rb && rm homebrew/dotfiles-plus.rb.bak
    sed -i.bak "s|/v[0-9]\+\.[0-9]\+\.[0-9]\+\.tar\.gz|/${VERSION_TAG}.tar.gz|" homebrew/dotfiles-plus.rb && rm homebrew/dotfiles-plus.rb.bak
    
    # Show the changes
    echo ""
    echo -e "${BLUE}Changes made:${NC}"
    git diff homebrew/dotfiles-plus.rb
    
    # Commit the change
    git add homebrew/dotfiles-plus.rb
    git commit -m "chore: update Homebrew formula for ${VERSION_TAG}" || echo "No changes to commit"
    echo ""
    echo -e "${GREEN}✅ Updated Homebrew formula${NC}"
else
    echo -e "${RED}Error: homebrew/dotfiles-plus.rb not found${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✨ Homebrew formula updated!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Push the main branch:"
echo -e "   ${YELLOW}git push origin main${NC}"
echo ""
echo "2. Test installation:"
echo -e "   ${YELLOW}brew install --HEAD https://raw.githubusercontent.com/anivar/dotfiles-plus/main/homebrew/dotfiles-plus.rb${NC}"