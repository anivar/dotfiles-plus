---
layout: default
title: Configuration Guide - AI Terminal Setup & Customization
description: Complete guide to configuring AI-powered terminal with Claude, ChatGPT, Gemini, and Ollama. Shell customization, plugin development, and performance optimization.
keywords: ai terminal configuration, bash ai setup, claude cli config, chatgpt terminal setup, gemini command line configuration, ollama shell setup, terminal customization
---

# ⚙️ Configuration Guide

Customize Dotfiles Plus to match your workflow perfectly. From AI providers to performance tuning, make it yours.

## 📁 Configuration Structure

```
~/.dotfiles-plus/
├── config/
│   ├── user.conf          # Your settings
│   ├── secrets.enc        # Encrypted secrets
│   └── local.conf         # Machine-specific
├── plugins/               # Custom plugins
├── templates/            # AI templates
├── memories/             # AI context
└── themes/               # Custom themes
```

## 🤖 AI Provider Configuration

### Quick Setup by Provider

#### Claude (Auto-detected)
```bash
# If Claude Code is installed, just works!
ai "hello"

# Manual configuration
dotfiles config set ai_provider claude
dotfiles config set claude_model claude-3-opus
```

#### OpenAI / ChatGPT
```bash
# API setup
dotfiles secret set OPENAI_API_KEY "sk-proj-..."
dotfiles config set ai_provider openai
dotfiles config set openai_model gpt-4-turbo-preview
dotfiles config set openai_temperature 0.7

# Verify
ai test
```

#### Google Gemini
```bash
# API configuration
dotfiles secret set GEMINI_API_KEY "AI..."
dotfiles config set ai_provider gemini
dotfiles config set gemini_model gemini-1.5-pro
dotfiles config set gemini_safety high

# Test connection
ai "hello from Gemini"
```

#### Ollama (Local AI)
```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull models - Choose based on your needs
ollama pull llama3              # General purpose (8B)
ollama pull codellama          # Code-focused
ollama pull mistral            # Fast & efficient (7B)
ollama pull gemma:2b           # Google's Gemma (2B) - ultra fast
ollama pull gemma              # Google's Gemma (7B)
ollama pull qwen:0.5b          # Alibaba's Qwen (0.5B) - ultra light
ollama pull qwen               # Alibaba's Qwen (7B)
ollama pull qwen2.5-coder      # Specialized for coding (7B)

# Configure
dotfiles config set ai_provider ollama
dotfiles config set ollama_model llama3  # or gemma, qwen, qwen2.5-coder
dotfiles config set ollama_url http://localhost:11434
```

#### OpenRouter (Multi-Model)
```bash
# Access 50+ models with one API
dotfiles secret set OPENROUTER_API_KEY "sk-or-..."
dotfiles config set ai_provider openrouter

# Choose model
dotfiles config set openrouter_model claude-3-opus     # Best quality
# or
dotfiles config set openrouter_model gpt-4-turbo      # Fast
# or  
dotfiles config set openrouter_model mixtral-8x7b     # Cost-effective
```

### Advanced AI Settings

```bash
# Model behavior
dotfiles config set ai_temperature 0.7          # Creativity (0-1)
dotfiles config set ai_max_tokens 4000          # Response length
dotfiles config set ai_timeout 30               # Seconds
dotfiles config set ai_retry_count 3            # Failed requests

# Context settings
dotfiles config set ai_context_window 100000    # Max context size
dotfiles config set ai_preserve_context true    # Keep between calls
dotfiles config set ai_include_system true      # System info in context

# Memory settings
dotfiles config set ai_memory_enabled true      # Enable memory system
dotfiles config set ai_memory_max_age 30        # Days to keep
dotfiles config set ai_memory_max_count 1000    # Maximum memories
dotfiles config set ai_memory_autotag true      # Auto-detect tags
```

## 🔧 Core Configuration

### Essential Settings

```bash
# Shell behavior
dotfiles config set shell_enhancement true      # Enhanced prompt
dotfiles config set auto_cd true                # cd by typing path
dotfiles config set command_suggestions true    # AI suggestions
dotfiles config set startup_greeting false      # Disable welcome

# Git enhancements
dotfiles config set git_enhanced_commands true  # gst, gc, etc.
dotfiles config set git_auto_fetch true         # Background fetch
dotfiles config set git_commit_ai true          # AI commit messages
dotfiles config set git_default_branch main     # Default branch

# Performance
dotfiles config set lazy_loading true           # Faster startup
dotfiles config set cache_enabled true          # Response caching
dotfiles config set cache_ttl 3600             # Cache duration
dotfiles config set parallel_operations true    # Parallel tasks
```

### Security Configuration

