#!/usr/bin/env bash
# 🧠 AI Context Management - Shell-compatible version
# Works without associative arrays for bash 3.x compatibility

# ============================================================================
# CONTEXT HIERARCHY MANAGEMENT (SHELL-COMPATIBLE)
# ============================================================================

# Get repository name without associative arrays
_ai_get_repo_name() {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" ]]; then
        basename "$git_root"
    fi
}

# Get current branch
_ai_get_branch() {
    git branch --show-current 2>/dev/null || echo "detached"
}

# Get context file path for different levels
_ai_get_context_file() {
    local level="$1"
    local context_dir="$DOTFILES_CONFIG_HOME/contexts"
    
    case "$level" in
        "dir")
            # Current directory context
            local dir_hash=$(echo -n "$(pwd)" | sha256sum 2>/dev/null || shasum -a 256 2>/dev/null | cut -c1-16)
            echo "$context_dir/dir_${dir_hash}.context"
            ;;
        "branch")
            # Branch-level context
            local repo_name=$(_ai_get_repo_name)
            local branch=$(_ai_get_branch)
            if [[ -n "$repo_name" ]]; then
                echo "$context_dir/repo_${repo_name}_branch_${branch}.context"
            fi
            ;;
        "repo")
            # Repository-level context
            local repo_name=$(_ai_get_repo_name)
            if [[ -n "$repo_name" ]]; then
                echo "$context_dir/repo_${repo_name}.context"
            fi
            ;;
        "session")
            # Session-level context
            echo "$context_dir/${DOTFILES_PLUS_SESSION_ID}_$(pwd | sed 's|/|_|g')"
            ;;
    esac
}

# ============================================================================
# SMART MEMORY FUNCTIONS
# ============================================================================

# Enhanced remember function with auto-tagging and importance levels
_ai_remember_smart() {
    local info="$*"
    local importance="normal"
    local tags=""
    
    # Parse flags for importance and tags
    while [[ $# -gt 0 ]]; do
        case $1 in
            --important|-i)
                importance="high"
                shift
                ;;
            --tag|-t)
                tags="$2"
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done
    
    info="$*"
    
    if [[ -z "$info" ]]; then
        echo "Usage: ai remember [--important] [--tag <tag>] <information>" >&2
        return 1
    fi
    
    # Sanitize input
    local safe_info
    safe_info=$(_secure_sanitize_input "$info" "true")
    if [[ $? -ne 0 ]]; then
        echo "❌ Invalid information - contains unsafe characters" >&2
        return 1
    fi
    
    # Auto-detect content type and add tags
    if [[ "$safe_info" =~ (TODO|FIXME|BUG) ]]; then
        tags="${tags:+$tags,}task"
    fi
    if [[ "$safe_info" =~ (http://|https://) ]]; then
        tags="${tags:+$tags,}link"
    fi
    if [[ "$safe_info" =~ (error|failed|issue) ]]; then
        tags="${tags:+$tags,}issue"
        importance="high"
    fi
    
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local levels_saved=0
    
    # Format with importance and tags
    local formatted_info="$safe_info"
    [[ "$importance" == "high" ]] && formatted_info="⚠️  $formatted_info"
    [[ -n "$tags" ]] && formatted_info="$formatted_info [#$tags]"
    
    # Save at directory level
    local dir_file=$(_ai_get_context_file "dir")
    if [[ -n "$dir_file" ]]; then
        mkdir -p "$(dirname "$dir_file")"
        echo "[$timestamp] $formatted_info" >> "$dir_file"
        ((levels_saved++))
    fi
    
    # Save at branch level if in git
    local branch_file=$(_ai_get_context_file "branch")
    if [[ -n "$branch_file" ]]; then
        mkdir -p "$(dirname "$branch_file")"
        echo "[$timestamp] [$(pwd)] $formatted_info" >> "$branch_file"
        ((levels_saved++))
    fi
    
    # Save at repo level if in git
    local repo_file=$(_ai_get_context_file "repo")
    local branch=$(_ai_get_branch)
    if [[ -n "$repo_file" ]]; then
        mkdir -p "$(dirname "$repo_file")"
        echo "[$timestamp] [$branch:$(pwd)] $formatted_info" >> "$repo_file"
        ((levels_saved++))
    fi
    
    # Save at session level
    local session_file=$(_ai_get_context_file "session")
    mkdir -p "$(dirname "$session_file")"
    echo "[$timestamp] $formatted_info" >> "$session_file"
    
    # Auto-cleanup old entries (keep last 100 per file)
    for file in "$dir_file" "$branch_file" "$repo_file"; do
        if [[ -f "$file" ]] && [[ $(wc -l < "$file") -gt 100 ]]; then
            tail -100 "$file" > "$file.tmp" && mv "$file.tmp" "$file"
        fi
    done
    
    echo "💾 Remembered at $levels_saved context levels: $safe_info"
}

# Enhanced recall function
_ai_recall_smart() {
    echo "📚 Smart Context Recall:"
    echo ""
    
    # Show current location
    local repo_name=$(_ai_get_repo_name)
    if [[ -n "$repo_name" ]]; then
        local branch=$(_ai_get_branch)
        echo "Current Location:"
        echo "- Repo: $repo_name ($branch)"
        echo "- Path: $(pwd)"
        echo ""
    fi
    
    local found_memories=false
    
    # Show directory-level memories
    local dir_file=$(_ai_get_context_file "dir")
    if [[ -f "$dir_file" ]]; then
        echo "📁 This Directory:"
        tail -5 "$dir_file" 2>/dev/null | while IFS= read -r line; do
            echo "  $line"
        done
        found_memories=true
        echo ""
    fi
    
    # Show branch-level memories
    local branch_file=$(_ai_get_context_file "branch")
    if [[ -f "$branch_file" ]]; then
        local branch=$(_ai_get_branch)
        echo "🌿 This Branch ($branch):"
        tail -5 "$branch_file" 2>/dev/null | while IFS= read -r line; do
            echo "  $line"
        done
        found_memories=true
        echo ""
    fi
    
    # Show repository-level memories
    local repo_file=$(_ai_get_context_file "repo")
    if [[ -f "$repo_file" ]]; then
        echo "📦 This Repository:"
        tail -5 "$repo_file" 2>/dev/null | while IFS= read -r line; do
            echo "  $line"
        done
        found_memories=true
        echo ""
    fi
    
    if [[ "$found_memories" == "false" ]]; then
        echo "No memories found for this context."
        echo "Use 'ai remember <info>' to add memories."
    fi
}

# Show context stack
_ai_context_stack() {
    echo "📚 Context Stack Navigation:"
    echo ""
    
    local current_dir="$(pwd)"
    local context_dir="$DOTFILES_CONFIG_HOME/contexts"
    local level=0
    
    # Show current directory and walk up
    while [[ "$current_dir" != "/" && "$current_dir" != "$HOME" && $level -lt 5 ]]; do
        local indent=""
        local i
        for ((i=0; i<level; i++)); do
            indent+="  "
        done
        
        echo "${indent}📁 $current_dir"
        
        # Check for memories at this level
        local dir_hash=$(echo -n "$current_dir" | sha256sum 2>/dev/null || shasum -a 256 2>/dev/null | cut -c1-16)
        local dir_context_file="$context_dir/dir_${dir_hash}.context"
        if [[ -f "$dir_context_file" ]]; then
            tail -2 "$dir_context_file" 2>/dev/null | while IFS= read -r line; do
                echo "${indent}    └── $line"
            done
        fi
        
        current_dir="$(dirname "$current_dir")"
        ((level++))
    done
}

# Show all projects
_ai_show_all_projects() {
    echo "📊 Cross-Project Context:"
    echo ""
    
    local context_dir="$DOTFILES_CONFIG_HOME/contexts"
    local found_projects=false
    
    # Find all repository context files
    for file in "$context_dir"/repo_*.context; do
        [[ -f "$file" ]] || continue
        
        local repo_name=$(basename "$file" | sed 's/repo_\(.*\)\.context/\1/' | sed 's/_branch_.*//')
        
        # Skip duplicates by checking if we've already shown this repo
        local already_shown=false
        if [[ -f "$context_dir/.shown_repos" ]]; then
            if grep -q "^$repo_name$" "$context_dir/.shown_repos" 2>/dev/null; then
                already_shown=true
            fi
        fi
        
        if [[ "$already_shown" == "false" ]]; then
            echo "$repo_name" >> "$context_dir/.shown_repos"
            echo "📦 $repo_name:"
            tail -3 "$file" 2>/dev/null | while IFS= read -r line; do
                echo "  $line"
            done
            echo ""
            found_projects=true
        fi
    done
    
    # Clean up temporary file
    rm -f "$context_dir/.shown_repos"
    
    if [[ "$found_projects" == "false" ]]; then
        echo "No project memories found yet."
    fi
}

# Build smart context for AI queries
_ai_build_smart_context_compat() {
    local session_id="$DOTFILES_PLUS_SESSION_ID"
    
    # Start with context-aware session
    local context="[CONTEXT-AWARE SESSION: $session_id] "
    
    # Add location context
    local repo_name=$(_ai_get_repo_name)
    if [[ -n "$repo_name" ]]; then
        local branch=$(_ai_get_branch)
        context+="Repo: $repo_name, Branch: $branch, "
    fi
    
    context+="Path: $(pwd)"$'\n'$'\n'
    
    # Add directory context
    local dir_file=$(_ai_get_context_file "dir")
    if [[ -f "$dir_file" ]]; then
        context+="Current Directory Context:"$'\n'
        local dir_lines=$(tail -3 "$dir_file" 2>/dev/null)
        if [[ -n "$dir_lines" ]]; then
            context+="$dir_lines"$'\n'
        fi
        context+=$'\n'
    fi
    
    # Add branch context
    local branch_file=$(_ai_get_context_file "branch")
    if [[ -f "$branch_file" ]]; then
        local branch=$(_ai_get_branch)
        context+="Branch Context ($branch):"$'\n'
        local branch_lines=$(tail -3 "$branch_file" 2>/dev/null)
        if [[ -n "$branch_lines" ]]; then
            context+="$branch_lines"$'\n'
        fi
        context+=$'\n'
    fi
    
    echo "$context"
}

# ============================================================================
# MEMORY MANAGEMENT
# ============================================================================

# Show memory statistics
_ai_memory_stats() {
    echo "📊 Memory Statistics:"
    echo ""
    
    local context_dir="$DOTFILES_CONFIG_HOME/contexts"
    local total_memories=0
    local total_size=0
    
    # Count memories by type
    echo "Memory Distribution:"
    
    # Directory memories
    local dir_count=$(find "$context_dir" -name "dir_*.context" -type f 2>/dev/null | wc -l)
    local dir_lines=$(find "$context_dir" -name "dir_*.context" -type f -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
    echo "  📁 Directory contexts: $dir_count files, ${dir_lines:-0} memories"
    
    # Branch memories
    local branch_count=$(find "$context_dir" -name "repo_*_branch_*.context" -type f 2>/dev/null | wc -l)
    local branch_lines=$(find "$context_dir" -name "repo_*_branch_*.context" -type f -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
    echo "  🌿 Branch contexts: $branch_count files, ${branch_lines:-0} memories"
    
    # Repo memories
    local repo_count=$(find "$context_dir" -name "repo_*.context" ! -name "*_branch_*" -type f 2>/dev/null | wc -l)
    local repo_lines=$(find "$context_dir" -name "repo_*.context" ! -name "*_branch_*" -type f -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
    echo "  📦 Repository contexts: $repo_count files, ${repo_lines:-0} memories"
    
    # Total size
    if command -v du >/dev/null 2>&1; then
        total_size=$(du -sh "$context_dir" 2>/dev/null | cut -f1)
        echo ""
        echo "Total storage: $total_size"
    fi
    
    # Show top tags
    echo ""
    echo "Top Tags:"
    grep -h "\[#" "$context_dir"/*.context 2>/dev/null | grep -o "#[^]]*" | sort | uniq -c | sort -nr | head -5 | while read count tag; do
        echo "  $tag: $count uses"
    done
}

# Clean old memories
_ai_memory_clean() {
    local days="${1:-30}"
    
    echo "🧹 Cleaning memories older than $days days..."
    
    local context_dir="$DOTFILES_CONFIG_HOME/contexts"
    local cleaned=0
    
    # Find and remove old session files
    find "$context_dir" -name "session_*" -type f -mtime +$days -delete 2>/dev/null
    cleaned=$?
    
    # Compact other context files by keeping only recent entries
    for file in "$context_dir"/*.context; do
        if [[ -f "$file" ]] && [[ $(wc -l < "$file") -gt 200 ]]; then
            tail -100 "$file" > "$file.tmp" && mv "$file.tmp" "$file"
            ((cleaned++))
        fi
    done
    
    echo "✅ Cleaned $cleaned files"
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export functions for use
# Note: Removed export -f statements to prevent function definitions from
# being displayed on terminal startup