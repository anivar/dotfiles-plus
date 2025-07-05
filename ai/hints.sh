#!/usr/bin/env bash
# 🎯 AI Context Hints
# Temporary context modifiers without persistent state

# ============================================================================
# CONTEXT HINT FUNCTIONS
# ============================================================================

# Architect perspective - focus on design
function _ai_as_architect() {
    local query="$*"
    local hint="[Speaking as a SOFTWARE ARCHITECT] Focus on: system design, patterns, "
    hint+="scalability, interfaces, modularity, and architectural decisions. "
    hint+="Consider long-term implications and design trade-offs. "
    
    _ai_query "${hint}Question: ${query}"
}

# Developer perspective - focus on implementation
function _ai_as_developer() {
    local query="$*"
    local hint="[Speaking as a DEVELOPER] Focus on: practical implementation, "
    hint+="clean code, features, APIs, and efficient solutions. "
    hint+="Be pragmatic and focused on working code. "
    
    _ai_query "${hint}Question: ${query}"
}

# Maintainer perspective - incremental improvements
function _ai_as_maintainer() {
    local query="$*"
    local hint="[Speaking as a MAINTAINER] IMPORTANT: Avoid suggesting complete rewrites. "
    hint+="Focus on: minimal changes, backwards compatibility, targeted fixes, "
    hint+="and incremental improvements. Respect existing patterns. "
    
    _ai_query "${hint}Question: ${query}"
}

# Tester perspective - quality focus  
function _ai_as_tester() {
    local query="$*"
    local hint="[Speaking as a QA ENGINEER] Focus on: test scenarios, edge cases, "
    hint+="error conditions, coverage, validation, and quality metrics. "
    hint+="Think about what could go wrong. "
    
    _ai_query "${hint}Question: ${query}"
}

# Reviewer perspective - code review
function _ai_as_reviewer() {
    local query="$*"
    local hint="[Speaking as a CODE REVIEWER] Look for: security issues, "
    hint+="performance problems, code smells, best practices, potential bugs. "
    hint+="Be constructive and specific with feedback. "
    
    _ai_query "${hint}Question: ${query}"
}

# Debugger perspective - root cause analysis
function _ai_as_debugger() {
    local query="$*"
    local hint="[Speaking as a DEBUGGER] Focus on: root cause analysis, "
    hint+="systematic investigation, reproduction steps, logging strategies. "
    hint+="Help trace and isolate the issue. "
    
    _ai_query "${hint}Question: ${query}"
}

# ============================================================================
# QUICK ALIASES
# ============================================================================

# Short aliases for common perspectives
alias ai-arch='_ai_as_architect'
alias ai-dev='_ai_as_developer'
alias ai-fix='_ai_as_maintainer'
alias ai-test='_ai_as_tester'
alias ai-review='_ai_as_reviewer'
alias ai-debug='_ai_as_debugger'

# ============================================================================
# SMART SUGGESTIONS
# ============================================================================

# Suggest appropriate perspective based on query
function _ai_suggest_perspective() {
    local query="$1"
    local suggestion=""
    
    # Pattern matching for suggestions
    if [[ "$query" =~ design|architecture|pattern|scale ]]; then
        suggestion="ai-arch"
    elif [[ "$query" =~ implement|create|build|add ]]; then
        suggestion="ai-dev"
    elif [[ "$query" =~ fix|repair|patch|maintain ]]; then
        suggestion="ai-fix"
    elif [[ "$query" =~ test|coverage|edge|case|quality ]]; then
        suggestion="ai-test"
    elif [[ "$query" =~ review|security|smell|improve ]]; then
        suggestion="ai-review"
    elif [[ "$query" =~ debug|error|bug|trace|why ]]; then
        suggestion="ai-debug"
    fi
    
    if [[ -n "$suggestion" ]]; then
        echo "💡 Consider using: $suggestion \"$query\""
    fi
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export functions for use
# Note: No export -f to avoid zsh issues