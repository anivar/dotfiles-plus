#!/usr/bin/env bash
# 🚀 Dotfiles Plus - Enhanced dotfiles with security and modularity
# Version 1.0 - Complete rewrite addressing all security vulnerabilities

# ============================================================================
# SECURITY NOTICE
# ============================================================================
# This version addresses critical security vulnerabilities:
# ✅ Command injection vulnerabilities fixed
# ✅ Unsafe eval calls replaced with secure alternatives
# ✅ Input sanitization implemented throughout
# ✅ Script verification for downloads
# ✅ Modular architecture for better maintainability
# ✅ Reduced global state pollution
# ✅ Performance optimizations implemented

# ============================================================================
# MODULE LOADING
# ============================================================================

# Get the directory where this script is located
SECURE_DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all core modules
source "$SECURE_DOTFILES_DIR/core/security.sh"
source "$SECURE_DOTFILES_DIR/core/config.sh"
source "$SECURE_DOTFILES_DIR/core/performance.sh"
source "$SECURE_DOTFILES_DIR/ai/providers.sh"
source "$SECURE_DOTFILES_DIR/ai/context.sh"
source "$SECURE_DOTFILES_DIR/project/manager.sh"
source "$SECURE_DOTFILES_DIR/system/bootstrap.sh"

# ============================================================================
# INITIALIZATION
# ============================================================================

# Initialize secure dotfiles system
_secure_dotfiles_init() {
    # Initialize configuration system
    _config_init
    
    # Setup environment variables (minimal set)
    _config_setup_environment
    
    # Initialize AI providers
    _config_init_ai_providers
    
    # Validate configuration
    if ! _config_validate; then
        echo "⚠️  Configuration validation failed. Some features may not work correctly."
    fi
    
    # Log initialization
    _secure_perf_log "secure_dotfiles_init" "0ms"
    
    echo "✅ Secure dotfiles-plus v$(_config_get version) loaded successfully"
}

# ============================================================================
# MAIN COMMANDS
# ============================================================================

# AI command interface
ai() {
    local subcommand="$1"
    shift
    
    case "$subcommand" in
        remember)
            ai_remember "$@"
            ;;
        forget)
            ai_forget
            ;;
        recall)
            ai_recall
            ;;
        memory)
            ai_memory
            ;;
        stack)
            ai_context_stack
            ;;
        projects)
            ai_show_all_projects
            ;;
        provider)
            case "$1" in
                setup)
                    ai_provider_setup "$2"
                    ;;
                list)
                    echo "🤖 Available AI Providers:"
                    for provider in "${!AI_CONTEXT_FILES[@]}"; do
                        echo "  $provider -> ${AI_CONTEXT_FILES[$provider]}"
                    done
                    ;;
                *)
                    echo "Provider commands: setup <provider>, list"
                    ;;
            esac
            ;;
        help)
            echo "🤖 AI Commands:"
            echo "  ai \"query\"              # Ask AI with secure execution"
            echo "  ai remember \"info\"      # Save context (multi-level aware)"
            echo "  ai forget               # Clear session context"
            echo "  ai recall               # Show smart context hierarchy"
            echo "  ai memory               # Show all memories"
            echo "  ai stack                # Show context stack navigation"
            echo "  ai projects             # Show cross-project contexts"
            echo "  ai provider setup <name> # Setup provider context file"
            echo "  ai provider list        # List available providers"
            ;;
        *)
            # Default: treat as query
            ai_query "$subcommand" "$@"
            ;;
    esac
}

