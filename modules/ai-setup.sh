#!/usr/bin/env bash
# AI Setup Wizard

# Auto-detect existing AI installations
ai_auto_detect() {
    log_info "Auto-detecting AI providers..."
    
    # Check for Claude Code
    if [[ -d "$HOME/Library/Application Support/Claude" ]] || [[ -d "$HOME/.config/claude" ]]; then
        log_success "Claude Code detected!"
        config_set "ai_provider" "claude"
        return 0
    fi
    
    # Check for Gemini CLI config
    if [[ -f "$HOME/.gemini/config.json" ]] || [[ -f "$HOME/.config/gemini/config.json" ]]; then
        log_success "Gemini CLI detected!"
        config_set "ai_provider" "gemini"
        return 0
    fi
    
    # Check for Claude CLI
    if command_exists claude; then
        log_success "Claude CLI detected!"
        config_set "ai_provider" "claude"
        return 0
    fi
    
    # Check for Gemini CLI
    if command_exists gemini; then
        log_success "Gemini CLI detected!"
        config_set "ai_provider" "gemini"
        return 0
    fi
    
    # Check for Ollama
    if command_exists ollama; then
        log_success "Ollama detected!"
        config_set "ai_provider" "ollama"
        # Try to get default model
        local default_model=$(ollama list 2>/dev/null | grep -v "NAME" | head -1 | awk '{print $1}')
        if [[ -n "$default_model" ]]; then
            config_set "ollama_model" "$default_model"
            log_info "Using model: $default_model"
        fi
        return 0
    fi
    
    # Check environment variables
    if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
        log_success "Anthropic API key found in environment!"
        config_set "ai_provider" "claude-api"
        return 0
    fi
    
    if [[ -n "${OPENAI_API_KEY:-}" ]]; then
        log_success "OpenAI API key found in environment!"
        config_set "ai_provider" "openai"
        return 0
    fi
    
    if [[ -n "${GEMINI_API_KEY:-}" ]] || [[ -n "${GOOGLE_API_KEY:-}" ]]; then
        log_success "Gemini API key found in environment!"
        config_set "ai_provider" "gemini"
        return 0
    fi
    
    if [[ -n "${OPENROUTER_API_KEY:-}" ]]; then
        log_success "OpenRouter API key found in environment!"
        config_set "ai_provider" "openrouter"
        return 0
    fi
    
    return 1
}

# Interactive AI setup
ai_setup_wizard() {
    # First try auto-detect
    if ai_auto_detect; then
        echo ""
        echo -e "${COLOR_GREEN}✨ AI provider auto-configured!${COLOR_RESET}"
        echo ""
        echo -n "Test connection now? [Y/n]: "
        read -r test_now
        if [[ ! "$test_now" =~ ^[Nn]$ ]]; then
            ai_test
        fi
        return 0
    fi
    
    # Manual setup if auto-detect failed
    log_info "No AI provider auto-detected. Starting manual setup..."
    echo ""
    echo "Choose your AI provider:"
    echo ""
    echo "1) Claude (Anthropic)"
    echo "2) Gemini (Google)"
    echo "3) OpenRouter (Multiple models)"
    echo "4) OpenAI"
    echo "5) Local AI (Ollama)"
    echo "6) Skip for now"
    echo ""
    echo -n "Select [1-6]: "
    read -r choice
    
    case "$choice" in
        1) setup_claude ;;
        2) setup_gemini ;;
        3) setup_openrouter ;;
        4) setup_openai ;;
        5) setup_local_ai ;;
        6) 
            log_info "Skipping AI setup. You can run 'dotfiles ai-setup' later."
            return 0
            ;;
        *)
            log_error "Invalid choice"
            return 1
            ;;
    esac
}

# Setup Claude
setup_claude() {
    echo ""
    log_info "Setting up Claude..."
    echo ""
    echo "To use Claude, you need:"
    echo "1. Install Claude CLI: https://claude.ai/download"
    echo "2. Or use API key with a compatible client"
    echo ""
    echo -n "Do you have Claude CLI installed? [y/N]: "
    read -r has_cli
    
    if [[ "$has_cli" =~ ^[Yy]$ ]]; then
        if command_exists claude; then
            config_set "ai_provider" "claude"
            log_success "Claude CLI detected and configured!"
        else
            log_error "Claude CLI not found in PATH"
            echo "Please install from: https://claude.ai/download"
        fi
    else
        echo ""
        echo -n "Enter your Anthropic API key (or press Enter to skip): "
        read -rs api_key
        echo ""
        
        if [[ -n "$api_key" ]]; then
            # Store in user config (not in git)
            echo "export ANTHROPIC_API_KEY='$api_key'" >> "$DOTFILES_USER_CONFIG"
            config_set "ai_provider" "claude-api"
            log_success "Claude API key configured!"
            echo ""
            echo "Note: You'll need a Claude-compatible client like:"
            echo "- llm (pip install llm)"
            echo "- claude-cli (npm install -g @anthropic-ai/cli)"
        fi
    fi
}

