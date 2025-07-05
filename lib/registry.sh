#!/usr/bin/env bash
# Registry library - Command and alias management

# ============================================================================
# COMMAND REGISTRY
# ============================================================================

# Register a command
command_register() {
    local name="$1"
    local handler="$2"
    local description="${3:-No description}"
    
    # Validate inputs
    if [[ -z "$name" ]] || [[ -z "$handler" ]]; then
        log error "Command registration requires name and handler"
        return 1
    fi
    
    # Store in registry
    DOTFILES_COMMANDS["$name"]="$handler:$description"
    
    log debug "Registered command: $name -> $handler"
}

# Get command handler
command_get() {
    local name="$1"
    local info="${DOTFILES_COMMANDS[$name]}"
    
    if [[ -n "$info" ]]; then
        echo "${info%%:*}"
    else
        return 1
    fi
}

# List all commands
command_list() {
    echo "📋 Registered Commands"
    echo "━━━━━━━━━━━━━━━━━━━"
    
    for cmd in "${!DOTFILES_COMMANDS[@]}"; do
        local info="${DOTFILES_COMMANDS[$cmd]}"
        local handler="${info%%:*}"
        local desc="${info#*:}"
        
        printf "  %-20s %s\n" "$cmd" "$desc"
    done | sort
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# ALIAS REGISTRY
# ============================================================================

# Register an alias
alias_register() {
    local name="$1"
    local expansion="$2"
    local description="${3:-}"
    
    # Create alias
    alias "$name=$expansion"
    
    # Store in registry
    DOTFILES_ALIASES["$name"]="$expansion:$description"
    
    log debug "Registered alias: $name -> $expansion"
}

# List all aliases
alias_list() {
    echo "🔗 Registered Aliases"
    echo "━━━━━━━━━━━━━━━━━━"
    
    for als in "${!DOTFILES_ALIASES[@]}"; do
        local info="${DOTFILES_ALIASES[$als]}"
        local expansion="${info%%:*}"
        local desc="${info#*:}"
        
        printf "  %-20s = %s\n" "$als" "$expansion"
        [[ -n "$desc" ]] && printf "  %-20s   %s\n" "" "$desc"
    done | sort
}

# ============================================================================
# PLUGIN REGISTRY
# ============================================================================

# Check if plugin is loaded
plugin_loaded() {
    local name="$1"
    [[ -n "${DOTFILES_PLUGINS[$name]}" ]]
}

# Get plugin info
plugin_info() {
    local name="$1"
    echo "${DOTFILES_PLUGINS[$name]}"
}

# List all plugins
plugin_list() {
    echo "🔌 Loaded Plugins"
    echo "━━━━━━━━━━━━━━━"
    
    for plugin in "${!DOTFILES_PLUGINS[@]}"; do
        local file="${DOTFILES_PLUGINS[$plugin]}"
        echo "  • $plugin ($file)"
    done | sort
}