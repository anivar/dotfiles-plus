---
layout: default
title: AI Terminal Features - ChatGPT, Claude, Gemini & Ollama CLI Integration
description: Transform your terminal with AI. Natural language commands, intelligent automation, and seamless integration with Claude, ChatGPT, Gemini, and Ollama in your command line.
keywords: ai terminal, claude cli, chatgpt terminal, gemini command line, ollama shell integration, ai bash commands, terminal ai assistant, command line ai
---

# 🤖 AI-Powered Terminal Features

Transform your command line into an intelligent assistant. Work with **Claude**, **ChatGPT**, **Gemini**, **Ollama**, and more - all from your terminal.

## 🌟 Why AI in the Terminal?

### Natural Language Commands
Stop memorizing complex syntax. Just describe what you want:
- `ai "find all TODO comments in my code"`
- `ai "compress images in this folder"`
- `ai "explain what port 8080 is used for"`

### Instant Error Resolution
Never get stuck on cryptic errors again:
```bash
$ npm start
Error: EADDRINUSE :::3000

$ ai fix
# AI: Port 3000 is in use. Let me find and stop the process...
# → Successfully freed port 3000 and restarted the server
```

### Context-Aware Assistance
AI that understands your project:
```bash
$ ai "what database does this project use"
# AI: This project uses PostgreSQL 14 with the following configuration:
# - Database: myapp_production
# - Port: 5432
# - Connection pooling: enabled (max 20)
# Found in: config/database.yml
```

## 🚀 Core AI Features

### 1. Universal AI Provider Support

Work with your preferred AI, or switch between them:

```bash
# Auto-detect installed providers
$ ai "hello"
# Using Claude Code (auto-detected)

# Switch providers on-the-fly
$ ai --provider gemini "explain Docker"
$ ai --provider ollama "write a bash function"

# Set default provider
$ dotfiles config set ai_provider chatgpt
```

**Supported Providers:**
- **Claude** (via Claude Code) - Auto-detected if installed
- **ChatGPT** (via API or CLI) - Official OpenAI integration
- **Google Gemini** - Latest Google AI models
- **Ollama** - Local LLMs (Llama 3, Mistral, etc.)
- **OpenRouter** - Access 50+ models with one API
- **Any OpenAI-compatible API** - LocalAI, FastChat, etc.

### 2. Intelligent Context Memory

Your AI assistant remembers important context across sessions:

```bash
# During debugging
$ ai remember "production bug: login fails after 5pm EST"
$ ai remember --tag=config "using Redis for session storage"
$ ai remember --important "API rate limit: 1000 req/hour"

# Days later...
$ ai recall "login"
# → Found: "production bug: login fails after 5pm EST"
# → Related: Session storage, authentication flow, recent changes

# Project-specific memory
$ cd ~/projects/webapp
$ ai discover                    # Auto-import project context
$ ai "how do we handle auth"    # AI knows your project!
```

### 3. File-Aware AI (@-syntax)

Include any file in your AI queries:

```bash
# Single file
ai "explain this code" @app.js
ai "find security issues in" @server.py
ai "optimize" @slow-query.sql

# Multiple files
ai "what's the difference between" @prod.config @dev.config
ai "create tests for" @utils.js @helpers.js

# Wildcards
ai "review all" @src/*.js
ai "document functions in" @lib/**/*.py

# Line-specific
ai "explain" @app.js:42-58
ai "why might this crash" @server.py:handleRequest
```

### 4. AI-Powered Shell Commands

Replace complex commands with natural language:

#### Smart Grep (aig)
```bash
# Natural language search
aig "error messages"              # Finds all error-related text
aig "TODO comments" --type=python # Search Python files only
aig "api keys or passwords"       # Security audit

# Context-aware search
aig "database connections"        # Finds DB-related code
aig "React components"           # Identifies JSX/components
```

#### Intelligent Find (aif)
```bash
# Describe what you're looking for
aif "config files"               # Finds .conf, .config, .ini, etc.
aif "large log files"           # Files > 100MB with .log extension
aif "recently changed tests"     # Test files modified < 24h ago

# Complex queries
aif "images bigger than 1MB"
aif "Python files with TODO"
aif "empty directories"
```

