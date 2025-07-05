#!/usr/bin/env bash
# Hook system - Event-driven automation

# ============================================================================
# HOOK MANAGEMENT
# ============================================================================

# Register a hook
hook_register() {
    local event="$1"
    local handler="$2"
    local priority="${3:-50}"
    
    # Validate inputs
    if [[ -z "$event" ]] || [[ -z "$handler" ]]; then
        log error "Hook registration requires event and handler"
        return 1
    fi
    
    # Create hook entry
    local hook_id="${event}_${handler}_${priority}"
    DOTFILES_HOOKS["$hook_id"]="$event:$handler:$priority"
    
    log debug "Registered hook: $event -> $handler (priority: $priority)"
}

# Run hooks for an event
hook_run() {
    local event="$1"
    shift
    local args=("$@")
    
    local executed=0
    
    # Find and sort hooks by priority
    for hook_id in "${!DOTFILES_HOOKS[@]}"; do
        local hook_info="${DOTFILES_HOOKS[$hook_id]}"
        local hook_event="${hook_info%%:*}"
        
        if [[ "$hook_event" == "$event" ]]; then
            local remaining="${hook_info#*:}"
            local handler="${remaining%%:*}"
            local priority="${remaining#*:}"
            
            # Execute handler if it exists
            if command_exists "$handler"; then
                log debug "Running hook: $handler for event: $event"
                "$handler" "${args[@]}"
                ((executed++))
            fi
        fi
    done | sort -t: -k3 -n  # Sort by priority
    
    return 0
}

# List all hooks
hook_list() {
    echo "🪝 Registered Hooks"
    echo "━━━━━━━━━━━━━━━━━"
    
    # Group by event
    local current_event=""
    
    for hook_id in $(printf '%s\n' "${!DOTFILES_HOOKS[@]}" | sort); do
        local hook_info="${DOTFILES_HOOKS[$hook_id]}"
        local event="${hook_info%%:*}"
        local remaining="${hook_info#*:}"
        local handler="${remaining%%:*}"
        local priority="${remaining#*:}"
        
        if [[ "$event" != "$current_event" ]]; then
            [[ -n "$current_event" ]] && echo ""
            echo "Event: $event"
            current_event="$event"
        fi
        
        printf "  [%3d] %s\n" "$priority" "$handler"
    done
}

# Remove a hook
hook_remove() {
    local event="$1"
    local handler="$2"
    
    for hook_id in "${!DOTFILES_HOOKS[@]}"; do
        local hook_info="${DOTFILES_HOOKS[$hook_id]}"
        local hook_event="${hook_info%%:*}"
        local remaining="${hook_info#*:}"
        local hook_handler="${remaining%%:*}"
        
        if [[ "$hook_event" == "$event" ]] && [[ "$hook_handler" == "$handler" ]]; then
            unset DOTFILES_HOOKS["$hook_id"]
            log debug "Removed hook: $event -> $handler"
            return 0
        fi
    done
    
    return 1
}

# ============================================================================
# COMMON HOOK POINTS
# ============================================================================

# Directory change hook
hook_directory_changed() {
    local old_dir="$1"
    local new_dir="$2"
    
    hook_run "directory_changed" "$old_dir" "$new_dir"
}

# Command execution hooks
hook_pre_command() {
    local cmd="$1"
    hook_run "pre_command" "$cmd"
}

hook_post_command() {
    local cmd="$1"
    local exit_code="$2"
    hook_run "post_command" "$cmd" "$exit_code"
}

# Error hook
hook_error() {
    local error_msg="$1"
    local exit_code="$2"
    hook_run "error" "$error_msg" "$exit_code"
}

# ============================================================================
# HOOK INTEGRATION
# ============================================================================

# Setup directory change detection
if [[ -n "$ZSH_VERSION" ]]; then
    # Zsh: use chpwd hook
    chpwd() {
        hook_directory_changed "$OLDPWD" "$PWD"
    }
elif [[ -n "$BASH_VERSION" ]]; then
    # Bash: override cd
    cd() {
        local old_dir="$PWD"
        builtin cd "$@"
        local result=$?
        [[ $result -eq 0 ]] && hook_directory_changed "$old_dir" "$PWD"
        return $result
    }
fi