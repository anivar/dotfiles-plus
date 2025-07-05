---
layout: default
title: Plugin Development - Create AI Terminal Extensions
description: Build custom plugins for AI-powered terminal. Extend bash with AI, create Claude CLI plugins, ChatGPT terminal extensions, and shell automation tools.
keywords: terminal plugin development, bash plugin tutorial, ai cli extensions, shell scripting plugins, dotfiles plugins, terminal customization
---

# 🔌 Plugin Development Guide

Extend Dotfiles Plus with custom plugins. Add new commands, integrate services, and create your perfect terminal environment.

## 🚀 Quick Start

### Create Your First Plugin

```bash
# Generate plugin from template
dotfiles plugin create hello-world

# Or create manually
cat > ~/.dotfiles-plus/plugins/hello.plugin.sh << 'EOF'
#!/usr/bin/env bash

# Plugin metadata
PLUGIN_NAME="hello"
PLUGIN_VERSION="1.0.0"
PLUGIN_DESCRIPTION="A friendly greeting plugin"

# Simple command
hello_world() {
    echo "Hello from my plugin! 👋"
}

# Register command
command_register "hello" "hello_world" "Say hello"

# That's it!
EOF

# Enable and test
dotfiles plugin enable hello
dotfiles reload
hello  # → "Hello from my plugin! 👋"
```

## 📁 Plugin Structure

### Basic Plugin

```bash
myplugin.plugin.sh
├── Metadata (required)
├── Initialization (optional)
├── Commands
├── Hooks (optional)
└── Cleanup (optional)
```

### Advanced Plugin

```
myplugin/
├── myplugin.plugin.sh    # Main entry point
├── lib/                  # Helper functions
│   ├── utils.sh
│   └── api.sh
├── commands/             # Command files
│   ├── list.sh
│   └── sync.sh
├── hooks/                # Hook handlers
│   └── git-hooks.sh
├── templates/            # File templates
├── config/              # Default config
└── README.md            # Documentation
```

## 🛠️ Core Concepts

### 1. Plugin Lifecycle

```bash
#!/usr/bin/env bash

# Called when plugin loads
plugin_init() {
    # Check dependencies
    require_command "jq" || return 1
    
    # Load configuration
    load_config
    
    # Initialize state
    MYPLUGIN_CACHE_DIR="$HOME/.cache/myplugin"
    mkdir -p "$MYPLUGIN_CACHE_DIR"
    
    log_info "MyPlugin initialized"
}

# Called when plugin unloads
plugin_cleanup() {
    # Save state
    save_cache
    
    # Clean up resources
    cleanup_temp_files
    
    log_info "MyPlugin cleaned up"
}
```

### 2. Command Registration

```bash
# Simple command
my_command() {
    echo "Executing my command with args: $*"
}
command_register "mycommand" "my_command" "Description of my command"

# Command with subcommands
my_complex_command() {
    local subcommand="${1:-help}"
    shift
    
    case "$subcommand" in
        list)   my_list "$@" ;;
        add)    my_add "$@" ;;
        remove) my_remove "$@" ;;
        help|*) my_help ;;
    esac
}
command_register "my" "my_complex_command" "My complex command"

# AI-enhanced command
my_ai_command() {
    local query="$*"
    ai "help me with: $query"
}
command_register "myai" "my_ai_command" "AI-powered helper"
```

### 3. Hook System

```bash
# Register hook handlers
hook_register "pre-commit" "my_pre_commit_check"
hook_register "post-command" "my_command_logger"
hook_register "on-directory" "my_directory_handler"

# Hook implementation
my_pre_commit_check() {
    log_info "Running my pre-commit checks..."
    
    # Check for debug code
    if git diff --cached | grep -q "console.log\|debugger"; then
        log_error "Found debug code!"
        return 1
    fi
    
    return 0
}

# Directory-specific behavior
my_directory_handler() {
    local dir="$1"
    
    # Node.js project detected
    if [[ -f "$dir/package.json" ]]; then
        log_info "Node.js project detected"
        # Auto-install dependencies if needed
        [[ -f "$dir/package-lock.json" && ! -d "$dir/node_modules" ]] && npm install
    fi
}
```

## 💡 Plugin Examples

### 1. API Integration Plugin

