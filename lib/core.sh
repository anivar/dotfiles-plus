#!/usr/bin/env bash
# Core library - Essential functions

# ============================================================================
# LOGGING
# ============================================================================

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly RESET='\033[0m'

# Log functions
log() {
    local level="$1"
    shift
    
    case "$level" in
        error)   echo -e "${RED}❌${RESET} $*" >&2 ;;
        warning) echo -e "${YELLOW}⚠️${RESET} $*" ;;
        info)    echo -e "${BLUE}ℹ️${RESET} $*" ;;
        success) echo -e "${GREEN}✅${RESET} $*" ;;
        debug)   [[ "${DEBUG:-}" == "true" ]] && echo -e "${CYAN}[DEBUG]${RESET} $*" ;;
    esac
}

# ============================================================================
# UTILITIES
# ============================================================================

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure directory exists
ensure_dir() {
    [[ -d "$1" ]] || mkdir -p "$1"
}

# Safe file read
safe_read() {
    [[ -f "$1" ]] && cat "$1" 2>/dev/null || echo ""
}

# Safe file write with atomic operation
safe_write() {
    local file="$1"
    local content="$2"
    local temp_file="${file}.tmp.$$"
    
    ensure_dir "$(dirname "$file")"
    echo "$content" > "$temp_file"
    mv -f "$temp_file" "$file"
}

# Get timestamp
timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Get epoch
epoch() {
    date +%s
}

# ============================================================================
# SECURITY
# ============================================================================

# Sanitize input
sanitize() {
    local input="$1"
    local allow_spaces="${2:-false}"
    
    if [[ "$allow_spaces" == "true" ]]; then
        # Allow spaces but remove dangerous chars
        echo "$input" | sed 's/[;&|`$(){}[\]\\<>]//g'
    else
        # Remove all dangerous chars including spaces
        echo "$input" | sed 's/[;&|`$(){}[\]\\<>[:space:]]//g'
    fi
}

# Validate against pattern
validate() {
    local input="$1"
    local pattern="${2:-^[a-zA-Z0-9_.-]+$}"
    
    [[ "$input" =~ $pattern ]]
}

# ============================================================================
# STATE MANAGEMENT
# ============================================================================

# Get state value
state_get() {
    local key="$1"
    local default="${2:-}"
    local state_file="$DOTFILES_HOME/state/$key"
    
    if [[ -f "$state_file" ]]; then
        cat "$state_file"
    else
        echo "$default"
    fi
}

# Set state value
state_set() {
    local key="$1"
    local value="$2"
    
    ensure_dir "$DOTFILES_HOME/state"
    safe_write "$DOTFILES_HOME/state/$key" "$value"
}

# ============================================================================
# CACHE SYSTEM
# ============================================================================

# Get from cache
cache_get() {
    local key="$1"
    local ttl="${2:-3600}"  # Default 1 hour
    local cache_file="$DOTFILES_HOME/cache/$key"
    
    if [[ -f "$cache_file" ]]; then
        local age=$(( $(epoch) - $(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null || echo 0) ))
        if [[ $age -lt $ttl ]]; then
            cat "$cache_file"
            return 0
        fi
    fi
    
    return 1
}

# Set cache
cache_set() {
    local key="$1"
    local value="$2"
    
    ensure_dir "$DOTFILES_HOME/cache"
    safe_write "$DOTFILES_HOME/cache/$key" "$value"
}

# Clear cache
cache_clear() {
    rm -rf "$DOTFILES_HOME/cache"/*
}

# ============================================================================
# ERROR HANDLING
# ============================================================================

# Error handler
error_handler() {
    local line="$1"
    local code="${2:-1}"
    local cmd="${3:-unknown}"
    
    log error "Command failed at line $line: $cmd (exit code: $code)"
    
    # Run error hooks
    hook_run "error" "$line" "$code" "$cmd"
}

# Set error trap (optional)
if [[ "${DOTFILES_STRICT:-false}" == "true" ]]; then
    trap 'error_handler ${LINENO} $? "$BASH_COMMAND"' ERR
fi

# ============================================================================
# HELP SYSTEM
# ============================================================================

# Generate help from registered commands
dotfiles_help() {
    echo "🚀 Dotfiles Plus v$DOTFILES_VERSION"
    echo ""
    echo "Usage: dotfiles <command> [options]"
    echo ""
    echo "Commands:"
    
    # Sort and display commands
    for cmd in $(echo "${!DOTFILES_COMMANDS[@]}" | tr ' ' '\n' | sort); do
        local info="${DOTFILES_COMMANDS[$cmd]}"
        local handler="${info%%:*}"
        local desc="${info#*:}"
        
        printf "  %-20s %s\n" "$cmd" "$desc"
    done
    
    echo ""
    echo "AI Commands:"
    echo "  ai <query>           Ask AI anything"
    echo "  ai remember <text>   Save to memory"
    echo "  ai recall [search]   Search memories"
    echo "  ai think <problem>   Deep analysis"
    echo ""
    echo "For more help: dotfiles help <command>"
}

# ============================================================================
# UPDATE SYSTEM
# ============================================================================

# Self-update function
dotfiles_update() {
    # Use the autoupdate script
    if [[ -f "$DOTFILES_ROOT/scripts/autoupdate.sh" ]]; then
        bash "$DOTFILES_ROOT/scripts/autoupdate.sh" manual
    else
        log error "Update script not found"
        return 1
    fi
}

# Reload configuration
dotfiles_reload() {
    log info "Reloading Dotfiles Plus..."
    source "$DOTFILES_ROOT/dotfiles.sh"
    log success "Reload complete!"
}