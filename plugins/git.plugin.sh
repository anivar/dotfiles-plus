#!/usr/bin/env bash
# Git Enhancement Plugin

# ============================================================================
# VISUAL GIT COMMANDS
# ============================================================================

# Enhanced git status with icons
gst() {
    if ! command_exists git; then
        log error "Git not installed"
        return 1
    fi
    
    # Header
    echo "📊 Git Status"
    echo "━━━━━━━━━━━━"
    
    # Branch info
    local branch=$(git branch --show-current 2>/dev/null || echo "detached")
    local remote=$(git config --get "branch.$branch.remote" 2>/dev/null || echo "none")
    local ahead_behind=$(git rev-list --left-right --count "$remote/$branch...HEAD" 2>/dev/null || echo "0 0")
    local ahead=$(echo "$ahead_behind" | awk '{print $2}')
    local behind=$(echo "$ahead_behind" | awk '{print $1}')
    
    echo "🌿 Branch: $branch"
    [[ $ahead -gt 0 ]] && echo "⬆️  Ahead by $ahead commits"
    [[ $behind -gt 0 ]] && echo "⬇️  Behind by $behind commits"
    echo ""
    
    # Status with icons
    git status --porcelain | while IFS= read -r line; do
        local status="${line:0:2}"
        local file="${line:3}"
        
        case "$status" in
            "??") echo "❓ Untracked: $file" ;;
            "A ") echo "➕ Added: $file" ;;
            "M ") echo "📝 Modified (staged): $file" ;;
            " M") echo "✏️  Modified: $file" ;;
            "D ") echo "🗑️  Deleted (staged): $file" ;;
            " D") echo "❌ Deleted: $file" ;;
            "R ") echo "📋 Renamed: $file" ;;
            "C ") echo "📄 Copied: $file" ;;
            "U ") echo "⚠️  Conflict: $file" ;;
            *) echo "❔ $status: $file" ;;
        esac
    done
    
    # Summary
    local changes=$(git status --porcelain | wc -l | tr -d ' ')
    if [[ $changes -eq 0 ]]; then
        echo ""
        echo "✨ Working tree clean"
    else
        echo ""
        echo "📊 Total: $changes changes"
    fi
}

# Smart commit with conventional format
gc() {
    local message="$*"
    
    if [[ -z "$message" ]]; then
        log error "Commit message required"
        echo "Usage: gc \"your commit message\""
        echo ""
        echo "AI suggestion:"
        ai_suggest_commit
        return 1
    fi
    
    # Auto-detect commit type if not provided
    if [[ ! "$message" =~ ^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert): ]]; then
        local type=$(detect_commit_type "$message")
        message="$type: $message"
    fi
    
    # Show what will be committed
    echo "📝 Committing with message:"
    echo "   $message"
    echo ""
    
    # Add to memory
    ai remember "git commit: $message"
    
    git commit -m "$message"
}

# AI-powered commit message suggestion
ai_suggest_commit() {
    local diff=$(git diff --cached --stat)
    local files=$(git diff --cached --name-only)
    
    if [[ -z "$diff" ]]; then
        log warning "No staged changes"
        return 1
    fi
    
    ai_query "
Based on these changes:

Files:
$files

Summary:
$diff

Suggest a conventional commit message (feat/fix/docs/etc). 
Keep it concise and clear.
"
}

# Detect commit type from message
detect_commit_type() {
    local message="$1"
    local type="chore"
    
    # Keywords for each type
    case "${message,,}" in
        *"add"*|*"implement"*|*"create"*) type="feat" ;;
        *"fix"*|*"bug"*|*"issue"*) type="fix" ;;
        *"update doc"*|*"readme"*) type="docs" ;;
        *"format"*|*"indent"*|*"spacing"*) type="style" ;;
        *"refactor"*|*"restructure"*|*"organize"*) type="refactor" ;;
        *"test"*|*"spec"*) type="test" ;;
        *"performance"*|*"optimize"*|*"speed"*) type="perf" ;;
        *"ci"*|*"workflow"*|*"github action"*) type="ci" ;;
        *"build"*|*"compile"*|*"bundle"*) type="build" ;;
    esac
    
    echo "$type"
}

