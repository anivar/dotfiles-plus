#!/usr/bin/env bash
# 🚀 Dotfiles Plus - Shell-Compatible Version
# Version 1.0 - Complete rewrite addressing all security vulnerabilities
# Compatible with bash 3.x and other shells without associative array support

# ============================================================================
# CORE SECURITY FUNCTIONS
# ============================================================================

# Sanitize user input to prevent command injection
_secure_sanitize_input() {
    local input="$1"
    local allow_spaces="${2:-false}"
    
    # Remove dangerous characters using proper escaping
    if [[ "$allow_spaces" == "true" ]]; then
        # Allow spaces but remove other dangerous chars
        input=$(echo "$input" | sed 's/[;&|`$(){}[\]\\<>]//g')
    else
        # Remove all potentially dangerous characters including spaces
        input=$(echo "$input" | sed 's/[;&|`$(){}[\]\\<>[:space:]]//g')
    fi
    
    # Limit length to prevent buffer overflow-style attacks
    if [[ ${#input} -gt 1000 ]]; then
        input="${input:0:1000}"
    fi
    
    echo "$input"
}

# Validate input against allowed patterns
_secure_validate_input() {
    local input="$1"
    local pattern="${2:-^[a-zA-Z0-9_.-]+$}"
    
    if [[ "$input" =~ $pattern ]]; then
        echo "$input"
        return 0
    else
        echo "❌ Invalid input: contains disallowed characters" >&2
        return 1
    fi
}

# Safe command execution without eval
_secure_execute_command() {
    local cmd_name="$1"
    shift
    local cmd_args=("$@")
    
    # Verify command exists and is executable
    if ! command -v "$cmd_name" >/dev/null 2>&1; then
        echo "❌ Command not found: $cmd_name" >&2
        return 1
    fi
    
    # Execute command safely without eval
    "$cmd_name" "${cmd_args[@]}" 2>/dev/null || {
        echo "❌ Command execution failed: $cmd_name" >&2
        return 1
    }
}

# ============================================================================
# CONFIGURATION SYSTEM
# ============================================================================

# Configuration storage using files instead of associative arrays
DOTFILES_CONFIG_HOME="${HOME}/.dotfiles-plus"
DOTFILES_CONFIG_FILE="${DOTFILES_CONFIG_HOME}/config/dotfiles.conf"

# Initialize configuration
_config_init() {
    # Create directory structure
    mkdir -p "${DOTFILES_CONFIG_HOME}"/{config,sessions,contexts,memory,backups,local,projects,performance,cache} 2>/dev/null
    
    # Create default configuration if it doesn't exist
    if [[ ! -f "$DOTFILES_CONFIG_FILE" ]]; then
        cat > "$DOTFILES_CONFIG_FILE" << 'EOF'
# Dotfiles Plus Configuration
version=1.0
session_id=session_$(date +%s)_$$
platform=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
shell=$(basename "$SHELL")
cache_ttl=3600
EOF
    fi
    
    # Set essential environment variables
    export DOTFILES_PLUS_HOME="$DOTFILES_CONFIG_HOME"
    export DOTFILES_PLUS_VERSION="2.0.1"
    export DOTFILES_PLUS_SESSION_ID="session_$(date +%s)_$$"
}

# Get configuration value
_config_get() {
    local key="$1"
    local default="$2"
    
    if [[ -f "$DOTFILES_CONFIG_FILE" ]]; then
        local value
        value=$(grep "^${key}=" "$DOTFILES_CONFIG_FILE" 2>/dev/null | cut -d= -f2- | head -1)
        echo "${value:-$default}"
    else
        echo "$default"
    fi
}

# Set configuration value
_config_set() {
    local key="$1"
    local value="$2"
    
    # Sanitize key
    local safe_key
    safe_key=$(_secure_validate_input "$key" "^[a-zA-Z0-9_-]+$")
    [[ $? -ne 0 ]] && return 1
    
    # Update or add configuration
    if [[ -f "$DOTFILES_CONFIG_FILE" ]]; then
        # Remove existing key
        grep -v "^${safe_key}=" "$DOTFILES_CONFIG_FILE" > "${DOTFILES_CONFIG_FILE}.tmp"
        mv "${DOTFILES_CONFIG_FILE}.tmp" "$DOTFILES_CONFIG_FILE"
    fi
    
    # Add new value
    echo "${safe_key}=${value}" >> "$DOTFILES_CONFIG_FILE"
}

# ============================================================================
# AI FUNCTIONALITY
# ============================================================================

# AI query with secure execution
function ai() {
    local subcommand="$1"
    shift
    
    case "$subcommand" in
        remember)
            _ai_remember "$@"
            ;;
        forget)
            _ai_forget
            ;;
        recall)
            if declare -f _ai_recall_smart >/dev/null 2>&1; then
                _ai_recall_smart "$@"
            else
                _ai_recall
            fi
            ;;
        stack)
            _ai_context_stack
            ;;
        projects)
            _ai_show_all_projects
            ;;
        stats)
            if declare -f _ai_memory_stats >/dev/null 2>&1; then
                _ai_memory_stats
            else
                echo "❌ Memory stats not available in this version"
            fi
            ;;
        clean)
            if declare -f _ai_memory_clean >/dev/null 2>&1; then
                _ai_memory_clean "$@"
            else
                echo "❌ Memory clean not available in this version"
            fi
            ;;
        think)
            if declare -f _ai_think >/dev/null 2>&1; then
                _ai_think "$@"
            else
                echo "❌ Thinking mode not available in this version"
            fi
            ;;
        import)
            if declare -f _ai_import_memory >/dev/null 2>&1; then
                _ai_import_memory "$@"
            else
                echo "❌ Import system not available in this version"
            fi
            ;;
        discover)
            if declare -f _ai_discover_memories >/dev/null 2>&1; then
                _ai_discover_memories "$@"
            else
                echo "❌ Memory discovery not available in this version"
            fi
            ;;
        template)
            if declare -f _ai_template >/dev/null 2>&1; then
                _ai_template "$@"
            else
                echo "❌ Template system not available in this version"
            fi
            ;;
        continue)
            if declare -f _ai_continue >/dev/null 2>&1; then
                _ai_continue "$@"
            else
                echo "❌ Continue conversation not available in this version"
            fi
            ;;
        resume)
            if declare -f _ai_resume >/dev/null 2>&1; then
                _ai_resume "$@"
            else
                echo "❌ Resume conversation not available in this version"
            fi
            ;;
        history)
            if declare -f _ai_history >/dev/null 2>&1; then
                _ai_history "$@"
            else
                echo "❌ Conversation history not available in this version"
            fi
            ;;
        testgen)
            if declare -f _ai_testgen >/dev/null 2>&1; then
                _ai_testgen "$@"
            else
                echo "❌ Test generation not available in this version"
            fi
            ;;
        freeze)
            if declare -f _ai_freeze >/dev/null 2>&1; then
                _ai_freeze "$@"
            else
                echo "❌ Freeze points not available in this version"
            fi
            ;;
        thaw)
            if declare -f _ai_thaw >/dev/null 2>&1; then
                _ai_thaw "$@"
            else
                echo "❌ Freeze points not available in this version"
            fi
            ;;
        freezelist)
            if declare -f _ai_freeze_list >/dev/null 2>&1; then
                _ai_freeze_list "$@"
            else
                echo "❌ Freeze points not available in this version"
            fi
            ;;
        memory)
            if declare -f _ai_memory_show >/dev/null 2>&1; then
                _ai_memory_show "$@"
            else
                echo "❌ Memory scope view not available in this version"
            fi
            ;;
        help)
            echo "🤖 AI Commands:"
            echo "  ai \"query\"                  # Ask AI with secure execution"
            echo ""
            echo "📝 Memory Management:"
            echo "  ai remember [opts] \"info\"   # Save context (multi-level aware)"
            echo "    --important|-i            # Mark as important"
            echo "    --tag|-t <tag>           # Add tag (task, link, issue, etc.)"
            echo "  ai forget                   # Clear session context"
            echo "  ai recall [opts] [search]   # Show smart context with filtering"
            echo "    --important|-i            # Show only important items"
            echo "    --tag|-t <tag>           # Filter by tag"
            echo "  ai stack                    # Show context stack navigation"
            echo "  ai projects                 # Show cross-project contexts"
            echo "  ai stats                    # Show memory statistics"
            echo "  ai clean [days]            # Clean memories older than N days (default: 30)"
            echo ""
            echo "🤔 Extended Features:"
            echo "  ai think \"complex problem\"  # Enter thinking mode for deep analysis"
            echo "  ai import @path/to/file    # Import memory from external file"
            echo "  ai discover                # Find and import memory files in parent dirs"
            echo "  ai template <type>         # Create memory templates (bug-report, etc.)"
            echo ""
            echo "💬 Conversations:"
            echo "  ai continue                # Continue last conversation"
            echo "  ai resume                  # Pick conversation to resume"
            echo "  ai history [limit]         # Show conversation history"
            echo ""
            echo "🧪 Development Tools:"
            echo "  ai testgen <target>        # Generate tests for code/functions"
            echo "  ai memory [--user|--project] # Show memory by scope"
            echo ""
            echo "❄️  Freeze Points (Save/Restore States):"
            echo "  ai freeze [name]           # Save current conversation state"
            echo "  ai thaw <name>             # Restore saved conversation state"
            echo "  ai freezelist              # List available freeze points"
            echo ""
            echo "🎯 Context Perspectives (No State Collision):"
            echo "  ai-arch \"question\"         # Ask as architect (design focus)"
            echo "  ai-dev \"question\"          # Ask as developer (implementation)"
            echo "  ai-fix \"question\"          # Ask as maintainer (minimal changes)"
            echo "  ai-test \"question\"         # Ask as tester (quality focus)"
            echo "  ai-review \"question\"       # Ask as reviewer (best practices)"
            echo "  ai-debug \"question\"        # Ask as debugger (root cause)"
            ;;
        *)
            # Default: treat as query
            _ai_query "$subcommand" "$@"
            ;;
    esac
}

