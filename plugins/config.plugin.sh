#!/usr/bin/env bash
# Configuration Plugin - Smart setup and management

# ============================================================================
# FIRST RUN SETUP
# ============================================================================

dotfiles_setup() {
    clear
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║     🚀 DOTFILES PLUS SETUP 🚀        ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    echo "Welcome! Let's get you set up in seconds."
    echo ""
    
    # Check if already initialized
    if [[ -f "$DOTFILES_HOME/.initialized" ]]; then
        echo "✅ Already initialized!"
        echo ""
        echo -n "Reconfigure? [y/N]: "
        read -r response
        [[ ! "$response" =~ ^[Yy]$ ]] && return 0
    fi
    
    # Step 1: Auto-detect AI
    echo "🔍 Auto-detecting AI providers..."
    echo ""
    
    local detected_ai=""
    
    # Check for existing installations
    if command_exists claude || [[ -d "$HOME/Library/Application Support/Claude" ]]; then
        detected_ai="claude"
        echo "  ✅ Claude detected!"
    fi
    
    if command_exists gemini || [[ -f "$HOME/.gemini/config.json" ]]; then
        detected_ai="${detected_ai:+$detected_ai,}gemini"
        echo "  ✅ Gemini detected!"
    fi
    
    if command_exists ollama; then
        detected_ai="${detected_ai:+$detected_ai,}ollama"
        echo "  ✅ Ollama detected!"
    fi
    
    # Check environment variables
    [[ -n "${ANTHROPIC_API_KEY:-}" ]] && echo "  ✅ Anthropic API key found!"
    [[ -n "${OPENAI_API_KEY:-}" ]] && echo "  ✅ OpenAI API key found!"
    [[ -n "${GEMINI_API_KEY:-}" ]] && echo "  ✅ Gemini API key found!"
    [[ -n "${OPENROUTER_API_KEY:-}" ]] && echo "  ✅ OpenRouter API key found!"
    
    echo ""
    
    if [[ -n "$detected_ai" ]]; then
        echo "🎉 Great! AI is already configured."
        state_set "ai_provider" "${detected_ai%%,*}"
    else
        echo "⚠️  No AI provider detected."
        echo ""
        echo "Dotfiles Plus needs AI for its core features:"
        echo "  • Intelligent memory system"
        echo "  • Natural language queries"
        echo "  • Smart automation"
        echo ""
        echo "Options:"
        echo "  1) Install Claude Code (recommended)"
        echo "  2) Install Gemini CLI"
        echo "  3) Use API key (OpenAI, Anthropic, etc)"
        echo "  4) Install local AI (Ollama)"
        echo "  5) Skip for now"
        echo ""
        echo -n "Choose [1-5]: "
        read -r choice
        
        case "$choice" in
            1) setup_claude_instructions ;;
            2) setup_gemini_instructions ;;
            3) setup_api_key ;;
            4) setup_ollama_instructions ;;
            5) log warning "Skipping AI setup. Most features won't work!" ;;
        esac
    fi
    
    # Step 2: Quick feature selection
    echo ""
    echo "📦 Feature Selection"
    echo "━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Enable all recommended features? [Y/n]: "
    read -r enable_all
    
    if [[ ! "$enable_all" =~ ^[Nn]$ ]]; then
        state_set "git_enhanced" "true"
        state_set "auto_update" "true"
        state_set "smart_hints" "true"
        state_set "auto_context" "true"
        log success "All features enabled!"
    else
        # Individual selection
        echo -n "Enhanced git commands? [Y/n]: "
        read -r git_choice
        [[ ! "$git_choice" =~ ^[Nn]$ ]] && state_set "git_enhanced" "true"
        
        echo -n "Auto-update checks? [Y/n]: "
        read -r update_choice
        [[ ! "$update_choice" =~ ^[Nn]$ ]] && state_set "auto_update" "true"
        
        echo -n "Smart command hints? [Y/n]: "
        read -r hints_choice
        [[ ! "$hints_choice" =~ ^[Nn]$ ]] && state_set "smart_hints" "true"
    fi
    
    # Step 3: Test
    echo ""
    echo "🧪 Testing setup..."
    echo ""
    
    if ai_test_connection; then
        log success "AI connection successful!"
    else
        log warning "AI test failed. Check your configuration."
    fi
    
    # Complete
    touch "$DOTFILES_HOME/.initialized"
    
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║        ✅ SETUP COMPLETE! ✅          ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    echo "🚀 Quick Start:"
    echo ""
    echo "  ai \"how do I find large files?\""
    echo "  ai remember \"working on auth feature\""
    echo "  ai recall"
    echo "  gst                  # Pretty git status"
    echo "  dotfiles help        # See all commands"
    echo ""
    echo "Enjoy Dotfiles Plus! 🎉"
    echo ""
}

