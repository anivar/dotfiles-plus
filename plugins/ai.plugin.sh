#!/usr/bin/env bash
# AI Plugin - Complete AI functionality with roadmap features

# ============================================================================
# CORE SETUP
# ============================================================================

# Memory database
MEMORY_DB="$DOTFILES_HOME/state/memories.db"
MEMORY_INDEX="$DOTFILES_HOME/state/memories.idx"

# Initialize - defer until core functions are available
ai_init() {
    ensure_dir "$DOTFILES_HOME/state"
    [[ ! -f "$MEMORY_DB" ]] && echo "# Dotfiles Plus Memory Database" > "$MEMORY_DB"
}

# Initialize immediately since we're already being loaded
ai_init

# ============================================================================
# PROVIDER DETECTION & MANAGEMENT
# ============================================================================

ai_detect_provider() {
    # Check Claude Code/CLI
    if [[ -d "$HOME/Library/Application Support/Claude" ]] || \
       [[ -d "$HOME/.config/claude" ]] || \
       command_exists claude; then
        echo "claude"
        return 0
    fi
    
    # Check Gemini
    if [[ -f "$HOME/.gemini/config.json" ]] || \
       [[ -f "$HOME/.config/gemini/config.json" ]] || \
       command_exists gemini; then
        echo "gemini"
        return 0
    fi
    
    # Check Ollama
    if command_exists ollama; then
        echo "ollama"
        return 0
    fi
    
    # Check API keys
    [[ -n "${ANTHROPIC_API_KEY:-}" ]] && echo "claude-api" && return 0
    [[ -n "${GEMINI_API_KEY:-}${GOOGLE_API_KEY:-}" ]] && echo "gemini-api" && return 0
    [[ -n "${OPENAI_API_KEY:-}" ]] && echo "openai-api" && return 0
    [[ -n "${OPENROUTER_API_KEY:-}" ]] && echo "openrouter" && return 0
    
    return 1
}

# ============================================================================
# @FILE SUPPORT & CONTEXT BUILDING (v1.3 Roadmap)
# ============================================================================

process_at_files() {
    local query="$1"
    local processed_query="$query"
    local context=""
    
    # Find all @file references
    while [[ "$query" =~ @([^[:space:]]+) ]]; do
        local file_ref="${BASH_REMATCH[1]}"
        local file_path="$file_ref"
        
        # Handle glob patterns
        if [[ "$file_ref" =~ \* ]]; then
            local files=($file_ref)
            for f in "${files[@]}"; do
                if [[ -f "$f" ]]; then
                    context+="\n--- File: $f ---\n"
                    context+=$(head -500 "$f" 2>/dev/null)
                fi
            done
            processed_query="${processed_query//@$file_ref/[files included]}"
        else
            # Single file
            if [[ -f "$file_path" ]]; then
                context+="\n--- File: $file_path ---\n"
                context+=$(head -500 "$file_path" 2>/dev/null)
                processed_query="${processed_query//@$file_ref/[file included]}"
            fi
        fi
        
        # Remove processed reference
        query="${query//@$file_ref/}"
    done
    
    echo -e "${context}\n\nQuery: ${processed_query}"
}

build_smart_context() {
    local query="$1"
    local context=""
    
    # Add recent memories
    if [[ -f "$MEMORY_DB" ]]; then
        local memories=$(tail -10 "$MEMORY_DB" | grep -v '^#' | tac)
        [[ -n "$memories" ]] && context+="Recent context:\n$memories\n\n"
    fi
    
    # Add project context
    if [[ -f ".ai-memory" ]]; then
        context+="Project context:\n$(cat .ai-memory)\n\n"
    fi
    
    # Auto-include relevant files (v1.3 feature)
    if [[ "$(state_get 'ai_auto_context' 'true')" == "true" ]]; then
        # Package files
        for f in package.json Cargo.toml go.mod requirements.txt Gemfile; do
            [[ -f "$f" ]] && context+="--- $f ---\n$(head -50 "$f")\n\n"
        done
        
        # Git context for relevant queries
        if [[ "$query" =~ (change|diff|commit|review) ]]; then
            local git_diff=$(git diff --stat 2>/dev/null | head -20)
            [[ -n "$git_diff" ]] && context+="Git changes:\n$git_diff\n\n"
        fi
    fi
    
    echo "$context"
}