```bash
# Security features
dotfiles config set input_sanitization true     # Always sanitize
dotfiles config set command_auditing true       # Log commands
dotfiles config set secret_scanning true        # Scan for secrets
dotfiles config set auto_fix_permissions true   # Fix file perms

# Encryption
dotfiles config set encrypt_secrets true        # Encrypt stored secrets
dotfiles config set encryption_key_derive pbkdf2 # Key derivation
dotfiles config set encryption_iterations 100000 # PBKDF2 iterations
```

## 🎨 Customization

### Custom Prompts

```bash
# Create custom prompt
cat > ~/.dotfiles-plus/themes/mytheme.sh << 'EOF'
# My custom theme
PROMPT_SYMBOL="❯"
PROMPT_COLOR="\[\033[36m\]"  # Cyan
GIT_DIRTY_COLOR="\[\033[31m\]"  # Red
GIT_CLEAN_COLOR="\[\033[32m\]"  # Green

custom_prompt() {
    local git_info=$(git_prompt_info)
    PS1="${PROMPT_COLOR}\w${git_info} ${PROMPT_SYMBOL} \[\033[0m\]"
}

PROMPT_COMMAND=custom_prompt
EOF

# Activate theme
dotfiles config set theme mytheme
```

### Custom Aliases

```bash
# Add aliases via config
dotfiles alias add ll "ls -la"
dotfiles alias add gs "git status"
dotfiles alias add dc "docker-compose"
dotfiles alias add k "kubectl"

# Or edit directly
cat >> ~/.dotfiles-plus/config/aliases.conf << 'EOF'
# Development
alias nr="npm run"
alias nrd="npm run dev"
alias nrt="npm test"

# Docker
alias dps="docker ps"
alias dimg="docker images"
alias dex="docker exec -it"

# Kubernetes  
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kaf="kubectl apply -f"
EOF
```

### Environment Variables

```bash
# Set environment variables
dotfiles env set EDITOR "code"
dotfiles env set PAGER "less -R"
dotfiles env set NODE_ENV "development"

# Project-specific
cat > .env.dotfiles << 'EOF'
# Loaded in this directory and subdirectories
API_URL=http://localhost:3000
DEBUG=true
LOG_LEVEL=debug
EOF
```

## 🔌 Plugin Development

### Creating a Plugin

```bash
# Generate plugin template
dotfiles plugin create myplugin

# Or create manually
cat > ~/.dotfiles-plus/plugins/myplugin.plugin.sh << 'EOF'
#!/usr/bin/env bash
# Plugin metadata
PLUGIN_NAME="myplugin"
PLUGIN_VERSION="1.0.0"
PLUGIN_DESCRIPTION="My custom plugin"

# Plugin initialization
plugin_init() {
    log_info "MyPlugin loaded"
}

# Register commands
my_command() {
    echo "Hello from my plugin!"
}

command_register "mycommand" "my_command" "My custom command"

# Register hooks
on_git_commit() {
    echo "Running pre-commit checks..."
}

hook_register "pre-commit" "on_git_commit"

# Plugin cleanup (optional)
plugin_cleanup() {
    log_info "MyPlugin unloaded"
}
EOF

# Enable plugin
dotfiles plugin enable myplugin
```

### Plugin Best Practices

```bash
# 1. Namespace your functions
myplugin_function() {
    # Avoid conflicts
}

# 2. Check dependencies
plugin_init() {
    require_command "jq" || return 1
    require_command "curl" || return 1
}

# 3. Use configuration
plugin_init() {
    MYPLUGIN_API_URL=${MYPLUGIN_API_URL:-"https://api.example.com"}
    MYPLUGIN_TIMEOUT=${MYPLUGIN_TIMEOUT:-30}
}

# 4. Add help
myplugin_help() {
    cat << EOF
MyPlugin Commands:
  mycommand     - Does something cool
  myother       - Does something else
EOF
}

command_register "myplugin:help" "myplugin_help" "Show plugin help"
```

## 🪝 Hook System

### Available Hooks

```bash
# Git hooks
pre-commit       # Before git commit
post-commit      # After git commit  
pre-push         # Before git push
post-merge       # After git merge

# Shell hooks
pre-command      # Before any command
post-command     # After any command
on-error         # Command failed
on-directory     # Changed directory

# System hooks
startup          # Shell startup
shutdown         # Shell exit
daily            # Once per day
weekly           # Once per week
```

### Using Hooks