```bash
#!/usr/bin/env bash
# weather.plugin.sh - Weather in your terminal

PLUGIN_NAME="weather"
PLUGIN_VERSION="1.0.0"

plugin_init() {
    # Default city from config or env
    WEATHER_CITY=${WEATHER_CITY:-$(dotfiles config get weather_city)}
    WEATHER_UNITS=${WEATHER_UNITS:-$(dotfiles config get weather_units "metric")}
}

weather() {
    local city="${1:-$WEATHER_CITY}"
    
    if [[ -z "$city" ]]; then
        echo "Usage: weather [city]"
        echo "Set default: dotfiles config set weather_city 'New York'"
        return 1
    fi
    
    # Fetch weather data
    local url="https://wttr.in/${city}?format=3"
    curl -s "$url" || echo "Failed to fetch weather"
}

weather_detailed() {
    local city="${1:-$WEATHER_CITY}"
    curl -s "https://wttr.in/${city}"
}

# Register commands
command_register "weather" "weather" "Show weather (brief)"
command_register "weather-detailed" "weather_detailed" "Show detailed weather"
```

### 2. Git Workflow Plugin

```bash
#!/usr/bin/env bash
# gitflow.plugin.sh - Enhanced git workflows

PLUGIN_NAME="gitflow"

# Feature branch workflow
feature() {
    local action="${1:-help}"
    local name="$2"
    
    case "$action" in
        start)
            [[ -z "$name" ]] && { echo "Name required"; return 1; }
            git checkout -b "feature/$name" develop
            ai remember "Started feature: $name"
            ;;
        
        finish)
            local current=$(git branch --show-current)
            git checkout develop
            git merge --no-ff "$current"
            git branch -d "$current"
            ;;
        
        list)
            git branch -a | grep "feature/"
            ;;
            
        *)
            echo "Usage: feature [start|finish|list] [name]"
            ;;
    esac
}

# Smart PR creation
pr() {
    local title="${1:-$(git log -1 --pretty=%B)}"
    
    # Generate PR body with AI
    local body=$(ai "Generate PR description from:" @<(git diff develop...HEAD))
    
    # Create PR (using gh CLI)
    gh pr create --title "$title" --body "$body"
}

command_register "feature" "feature" "Feature branch workflow"
command_register "pr" "pr" "Create PR with AI description"
```

### 3. Project Templates Plugin

```bash
#!/usr/bin/env bash
# templates.plugin.sh - Quick project scaffolding

PLUGIN_NAME="templates"

template_create() {
    local type="$1"
    local name="$2"
    
    [[ -z "$type" || -z "$name" ]] && {
        echo "Usage: template create <type> <name>"
        echo "Types: node, python, go, react"
        return 1
    }
    
    case "$type" in
        node)
            mkdir -p "$name"
            cd "$name"
            
            # Generate with AI
            ai "Create package.json for Node.js project named $name" > package.json
            ai "Create .gitignore for Node.js" > .gitignore
            ai "Create README.md for $name project" > README.md
            
            # Initialize
            git init
            npm install
            
            log_success "Created Node.js project: $name"
            ;;
            
        react)
            npx create-react-app "$name" --template typescript
            cd "$name"
            
            # Enhance with AI
            ai "Add ESLint config for React TypeScript" > .eslintrc.json
            ai "Create VS Code settings for React" > .vscode/settings.json
            ;;
            
        *)
            log_error "Unknown template type: $type"
            return 1
            ;;
    esac
}

command_register "template" "template_create" "Create project from template"
```

### 4. AI Memory Plugin

