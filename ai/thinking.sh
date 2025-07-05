#!/usr/bin/env bash
# 🤔 AI Thinking Mode
# Inspired by Claude Code's extended thinking feature

# ============================================================================
# THINKING MODE FUNCTIONS
# ============================================================================

# Enhanced thinking mode for complex problems
function _ai_think() {
    local query="$*"
    local thinking_level="normal"
    
    # Parse thinking level
    if [[ "$query" =~ (think harder|think deeper|think longer) ]]; then
        thinking_level="deep"
        echo "🧠 Entering deep thinking mode..."
    else
        echo "🤔 Thinking about your question..."
    fi
    
    # Add thinking context
    local think_context="[THINKING MODE: $thinking_level] "
    think_context+="Please think step by step about this problem. "
    
    if [[ "$thinking_level" == "deep" ]]; then
        think_context+="Take your time to consider multiple approaches, "
        think_context+="potential edge cases, and long-term implications. "
        think_context+="Show your reasoning process. "
    fi
    
    # Include current context
    local context=""
    if declare -f _ai_build_smart_context_compat >/dev/null 2>&1; then
        context=$(_ai_build_smart_context_compat)
    fi
    
    # Execute query with thinking context
    local full_query="${think_context}${context}Question: ${query}"
    
    echo "📍 Context: $(pwd)"
    echo ""
    
    # Check for available AI providers
    if command -v claude >/dev/null 2>&1; then
        echo "🔵 Using claude in thinking mode..."
        _secure_execute_command "claude" "$full_query"
    elif command -v gemini >/dev/null 2>&1; then
        echo "🔵 Using gemini in thinking mode..."
        _secure_execute_command "gemini" "-p" "$full_query"
    else
        echo "❌ No AI provider available for thinking mode"
    fi
}

# ============================================================================
# CONVERSATION MANAGEMENT
# ============================================================================

# Continue last conversation
function _ai_continue() {
    local session_dir="$DOTFILES_CONFIG_HOME/sessions"
    local last_session=$(ls -t "$session_dir"/conversation_* 2>/dev/null | head -1)
    
    if [[ -f "$last_session" ]]; then
        echo "📂 Continuing conversation from: $(basename "$last_session")"
        
        # Load previous context
        local prev_context=$(cat "$last_session")
        echo "$prev_context"
        echo ""
        echo "---"
        echo "🔄 Conversation resumed. Continue with your question:"
    else
        echo "❌ No previous conversation found"
        echo "💡 Start a new conversation with: ai \"your question\""
    fi
}

# Resume with interactive picker
function _ai_resume() {
    local session_dir="$DOTFILES_CONFIG_HOME/sessions"
    local conversations=($(ls -t "$session_dir"/conversation_* 2>/dev/null | head -10))
    
    if [[ ${#conversations[@]} -eq 0 ]]; then
        echo "❌ No conversations found"
        return 1
    fi
    
    echo "📚 Recent conversations:"
    echo ""
    
    local i=1
    for conv in "${conversations[@]}"; do
        local timestamp=$(basename "$conv" | sed 's/conversation_//' | sed 's/_/ /g')
        local preview=$(head -1 "$conv" 2>/dev/null | cut -c1-50)
        echo "$i) $timestamp - $preview..."
        ((i++))
    done
    
    echo ""
    echo "Select conversation (1-${#conversations[@]}) or 'q' to quit:"
    read -r choice
    
    if [[ "$choice" == "q" ]]; then
        return 0
    fi
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#conversations[@]} )); then
        local selected="${conversations[$((choice-1))]}"
        echo ""
        echo "📂 Resuming: $(basename "$selected")"
        cat "$selected"
        echo ""
        echo "---"
        echo "🔄 Conversation resumed. Continue with your question:"
    else
        echo "❌ Invalid selection"
    fi
}

# Show conversation history
function _ai_history() {
    local session_dir="$DOTFILES_CONFIG_HOME/sessions"
    local limit="${1:-20}"
    
    echo "📜 Conversation History (last $limit):"
    echo ""
    
    ls -t "$session_dir"/conversation_* 2>/dev/null | head -"$limit" | while read -r conv; do
        local timestamp=$(basename "$conv" | sed 's/conversation_//' | sed 's/_/ /g')
        local size=$(wc -l < "$conv")
        echo "• $timestamp - $size lines"
    done
}

# ============================================================================
# PROJECT VS USER MEMORY
# ============================================================================

# Remember with scope
function _ai_remember_scoped() {
    local scope="session"
    local info=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --project|-p)
                scope="project"
                shift
                ;;
            --user|-u)
                scope="user"
                shift
                ;;
            *)
                info="$*"
                break
                ;;
        esac
    done
    
    if [[ -z "$info" ]]; then
        echo "Usage: ai remember [--project|--user] <information>" >&2
        return 1
    fi
    
    case "$scope" in
        "project")
            local project_file="$(pwd)/AI_MEMORY.md"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $info" >> "$project_file"
            echo "💾 Saved to project memory: $project_file"
            ;;
        "user")
            local user_file="$HOME/.ai-memory"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $info" >> "$user_file"
            echo "💾 Saved to user memory: $user_file"
            ;;
        *)
            # Default session memory
            _ai_remember "$info"
            ;;
    esac
}

