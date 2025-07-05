#!/usr/bin/env bash
# 📥 AI Memory Import System
# Inspired by Claude Code's import feature

# ============================================================================
# IMPORT FUNCTIONS
# ============================================================================

# Import external memory file
function _ai_import_memory() {
    local import_path="$1"
    local max_depth="${2:-5}"
    
    # Handle @ prefix
    if [[ "$import_path" =~ ^@ ]]; then
        import_path="${import_path:1}"
    fi
    
    # Expand tilde for home directory
    import_path="${import_path/#\~/$HOME}"
    
    # Security check
    if [[ ! -f "$import_path" ]]; then
        echo "❌ File not found: $import_path" >&2
        return 1
    fi
    
    # Check file extension
    if [[ ! "$import_path" =~ \.(md|txt|ai-memory)$ ]]; then
        echo "❌ Unsupported file type. Use .md, .txt, or .ai-memory files" >&2
        return 1
    fi
    
    # Import the file
    echo "📥 Importing: $import_path"
    local content=$(cat "$import_path" 2>/dev/null)
    
    if [[ -n "$content" ]]; then
        # Add import header
        local import_header="[IMPORTED FROM: $import_path at $(date '+%Y-%m-%d %H:%M:%S')]"
        
        # Save to current context
        ai remember "$import_header"
        ai remember "$content"
        
        echo "✅ Imported $(echo "$content" | wc -l) lines"
    else
        echo "❌ File is empty or unreadable" >&2
        return 1
    fi
}

# Discover memory files up the directory tree
function _ai_discover_memories() {
    local current_dir="$(pwd)"
    local depth=0
    local max_depth="${1:-5}"
    local found_files=()
    
    echo "🔍 Discovering AI memory files..."
    
    while [[ "$current_dir" != "/" && "$current_dir" != "$HOME" && $depth -lt $max_depth ]]; do
        # Look for memory files
        for pattern in "CLAUDE.md" ".ai-memory" "*.ai-memory" "AI_MEMORY.md"; do
            for file in "$current_dir"/$pattern; do
                if [[ -f "$file" ]]; then
                    found_files+=("$file")
                    echo "  📄 Found: $file"
                fi
            done
        done
        
        # Move up one directory
        current_dir="$(dirname "$current_dir")"
        ((depth++))
    done
    
    if [[ ${#found_files[@]} -gt 0 ]]; then
        echo ""
        echo "Found ${#found_files[@]} memory files. Import them?"
        echo "1) Import all"
        echo "2) Select individually"
        echo "3) Cancel"
        
        read -r choice
        case $choice in
            1)
                for file in "${found_files[@]}"; do
                    _ai_import_memory "$file"
                done
                ;;
            2)
                for file in "${found_files[@]}"; do
                    echo ""
                    echo "Import $file? (y/n)"
                    read -r confirm
                    if [[ "$confirm" == "y" ]]; then
                        _ai_import_memory "$file"
                    fi
                done
                ;;
            *)
                echo "Cancelled"
                ;;
        esac
    else
        echo "No memory files found in parent directories"
    fi
}

# Parse imports from a memory file
function _ai_parse_imports() {
    local file="$1"
    local imports=()
    
    while IFS= read -r line; do
        # Look for @import syntax
        if [[ "$line" =~ ^[[:space:]]*@([^[:space:]]+) ]]; then
            imports+=("${BASH_REMATCH[1]}")
        fi
    done < "$file"
    
    printf '%s\n' "${imports[@]}"
}

# Process imports recursively
function _ai_process_imports() {
    local file="$1"
    local depth="${2:-0}"
    local max_depth="${3:-5}"
    local processed_files=("${@:4}")
    
    # Check if already processed
    for pf in "${processed_files[@]}"; do
        if [[ "$pf" == "$file" ]]; then
            return 0
        fi
    done
    
    if [[ $depth -ge $max_depth ]]; then
        echo "⚠️  Max import depth reached for: $file" >&2
        return 1
    fi
    
    processed_files+=("$file")
    
    # Get imports from file
    local imports=($(_ai_parse_imports "$file"))
    
    for import in "${imports[@]}"; do
        local import_path="${import/#\~/$HOME}"
        
        if [[ -f "$import_path" ]]; then
            echo "  $('  ' | sed "s/./  /g")↳ Importing: $import_path"
            _ai_process_imports "$import_path" $((depth + 1)) "$max_depth" "${processed_files[@]}"
        fi
    done
}

