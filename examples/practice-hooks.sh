#!/usr/bin/env bash
# 🎯 Example: Enforcing Best Practices with Git Hooks
# Copy relevant functions to your project's git hooks

# ============================================================================
# PRE-COMMIT HOOK EXAMPLE
# ============================================================================

# Add to .git/hooks/pre-commit
pre_commit_checks() {
    echo "🔍 Running Dotfiles Plus Best Practice Checks..."
    
    # 1. Security check
    echo "🔒 Checking for secrets..."
    if git diff --staged --name-only | xargs grep -E "(api_key|password|secret|token|private)" 2>/dev/null; then
        echo "❌ Potential secrets detected! Review the above matches."
        echo "💡 Use 'ai-review \"check if these are actual secrets\"' to verify"
        return 1
    fi
    
    # 2. Code quality check
    echo "📝 Running AI code review..."
    local changed_files=$(git diff --staged --name-only | grep -E '\.(js|ts|py|go|rb)$')
    if [[ -n "$changed_files" ]]; then
        echo "$changed_files" | while read -r file; do
            echo "Reviewing: $file"
            # This would need the AI to be available in hook context
            # For now, just remind to review
        done
        echo "💡 Run 'ai-review \"review my staged changes\"' before committing"
    fi
    
    # 3. Test reminder
    echo "🧪 Test check..."
    local code_changes=$(git diff --staged --name-only | grep -v test | grep -E '\.(js|ts|py|go|rb)$')
    if [[ -n "$code_changes" ]]; then
        echo "⚠️  Code changes detected. Have you added/updated tests?"
        echo "💡 Use 'ai testgen <file>' to generate test cases"
    fi
    
    # 4. Documentation check
    if git diff --staged --name-only | grep -E '^(src/|lib/).*\.(js|ts|py|go|rb)$' > /dev/null; then
        echo "📚 Documentation reminder:"
        echo "💡 Update docs if you've changed public APIs"
    fi
    
    return 0
}

# ============================================================================
# COMMIT-MSG HOOK EXAMPLE
# ============================================================================

