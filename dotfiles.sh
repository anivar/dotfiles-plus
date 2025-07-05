#!/usr/bin/env bash
# 🚀 Dotfiles Plus - Unified Architecture
# Version: 2.0.0
# Revolutionary plugin-based system with smart routing
# Requires: Bash 5.0+ or Zsh

# ============================================================================
# CORE ENGINE
# ============================================================================

# Detect shell and set compatibility mode
if [[ -n "${BASH_VERSION:-}" ]]; then
    DOTFILES_SHELL="bash"
    DOTFILES_SHELL_VERSION="${BASH_VERSION%%.*}"
elif [[ -n "${ZSH_VERSION:-}" ]]; then
    DOTFILES_SHELL="zsh"
    DOTFILES_SHELL_VERSION="${ZSH_VERSION}"
else
    echo "❌ Unsupported shell. Requires Bash 5+ or Zsh."
    return 1
fi

# Ensure Bash 5+ if using Bash
if [[ "$DOTFILES_SHELL" == "bash" ]] && [[ "$DOTFILES_SHELL_VERSION" -lt 5 ]]; then
    echo "❌ Bash 5.0+ required. Found: $BASH_VERSION"
    echo "💡 macOS: brew install bash && chsh -s \$(brew --prefix)/bin/bash"
    return 1
fi

# ============================================================================
# SMART INITIALIZATION
# ============================================================================

# Core paths
export DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
export DOTFILES_HOME="${DOTFILES_HOME:-$HOME/.dotfiles-plus}"
export DOTFILES_VERSION="2.0.0"

# Create modular structure
mkdir -p "$DOTFILES_HOME"/{config,plugins,hooks,state,cache} 2>/dev/null

# ============================================================================
# PLUGIN SYSTEM
# ============================================================================

declare -A DOTFILES_PLUGINS
declare -A DOTFILES_COMMANDS
declare -A DOTFILES_ALIASES
declare -A DOTFILES_HOOKS

# Register a plugin
plugin_register() {
    local name="$1"
    local path="$2"
    local priority="${3:-50}"
    
    DOTFILES_PLUGINS[$name]="$path:$priority"
}

# Register a command
command_register() {
    local cmd="$1"
    local handler="$2"
    local description="${3:-}"
    
    DOTFILES_COMMANDS[$cmd]="$handler:$description"
}

# Register an alias
alias_register() {
    local name="$1"
    local expansion="$2"
    
    DOTFILES_ALIASES[$name]="$expansion"
    alias "$name"="$expansion"
}

# Register a hook
hook_register() {
    local event="$1"
    local handler="$2"
    local priority="${3:-50}"
    
    local current="${DOTFILES_HOOKS[$event]:-}"
    DOTFILES_HOOKS[$event]="$current|$handler:$priority"
}

# Run hooks for an event
hook_run() {
    local event="$1"
    shift
    
    local hooks="${DOTFILES_HOOKS[$event]:-}"
    if [[ -n "$hooks" ]]; then
        # Sort by priority and execute
        echo "$hooks" | tr '|' '\n' | grep -v '^$' | sort -t: -k2 -n | while IFS=: read -r handler priority; do
            if [[ -n "$handler" ]] && type "$handler" &>/dev/null; then
                "$handler" "$@"
            fi
        done
    fi
}

# ============================================================================
# UNIFIED COMMAND INTERFACE
# ============================================================================

# Main command router
dotfiles() {
    local cmd="${1:-help}"
    shift || true
    
    # Check for registered command
    if [[ -n "${DOTFILES_COMMANDS[$cmd]}" ]]; then
        local handler="${DOTFILES_COMMANDS[$cmd]%%:*}"
        hook_run "before_command" "$cmd" "$@"
        "$handler" "$@"
        local result=$?
        hook_run "after_command" "$cmd" "$@"
        return $result
    else
        echo "❌ Unknown command: $cmd"
        echo "💡 Try: dotfiles help"
        return 1
    fi
}

# Smart AI command with auto-routing
ai() {
    # Special handling for AI - if first arg looks like a command, route it
    local first="${1:-}"
    
    if [[ -n "${DOTFILES_COMMANDS[ai_$first]}" ]]; then
        # It's an AI subcommand
        shift
        dotfiles "ai_$first" "$@"
    else
        # It's a query
        dotfiles ai_query "$@"
    fi
}

# Command routing helper
dotfiles_route() {
    local cmd="$1"
    shift
    
    # Look up handler
    local handler_info="${DOTFILES_COMMANDS[$cmd]:-}"
    if [[ -n "$handler_info" ]]; then
        local handler="${handler_info%%:*}"
        "$handler" "$@"
    else
        return 1
    fi
}

# Lazy load plugin feature
lazy_load_plugin() {
    local name="$1"
    local file="$2"
    local commands=("${@:3}")
    
    # Create stub commands that load plugin on first use
    for cmd in "${commands[@]}"; do
        eval "
        $cmd() {
            # Load the plugin
            if [[ -f '$file' ]]; then
                source '$file'
                # Call the real command
                $cmd \"\$@\"
            else
                echo '❌ Plugin not found: $name'
                return 1
            fi
        }
        "
    done
}

