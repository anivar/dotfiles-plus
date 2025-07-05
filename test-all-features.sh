#!/usr/bin/env bash
# Comprehensive test script for Dotfiles Plus
# Tests all features to ensure nothing is broken

set -e

echo "🧪 Dotfiles Plus Feature Test Suite"
echo "==================================="
echo ""

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
test_feature() {
    local name="$1"
    local cmd="$2"
    local expected="${3:-}"
    
    echo -n "Testing $name... "
    
    if eval "$cmd" >/dev/null 2>&1; then
        echo "✅ PASS"
        ((TESTS_PASSED++))
    else
        echo "❌ FAIL"
        ((TESTS_FAILED++))
        echo "  Command: $cmd"
    fi
}

# Source dotfiles
echo "Loading Dotfiles Plus..."
source ./dotfiles.sh || { echo "Failed to load dotfiles.sh"; exit 1; }

echo ""
echo "📦 Core System Tests"
echo "━━━━━━━━━━━━━━━━━━"

# Core commands
test_feature "Help system" "dotfiles help"
test_feature "Version info" "dotfiles version"  
test_feature "Status check" "dotfiles status"
test_feature "Configuration" "dotfiles config"

echo ""
echo "🤖 AI Feature Tests"
echo "━━━━━━━━━━━━━━━━━"

# AI memory
test_feature "AI help" "ai help"
test_feature "AI remember" "ai remember 'test memory'"
test_feature "AI recall" "ai recall"
test_feature "AI stats" "ai stats"
test_feature "AI forget" "ai forget"

# Advanced AI
test_feature "AI template list" "ai template list"
test_feature "AI freeze" "ai freeze test_freeze"
test_feature "AI freezelist" "ai freezelist"
test_feature "AI thaw" "ai thaw test_freeze"

# AI commands (just check they exist)
test_feature "aig command" "command_exists aig"
test_feature "aif command" "command_exists aif"
test_feature "ais command" "command_exists ais"
test_feature "aih command" "command_exists aih"

echo ""
echo "🔒 Security Tests"
echo "━━━━━━━━━━━━━━━"

# Security features
test_feature "Secret list" "dotfiles secret list"
test_feature "Permission check" "dotfiles check-security"
test_feature "Password generation" "dotfiles generate-password 16"

echo ""
echo "📊 Performance Tests"
echo "━━━━━━━━━━━━━━━━━━"

# Performance features
test_feature "Cache stats" "dotfiles cache stats"
test_feature "Profile command" "dotfiles profile echo test"
test_feature "Jobs list" "dotfiles jobs list"

echo ""
echo "🔧 Plugin System Tests"
echo "━━━━━━━━━━━━━━━━━━━"

# Check plugins loaded
for plugin in ai config git security performance; do
    if [[ -n "${DOTFILES_PLUGINS[$plugin]}" ]]; then
        echo "✅ Plugin loaded: $plugin"
        ((TESTS_PASSED++))
    else
        echo "❌ Plugin missing: $plugin"
        ((TESTS_FAILED++))
    fi
done

echo ""
echo "🎣 Hook System Tests"
echo "━━━━━━━━━━━━━━━━━━"

# Test hooks
test_feature "List hooks" "hook_list"
test_feature "Run test hook" "hook_run test_event"

echo ""
echo "🌿 Git Enhancement Tests"
echo "━━━━━━━━━━━━━━━━━━━━━"

# Git commands (if in git repo)
if git rev-parse --git-dir >/dev/null 2>&1; then
    test_feature "Git status (gst)" "command_exists gst"
    test_feature "Git commit (gc)" "command_exists gc"
    test_feature "Git log (gl)" "command_exists gl"
else
    echo "⚠️  Not in git repo, skipping git tests"
fi

echo ""
echo "📝 File System Tests"
echo "━━━━━━━━━━━━━━━━━"

# Check directories created
for dir in state cache logs plugins config templates; do
    if [[ -d "$DOTFILES_HOME/$dir" ]]; then
        echo "✅ Directory exists: $dir"
        ((TESTS_PASSED++))
    else
        echo "❌ Directory missing: $dir"
        ((TESTS_FAILED++))
    fi
done

echo ""
echo "🔍 Feature Detection Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━"

# Test AI provider detection
test_feature "AI provider detection" "ai_detect_provider"

# Test project type detection
if declare -f detect_project_type >/dev/null; then
    test_feature "Project type detection" "detect_project_type"
fi

echo ""
echo "📊 Test Summary"
echo "━━━━━━━━━━━━━"
echo "✅ Passed: $TESTS_PASSED"
echo "❌ Failed: $TESTS_FAILED"
echo ""

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo "🎉 All tests passed!"
    exit 0
else
    echo "⚠️  Some tests failed. Please check the output above."
    exit 1
fi