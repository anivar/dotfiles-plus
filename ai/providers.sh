#!/usr/bin/env bash
# 🤖 AI Provider Management Module
# Secure AI integration with input sanitization

# ============================================================================
# AI PROVIDER INTERFACE
# ============================================================================

# Execute AI query securely
ai_query() {
    local query="$*"
    
    # Validate and sanitize input
    if [[ -z "$query" ]]; then
        echo "❌ Empty query provided" >&2
        return 1
    fi
    
    # Sanitize the query
    local safe_query
    safe_query=$(_secure_sanitize_input "$query" "true")
    if [[ $? -ne 0 ]] || [[ -z "$safe_query" ]]; then
        echo "❌ Invalid query - contains unsafe characters" >&2
        return 1
    fi
    
    # Get available provider
    local provider
    provider=$(_config_get_ai_provider)
    if [[ $? -ne 0 ]]; then
        echo "🤖 AI Response: $safe_query

💡 No AI providers available. Configure providers:
  config edit providers   # Edit provider configuration
  config test providers   # Test available providers"
        return 0
    fi
    
    # Execute query securely
    _ai_execute_query "$provider" "$safe_query"
}

# Secure AI query execution
_ai_execute_query() {
    local provider="$1"
    local query="$2"
    
    # Build session context
    local context
    context=$(_ai_build_context)
    
    # Combine context and query
    local full_query="$context$query"
    
    echo "🤖 AI Query [$(_config_get session_id)]: $query"
    echo "📍 Directory: $(_perf_cache_get_or_set "current_dir" 60 "_perf_directory_basename")"
    echo "🔵 Using $provider..."
    
    # Execute provider command securely
    if _secure_ai_execute "$provider" "$full_query"; then
        # Log successful query
        local session_log="$(_config_get_session_log)"
        echo "[$(date '+%H:%M')] Q: $query" >> "$session_log"
    else
        echo "❌ AI provider execution failed" >&2
        return 1
    fi
}

# Build session context
_ai_build_context() {
    local session_id="$(_config_get session_id)"
    local context_file="$(_config_get_session_file)"
    
    # Session isolation instruction
    local isolation="[ISOLATED SESSION: $session_id] Treat this as completely separate from other conversations. "
    
    # Session information
    local session_info="Session: $session_id"$'\n'
    session_info+="Directory: $(_perf_cache_get_or_set "current_dir" 60 "_perf_directory_basename")"$'\n'
    
    # Git information (cached)
    local git_info=""
    local git_data
    git_data=$(_perf_cache_get_or_set "git_info" 30 "_perf_git_info_batch")
    
    if [[ "$git_data" != "not_a_repo||||" ]]; then
        IFS='|' read -r branch repo_name status commit_count <<< "$git_data"
        git_info="Repository: $repo_name"$'\n'
        git_info+="Branch: $branch"$'\n'
        git_info+="Status: $status files changed"$'\n'$'\n'
    fi
    
    # Session context
    local context=""
    if [[ -f "$context_file" ]]; then
        context="Session Context:"$'\n'
        context+="$(cat "$context_file")"$'\n'$'\n'
    fi
    
    echo "${isolation}${session_info}"$'\n'"${git_info}${context}Query: "
}

# ============================================================================
# AI MEMORY MANAGEMENT
# ============================================================================

# Remember information in session context
ai_remember() {
    local info="$*"
    
    if [[ -z "$info" ]]; then
        echo "Usage: ai remember <information>" >&2
        return 1
    fi
    
    # Sanitize input
    local safe_info
    safe_info=$(_secure_sanitize_input "$info" "true")
    if [[ $? -ne 0 ]]; then
        echo "❌ Invalid information - contains unsafe characters" >&2
        return 1
    fi
    
    local context_file="$(_config_get_session_file)"
    local timestamp="[$(date '+%H:%M')]"
    
    echo "$timestamp $safe_info" >> "$context_file"
    echo "💾 Remembered: $safe_info"
    
    # Update provider context files if they exist
    _ai_update_provider_contexts
}

# Forget session context
ai_forget() {
    local context_file="$(_config_get_session_file)"
    
    if [[ -f "$context_file" ]]; then
        rm -f "$context_file"
        echo "🗑️  Context cleared for this session/directory"
        
        # Update provider context files
        _ai_update_provider_contexts
    else
        echo "No context to clear"
    fi
}

# Recall session context
ai_recall() {
    local context_file="$(_config_get_session_file)"
    
    if [[ -f "$context_file" ]]; then
        echo "📚 Context for session $(_config_get session_id):"
        cat "$context_file"
    else
        echo "No context for this session/directory"
    fi
}

# Show all memories for current session
ai_memory() {
    local session_id="$(_config_get session_id)"
    local context_dir="$(_config_get context_dir)"
    
    echo "🧠 All memories for session $session_id:"
    
    find "$context_dir" -name "${session_id}_*" 2>/dev/null | while read -r file; do
        local dir_encoded="${file##*${session_id}_}"
        local dir_path="${dir_encoded//_//}"
        echo "📁 $dir_path:"
        sed 's/^/  /' "$file"
        echo
    done
}

# ============================================================================
# PROVIDER CONTEXT FILES
# ============================================================================

# AI context file mapping
declare -A AI_CONTEXT_FILES=(
    ["claude"]="CLAUDE.md"
    ["gemini"]="GEMINI.md"
    ["opencode"]="OPENCODE.md"
    ["cursor"]="CURSOR.md"
    ["codeium"]="CODEIUM.md"
)

