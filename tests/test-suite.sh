#!/usr/bin/env bash
# 🧪 Secure Dotfiles Test Suite
# Comprehensive testing for all security fixes and features

# ============================================================================
# TEST FRAMEWORK
# ============================================================================

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Test assertion functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    ((TESTS_RUN++))
    
    if [[ "$expected" == "$actual" ]]; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $test_name"
        echo "   Expected: '$expected'"
        echo "   Actual:   '$actual'"
        ((TESTS_FAILED++))
    fi
}

assert_success() {
    local exit_code="$1"
    local test_name="$2"
    
    ((TESTS_RUN++))
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $test_name (exit code: $exit_code)"
        ((TESTS_FAILED++))
    fi
}

assert_failure() {
    local exit_code="$1"
    local test_name="$2"
    
    ((TESTS_RUN++))
    
    if [[ $exit_code -ne 0 ]]; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $test_name (should have failed but didn't)"
        ((TESTS_FAILED++))
    fi
}

# ============================================================================
# SETUP
# ============================================================================

setup_test_environment() {
    echo "🔧 Setting up test environment..."
    
    # Source the secure dotfiles system
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$script_dir/secure-dotfiles.sh"
    
    # Create test directories
    TEST_HOME="/tmp/dotfiles-test-$$"
    mkdir -p "$TEST_HOME"
    
    # Override configuration for testing
    DOTFILES_CONFIG["home"]="$TEST_HOME"
    
    echo "✅ Test environment ready"
}

cleanup_test_environment() {
    echo "🧹 Cleaning up test environment..."
    rm -rf "$TEST_HOME"
    echo "✅ Cleanup complete"
}

# ============================================================================
# SECURITY TESTS
# ============================================================================

test_input_sanitization() {
    echo ""
    echo "🔒 Testing Input Sanitization..."
    
    # Test basic sanitization
    local result
    result=$(_secure_sanitize_input "hello world" "true")
    assert_equals "hello world" "$result" "Basic input with spaces allowed"
    
    result=$(_secure_sanitize_input "hello;world")
    assert_equals "helloworld" "$result" "Dangerous characters removed"
    
    result=$(_secure_sanitize_input "test\$(rm -rf /)")
    assert_equals "test" "$result" "Command injection attempt blocked"
    
    result=$(_secure_sanitize_input "normal_input-123.txt")
    assert_equals "normal_input-123.txt" "$result" "Valid characters preserved"
    
    # Test input validation
    _secure_validate_input "valid_name" "^[a-zA-Z0-9_-]+$" >/dev/null
    assert_success $? "Valid input passes validation"
    
    _secure_validate_input "invalid;name" "^[a-zA-Z0-9_-]+$" >/dev/null 2>&1
    assert_failure $? "Invalid input fails validation"
}

test_secure_command_execution() {
    echo ""
    echo "🔒 Testing Secure Command Execution..."
    
    # Test safe command execution
    _secure_execute_command "echo" "hello" >/dev/null
    assert_success $? "Valid command executes successfully"
    
    _secure_execute_command "nonexistent_command" >/dev/null 2>&1
    assert_failure $? "Nonexistent command fails safely"
    
    # Test AI provider execution
    # Note: This tests the function without actual AI providers
    _secure_ai_execute "claude" "test query" >/dev/null 2>&1
    local exit_code=$?
    echo -e "${YELLOW}ℹ️  INFO${NC}: AI execution test (exit code: $exit_code) - provider may not be available"
}

test_lazy_loading_security() {
    echo ""
    echo "🔒 Testing Secure Lazy Loading..."
    
    # Register a test module
    test_load_function() {
        echo "Test module loaded"
    }
    
    _secure_register_module "test_module" "test_load_function"
    assert_success $? "Module registration succeeds"
    
    # Test secure loading
    result=$(_secure_lazy_load "test_module" 2>/dev/null)
    assert_success $? "Secure lazy loading works"
    
    # Test invalid module name
    _secure_lazy_load "invalid;module" >/dev/null 2>&1
    assert_failure $? "Invalid module name rejected"
}

# ============================================================================
# CONFIGURATION TESTS
# ============================================================================

test_configuration_system() {
    echo ""
    echo "⚙️ Testing Configuration System..."
    
    # Test basic configuration
    _config_set "test_key" "test_value"
    local result
    result=$(_config_get "test_key")
    assert_equals "test_value" "$result" "Configuration get/set works"
    
    # Test default values
    result=$(_config_get "nonexistent_key" "default_value")
    assert_equals "default_value" "$result" "Default values work"
    
    # Test configuration validation
    _config_validate >/dev/null 2>&1
    assert_success $? "Configuration validation passes"
}

test_ai_provider_config() {
    echo ""
    echo "🤖 Testing AI Provider Configuration..."
    
    # Initialize AI providers
    _config_init_ai_providers
    
    # Test provider detection (may not find any, which is okay)
    _config_get_ai_provider >/dev/null 2>&1
    local exit_code=$?
    echo -e "${YELLOW}ℹ️  INFO${NC}: AI provider detection test (exit code: $exit_code) - no providers may be available"
}

# ============================================================================
# PERFORMANCE TESTS
# ============================================================================

test_performance_caching() {
    echo ""
    echo "⚡ Testing Performance Caching..."
    
    # Test cache function
    test_cached_function() {
        echo "cached_result"
    }
    
    # First call should execute function
    local result
    result=$(_perf_cache_get_or_set "test_cache" 300 "test_cached_function")
    assert_equals "cached_result" "$result" "Cache function execution works"
    
    # Second call should use cache
    result=$(_perf_cache_get_or_set "test_cache" 300 "test_cached_function")
    assert_equals "cached_result" "$result" "Cache retrieval works"
    
    # Test cache cleanup
    _perf_cache_cleanup 0  # Force cleanup with 0 TTL
    assert_success $? "Cache cleanup works"
}

test_performance_optimization() {
    echo ""
    echo "⚡ Testing Performance Optimization..."
    
    # Test git info batching
    local git_info
    git_info=$(_perf_git_info_batch)
    assert_success $? "Git info batch operation works"
    
    # Test file system info batching
    local fs_info
    fs_info=$(_perf_fs_info_batch)
    assert_success $? "File system info batch operation works"
}

# ============================================================================
# PROJECT MANAGEMENT TESTS
# ============================================================================

test_project_detection() {
    echo ""
    echo "📂 Testing Project Detection..."
    
    # Create a test Node.js project
    local test_project_dir="$TEST_HOME/test-project"
    mkdir -p "$test_project_dir"
    cd "$test_project_dir"
    echo '{"name": "test-project", "dependencies": {"react": "^18.0.0"}}' > package.json
    
    # Test project detection
    local detection_result
    detection_result=$(project_detect)
    IFS='|' read -r project_type confidence details <<< "$detection_result"
    
    assert_equals "nodejs" "$project_type" "Node.js project detected correctly"
    
    # Test project initialization
    project_init "test-project" >/dev/null
    assert_success $? "Project initialization works"
    
    # Clean up
    cd - >/dev/null
    rm -rf "$test_project_dir"
}

# ============================================================================
# AI FUNCTIONALITY TESTS
# ============================================================================

test_ai_memory_management() {
    echo ""
    echo "🧠 Testing AI Memory Management..."
    
    # Test remembering information
    ai_remember "Test information for session" >/dev/null
    assert_success $? "AI remember function works"
    
    # Test recalling information
    local recalled
    recalled=$(ai_recall 2>/dev/null)
    assert_success $? "AI recall function works"
    
    # Test forgetting information
    ai_forget >/dev/null
    assert_success $? "AI forget function works"
}

# ============================================================================
# INTEGRATION TESTS
# ============================================================================

test_full_system_integration() {
    echo ""
    echo "🔄 Testing Full System Integration..."
    
    # Test system status
    _dotfiles_status >/dev/null
    assert_success $? "System status works"
    
    # Test health check
    _dotfiles_health_check >/dev/null
    assert_success $? "Health check works"
    
    # Test version command
    _dotfiles_version >/dev/null
    assert_success $? "Version command works"
    
    # Test configuration commands
    config get version >/dev/null
    assert_success $? "Config get command works"
    
    config set test_integration_key test_value >/dev/null
    assert_success $? "Config set command works"
}

# ============================================================================
# MAIN TEST RUNNER
# ============================================================================

run_all_tests() {
    echo "🧪 Starting Secure Dotfiles Test Suite"
    echo "======================================"
    
    # Setup
    setup_test_environment
    
    # Run test suites
    test_input_sanitization
    test_secure_command_execution
    test_lazy_loading_security
    test_configuration_system
    test_ai_provider_config
    test_performance_caching
    test_performance_optimization
    test_project_detection
    test_ai_memory_management
    test_full_system_integration
    
    # Cleanup
    cleanup_test_environment
    
    # Results
    echo ""
    echo "📊 Test Results"
    echo "==============="
    echo "Tests run: $TESTS_RUN"
    echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "\n🎉 ${GREEN}All tests passed!${NC}"
        echo "✅ Secure dotfiles system is working correctly"
        return 0
    else
        echo -e "\n⚠️  ${RED}Some tests failed${NC}"
        echo "❌ Please review the failures above"
        return 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi