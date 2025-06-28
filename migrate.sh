#!/usr/bin/env bash
# 🔄 Migration Script - Upgrade from dotfiles-plus v2.1.0 to Secure v1.0
# Safely migrates all user data and configurations

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Migration configuration
OLD_HOME="$HOME/.dotfiles-plus"
NEW_HOME="$HOME/.dotfiles-plus"
BACKUP_DIR="$HOME/.dotfiles-plus-migration-backup-$(date +%Y%m%d-%H%M%S)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================================================
# LOGGING AND OUTPUT
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

# ============================================================================
# MIGRATION FUNCTIONS
# ============================================================================

check_prerequisites() {
    log_info "Checking migration prerequisites..."
    
    # Check if old version exists
    if [[ ! -d "$OLD_HOME" ]]; then
        log_error "No existing dotfiles-plus installation found at $OLD_HOME"
        log_info "This appears to be a fresh installation."
        return 1
    fi
    
    # Check for write permissions
    if [[ ! -w "$(dirname "$NEW_HOME")" ]]; then
        log_error "No write permission to $(dirname "$NEW_HOME")"
        return 1
    fi
    
    # Check disk space (rough estimate: need 2x current size)
    local current_size
    current_size=$(du -sm "$OLD_HOME" 2>/dev/null | cut -f1 || echo "10")
    local required_space=$((current_size * 2))
    local available_space
    available_space=$(df "$(dirname "$NEW_HOME")" | tail -1 | awk '{print int($4/1024)}')
    
    if [[ $available_space -lt $required_space ]]; then
        log_warning "Low disk space. Required: ${required_space}MB, Available: ${available_space}MB"
        echo -n "Continue anyway? [y/N] "
        read -r response
        [[ ! "$response" =~ ^[Yy]$ ]] && return 1
    fi
    
    log_success "Prerequisites check passed"
}

create_backup() {
    log_info "Creating full backup of existing installation..."
    
    if [[ -d "$OLD_HOME" ]]; then
        cp -r "$OLD_HOME" "$BACKUP_DIR"
        log_success "Backup created at $BACKUP_DIR"
    else
        log_warning "No existing installation to backup"
    fi
}

migrate_configuration() {
    log_info "Migrating configuration files..."
    
    # Migrate main configuration
    local old_config="$OLD_HOME/config"
    local new_config="$NEW_HOME/config"
    
    if [[ -d "$old_config" ]]; then
        mkdir -p "$new_config"
        
        # Migrate providers configuration
        if [[ -f "$old_config/providers.conf" ]]; then
            cp "$old_config/providers.conf" "$new_config/providers.conf"
            log_success "Migrated AI providers configuration"
        fi
        
        # Migrate version tracking
        if [[ -f "$old_config/version" ]]; then
            cp "$old_config/version" "$new_config/version.old"
            echo "1.0" > "$new_config/version"
            log_success "Updated version tracking"
        fi
        
        # Create new configuration file with migrated settings
        create_new_config_file
    fi
}

create_new_config_file() {
    local config_file="$NEW_HOME/config/dotfiles.conf"
    
    cat > "$config_file" << EOF
# Dotfiles Plus Configuration
# Migrated from v2.1.0 on $(date)

# Core settings
version=1.0
cache_ttl=3600
performance_logging=true

# Security settings
input_sanitization=true
script_verification=true
secure_lazy_loading=true

# Migration metadata
migrated_from=2.1.0
migration_date=$(date +%s)
backup_location=$BACKUP_DIR
EOF
    
    log_success "Created new configuration file"
}

