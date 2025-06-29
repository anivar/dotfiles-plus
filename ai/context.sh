#!/usr/bin/env bash
# 🧠 AI Context Management - Multi-level awareness
# Intelligent context tracking: repo, branch, directory stack

# ============================================================================
# CONTEXT HIERARCHY MANAGEMENT
# ============================================================================

# Get current context identifiers
_ai_get_context_ids() {
    local context_ids=()
    
    # Git repository context
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" ]]; then
        local repo_name=$(basename "$git_root")
        local branch=$(git branch --show-current 2>/dev/null || echo "detached")
        context_ids+=("repo:$repo_name")
        context_ids+=("branch:$branch")
    fi
    
    # Directory stack context
    local current_dir="$(pwd)"
    local dir_stack=()
    
    # Build directory hierarchy
    while [[ "$current_dir" != "/" && "$current_dir" != "$HOME" ]]; do
        dir_stack+=("$current_dir")
        current_dir="$(dirname "$current_dir")"
    done
    
    # Project type context
    local project_type=$(_ai_detect_project_type)
    if [[ -n "$project_type" ]]; then
        context_ids+=("type:$project_type")
    fi
    
    # Session context
    local session_id="$(_config_get session_id)"
    context_ids+=("session:$session_id")
    
    # Return all context IDs
    printf '%s\n' "${context_ids[@]}"
    printf '%s\n' "${dir_stack[@]}"
}