# Add all with summary
gaa() {
    local files=$(git status --porcelain | wc -l | tr -d ' ')
    
    if [[ $files -eq 0 ]]; then
        log info "No changes to add"
        return 0
    fi
    
    log info "Adding $files files..."
    git add -A
    
    # Show summary
    echo ""
    git status --short
}

# Push with setup
gp() {
    local branch=$(git branch --show-current 2>/dev/null)
    
    if [[ -z "$branch" ]]; then
        log error "Not on a branch"
        return 1
    fi
    
    # Check if upstream is set
    if ! git config --get "branch.$branch.remote" >/dev/null 2>&1; then
        log info "Setting upstream to origin/$branch"
        git push -u origin "$branch"
    else
        git push
    fi
}

# Pretty log
gl() {
    local limit="${1:-10}"
    
    git log \
        --graph \
        --pretty=format:'%C(yellow)%h%C(reset) %C(blue)%an%C(reset) %C(cyan)%ar%C(reset) %s %C(green)%d%C(reset)' \
        --abbrev-commit \
        -n "$limit"
}

# Interactive diff
gd() {
    if command_exists delta; then
        git diff "$@" | delta
    elif command_exists diff-so-fancy; then
        git diff "$@" | diff-so-fancy
    else
        git diff --color "$@"
    fi
}

# ============================================================================
# AI-ENHANCED GIT FEATURES (v1.3)
# ============================================================================

# Smart git workflow assistant
ai_gitflow() {
    local current_branch=$(git branch --show-current 2>/dev/null)
    local status=$(git status --porcelain)
    
    ai_query "
Current branch: $current_branch
Working tree status: ${status:-clean}

What's the next logical git action I should take?
Consider best practices for git workflow.
"
}

# Generate .gitignore
ai_gitignore() {
    local project_type=$(detect_project_type)
    
    ai_query "
Generate a comprehensive .gitignore file for a $project_type project.
Include common IDE files, OS files, and $project_type-specific patterns.
Output only the .gitignore content, no explanations.
" > .gitignore
    
    log success "Generated .gitignore for $project_type project"
}

# ============================================================================
# GIT ALIASES
# ============================================================================

# Short aliases
alias_register "g" "git"
alias_register "gs" "gst"
alias_register "ga" "git add"
alias_register "gb" "git branch"
alias_register "gco" "git checkout"
alias_register "gcm" "git checkout main || git checkout master"
alias_register "gpl" "git pull"
alias_register "gps" "git push"
alias_register "grb" "git rebase"
alias_register "gm" "git merge"
alias_register "gcp" "git cherry-pick"

# Advanced aliases
alias_register "gundo" "git reset HEAD~1"
alias_register "gclean" "git clean -fd"
alias_register "gbclean" 'git branch --merged | grep -v "\\*\\|main\\|master" | xargs -n 1 git branch -d'

# ============================================================================
# GIT HOOKS INTEGRATION
# ============================================================================

# Pre-commit memory
git_pre_commit_hook() {
    local message=$(git diff --cached --name-only)
    ai remember "Committing files: $message"
}

# Post-commit notification
git_post_commit_hook() {
    local last_commit=$(git log -1 --oneline)
    log success "Committed: $last_commit"
}

# ============================================================================
# REGISTRATION
# ============================================================================

# Register commands
command_register "git_status" "gst" "Enhanced git status"
command_register "git_commit" "gc" "Smart commit"
command_register "git_log" "gl" "Pretty git log"
command_register "git_diff" "gd" "Enhanced diff"

# Register AI git commands
command_register "ai_gitflow" "ai_gitflow" "Git workflow assistant"
command_register "ai_gitignore" "ai_gitignore" "Generate .gitignore"

# Register hooks if in git repo
if git rev-parse --git-dir >/dev/null 2>&1; then
    hook_register "pre_commit" "git_pre_commit_hook"
    hook_register "post_commit" "git_post_commit_hook"
fi