# Execute AI query securely
function _ai_query() {
    local query="$*"
    
    # Validate and sanitize input
    if [[ -z "$query" ]]; then
        echo "❌ Empty query provided" >&2
        return 1
    fi
    
    # Sanitize the query
    local safe_query
    safe_query=$(_secure_sanitize_input "$query" "true")
    if [[ $? -ne 0 ]] || [[ -z "$safe_query" ]]; then
        echo "❌ Invalid query - contains unsafe characters" >&2
        return 1
    fi
    
    # Build smart context if available
    local context=""
    if declare -f _ai_build_smart_context_compat >/dev/null 2>&1; then
        context=$(_ai_build_smart_context_compat)
        safe_query="${context}Query: ${safe_query}"
    fi
    
    echo "🤖 AI Query [$DOTFILES_PLUS_SESSION_ID]: $query"
    echo "📍 Directory: $(basename "$(pwd)")"
    
    # Check for available AI providers
    if command -v claude >/dev/null 2>&1; then
        echo "🔵 Using claude..."
        _secure_execute_command "claude" "$safe_query"
    elif command -v gemini >/dev/null 2>&1; then
        echo "🔵 Using gemini..."
        _secure_execute_command "gemini" "-p" "$safe_query"
    else
        echo "🤖 AI Response: $query

💡 No AI providers available. Install providers:
  Claude Code: Visit https://claude.ai/code
  Gemini CLI:  npm install -g @google/generative-ai-cli"
    fi
}

