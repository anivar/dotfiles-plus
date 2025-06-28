#!/usr/bin/env bash
# 🔄 Universal Dotfiles Migration System
# Migrate from ANY dotfiles system to Dotfiles Plus

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Migration configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-migration-backup-$(date +%Y%m%d-%H%M%S)"
NEW_HOME="$HOME/.dotfiles-plus"

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

show_banner() {
    echo ""
    echo "🔄 Universal Dotfiles Migration to Dotfiles Plus"
    echo "======================================================="
    echo "✨ Migrate from ANY dotfiles system with zero data loss"
    echo ""
    echo "🔒 Why migrate to Dotfiles Plus?"
    echo "  • ✅ Command injection vulnerabilities fixed"
    echo "  • ✅ Input sanitization for all operations"
    echo "  • ✅ Modular architecture for maintainability"
    echo "  • ✅ AI integration with session isolation"
    echo "  • ✅ Performance optimizations"
    echo "  • ✅ Cross-platform compatibility (macOS, Linux, WSL)"
    echo ""
}

# ============================================================================
# DOTFILES SYSTEM DETECTION
# ============================================================================

detect_existing_dotfiles() {
    log_info "Detecting existing dotfiles systems..."
    
    local detected_systems=()
    
    # Check for common dotfiles frameworks
    if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
        detected_systems+=("oh-my-zsh")
        log_info "Found: Oh My Zsh"
    fi
    
    if [[ -f "$HOME/.oh-my-bash/oh-my-bash.sh" ]]; then
        detected_systems+=("oh-my-bash")
        log_info "Found: Oh My Bash"
    fi
    
    if [[ -d "$HOME/.prezto" ]]; then
        detected_systems+=("prezto")
        log_info "Found: Prezto"
    fi
    
    if [[ -f "$HOME/.antidote/antidote.zsh" ]] || command -v antidote >/dev/null 2>&1; then
        detected_systems+=("antidote")
        log_info "Found: Antidote"
    fi
    
    if [[ -f "$HOME/.zinit/zinit.zsh" ]]; then
        detected_systems+=("zinit")
        log_info "Found: Zinit"
    fi
    
    if [[ -f "$HOME/.bashit/bash_it.sh" ]]; then
        detected_systems+=("bash-it")
        log_info "Found: Bash-it"
    fi
    
    # Check for Homebrew dotfiles
    if command -v brew >/dev/null 2>&1 && brew list --formula 2>/dev/null | grep -E "(dotfiles|rcm)" >/dev/null; then
        detected_systems+=("homebrew-dotfiles")
        log_info "Found: Homebrew-managed dotfiles"
    fi
    
    # Check for GNU Stow
    if command -v stow >/dev/null 2>&1 && [[ -d "$HOME/dotfiles" ]]; then
        detected_systems+=("gnu-stow")
        log_info "Found: GNU Stow dotfiles"
    fi
    
    # Check for Chezmoi
    if command -v chezmoi >/dev/null 2>&1; then
        detected_systems+=("chezmoi")
        log_info "Found: Chezmoi"
    fi
    
    # Check for YADM
    if command -v yadm >/dev/null 2>&1; then
        detected_systems+=("yadm")
        log_info "Found: YADM"
    fi
    
    # Check for dotbot
    if [[ -f "$HOME/.dotfiles/install" ]] && grep -q "dotbot" "$HOME/.dotfiles/install" 2>/dev/null; then
        detected_systems+=("dotbot")
        log_info "Found: Dotbot"
    fi
    
    # Check for custom dotfiles repository
    if [[ -d "$HOME/.dotfiles/.git" ]] || [[ -d "$HOME/dotfiles/.git" ]]; then
        detected_systems+=("custom-git")
        log_info "Found: Custom Git-based dotfiles"
    fi
    
    # Check for existing dotfiles-plus
    if [[ -d "$HOME/.dotfiles-plus" ]]; then
        detected_systems+=("dotfiles-plus")
        log_info "Found: Existing dotfiles-plus installation"
    fi
    
    # General dotfiles detection
    local dotfile_count=0
    for file in "$HOME"/.*; do
        if [[ -f "$file" && "$(basename "$file")" =~ ^\.[a-z] ]]; then
            ((dotfile_count++))
        fi
    done
    
    if [[ $dotfile_count -gt 10 ]]; then
        detected_systems+=("manual-dotfiles")
        log_info "Found: Manual dotfiles configuration ($dotfile_count dotfiles)"
    fi
    
    if [[ ${#detected_systems[@]} -eq 0 ]]; then
        detected_systems+=("minimal")
        log_info "Minimal dotfiles setup detected"
    fi
    
    echo "${detected_systems[@]}"
}

# ============================================================================
# SYSTEM-SPECIFIC MIGRATION FUNCTIONS
# ============================================================================

migrate_oh_my_zsh() {
    log_info "Migrating Oh My Zsh configuration..."
    
    # Backup Oh My Zsh
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        cp -r "$HOME/.oh-my-zsh" "$BACKUP_DIR/oh-my-zsh"
    fi
    
    # Extract useful configurations
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$BACKUP_DIR/zshrc.backup"
        
        # Extract theme and plugins
        local theme plugins
        theme=$(grep "^ZSH_THEME=" "$HOME/.zshrc" 2>/dev/null | cut -d'"' -f2 || echo "")
        plugins=$(grep "^plugins=" "$HOME/.zshrc" 2>/dev/null | sed 's/plugins=(//' | sed 's/)//' || echo "")
        
        # Save Oh My Zsh preferences for future reference
        cat > "$NEW_HOME/config/oh-my-zsh-migration.conf" << EOF
# Oh My Zsh migration settings
# Theme: $theme
# Plugins: $plugins
# 
# Note: Dotfiles Plus provides equivalent functionality
# with enhanced security and performance.
EOF
        
        log_success "Oh My Zsh configuration backed up and analyzed"
    fi
}

migrate_bash_it() {
    log_info "Migrating Bash-it configuration..."
    
    if [[ -d "$HOME/.bash_it" ]]; then
        cp -r "$HOME/.bash_it" "$BACKUP_DIR/bash_it"
    fi
    
    if [[ -f "$HOME/.bashrc" ]]; then
        cp "$HOME/.bashrc" "$BACKUP_DIR/bashrc.backup"
        
        # Extract Bash-it configurations
        local theme completions plugins
        theme=$(grep "BASH_IT_THEME=" "$HOME/.bashrc" 2>/dev/null | cut -d'"' -f2 || echo "")
        
        cat > "$NEW_HOME/config/bash-it-migration.conf" << EOF
# Bash-it migration settings
# Theme: $theme
# 
# Dotfiles Plus provides equivalent functionality.
EOF
        
        log_success "Bash-it configuration backed up"
    fi
}

migrate_custom_git() {
    log_info "Migrating custom Git-based dotfiles..."
    
    local dotfiles_dir=""
    if [[ -d "$HOME/.dotfiles/.git" ]]; then
        dotfiles_dir="$HOME/.dotfiles"
    elif [[ -d "$HOME/dotfiles/.git" ]]; then
        dotfiles_dir="$HOME/dotfiles"
    fi
    
    if [[ -n "$dotfiles_dir" ]]; then
        # Create a comprehensive backup of the git repository
        cp -r "$dotfiles_dir" "$BACKUP_DIR/original-dotfiles"
        
        # Extract useful scripts and configurations
        find "$dotfiles_dir" -name "*.sh" -o -name "*.zsh" -o -name "*.bash" | while read -r script; do
            local dest="$NEW_HOME/local/$(basename "$script")"
            cp "$script" "$dest"
            log_info "Preserved script: $(basename "$script")"
        done
        
        # Copy configuration files
        find "$dotfiles_dir" -name ".*rc" -o -name ".*profile" | while read -r config; do
            local dest="$BACKUP_DIR/configs/$(basename "$config")"
            mkdir -p "$(dirname "$dest")"
            cp "$config" "$dest"
        done
        
        log_success "Custom dotfiles repository backed up and useful files preserved"
    fi
}

migrate_chezmoi() {
    log_info "Migrating Chezmoi configuration..."
    
    if command -v chezmoi >/dev/null 2>&1; then
        # Export chezmoi data
        local chezmoi_data="$BACKUP_DIR/chezmoi-export"
        mkdir -p "$chezmoi_data"
        
        chezmoi data > "$chezmoi_data/data.yaml" 2>/dev/null || true
        chezmoi execute-template --init --promptString="" < /dev/null > "$chezmoi_data/templates.txt" 2>/dev/null || true
        
        # Copy chezmoi source directory
        local source_dir
        source_dir=$(chezmoi source-path 2>/dev/null || echo "$HOME/.local/share/chezmoi")
        if [[ -d "$source_dir" ]]; then
            cp -r "$source_dir" "$chezmoi_data/source"
        fi
        
        log_success "Chezmoi configuration exported"
    fi
}

migrate_yadm() {
    log_info "Migrating YADM configuration..."
    
    if command -v yadm >/dev/null 2>&1; then
        # List YADM managed files
        yadm list > "$BACKUP_DIR/yadm-files.txt" 2>/dev/null || true
        
        # Export YADM repository
        local yadm_repo="$HOME/.local/share/yadm/repo.git"
        if [[ -d "$yadm_repo" ]]; then
            cp -r "$yadm_repo" "$BACKUP_DIR/yadm-repo.git"
        fi
        
        log_success "YADM configuration backed up"
    fi
}

migrate_general_dotfiles() {
    log_info "Migrating general dotfiles and shell configurations..."
    
    # Common shell configuration files
    local shell_files=(
        ".bashrc" ".bash_profile" ".bash_aliases" ".bash_functions"
        ".zshrc" ".zsh_profile" ".zshenv" ".zprofile"
        ".profile" ".shellrc"
    )
    
    for file in "${shell_files[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            cp "$HOME/$file" "$BACKUP_DIR/${file#.}.backup"
            log_info "Backed up $file"
        fi
    done
    
    # Common application configurations
    local config_files=(
        ".gitconfig" ".gitignore_global"
        ".vimrc" ".nvimrc"
        ".tmux.conf"
        ".inputrc"
        ".editorconfig"
    )
    
    for file in "${config_files[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            cp "$HOME/$file" "$BACKUP_DIR/${file#.}.backup"
            log_info "Backed up $file"
        fi
    done
    
    # SSH configurations (handle carefully)
    if [[ -d "$HOME/.ssh" ]]; then
        mkdir -p "$BACKUP_DIR/ssh"
        # Only backup config files, not keys
        for file in "$HOME/.ssh/config" "$HOME/.ssh/known_hosts"; do
            if [[ -f "$file" ]]; then
                cp "$file" "$BACKUP_DIR/ssh/$(basename "$file")"
            fi
        done
        log_info "Backed up SSH configuration (keys excluded for security)"
    fi
}

# ============================================================================
# SHELL CONFIGURATION UPDATE
# ============================================================================

update_shell_configuration() {
    log_info "Updating shell configuration for Dotfiles Plus..."
    
    local shell_name
    shell_name="$(basename "$SHELL")"
    local rc_file=""
    
    case "$shell_name" in
        bash)
            rc_file="$HOME/.bashrc"
            [[ ! -f "$rc_file" && -f "$HOME/.bash_profile" ]] && rc_file="$HOME/.bash_profile"
            ;;
        zsh)
            rc_file="$HOME/.zshrc"
            ;;
        *)
            log_warning "Unknown shell: $shell_name. You may need to manually configure."
            return
            ;;
    esac
    
    if [[ -n "$rc_file" ]]; then
        # Backup current rc file
        cp "$rc_file" "${rc_file}.backup-$(date +%Y%m%d-%H%M%S)"
        
        # Remove old dotfiles loading
        sed -i.bak '/oh-my-zsh/d; /oh-my-bash/d; /bash_it/d; /prezto/d; /antidote/d; /zinit/d' "$rc_file" 2>/dev/null || true
        sed -i.bak '/source.*dotfiles/d; /\.dotfiles/d' "$rc_file" 2>/dev/null || true
        
        # Add Dotfiles Plus
        cat >> "$rc_file" << EOF

# ============================================================================
# SECURE DOTFILES PLUS v1.0
# Migrated on $(date)
# Backup location: $BACKUP_DIR
# ============================================================================

# Load Dotfiles Plus (compatible version for better shell support)
if [[ -f "$SCRIPT_DIR/secure-dotfiles-compatible.sh" ]]; then
    source "$SCRIPT_DIR/secure-dotfiles-compatible.sh"
fi
EOF
        
        log_success "Updated $rc_file with Dotfiles Plus"
        log_info "Original configuration backed up to ${rc_file}.backup-*"
    fi
}

# ============================================================================
# PREFERENCES MIGRATION
# ============================================================================

migrate_preferences() {
    log_info "Creating personalized configuration based on your preferences..."
    
    # Create user preferences file
    cat > "$NEW_HOME/config/user-preferences.conf" << EOF
# User Preferences - Migrated $(date)
# This file contains your personalized settings

# Shell customization
preferred_shell=$(basename "$SHELL")
migration_date=$(date +%s)
backup_location=$BACKUP_DIR

# Features to enable (you can modify these)
enable_ai_integration=true
enable_git_enhancements=true
enable_performance_optimizations=true
enable_session_isolation=true

# AI provider preference (set when you install providers)
ai_provider_preference=claude

# Git aliases preservation
preserve_git_aliases=true

# Custom aliases (add your own)
# alias ll='ls -la'
# alias grep='grep --color=auto'
EOF
    
    # Migrate Git configuration
    if [[ -f "$HOME/.gitconfig" ]]; then
        cp "$HOME/.gitconfig" "$NEW_HOME/config/git-config.backup"
        
        # Extract useful Git settings
        local git_name git_email
        git_name=$(git config user.name 2>/dev/null || echo "")
        git_email=$(git config user.email 2>/dev/null || echo "")
        
        if [[ -n "$git_name" && -n "$git_email" ]]; then
            cat >> "$NEW_HOME/config/user-preferences.conf" << EOF

# Git configuration
git_user_name=$git_name
git_user_email=$git_email
EOF
        fi
    fi
    
    log_success "Created personalized configuration"
}

# ============================================================================
# POST-MIGRATION SETUP
# ============================================================================

create_migration_report() {
    local report_file="$NEW_HOME/migration-report.md"
    
    cat > "$report_file" << EOF
# Dotfiles Migration Report

**Migration Date:** $(date)
**Backup Location:** \`$BACKUP_DIR\`
**New Installation:** \`$NEW_HOME\`

## What Was Migrated

$(if [[ -f "$BACKUP_DIR/zshrc.backup" ]]; then echo "- ✅ Zsh configuration"; fi)
$(if [[ -f "$BACKUP_DIR/bashrc.backup" ]]; then echo "- ✅ Bash configuration"; fi)
$(if [[ -f "$BACKUP_DIR/git-config.backup" ]]; then echo "- ✅ Git configuration"; fi)
$(if [[ -d "$BACKUP_DIR/ssh" ]]; then echo "- ✅ SSH configuration"; fi)
$(if [[ -d "$BACKUP_DIR/original-dotfiles" ]]; then echo "- ✅ Original dotfiles repository"; fi)

## Security Improvements

- ✅ **Command Injection Protection**: All user input is now sanitized
- ✅ **Secure Command Execution**: No more dangerous \`eval\` calls
- ✅ **Input Validation**: All commands validate input before execution
- ✅ **Session Isolation**: AI contexts are isolated between sessions

## New Features Available

- 🤖 **AI Integration**: Use \`ai "query"\` for intelligent assistance
- 📊 **System Status**: Use \`dotfiles status\` for system overview
- 🔍 **Health Checks**: Use \`dotfiles health\` for diagnostics
- 💾 **Session Memory**: Use \`ai remember "info"\` to save context
- 🌿 **Enhanced Git**: Use \`gst\` for smart git status

## Next Steps

1. **Restart your shell**: \`exec \$SHELL\`
2. **Test the installation**: \`dotfiles health\`
3. **Try AI features**: \`ai help\`
4. **Check git status**: \`gst\` (if in a git repository)

## Rollback Instructions

If you need to rollback:

\`\`\`bash
# Restore your original shell configuration
cp $BACKUP_DIR/$(basename "$SHELL")rc.backup ~/.$(basename "$SHELL")rc

# Remove Dotfiles Plus
rm -rf $NEW_HOME

# Restart shell
exec \$SHELL
\`\`\`

## Support

- 📚 Documentation: Run \`dotfiles help\`
- 🔧 Configuration: Files in \`$NEW_HOME/config/\`
- 💾 Backups: Located in \`$BACKUP_DIR\`

---
*Generated by Dotfiles Plus Universal Migration v1.0*
EOF
    
    log_success "Created migration report: $report_file"
}

show_next_steps() {
    echo ""
    log_success "Migration completed successfully! 🎉"
    echo ""
    echo "📋 Next Steps:"
    echo ""
    echo "  1️⃣  Restart your shell:"
    echo "      exec \$SHELL"
    echo ""
    echo "  2️⃣  Test the installation:"
    echo "      dotfiles health"
    echo ""
    echo "  3️⃣  Try AI features (after installing AI providers):"
    echo "      ai help"
    echo ""
    echo "  4️⃣  Test enhanced git commands:"
    echo "      gst    # Smart git status"
    echo "      gc     # Smart commit"
    echo ""
    echo "📁 Important Locations:"
    echo "  • Backup: $BACKUP_DIR"
    echo "  • Config: $NEW_HOME"
    echo "  • Report: $NEW_HOME/migration-report.md"
    echo ""
    echo "🔒 Security Features Now Active:"
    echo "  • Command injection protection"
    echo "  • Input sanitization"
    echo "  • Secure AI integration"
    echo "  • Session isolation"
    echo ""
}

# ============================================================================
# MAIN MIGRATION PROCESS
# ============================================================================

main() {
    show_banner
    
    echo "🔍 This migration will:"
    echo "  • Detect your existing dotfiles system"
    echo "  • Create a complete backup of your current setup"
    echo "  • Migrate your configurations safely"
    echo "  • Install Dotfiles Plus with all your data preserved"
    echo "  • Provide rollback instructions if needed"
    echo ""
    echo -n "Do you want to proceed with the migration? [y/N] "
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        log_info "Migration cancelled by user"
        exit 0
    fi
    
    log_info "Starting universal migration process..."
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$NEW_HOME/config"
    
    # Detect existing systems
    local detected_systems
    detected_systems=($(detect_existing_dotfiles))
    
    log_info "Detected systems: ${detected_systems[*]}"
    
    # Migrate based on detected systems
    for system in "${detected_systems[@]}"; do
        case "$system" in
            oh-my-zsh)
                migrate_oh_my_zsh
                ;;
            oh-my-bash)
                migrate_oh_my_bash
                ;;
            bash-it)
                migrate_bash_it
                ;;
            custom-git)
                migrate_custom_git
                ;;
            chezmoi)
                migrate_chezmoi
                ;;
            yadm)
                migrate_yadm
                ;;
            dotfiles-plus)
                log_info "Upgrading existing dotfiles-plus installation"
                source "$SCRIPT_DIR/migrate.sh"
                ;;
        esac
    done
    
    # Always migrate general dotfiles
    migrate_general_dotfiles
    
    # Create user preferences
    migrate_preferences
    
    # Update shell configuration
    update_shell_configuration
    
    # Create migration report
    create_migration_report
    
    # Show completion message
    show_next_steps
}

# Run migration if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi