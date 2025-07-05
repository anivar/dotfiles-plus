#!/usr/bin/env bash
# Constants and global variables

# Version info
readonly DOTFILES_PLUS_NAME="Dotfiles Plus"
readonly DOTFILES_PLUS_AUTHOR="anivar"
readonly DOTFILES_PLUS_REPO="https://github.com/anivar/dotfiles-plus"

# Directories
readonly DOTFILES_CONFIG_DIR="${DOTFILES_PLUS_HOME}/config"
readonly DOTFILES_MEMORY_DIR="${DOTFILES_PLUS_HOME}/memory"
readonly DOTFILES_CONTEXT_DIR="${DOTFILES_PLUS_HOME}/contexts"
readonly DOTFILES_TEMPLATE_DIR="${DOTFILES_PLUS_HOME}/templates"
readonly DOTFILES_BACKUP_DIR="${DOTFILES_PLUS_HOME}/backups"
readonly DOTFILES_CACHE_DIR="${DOTFILES_PLUS_HOME}/cache"
readonly DOTFILES_LOG_DIR="${DOTFILES_PLUS_HOME}/logs"

# Files
readonly DOTFILES_CONFIG_FILE="${DOTFILES_CONFIG_DIR}/dotfiles.conf"
readonly DOTFILES_USER_CONFIG="${DOTFILES_CONFIG_DIR}/user.conf"
readonly DOTFILES_MEMORY_FILE="${DOTFILES_MEMORY_DIR}/memories.txt"
readonly DOTFILES_LOG_FILE="${DOTFILES_LOG_DIR}/dotfiles.log"

# Limits
readonly DOTFILES_MAX_MEMORY_AGE=30  # days
readonly DOTFILES_MAX_MEMORY_COUNT=1000
readonly DOTFILES_MAX_INPUT_LENGTH=1000
readonly DOTFILES_CACHE_TTL=3600  # seconds

# Colors
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_MAGENTA='\033[0;35m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_RESET='\033[0m'

# Icons
readonly ICON_SUCCESS="✅"
readonly ICON_ERROR="❌"
readonly ICON_WARNING="⚠️"
readonly ICON_INFO="ℹ️"
readonly ICON_AI="🤖"
readonly ICON_MEMORY="💾"
readonly ICON_ROCKET="🚀"