# 🚀 Dotfiles Plus

> AI-powered dotfiles management with enterprise-grade security

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Release](https://img.shields.io/github/v/release/anivar/dotfiles-plus)](https://github.com/anivar/dotfiles-plus/releases)
[![Shell: Bash 4.0+/Zsh](https://img.shields.io/badge/Shell-Bash%204.0%2B%2FZsh-green.svg)](https://github.com/anivar/dotfiles-plus)
[![Security: Hardened](https://img.shields.io/badge/Security-Hardened-red.svg)](https://github.com/anivar/dotfiles-plus)
[![Sponsor](https://img.shields.io/badge/Sponsor-%E2%9D%A4-pink)](https://github.com/sponsors/anivar)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-☕-yellow)](https://buymeacoffee.com/anivar)

## ✨ What is Dotfiles Plus?

A modern dotfiles manager that brings AI intelligence directly into your terminal workflow. Built with security-first principles and designed for developers who want powerful automation without compromising safety.

### Key Features

🤖 **AI Integration** - Natural language queries, smart context awareness, and intelligent automation  
🔒 **Security Hardened** - No eval commands, sanitized inputs, encrypted secrets  
🧠 **Smart Memory** - Remembers context across projects, branches, and directories  
⚡ **Modern Shell** - Leverages bash 4+ and zsh features for optimal performance  
🔄 **Easy Migration** - Keep your existing setup, enhance don't replace

## 🚀 Quick Start

### Requirements

- **Shell**: Bash 4.0+ or Zsh
- **OS**: macOS, Linux
- **Tools**: Git, curl

**macOS Note**: Install bash 4+ with Homebrew:
```bash
brew install bash && chsh -s $(brew --prefix)/bin/bash
```

### Installation

```bash
# One-line install
curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash

# Or clone and source
git clone https://github.com/anivar/dotfiles-plus.git ~/.dotfiles-plus
source ~/.dotfiles-plus/dotfiles-plus.sh
```

### First Steps

```bash
# Configure AI provider (optional - works with claude, gemini, etc.)
dotfiles config

# Try AI integration
ai "how do I find large files in this directory?"

# Remember context for later
ai remember "working on authentication feature"

# Use enhanced git commands
gst  # Beautiful git status
gc "feat: add login"  # Smart commit
```

## 🎯 Core Features

### AI Assistant

```bash
# Ask questions naturally
ai "explain this error: permission denied on port 80"

# Include files in queries (coming in v1.3)
ai "review @config.json and suggest improvements"

# Smart context awareness
cd ~/projects/api
ai remember "using JWT for auth"
ai recall  # Shows context for current location
```

### Memory System

The AI maintains hierarchical context awareness:

```
📦 Repository Level     (shared across all branches)
└── 🌿 Branch Level    (isolated per branch)
    └── 📁 Directory   (inherited by subdirectories)
```

```bash
# Remember with tags and importance
ai remember --important --tag bug "users can't reset passwords"

# Smart recall with filtering
ai recall --tag bug      # Show only bugs
ai recall "password"     # Search memories
ai stats                 # Memory statistics

# Extended features
ai think "how to optimize this database schema"  # Deep analysis mode
ai template list         # Reusable prompts
ai continue             # Resume last conversation
```

### Enhanced Git

```bash
gst         # Status with icons
gaa         # Add all with summary
gc "msg"    # Commit with conventional format
gp          # Push with branch tracking
gl          # Pretty log graph
gd          # Diff with syntax highlighting
```

### System Management

```bash
dotfiles status    # System health check
dotfiles update    # Update to latest version
dotfiles backup    # Create timestamped backup
dotfiles migrate   # Import from other managers
```

## 📚 Documentation

- 📖 [Command Reference](COMMANDS.md) - All available commands
- 🔧 [Configuration Guide](CONFIGURATION.md) - Setup and customization
- 🛣️ [Roadmap](ROADMAP.md) - Future plans and vision
- 💡 [Best Practices](BEST_PRACTICES.md) - Tips and workflows
- 🤝 [Contributing](CONTRIBUTING.md) - How to help

## 🔒 Security

Dotfiles Plus prioritizes security:

- ✅ **No eval** - Zero dynamic code execution
- ✅ **Input sanitization** - All inputs validated and cleaned
- ✅ **Encrypted storage** - Sensitive data protected (coming in v1.5)
- ✅ **Session isolation** - Separate contexts per terminal
- ✅ **Audit trails** - Track sensitive operations

## 🆚 Why Dotfiles Plus?

| Feature | Dotfiles Plus | Traditional Managers |
|---------|--------------|---------------------|
| AI Integration | Built-in | ❌ None |
| Security Focus | Primary concern | Basic |
| Context Awareness | Multi-level hierarchy | ❌ None |
| Shell Support | Bash 4+/Zsh | Varies |
| Learning Curve | Minimal | Steep |

## 🗺️ Roadmap Highlights

**v1.3** - Direct file inclusion in AI queries (@file syntax)  
**v1.4** - AI-powered shell commands (aig, aif, ais)  
**v1.5** - Encrypted secrets management  
**v1.6** - Performance optimizations & local LLM support

See full [ROADMAP.md](ROADMAP.md) for details.

## 🤝 Contributing

We welcome contributions! Priority areas:
- Security auditing
- Cross-platform testing  
- Documentation improvements
- Feature implementation

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 💬 Support

- 🐛 [Report Issues](https://github.com/anivar/dotfiles-plus/issues)
- 💡 [Request Features](https://github.com/anivar/dotfiles-plus/discussions)
- ⭐ [Star on GitHub](https://github.com/anivar/dotfiles-plus)
- ☕ [Buy Me A Coffee](https://buymeacoffee.com/anivar)

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/anivar">anivar</a> and contributors
</p>