# Setup provider context file
ai_provider_setup() {
    local provider="${1:-claude}"
    
    # Validate provider
    local safe_provider
    safe_provider=$(_secure_validate_input "$provider" "^[a-zA-Z0-9_-]+$")
    if [[ $? -ne 0 ]]; then
        echo "❌ Invalid provider name: $provider" >&2
        return 1
    fi
    
    local context_filename="${AI_CONTEXT_FILES[$safe_provider]}"
    if [[ -z "$context_filename" ]]; then
        echo "❌ Unknown provider: $safe_provider" >&2
        echo "Supported providers: ${!AI_CONTEXT_FILES[*]}" >&2
        return 1
    fi
    
    _ai_create_provider_context "$safe_provider" "$context_filename"
}

# Create provider context file
_ai_create_provider_context() {
    local provider="$1"
    local context_filename="$2"
    local current_dir="$(pwd)"
    local session_id="$(_config_get session_id)"
    local session_context="$(_config_get home)/contexts/${session_id}_${provider}.md"
    local project_context="$current_dir/$context_filename"
    local backup_context="$current_dir/.${context_filename}.backup.$(date +%s)"
    
    # Create session-specific context
    _ai_generate_provider_template "$provider" "$session_context"
    
    # Handle existing context file
    if [[ -f "$project_context" ]] && [[ ! -L "$project_context" ]]; then
        cp "$project_context" "$backup_context"
        echo "💾 Backed up existing $context_filename to $(basename "$backup_context")"
        
        # Merge existing content
        {
            echo ""
            echo "## 📄 Original Project Instructions"
            echo ""
            cat "$project_context"
        } >> "$session_context"
        
        rm "$project_context"
    fi
    
    # Create symlink
    if [[ ! -L "$project_context" ]] || [[ "$(readlink "$project_context")" != "$session_context" ]]; then
        ln -sf "$session_context" "$project_context"
        echo "🔗 Created $context_filename symlink for session: $session_id"
    fi
}

# Generate provider-specific template
_ai_generate_provider_template() {
    local provider="$1"
    local session_file="$2"
    local current_dir="$(pwd)"
    local session_id="$(_config_get session_id)"
    
    # Get git info
    local git_data
    git_data=$(_perf_cache_get_or_set "git_info" 30 "_perf_git_info_batch")
    local git_branch="not a git repo"
    if [[ "$git_data" != "not_a_repo||||" ]]; then
        IFS='|' read -r branch repo_name status commit_count <<< "$git_data"
        git_branch="$branch"
    fi
    
    # Get current context
    local context_file="$(_config_get_session_file)"
    local current_context="No context - use 'ai remember <info>' to add"
    if [[ -f "$context_file" ]]; then
        current_context="$(cat "$context_file")"
    fi
    
    case "$provider" in
        claude)
            cat > "$session_file" << EOF
# CLAUDE.md - AI Session: $session_id

## 🤖 Session Instructions for Claude
This is an isolated session. Do not reference conversations from other sessions.

## 📍 Project Context
- **Session ID**: $session_id
- **Project**: $(basename "$current_dir")
- **Directory**: $current_dir
- **Git Branch**: $git_branch

## 💾 Session Memory
$current_context

## 🎯 Claude-Specific Guidelines
- Provide detailed explanations and step-by-step guidance
- Focus on code quality and best practices
- Use the session memory and project context above
- Maintain conversation continuity within this session only

---
**Auto-generated by secure dotfiles-plus Session: $session_id**
EOF
            ;;
        gemini)
            cat > "$session_file" << EOF
# GEMINI.md - AI Session: $session_id

## 🤖 Context Instructions for Gemini
This session is isolated from other conversations. Use only the context provided below.

## 📍 Project Information
- **Session ID**: $session_id
- **Project Name**: $(basename "$current_dir")
- **Working Directory**: $current_dir
- **Git Branch**: $git_branch

## 💾 Session Context
$current_context

## 🎯 Gemini Guidelines
- Analyze the project structure and context above
- Provide practical, actionable solutions
- Focus on efficiency and modern best practices
- Reference the session context for decision-making

---
**Generated by secure dotfiles-plus | Session: $session_id**
EOF
            ;;
        *)
            local provider_upper="${provider^^}"
            cat > "$session_file" << EOF
# ${provider_upper}.md - Session: $session_id

## 🤖 ${provider_upper} Session Context
This is an isolated AI session.

## 📍 Project Details  
- **Session**: $session_id
- **Project**: $(basename "$current_dir")
- **Path**: $current_dir
- **Git Branch**: $git_branch

## 💾 Current Context
$current_context

## 🎯 Instructions
- Use project information and context above
- Provide relevant, context-aware responses

---
**secure dotfiles-plus Session: $session_id**
EOF
            ;;
    esac
}

# Update provider context files with current context
_ai_update_provider_contexts() {
    local session_id="$(_config_get session_id)"
    local context_dir="$(_config_get home)/contexts"
    
    # Update all provider context files for this session
    for provider in "${!AI_CONTEXT_FILES[@]}"; do
        local session_context="$context_dir/${session_id}_${provider}.md"
        if [[ -f "$session_context" ]]; then
            _ai_generate_provider_template "$provider" "$session_context"
        fi
    done
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export AI functions
export -f ai_query
export -f ai_remember
export -f ai_forget
export -f ai_recall
export -f ai_memory
export -f ai_provider_setup