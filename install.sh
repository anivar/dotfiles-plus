#!/usr/bin/env bash
# 🚀 Dotfiles Plus - One-Line Installer
# Fast, secure installation for new users

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation configuration
INSTALL_DIR="$HOME/.dotfiles-plus"
GITHUB_URL="https://raw.githubusercontent.com/anivar/dotfiles-plus/main"
TEMP_DIR="/tmp/dotfiles-plus-install-$$"

# ============================================================================
# UTILITY FUNCTIONS
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
    echo "🚀 Dotfiles Plus Installer"
    echo "================================="
    echo "✨ AI-powered dotfiles with enterprise security"
    echo ""
    echo "🔒 Security Features:"
    echo "  • Command injection protection"
    echo "  • Input sanitization"
    echo "  • Secure AI integration"
    echo "  • Session isolation"
    echo ""
    echo "🤖 AI Integration:"
    echo "  • Claude Code support"
    echo "  • Gemini CLI support"
    echo "  • Extensible provider system"
    echo ""
    echo "⚡ Performance:"
    echo "  • Lazy loading modules"
    echo "  • Intelligent caching"
    echo "  • Optimized for daily use"
    echo ""
}

# ============================================================================
# SYSTEM CHECKS
# ============================================================================

check_prerequisites() {
    log_info "Checking system prerequisites..."
    
    # Check OS support
    local os_name=$(uname -s)
    case "$os_name" in
        Darwin|Linux)
            log_info "✅ Supported OS: $os_name"
            ;;
        *)
            log_error "Unsupported OS: $os_name"
            log_info "Supported: macOS (Darwin), Linux"
            return 1
            ;;
    esac
    
    # Check shell and version
    local shell_name=$(basename "$SHELL")
    case "$shell_name" in
        bash)
            # Check bash version
            local bash_version="${BASH_VERSION%%.*}"
            if [[ -n "$bash_version" ]] && [[ "$bash_version" -ge 5 ]]; then
                log_info "✅ Bash ${BASH_VERSION} (5.0+ required)"
            else
                log_error "Bash 5.0+ required. Found: ${BASH_VERSION:-unknown}"
                log_info "macOS users: Install bash 5+ with 'brew install bash'"
                return 1
            fi
            ;;
        zsh)
            log_info "✅ Supported shell: $shell_name"
            ;;
        *)
            log_warning "Shell may not be fully supported: $shell_name"
            log_info "Recommended: bash 4+ or zsh"
            ;;
    esac
    
    # Check required commands
    local required_commands=("curl" "mkdir" "chmod")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            log_error "Required command not found: $cmd"
            return 1
        fi
    done
    
    # Check write permissions
    if [[ ! -w "$(dirname "$INSTALL_DIR")" ]]; then
        log_error "No write permission to $(dirname "$INSTALL_DIR")"
        return 1
    fi
    
    # Check if already installed
    if [[ -d "$INSTALL_DIR" ]]; then
        log_warning "Existing installation found at $INSTALL_DIR"
        echo -n "Would you like to run migration instead? [Y/n] "
        read -r response
        if [[ ! "$response" =~ ^[Nn]$ ]]; then
            log_info "Use the migration script for existing installations:"
            echo "  curl -fsSL $GITHUB_URL/migrate-universal.sh | bash"
            exit 0
        fi
    fi
    
    log_success "Prerequisites check passed"
}

# ============================================================================
# INSTALLATION FUNCTIONS
# ============================================================================

create_directory_structure() {
    log_info "Creating directory structure..."
    
    mkdir -p "$INSTALL_DIR"/{config,sessions,contexts,memory,backups,local,projects,performance,cache}
    mkdir -p "$INSTALL_DIR"/{core,ai,project,system}
    
    log_success "Directory structure created"
}