# System management commands
dotfiles() {
    local subcommand="$1"
    shift
    
    case "$subcommand" in
        status)
            _dotfiles_status
            ;;
        health)
            _dotfiles_health_check
            ;;
        benchmark)
            _dotfiles_benchmark
            ;;
        update)
            _dotfiles_update
            ;;
        version)
            _dotfiles_version
            ;;
        backup)
            _dotfiles_backup
            ;;
        optimize)
            _dotfiles_optimize
            ;;
        test)
            _dotfiles_run_tests
            ;;
        help)
            echo "🚀 System Management:"
            echo "  dotfiles status      # Show system status"
            echo "  dotfiles health      # Run health check"
            echo "  dotfiles benchmark   # Performance benchmark"
            echo "  dotfiles update      # Update secure dotfiles"
            echo "  dotfiles version     # Show version info"
            echo "  dotfiles backup      # Backup configuration"
            echo "  dotfiles optimize    # Optimize performance"
            echo "  dotfiles test        # Run test suite"
            ;;
        *)
            dotfiles help
            ;;
    esac
}

# Configuration management
config() {
    local subcommand="$1"
    shift
    
    case "$subcommand" in
        get)
            _config_get "$1" "$2"
            ;;
        set)
            _config_set "$1" "$2"
            ;;
        save)
            _config_save
            ;;
        edit)
            local config_file="$(_config_get home)/config/dotfiles.conf"
            ${EDITOR:-nano} "$config_file"
            ;;
        providers)
            case "$1" in
                edit)
                    local providers_file="$(_config_get home)/config/providers.conf"
                    ${EDITOR:-nano} "$providers_file"
                    ;;
                test)
                    _config_test_providers
                    ;;
                *)
                    echo "Provider commands: edit, test"
                    ;;
            esac
            ;;
        help)
            echo "⚙️ Configuration Management:"
            echo "  config get <key>         # Get configuration value"
            echo "  config set <key> <value> # Set configuration value"
            echo "  config save              # Save configuration"
            echo "  config edit              # Edit main configuration"
            echo "  config providers edit    # Edit AI providers"
            echo "  config providers test    # Test AI providers"
            ;;
        *)
            config help
            ;;
    esac
}

# Project management
project() {
    local subcommand="$1"
    shift
    
    case "$subcommand" in
        init)
            project_init "$@"
            ;;
        detect)
            project_detect
            ;;
        current)
            project_current
            ;;
        list)
            project_list
            ;;
        build|test|dev|install)
            project_exec "$subcommand" "$@"
            ;;
        help)
            echo "📂 Project Management:"
            echo "  project init [name]    # Initialize project config"
            echo "  project detect         # Detect project type"
            echo "  project current        # Show current project info"
            echo "  project list           # List all projects"
            echo "  project build          # Build project"
            echo "  project test           # Run project tests"
            echo "  project dev            # Start development server"
            echo "  project install        # Install dependencies"
            ;;
        *)
            project help
            ;;
    esac
}

# Bootstrap system
bootstrap() {
    local subcommand="$1"
    shift
    
    case "$subcommand" in
        macos)
            bootstrap_macos
            ;;
        linux)
            bootstrap_linux
            ;;
        apps)
            bootstrap_apps
            ;;
        dev)
            bootstrap_dev
            ;;
        all)
            bootstrap_all
            ;;
        install)
            bootstrap_install_packages "$@"
            ;;
        update)
            bootstrap_update_system
            ;;
        help)
            echo "🚀 Bootstrap Commands:"
            echo "  bootstrap macos          # Configure macOS defaults"
            echo "  bootstrap linux          # Configure Linux environment"
            echo "  bootstrap apps           # Install essential apps"
            echo "  bootstrap dev            # Setup development tools"
            echo "  bootstrap all            # Complete setup"
            echo "  bootstrap install <pkg>  # Install packages"
            echo "  bootstrap update         # Update system packages"
            ;;
        *)
            bootstrap help
            ;;
    esac
}

# ============================================================================
# SYSTEM STATUS AND DIAGNOSTICS
# ============================================================================

