# 🚀 Dotfiles Plus - AI-Powered Terminal Enhancement

> One unified tool for all your environments. Whether on your MacBook, Linux server, or cloud instance - enjoy the same powerful AI-enhanced terminal experience everywhere. Seamlessly integrates with ChatGPT, Claude, Gemini, Ollama, and any OpenAI-compatible API.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Release](https://img.shields.io/github/v/release/anivar/dotfiles-plus)](https://github.com/anivar/dotfiles-plus/releases)
[![Shell: Bash 5+/Zsh](https://img.shields.io/badge/Shell-Bash%205%2B%2FZsh-green.svg)](https://github.com/anivar/dotfiles-plus)
[![AI: Multi-Provider](https://img.shields.io/badge/AI-Claude%20|%20GPT%20|%20Gemini%20|%20Ollama-blue.svg)](https://github.com/anivar/dotfiles-plus)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-☕-yellow)](https://buymeacoffee.com/anivar)

## 🎯 What is Dotfiles Plus?

**Dotfiles Plus** is a revolutionary shell enhancement framework that brings AI directly to your terminal. It's the same powerful tool whether you're SSH'd into a production server, working on your laptop, or managing cloud infrastructure. Compatible with **Bash 5+** and **Zsh** on **macOS**, **Linux**, **BSD**, and **WSL**, it transforms how you interact with the command line by seamlessly integrating **Claude**, **ChatGPT**, **Gemini**, **Ollama**, and more.

### 🔥 Why Choose Dotfiles Plus?

- **🌐 Universal Deployment**: Deploy once, use everywhere - from development laptops to production servers
- **🤖 Multi-AI Support**: Seamlessly switch between Claude, ChatGPT, Gemini, Ollama, and OpenRouter in a single session
- **🧠 Persistent Memory**: Your AI assistant remembers context across projects, sessions, and even system reboots
- **🔒 Enterprise-Ready Security**: Built without `eval`, featuring input sanitization, encrypted secrets, and comprehensive audit logging
- **⚡ Lightning Performance**: Sub-100ms shell startup with intelligent lazy loading and smart caching
- **🎨 Beautiful Experience**: Enhanced git workflows, intuitive visual outputs, and intelligent command completions
- **🔌 Fully Extensible**: Powerful plugin architecture with hooks for complete customization
- **🔄 Always Up-to-Date**: Automatic updates keep you current across all your environments
- **📦 True Portability**: Pure shell implementation works offline and requires no external dependencies

## 🚀 Quick Install

### Option 1: Homebrew (Recommended for macOS/Linux)

```bash
# Add tap from GitHub branch and install
brew tap anivar/dotfiles-plus https://github.com/anivar/dotfiles-plus
brew install dotfiles-plus

# After installation, add to your shell:
# For Bash: echo 'source $(brew --prefix)/opt/dotfiles-plus/bin/dotfiles-plus-init' >> ~/.bashrc
# For Zsh:  echo 'source $(brew --prefix)/opt/dotfiles-plus/bin/dotfiles-plus-init' >> ~/.zshrc
```

### Option 2: One-Line Install

```bash
# Quick install script
curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash
```

### Option 3: Manual Install

```bash
# Clone and install
git clone https://github.com/anivar/dotfiles-plus.git ~/.dotfiles-plus
cd ~/.dotfiles-plus
./install.sh
```

### Option 4: Try with Docker

```bash
# Coming soon - Test without installing
docker run -it anivar/dotfiles-plus
```

## 💡 Features That Transform Your Terminal

### 🤖 AI-Powered Commands

Ask questions in natural language and get instant help:

```bash
# Get help with any command
ai "how do I find files larger than 100MB?"
ai "explain this error: permission denied on port 80"
ai "what's the git command to undo last commit?"

# Smart command fixes
ai fix                    # Auto-fix the last failed command
ai explain-last          # Understand what just happened
ai suggest               # Get next command suggestions

# Natural language tools
aig "search for TODO"    # AI-powered grep
aif "find config files"  # Smart file search
ais "change var to let" app.js  # AI-powered sed
aih "docker commands"    # Search command history with AI
```

### 🧠 Intelligent Context Memory

The AI remembers your work context intelligently:

```bash
# Remember important information
ai remember "using PostgreSQL 15 with TimescaleDB extension"
ai remember --tag bug "users report slow login after 5pm"
ai remember --important "API keys rotate every 30 days"

# Recall with smart filtering
ai recall                 # Show all context
ai recall --tag bug      # Filter by tags
ai recall --important    # Show only important items

# Auto-discovery
cd ~/projects/myapp
ai discover              # Finds and imports .ai-memory files
```

### 📁 File-Aware AI (v2.0)

Include files directly in your AI queries:

```bash
# Single file
ai "explain @package.json"
ai "find security issues in @server.js"

# Multiple files
ai "compare @old-config.json @new-config.json"

# Glob patterns
ai "review @src/*.js and suggest improvements"
ai "generate tests for @lib/**/*.py"
```

### ❄️ Conversation Management

Save and restore AI conversation states:

```bash
# Save current context
ai freeze myproject-auth

# List saved states
ai freezelist

# Restore later
ai thaw myproject-auth
ai continue "where were we?"
```

### 🔒 Secure Configuration

Enterprise-grade security built-in:

```bash
# Encrypted secrets management
dotfiles secret set OPENAI_API_KEY "sk-..."
dotfiles secret set DATABASE_URL "postgres://..."
dotfiles secret list

# Security audit
dotfiles check-security    # Check file permissions
dotfiles scan-secrets      # Scan for exposed secrets
dotfiles fix-permissions   # Auto-fix security issues

# Audit logging
dotfiles audit-enable      # Track sensitive commands
dotfiles audit-log         # View audit trail
```

### 🎨 Enhanced Git Experience

Beautiful and intelligent git commands:

```bash
# Visual git status with icons
gst
📊 Git Status
🌿 Branch: feature/auth
⬆️  Ahead by 2 commits

✏️  Modified: auth.js
➕ Added: jwt-helper.js
❓ Untracked: test.log

# Smart commits with AI
gc "add user authentication"
# AI detects type: "feat: add user authentication"

# AI-powered git workflow
ai gitflow               # Get workflow suggestions
ai gitignore            # Generate .gitignore
```

### ⚡ Performance Features

Built for speed and scale:

```bash
# Profile commands
dotfiles profile "npm install"

# Benchmark performance
dotfiles benchmark 10 "ai recall"

# Async job management
dotfiles async "npm run build"
dotfiles jobs list
dotfiles jobs status job_123

# Cache management
dotfiles cache stats
dotfiles cache clear
```

### 🧪 Development Tools

Boost your development workflow:

```bash
# Generate unit tests with AI
ai testgen auth.js         # Auto-detect framework
ai testgen user.py pytest  # Specify framework

# Template system
ai template save bug "I found a bug in {}: "
ai template use bug "login system"
```

### Project vs System Installation

**System Installation** (`install.sh`):
- Installs Dotfiles Plus globally on your computer
- One-time setup for all your projects
- Use the installation methods above

**Project Initialization** (`init.sh`):
- Adds AI memory to a specific project
- Creates `.ai-memory` and `.ai-templates/` in project
- Use after Dotfiles Plus is installed:

```bash
# Initialize AI for existing project
cd /path/to/your/project
~/.dotfiles-plus/init.sh
```

## 📚 Advanced Usage

### Custom AI Providers

Configure any AI provider:

```bash
# Claude (auto-detected if installed)
dotfiles config ai_provider claude

# OpenAI API
dotfiles secret set OPENAI_API_KEY "sk-..."
dotfiles config ai_provider openai-api

# Local Ollama
brew install ollama
ollama pull llama3
dotfiles config ai_provider ollama

# OpenRouter (multi-model)
dotfiles secret set OPENROUTER_API_KEY "..."
dotfiles config ai_provider openrouter
```

### Plugin Development

Create custom plugins:

```bash
# Create plugin
cat > ~/.dotfiles-plus/plugins/my.plugin.sh << 'EOF'
#!/usr/bin/env bash
my_command() {
    echo "Hello from my plugin!"
}
command_register "mycommand" "my_command" "My custom command"
EOF

# Reload to activate
dotfiles reload
```

### Hook System

Automate workflows with hooks:

```bash
# Available hooks
dotfiles hooks list

# Example: Auto-save memory on directory change
hook_register "directory_changed" "auto_save_context" 50
```

## 🛠️ System Requirements

- **Shell**: Bash 5.0+ or Zsh
- **OS**: macOS, Linux, BSD, WSL
- **Dependencies**: curl, tar, git (standard on most systems)
- **Optional**: AI provider (Claude, ChatGPT, Gemini, Ollama)

### 🔄 Auto-Update Support

Dotfiles Plus includes automatic update checking that works on all platforms:

```bash
# Manual update check
dotfiles update

# Disable auto-updates
export DOTFILES_AUTO_UPDATE=false

# Check update interval (default: 24 hours)
export DOTFILES_UPDATE_INTERVAL=86400
```

### macOS Users

macOS ships with Bash 3.2. Install Bash 5+:

```bash
brew install bash
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/bash"
```

### Linux Users

Most modern Linux distributions include Bash 5+ and all required tools. For package installation:

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install curl tar git

# Fedora/RHEL
sudo dnf install curl tar git

# Arch
sudo pacman -S curl tar git
```

## 🤝 Contributing

We love contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Priority Areas

- 🔒 Security audits and hardening
- 🚀 Performance optimizations  
- 🌍 Internationalization
- 📚 Documentation and examples
- 🧪 Test coverage

## 📖 Documentation

- [Installation Guide](INSTALL.md)
- [Configuration](docs/configuration.md)
- [Plugin Development](docs/plugins.md)
- [Security](docs/security.md)
- [Roadmap](ROADMAP.md)

## 🆘 Troubleshooting

### AI not working?

```bash
# Check configuration
dotfiles config ai_provider

# Test connection
dotfiles test_ai

# View detailed help
ai help
```

### Performance issues?

```bash
# Check startup time
dotfiles optimize

# Enable performance mode
export DOTFILES_PERF_MODE=true
```

## 📜 License

MIT © [anivar](https://github.com/anivar)

## 🙏 Acknowledgments

Built with inspiration from:
- The amazing shell scripting community
- Security best practices from OWASP
- Modern CLI design principles

---

**Keywords**: dotfiles, shell enhancement, terminal AI, bash configuration, zsh plugins, command line productivity, CLI tools, terminal automation, shell scripting, developer tools, ChatGPT terminal, Claude CLI, Gemini shell, Ollama integration, AI coding assistant, smart terminal, bash productivity, zsh enhancement, terminal multiplexer, command line AI

⭐ Star us on GitHub | 💬 [Join Discussions](https://github.com/anivar/dotfiles-plus/discussions) | 🐛 [Report Issues](https://github.com/anivar/dotfiles-plus/issues)