```bash
# Add hook handler
dotfiles hook add pre-commit "npm test"
dotfiles hook add post-merge "npm install"
dotfiles hook add on-error "ai explain-last"

# Complex hook
cat > ~/.dotfiles-plus/hooks/pre-push.sh << 'EOF'
#!/usr/bin/env bash
# Run tests before push
echo "Running pre-push checks..."

# Check for console.log
if git diff --cached --name-only | xargs grep -l "console.log"; then
    echo "❌ Found console.log statements"
    exit 1
fi

# Run tests
npm test || exit 1

echo "✅ All checks passed"
EOF

dotfiles hook add pre-push "~/.dotfiles-plus/hooks/pre-push.sh"
```

## 🚀 Performance Tuning

### Optimize Startup Time

```bash
# Profile startup
dotfiles profile startup

# Disable slow features
dotfiles config set git_auto_fetch false        # No background fetch
dotfiles config set ai_preload false            # Load AI on demand
dotfiles config set plugin_lazy_load true       # Defer plugins

# Minimal mode for slow systems
dotfiles config set performance_mode minimal
```

### Cache Configuration

```bash
# Cache settings
dotfiles config set cache_enabled true
dotfiles config set cache_dir "~/.cache/dotfiles-plus"
dotfiles config set cache_compress true         # Compress cached data
dotfiles config set cache_max_size "100M"       # Max cache size

# Per-feature cache
dotfiles config set ai_cache_ttl 3600          # 1 hour
dotfiles config set git_status_cache_ttl 30    # 30 seconds
dotfiles config set completion_cache_ttl 300   # 5 minutes
```

### Background Jobs

```bash
# Configure async operations
dotfiles config set async_enabled true
dotfiles config set max_background_jobs 4
dotfiles config set job_timeout 300            # 5 minutes

# Async features
dotfiles config set git_fetch_async true       # Background fetch
dotfiles config set ai_preload_async true      # Preload AI models
dotfiles config set update_check_async true    # Check updates
```

## 📱 Platform-Specific

### macOS Configuration

```bash
# macOS optimizations
if [[ "$OSTYPE" == "darwin"* ]]; then
    dotfiles config set macos_optimizations true
    dotfiles config set use_homebrew_paths true
    dotfiles config set terminal_app "$TERM_PROGRAM"
fi

# Touch ID for sudo
dotfiles config set macos_touchid_sudo true
```

### Linux Configuration

```bash
# Linux-specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    dotfiles config set linux_distro "$(lsb_release -si)"
    dotfiles config set package_manager "auto"  # apt, dnf, pacman
fi
```

### WSL Configuration

```bash
# WSL optimizations
if grep -qi microsoft /proc/version; then
    dotfiles config set wsl_optimizations true
    dotfiles config set wsl_windows_interop true
    dotfiles config set git_credential_manager "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe"
fi
```

## 🔍 Debugging Configuration

### Enable Debug Mode

```bash
# Verbose output
dotfiles config set debug_mode true
dotfiles config set log_level debug
dotfiles config set log_file ~/.dotfiles-plus/debug.log

# Component debugging
dotfiles config set debug_ai true              # AI operations
dotfiles config set debug_git true             # Git commands
dotfiles config set debug_hooks true           # Hook execution
dotfiles config set debug_performance true     # Timing info
```

### Configuration Validation

```bash
# Check configuration
dotfiles config validate

# Test specific settings
dotfiles test config
dotfiles test ai
dotfiles test plugins

# Reset to defaults
dotfiles config reset                          # All settings
dotfiles config reset ai_provider              # Specific setting
```

## 📝 Example Configurations

### Minimal Setup
```bash
# Fast startup, basic features
dotfiles config set performance_mode minimal
dotfiles config set lazy_loading true
dotfiles config set git_enhanced_commands true
dotfiles config set ai_provider none
```

### Developer Setup
```bash
# Full features for development
dotfiles config set ai_provider claude
dotfiles config set git_enhanced_commands true
dotfiles config set git_commit_ai true
dotfiles config set command_suggestions true
dotfiles config set plugin_development_mode true
```

### Security-Focused
```bash
# Maximum security
dotfiles config set input_sanitization strict
dotfiles config set command_auditing true
dotfiles config set secret_scanning aggressive
dotfiles config set ai_local_only true         # Ollama only
dotfiles config set encrypt_everything true
```

---

<div style="text-align: center; margin-top: 3em;">
  <a href="ai-features.html" class="btn-secondary">← AI Features</a>
  <a href="index.html" class="btn-secondary">Home</a>
  <a href="plugins.html" class="btn">Plugins →</a>
</div>

## 💖 Support Development

Help us improve Dotfiles Plus:

<div style="text-align: center; margin: 2em 0;">
  <a href="https://github.com/sponsors/anivar" class="btn">💖 GitHub Sponsors</a>
  <a href="https://buymeacoffee.com/anivar" class="btn-secondary">☕ Buy Me a Coffee</a>
</div>