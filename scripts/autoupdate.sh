#!/usr/bin/env bash
# 🔄 Dotfiles Plus - Auto Update System
# Handles automatic updates for Dotfiles Plus

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_HOME="${DOTFILES_HOME:-$HOME/.dotfiles-plus}"
UPDATE_CHECK_FILE="$DOTFILES_HOME/.last_update_check"
UPDATE_INTERVAL=${DOTFILES_UPDATE_INTERVAL:-86400} # 24 hours default
GITHUB_API="https://api.github.com/repos/anivar/dotfiles-plus/releases/latest"

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️  INFO${NC}: $*"
}

log_success() {
    echo -e "${GREEN}✅ SUCCESS${NC}: $*"
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING${NC}: $*"
}

log_error() {
    echo -e "${RED}❌ ERROR${NC}: $*"
}

# Get current version
get_current_version() {
    if [[ -f "$DOTFILES_HOME/VERSION" ]]; then
        cat "$DOTFILES_HOME/VERSION"
    else
        echo "unknown"
    fi
}

# Check if update check is needed
should_check_update() {
    # Check if auto-update is disabled
    if [[ "${DOTFILES_AUTO_UPDATE:-true}" == "false" ]]; then
        return 1
    fi

    # Check last update time
    if [[ -f "$UPDATE_CHECK_FILE" ]]; then
        local last_check=$(cat "$UPDATE_CHECK_FILE" 2>/dev/null || echo 0)
        local now=$(date +%s)
        local diff=$((now - last_check))
        
        if [[ $diff -lt $UPDATE_INTERVAL ]]; then
            return 1
        fi
    fi
    
    return 0
}

# ============================================================================
# UPDATE FUNCTIONS
# ============================================================================

# Check for updates
check_for_updates() {
    local current_version=$(get_current_version)
    
    # Get latest release info
    local latest_info
    if ! latest_info=$(curl -s "$GITHUB_API" 2>/dev/null); then
        log_error "Failed to check for updates"
        return 1
    fi
    
    # Parse version
    local latest_version=$(echo "$latest_info" | grep '"tag_name"' | cut -d'"' -f4 | sed 's/^v//')
    
    if [[ -z "$latest_version" ]]; then
        log_error "Could not determine latest version"
        return 1
    fi
    
    # Update check timestamp
    date +%s > "$UPDATE_CHECK_FILE"
    
    # Compare versions
    if [[ "$latest_version" == "$current_version" ]]; then
        return 1  # No update needed
    fi
    
    echo "$latest_version"
    return 0
}

# Perform the actual update
perform_update() {
    local new_version="$1"
    local current_version=$(get_current_version)
    
    log_info "Updating from v$current_version to v$new_version..."
    
    # Create backup
    local backup_dir="$DOTFILES_HOME/backups/pre-update-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    
    log_info "Creating backup..."
    cp -r "$DOTFILES_HOME"/* "$backup_dir/" 2>/dev/null || true
    
    # Download and install update
    local temp_dir="/tmp/dotfiles-plus-update-$$"
    mkdir -p "$temp_dir"
    
    log_info "Downloading v$new_version..."
    if curl -sL "https://github.com/anivar/dotfiles-plus/archive/refs/tags/v$new_version.tar.gz" | tar -xz -C "$temp_dir"; then
        # Copy files
        log_info "Installing update..."
        cp -r "$temp_dir/dotfiles-plus-$new_version"/* "$DOTFILES_HOME/" 2>/dev/null || {
            log_error "Failed to copy update files"
            return 1
        }
        
        # Update VERSION file
        echo "$new_version" > "$DOTFILES_HOME/VERSION"
        
        # Clean up
        rm -rf "$temp_dir"
        
        log_success "Update complete!"
        echo ""
        echo "☕ Enjoying Dotfiles Plus? Support the project:"
        echo "   https://buymeacoffee.com/anivar"
        echo ""
        echo "Please restart your shell or run: source ~/.dotfiles-plus/dotfiles-plus.sh"
        
        return 0
    else
        log_error "Failed to download update"
        rm -rf "$temp_dir"
        return 1
    fi
}

# Interactive update prompt
prompt_for_update() {
    local new_version="$1"
    local current_version=$(get_current_version)
    
    echo ""
    echo "🔄 Update Available!"
    echo "Current version: v$current_version"
    echo "New version:     v$new_version"
    echo ""
    echo -n "Would you like to update now? [Y/n] "
    read -r response
    
    if [[ ! "$response" =~ ^[Nn]$ ]]; then
        perform_update "$new_version"
    else
        log_info "Update skipped. Run 'dotfiles update' to update manually."
    fi
}

# ============================================================================
# MAIN FUNCTIONS
# ============================================================================

# Manual update command
manual_update() {
    log_info "Checking for updates..."
    
    if new_version=$(check_for_updates); then
        prompt_for_update "$new_version"
    else
        log_success "Already up to date!"
    fi
}

# Auto update check (silent unless update available)
auto_update_check() {
    if ! should_check_update; then
        return 0
    fi
    
    if new_version=$(check_for_updates); then
        # Only prompt if running interactively
        if [[ -t 1 ]]; then
            prompt_for_update "$new_version"
        else
            log_info "Update available: v$new_version. Run 'dotfiles update' to update."
        fi
    fi
}

# ============================================================================
# ENTRY POINT
# ============================================================================

# Determine mode
case "${1:-auto}" in
    manual)
        manual_update
        ;;
    auto)
        auto_update_check
        ;;
    check)
        if new_version=$(check_for_updates); then
            echo "Update available: v$new_version"
            exit 0
        else
            echo "Already up to date"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 [manual|auto|check]"
        exit 1
        ;;
esac