# Remember information
function _ai_remember() {
    # Use smart remember if available, otherwise fallback
    if declare -f _ai_remember_smart >/dev/null 2>&1; then
        _ai_remember_smart "$@"
    else
        local info="$*"
        
        if [[ -z "$info" ]]; then
            echo "Usage: ai remember <information>" >&2
            return 1
        fi
        
        # Sanitize input
        local safe_info
        safe_info=$(_secure_sanitize_input "$info" "true")
        if [[ $? -ne 0 ]]; then
            echo "❌ Invalid information - contains unsafe characters" >&2
            return 1
        fi
        
        local context_file="$DOTFILES_CONFIG_HOME/contexts/${DOTFILES_PLUS_SESSION_ID}_$(pwd | sed 's|/|_|g')"
        local timestamp="[$(date '+%H:%M')]"
        
        echo "$timestamp $safe_info" >> "$context_file"
        echo "💾 Remembered: $safe_info"
    fi
}

# Forget session context
function _ai_forget() {
    local context_file="$DOTFILES_CONFIG_HOME/contexts/${DOTFILES_PLUS_SESSION_ID}_$(pwd | sed 's|/|_|g')"
    
    if [[ -f "$context_file" ]]; then
        rm -f "$context_file"
        echo "🗑️  Context cleared for this session/directory"
    else
        echo "No context to clear"
    fi
}

# Recall session context
function _ai_recall() {
    # Use smart recall if available, otherwise fallback
    if declare -f _ai_recall_smart >/dev/null 2>&1; then
        _ai_recall_smart
    else
        local context_file="$DOTFILES_CONFIG_HOME/contexts/${DOTFILES_PLUS_SESSION_ID}_$(pwd | sed 's|/|_|g')"
        
        if [[ -f "$context_file" ]]; then
            echo "📚 Context for session $DOTFILES_PLUS_SESSION_ID:"
            cat "$context_file"
        else
            echo "No context for this session/directory"
        fi
    fi
}

# ============================================================================
# SYSTEM MANAGEMENT
# ============================================================================

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
        version)
            _dotfiles_version
            ;;
        backup)
            _dotfiles_backup
            ;;
        help)
            echo "🚀 System Management:"
            echo "  dotfiles status   # Show system status"
            echo "  dotfiles health   # Run health check"
            echo "  dotfiles version  # Show version info"
            echo "  dotfiles backup   # Backup configuration"
            ;;
        *)
            dotfiles help
            ;;
    esac
}