# ============================================================================
# PROVIDER SETUP HELPERS
# ============================================================================

setup_claude_instructions() {
    echo ""
    echo "📘 Claude Setup Instructions:"
    echo ""
    echo "1. Download Claude from: https://claude.ai/download"
    echo "2. Install and sign in"
    echo "3. Run: dotfiles reload"
    echo ""
    echo "Press Enter to open download page..."
    read -r
    
    if command_exists open; then
        open "https://claude.ai/download"
    elif command_exists xdg-open; then
        xdg-open "https://claude.ai/download"
    fi
}

setup_gemini_instructions() {
    echo ""
    echo "📗 Gemini Setup Instructions:"
    echo ""
    echo "1. Install: npm install -g @google/generative-ai-cli"
    echo "2. Get API key: https://makersuite.google.com/app/apikey"
    echo "3. Run: gemini --init"
    echo "4. Run: dotfiles reload"
    echo ""
}

setup_api_key() {
    echo ""
    echo "🔑 API Key Setup"
    echo ""
    echo "Choose provider:"
    echo "1) OpenAI"
    echo "2) Anthropic"
    echo "3) OpenRouter"
    echo ""
    echo -n "Select [1-3]: "
    read -r provider
    
    echo -n "Enter API key: "
    read -rs api_key
    echo ""
    
    if [[ -n "$api_key" ]]; then
        case "$provider" in
            1) 
                echo "export OPENAI_API_KEY='$api_key'" >> "$DOTFILES_HOME/config/secrets.sh"
                state_set "ai_provider" "openai-api"
                ;;
            2)
                echo "export ANTHROPIC_API_KEY='$api_key'" >> "$DOTFILES_HOME/config/secrets.sh"
                state_set "ai_provider" "claude-api"
                ;;
            3)
                echo "export OPENROUTER_API_KEY='$api_key'" >> "$DOTFILES_HOME/config/secrets.sh"
                state_set "ai_provider" "openrouter"
                ;;
        esac
        
        chmod 600 "$DOTFILES_HOME/config/secrets.sh"
        log success "API key saved securely"
    fi
}

setup_ollama_instructions() {
    echo ""
    echo "🦙 Ollama Setup Instructions:"
    echo ""
    echo "1. Install from: https://ollama.ai"
    echo "2. Run: ollama pull llama3"
    echo "3. Run: dotfiles reload"
    echo ""
}

# ============================================================================
# CONFIGURATION MANAGEMENT
# ============================================================================

