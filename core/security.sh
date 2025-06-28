#!/usr/bin/env bash
# 🔒 Security Core Module - Input Sanitization & Safe Operations
# Addresses critical command injection vulnerabilities

# ============================================================================
# INPUT SANITIZATION FUNCTIONS
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
    local cmd_array=("$@")
    local cmd_name="${cmd_array[0]}"
    
    # Verify command exists and is executable
    if ! command -v "$cmd_name" >/dev/null 2>&1; then
        echo "❌ Command not found: $cmd_name" >&2
        return 1
    fi
    
    # Execute command safely without eval
    "${cmd_array[@]}" 2>/dev/null || {
        echo "❌ Command execution failed: $cmd_name" >&2
        return 1
    }
}

# ============================================================================
# SECURE AI PROVIDER EXECUTION
# ============================================================================

# Safe AI provider execution (replaces dangerous eval)
_secure_ai_execute() {
    local provider_cmd="$1"
    local query="$2"
    
    # Sanitize the query
    local safe_query
    safe_query=$(_secure_sanitize_input "$query" "true")
    [[ $? -ne 0 ]] && return 1
    
    # Validate provider command
    local safe_cmd
    safe_cmd=$(_secure_validate_input "$provider_cmd" "^[a-zA-Z0-9_-]+$")
    [[ $? -ne 0 ]] && return 1
    
    # Build command array safely
    case "$provider_cmd" in
        claude)
            _secure_execute_command "$safe_cmd" "$safe_query"
            ;;
        gemini)
            _secure_execute_command "$safe_cmd" "-p" "$safe_query"
            ;;
        opencode)
            _secure_execute_command "$safe_cmd" "$safe_query"
            ;;
        *)
            echo "❌ Unsupported AI provider: $provider_cmd" >&2
            return 1
            ;;
    esac
}

# ============================================================================
# SECURE LAZY LOADING SYSTEM
# ============================================================================

# Secure lazy loading without eval
declare -A SECURE_LOADED_MODULES
declare -A SECURE_MODULE_FUNCTIONS

# Register a module with its loading function
_secure_register_module() {
    local module_name="$1"
    local load_function="$2"
    
    # Validate module name
    local safe_module
    safe_module=$(_secure_validate_input "$module_name" "^[a-zA-Z0-9_-]+$")
    [[ $? -ne 0 ]] && return 1
    
    # Validate function name
    local safe_function
    safe_function=$(_secure_validate_input "$load_function" "^[a-zA-Z0-9_-]+$")
    [[ $? -ne 0 ]] && return 1
    
    SECURE_MODULE_FUNCTIONS["$safe_module"]="$safe_function"
}

# Secure lazy loading
_secure_lazy_load() {
    local module="$1"
    
    # Validate module name
    local safe_module
    safe_module=$(_secure_validate_input "$module" "^[a-zA-Z0-9_-]+$")
    [[ $? -ne 0 ]] && return 1
    
    if [[ -z "${SECURE_LOADED_MODULES[$safe_module]}" ]]; then
        local load_func="${SECURE_MODULE_FUNCTIONS[$safe_module]}"
        
        if [[ -n "$load_func" ]] && declare -f "$load_func" >/dev/null; then
            local start_time=$(date +%s%3N 2>/dev/null || date +%s)
            
            # Call function directly instead of eval
            "$load_func"
            local result=$?
            
            local end_time=$(date +%s%3N 2>/dev/null || date +%s)
            local duration=$((end_time - start_time))
            
            if [[ $result -eq 0 ]]; then
                SECURE_LOADED_MODULES["$safe_module"]=1
                _secure_perf_log "lazy_load_$safe_module" "${duration}ms"
            fi
            
            return $result
        else
            echo "❌ Module loading function not found: $load_func" >&2
            return 1
        fi
    fi
    
    return 0
}

# ============================================================================
# SECURE SCRIPT VERIFICATION
# ============================================================================

# Verify downloaded scripts with checksums
_secure_verify_script() {
    local script_url="$1"
    local expected_checksum="$2"
    local script_file="$3"
    
    # Validate URL format
    if [[ ! "$script_url" =~ ^https:// ]]; then
        echo "❌ Only HTTPS URLs are allowed" >&2
        return 1
    fi
    
    # Download script to temporary file
    local temp_script=$(mktemp)
    if ! curl -fsSL "$script_url" -o "$temp_script"; then
        rm -f "$temp_script"
        echo "❌ Failed to download script from $script_url" >&2
        return 1
    fi
    
    # Verify checksum if provided
    if [[ -n "$expected_checksum" ]]; then
        local actual_checksum
        if command -v sha256sum >/dev/null 2>&1; then
            actual_checksum=$(sha256sum "$temp_script" | cut -d' ' -f1)
        elif command -v shasum >/dev/null 2>&1; then
            actual_checksum=$(shasum -a 256 "$temp_script" | cut -d' ' -f1)
        else
            echo "❌ No checksum utility available" >&2
            rm -f "$temp_script"
            return 1
        fi
        
        if [[ "$actual_checksum" != "$expected_checksum" ]]; then
            echo "❌ Checksum verification failed" >&2
            echo "   Expected: $expected_checksum" >&2
            echo "   Actual:   $actual_checksum" >&2
            rm -f "$temp_script"
            return 1
        fi
        
        echo "✅ Checksum verified successfully"
    else
        echo "⚠️  Warning: No checksum provided for verification"
    fi
    
    # Move verified script to destination
    mv "$temp_script" "$script_file"
    echo "✅ Script downloaded and verified: $script_file"
}

# ============================================================================
# SECURE PERFORMANCE LOGGING
# ============================================================================

# Secure performance logging
_secure_perf_log() {
    local event="$1"
    local duration="$2"
    
    # Sanitize event name
    local safe_event
    safe_event=$(_secure_sanitize_input "$event")
    [[ $? -ne 0 ]] && return 1
    
    # Sanitize duration
    local safe_duration
    safe_duration=$(_secure_sanitize_input "$duration")
    [[ $? -ne 0 ]] && return 1
    
    local log_file="${DOTFILES_PLUS_PERF_LOG:-$HOME/.dotfiles-plus/performance.log}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Ensure log directory exists
    mkdir -p "$(dirname "$log_file")"
    
    # Write log entry safely
    printf "%s|%s|%s\n" "$timestamp" "$safe_event" "$safe_duration" >> "$log_file"
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export secure functions for use by other modules
export -f _secure_sanitize_input
export -f _secure_validate_input
export -f _secure_execute_command
export -f _secure_ai_execute
export -f _secure_register_module
export -f _secure_lazy_load
export -f _secure_verify_script
export -f _secure_perf_log