# Add to .git/hooks/commit-msg
commit_msg_check() {
    local commit_file=$1
    local commit_msg=$(cat "$commit_file")
    
    echo "📝 Checking commit message format..."
    
    # Check conventional commit format
    if ! echo "$commit_msg" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .{1,}$'; then
        echo "❌ Commit message doesn't follow conventional format!"
        echo "Expected format: <type>(<scope>): <subject>"
        echo ""
        echo "Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert"
        echo ""
        echo "💡 Use this helper:"
        echo "ai \"format as conventional commit: $commit_msg\""
        return 1
    fi
    
    # Check message length
    local first_line=$(echo "$commit_msg" | head -1)
    if [[ ${#first_line} -gt 72 ]]; then
        echo "⚠️  First line is ${#first_line} characters (max: 72)"
    fi
    
    return 0
}

# ============================================================================
# POST-CHECKOUT HOOK EXAMPLE
# ============================================================================

# Add to .git/hooks/post-checkout
post_checkout_discover() {
    echo "🔍 Dotfiles Plus: Checking for AI memory files..."
    
    # Auto-discover memory files
    if [[ -f "CLAUDE.md" ]] || [[ -f ".ai-memory" ]] || [[ -f "AI_MEMORY.md" ]]; then
        echo "📚 Found AI memory files in this branch"
        echo "💡 Run 'ai discover' to import team knowledge"
    fi
    
    # Show branch-specific context
    local branch=$(git branch --show-current)
    echo "🌿 Switched to branch: $branch"
    echo "💡 Run 'ai recall' to see branch-specific memories"
}

# ============================================================================
# SHELL PROMPT INTEGRATION
# ============================================================================

# Add to your prompt to show AI context status
ai_context_prompt() {
    local memory_count=$(find "$DOTFILES_CONFIG_HOME/contexts" -type f 2>/dev/null | wc -l)
    if [[ $memory_count -gt 0 ]]; then
        echo "🧠"  # Shows brain emoji when AI has context
    fi
}

# Example PS1 integration
# PS1='$(ai_context_prompt) \u@\h:\w\$ '

# ============================================================================
# AUTOMATED STANDUP
# ============================================================================

# Daily standup helper
daily_standup() {
    echo "📅 Daily Standup - $(date '+%Y-%m-%d')"
    echo "=========================="
    
    # Yesterday's work
    echo "Yesterday:"
    ai recall | grep -A5 "$(date -d yesterday '+%Y-%m-%d' 2>/dev/null || date -v-1d '+%Y-%m-%d')"
    
    # Today's plan
    echo -e "\nToday's Plan:"
    ai recall --tag todo
    
    # Blockers
    echo -e "\nBlockers:"
    ai recall --tag blocker --important
    
    # Save standup
    local standup_file="$HOME/standups/$(date '+%Y-%m-%d').md"
    mkdir -p "$HOME/standups"
    echo "Saving to: $standup_file"
}

# ============================================================================
# CODE REVIEW WORKFLOW
# ============================================================================

# Structured code review process
code_review_workflow() {
    local pr_number=$1
    
    echo "🔍 Starting Code Review for PR #$pr_number"
    
    # Create review context
    ai freeze "review-pr-$pr_number"
    
    # Fetch PR details (requires gh CLI)
    gh pr view "$pr_number"
    
    # Review checklist
    echo -e "\n📋 Review Checklist:"
    echo "[ ] Code follows project style"
    echo "[ ] Tests are included and pass"
    echo "[ ] Documentation is updated"
    echo "[ ] No security vulnerabilities"
    echo "[ ] Performance impact considered"
    echo "[ ] Edge cases handled"
    
    # AI-assisted review
    echo -e "\n🤖 AI Review Suggestions:"
    echo "Run these commands:"
    echo "  ai-review 'review PR #$pr_number for security issues'"
    echo "  ai-review 'check PR #$pr_number for performance impacts'"
    echo "  ai-test 'suggest edge cases for PR #$pr_number'"
    
    # Save review notes
    ai remember --tag review "Reviewing PR #$pr_number"
}

# ============================================================================
# LEARNING TRACKER
# ============================================================================

# Track what you learn
til() {
    local learning="$*"
    ai remember --tag learning "TIL: $learning"
    
    # Add to TIL file
    local til_file="$HOME/til/$(date '+%Y-%m').md"
    mkdir -p "$HOME/til"
    echo "- $(date '+%Y-%m-%d'): $learning" >> "$til_file"
    
    echo "✅ Learned and saved!"
}

# Weekly learning review
learning_review() {
    echo "📚 This Week's Learning"
    echo "====================="
    ai recall --tag learning | grep -A20 "$(date -d '7 days ago' '+%Y-%m-%d' 2>/dev/null || date -v-7d '+%Y-%m-%d')"
    
    echo -e "\n💡 Knowledge Application:"
    ai "based on what I learned this week, what should I practice?"
}

# ============================================================================
# INSTALLATION HELPER
# ============================================================================

install_git_hooks() {
    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -z "$repo_root" ]]; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    echo "📦 Installing Dotfiles Plus git hooks..."
    
    # Create hooks directory
    mkdir -p "$repo_root/.git/hooks"
    
    # Install pre-commit hook
    cat > "$repo_root/.git/hooks/pre-commit" << 'EOF'
#!/usr/bin/env bash
source ~/.dotfiles-plus/dotfiles-plus.sh
source ~/.dotfiles-plus/examples/practice-hooks.sh
pre_commit_checks
EOF
    
    chmod +x "$repo_root/.git/hooks/pre-commit"
    echo "✅ Installed pre-commit hook"
    
    # Install commit-msg hook
    cat > "$repo_root/.git/hooks/commit-msg" << 'EOF'
#!/usr/bin/env bash
source ~/.dotfiles-plus/dotfiles-plus.sh
source ~/.dotfiles-plus/examples/practice-hooks.sh
commit_msg_check "$1"
EOF
    
    chmod +x "$repo_root/.git/hooks/commit-msg"
    echo "✅ Installed commit-msg hook"
    
    echo "🎉 Git hooks installed! Best practices will be enforced automatically."
}

# Show available functions
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "🎯 Dotfiles Plus Practice Hooks"
    echo "=============================="
    echo ""
    echo "Available functions:"
    echo "  pre_commit_checks    - Run before committing"
    echo "  commit_msg_check     - Validate commit messages"
    echo "  post_checkout_discover - Auto-discover AI memories"
    echo "  daily_standup        - Generate standup report"
    echo "  code_review_workflow - Structured PR review"
    echo "  til                  - Track what you learned"
    echo "  learning_review      - Weekly learning summary"
    echo "  install_git_hooks    - Install hooks in current repo"
    echo ""
    echo "To use: source this file and call the functions"
fi