#### AI-Powered Sed (ais)
```bash
# Smart replacements
ais "change var to const" app.js        # ES6 updates
ais "update copyright year" *.md        # © 2023 → © 2024
ais "fix British spelling" docs/        # colour → color

# Refactoring
ais "convert callbacks to async/await" lib.js
ais "change class to function component" Button.jsx
```

#### History Intelligence (aih)
```bash
# Semantic history search
aih "docker commands"            # All Docker-related history
aih "git commits last week"      # Recent git commits
aih "commands with sudo"         # Audit sudo usage

# Learning from history
ai "what commands do I use most"
ai "how did I fix this last time"
```

## 🧠 Advanced AI Features

### Conversation Management

```bash
# Continue conversations
$ ai "let's debug the login issue"
# ... debugging session ...

$ ai continue  # Resume where you left off
$ ai history   # See conversation history
$ ai restart   # Start fresh
```

### Freeze/Thaw Conversation States

Save and restore entire AI contexts:

```bash
# Save current debugging session
$ ai freeze "login-bug-investigation"

# Work on something else...
$ ai restart

# Return to saved state
$ ai thaw "login-bug-investigation"
# AI: Resuming from where we were investigating the login timeout...

# Manage saved states
$ ai freeze-list
$ ai freeze-delete "old-session"
```

### AI Templates

Create reusable prompts for common tasks:

```bash
# Use built-in templates
$ ai template use code-review
$ ai template use security-audit
$ ai template use performance-check

# Create custom templates
$ cat > ~/.dotfiles-plus/templates/pr-review.md
Review this pull request for:
- Code quality and style
- Potential bugs
- Security concerns
- Performance implications
- Test coverage

$ ai template use pr-review @changes.diff
```

### Specialized AI Perspectives

Get expertise-focused assistance:

```bash
# Architecture decisions
$ ai-arch "design user authentication system"
# Considers: scalability, security, patterns, trade-offs

# Development help
$ ai-dev "implement rate limiting"
# Focuses on: code examples, best practices, libraries

# Bug fixing
$ ai-fix "debug memory leak"
# Analyzes: symptoms, causes, solutions, prevention

# Test generation
$ ai-test "create tests for user service"
# Generates: unit tests, edge cases, mocks

# Code review
$ ai-review @pr-changes.diff
# Checks: quality, security, performance, style

# Performance debugging
$ ai-debug "why is the API slow"
# Investigates: bottlenecks, profiling, optimization
```

## 🔧 Configuration Examples

### Setting Up Different AI Providers

#### Claude (Recommended)
```bash
# Auto-detected if Claude Code is installed
# No configuration needed!
ai "hello from Claude"
```

#### ChatGPT / OpenAI
```bash
# Using API key
dotfiles secret set OPENAI_API_KEY "sk-..."
dotfiles config set ai_provider openai
dotfiles config set openai_model gpt-4-turbo-preview

# Using CLI tool
npm install -g chatgpt-cli
dotfiles config set ai_provider chatgpt-cli
```

#### Google Gemini
```bash
# Set up API
dotfiles secret set GEMINI_API_KEY "..."
dotfiles config set ai_provider gemini
dotfiles config set gemini_model gemini-pro

# Or use CLI
npm install -g @google/generative-ai-cli
dotfiles config set ai_provider gemini-cli
```

#### Ollama (Local AI)
```bash
# Install and setup
brew install ollama
ollama pull llama3
ollama pull codellama

# Configure
dotfiles config set ai_provider ollama
dotfiles config set ollama_model llama3
dotfiles config set ollama_url http://localhost:11434
```

#### OpenRouter (50+ Models)
```bash
# Access Claude, GPT-4, Gemini, and more with one API
dotfiles secret set OPENROUTER_API_KEY "..."
dotfiles config set ai_provider openrouter
dotfiles config set openrouter_model "anthropic/claude-3-opus"
```

### Memory Configuration

```bash
# Adjust memory settings
dotfiles config set ai_memory_max_count 1000     # Max memories
dotfiles config set ai_memory_max_age 30          # Days to keep
dotfiles config set ai_memory_autoclean true      # Auto cleanup

# Project-specific memory
echo "PostgreSQL 14, Redis 7, Node.js 20" > .ai-memory
echo "Use TypeScript strict mode" >> .ai-memory
echo "API versioning: /v2/ prefix" >> .ai-memory
```