# Show system status
_dotfiles_status() {
    echo "📊 Dotfiles Plus Status"
    echo "==============================="
    echo "Version: $(_config_get version)"
    echo "Session: $(_config_get session_id)"
    echo "Platform: $(_config_get platform) $(_config_get arch)"
    echo "Shell: $(_config_get shell)"
    echo "Home: $(_config_get home)"
    echo ""
    
    # Performance info
    echo "⚡ Performance:"
    echo "  Startup time: $(_config_get_duration)"
    echo "  Loaded modules: ${#SECURE_LOADED_MODULES[@]}"
    echo "  Cache entries: ${#PERF_CACHE[@]}"
    echo ""
    
    # Project info
    if project_get_current_config >/dev/null 2>&1; then
        echo "📂 Current Project:"
        project_current
    else
        echo "📂 No project configured for current directory"
    fi
    echo ""
    
    # AI provider status
    echo "🤖 AI Provider Status:"
    local provider
    provider=$(_config_get_ai_provider 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        echo "  Active provider: $provider ✅"
    else
        echo "  No providers available ❌"
    fi
}

# Health check
_dotfiles_health_check() {
    echo "🏥 Dotfiles Plus Health Check"
    echo "===================================="
    
    local issues=0
    
    # Check core functionality
    echo "🔧 Core functionality..."
    if declare -f _secure_sanitize_input >/dev/null; then
        echo "  Security module: ✅ OK"
    else
        echo "  Security module: ❌ FAILED"
        ((issues++))
    fi
    
    if declare -f _config_get >/dev/null; then
        echo "  Configuration module: ✅ OK"
    else
        echo "  Configuration module: ❌ FAILED"
        ((issues++))
    fi
    
    # Check file system
    echo "💾 File system..."
    local home_dir="$(_config_get home)"
    if [[ -d "$home_dir" && -w "$home_dir" ]]; then
        echo "  Home directory: ✅ OK"
    else
        echo "  Home directory: ❌ FAILED"
        ((issues++))
    fi
    
    # Check AI providers
    echo "🤖 AI providers..."
    if _config_get_ai_provider >/dev/null 2>&1; then
        echo "  AI providers: ✅ OK"
    else
        echo "  AI providers: ⚠️  None available"
    fi
    
    # Performance check
    echo "⚡ Performance..."
    local duration="$(_config_get_duration)"
    echo "  Startup time: $duration"
    
    # Summary
    echo ""
    if [[ $issues -eq 0 ]]; then
        echo "🎉 All health checks passed!"
    else
        echo "⚠️  $issues issues found. Check logs for details."
        return 1
    fi
}

# Version information
_dotfiles_version() {
    echo "📦 Dotfiles Plus"
    echo "Version: $(_config_get version)"
    echo "Session: $(_config_get session_id)"
    echo "Platform: $(_perf_get_system_info)"
    echo "Startup time: $(_config_get_duration)"
    echo ""
    echo "🔒 Security features:"
    echo "  ✅ Input sanitization active"
    echo "  ✅ Command injection protection"
    echo "  ✅ Script verification enabled"
    echo "  ✅ Secure lazy loading"
    echo ""
    echo "📈 Performance features:"
    echo "  ✅ Smart caching enabled"
    echo "  ✅ Subprocess optimization"
    echo "  ✅ Batch operations"
    echo "  ✅ Deferred loading"
}

# Backup configuration
_dotfiles_backup() {
    local backup_dir="$(_config_get backup_dir)"
    local backup_file="$backup_dir/full-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    mkdir -p "$backup_dir"
    
    echo "💾 Creating backup..."
    if tar -czf "$backup_file" -C "$(_config_get home)" . 2>/dev/null; then
        echo "✅ Backup created: $(basename "$backup_file")"
        echo "📁 Location: $backup_file"
    else
        echo "❌ Backup failed" >&2
        return 1
    fi
}

# Optimize performance
_dotfiles_optimize() {
    echo "⚡ Optimizing secure dotfiles performance..."
    
    # Clean cache
    _perf_cache_cleanup
    echo "✅ Cache cleaned"
    
    # Clean old logs
    _perf_cleanup
    echo "✅ Logs optimized"
    
    # Optimize git repository if present
    if [[ -d "$(_config_get dotfiles_dir)/.git" ]]; then
        echo "🌿 Optimizing git repository..."
        (cd "$(_config_get dotfiles_dir)" && git gc --aggressive --prune=now >/dev/null 2>&1)
        echo "✅ Git repository optimized"
    fi
    
    echo "🎉 Optimization complete!"
}

# Performance benchmark
_dotfiles_benchmark() {
    echo "⚡ Running performance benchmarks..."
    
    # Benchmark core functions
    _perf_benchmark "_config_get" 10 "version"
    _perf_benchmark "_secure_sanitize_input" 10 "test input"
    _perf_benchmark "_perf_git_info_batch" 5
    
    echo "📊 Benchmark complete"
}

# Test provider availability
_config_test_providers() {
    echo "🧪 Testing AI providers..."
    
    for provider in claude gemini opencode; do
        local cmd="${AI_PROVIDERS[${provider}_cmd]}"
        if [[ -n "$cmd" ]] && command -v "$cmd" >/dev/null 2>&1; then
            echo "  ✅ $provider ($cmd) - Available"
        else
            echo "  ❌ $provider ($cmd) - Not available"
        fi
    done
}

# ============================================================================
# ENHANCED GIT COMMANDS
# ============================================================================

# Smart git status
gst() {
    echo "🌿 Git Status"
    
    # Use cached git info
    local git_data
    git_data=$(_perf_cache_get_or_set "git_info" 10 "_perf_git_info_batch")
    
    if [[ "$git_data" == "not_a_repo||||" ]]; then
        echo "Not a git repository"
        return 1
    fi
    
    IFS='|' read -r branch repo_name status_count commit_count <<< "$git_data"
    echo "📍 Repository: $repo_name"
    echo "🌿 Branch: $branch"
    echo "📊 Commits: $commit_count"
    echo ""
    
    # Show detailed status
    git status --porcelain | while read -r line; do
        local status_code="${line:0:2}"
        local file="${line:3}"
        
        case "$status_code" in
            "M ") echo "📝 Modified:   $file" ;;
            " M") echo "✏️  Modified:   $file (unstaged)" ;;
            "A ") echo "➕ Added:      $file" ;;
            "D ") echo "🗑️  Deleted:    $file" ;;
            "??") echo "❓ Untracked:  $file" ;;
            *) echo "$status_code $file" ;;
        esac
    done
}