# ============================================================================
# TEMPLATE SYSTEM
# ============================================================================

# Memory templates for common scenarios
function _ai_template() {
    local template_name="$1"
    local template_dir="$DOTFILES_CONFIG_HOME/templates"
    
    mkdir -p "$template_dir"
    
    case "$template_name" in
        "bug-report")
            cat > "$template_dir/bug-report.ai-memory" << 'EOF'
# Bug Report Template

## Issue Description
[Describe the bug]

## Steps to Reproduce
1. 
2. 
3. 

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS: 
- Shell: 
- Version: 

## Additional Context
[Any other relevant information]
EOF
            echo "✅ Created bug-report template"
            ;;
            
        "feature-planning")
            cat > "$template_dir/feature-planning.ai-memory" << 'EOF'
# Feature Planning Template

## Feature Name
[Name of the feature]

## Problem Statement
[What problem does this solve?]

## Proposed Solution
[High-level approach]

## Implementation Steps
1. 
2. 
3. 

## Considerations
- Security: 
- Performance: 
- Compatibility: 

## Success Criteria
[How do we know it's working?]
EOF
            echo "✅ Created feature-planning template"
            ;;
            
        "code-review")
            cat > "$template_dir/code-review.ai-memory" << 'EOF'
# Code Review Template

## Review Focus
[What aspects to focus on]

## Key Files
- 
- 

## Review Checklist
- [ ] Security vulnerabilities
- [ ] Performance issues
- [ ] Code style consistency
- [ ] Test coverage
- [ ] Documentation

## Findings
[Document issues found]

## Recommendations
[Suggested improvements]
EOF
            echo "✅ Created code-review template"
            ;;
            
        "list")
            echo "📋 Available templates:"
            ls -1 "$template_dir"/*.ai-memory 2>/dev/null | while read -r file; do
                echo "  - $(basename "$file" .ai-memory)"
            done
            ;;
            
        *)
            echo "❌ Unknown template: $template_name"
            echo "Available templates: bug-report, feature-planning, code-review"
            return 1
            ;;
    esac
    
    if [[ "$template_name" != "list" && -f "$template_dir/$template_name.ai-memory" ]]; then
        echo ""
        echo "Use template with:"
        echo "  ai import @$template_dir/$template_name.ai-memory"
    fi
}

# ============================================================================
# AUTO-DISCOVERY
# ============================================================================

# Auto-discover and load memory files on cd
function _ai_auto_discover() {
    local current_dir="$(pwd)"
    local marker_file="$DOTFILES_CONFIG_HOME/.last_auto_discover"
    
    # Check if we've already discovered for this directory
    if [[ -f "$marker_file" ]]; then
        local last_dir=$(cat "$marker_file")
        if [[ "$last_dir" == "$current_dir" ]]; then
            return 0
        fi
    fi
    
    # Look for memory files in current directory
    local found_memory=false
    for pattern in "CLAUDE.md" ".ai-memory" "AI_MEMORY.md"; do
        if [[ -f "$current_dir/$pattern" ]]; then
            found_memory=true
            break
        fi
    done
    
    if [[ "$found_memory" == "true" ]]; then
        echo "🔍 Found AI memory files in this directory"
        echo "💡 Use 'ai discover' to import them or 'ai import @./$pattern' for specific file"
        
        # Mark as discovered
        echo "$current_dir" > "$marker_file"
    fi
}

# Hook into cd command for auto-discovery (optional)
function _ai_setup_auto_discover() {
    # For bash
    if [[ -n "$BASH_VERSION" ]]; then
        # Override cd to include auto-discovery
        function cd() {
            builtin cd "$@" && _ai_auto_discover
        }
    fi
    
    # For zsh
    if [[ -n "$ZSH_VERSION" ]]; then
        # Use chpwd hook
        function chpwd() {
            _ai_auto_discover
        }
    fi
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export functions for use
# Note: No export -f to avoid zsh issues