migrate_sessions_and_contexts() {
    log_info "Migrating sessions and contexts..."
    
    # Migrate sessions
    if [[ -d "$OLD_HOME/sessions" ]]; then
        mkdir -p "$NEW_HOME/sessions"
        cp -r "$OLD_HOME/sessions/"* "$NEW_HOME/sessions/" 2>/dev/null || true
        log_success "Migrated session files"
    fi
    
    # Migrate contexts
    if [[ -d "$OLD_HOME/contexts" ]]; then
        mkdir -p "$NEW_HOME/contexts"
        cp -r "$OLD_HOME/contexts/"* "$NEW_HOME/contexts/" 2>/dev/null || true
        log_success "Migrated context files"
    fi
}

migrate_memory_and_data() {
    log_info "Migrating memory and user data..."
    
    # Migrate code memory
    if [[ -d "$OLD_HOME/memory" ]]; then
        mkdir -p "$NEW_HOME/memory"
        cp -r "$OLD_HOME/memory/"* "$NEW_HOME/memory/" 2>/dev/null || true
        log_success "Migrated code memory"
    fi
    
    # Migrate projects
    if [[ -d "$OLD_HOME/projects" ]]; then
        mkdir -p "$NEW_HOME/projects"
        cp -r "$OLD_HOME/projects/"* "$NEW_HOME/projects/" 2>/dev/null || true
        log_success "Migrated project configurations"
    fi
    
    # Migrate performance logs
    if [[ -d "$OLD_HOME/performance" ]]; then
        mkdir -p "$NEW_HOME/performance"
        cp -r "$OLD_HOME/performance/"* "$NEW_HOME/performance/" 2>/dev/null || true
        log_success "Migrated performance logs"
    fi
}

migrate_cache_and_local() {
    log_info "Migrating cache and local customizations..."
    
    # Create new cache directory (don't migrate old cache)
    mkdir -p "$NEW_HOME/cache"
    log_info "Created new cache directory (old cache not migrated for performance)"
    
    # Migrate local customizations
    if [[ -d "$OLD_HOME/local" ]]; then
        mkdir -p "$NEW_HOME/local"
        cp -r "$OLD_HOME/local/"* "$NEW_HOME/local/" 2>/dev/null || true
        log_success "Migrated local customizations"
    fi
    
    # Migrate backups
    if [[ -d "$OLD_HOME/backups" ]]; then
        mkdir -p "$NEW_HOME/backups"
        cp -r "$OLD_HOME/backups/"* "$NEW_HOME/backups/" 2>/dev/null || true
        log_success "Migrated backup files"
    fi
}

update_shell_configuration() {
    log_info "Updating shell configuration..."
    
    local shell_rc=""
    case "$(basename "$SHELL")" in
        bash)
            shell_rc="$HOME/.bashrc"
            ;;
        zsh)
            shell_rc="$HOME/.zshrc"
            ;;
        *)
            log_warning "Unknown shell: $SHELL. Manual configuration may be required."
            return
            ;;
    esac
    
    if [[ -f "$shell_rc" ]]; then
        # Create backup of shell configuration
        cp "$shell_rc" "${shell_rc}.backup-$(date +%Y%m%d-%H%M%S)"
        
        # Remove old dotfiles-plus source line
        sed -i.bak '/dotfiles-plus\.sh/d' "$shell_rc" 2>/dev/null || true
        sed -i.bak '/ai-dotfiles\.sh/d' "$shell_rc" 2>/dev/null || true
        
        # Add new secure dotfiles source line
        echo "" >> "$shell_rc"
        echo "# Dotfiles Plus v1.0 (migrated $(date))" >> "$shell_rc"
        echo "source \"$SCRIPT_DIR/secure-dotfiles.sh\"" >> "$shell_rc"
        
        log_success "Updated $shell_rc configuration"
        log_info "Shell configuration backed up to ${shell_rc}.backup-*"
    else
        log_warning "Shell configuration file not found: $shell_rc"
        log_info "You may need to manually add: source \"$SCRIPT_DIR/secure-dotfiles.sh\""
    fi
}