```bash
#!/usr/bin/env bash
# smart-memory.plugin.sh - Enhanced AI memory

PLUGIN_NAME="smart-memory"

# Auto-tag memories based on content
smart_remember() {
    local content="$*"
    local tags=()
    
    # Auto-detect tags
    [[ "$content" =~ (bug|error|issue) ]] && tags+=("bug")
    [[ "$content" =~ (api|endpoint|route) ]] && tags+=("api")
    [[ "$content" =~ (database|sql|query) ]] && tags+=("database")
    [[ "$content" =~ (security|auth|token) ]] && tags+=("security")
    
    # Remember with auto-tags
    if [[ ${#tags[@]} -gt 0 ]]; then
        ai remember --tag="$(IFS=,; echo "${tags[*]}")" "$content"
    else
        ai remember "$content"
    fi
    
    log_info "Remembered with tags: ${tags[*]:-none}"
}

# Context-aware recall
smart_recall() {
    local query="$*"
    
    # Get current context
    local context=""
    [[ -d .git ]] && context+=" git:$(git branch --show-current)"
    [[ -f package.json ]] && context+=" node:$(jq -r .name package.json)"
    
    # Recall with context
    ai recall "$query" --context "$context"
}

command_register "remember" "smart_remember" "Smart memory with auto-tagging"
command_register "recall" "smart_recall" "Context-aware recall"
```

## 🏗️ Advanced Features

### Plugin Configuration

```bash
# Support configuration
plugin_init() {
    # Load plugin config
    PLUGIN_CONFIG_FILE="$HOME/.dotfiles-plus/config/${PLUGIN_NAME}.conf"
    
    if [[ -f "$PLUGIN_CONFIG_FILE" ]]; then
        source "$PLUGIN_CONFIG_FILE"
    fi
    
    # Set defaults
    : ${MYPLUGIN_TIMEOUT:=30}
    : ${MYPLUGIN_CACHE_TTL:=3600}
    : ${MYPLUGIN_API_KEY:=$(dotfiles secret get MYPLUGIN_API_KEY)}
}

# Configuration commands
myplugin_config() {
    local key="$1"
    local value="$2"
    
    if [[ -z "$value" ]]; then
        # Get
        echo "${!MYPLUGIN_${key^^}}"
    else
        # Set
        echo "MYPLUGIN_${key^^}='$value'" >> "$PLUGIN_CONFIG_FILE"
        eval "MYPLUGIN_${key^^}='$value'"
    fi
}

command_register "myplugin:config" "myplugin_config" "Configure plugin"
```

### Async Operations

```bash
# Background jobs
myplugin_sync() {
    # Start background sync
    {
        log_info "Starting background sync..."
        
        # Long running operation
        while true; do
            do_sync_work
            sleep 300  # 5 minutes
        done
    } &
    
    # Save job PID
    local job_pid=$!
    echo "$job_pid" > "$MYPLUGIN_CACHE_DIR/sync.pid"
    
    log_success "Sync started (PID: $job_pid)"
}

# Stop background job
myplugin_stop() {
    if [[ -f "$MYPLUGIN_CACHE_DIR/sync.pid" ]]; then
        local pid=$(cat "$MYPLUGIN_CACHE_DIR/sync.pid")
        kill "$pid" 2>/dev/null && log_info "Sync stopped"
        rm -f "$MYPLUGIN_CACHE_DIR/sync.pid"
    fi
}
```

### Plugin Dependencies

```bash
# Depend on other plugins
plugin_init() {
    # Require another plugin
    require_plugin "git-enhanced" || {
        log_error "This plugin requires git-enhanced plugin"
        return 1
    }
    
    # Check commands
    require_command "jq" || {
        log_error "This plugin requires jq. Install with: brew install jq"
        return 1
    }
    
    # Check AI provider
    if [[ "$(dotfiles config get ai_provider)" == "none" ]]; then
        log_warning "AI features disabled - no AI provider configured"
    fi
}
```

## 🧪 Testing Plugins

### Unit Tests

```bash
# tests/test_myplugin.sh
#!/usr/bin/env bash

source "$(dirname "$0")/../myplugin.plugin.sh"

test_my_command() {
    local result=$(my_command "test")
    assert_equals "Expected output" "$result"
}

test_error_handling() {
    my_command_that_fails 2>/dev/null
    assert_equals 1 $?
}

# Run tests
dotfiles test plugins/myplugin
```

### Integration Tests

```bash
# Test with real environment
test_integration() {
    # Create temp directory
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    
    # Test plugin behavior
    my_project_init "test-project"
    assert_exists "test-project/package.json"
    
    # Cleanup
    cd - && rm -rf "$test_dir"
}
```

## 📦 Publishing Plugins

### Package Structure

```
myplugin/
├── myplugin.plugin.sh
├── README.md
├── LICENSE
├── install.sh
└── manifest.json
```

### Manifest File

