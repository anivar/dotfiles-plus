---
layout: default
---

# 🚀 Transform Your Terminal with AI

**Dotfiles Plus** brings the power of AI directly into your command line. Whether you're using **Claude**, **ChatGPT**, **Gemini**, or **Ollama**, get instant help, smart automation, and enterprise-grade security.

<div style="text-align: center; margin: 2em 0;">
  <a href="#quick-install" class="btn">Get Started</a>
  <a href="https://github.com/anivar/dotfiles-plus" class="btn-secondary">View on GitHub</a>
</div>

## ✨ Why Dotfiles Plus?

### 🤖 **Universal AI Integration**
Works seamlessly with all major AI providers - Claude Code, ChatGPT, Google Gemini, Ollama, OpenRouter, and any OpenAI-compatible API.

### 🧠 **Intelligent Memory System**
Context-aware AI that remembers your work across projects, branches, and directories. Never lose important context again.

### 🔒 **Enterprise Security**
Built with security first - no `eval`, input sanitization, encrypted secrets, audit logging, and session isolation.

### ⚡ **Blazing Fast**
Shell startup under 100ms guaranteed with lazy loading, intelligent caching, and async operations.

## 🎯 Features

### AI-Powered Commands
```bash
# Natural language queries
ai "how do I find files larger than 100MB?"
ai "explain this error: permission denied on port 80"

# Smart command fixes
ai fix                    # Auto-fix the last failed command
ai explain-last          # Understand what just happened
ai suggest               # Get next command suggestions

# AI-powered tools
aig "search for TODO"    # Natural language grep
aif "find config files"  # Smart file search
ais "change var to let" app.js  # AI-powered sed
```

### Intelligent Context Memory
```bash
# Remember important information
ai remember "using PostgreSQL 15 with TimescaleDB"
ai remember --tag bug "users report slow login after 5pm"
ai remember --important "API keys rotate every 30 days"

# Smart recall
ai recall                 # Show all context
ai recall --tag bug      # Filter by tags
ai recall "password"     # Search memories
```

### File-Aware AI (v2.0)
```bash
# Include files in queries
ai "explain @package.json"
ai "find security issues in @server.js"
ai "compare @old-config.json @new-config.json"
ai "review @src/*.js and suggest improvements"
```

### Enhanced Git Experience
```bash
# Visual git status
gst
📊 Git Status
🌿 Branch: feature/auth
⬆️  Ahead by 2 commits

✏️  Modified: auth.js
➕ Added: jwt-helper.js
❓ Untracked: test.log

# Smart commits
gc "add user authentication"
# AI detects type: "feat: add user authentication"
```

## 💾 Quick Install

### Homebrew (Recommended)
```bash
brew tap anivar/dotfiles-plus https://github.com/anivar/dotfiles-plus
brew install dotfiles-plus
```

### One-Line Install
```bash
curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash
```

### Manual Install
```bash
git clone https://github.com/anivar/dotfiles-plus.git ~/.dotfiles-plus
cd ~/.dotfiles-plus
./install.sh
```

## 🛠️ Requirements

- **Shell**: Bash 5.0+ or Zsh
- **OS**: macOS, Linux, BSD, WSL
- **Optional**: AI provider (Claude, ChatGPT, Gemini, Ollama)

### macOS Users
macOS ships with Bash 3.2. Install Bash 5+:
```bash
brew install bash
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/bash"
```

## 🔧 Configuration

### AI Providers
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
```

### Plugin Development
```bash
# Create custom plugin
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

## 📚 Documentation

- [Installation Guide](https://github.com/anivar/dotfiles-plus/blob/main/INSTALL.md)
- [Command Reference](https://github.com/anivar/dotfiles-plus/blob/main/COMMANDS.md)
- [Configuration](https://github.com/anivar/dotfiles-plus/blob/main/CONFIGURATION.md)
- [Roadmap](https://github.com/anivar/dotfiles-plus/blob/main/ROADMAP.md)

## 🤝 Contributing

We welcome contributions! Priority areas:
- 🔒 Security audits
- 🚀 Performance optimizations
- 🌍 Internationalization
- 📚 Documentation
- 🧪 Test coverage

## 📜 License

MIT © [anivar](https://github.com/anivar)

---

<div style="text-align: center; margin-top: 3em;">
  <a href="https://github.com/anivar/dotfiles-plus" class="github-button" data-size="large" data-show-count="true">Star</a>
  <a href="https://github.com/anivar/dotfiles-plus/discussions" class="github-button" data-size="large">Discuss</a>
  <a href="https://buymeacoffee.com/anivar" class="github-button" data-size="large">Support</a>
</div>