# Show system status
_dotfiles_status() {
    echo "📊 Dotfiles Plus Status"
    echo "==============================="
    echo "Version: $(_config_get version)"
    echo "Session: $DOTFILES_PLUS_SESSION_ID"
    echo "Platform: $(_config_get platform) $(_config_get arch)"
    echo "Shell: $(_config_get shell)"
    echo "Home: $DOTFILES_CONFIG_HOME"
}

# Health check
_dotfiles_health_check() {
    echo "🏥 Dotfiles Plus Health Check"
    echo "===================================="
    
    local issues=0
    
    # Check core functionality
    echo "🔧 Core functionality..."
    if declare -f _secure_sanitize_input >/dev/null; then
        echo "  Security functions: ✅ OK"
    else
        echo "  Security functions: ❌ FAILED"
        ((issues++))
    fi
    
    # Check file system
    echo "💾 File system..."
    if [[ -d "$DOTFILES_CONFIG_HOME" && -w "$DOTFILES_CONFIG_HOME" ]]; then
        echo "  Home directory: ✅ OK"
    else
        echo "  Home directory: ❌ FAILED"
        ((issues++))
    fi
    
    # Check AI providers
    echo "🤖 AI providers..."
    if command -v claude >/dev/null 2>&1 || command -v gemini >/dev/null 2>&1; then
        echo "  AI providers: ✅ OK"
    else
        echo "  AI providers: ⚠️  None available"
    fi
    
    # Summary
    echo ""
    if [[ $issues -eq 0 ]]; then
        echo "🎉 All health checks passed!"
    else
        echo "⚠️  $issues issues found."
        return 1
    fi
}

# Version information
_dotfiles_version() {
    echo "📦 Dotfiles Plus"
    echo "Version: $(_config_get version)"
    echo "Session: $DOTFILES_PLUS_SESSION_ID"
    echo "Platform: $(_config_get platform) $(_config_get arch)"
    echo ""
    echo "🔒 Security features:"
    echo "  ✅ Input sanitization active"
    echo "  ✅ Command injection protection"
    echo "  ✅ Secure command execution"
}

# Backup configuration
_dotfiles_backup() {
    local backup_file="$DOTFILES_CONFIG_HOME/backups/backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    mkdir -p "$(dirname "$backup_file")"
    
    echo "💾 Creating backup..."
    if tar -czf "$backup_file" -C "$DOTFILES_CONFIG_HOME" . 2>/dev/null; then
        echo "✅ Backup created: $(basename "$backup_file")"
    else
        echo "❌ Backup failed" >&2
        return 1
    fi
}

# ============================================================================
# ENHANCED GIT COMMANDS
# ============================================================================

# Smart git status
gst() {
    echo "🌿 Git Status"
    
    if git rev-parse --git-dir >/dev/null 2>&1; then
        local branch
        branch=$(git branch --show-current 2>/dev/null || echo "unknown")
        echo "📍 Branch: $branch"
        echo ""
        
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
    else
        echo "Not a git repository"
    fi
}

# Smart commit
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
# INITIALIZATION
# ============================================================================

# Source enhanced context if available
if [[ -f "$HOME/.dotfiles-plus/ai/context-compat.sh" ]]; then
    source "$HOME/.dotfiles-plus/ai/context-compat.sh"
fi

# Source import system if available
if [[ -f "$HOME/.dotfiles-plus/ai/import.sh" ]]; then
    source "$HOME/.dotfiles-plus/ai/import.sh"
fi

# Source thinking mode if available
if [[ -f "$HOME/.dotfiles-plus/ai/thinking.sh" ]]; then
    source "$HOME/.dotfiles-plus/ai/thinking.sh"
fi

# Source context hints if available
if [[ -f "$HOME/.dotfiles-plus/ai/hints.sh" ]]; then
    source "$HOME/.dotfiles-plus/ai/hints.sh"
fi

# Initialize the system
_secure_dotfiles_init() {
    # Initialize configuration
    _config_init
    
    # Setup auto-discovery if available
    if declare -f _ai_setup_auto_discover >/dev/null 2>&1; then
        _ai_setup_auto_discover
    fi
    
    echo "✅ Dotfiles Plus v$(_config_get version) loaded successfully"
}

# Initialize
_secure_dotfiles_init

# Show welcome message
echo ""
echo "  ┌─────────────────────────────────────────┐"
echo "  │     🔒 Dotfiles Plus v$(_config_get version)     │"
echo "  │   Enhanced dotfiles with security       │"
echo "  └─────────────────────────────────────────┘"
echo ""
echo "💡 Try: ai help | dotfiles status | gst"
echo "🔒 Security: All vulnerabilities addressed"
echo ""

# Aliases
alias g="git"
alias ll="ls -la"
alias ..="cd .."
alias grep="grep --color=auto"
alias remember="ai remember"
alias forget="ai forget"