# ============================================================================
# FREEZE POINTS - Save/Restore Conversation States
# ============================================================================

# Create a freeze point (snapshot of current conversation)
function _ai_freeze() {
    local name="${1:-$(date +%Y%m%d_%H%M%S)}"
    local freeze_dir="$DOTFILES_CONFIG_HOME/freezepoints"
    local freeze_file="$freeze_dir/freeze_${name}.tar.gz"
    
    mkdir -p "$freeze_dir"
    
    echo "❄️  Creating freeze point: $name"
    
    # Create temporary directory for freeze
    local temp_dir=$(mktemp -d)
    
    # Copy all current context files
    cp -r "$DOTFILES_CONFIG_HOME/contexts" "$temp_dir/" 2>/dev/null || true
    cp -r "$DOTFILES_CONFIG_HOME/sessions" "$temp_dir/" 2>/dev/null || true
    
    # Include current environment info
    cat > "$temp_dir/freeze_info.txt" << EOF
Freeze Point: $name
Created: $(date)
Directory: $(pwd)
Branch: $(git branch --show-current 2>/dev/null || echo "N/A")
Session: $DOTFILES_PLUS_SESSION_ID
EOF
    
    # Create archive
    tar -czf "$freeze_file" -C "$temp_dir" . 2>/dev/null
    rm -rf "$temp_dir"
    
    echo "✅ Freeze point created: $name"
    echo "   Saved to: $freeze_file"
}

# List available freeze points
function _ai_freeze_list() {
    local freeze_dir="$DOTFILES_CONFIG_HOME/freezepoints"
    
    if [[ ! -d "$freeze_dir" ]]; then
        echo "❌ No freeze points found"
        return 1
    fi
    
    echo "❄️  Available freeze points:"
    echo ""
    
    ls -1t "$freeze_dir"/freeze_*.tar.gz 2>/dev/null | while read -r file; do
        local name=$(basename "$file" | sed 's/freeze_//' | sed 's/.tar.gz//')
        local size=$(du -h "$file" | cut -f1)
        local date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || stat -c "%y" "$file" 2>/dev/null | cut -d' ' -f1,2)
        echo "  • $name ($size) - $date"
    done
}