dotfiles_config() {
    local key="$1"
    local value="$2"
    
    if [[ -z "$key" ]]; then
        # Show all config
        echo "🔧 Dotfiles Plus Configuration"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        
        # Core settings
        echo "Core:"
        echo "  version:      $DOTFILES_VERSION"
        echo "  home:         $DOTFILES_HOME"
        echo "  shell:        $DOTFILES_SHELL $DOTFILES_SHELL_VERSION"
        echo ""
        
        # AI settings
        echo "AI:"
        echo "  provider:     $(state_get 'ai_provider' 'none')"
        echo "  auto_context: $(state_get 'auto_context' 'true')"
        echo ""
        
        # Features
        echo "Features:"
        echo "  git_enhanced: $(state_get 'git_enhanced' 'true')"
        echo "  auto_update:  $(state_get 'auto_update' 'true')"
        echo "  smart_hints:  $(state_get 'smart_hints' 'true')"
        echo ""
        
        # Stats
        if [[ -f "$MEMORY_DB" ]]; then
            local mem_count=$(grep -v '^#' "$MEMORY_DB" | wc -l)
            echo "Stats:"
            echo "  memories:     $mem_count"
            echo "  plugins:      ${#DOTFILES_PLUGINS[@]}"
        fi
    elif [[ -z "$value" ]]; then
        # Get single value
        echo "$(state_get "$key")"
    else
        # Set value
        state_set "$key" "$value"
        log success "Set $key = $value"
    fi
}

# ============================================================================
# TEST CONNECTION
# ============================================================================

ai_test_connection() {
    local provider=$(state_get "ai_provider" "none")
    
    if [[ "$provider" == "none" ]]; then
        log error "No AI provider configured"
        return 1
    fi
    
    echo "Testing $provider..."
    
    case "$provider" in
        claude)
            if command_exists claude; then
                echo "test" | claude "Say 'OK' if you can read this" 2>/dev/null | grep -q "OK"
            else
                return 1
            fi
            ;;
        gemini)
            if command_exists gemini; then
                echo "test" | gemini "Say 'OK' if you can read this" 2>/dev/null | grep -q "OK"
            else
                return 1
            fi
            ;;
        ollama)
            if command_exists ollama; then
                ollama list >/dev/null 2>&1
            else
                return 1
            fi
            ;;
        *)
            # Try a simple query
            ai_query "Say 'OK'" 2>/dev/null | grep -q "OK"
            ;;
    esac
}

# ============================================================================
# REGISTRATION
# ============================================================================

# Version command
dotfiles_version() {
    echo "Dotfiles Plus v2.0.2"
    echo "Shell: $DOTFILES_SHELL v$DOTFILES_SHELL_VERSION"
    echo "Platform: $(uname -s)"
}

# Status command
dotfiles_status() {
    local quiet="${1:-}"
    if [[ "$quiet" != "--quiet" ]]; then
        echo "🚀 Dotfiles Plus v$DOTFILES_VERSION"
        echo "   Shell: $DOTFILES_SHELL v$DOTFILES_SHELL_VERSION"
        echo "   Plugins: ${!DOTFILES_PLUGINS[@]}"
        echo "   AI: $(state_get ai_provider 'not configured')"
    fi
}

# Health check
dotfiles_health() {
    echo "🏥 Health Check"
    echo ""
    echo "✅ Core system loaded"
    echo "✅ Shell: $DOTFILES_SHELL v$DOTFILES_SHELL_VERSION"
    echo "✅ Plugins loaded: ${#DOTFILES_PLUGINS[@]}"
    echo "✅ Commands registered: ${#DOTFILES_COMMANDS[@]}"
    
    # Check AI
    local ai_provider=$(state_get ai_provider 'none')
    if [[ "$ai_provider" != "none" ]]; then
        echo "✅ AI configured: $ai_provider"
    else
        echo "⚠️  AI not configured"
    fi
}

# Register commands
command_register "setup" "dotfiles_setup" "Run setup wizard"
command_register "config" "dotfiles_config" "Manage configuration"
command_register "setup_ai" "dotfiles_setup" "Configure AI provider"
command_register "test_ai" "ai_test_connection" "Test AI connection"
command_register "version" "dotfiles_version" "Show version"
command_register "status" "dotfiles_status" "Show status"
command_register "health" "dotfiles_health" "Health check"
command_register "help" "dotfiles_help" "Show help"

# Auto-load secrets if exist
if [[ -f "$DOTFILES_HOME/config/secrets.sh" ]]; then
    source "$DOTFILES_HOME/config/secrets.sh"
fi