```json
{
  "name": "myplugin",
  "version": "1.0.0",
  "description": "My awesome plugin",
  "author": "Your Name",
  "license": "MIT",
  "homepage": "https://github.com/user/myplugin",
  "requires": {
    "dotfiles-plus": ">=2.0.0",
    "commands": ["jq", "curl"],
    "plugins": ["git-enhanced"]
  },
  "config": {
    "timeout": 30,
    "cache_ttl": 3600
  }
}
```

### Installation Script

```bash
#!/usr/bin/env bash
# install.sh

PLUGIN_DIR="$HOME/.dotfiles-plus/plugins"

# Create plugin directory
mkdir -p "$PLUGIN_DIR"

# Copy plugin files
cp -r "$(dirname "$0")"/* "$PLUGIN_DIR/myplugin/"

# Enable plugin
dotfiles plugin enable myplugin

echo "✅ MyPlugin installed successfully!"
echo "Run 'dotfiles reload' to activate"
```

### Sharing Plugins

```bash
# 1. GitHub repository
git init
git add .
git commit -m "Initial plugin release"
git remote add origin https://github.com/you/myplugin-dotfiles-plus
git push -u origin main

# 2. Install from GitHub
curl -sSL https://github.com/you/myplugin-dotfiles-plus/raw/main/install.sh | bash

# 3. Or manual install
git clone https://github.com/you/myplugin-dotfiles-plus
cd myplugin-dotfiles-plus
./install.sh
```

## 🎯 Best Practices

### 1. Namespace Everything
```bash
# ✅ Good
myplugin_function() { }
MYPLUGIN_VAR="value"

# ❌ Bad  
function() { }
VAR="value"
```

### 2. Handle Errors Gracefully
```bash
# Check command success
if ! api_call; then
    log_error "API call failed"
    return 1
fi

# Use error handling
set -euo pipefail  # In functions
trap 'handle_error' ERR
```

### 3. Provide Help
```bash
myplugin_help() {
    cat << EOF
MyPlugin Commands:
  
  myplugin list              List all items
  myplugin add <item>        Add new item  
  myplugin remove <item>     Remove item
  myplugin config <key>      Get/set config
  
Examples:
  myplugin add "todo item"
  myplugin config api_key "abc123"
  
Configuration:
  MYPLUGIN_API_KEY          API key for service
  MYPLUGIN_TIMEOUT          Request timeout (default: 30)
EOF
}

command_register "myplugin:help" "myplugin_help"
```

### 4. Cache Expensive Operations
```bash
# Cache API responses
cached_api_call() {
    local cache_file="$MYPLUGIN_CACHE_DIR/api_cache"
    local cache_ttl=300  # 5 minutes
    
    # Check cache
    if [[ -f "$cache_file" ]] && \
       [[ $(( $(date +%s) - $(stat -f%m "$cache_file" 2>/dev/null || stat -c%Y "$cache_file") )) -lt $cache_ttl ]]; then
        cat "$cache_file"
        return
    fi
    
    # Make API call and cache
    local response=$(make_api_call)
    echo "$response" > "$cache_file"
    echo "$response"
}
```

## 🚀 Plugin Ideas

- **Cloud Integration**: AWS/GCP/Azure CLI enhancements
- **Container Tools**: Docker/Kubernetes helpers  
- **Language Tools**: Language-specific commands
- **Productivity**: Pomodoro timer, note-taking
- **Monitoring**: System/service monitoring
- **Security**: Security scanning, secret rotation
- **Team Tools**: Shared contexts, collaboration

---

<div style="text-align: center; margin-top: 3em;">
  <a href="configuration.html" class="btn-secondary">← Configuration</a>
  <a href="index.html" class="btn-secondary">Home</a>
  <a href="troubleshooting.html" class="btn">Troubleshooting →</a>
</div>

## 💖 Share Your Plugins!

Created an awesome plugin? Let us know!

<div style="text-align: center; margin: 2em 0;">
  <a href="https://github.com/anivar/dotfiles-plus/discussions" class="btn">Share Plugin</a>
  <a href="https://github.com/sponsors/anivar" class="btn">💖 Sponsor</a>
  <a href="https://buymeacoffee.com/anivar" class="btn-secondary">☕ Buy Coffee</a>
</div>