# Detect project type for context
_ai_detect_project_type() {
    if [[ -f "package.json" ]]; then
        echo "nodejs"
    elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
        echo "python"
    elif [[ -f "Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "go.mod" ]]; then
        echo "go"
    elif [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]]; then
        echo "java"
    else
        echo ""
    fi
}

# ============================================================================
# HIERARCHICAL MEMORY STORAGE
# ============================================================================

# Remember with full context hierarchy
ai_remember_smart() {
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
    
    # Get all context levels
    local context_ids=()
    while IFS= read -r context_id; do
        context_ids+=("$context_id")
    done < <(_ai_get_context_ids)
    
    # Store memory at multiple context levels
    local context_dir="$(_config_get context_dir)"
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    
    # Store at current directory level
    local dir_hash=$(echo -n "$(pwd)" | sha256sum | cut -c1-16)
    local dir_context_file="$context_dir/dir_${dir_hash}.context"
    echo "[$timestamp] $safe_info" >> "$dir_context_file"
    
    # Store at branch level if in git
    if [[ -n "$git_root" ]]; then
        local repo_name=$(basename "$git_root")
        local branch=$(git branch --show-current 2>/dev/null || echo "detached")
        local branch_context_file="$context_dir/repo_${repo_name}_branch_${branch}.context"
        echo "[$timestamp] [$(pwd)] $safe_info" >> "$branch_context_file"
        
        # Store at repo level
        local repo_context_file="$context_dir/repo_${repo_name}.context"
        echo "[$timestamp] [$branch:$(pwd)] $safe_info" >> "$repo_context_file"
    fi
    
    # Store at session level
    local session_file="$(_config_get_session_file)"
    echo "[$timestamp] $safe_info" >> "$session_file"
    
    echo "💾 Remembered at $(echo "${#context_ids[@]}" | awk '{print $1-3}') context levels: $safe_info"
}

# ============================================================================
# CONTEXT-AWARE RECALL
# ============================================================================

# Recall with context hierarchy
ai_recall_smart() {
    echo "📚 Smart Context Recall:"
    echo ""
    
    # Current location info
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" ]]; then
        local repo_name=$(basename "$git_root")
        local branch=$(git branch --show-current 2>/dev/null || echo "detached")
        echo "Current Location:"
        echo "- Repo: $repo_name ($branch)"
        echo "- Path: $(pwd)"
        echo ""
    fi
    
    # Get relevant memories from different levels
    local context_dir="$(_config_get context_dir)"
    local found_memories=false
    
    # Current directory memories
    local dir_hash=$(echo -n "$(pwd)" | sha256sum | cut -c1-16)
    local dir_context_file="$context_dir/dir_${dir_hash}.context"
    if [[ -f "$dir_context_file" ]]; then
        echo "📁 This Directory:"
        tail -5 "$dir_context_file" | while IFS= read -r line; do
            echo "  $line"
        done
        found_memories=true
        echo ""
    fi
    
    # Branch-level memories
    if [[ -n "$git_root" ]]; then
        local branch_context_file="$context_dir/repo_${repo_name}_branch_${branch}.context"
        if [[ -f "$branch_context_file" ]]; then
            echo "🌿 This Branch ($branch):"
            tail -5 "$branch_context_file" | while IFS= read -r line; do
                echo "  $line"
            done
            found_memories=true
            echo ""
        fi
        
        # Repository-level memories
        local repo_context_file="$context_dir/repo_${repo_name}.context"
        if [[ -f "$repo_context_file" ]]; then
            echo "📦 This Repository:"
            tail -5 "$repo_context_file" | grep -v "^\[$branch:" | while IFS= read -r line; do
                echo "  $line"
            done
            found_memories=true
            echo ""
        fi
    fi
    
    # Parent directory memories
    local parent_dir="$(dirname "$(pwd)")"
    if [[ "$parent_dir" != "/" && "$parent_dir" != "$HOME" ]]; then
        local parent_hash=$(echo -n "$parent_dir" | sha256sum | cut -c1-16)
        local parent_context_file="$context_dir/dir_${parent_hash}.context"
        if [[ -f "$parent_context_file" ]]; then
            echo "📂 Parent Directory:"
            tail -3 "$parent_context_file" | while IFS= read -r line; do
                echo "  $line"
            done
            found_memories=true
            echo ""
        fi
    fi
    
    if [[ "$found_memories" == "false" ]]; then
        echo "No memories found for this context."
        echo "Use 'ai remember <info>' to add memories."
    fi
}

# ============================================================================
# CROSS-PROJECT CONTEXT
# ============================================================================

# Show memories across all projects
ai_show_all_projects() {
    echo "📊 Cross-Project Context:"
    echo ""
    
    local context_dir="$(_config_get context_dir)"
    local repos=()
    
    # Find all repository context files
    for file in "$context_dir"/repo_*.context; do
        [[ -f "$file" ]] || continue
        local repo_name=$(basename "$file" | sed 's/repo_\(.*\)\.context/\1/' | sed 's/_branch_.*//')
        if [[ ! " ${repos[@]} " =~ " ${repo_name} " ]]; then
            repos+=("$repo_name")
        fi
    done
    
    # Show recent activity for each repo
    for repo in "${repos[@]}"; do
        echo "📦 $repo:"
        local repo_file="$context_dir/repo_${repo}.context"
        if [[ -f "$repo_file" ]]; then
            tail -3 "$repo_file" | while IFS= read -r line; do
                echo "  $line"
            done
        fi
        echo ""
    done
    
    if [[ ${#repos[@]} -eq 0 ]]; then
        echo "No project memories found yet."
    fi
}

# ============================================================================
# ENHANCED CONTEXT BUILDING
# ============================================================================

# Build context with hierarchy awareness
_ai_build_smart_context() {
    local session_id="$(_config_get session_id)"
    
    # Start with session isolation
    local context="[CONTEXT-AWARE SESSION: $session_id] "
    
    # Add location context
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" ]]; then
        local repo_name=$(basename "$git_root")
        local branch=$(git branch --show-current 2>/dev/null || echo "detached")
        context+="Repo: $repo_name, Branch: $branch, "
    fi
    
    context+="Path: $(pwd)"$'\n'$'\n'
    
    # Add hierarchical memories
    local context_dir="$(_config_get context_dir)"
    
    # Add relevant context from current directory
    local dir_hash=$(echo -n "$(pwd)" | sha256sum | cut -c1-16)
    local dir_context_file="$context_dir/dir_${dir_hash}.context"
    if [[ -f "$dir_context_file" ]]; then
        context+="Current Directory Context:"$'\n'
        tail -3 "$dir_context_file" | while IFS= read -r line; do
            context+="$line"$'\n'
        done
        context+=$'\n'
    fi
    
    # Add branch context if available
    if [[ -n "$git_root" ]]; then
        local branch_context_file="$context_dir/repo_${repo_name}_branch_${branch}.context"
        if [[ -f "$branch_context_file" ]]; then
            context+="Branch Context ($branch):"$'\n'
            tail -3 "$branch_context_file" | while IFS= read -r line; do
                context+="$line"$'\n'
            done
            context+=$'\n'
        fi
    fi
    
    echo "$context"
}

# ============================================================================
# CONTEXT NAVIGATION
# ============================================================================

# Navigate context stack
ai_context_stack() {
    echo "📚 Context Stack Navigation:"
    echo ""
    
    local current_dir="$(pwd)"
    local context_dir="$(_config_get context_dir)"
    local level=0
    
    # Show current directory and walk up
    while [[ "$current_dir" != "/" && "$current_dir" != "$HOME" ]]; do
        local indent=""
        for ((i=0; i<level; i++)); do
            indent+="  "
        done
        
        echo "${indent}📁 $current_dir"
        
        # Check for memories at this level
        local dir_hash=$(echo -n "$current_dir" | sha256sum | cut -c1-16)
        local dir_context_file="$context_dir/dir_${dir_hash}.context"
        if [[ -f "$dir_context_file" ]]; then
            tail -2 "$dir_context_file" | while IFS= read -r line; do
                echo "${indent}    └── $line"
            done
        fi
        
        current_dir="$(dirname "$current_dir")"
        ((level++))
    done
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export smart context functions
export -f ai_remember_smart
export -f ai_recall_smart
export -f ai_show_all_projects
export -f ai_context_stack
export -f _ai_build_smart_context
export -f _ai_get_context_ids

# Create aliases for backward compatibility
alias ai_remember="ai_remember_smart"
alias ai_recall="ai_recall_smart"