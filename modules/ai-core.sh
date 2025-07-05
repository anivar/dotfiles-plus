#!/usr/bin/env bash
# Core AI functionality

# Main AI command
ai() {
    # Check if AI is configured
    if ! check_ai_configured; then
        return 1
    fi
    
    local subcommand="${1:-}"
    shift || true
    
    case "$subcommand" in
        remember)
            ai_remember "$@"
            ;;
        recall)
            ai_recall "$@"
            ;;
        forget)
            ai_forget "$@"
            ;;
        think)
            ai_think "$@"
            ;;
        template)
            ai_template "$@"
            ;;
        import)
            ai_import "$@"
            ;;
        discover)
            ai_discover "$@"
            ;;
        continue)
            ai_continue "$@"
            ;;
        resume)
            ai_resume "$@"
            ;;
        stats)
            ai_stats "$@"
            ;;
        clean)
            ai_clean "$@"
            ;;
        help)
            ai_help
            ;;
        "")
            ai_help
            ;;
        *)
            # Default: treat as query
            ai_query "$subcommand" "$@"
            ;;
    esac
}

# Execute AI query
ai_query() {
    local query="$*"
    local provider=$(config_get "ai_provider")
    
    # Validate and sanitize input
    query=$(sanitize_input "$query" "true")
    if [[ -z "$query" ]]; then
        log_error "Empty query"
        return 1
    fi
    
    # Add context if available
    local context=""
    if [[ -f "${DOTFILES_CONTEXT_DIR}/current" ]]; then
        context=$(cat "${DOTFILES_CONTEXT_DIR}/current")
        query="${context}\n\nQuery: ${query}"
    fi
    
    # Log query
    echo "${ICON_AI} AI Query: $*"
    
    # Execute based on provider
    case "$provider" in
        claude)
            if command_exists claude; then
                claude "$query"
            else
                log_error "Claude CLI not found"
                return 1
            fi
            ;;
            
        gemini)
            if command_exists gemini; then
                gemini "$query"
            else
                log_error "Gemini CLI not found"
                return 1
            fi
            ;;
            
        ollama)
            if command_exists ollama; then
                local model=$(config_get "ollama_model" "llama3")
                echo "$query" | ollama run "$model"
            else
                log_error "Ollama not found"
                return 1
            fi
            ;;
            
        openrouter|claude-api|openai)
            # Use our custom client
            ai_api_query "$provider" "$query"
            ;;
            
        *)
            log_error "Unknown AI provider: $provider"
            return 1
            ;;
    esac
}

# API-based query (for providers without CLI)
ai_api_query() {
    local provider="$1"
    local query="$2"
    
    case "$provider" in
        openrouter)
            local api_key="${OPENROUTER_API_KEY:-}"
            local model=$(config_get "openrouter_model" "anthropic/claude-3-sonnet")
            
            if [[ -z "$api_key" ]]; then
                log_error "OPENROUTER_API_KEY not set"
                return 1
            fi
            
            # Make API call
            local response
            response=$(curl -s -X POST "https://openrouter.ai/api/v1/chat/completions" \
                -H "Authorization: Bearer $api_key" \
                -H "Content-Type: application/json" \
                -d "$(jq -n \
                    --arg model "$model" \
                    --arg content "$query" \
                    '{
                        model: $model,
                        messages: [{role: "user", content: $content}]
                    }'
                )" 2>/dev/null)
            
            # Extract and display response
            echo "$response" | jq -r '.choices[0].message.content' 2>/dev/null || {
                log_error "API request failed"
                return 1
            }
            ;;
            
        claude-api)
            # Similar implementation for Claude API
            log_error "Claude API direct calls not yet implemented. Use Claude CLI."
            ;;
            
        openai)
            # Similar implementation for OpenAI
            log_error "OpenAI direct calls not yet implemented. Install OpenAI CLI."
            ;;
    esac
}

# Help command
ai_help() {
    echo "${ICON_AI} AI Commands:"
    echo ""
    echo "Query:"
    echo "  ai \"your question\"         Ask AI anything"
    echo ""
    echo "Memory:"
    echo "  ai remember \"info\"         Save context"
    echo "  ai recall [search]         Show memories"
    echo "  ai forget                  Clear session"
    echo "  ai stats                   Memory statistics"
    echo "  ai clean [days]            Clean old memories"
    echo ""
    echo "Advanced:"
    echo "  ai think \"problem\"         Extended thinking"
    echo "  ai template <cmd>          Manage templates"
    echo "  ai import <file>           Import memories"
    echo "  ai discover                Find project memories"
    echo "  ai continue                Continue last chat"
    echo ""
    echo "Setup:"
    echo "  ai-setup                   Configure AI provider"
    echo "  ai-test                    Test connection"
}