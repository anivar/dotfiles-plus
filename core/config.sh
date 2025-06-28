#!/usr/bin/env bash
# ⚙️ Configuration Management Module
# Centralized configuration system to reduce global state pollution

# ============================================================================
# CONFIGURATION SYSTEM
# ============================================================================

# Configuration storage (replaces scattered global variables)
declare -A DOTFILES_CONFIG

# Initialize default configuration
_config_init() {
    # Core settings
    DOTFILES_CONFIG["version"]="2.1.0"
    DOTFILES_CONFIG["home"]="${HOME}/.dotfiles-plus"
    DOTFILES_CONFIG["dotfiles_dir"]="${HOME}/dotfiles"
    
    # Performance settings
    DOTFILES_CONFIG["perf_log"]="${DOTFILES_CONFIG[home]}/performance.log"
    DOTFILES_CONFIG["cache_ttl"]="3600"
    DOTFILES_CONFIG["cache_dir"]="${DOTFILES_CONFIG[home]}/cache"
    
    # Session settings
    DOTFILES_CONFIG["session_id"]="session_$(date +%s)_$$"
    DOTFILES_CONFIG["session_dir"]="${DOTFILES_CONFIG[home]}/sessions"
    DOTFILES_CONFIG["context_dir"]="${DOTFILES_CONFIG[home]}/contexts"
    
    # Module settings
    DOTFILES_CONFIG["module_dir"]="${DOTFILES_CONFIG[home]}/modules"
    DOTFILES_CONFIG["local_dir"]="${DOTFILES_CONFIG[home]}/local"
    DOTFILES_CONFIG["backup_dir"]="${DOTFILES_CONFIG[home]}/backups"
    
    # Platform detection
    DOTFILES_CONFIG["platform"]="$(uname -s | tr '[:upper:]' '[:lower:]')"
    DOTFILES_CONFIG["arch"]="$(uname -m)"
    DOTFILES_CONFIG["shell"]="$(basename "$SHELL")"
    
    # Performance tracking
    if [[ "${DOTFILES_CONFIG[platform]}" == "darwin" ]]; then
        DOTFILES_CONFIG["start_time"]="$(date +%s)"
        DOTFILES_CONFIG["time_format"]="seconds"
    else
        DOTFILES_CONFIG["start_time"]="$(date +%s%3N)"
        DOTFILES_CONFIG["time_format"]="milliseconds"
    fi
    
    # Create directory structure
    mkdir -p "${DOTFILES_CONFIG[home]}"/{config,sessions,contexts,memory,backups,local,projects,performance,cache,modules} 2>/dev/null
    
    # Load user configuration if exists
    _config_load_user_config
}

# Get configuration value
_config_get() {
    local key="$1"
    local default="$2"
    
    local value="${DOTFILES_CONFIG[$key]}"
    echo "${value:-$default}"
}

# Set configuration value
_config_set() {
    local key="$1"
    local value="$2"
    
    # Validate key
    local safe_key
    safe_key=$(_secure_validate_input "$key" "^[a-zA-Z0-9_-]+$")
    [[ $? -ne 0 ]] && return 1
    
    DOTFILES_CONFIG["$safe_key"]="$value"
}

# Save configuration to file
_config_save() {
    local config_file="$(_config_get home)/config/dotfiles.conf"
    
    # Ensure config directory exists
    mkdir -p "$(dirname "$config_file")"
    
    # Write configuration
    {
        echo "# dotfiles-plus configuration"
        echo "# Generated on $(date)"
        echo ""
        for key in "${!DOTFILES_CONFIG[@]}"; do
            # Skip runtime-only values
            case "$key" in
                start_time|session_id|platform|arch|shell) continue ;;
                *) echo "$key=${DOTFILES_CONFIG[$key]}" ;;
            esac
        done
    } > "$config_file"
    
    echo "✅ Configuration saved to $config_file"
}

# Load user configuration
_config_load_user_config() {
    local config_file="$(_config_get home)/config/dotfiles.conf"
    
    if [[ -f "$config_file" ]]; then
        # Read configuration file safely
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^[[:space:]]*# ]] && continue
            [[ -z "$key" ]] && continue
            
            # Sanitize key and value
            local safe_key safe_value
            safe_key=$(_secure_sanitize_input "$key")
            safe_value=$(_secure_sanitize_input "$value" "true")
            
            if [[ -n "$safe_key" && -n "$safe_value" ]]; then
                DOTFILES_CONFIG["$safe_key"]="$safe_value"
            fi
        done < "$config_file"
    fi
}

# ============================================================================
# AI PROVIDER CONFIGURATION
# ============================================================================

# AI provider configuration storage
declare -A AI_PROVIDERS

# Initialize AI provider configuration
_config_init_ai_providers() {
    local providers_file="$(_config_get home)/config/providers.conf"
    
    # Create default providers config if not exists
    if [[ ! -f "$providers_file" ]]; then
        mkdir -p "$(dirname "$providers_file")"
        cat > "$providers_file" << 'EOF'
# AI Provider Configuration
# Format: provider_name:command:args_pattern
# Priority order: first available provider is used

claude:claude:{query}
gemini:gemini:-p {query}
opencode:opencode:{query}
EOF
    fi
    
    # Load providers configuration
    _config_load_ai_providers "$providers_file"
}

