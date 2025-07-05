#!/usr/bin/env bash
# 🚀 Dotfiles Plus - Modular Architecture
# Version: 1.2.0
# Requirements: Bash 5.0+ or Zsh

# ============================================================================
# INITIALIZATION
# ============================================================================

# Strict mode
set -euo pipefail

# Get script directory
DOTFILES_PLUS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Core environment
export DOTFILES_PLUS_VERSION="1.2.0"
export DOTFILES_PLUS_ROOT
export DOTFILES_PLUS_HOME="${DOTFILES_PLUS_HOME:-$HOME/.dotfiles-plus}"
export DOTFILES_PLUS_SESSION_ID="session_$(date +%s)_$$"

# ============================================================================
# MODULE LOADER
# ============================================================================

# Load a module with error handling
load_module() {
    local module="$1"
    local module_path="${DOTFILES_PLUS_ROOT}/${module}"
    
    if [[ -f "$module_path" ]]; then
        # shellcheck source=/dev/null
        source "$module_path" || {
            echo "❌ Failed to load module: $module" >&2
            return 1
        }
    else
        echo "❌ Module not found: $module" >&2
        return 1
    fi
}

# Load all modules from a directory
load_modules_from() {
    local dir="$1"
    local pattern="${2:-*.sh}"
    
    if [[ -d "${DOTFILES_PLUS_ROOT}/${dir}" ]]; then
        for module in "${DOTFILES_PLUS_ROOT}/${dir}"/${pattern}; do
            if [[ -f "$module" ]]; then
                load_module "${dir}/$(basename "$module")"
            fi
        done
    fi
}

# ============================================================================
# CORE MODULES
# ============================================================================

# Load core modules first (order matters)
load_module "lib/constants.sh"
load_module "lib/utils.sh"
load_module "lib/security.sh"
load_module "lib/config.sh"
load_module "lib/logger.sh"

# ============================================================================
# FEATURE MODULES
# ============================================================================

# Load feature modules
load_modules_from "modules" "*.sh"

# ============================================================================
# INITIALIZATION COMPLETE
# ============================================================================

# Initialize configuration
dotfiles_init

# Show status if interactive
if [[ $- == *i* ]]; then
    dotfiles_status --quiet
fi