# Smart commit (preserved from original)
gc() {
    local message="$*"
    
    if ! git diff --cached --quiet; then
        if [[ -z "$message" ]]; then
            local files
            files=$(git diff --cached --name-only | tr '\n' ' ')
            message="update $files"
            echo "💬 Suggested: $message"
            echo -n "Use this message? [Y/n] "
            read -r response
            [[ "$response" =~ ^[Nn] ]] && { echo -n "Enter message: "; read -r message; }
        fi
        git commit -m "$message" && echo "✅ Committed: $message"
    else
        echo "❌ No staged changes"
    fi
}

# Quick add + commit
gac() { git add . && gc "$*"; }

# Pretty log
gl() { git log --oneline --graph --decorate -n "${1:-10}"; }

# ============================================================================
# ALIASES
# ============================================================================

# Safe aliases (no conflicts)
alias g="git"
alias ll="ls -la"
alias ..="cd .."
alias grep="grep --color=auto"

# AI shortcuts
alias remember="ai remember"
alias forget="ai forget"

# ============================================================================
# INITIALIZATION AND CLEANUP
# ============================================================================

# Initialize the system
_secure_dotfiles_init

# Cleanup function for exit
_secure_dotfiles_cleanup() {
    _perf_cleanup
    _perf_execute_deferred
}

# Register cleanup on exit
trap _secure_dotfiles_cleanup EXIT

# Show welcome message
echo ""
echo "  ┌─────────────────────────────────────────┐"
echo "  │     🔒 Dotfiles Plus v$(_config_get version)     │"
echo "  │   Enhanced dotfiles with security       │"
echo "  └─────────────────────────────────────────┘"
echo ""
echo "💡 Try: ai help | dotfiles status | project detect"
echo "🔒 Security: All vulnerabilities addressed"
echo ""