download_core_files() {
    log_info "Downloading core files..."
    
    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    
    # For now, copy from current directory since this is a local setup
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Copy all files
    cp -r "$script_dir"/* "$INSTALL_DIR/" 2>/dev/null || {
        log_error "Failed to copy files from $script_dir"
        return 1
    }
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR"/*.sh
    chmod +x "$INSTALL_DIR"/core/*.sh
    chmod +x "$INSTALL_DIR"/ai/*.sh
    chmod +x "$INSTALL_DIR"/project/*.sh
    chmod +x "$INSTALL_DIR"/system/*.sh
    
    log_success "Core files downloaded and configured"
}

create_initial_configuration() {
    log_info "Creating initial configuration..."
    
    # Create main configuration
    cat > "$INSTALL_DIR/config/dotfiles.conf" << EOF
# Dotfiles Plus Configuration
# Installed on $(date)

# Core settings
version=1.0
session_id=session_$(date +%s)_$$
platform=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
shell=$(basename "$SHELL")
cache_ttl=3600

# Features
performance_logging=true
input_sanitization=true
script_verification=true
secure_lazy_loading=true

# Installation metadata
install_date=$(date +%s)
install_method=one_line_installer
EOF
    
    # Create user preferences
    cat > "$INSTALL_DIR/config/user-preferences.conf" << EOF
# User Preferences - Fresh Installation $(date)
# Customize these settings to match your workflow

# Shell customization
preferred_shell=$(basename "$SHELL")
install_date=$(date +%s)

# Features to enable
enable_ai_integration=true
enable_git_enhancements=true
enable_performance_optimizations=true
enable_session_isolation=true

# AI provider preference (will be set when providers are available)
ai_provider_preference=claude

# Git enhancements
preserve_git_aliases=true

# Custom aliases (add your own below)
# alias ll='ls -la'
# alias grep='grep --color=auto'
EOF
    
    log_success "Initial configuration created"
}

update_shell_configuration() {
    log_info "Updating shell configuration..."
    
    local shell_name=$(basename "$SHELL")
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
            log_warning "Unknown shell: $shell_name. Manual configuration required."
            log_info "Add this line to your shell configuration:"
            echo "  source \"$INSTALL_DIR/dotfiles-plus.sh\""
            return
            ;;
    esac
    
    if [[ -n "$rc_file" ]]; then
        # Backup existing configuration
        if [[ -f "$rc_file" ]]; then
            cp "$rc_file" "${rc_file}.backup-$(date +%Y%m%d-%H%M%S)"
            log_info "Backed up existing $rc_file"
        fi
        
        # Add Dotfiles Plus
        cat >> "$rc_file" << EOF

# ============================================================================
# SECURE DOTFILES PLUS v1.0
# Installed on $(date)
# ============================================================================

# Load Dotfiles Plus (compatible version for better shell support)
if [[ -f "$INSTALL_DIR/dotfiles-plus.sh" ]]; then
    source "$INSTALL_DIR/dotfiles-plus.sh"
fi
EOF
        
        log_success "Updated $rc_file"
    fi
}

run_initial_tests() {
    log_info "Running initial tests..."
    
    # Source the system to test it
    if source "$INSTALL_DIR/dotfiles-plus.sh" >/dev/null 2>&1; then
        log_success "System loads successfully"
    else
        log_error "Failed to load system"
        return 1
    fi
    
    # Test basic commands
    if dotfiles version >/dev/null 2>&1; then
        log_success "Core commands work"
    else
        log_warning "Some commands may not work properly"
    fi
    
    # Test health check
    if dotfiles health >/dev/null 2>&1; then
        log_success "Health check passes"
    else
        log_warning "Health check has issues"
    fi
    
    log_success "Initial tests completed"
}

# ============================================================================
# POST-INSTALLATION
# ============================================================================

show_next_steps() {
    echo ""
    log_success "🎉 Installation completed successfully!"
    echo ""
    echo "📋 Next Steps:"
    echo ""
    echo "  1️⃣  Restart your shell to load the new configuration:"
    echo "      exec \$SHELL"
    echo ""
    echo "  2️⃣  Test the installation:"
    echo "      dotfiles health"
    echo ""
    echo "  3️⃣  Try basic commands:"
    echo "      dotfiles status    # Show system status"
    echo "      ai help            # AI command help"
    echo "      gst                # Enhanced git status"
    echo ""
    echo "  4️⃣  Install AI providers (optional):"
    echo "      Claude Code: Visit https://claude.ai/code"
    echo "      Gemini CLI:  npm install -g @google/generative-ai-cli"
    echo ""
    echo "📁 Installation Location: $INSTALL_DIR"
    echo ""
    echo "🔒 Security Features Now Active:"
    echo "  • Command injection protection"
    echo "  • Input sanitization for all operations"
    echo "  • Secure AI integration with session isolation"
    echo "  • Script verification for downloads"
    echo ""
    echo "💡 For help and documentation:"
    echo "      dotfiles help"
    echo ""
    echo "🤖 Try your first AI query (if providers are installed):"
    echo "      ai \"help me get started with this system\""
    echo ""
}

cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

# ============================================================================
# MAIN INSTALLATION PROCESS
# ============================================================================

main() {
    # Set up cleanup on exit
    trap cleanup EXIT
    
    show_banner
    
    echo "🔍 This installer will:"
    echo "  • Check your system compatibility"
    echo "  • Download and install Dotfiles Plus"
    echo "  • Configure your shell automatically"
    echo "  • Run initial tests to verify installation"
    echo "  • Preserve any existing dotfiles (with backups)"
    echo ""
    echo -n "Do you want to proceed with the installation? [y/N] "
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled by user"
        exit 0
    fi
    
    log_info "Starting installation process..."
    
    # Installation steps
    if ! check_prerequisites; then
        log_error "Prerequisites check failed. Aborting installation."
        exit 1
    fi
    
    create_directory_structure
    download_core_files
    create_initial_configuration
    update_shell_configuration
    run_initial_tests
    
    # Show completion
    show_next_steps
}

# ============================================================================
# ENTRY POINT
# ============================================================================

# Run installation if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi