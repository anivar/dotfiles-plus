#!/usr/bin/env bash
# Install optional git hooks for Dotfiles Plus development
# This is optional - mainly for maintainers who want extra safety

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🪝 Installing Git Hooks for Dotfiles Plus${NC}"
echo ""

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/usr/bin/env bash
# Pre-commit hook for Dotfiles Plus
# Provides helpful warnings but won't block commits

# Don't use strict mode to avoid breaking git workflow
set +e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Allow disabling hooks via environment variable
if [ "${SKIP_HOOKS}" = "1" ] || [ "${SKIP_PRE_COMMIT}" = "1" ]; then
    exit 0
fi

echo -e "${BLUE}🪝 Running pre-commit checks...${NC}"

# Track if we found any issues (but don't fail)
FOUND_ISSUES=false

# Check if we're committing version-related files
if git diff --cached --name-only | grep -qE "(VERSION|CHANGELOG\.md|dotfiles-plus\.sh|CLAUDE\.md)" 2>/dev/null; then
    # Get version from VERSION file
    if [ -f VERSION ]; then
        VERSION_FILE=$(cat VERSION 2>/dev/null || echo "unknown")
        VERSION_DOTFILES=$(grep 'DOTFILES_PLUS_VERSION=' dotfiles-plus.sh 2>/dev/null | cut -d'"' -f2 || echo "not found")
        
        if [ "$VERSION_FILE" != "$VERSION_DOTFILES" ] && [ "$VERSION_DOTFILES" != "not found" ]; then
            echo -e "${YELLOW}⚠️  Version inconsistency detected:${NC}"
            echo "   VERSION file: $VERSION_FILE"
            echo "   dotfiles-plus.sh: $VERSION_DOTFILES"
            echo ""
            echo -e "${YELLOW}   Suggestion: ./scripts/update-version.sh $VERSION_FILE${NC}"
            echo -e "${YELLOW}   To bypass: git commit --no-verify${NC}"
            FOUND_ISSUES=true
        fi
    fi
fi

# Only run tests if explicitly enabled
if [ "${RUN_TESTS_ON_COMMIT}" = "1" ]; then
    if git diff --cached --name-only | grep -qE "\.(sh|bash)$" 2>/dev/null; then
        echo -e "${YELLOW}🧪 Running quick tests...${NC}"
        
        if [ -f ./test.sh ] && [ -x ./test.sh ]; then
            if ./test.sh --quick > /dev/null 2>&1; then
                echo -e "${GREEN}✅ Tests passed${NC}"
            else
                echo -e "${YELLOW}⚠️  Some tests failed${NC}"
                echo -e "${YELLOW}   Run: ./test.sh --verbose for details${NC}"
                FOUND_ISSUES=true
            fi
        fi
    fi
fi

# Check for common issues (warnings only)
if command -v grep >/dev/null 2>&1; then
    # Check for debugging statements
    DEBUG_FOUND=$(git diff --cached 2>/dev/null | grep -E "^\+.*\b(console\.log|echo.*DEBUG|set -x)\b" | grep -v "^+#" | head -5)
    if [ -n "$DEBUG_FOUND" ]; then
        echo -e "${YELLOW}📝 Found possible debug statements:${NC}"
        echo "$DEBUG_FOUND" | head -3
        echo -e "${YELLOW}   (Review if intentional)${NC}"
    fi
fi

if [ "$FOUND_ISSUES" = true ]; then
    echo ""
    echo -e "${YELLOW}Some issues were found but commit will proceed.${NC}"
    echo -e "${YELLOW}To skip these checks: SKIP_HOOKS=1 git commit${NC}"
else
    echo -e "${GREEN}✅ All checks passed${NC}"
fi

# Always exit 0 to not block commits
exit 0
EOF

# Create commit-msg hook
cat > .git/hooks/commit-msg << 'EOF'
#!/usr/bin/env bash
# Commit message hook for Dotfiles Plus
# Suggests conventional format but won't block commits

# Don't use strict mode to avoid breaking git workflow
set +e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Allow disabling hooks via environment variable
if [ "${SKIP_HOOKS}" = "1" ] || [ "${SKIP_COMMIT_MSG}" = "1" ]; then
    exit 0
fi

# Only enforce if explicitly enabled
if [ "${ENFORCE_CONVENTIONAL_COMMITS}" != "1" ]; then
    # Just provide a gentle reminder
    if [ "${HIDE_COMMIT_SUGGESTIONS}" != "1" ]; then
        echo -e "${BLUE}💡 Tip: Consider using conventional commits (feat/fix/docs/etc.)${NC}"
    fi
    exit 0
fi

commit_regex='^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?: .{1,100}$'
merge_regex='^Merge '
revert_regex='^Revert '

# Read commit message
commit_msg=$(cat "$1" 2>/dev/null || echo "")

# Skip merge and revert commits
if [[ "$commit_msg" =~ $merge_regex ]] || [[ "$commit_msg" =~ $revert_regex ]]; then
    exit 0
fi

# Check commit message format
if ! [[ "$commit_msg" =~ $commit_regex ]]; then
    echo -e "${YELLOW}📝 Commit message doesn't follow conventional format${NC}"
    echo ""
    echo "Suggested format:"
    echo "  <type>(<scope>): <subject>"
    echo ""
    echo "Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert"
    echo ""
    echo "Examples:"
    echo "  feat(ai): add support for Claude 3.5"
    echo "  fix(install): correct bash version check"
    echo "  docs: update installation instructions"
    echo ""
    echo -e "${YELLOW}Your message:${NC} $commit_msg"
    echo ""
    echo -e "${YELLOW}To enforce this: export ENFORCE_CONVENTIONAL_COMMITS=1${NC}"
    echo -e "${YELLOW}To hide hints: export HIDE_COMMIT_SUGGESTIONS=1${NC}"
else
    if [ "${HIDE_COMMIT_SUGGESTIONS}" != "1" ]; then
        echo -e "${GREEN}✅ Good commit message format!${NC}"
    fi
fi

# Always exit 0 to not block commits
exit 0
EOF

# Make hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/commit-msg

echo -e "${GREEN}✅ Git hooks installed successfully!${NC}"
echo ""
echo "Installed hooks (non-blocking by default):"
echo "  - pre-commit: Warns about version inconsistencies and debug statements"
echo "  - commit-msg: Suggests conventional commit format"
echo ""
echo -e "${BLUE}🎛️  Configuration Options:${NC}"
echo "  export SKIP_HOOKS=1                    # Skip all hooks"
echo "  export SKIP_PRE_COMMIT=1               # Skip pre-commit only"
echo "  export SKIP_COMMIT_MSG=1               # Skip commit-msg only"
echo "  export RUN_TESTS_ON_COMMIT=1           # Enable test running"
echo "  export ENFORCE_CONVENTIONAL_COMMITS=1  # Enforce commit format"
echo "  export HIDE_COMMIT_SUGGESTIONS=1       # Hide commit tips"
echo ""
echo -e "${YELLOW}📝 Notes:${NC}"
echo "  - Hooks provide suggestions but won't block commits"
echo "  - Use 'git commit --no-verify' to bypass all hooks"
echo "  - GitHub Actions handle the critical checks"
echo ""
echo -e "${GREEN}These hooks are designed to help, not hinder your workflow!${NC}"