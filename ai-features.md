---
layout: default
title: AI Features
---

# AI Features

## Basic Usage

```bash
# Ask anything
ai "how do I squash last 3 commits?"
ai "explain this error: EADDRINUSE"
ai "convert this timestamp: 1641024000"
```

## Memory System

```bash
# Remember context
ai remember "using Next.js 14 with app router"
ai remember --important "API rate limit is 100/hour"
ai remember --tag bug "login fails after midnight"

# Recall context
ai recall                    # Show all memories
ai recall --important        # Show only important
ai recall "database"         # Search memories
```

## File Integration

```bash
# Include files with @
ai "review @src/auth.js"
ai "find bugs in @server.js"
ai "explain @package.json dependencies"
ai "compare @old.config @new.config"
```

## Smart Commands

```bash
# AI-powered grep
aig "TODO comments"          # Finds TODO, FIXME, etc.

# AI-powered find
aif "test files"            # Finds *.test.js, *.spec.ts, etc.

# AI-powered sed
ais "var to const" file.js  # Context-aware replacements

# Fix last error
npm start                   # Error: port in use
ai fix                      # AI fixes the issue
```

## Conversation Management

```bash
# Continue conversations
ai "how do I setup Redis?"
# ... AI response ...
ai continue "what about clustering?"

# Save/restore states
ai freeze "auth-debug"      # Save current conversation
ai thaw "auth-debug"        # Restore later
ai freezelist               # List saved states
```

## Provider Configuration

```bash
# Set your preferred AI
dotfiles config ai_provider claude      # Claude Code
dotfiles config ai_provider gemini      # Google Gemini
dotfiles config ai_provider ollama      # Local Ollama
dotfiles config ai_provider openai-api  # OpenAI API
```

## Advanced Features

### Context Perspectives

```bash
ai-arch "how should I structure this?"   # Architectural view
ai-dev "implement user auth"             # Developer view
ai-fix "minimal change for bug"          # Maintainer view
ai-test "edge cases for login"           # Tester view
ai-review "check my PR"                  # Reviewer view
ai-debug "why is this slow?"             # Debugger view
```

### Import External Context

```bash
# Import from files
ai import @project-docs.md
ai import @meeting-notes.txt

# Auto-discover in parent dirs
ai discover                  # Finds all .ai-memory files
```

### Templates

```bash
# Use templates
ai template bug-report       # Structured bug report
ai template code-review      # Code review checklist
ai template architecture     # Architecture decision
```

## Tips

1. **Be specific** - More context = better answers
2. **Use memories** - Build context over time
3. **Include files** - Let AI see your actual code
4. **Tag important info** - Easy retrieval later
5. **Freeze complex sessions** - Resume debugging later

[Back to home](/) • [Next: Configuration →](configuration)