# Restore from freeze point
function _ai_thaw() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        echo "Usage: ai thaw <name>"
        _ai_freeze_list
        return 1
    fi
    
    local freeze_dir="$DOTFILES_CONFIG_HOME/freezepoints"
    local freeze_file="$freeze_dir/freeze_${name}.tar.gz"
    
    if [[ ! -f "$freeze_file" ]]; then
        echo "❌ Freeze point not found: $name"
        _ai_freeze_list
        return 1
    fi
    
    echo "🔥 Thawing freeze point: $name"
    
    # Backup current state
    local backup_dir="$DOTFILES_CONFIG_HOME/freezepoints/backup_before_thaw"
    mkdir -p "$backup_dir"
    cp -r "$DOTFILES_CONFIG_HOME/contexts" "$backup_dir/" 2>/dev/null || true
    cp -r "$DOTFILES_CONFIG_HOME/sessions" "$backup_dir/" 2>/dev/null || true
    
    # Extract freeze point
    local temp_dir=$(mktemp -d)
    tar -xzf "$freeze_file" -C "$temp_dir" 2>/dev/null
    
    # Show freeze info
    if [[ -f "$temp_dir/freeze_info.txt" ]]; then
        echo ""
        cat "$temp_dir/freeze_info.txt"
        echo ""
    fi
    
    # Restore contexts and sessions
    cp -r "$temp_dir/contexts/"* "$DOTFILES_CONFIG_HOME/contexts/" 2>/dev/null || true
    cp -r "$temp_dir/sessions/"* "$DOTFILES_CONFIG_HOME/sessions/" 2>/dev/null || true
    
    rm -rf "$temp_dir"
    
    echo "✅ Restored from freeze point: $name"
    echo "💡 Use 'ai recall' to see restored context"
}

# ============================================================================
# TEST GENERATION
# ============================================================================

# Generate tests for code
function _ai_testgen() {
    local target="$*"
    
    if [[ -z "$target" ]]; then
        echo "Usage: ai testgen <file|function|description>"
        echo ""
        echo "Examples:"
        echo "  ai testgen auth.js"
        echo "  ai testgen \"login function\""
        echo "  ai testgen src/utils/validation.ts"
        return 1
    fi
    
    echo "🧪 Generating tests for: $target"
    echo "📍 Context: $(pwd)"
    
    # Build context for test generation
    local context="[TEST GENERATION MODE] "
    context+="Generate comprehensive unit tests for: $target. "
    context+="Include edge cases, error handling, and both positive/negative test cases. "
    context+="Use the testing framework already in this project. "
    
    # Add project context if available
    if [[ -f "package.json" ]]; then
        context+="Project type: Node.js/JavaScript. "
    elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
        context+="Project type: Python. "
    elif [[ -f "go.mod" ]]; then
        context+="Project type: Go. "
    fi
    
    # Include current context
    if declare -f _ai_build_smart_context_compat >/dev/null 2>&1; then
        local smart_context=$(_ai_build_smart_context_compat)
        context+="$smart_context"
    fi
    
    # Execute query
    local full_query="${context}Target for testing: ${target}"
    
    # Check for available AI providers
    if command -v claude >/dev/null 2>&1; then
        echo "🔵 Using claude for test generation..."
        _secure_execute_command "claude" "$full_query"
    elif command -v gemini >/dev/null 2>&1; then
        echo "🔵 Using gemini for test generation..."
        _secure_execute_command "gemini" "-p" "$full_query"
    else
        echo "❌ No AI provider available for test generation"
    fi
}

# Show memory by scope
function _ai_memory_show() {
    local scope="${1:-all}"
    
    case "$scope" in
        "--project"|"-p")
            echo "📦 Project Memory:"
            if [[ -f "$(pwd)/AI_MEMORY.md" ]]; then
                cat "$(pwd)/AI_MEMORY.md"
            else
                echo "No project memory found"
            fi
            ;;
        "--user"|"-u")
            echo "👤 User Memory:"
            if [[ -f "$HOME/.ai-memory" ]]; then
                cat "$HOME/.ai-memory"
            else
                echo "No user memory found"
            fi
            ;;
        *)
            # Show all
            echo "📚 All Memory Scopes:"
            echo ""
            _ai_memory_show --user
            echo ""
            _ai_memory_show --project
            echo ""
            _ai_recall
            ;;
    esac
}