# ============================================================================
# MAIN AI QUERY ENGINE
# ============================================================================

ai_query() {
    local raw_query="$*"
    
    if [[ -z "$raw_query" ]]; then
        ai_help
        return 0
    fi
    
    # Check provider
    local provider=$(state_get "ai_provider" "$(ai_detect_provider)")
    if [[ -z "$provider" ]] || [[ "$provider" == "" ]]; then
        log error "No AI provider configured! Run: dotfiles setup"
        return 1
    fi
    
    # Process @file references (v1.3 feature)
    local processed_query=$(process_at_files "$raw_query")
    
    # Build context
    local context=$(build_smart_context "$raw_query")
    local full_query="${context}${processed_query}"
    
    # Log query
    echo "${ICON_AI} AI Query [$provider]: $raw_query"
    
    # Execute based on provider
    case "$provider" in
        claude)
            echo "$full_query" | claude
            ;;
        gemini)
            echo "$full_query" | gemini
            ;;
        ollama)
            local model=$(state_get "ollama_model" "llama3")
            echo "$full_query" | ollama run "$model"
            ;;
        openrouter)
            ai_api_query "$provider" "$full_query"
            ;;
        *)
            log error "Provider $provider not implemented"
            return 1
            ;;
    esac
}

# API-based providers
ai_api_query() {
    local provider="$1"
    local query="$2"
    
    case "$provider" in
        openrouter)
            local api_key="${OPENROUTER_API_KEY:-}"
            local model=$(state_get "openrouter_model" "anthropic/claude-3-sonnet")
            
            curl -s -X POST "https://openrouter.ai/api/v1/chat/completions" \
                -H "Authorization: Bearer $api_key" \
                -H "Content-Type: application/json" \
                -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"$query\"}]}" \
                | jq -r '.choices[0].message.content' 2>/dev/null
            ;;
    esac
}

# ============================================================================
# MEMORY SYSTEM
# ============================================================================