# Load AI providers from configuration file
_config_load_ai_providers() {
    local providers_file="$1"
    
    while IFS=: read -r name cmd args; do
        # Skip comments and empty lines
        [[ "$name" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$name" ]] && continue
        
        # Sanitize provider information
        local safe_name safe_cmd safe_args
        safe_name=$(_secure_sanitize_input "$name")
        safe_cmd=$(_secure_sanitize_input "$cmd")
        safe_args=$(_secure_sanitize_input "$args" "true")
        
        if [[ -n "$safe_name" && -n "$safe_cmd" ]]; then
            AI_PROVIDERS["${safe_name}_cmd"]="$safe_cmd"
            AI_PROVIDERS["${safe_name}_args"]="$safe_args"
        fi
    done < "$providers_file"
}

# Get available AI provider
_config_get_ai_provider() {
    for provider in claude gemini opencode; do
        local cmd="${AI_PROVIDERS[${provider}_cmd]}"
        if [[ -n "$cmd" ]] && command -v "$cmd" >/dev/null 2>&1; then
            echo "$provider"
            return 0
        fi
    done
    return 1
}

# Get AI provider command and args
_config_get_ai_provider_info() {
    local provider="$1"
    local cmd="${AI_PROVIDERS[${provider}_cmd]}"
    local args="${AI_PROVIDERS[${provider}_args]}"
    
    if [[ -n "$cmd" ]]; then
        echo "$cmd:$args"
        return 0
    fi
    return 1
}

# ============================================================================
# SESSION CONFIGURATION
# ============================================================================

# Get session-specific configuration
_config_get_session_file() {
    local session_id="$(_config_get session_id)"
    local context_dir="$(_config_get context_dir)"
    local current_dir_encoded
    current_dir_encoded="$(pwd | sed 's|/|_|g')"
    
    echo "$context_dir/${session_id}_${current_dir_encoded}"
}

# Get session log file
_config_get_session_log() {
    local session_id="$(_config_get session_id)"
    local session_dir="$(_config_get session_dir)"
    
    echo "$session_dir/${session_id}.log"
}

# ============================================================================
# PERFORMANCE CONFIGURATION
# ============================================================================

# Get current timestamp for performance tracking
_config_get_timestamp() {
    local time_format="$(_config_get time_format)"
    
    if [[ "$time_format" == "milliseconds" ]]; then
        date +%s%3N 2>/dev/null || date +%s
    else
        date +%s
    fi
}

# Calculate duration since start
_config_get_duration() {
    local current_time="$(_config_get_timestamp)"
    local start_time="$(_config_get start_time)"
    local time_format="$(_config_get time_format)"
    
    local duration=$((current_time - start_time))
    
    if [[ "$time_format" == "milliseconds" ]]; then
        echo "${duration}ms"
    else
        echo "${duration}s"
    fi
}

# ============================================================================
# ENVIRONMENT MANAGEMENT
# ============================================================================

# Set minimal required environment variables
_config_setup_environment() {
    # Only export what's absolutely necessary
    export DOTFILES_PLUS_HOME="$(_config_get home)"
    export DOTFILES_PLUS_VERSION="$(_config_get version)"
    export DOTFILES_PLUS_SESSION_ID="$(_config_get session_id)"
    
    # Initialize session log
    local session_log="$(_config_get_session_log)"
    echo "🌿 Session: $(_config_get session_id)" > "$session_log"
}

# ============================================================================
# CONFIGURATION VALIDATION
# ============================================================================

# Validate configuration integrity
_config_validate() {
    local issues=0
    
    echo "🔧 Validating configuration..."
    
    # Check required directories
    local home_dir="$(_config_get home)"
    if [[ ! -d "$home_dir" ]]; then
        echo "❌ Home directory missing: $home_dir"
        ((issues++))
    fi
    
    # Check write permissions
    if [[ ! -w "$home_dir" ]]; then
        echo "❌ No write permission to: $home_dir"
        ((issues++))
    fi
    
    # Check configuration file
    local config_file="$home_dir/config/dotfiles.conf"
    if [[ -f "$config_file" && ! -r "$config_file" ]]; then
        echo "❌ Cannot read configuration file: $config_file"
        ((issues++))
    fi
    
    if [[ $issues -eq 0 ]]; then
        echo "✅ Configuration validation passed"
    else
        echo "❌ Configuration validation failed with $issues issues"
        return 1
    fi
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export configuration functions
export -f _config_init
export -f _config_get
export -f _config_set
export -f _config_save
export -f _config_load_user_config
export -f _config_init_ai_providers
export -f _config_get_ai_provider
export -f _config_get_ai_provider_info
export -f _config_get_session_file
export -f _config_get_session_log
export -f _config_get_timestamp
export -f _config_get_duration
export -f _config_setup_environment
export -f _config_validate