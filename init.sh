#!/usr/bin/env bash
# 🚀 Dotfiles Plus - Quick Initialization
# Initialize dotfiles-plus in current directory or create new setup

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/anivar/dotfiles-plus.git"
INSTALL_DIR="${DOTFILES_PLUS_HOME:-$HOME/.dotfiles-plus}"
CURRENT_DIR="$(pwd)"

# Functions
log_info() {
    echo -e "${BLUE}ℹ️  ${NC}$*"
}

log_success() {
    echo -e "${GREEN}✅ ${NC}$*"
}

log_warning() {
    echo -e "${YELLOW}⚠️  ${NC}$*"
}

log_error() {
    echo -e "${RED}❌ ${NC}$*"
}

show_header() {
    echo ""
    echo -e "${MAGENTA}🚀 Dotfiles Plus Init${NC}"
    echo -e "${MAGENTA}═══════════════════${NC}"
    echo ""
}

check_requirements() {
    local has_error=false
    
    # Check bash version
    if [[ -n "${BASH_VERSION:-}" ]]; then
        local bash_major="${BASH_VERSION%%.*}"
        if [[ "$bash_major" -lt 5 ]]; then
            log_error "Bash 5.0+ required (found: $BASH_VERSION)"
            log_info "macOS: brew install bash && chsh -s \$(brew --prefix)/bin/bash"
            has_error=true
        fi
    fi
    
    # Check for git
    if ! command -v git >/dev/null 2>&1; then
        log_error "Git is required but not installed"
        has_error=true
    fi
    
    # Check for curl
    if ! command -v curl >/dev/null 2>&1; then
        log_error "Curl is required but not installed"
        has_error=true
    fi
    
    if [[ "$has_error" == "true" ]]; then
        return 1
    fi
    
    return 0
}

init_new_setup() {
    log_info "Initializing new Dotfiles Plus setup..."
    
    # Check if already exists
    if [[ -d "$INSTALL_DIR" ]]; then
        log_warning "Existing installation found at $INSTALL_DIR"
        echo -n "Reinitialize? This will backup existing setup [y/N]: "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Initialization cancelled"
            return 1
        fi
        
        # Backup existing
        local backup_dir="${INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up to $backup_dir"
        mv "$INSTALL_DIR" "$backup_dir"
    fi
    
    # Clone repository
    log_info "Cloning Dotfiles Plus..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    
    # Create initial directories
    log_info "Creating directory structure..."
    mkdir -p "$INSTALL_DIR"/{contexts,memories,templates,backups}
    
    # Create initial config
    create_initial_config
    
    # Add to shell RC
    add_to_shell_rc
    
    log_success "Dotfiles Plus initialized successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Restart your shell or run: source ~/.bashrc (or ~/.zshrc)"
    echo "2. Configure AI provider: dotfiles config"
    echo "3. Try it out: ai \"hello world\""
    echo ""
}

