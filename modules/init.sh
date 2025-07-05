#!/usr/bin/env bash
# Initialization module

# First-run initialization
dotfiles_init() {
    # Check if first run
    local init_file="${DOTFILES_CONFIG_DIR}/.initialized"
    
    if [[ ! -f "$init_file" ]]; then
        # First run - show welcome and setup
        first_run_setup
        touch "$init_file"
    else
        # Regular initialization
        config_init
        
        # Check if AI is configured
        local provider=$(config_get "ai_provider" "none")
        if [[ "$provider" == "none" ]]; then
            if is_interactive; then
                echo ""
                echo -e "${COLOR_YELLOW}${ICON_WARNING} AI not configured!${COLOR_RESET}"
                echo "Run 'ai-setup' to configure AI provider for memory features."
                echo ""
            fi
        fi
    fi
}

# First run setup wizard
first_run_setup() {
    clear
    echo ""
    echo -e "${COLOR_MAGENTA}🚀 Welcome to Dotfiles Plus!${COLOR_RESET}"
    echo -e "${COLOR_MAGENTA}═══════════════════════════${COLOR_RESET}"
    echo ""
    echo "This appears to be your first time using Dotfiles Plus."
    echo "Let's get you set up!"
    echo ""
    echo "Press Enter to continue..."
    read -r
    
    # Initialize directories
    config_init
    
    # CRITICAL: Setup AI first since it's core to the experience
    echo ""
    echo -e "${COLOR_BLUE}Step 1: AI Provider Setup${COLOR_RESET}"
    echo -e "${COLOR_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
    echo ""
    echo "Dotfiles Plus uses AI for intelligent memory and automation."
    echo "Without AI configured, most features won't work."
    echo ""
    
    # Force AI setup
    ai_setup_wizard
    
    # Test if AI was configured
    local provider=$(config_get "ai_provider" "none")
    if [[ "$provider" == "none" ]]; then
        echo ""
        echo -e "${COLOR_RED}⚠️  WARNING: No AI provider configured!${COLOR_RESET}"
        echo ""
        echo "Dotfiles Plus requires AI for:"
        echo "- Context-aware memory system"
        echo "- Intelligent command suggestions"
        echo "- Natural language queries"
        echo ""
        echo "You can configure AI later with: ai-setup"
        echo ""
        echo -n "Continue without AI? [y/N]: "
        read -r continue_without_ai
        
        if [[ ! "$continue_without_ai" =~ ^[Yy]$ ]]; then
            echo "Setup cancelled. Please run again when ready."
            return 1
        fi
    else
        # Test AI connection
        echo ""
        echo "Testing AI connection..."
        if ai_test >/dev/null 2>&1; then
            log_success "AI configured successfully!"
        else
            log_warning "AI configured but test failed. Check your setup."
        fi
    fi
    
    # Git enhancements
    echo ""
    echo -e "${COLOR_BLUE}Step 2: Git Enhancements${COLOR_RESET}"
    echo -e "${COLOR_BLUE}━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
    echo ""
    echo -n "Enable enhanced git commands (gst, gc, etc)? [Y/n]: "
    read -r enable_git
    
    if [[ ! "$enable_git" =~ ^[Nn]$ ]]; then
        config_set "enable_git_enhanced" "true"
        log_success "Git enhancements enabled"
    fi
    
    # Auto-update check
    echo ""
    echo -e "${COLOR_BLUE}Step 3: Auto Updates${COLOR_RESET}"
    echo -e "${COLOR_BLUE}━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
    echo ""
    echo -n "Enable automatic update checks? [Y/n]: "
    read -r enable_updates
    
    if [[ ! "$enable_updates" =~ ^[Nn]$ ]]; then
        config_set "enable_auto_update_check" "true"
        log_success "Auto-update checks enabled"
    fi
    
    # Complete
    echo ""
    echo -e "${COLOR_GREEN}✅ Setup Complete!${COLOR_RESET}"
    echo ""
    echo "Quick Start Guide:"
    echo "━━━━━━━━━━━━━━━━"
    if [[ "$provider" != "none" ]]; then
        echo "• Ask AI anything:      ai \"how do I list large files?\""
        echo "• Remember context:     ai remember \"working on auth feature\""
        echo "• Recall memories:      ai recall"
        echo "• Deep thinking:        ai think \"complex problem here\""
    fi
    echo "• Check status:         dotfiles status"
    echo "• Update:              dotfiles update"
    echo "• Help:                dotfiles help"
    echo ""
    echo "Enjoy Dotfiles Plus! ⚡"
    echo ""
}

# Check and prompt for AI if not configured
check_ai_configured() {
    local provider=$(config_get "ai_provider" "none")
    
    if [[ "$provider" == "none" ]] && is_interactive; then
        # Only prompt once per session
        if [[ -z "${DOTFILES_AI_PROMPT_SHOWN:-}" ]]; then
            export DOTFILES_AI_PROMPT_SHOWN=1
            
            echo ""
            echo -e "${COLOR_YELLOW}┌─────────────────────────────────────┐${COLOR_RESET}"
            echo -e "${COLOR_YELLOW}│ 🤖 AI Provider Not Configured      │${COLOR_RESET}"
            echo -e "${COLOR_YELLOW}├─────────────────────────────────────┤${COLOR_RESET}"
            echo -e "${COLOR_YELLOW}│ AI features are disabled.           │${COLOR_RESET}"
            echo -e "${COLOR_YELLOW}│ Run 'ai-setup' to enable:           │${COLOR_RESET}"
            echo -e "${COLOR_YELLOW}│ • Context-aware memory              │${COLOR_RESET}"
            echo -e "${COLOR_YELLOW}│ • Natural language queries          │${COLOR_RESET}"
            echo -e "${COLOR_YELLOW}│ • Intelligent automation            │${COLOR_RESET}"
            echo -e "${COLOR_YELLOW}└─────────────────────────────────────┘${COLOR_RESET}"
            echo ""
        fi
        
        return 1
    fi
    
    return 0
}

# Quick setup command
quick_setup() {
    echo "Starting quick setup..."
    first_run_setup
}