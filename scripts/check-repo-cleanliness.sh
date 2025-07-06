#!/usr/bin/env bash
# Check repository for files that shouldn't be committed
# This helps ensure end users get a clean installation

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Checking repository cleanliness...${NC}"
echo ""

ISSUES_FOUND=false

# Check for files that should be in .gitignore
echo "Checking for development files..."
DEV_FILES=(
    "SESSION_SUMMARY.md"
    "TODO_REMAINING.md"
    "SETUP_GUIDE.md"
    "HOMEBREW_SUBMISSION.md"
    "TODO.md"
    "NOTES.md"
    ".ai-memory.local"
    ".env"
    ".env.local"
)

for file in "${DEV_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${RED}❌ Found development file: $file${NC}"
        ISSUES_FOUND=true
    fi
done

# Check for editor files
echo "Checking for editor files..."
if find . -name "*.swp" -o -name "*.swo" -o -name "*~" | grep -q .; then
    echo -e "${RED}❌ Found editor temporary files${NC}"
    find . -name "*.swp" -o -name "*.swo" -o -name "*~" -print
    ISSUES_FOUND=true
fi

# Check for OS files
echo "Checking for OS-specific files..."
if find . -name ".DS_Store" -o -name "Thumbs.db" | grep -q .; then
    echo -e "${RED}❌ Found OS-specific files${NC}"
    find . -name ".DS_Store" -o -name "Thumbs.db" -print
    ISSUES_FOUND=true
fi

# Check for large files
echo "Checking for large files..."
LARGE_FILES=$(find . -type f -size +1M ! -path "./.git/*" 2>/dev/null)
if [ -n "$LARGE_FILES" ]; then
    echo -e "${YELLOW}⚠️  Found large files (>1MB):${NC}"
    echo "$LARGE_FILES" | while read -r file; do
        size=$(ls -lh "$file" | awk '{print $5}')
        echo "   $file ($size)"
    done
fi

# Check for sensitive patterns
echo "Checking for sensitive information..."
SENSITIVE_PATTERNS=(
    "api_key"
    "API_KEY"
    "secret"
    "SECRET"
    "password"
    "PASSWORD"
    "token"
    "TOKEN"
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    # Exclude this script and .gitignore from the check
    if git grep -i "$pattern" -- ':!scripts/check-repo-cleanliness.sh' ':!.gitignore' ':!*.md' 2>/dev/null | grep -v "secret set" | grep -v "secrets management" | grep -q .; then
        echo -e "${YELLOW}⚠️  Found potential sensitive pattern: $pattern${NC}"
        echo "   Review these matches:"
        git grep -i "$pattern" -- ':!scripts/check-repo-cleanliness.sh' ':!.gitignore' ':!*.md' | grep -v "secret set" | grep -v "secrets management" | head -5
    fi
done

# Summary
echo ""
if [ "$ISSUES_FOUND" = true ]; then
    echo -e "${RED}❌ Repository has cleanliness issues${NC}"
    echo "Please clean up before creating a release."
    exit 1
else
    echo -e "${GREEN}✅ Repository is clean!${NC}"
    echo ""
    echo "All checks passed:"
    echo "  ✓ No development files"
    echo "  ✓ No editor temporary files"
    echo "  ✓ No OS-specific files"
    echo "  ✓ No obvious sensitive information"
fi

# Additional info
echo ""
echo -e "${BLUE}📊 Repository Statistics:${NC}"
echo "  Total files: $(find . -type f ! -path "./.git/*" | wc -l)"
echo "  Shell scripts: $(find . -name "*.sh" ! -path "./.git/*" | wc -l)"
echo "  Documentation: $(find . -name "*.md" ! -path "./.git/*" | wc -l)"
echo "  Directories: $(find . -type d ! -path "./.git/*" | wc -l)"