ai_remember() {
    local content="$*"
    local tags=""
    local important="false"
    
    # Parse options
    while [[ "$1" =~ ^- ]]; do
        case "$1" in
            -i|--important) important="true"; shift ;;
            -t|--tag) tags="$2"; shift 2 ;;
            *) break ;;
        esac
    done
    
    content="$*"
    [[ -z "$content" ]] && log error "Nothing to remember" && return 1
    
    # Context
    local repo_path
    repo_path=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
    local repo
    if [[ -n "$repo_path" ]]; then
        repo=$(basename "$repo_path")
    else
        repo="none"
    fi
    local branch=$(git branch --show-current 2>/dev/null || echo "none")
    local dir=$(pwd)
    
    # Auto-tags - use case-insensitive matching for compatibility
    local content_lower=$(echo "$content" | tr '[:upper:]' '[:lower:]')
    [[ "$content_lower" =~ todo ]] && tags="${tags:+$tags,}todo"
    [[ "$content_lower" =~ fixme ]] || [[ "$content_lower" =~ bug ]] && tags="${tags:+$tags,}bug"
    [[ "$content" =~ http:// ]] || [[ "$content" =~ https:// ]] && tags="${tags:+$tags,}link"
    [[ "$important" == "true" ]] && tags="${tags:+$tags,}important"
    
    # Save
    local id=$(echo "$content" | shasum | cut -c1-8)
    echo "$(timestamp)|$id|$repo:$branch:$dir|${tags:-none}|$content" >> "$MEMORY_DB"
    
    log success "Remembered: $content"
    [[ -n "$tags" ]] && echo "   Tags: $tags"
}

ai_recall() {
    local search="$1"
    local tag_filter=""
    local limit=20
    
    # Parse options
    while [[ "$1" =~ ^- ]]; do
        case "$1" in
            -t|--tag) tag_filter="$2"; shift 2 ;;
            -n|--limit) limit="$2"; shift 2 ;;
            *) search="$1"; shift ;;
        esac
    done
    
    echo "🧠 Memory Recall"
    echo "━━━━━━━━━━━━━━"
    
    local count=0
    while IFS='|' read -r timestamp id level tags content; do
        [[ "$timestamp" =~ ^# ]] && continue
        
        # Filters
        [[ -n "$search" ]] && [[ ! "$content" =~ $search ]] && continue
        [[ -n "$tag_filter" ]] && [[ ! "$tags" =~ $tag_filter ]] && continue
        
        echo "[$timestamp] $content"
        [[ "$tags" != "none" ]] && echo "   📌 $tags"
        
        ((count++))
        [[ $count -ge $limit ]] && break
    done < <(tac "$MEMORY_DB" 2>/dev/null)
    
    [[ $count -eq 0 ]] && echo "No memories found."
}

ai_forget() {
    echo -n "Clear all memories? [y/N]: "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "# Dotfiles Plus Memory Database" > "$MEMORY_DB"
        log success "Memory cleared"
    fi
}

ai_stats() {
    local total=$(grep -v '^#' "$MEMORY_DB" 2>/dev/null | wc -l)
    local tags=$(grep -v '^#' "$MEMORY_DB" 2>/dev/null | cut -d'|' -f4 | tr ',' '\n' | sort | uniq -c | sort -rn)
    
    echo "📊 Memory Statistics"
    echo "━━━━━━━━━━━━━━━━━"
    echo "Total memories: $total"
    echo ""
    echo "Top tags:"
    echo "$tags" | head -10
}

# ============================================================================
# ADVANCED FEATURES (v1.3+)
# ============================================================================

# Deep thinking mode
ai_think() {
    local problem="$*"
    [[ -z "$problem" ]] && log error "No problem provided" && return 1
    
    echo "🤔 Thinking deeply about: $problem"
    echo ""
    
    # Multi-step analysis
    local steps=(
        "Understanding the problem"
        "Breaking down components"
        "Analyzing approaches"
        "Considering trade-offs"
        "Formulating solution"
    )
    
    for step in "${steps[@]}"; do
        echo "▶ $step..."
        ai_query "$step: $problem"
        echo ""
        sleep 1
    done
}

# Fix last command
ai_fix() {
    local last_cmd=$(fc -ln -1 | sed 's/^[[:space:]]*//')
    local last_exit=$?
    
    [[ $last_exit -eq 0 ]] && log info "Last command succeeded" && return 0
    
    local error_output=$($last_cmd 2>&1)
    local fix=$(ai_query "Fix this command: $last_cmd\nError: $error_output\nProvide ONLY the corrected command.")
    
    echo "Suggested: $fix"
    echo -n "Run? [Y/n]: "
    read -r response
    [[ ! "$response" =~ ^[Nn]$ ]] && eval "$fix"
}

# Explain last
ai_explain_last() {
    local last_cmd=$(fc -ln -1)
    local output=$(eval "$last_cmd" 2>&1 | head -100)
    ai_query "Explain this command and output:\nCommand: $last_cmd\nOutput: $output"
}

# Suggest next
ai_suggest() {
    local history=$(fc -l -10 | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//')
    ai_query "Based on these commands:\n$history\n\nSuggest the next logical command."
}

# Import memories
ai_import() {
    local source="${1#@}"  # Remove @ prefix
    [[ -f "$source" ]] || { log error "File not found: $source"; return 1; }
    
    while IFS= read -r line; do
        [[ -n "$line" ]] && [[ ! "$line" =~ ^# ]] && ai_remember "$line"
    done < "$source"
    
    log success "Imported from $source"
}

# Discover memories
ai_discover() {
    local found=0
    local dir="$PWD"
    
    while [[ "$dir" != "/" ]]; do
        for file in ".ai-memory" "CLAUDE.md" "AI_CONTEXT.md"; do
            if [[ -f "$dir/$file" ]]; then
                log success "Found: $dir/$file"
                ai_import "$dir/$file"
                ((found++))
            fi
        done
        dir=$(dirname "$dir")
    done
    
    [[ $found -eq 0 ]] && log info "No memory files found"
}

# ============================================================================
# AI-POWERED COMMANDS (v1.4 Roadmap)
# ============================================================================

# Natural language grep
aig() {
    local query="$1"
    shift
    local pattern=$(ai_query "Convert to grep regex: $query. Reply with ONLY the pattern." | tr -d '\n')
    log info "Pattern: $pattern"
    grep -r "$pattern" "$@"
}

# Smart find
aif() {
    local query="$1"
    local path="${2:-.}"
    local find_args=$(ai_query "Convert to find arguments: $query. Reply with ONLY the arguments." | tr -d '\n')
    log info "Finding: find $path $find_args"
    eval "find $path $find_args"
}

# AI sed
ais() {
    local transform="$1"
    local file="$2"
    [[ -z "$file" ]] && { log error "Usage: ais \"transformation\" file"; return 1; }
    
    local sed_expr=$(ai_query "Convert to sed expression: $transform. Reply with ONLY s/.../.../ format." | tr -d '\n')
    log info "Transform: $sed_expr"
    
    # Preview
    sed "$sed_expr" "$file" | diff -u "$file" - || true
    echo -n "Apply? [Y/n]: "
    read -r response
    [[ ! "$response" =~ ^[Nn]$ ]] && sed -i.bak "$sed_expr" "$file"
}

# AI history search
aih() {
    local query="$1"
    local limit="${2:-20}"
    
    [[ -z "$query" ]] && { log error "Usage: aih \"search query\" [limit]"; return 1; }
    
    # Get search pattern from AI
    local pattern=$(ai_query "Convert to history search pattern: $query. Reply with ONLY the pattern." | tr -d '\n')
    log info "Searching history for: $pattern"
    
    # Search shell history
    if [[ -n "$ZSH_VERSION" ]]; then
        fc -l -${limit} | grep -i "$pattern"
    else
        history ${limit} | grep -i "$pattern"
    fi
}

# Pipe support
ai_pipe() {
    local query="${1:-summarize}"
    local input=$(cat)
    ai_query "$query this:\n\`\`\`\n$input\n\`\`\`"
}

# ============================================================================
# TEMPLATES & CONTINUATION
# ============================================================================

ai_template() {
    local cmd="${1:-list}"
    local template_dir="$DOTFILES_HOME/templates"
    ensure_dir "$template_dir"
    
    case "$cmd" in
        list)
            echo "📝 Templates:"
            ls -1 "$template_dir" 2>/dev/null | sed 's/\.md$//' || echo "  (none)"
            ;;
        save)
            local name="$2"
            local content="${@:3}"
            [[ -z "$name" ]] && { log error "Name required"; return 1; }
            echo "$content" > "$template_dir/$name.md"
            log success "Saved template: $name"
            ;;
        use)
            local name="$2"
            local args="${@:3}"
            [[ -f "$template_dir/$name.md" ]] || { log error "Template not found: $name"; return 1; }
            local template=$(cat "$template_dir/$name.md")
            ai_query "${template/\{\}/$args}"
            ;;
    esac
}

ai_continue() {
    local last_query=$(state_get "last_ai_query" "")
    [[ -z "$last_query" ]] && { log error "No previous query"; return 1; }
    
    echo "Continuing from: $last_query"
    ai_query "$@"
}

# ============================================================================
# SMART CONTEXT & HOOKS
# ============================================================================

ai_context_update() {
    local dir="$1"
    
    # Detect project type
    local project_type="unknown"
    [[ -f "package.json" ]] && project_type="node"
    [[ -f "go.mod" ]] && project_type="go"
    [[ -f "Cargo.toml" ]] && project_type="rust"
    [[ -f "requirements.txt" ]] && project_type="python"
    
    state_set "project_type" "$project_type"
    
    # Auto-discover memories
    if [[ "$(state_get 'auto_discover' 'true')" == "true" ]]; then
        [[ -f ".ai-memory" ]] && ai_import ".ai-memory" >/dev/null 2>&1
    fi
}

# ============================================================================
# FREEZE/THAW CONVERSATION STATES (v1.2)
# ============================================================================

# Save conversation state
ai_freeze() {
    local name="${1:-freeze_$(date +%s)}"
    local freeze_dir="$DOTFILES_HOME/freezes"
    ensure_dir "$freeze_dir"
    
    local freeze_file="$freeze_dir/$name.freeze"
    
    # Save current context
    {
        echo "# Frozen at: $(timestamp)"
        echo "# Directory: $PWD"
        echo "# Branch: $(git branch --show-current 2>/dev/null || echo 'none')"
        echo ""
        
        # Save recent memories
        if [[ -f "$MEMORY_DB" ]]; then
            echo "# Recent memories:"
            tail -20 "$MEMORY_DB" | grep -v '^#'
        fi
        
        # Save last query
        local last_query=$(state_get "last_ai_query" "")
        [[ -n "$last_query" ]] && echo "# Last query: $last_query"
        
    } > "$freeze_file"
    
    log success "Conversation frozen as: $name"
}

# Restore conversation state
ai_thaw() {
    local name="$1"
    [[ -z "$name" ]] && { log error "Freeze name required"; return 1; }
    
    local freeze_file="$DOTFILES_HOME/freezes/$name.freeze"
    
    if [[ -f "$freeze_file" ]]; then
        echo "❄️ Thawing conversation: $name"
        echo ""
        cat "$freeze_file"
        
        # Restore memories
        while IFS= read -r line; do
            [[ "$line" =~ ^#.*Last\ query:\ (.*)$ ]] && state_set "last_ai_query" "${BASH_REMATCH[1]}"
            [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]] && echo "$line" >> "$MEMORY_DB"
        done < "$freeze_file"
        
        log success "Conversation restored"
    else
        log error "Freeze not found: $name"
    fi
}

# List frozen conversations
ai_freeze_list() {
    local freeze_dir="$DOTFILES_HOME/freezes"
    
    echo "❄️ Frozen Conversations"
    echo "━━━━━━━━━━━━━━━━━━━━━"
    
    if [[ -d "$freeze_dir" ]]; then
        for freeze in "$freeze_dir"/*.freeze; do
            [[ -f "$freeze" ]] || continue
            
            local name=$(basename "$freeze" .freeze)
            local date=$(grep "^# Frozen at:" "$freeze" | cut -d: -f2-)
            local dir=$(grep "^# Directory:" "$freeze" | cut -d: -f2- | xargs basename 2>/dev/null)
            
            echo "• $name"
            echo "  Frozen: $date"
            [[ -n "$dir" ]] && echo "  Dir: $dir"
            echo ""
        done
    else
        echo "No frozen conversations"
    fi
}

# ============================================================================
# TEST GENERATION (v1.2)
# ============================================================================

# Generate tests for code
ai_testgen() {
    local target="$1"
    local framework="${2:-auto}"
    
    [[ -z "$target" ]] && { log error "Target required (file, function, or description)"; return 1; }
    
    # Detect test framework
    if [[ "$framework" == "auto" ]]; then
        if [[ -f "package.json" ]] && grep -q "jest" "package.json"; then
            framework="jest"
        elif [[ -f "package.json" ]] && grep -q "mocha" "package.json"; then
            framework="mocha"
        elif [[ -f "go.mod" ]]; then
            framework="go"
        elif [[ -f "requirements.txt" ]] && grep -q "pytest" "requirements.txt"; then
            framework="pytest"
        else
            framework="generic"
        fi
    fi
    
    echo "🧪 Generating tests for: $target"
    echo "Framework: $framework"
    echo ""
    
    # Build query with context
    local query="Generate comprehensive unit tests for: $target\n\n"
    
    # Include file if it exists
    if [[ -f "$target" ]]; then
        query+="Code to test:\n\`\`\`\n$(cat "$target")\n\`\`\`\n\n"
    fi
    
    query+="Requirements:\n"
    query+="- Framework: $framework\n"
    query+="- Include edge cases and error handling\n"
    query+="- Add comments explaining test purpose\n"
    query+="- Follow best practices for $framework\n"
    query+="- Make tests independent and deterministic\n"
    
    ai_query "$query"
}

# ============================================================================
# REGISTRATION
# ============================================================================

# Main AI command with smart routing
ai() {
    local first="${1:-}"
    
    # Check if it's a subcommand
    case "$first" in
        remember|recall|forget|think|import|discover|stats|clean|fix|suggest|template|continue)
            shift
            "ai_$first" "$@"
            ;;
        explain-last)
            shift
            ai_explain_last "$@"
            ;;
        freeze)
            shift
            ai_freeze "$@"
            ;;
        thaw)
            shift
            ai_thaw "$@"
            ;;
        freezelist)
            shift
            ai_freeze_list "$@"
            ;;
        testgen)
            shift
            ai_testgen "$@"
            ;;
        help)
            ai_help
            ;;
        "")
            ai_help
            ;;
        *)
            # Save query for continue
            state_set "last_ai_query" "$*"
            ai_query "$@"
            ;;
    esac
}

# Register commands
command_register "ai" "ai" "AI assistant"

# Register AI-powered commands
alias aig='aig'
alias aif='aif'
alias ais='ais'
alias aih='aih'

# Pipe support (zsh)
[[ -n "$ZSH_VERSION" ]] && alias -g AI='| ai_pipe'

# Hooks
hook_register "directory_changed" "ai_context_update" 20

# Help
ai_help() {
    cat << 'EOF'
🤖 AI Commands:

Query:
  ai "question"              Ask AI anything
  ai "explain @file.js"      Include files with @
  ai "review @*.py"          Use glob patterns

Memory:
  ai remember "info"         Save context
  ai recall [search]         Show memories
  ai forget                  Clear memories
  ai stats                   Memory statistics
  ai import @file            Import memories
  ai discover                Find project memories

Advanced:
  ai think "problem"         Deep analysis
  ai fix                     Fix last command
  ai explain-last            Explain last command
  ai suggest                 Suggest next command
  ai template <cmd>          Manage templates
  ai continue                Continue conversation

Conversation States:
  ai freeze [name]           Save conversation state
  ai thaw <name>             Restore conversation
  ai freezelist              List saved states

Development:
  ai testgen <target>        Generate unit tests

AI Commands:
  aig "search"               Natural language grep
  aif "find files"           Smart file search
  ais "transform" file       AI-powered sed
  aih "query" [limit]        AI-powered history search

Pipe:
  command | ai "query"       Process output

Perspectives:
  ai-arch "question"         Ask as architect
  ai-dev "question"          Ask as developer
  ai-fix "question"          Ask as maintainer
  ai-test "question"         Ask as tester
  ai-review "question"       Ask as reviewer
  ai-debug "question"        Ask as debugger
EOF
}

# ============================================================================
# CONTEXT PERSPECTIVES (No State Collision)
# ============================================================================

# Architecture perspective
ai-arch() {
    local query="$*"
    ai_query "As a software architect focusing on design patterns, scalability, and maintainability: $query"
}

# Developer perspective
ai-dev() {
    local query="$*"
    ai_query "As a developer focusing on implementation details and code quality: $query"
}

# Maintainer perspective (minimal changes)
ai-fix() {
    local query="$*"
    ai_query "As a maintainer focusing on minimal, safe changes that won't break existing functionality: $query"
}

# Tester perspective
ai-test() {
    local query="$*"
    ai_query "As a QA engineer focusing on edge cases, test coverage, and quality assurance: $query"
}

# Reviewer perspective
ai-review() {
    local query="$*"
    ai_query "As a code reviewer focusing on best practices, security, and maintainability: $query"
}

# Debugger perspective
ai-debug() {
    local query="$*"
    ai_query "As a debugger focusing on root cause analysis and systematic problem solving: $query"
}

# Register perspective commands
for perspective in arch dev fix test review debug; do
    alias_register "ai-$perspective" "ai-$perspective"
done