# ============================================================================
# CORE PLUGINS LOADER
# ============================================================================

# Load a plugin
plugin_load() {
    local name="$1"
    local plugin_info="${DOTFILES_PLUGINS[$name]:-}"
    
    if [[ -z "$plugin_info" ]]; then
        return 1
    fi
    
    local path="${plugin_info%%:*}"
    
    if [[ -f "$path" ]]; then
        source "$path"
        hook_run "plugin_loaded" "$name"
        return 0
    else
        return 1
    fi
}

# Auto-discover and register plugins
plugin_discover() {
    local plugin_dir="$DOTFILES_ROOT/plugins"
    
    if [[ -d "$plugin_dir" ]]; then
        for plugin in "$plugin_dir"/*.plugin.sh; do
            if [[ -f "$plugin" ]]; then
                local name=$(basename "$plugin" .plugin.sh)
                plugin_register "$name" "$plugin"
            fi
        done
    fi
}

# ============================================================================
# LAZY LOADING SYSTEM
# ============================================================================

# Create lazy-loaded function
lazy_load() {
    local func="$1"
    local plugin="$2"
    
    eval "$func() {
        plugin_load '$plugin' && $func \"\$@\"
    }"
}

# ============================================================================
# BOOTSTRAP
# ============================================================================

# Load core library
source "$DOTFILES_ROOT/lib/core.sh"

# Discover plugins
plugin_discover

# Load essential plugins
plugin_load "config"
plugin_load "security"
plugin_load "ai"
plugin_load "git"

# Setup lazy loading for heavy features
lazy_load "ai_think" "ai_think"
lazy_load "ai_import" "ai_import"
lazy_load "dotfiles_migrate" "migrate"
lazy_load "dotfiles_bootstrap" "bootstrap"

# Initialize
hook_run "init"

# First run check
if [[ ! -f "$DOTFILES_HOME/.initialized" ]]; then
    dotfiles setup
    touch "$DOTFILES_HOME/.initialized"
fi

# ============================================================================
# SMART FEATURES
# ============================================================================

# Intelligent command not found handler
if [[ "$DOTFILES_SHELL" == "bash" ]]; then
    command_not_found_handle() {
        local cmd="$1"
        shift
        
        # Check if it's a dotfiles command
        if [[ -n "${DOTFILES_COMMANDS[${cmd#dotfiles_}]}" ]]; then
            dotfiles "${cmd#dotfiles_}" "$@"
        else
            # AI suggestion
            if command_exists ai; then
                echo "❌ Command not found: $cmd"
                echo "💡 Asking AI for suggestions..."
                ai "what is the command to $cmd $*"
            else
                echo "bash: $cmd: command not found"
            fi
        fi
    }
elif [[ "$DOTFILES_SHELL" == "zsh" ]]; then
    command_not_found_handler() {
        local cmd="$1"
        # Similar implementation for zsh
        command_not_found_handle "$@"
    }
fi

# ============================================================================
# CONTEXTUAL AWARENESS
# ============================================================================

# Auto-detect context on directory change
if [[ "$DOTFILES_SHELL" == "bash" ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}hook_run 'directory_changed' \"\$PWD\""
elif [[ "$DOTFILES_SHELL" == "zsh" ]]; then
    chpwd() {
        hook_run "directory_changed" "$PWD"
    }
fi

# ============================================================================
# USER INTERFACE
# ============================================================================

# Enhanced prompt with context
if [[ "${DOTFILES_PROMPT_ENHANCED:-true}" == "true" ]]; then
    hook_register "directory_changed" "update_prompt_context"
fi

# Status line
dotfiles_status() {
    local quiet="${1:-}"
    
    if [[ "$quiet" != "--quiet" ]]; then
        echo "🚀 Dotfiles Plus v$DOTFILES_VERSION"
        
        # AI status
        local ai_status="❌ Not configured"
        if command_exists ai; then
            ai_status="✅ Ready"
        fi
        echo "🤖 AI: $ai_status"
        
        # Plugin count
        echo "🔌 Plugins: ${#DOTFILES_PLUGINS[@]} loaded"
        
        # Memory status
        if [[ -f "$DOTFILES_HOME/state/memories.db" ]]; then
            local mem_count=$(wc -l < "$DOTFILES_HOME/state/memories.db")
            echo "🧠 Memories: $mem_count"
        fi
    fi
}

# Register core commands
command_register "help" "dotfiles_help" "Show help"
command_register "status" "dotfiles_status" "Show status"
command_register "setup" "dotfiles_setup" "Run setup wizard"
command_register "update" "dotfiles_update" "Update to latest"
command_register "reload" "dotfiles_reload" "Reload configuration"

# Compatibility layer for existing commands
alias ai-setup='dotfiles setup_ai'
alias ai-test='dotfiles test_ai'

# ============================================================================
# WELCOME
# ============================================================================

# Show status on load (if interactive)
if [[ -t 1 ]] && [[ "${DOTFILES_QUIET:-}" != "true" ]]; then
    dotfiles_status --quiet
fi