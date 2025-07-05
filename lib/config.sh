#!/usr/bin/env bash
# Configuration management

# Initialize configuration system
config_init() {
    # Create directory structure
    ensure_dir "$DOTFILES_CONFIG_DIR"
    ensure_dir "$DOTFILES_MEMORY_DIR"
    ensure_dir "$DOTFILES_CONTEXT_DIR"
    ensure_dir "$DOTFILES_TEMPLATE_DIR"
    ensure_dir "$DOTFILES_BACKUP_DIR"
    ensure_dir "$DOTFILES_CACHE_DIR"
    ensure_dir "$DOTFILES_LOG_DIR"
    
    # Create default config if not exists
    if [[ ! -f "$DOTFILES_CONFIG_FILE" ]]; then
        config_create_default
    fi
    
    # Load user config if exists
    if [[ -f "$DOTFILES_USER_CONFIG" ]]; then
        # shellcheck source=/dev/null
        source "$DOTFILES_USER_CONFIG"
    fi
}

# Create default configuration
config_create_default() {
    cat > "$DOTFILES_CONFIG_FILE" << EOF
# Dotfiles Plus Configuration
# Generated: $(timestamp)

# Version
version=$DOTFILES_PLUS_VERSION

# System info
platform=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
shell=$(basename "$SHELL")

# Settings
memory_max_age=$DOTFILES_MAX_MEMORY_AGE
memory_max_count=$DOTFILES_MAX_MEMORY_COUNT
cache_ttl=$DOTFILES_CACHE_TTL

# Features
enable_ai=true
enable_git_enhanced=true
enable_auto_update_check=true
enable_hints=true
EOF
}

# Get config value
config_get() {
    local key="$1"
    local default="${2:-}"
    
    # First check environment variable
    local env_var="DOTFILES_PLUS_${key^^}"
    if [[ -n "${!env_var:-}" ]]; then
        echo "${!env_var}"
        return
    fi
    
    # Then check config file
    if [[ -f "$DOTFILES_CONFIG_FILE" ]]; then
        local value
        value=$(grep "^${key}=" "$DOTFILES_CONFIG_FILE" 2>/dev/null | cut -d'=' -f2-)
        if [[ -n "$value" ]]; then
            echo "$value"
            return
        fi
    fi
    
    # Return default
    echo "$default"
}

# Set config value
config_set() {
    local key="$1"
    local value="$2"
    
    # Update or add to config file
    if grep -q "^${key}=" "$DOTFILES_CONFIG_FILE" 2>/dev/null; then
        # Update existing
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/^${key}=.*/${key}=${value}/" "$DOTFILES_CONFIG_FILE"
        else
            sed -i "s/^${key}=.*/${key}=${value}/" "$DOTFILES_CONFIG_FILE"
        fi
    else
        # Add new
        echo "${key}=${value}" >> "$DOTFILES_CONFIG_FILE"
    fi
}

# List all config values
config_list() {
    if [[ -f "$DOTFILES_CONFIG_FILE" ]]; then
        cat "$DOTFILES_CONFIG_FILE" | grep -v '^#' | grep -v '^$'
    fi
}

# Reset to defaults
config_reset() {
    log_warning "Resetting configuration to defaults..."
    rm -f "$DOTFILES_CONFIG_FILE"
    config_create_default
    log_success "Configuration reset"
}