## 💡 Real-World Use Cases

### 1. Debugging Production Issues

```bash
# Capture context
ai remember --important "customers report slow checkout after 3pm"
ai remember --tag=metrics "CPU spikes to 90% during peak"

# Investigate
ai "analyze slow query" @logs/slow-query.log
ai "why would checkout be slow only after 3pm"

# Get solutions
ai fix-performance @checkout-handler.js
```

### 2. Learning New Codebases

```bash
# Understand project structure
cd new-project
ai discover                              # Import project context
ai "explain the architecture"
ai "how do I run this locally"
ai "where is authentication handled"

# Trace functionality
ai trace "user login flow"
ai "show me how data flows from API to UI"
```

### 3. Rapid Development

```bash
# Generate boilerplate
ai "create Express REST API for user management"
ai "add authentication middleware"

# Refactor existing code
ai "convert this to TypeScript" @old-app.js
ai "add error handling" @api-routes.js

# Write tests
ai test-gen @user-service.js
ai "create integration tests for" @api/
```

### 4. Code Reviews

```bash
# Pre-commit review
ai review-changes                        # Review staged changes
ai "check for security issues"

# PR reviews
ai review @feature-branch.diff
ai "does this follow our style guide" @changes
```

### 5. DevOps & Operations

```bash
# Dockerfile generation
ai "create optimized Dockerfile" @package.json

# CI/CD pipelines
ai "generate GitHub Actions workflow for Node.js"

# Kubernetes configs
ai "create k8s deployment" @app-requirements.txt

# Debugging deployments
ai "why is my container crashing" @error.log
```

## 🎯 Best Practices

### 1. Use Specific Context
```bash
# ❌ Too vague
ai "fix bug"

# ✅ Specific
ai "fix TypeError in login function" @auth.js:42
```

### 2. Leverage Memory Tags
```bash
# Organize by category
ai remember --tag=api "rate limit: 100 req/min"
ai remember --tag=db "connection pool size: 20"
ai remember --tag=security "JWT expires in 1 hour"

# Easy recall
ai recall --tag=api
```

### 3. Combine AI Commands
```bash
# Find and fix issues
aig "console.log" | ai "convert to proper logging"

# Search and document
aif "undocumented functions" | ai "add JSDoc comments"
```

### 4. Create Project Templates
```bash
# Save project-specific templates
mkdir .ai-templates
echo "Review for our style guide..." > .ai-templates/review.md
echo "Generate tests using Jest..." > .ai-templates/test.md
```

## 🚀 Performance Tips

### Local AI for Speed
```bash
# Use Ollama for faster responses
ollama pull phi
dotfiles config set ai_provider ollama
dotfiles config set ai_fast_model phi

# Quick questions use fast model
ai quick "what's the git command for squash"
```

### Caching Responses
```bash
# Enable response caching
dotfiles config set ai_cache_enabled true
dotfiles config set ai_cache_ttl 3600  # 1 hour

# Clear cache when needed
dotfiles cache clean ai
```

## 🔐 Security & Privacy

### Local-First Options
```bash
# Fully offline AI
brew install ollama
ollama pull codellama
dotfiles config set ai_provider ollama
dotfiles config set ai_offline_mode true
```

### Sensitive Data Protection
```bash
# Exclude from AI queries
echo "*.env" >> .ai-ignore
echo "secrets/" >> .ai-ignore
echo "*_key*" >> .ai-ignore

# Audit AI usage
dotfiles security ai-audit
```

---

<div style="text-align: center; margin-top: 3em;">
  <a href="commands.html" class="btn-secondary">← Commands</a>
  <a href="index.html" class="btn-secondary">Home</a>
  <a href="configuration.html" class="btn">Configuration →</a>
</div>

## 💖 Support AI-Powered Development

Help us make terminal AI better for everyone:

<div style="text-align: center; margin: 2em 0;">
  <a href="https://github.com/sponsors/anivar" class="btn">💖 GitHub Sponsors</a>
  <a href="https://buymeacoffee.com/anivar" class="btn-secondary">☕ Buy Me a Coffee</a>
</div>

Your support drives innovation in AI-powered developer tools!