# Setup Gemini
setup_gemini() {
    echo ""
    log_info "Setting up Gemini..."
    echo ""
    echo "To use Gemini:"
    echo "1. Install Gemini CLI: npm install -g @google/generative-ai-cli"
    echo "2. Get API key from: https://makersuite.google.com/app/apikey"
    echo ""
    echo -n "Enter your Gemini API key (or press Enter to skip): "
    read -rs api_key
    echo ""
    
    if [[ -n "$api_key" ]]; then
        echo "export GEMINI_API_KEY='$api_key'" >> "$DOTFILES_USER_CONFIG"
        config_set "ai_provider" "gemini"
        
        # Check if gemini CLI is installed
        if command_exists gemini; then
            log_success "Gemini CLI found and configured!"
        else
            log_warning "Gemini CLI not found. Install with:"
            echo "  npm install -g @google/generative-ai-cli"
        fi
    fi
}

# Setup OpenRouter
setup_openrouter() {
    echo ""
    log_info "Setting up OpenRouter..."
    echo ""
    echo "OpenRouter provides access to multiple AI models:"
    echo "- Claude 3 Opus/Sonnet/Haiku"
    echo "- GPT-4/GPT-3.5"
    echo "- Llama, Mistral, and more"
    echo ""
    echo "Get your API key from: https://openrouter.ai/keys"
    echo ""
    echo -n "Enter your OpenRouter API key (or press Enter to skip): "
    read -rs api_key
    echo ""
    
    if [[ -n "$api_key" ]]; then
        echo "export OPENROUTER_API_KEY='$api_key'" >> "$DOTFILES_USER_CONFIG"
        config_set "ai_provider" "openrouter"
        
        # Default model selection
        echo ""
        echo "Choose default model:"
        echo "1) claude-3-opus"
        echo "2) claude-3-sonnet"
        echo "3) gpt-4"
        echo "4) gpt-3.5-turbo"
        echo "5) llama-3-70b"
        echo ""
        echo -n "Select [1-5]: "
        read -r model_choice
        
        case "$model_choice" in
            1) config_set "openrouter_model" "anthropic/claude-3-opus" ;;
            2) config_set "openrouter_model" "anthropic/claude-3-sonnet" ;;
            3) config_set "openrouter_model" "openai/gpt-4" ;;
            4) config_set "openrouter_model" "openai/gpt-3.5-turbo" ;;
            5) config_set "openrouter_model" "meta-llama/llama-3-70b" ;;
        esac
        
        log_success "OpenRouter configured!"
        echo ""
        echo "You'll need a client that supports OpenRouter like:"
        echo "- llm with openrouter plugin"
        echo "- Custom script (we'll provide one)"
    fi
}

# Setup OpenAI
setup_openai() {
    echo ""
    log_info "Setting up OpenAI..."
    echo ""
    echo "Get your API key from: https://platform.openai.com/api-keys"
    echo ""
    echo -n "Enter your OpenAI API key (or press Enter to skip): "
    read -rs api_key
    echo ""
    
    if [[ -n "$api_key" ]]; then
        echo "export OPENAI_API_KEY='$api_key'" >> "$DOTFILES_USER_CONFIG"
        config_set "ai_provider" "openai"
        
        # Model selection
        echo ""
        echo "Choose default model:"
        echo "1) gpt-4-turbo"
        echo "2) gpt-4"
        echo "3) gpt-3.5-turbo"
        echo ""
        echo -n "Select [1-3]: "
        read -r model_choice
        
        case "$model_choice" in
            1) config_set "openai_model" "gpt-4-turbo" ;;
            2) config_set "openai_model" "gpt-4" ;;
            3) config_set "openai_model" "gpt-3.5-turbo" ;;
        esac
        
        log_success "OpenAI configured!"
    fi
}

# Setup Local AI
setup_local_ai() {
    echo ""
    log_info "Setting up Local AI (Ollama)..."
    echo ""
    
    if command_exists ollama; then
        log_success "Ollama detected!"
        
        # List available models
        echo ""
        echo "Available models:"
        ollama list 2>/dev/null | grep -v "NAME" | awk '{print "- " $1}'
        
        echo ""
        echo -n "Enter model name (e.g., llama3, mistral): "
        read -r model_name
        
        if [[ -n "$model_name" ]]; then
            config_set "ai_provider" "ollama"
            config_set "ollama_model" "$model_name"
            log_success "Local AI configured with $model_name!"
        fi
    else
        log_warning "Ollama not found. Install from: https://ollama.ai"
        echo ""
        echo "After installing Ollama:"
        echo "1. Run: ollama pull llama3"
        echo "2. Run: dotfiles ai-setup"
    fi
}

# Test AI connection
ai_test() {
    local provider=$(config_get "ai_provider" "none")
    
    case "$provider" in
        claude)
            if command_exists claude; then
                echo "Testing Claude..." 
                claude "Say 'Dotfiles Plus connected!' in 5 words or less"
            else
                log_error "Claude CLI not found"
            fi
            ;;
        gemini)
            if command_exists gemini; then
                echo "Testing Gemini..."
                gemini "Say 'Dotfiles Plus connected!' in 5 words or less"
            else
                log_error "Gemini CLI not found"
            fi
            ;;
        ollama)
            if command_exists ollama; then
                local model=$(config_get "ollama_model" "llama3")
                echo "Testing Ollama with $model..."
                echo "Say 'Dotfiles Plus connected!' in 5 words or less" | ollama run "$model"
            else
                log_error "Ollama not found"
            fi
            ;;
        *)
            log_error "No AI provider configured. Run: dotfiles ai-setup"
            ;;
    esac
}

# Main AI setup command
dotfiles_ai_setup() {
    ai_setup_wizard
}

# Register commands
alias ai-setup='dotfiles_ai_setup'
alias ai-test='ai_test'