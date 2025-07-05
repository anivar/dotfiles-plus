---
layout: default
---

# 🚀 Transform Your Terminal with AI

> 💡 **A Personal Story**: As a developer, I was tired of switching between my terminal and AI chat windows. I needed AI right where I work - in my command line. So I built **Dotfiles Plus** - bringing the power of **Claude**, **ChatGPT**, **Gemini**, and **Ollama** directly into the terminal where we spend our days.

**Born from a developer's need, built for developers everywhere** 🛠️

<div style="text-align: center; margin: 2em 0;">
  <a href="#quick-install" class="btn">Get Started</a>
  <a href="https://github.com/anivar/dotfiles-plus" class="btn-secondary">View on GitHub</a>
</div>

## ✨ Why I Built This (And Why You'll Love It)

<div class="feature-card">
<h3>🤖 <strong>Universal AI Integration</strong></h3>
<p>Frustrated with copy-pasting between terminal and ChatGPT? Me too! Now you can use <strong>Claude Code</strong>, <strong>ChatGPT</strong>, <strong>Google Gemini</strong>, <strong>Ollama</strong>, and more - all without leaving your terminal.</p>
</div>

<div class="feature-card">
<h3>🧠 <strong>AI That Remembers</strong></h3>
<p>Ever explained the same project context to AI multiple times? Not anymore! The intelligent memory system remembers your work across projects, branches, and sessions. Your AI assistant finally has context!</p>
</div>

<div class="feature-card">
<h3>🔐 <strong>Security You Can Trust</strong></h3>
<p>As someone who's paranoid about security, I built this with protection first - no dangerous <code>eval</code>, full input sanitization, encrypted secrets, and complete audit trails. Sleep well knowing your code is safe.</p>
</div>

<div class="feature-card">
<h3>⚡ <strong>Lightning Fast</strong></h3>
<p>Nobody likes slow shells. With lazy loading, intelligent caching, and async operations, your shell starts in under 100ms. Because every millisecond counts when you're in the flow.</p>
</div>

## 🎯 Real Features That Save Real Time

### 🤖 Natural Language in Your Terminal
```bash
# Stop googling, just ask! 
ai "how do I find files larger than 100MB?" 
# → AI: Use: find . -type f -size +100M

ai "explain this error: permission denied on port 80"
# → AI: Port 80 requires root access. Try: sudo your-command or use port 3000

# When commands fail, AI has your back 🛡️
npm start
# Error: EADDRINUSE :::3000
ai fix
# → AI: Port 3000 is busy. Running: lsof -ti:3000 | xargs kill -9
# ✅ Fixed! Restarting your server...

# AI-powered tools that understand what you mean 🎯
aig "search for TODO"    # Smarter than grep - finds TODOs, FIXME, etc.
aif "find config files"  # Knows .conf, .config, .env, settings.json...
ais "change var to let" app.js  # Understands JavaScript context!
```

### 🧠 AI Memory That Actually Works
```bash
# Your AI assistant finally has a memory! 🎉
ai remember "using PostgreSQL 15 with TimescaleDB"
ai remember --tag bug "users report slow login after 5pm"
ai remember --important "API keys rotate every 30 days"

# Weeks later, your AI still knows your project 🤯
ai recall "database"
# → PostgreSQL 15 with TimescaleDB
# → Connection pool: 20 max (remembered 2 weeks ago)
# → Recent issue: slow queries on user_sessions table
```

### 📁 AI That Reads Your Files (Game Changer!)
```bash
# The @ symbol includes files - mind blown! 🤯
ai "explain @package.json"
ai "find security issues in @server.js"
ai "compare @old-config.json @new-config.json"
ai "review @src/*.js and suggest improvements"

# My favorite: instant code reviews 💅
ai "is this production ready?" @api/auth.js
# → AI: Found 3 issues:
# → 1. No rate limiting on login endpoint
# → 2. Passwords logged in line 47
# → 3. Missing input validation
```

### 🌿 Git Commands That Spark Joy
```bash
# Visual git status that actually makes sense! 
gst
📊 Git Status for awesome-project
🌿 Branch: feature/auth  
📍 Tracking: origin/feature/auth (↑2 commits ahead)

✏️  Modified:
    src/auth.js (45 lines changed)
    src/utils/jwt.js (12 lines changed)
    
➕ New Files:
    tests/auth.test.js
    
❓ Untracked:
    .env.local (⚠️ contains secrets!)

# Commits that follow conventions automatically! 🎨
gc "add user authentication"
# → AI writes: "feat(auth): add JWT-based user authentication
#             
#             - Implement login/logout endpoints
#             - Add JWT token generation
#             - Include refresh token flow"
```

## 🎁 My Gift to Fellow Developers

<div class="cta-section">
<p><strong>This started as a personal tool</strong> to solve my daily frustrations. Now it's saving hours for developers worldwide. If it helps you too, that's all the reward I need! 💝</p>
<p style="margin-top: 1rem;"><em>Though if you want to buy me coffee while I add more features... ☕</em></p>
</div>

## 💾 Quick Install (Under 30 Seconds!)

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

<div class="cta-section" style="margin-top: 4em;">
  <h2>💖 Support a Fellow Developer's Passion Project</h2>
  <p style="font-size: 1.1em; margin: 1.5em 0;">
    <strong>Hi, I'm Anivar!</strong> 👋<br>
    I built Dotfiles Plus because I needed AI in my terminal, not in another browser tab.<br>
    If this tool saves you time (or just makes you smile), consider supporting its development!
  </p>
  
  <div style="margin: 2em 0;">
    <a href="https://github.com/sponsors/anivar" class="btn">💖 GitHub Sponsors</a>
    <a href="https://buymeacoffee.com/anivar" class="btn-secondary">☕ Buy Me a Coffee</a>
  </div>
  
  <p style="font-size: 0.9em; color: #666; margin-top: 2em;">
    Every sponsor helps me dedicate more time to features you'll love! 🚀<br>
    <strong>Recent additions:</strong> Gemma & Qwen support, Jekyll website, auto-sync docs
  </p>
  
  <hr style="margin: 2em 0; opacity: 0.3;">
  
  <p style="margin-top: 2em;">
    <strong>Join the Community:</strong><br>
    <a href="https://github.com/anivar/dotfiles-plus" style="margin: 0 1em;">⭐ Star on GitHub</a>
    <a href="https://github.com/anivar/dotfiles-plus/discussions" style="margin: 0 1em;">💬 Share Your Story</a>
    <a href="https://github.com/anivar/dotfiles-plus/issues" style="margin: 0 1em;">🐛 Report Issues</a>
  </p>
</div>