init_existing_project() {
    log_info "Initializing Dotfiles Plus for current project..."
    
    # Create project-specific files
    local project_name=$(basename "$CURRENT_DIR")
    
    # Create .ai-memory file
    if [[ ! -f ".ai-memory" ]]; then
        cat > .ai-memory << 'EOF'
# AI Memory for This Project
# Add important context that AI should remember

## Project Overview
- Name: PROJECT_NAME
- Type: [Node.js/Python/Go/etc]
- Purpose: [Brief description]

## Key Decisions
- [Add architectural decisions]
- [Add technology choices]

## Current Focus
- [What you're working on]

## Important Notes
- [Any special considerations]
EOF
        sed -i.bak "s/PROJECT_NAME/$project_name/g" .ai-memory && rm .ai-memory.bak
        log_success "Created .ai-memory file"
    else
        log_info ".ai-memory already exists"
    fi
    
    # Create .ai-templates directory
    if [[ ! -d ".ai-templates" ]]; then
        mkdir -p .ai-templates
        
        # Create sample template
        cat > .ai-templates/code-review.md << 'EOF'
Please review this code for:
- Security vulnerabilities
- Performance issues
- Code quality
- Best practices
- Potential bugs

Focus on: [SPECIFIC_AREA]
EOF
        log_success "Created .ai-templates directory with sample"
    fi
    
    # Add to .gitignore if needed
    if [[ -f ".gitignore" ]]; then
        if ! grep -q "^.ai-memory.local" .gitignore; then
            echo "" >> .gitignore
            echo "# Dotfiles Plus" >> .gitignore
            echo ".ai-memory.local" >> .gitignore
            echo ".ai-templates.local/" >> .gitignore
            log_success "Updated .gitignore"
        fi
    fi
    
    log_success "Project initialized for Dotfiles Plus!"
    echo ""
    echo "Created:"
    echo "- .ai-memory - Project context for AI"
    echo "- .ai-templates/ - Reusable prompt templates"
    echo ""
    echo "Next steps:"
    echo "1. Edit .ai-memory with project details"
    echo "2. Run: ai discover (to load project context)"
    echo "3. Try: ai \"explain this project\""
}

create_initial_config() {
    local config_file="$INSTALL_DIR/config/user.conf"
    mkdir -p "$(dirname "$config_file")"
    
    if [[ ! -f "$config_file" ]]; then
        cat > "$config_file" << 'EOF'
# Dotfiles Plus User Configuration
# Generated on: $(date)

# AI Provider (claude, gemini, openai, etc.)
AI_PROVIDER=""

# API Keys (or use environment variables)
# ANTHROPIC_API_KEY=""
# GEMINI_API_KEY=""
# OPENAI_API_KEY=""

# Memory Settings
AI_MEMORY_MAX_AGE=30  # Days to keep memories
AI_MEMORY_MAX_COUNT=1000  # Maximum memories to store

# Features
DOTFILES_PLUS_GIT_ENHANCED=true
DOTFILES_PLUS_AI_HINTS=true
DOTFILES_PLUS_AUTO_UPDATE_CHECK=true

# Custom Settings
# Add your own configuration here
EOF
        log_success "Created initial configuration"
    fi
}

add_to_shell_rc() {
    local shell_rc=""
    local shell_name=$(basename "${SHELL:-/bin/bash}")
    
    case "$shell_name" in
        bash) shell_rc="$HOME/.bashrc" ;;
        zsh) shell_rc="$HOME/.zshrc" ;;
        *) 
            log_warning "Unknown shell: $shell_name"
            shell_rc="$HOME/.bashrc"
            ;;
    esac
    
    # Check if already added
    if grep -q "dotfiles-plus.sh" "$shell_rc" 2>/dev/null; then
        log_info "Already added to $shell_rc"
        return
    fi
    
    # Add source line
    echo "" >> "$shell_rc"
    echo "# Dotfiles Plus" >> "$shell_rc"
    echo "[ -f \"$INSTALL_DIR/dotfiles-plus.sh\" ] && source \"$INSTALL_DIR/dotfiles-plus.sh\"" >> "$shell_rc"
    
    log_success "Added to $shell_rc"
}

show_menu() {
    echo "What would you like to do?"
    echo ""
    echo "1) Initialize new Dotfiles Plus setup"
    echo "2) Initialize current project for AI memory"
    echo "3) Check system requirements"
    echo "4) Show documentation"
    echo "5) Exit"
    echo ""
    echo -n "Choose [1-5]: "
}

# Main
main() {
    show_header
    
    # Quick requirement check
    if ! check_requirements; then
        log_error "Please install missing requirements first"
        exit 1
    fi
    
    # If run with --project flag, init current project
    if [[ "${1:-}" == "--project" ]] || [[ "${1:-}" == "-p" ]]; then
        init_existing_project
        exit 0
    fi
    
    # If run with --new flag, init new setup
    if [[ "${1:-}" == "--new" ]] || [[ "${1:-}" == "-n" ]]; then
        init_new_setup
        exit 0
    fi
    
    # Interactive menu
    while true; do
        show_menu
        read -r choice
        
        case "$choice" in
            1) 
                init_new_setup
                break
                ;;
            2) 
                init_existing_project
                break
                ;;
            3)
                log_info "Checking system requirements..."
                if check_requirements; then
                    log_success "All requirements met!"
                fi
                echo ""
                ;;
            4)
                echo ""
                echo "📚 Documentation:"
                echo "- README: https://github.com/anivar/dotfiles-plus"
                echo "- Commands: https://github.com/anivar/dotfiles-plus/blob/main/COMMANDS.md"
                echo "- Config: https://github.com/anivar/dotfiles-plus/blob/main/CONFIGURATION.md"
                echo ""
                ;;
            5)
                log_info "Goodbye!"
                exit 0
                ;;
            *)
                log_error "Invalid choice"
                echo ""
                ;;
        esac
    done
}

# Run main
main "$@"