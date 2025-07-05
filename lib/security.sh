#!/usr/bin/env bash
# Security functions

# Sanitize input to prevent command injection
sanitize_input() {
    local input="$1"
    local allow_spaces="${2:-false}"
    
    # Remove dangerous characters
    if [[ "$allow_spaces" == "true" ]]; then
        # Allow spaces but remove other dangerous chars
        input=$(echo "$input" | sed 's/[;&|`$(){}[\]\\<>]//g')
    else
        # Remove all potentially dangerous characters including spaces
        input=$(echo "$input" | sed 's/[;&|`$(){}[\]\\<>[:space:]]//g')
    fi
    
    # Limit length
    if [[ ${#input} -gt $DOTFILES_MAX_INPUT_LENGTH ]]; then
        input="${input:0:$DOTFILES_MAX_INPUT_LENGTH}"
    fi
    
    echo "$input"
}

# Validate input against pattern
validate_input() {
    local input="$1"
    local pattern="${2:-^[a-zA-Z0-9_.-]+$}"
    
    if [[ "$input" =~ $pattern ]]; then
        return 0
    else
        return 1
    fi
}

# Execute command safely without eval
safe_execute() {
    local cmd="$1"
    shift
    
    # Verify command exists
    if ! command_exists "$cmd"; then
        log_error "Command not found: $cmd"
        return 1
    fi
    
    # Execute without eval
    "$cmd" "$@"
}

# Validate file path (no directory traversal)
validate_path() {
    local path="$1"
    local base_dir="${2:-$DOTFILES_PLUS_HOME}"
    
    # Resolve to absolute path
    local abs_path
    abs_path=$(cd "$(dirname "$path")" 2>/dev/null && pwd)/$(basename "$path") || return 1
    
    # Check if within allowed directory
    [[ "$abs_path" == "$base_dir"/* ]]
}

# Generate secure random string
generate_id() {
    local length="${1:-8}"
    if command_exists openssl; then
        openssl rand -hex "$length" 2>/dev/null
    else
        # Fallback to /dev/urandom
        tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c "$length"
    fi
}

# Hash sensitive data
hash_data() {
    local data="$1"
    if command_exists sha256sum; then
        echo -n "$data" | sha256sum | cut -d' ' -f1
    elif command_exists shasum; then
        echo -n "$data" | shasum -a 256 | cut -d' ' -f1
    else
        # Simple fallback (not cryptographically secure)
        echo -n "$data" | cksum | cut -d' ' -f1
    fi
}

# Check if running as root
is_root() {
    [[ $EUID -eq 0 ]]
}

# Ensure not running as root
ensure_not_root() {
    if is_root; then
        log_error "Do not run as root"
        exit 1
    fi
}