verify_migration() {
    log_info "Verifying migration..."
    
    local issues=0
    
    # Check essential directories
    for dir in config sessions contexts memory projects; do
        if [[ ! -d "$NEW_HOME/$dir" ]]; then
            log_error "Missing directory: $NEW_HOME/$dir"
            ((issues++))
        fi
    done
    
    # Check configuration file
    if [[ ! -f "$NEW_HOME/config/dotfiles.conf" ]]; then
        log_error "Missing configuration file"
        ((issues++))
    fi
    
    # Check providers configuration
    if [[ ! -f "$NEW_HOME/config/providers.conf" ]]; then
        log_warning "Missing providers configuration (will be created on first run)"
    fi
    
    if [[ $issues -eq 0 ]]; then
        log_success "Migration verification passed"
    else
        log_error "Migration verification failed with $issues issues"
        return 1
    fi
}

run_post_migration_tests() {
    log_info "Running post-migration tests..."
    
    # Source the new secure dotfiles
    if source "$SCRIPT_DIR/secure-dotfiles.sh" >/dev/null 2>&1; then
        log_success "Secure dotfiles loaded successfully"
    else
        log_error "Failed to load secure dotfiles"
        return 1
    fi
    
    # Test basic functionality
    if dotfiles version >/dev/null 2>&1; then
        log_success "Version command works"
    else
        log_warning "Version command failed"
    fi
    
    if dotfiles health >/dev/null 2>&1; then
        log_success "Health check works"
    else
        log_warning "Health check failed"
    fi
    
    log_success "Post-migration tests completed"
}

# ============================================================================
# MAIN MIGRATION PROCESS
# ============================================================================

show_migration_banner() {
    echo ""
    echo "🔄 Dotfiles Plus Migration"
    echo "================================="
    echo "Upgrading from v2.1.0 to v1.0"
    echo ""
    echo "🔒 Security improvements:"
    echo "  • Command injection vulnerabilities fixed"
    echo "  • Input sanitization implemented"
    echo "  • Script verification for downloads"
    echo "  • Secure lazy loading system"
    echo ""
    echo "🏗️ Architecture improvements:"
    echo "  • Modular design for better maintainability"
    echo "  • Reduced global state pollution"
    echo "  • Performance optimizations"
    echo "  • Comprehensive error handling"
    echo ""
}

confirm_migration() {
    echo "⚠️  This migration will:"
    echo "  1. Create a full backup of your current installation"
    echo "  2. Migrate all your data to the new secure architecture"
    echo "  3. Update your shell configuration"
    echo "  4. Preserve all your sessions, contexts, and settings"
    echo ""
    echo -n "Do you want to proceed with the migration? [y/N] "
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        log_info "Migration cancelled by user"
        exit 0
    fi
}

main() {
    show_migration_banner
    confirm_migration
    
    log_info "Starting migration process..."
    
    # Migration steps
    if ! check_prerequisites; then
        log_error "Prerequisites check failed. Aborting migration."
        exit 1
    fi
    
    create_backup
    migrate_configuration
    migrate_sessions_and_contexts
    migrate_memory_and_data
    migrate_cache_and_local
    update_shell_configuration
    
    if verify_migration; then
        run_post_migration_tests
        
        echo ""
        log_success "Migration completed successfully!"
        echo ""
        echo "🎉 Next steps:"
        echo "  1. Restart your shell: exec \$SHELL"
        echo "  2. Test the installation: dotfiles health"
        echo "  3. Check your data: ai recall, project list"
        echo ""
        echo "📁 Backup location: $BACKUP_DIR"
        echo "🔒 New secure features are now active"
        echo ""
        echo "💡 For help: dotfiles help"
        
    else
        log_error "Migration verification failed!"
        echo ""
        echo "🔄 Recovery steps:"
        echo "  1. Your original installation is backed up at: $BACKUP_DIR"
        echo "  2. You can restore it with: cp -r '$BACKUP_DIR' '$OLD_HOME'"
        echo "  3. Please report this issue with the error details above"
        exit 1
    fi
}

# Run migration if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi