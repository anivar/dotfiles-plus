---
layout: default
title: Command Reference - AI Terminal Commands
description: Complete reference for AI-powered terminal commands, bash AI integration, Claude CLI commands, ChatGPT terminal tools, and shell automation with artificial intelligence
keywords: ai terminal commands, bash ai integration, claude cli, chatgpt terminal, gemini command line, ollama shell, ai powered bash, terminal automation
---

# 🤖 AI-Powered Terminal Commands Reference

Master the complete set of AI-enhanced terminal commands for developers. Transform your command line with artificial intelligence.

## 📚 Table of Contents

- [Core Commands](#core-commands)
- [AI Commands](#ai-commands)
- [Git Enhancements](#git-enhancements)
- [Security Commands](#security-commands)
- [Performance Tools](#performance-tools)
- [Plugin Management](#plugin-management)

## 🎯 Core Commands

### `dotfiles` - Main Command Interface

```bash
# System Management
dotfiles version              # Show version
dotfiles health              # Run health check
dotfiles update              # Update to latest
dotfiles reload              # Reload configuration
dotfiles status              # System status

# Configuration
dotfiles config get <key>    # Get config value
dotfiles config set <key> <value>  # Set config
dotfiles config list         # Show all config
dotfiles config reset        # Reset to defaults

# Backup & Restore
dotfiles backup create [name]  # Create backup
dotfiles backup list          # List backups
dotfiles backup restore <name> # Restore backup
dotfiles backup delete <name>  # Delete backup
```

## 🤖 AI Commands

### `ai` - Natural Language Terminal Assistant

Transform your terminal with AI-powered natural language commands:

```bash
# Basic AI Queries
ai "how do I find large files"
ai "explain this error: permission denied"
ai "what's the command to compress a folder"

# Code Analysis
ai "review this code for security issues" @app.js
ai "explain what this function does" @utils.py:42
ai "find bugs in" @src/*.js

# Multi-file Operations
ai "compare these configs" @prod.json @dev.json
ai "refactor for better performance" @slow-query.sql
```

### Smart Terminal Fixes

```bash
# Auto-fix Failed Commands
$ npm install
# Error: EACCES permission denied
$ ai fix
# → sudo npm install -g with proper permissions

# Explain Last Command
$ find . -name "*.log" -mtime +30 -delete
$ ai explain-last
# → "This finds all .log files older than 30 days and deletes them"

# Get Next Suggestions
$ git add .
$ ai suggest
# → "git commit -m 'message'" or "git status" to review
```

### AI-Powered Shell Tools

```bash
# Natural Language Grep (aig)
aig "find error messages"            # Searches all files
aig "security warnings" /var/log     # Search specific path
aig "TODO or FIXME" --type=python   # Language-specific

# Smart Find (aif)
aif "configuration files"            # Finds .conf, .config, etc.
aif "large images"                   # Finds image files >1MB
aif "recently modified python"       # Recent .py files

# AI-Powered Sed (ais)
ais "change all var to const" app.js
ais "update copyright to 2024" *.md
ais "fix typos" README.md

# Smart History Search (aih)
aih "docker commands"                # Find docker in history
aih "last git push"                  # Find recent git push
aih "commands with sudo"             # Security audit
```

### AI Memory System

```bash
# Remember Context
ai remember "using Next.js 14 with App Router"
ai remember --tag=security "API uses JWT with 1hr expiry"
ai remember --important "production uses PostgreSQL 15"
ai remember --project "client prefers TypeScript strict mode"

# Recall Information
ai recall                    # Show all memories
ai recall --recent          # Last 7 days
ai recall --tag=security    # By category
ai recall "database"        # Search memories
ai recall --important       # Priority items only

# Manage Memory
ai forget <id>              # Remove specific memory
ai memories clean           # Remove old memories
ai memories export          # Backup memories
ai memories import <file>   # Restore memories
ai stats                    # Memory statistics
```

### AI Conversation Management

```bash
# Conversation Control
ai continue                 # Continue last conversation
ai resume                   # Resume with full context
ai restart                  # Start fresh
ai history                  # Show conversation history

# Freeze/Thaw States (v2.0)
ai freeze "debugging-session"     # Save current context
ai freeze-list                    # Show saved states
ai thaw "debugging-session"       # Restore context
ai freeze-delete "old-session"    # Clean up
```

### AI Templates

```bash
# Use Templates
ai template use code-review
ai template use explain-error
ai template use security-audit

# Manage Templates
ai template list                  # Show available
ai template create <name>         # Create new
ai template edit <name>          # Modify
ai template delete <name>        # Remove
ai template share <name>         # Export
```

### AI Perspectives (v2.0)

```bash
# Specialized AI Modes
ai-arch "design a microservice for user auth"     # Architecture
ai-dev "implement caching layer"                   # Development
ai-fix "debug memory leak in Node.js"            # Debugging
ai-test "write tests for auth module"            # Testing
ai-review "check this PR" @changes.diff          # Code review
ai-debug "why is login slow"                     # Performance
```

## 🌿 Git Enhancements

### Visual Git Commands

```bash
# Enhanced Status (gst)
$ gst
📊 Git Status for project-name
🌿 On branch: feature/new-ui
📍 Tracking: origin/feature/new-ui
⬆️  Ahead by 2 commits

✏️  Modified Files:
    components/Button.jsx
    styles/theme.css

➕ New Files:
    tests/Button.test.js

❓ Untracked:
    .env.local
```

### Smart Git Commits

```bash
# Intelligent Commit (gc)
gc "add user authentication"
# → Creates: "feat: add user authentication"

gc "fixed login bug"
# → Creates: "fix: resolve login bug"

# Quick Add + Commit (gac)
gac "update documentation"
# → Stages all & commits with proper format
```

### Beautiful Git Logs

```bash
# Pretty Git Log (gl)
gl                          # Colored graph view
gl -10                      # Last 10 commits
gl --author="John"          # Filter by author
gl --since="2 weeks ago"    # Time filter
```

### AI-Enhanced Git

```bash
# AI Commit Messages
git add .
ai commit                   # Generate message from diff

# Smart Merge Conflict Resolution
ai resolve-conflict         # Get help with conflicts

# Code Review Helper
ai review-changes          # Pre-commit review
```

## 🔒 Security Commands

### Secret Management

```bash
# Encrypted Secrets
dotfiles secret set API_KEY "sk-..."      # Store encrypted
dotfiles secret get API_KEY                # Retrieve
dotfiles secret list                       # Show all keys
dotfiles secret delete API_KEY             # Remove
dotfiles secret rotate API_KEY             # Generate new

# Bulk Operations
dotfiles secret export --encrypted         # Backup
dotfiles secret import secrets.enc         # Restore
```

### Security Scanning

```bash
# Scan for Exposed Secrets
dotfiles security scan                    # Current directory
dotfiles security scan ~/projects         # Specific path
dotfiles security scan --deep            # Include git history

# Fix Permissions
dotfiles security fix-perms              # Auto-fix issues
dotfiles security audit                  # Full audit
```

## ⚡ Performance Tools

### Command Profiling

```bash
# Profile Commands
dotfiles profile "npm install"           # Time a command
dotfiles profile --iterations=10 "build" # Average of 10 runs

# Analyze Startup
dotfiles profile startup                 # Shell startup time
dotfiles profile plugins                 # Plugin load times
```

### Cache Management

```bash
# Cache Control
dotfiles cache stats                     # Show cache info
dotfiles cache clean                     # Clear expired
dotfiles cache flush                     # Clear all
dotfiles cache disable                   # Temporary disable
```

### Background Jobs

```bash
# Async Job Management
dotfiles job run "long-task" &          # Start background job
dotfiles job list                        # Show running jobs
dotfiles job status <id>                 # Check specific job
dotfiles job kill <id>                   # Stop job
dotfiles job logs <id>                   # View output
```

## 🔌 Plugin Management

### Plugin Commands

```bash
# Plugin Operations
dotfiles plugin list                     # Show installed
dotfiles plugin enable <name>            # Activate plugin
dotfiles plugin disable <name>           # Deactivate
dotfiles plugin reload <name>            # Reload specific

# Plugin Development
dotfiles plugin create <name>            # New plugin template
dotfiles plugin test <name>              # Run plugin tests
dotfiles plugin lint <name>              # Check code quality
```

### Hook System

```bash
# Hook Management
dotfiles hook list                       # Show all hooks
dotfiles hook add pre-commit "npm test"  # Add hook
dotfiles hook remove pre-commit          # Remove hook
dotfiles hook disable <event>            # Temporary disable
```

## 🛠️ Advanced Usage

### Batch Operations

```bash
# Process Multiple Files
ai "add error handling to all" @src/**/*.js
aig "console.log" --replace "logger.debug" src/

# Bulk Git Operations
git-all status                           # Status in all repos
git-all pull                             # Update all repos
git-all "checkout main"                  # Run in all repos
```

### Custom Aliases

```bash
# Create Custom Commands
dotfiles alias create deploy "git push && npm run build"
dotfiles alias create morning "git pull && npm install && npm test"
dotfiles alias list                      # Show all
dotfiles alias delete deploy             # Remove
```

### Integration Examples

```bash
# CI/CD Integration
ai "generate GitHub Action for Node.js testing"
ai "create Dockerfile for this project" @package.json

# Documentation Generation
ai "document all functions in" @lib/*.js
ai "create API docs from" @routes/*.js

# Test Generation
ai test-gen @src/utils.js               # Generate tests
ai "write integration tests for" @api/  
```

## 🔍 Search & Discovery

### Smart Project Discovery

```bash
# Auto-discover Project Info
ai discover                              # Scan current project
ai "what is this project"               # Explain project
ai "how do I run this"                  # Get started guide
```

### Enhanced Search

```bash
# Context-Aware Search
ai search "authentication flow"          # Search with AI
ai locate "where is user login"         # Find code locations
ai trace "handleLogin function"         # Trace execution
```

## 📊 Monitoring & Analytics

### Usage Analytics

```bash
# Command Statistics
dotfiles stats commands                  # Most used commands
dotfiles stats ai                       # AI usage stats
dotfiles stats performance              # Performance metrics

# Export Reports
dotfiles report weekly                  # Weekly summary
dotfiles report custom --from="2024-01-01"
```

## 🌍 Multi-Language Support

```bash
# Language-Specific AI
ai --lang=python "optimize this function" @slow.py
ai --lang=go "add error handling" @main.go
ai --lang=rust "make this memory safe" @unsafe.rs

# Framework Detection
ai "add React hooks to" @Component.jsx
ai "convert to TypeScript" @app.js
ai "add Tailwind classes" @page.html
```

---

## 💡 Pro Tips

1. **Use `@` for files**: Include any file in AI context with `@filename`
2. **Tab completion**: All commands support tab completion
3. **Combine commands**: Chain with `&&` or pipe with `|`
4. **Custom shortcuts**: Create aliases for frequent commands
5. **Memory tags**: Organize context with custom tags

## 🆘 Getting Help

```bash
# Command Help
dotfiles help                # General help
ai help                      # AI command help
dotfiles help <command>      # Specific command

# Online Resources
dotfiles docs                # Open documentation
dotfiles examples            # Show examples
dotfiles tutorial            # Interactive tutorial
```

---

<div style="text-align: center; margin-top: 3em;">
  <a href="installation.html" class="btn-secondary">← Installation</a>
  <a href="index.html" class="btn-secondary">Home</a>
  <a href="ai-features.html" class="btn">AI Features →</a>
</div>

## 🤝 Support Development

Love using AI-powered terminal commands? Support the project:

<div style="text-align: center; margin: 2em 0;">
  <a href="https://github.com/sponsors/anivar" class="btn">💖 GitHub Sponsors</a>
  <a href="https://buymeacoffee.com/anivar" class="btn-secondary">☕ Buy Me a Coffee</a>
</div>

Your support helps maintain and improve these AI terminal tools for developers worldwide!