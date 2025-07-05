# 🚀 Dotfiles Plus

A security-focused dotfiles manager with built-in AI integration, smart context awareness, and seamless migration from existing setups. Works with bash 3.2+ and zsh.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Release](https://img.shields.io/github/v/release/anivar/dotfiles-plus)](https://github.com/anivar/dotfiles-plus/releases)
[![Shell: Bash 3.2+/Zsh](https://img.shields.io/badge/Shell-Bash%203.2%2B%2FZsh-green.svg)](https://github.com/anivar/dotfiles-plus)
[![Security: Hardened](https://img.shields.io/badge/Security-Hardened-red.svg)](https://github.com/anivar/dotfiles-plus)
[![Sponsor](https://img.shields.io/badge/Sponsor-%E2%9D%A4-pink)](https://github.com/sponsors/anivar)

## 🎯 Why Dotfiles Plus?

Dotfiles Plus addresses common developer needs with a security-first approach:
- **Built-in AI Integration**: Ask questions without leaving your terminal
- **Security Hardened**: No eval commands, comprehensive input sanitization
- **Smart Context Memory**: AI remembers context at repo, branch, and directory levels  
- **Universal Migration**: Keep your existing setup, no need to start over
- **Works Everywhere**: Compatible with bash 3.2+ (macOS default) and zsh

### Two Versions Available

1. **Shell-Compatible Version** (`dotfiles-plus.sh`) - Works with bash 3.2+/zsh
   - All core features without requiring bash 4+ associative arrays
   - Perfect for macOS and older systems
   - Fully tested and production-ready

2. **Full Version** (`dotfiles-plus-full.sh`) - Requires bash 4+
   - Additional features like project management and bootstrap automation
   - Modular architecture with lazy loading
   - Extended performance optimizations

## 🚀 Features

### 🤖 AI Integration
```bash
# Ask questions directly from your terminal
ai "how do I fix this error: permission denied"
ai "explain this regex: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

# Context-aware memory system with enhanced features
ai remember "debugging authentication issue in user service"
ai remember --important "critical bug: user data not saving"
ai remember --tag todo "implement rate limiting"

# Advanced recall with filtering
ai recall                    # Shows all recent context
ai recall "authentication"   # Search for specific terms
ai recall --important        # Show only important items
ai recall --tag todo        # Filter by specific tags

# Memory management
ai stats                     # View memory distribution and top tags
ai clean 7                   # Clean memories older than 7 days
ai forget                    # Clear current session context
ai stack                     # Navigate context hierarchy
ai projects                  # View memories across all projects
```

📖 **[See all AI commands →](COMMANDS.md#-ai-commands)** | **[Configuration Guide →](CONFIGURATION.md)**

#### 🧠 How the Smart Memory System Works
The AI memory system maintains context at multiple hierarchical levels:

```bash
# Context is automatically scoped to multiple levels
$ cd ~/projects/auth-service
$ git branch
* feature/oauth-implementation

# The AI knows:
# - Current directory: ~/projects/auth-service
# - Git repository: auth-service
# - Current branch: feature/oauth-implementation
# - Project type: Node.js (auto-detected)
# - Parent directories in your stack

$ ai remember "implementing OAuth2 with refresh tokens"
# This memory is tagged with ALL context levels

# Navigate to a subdirectory
$ cd src/controllers
$ ai remember "rate limiting should be 10 requests per minute"

# The AI maintains hierarchical context
$ ai recall
📚 Context Stack:
├── Repository: auth-service (Node.js)
│   └── Branch: feature/oauth-implementation
│       ├── ~/projects/auth-service
│       │   └── "implementing OAuth2 with refresh tokens"
│       └── ~/projects/auth-service/src/controllers
│           └── "rate limiting should be 10 requests per minute"

# Switch branches - get different context!
$ git checkout feature/user-profiles
$ ai recall
📚 Context for feature/user-profiles:
[Yesterday 15:30] "working on user avatar upload"
[Yesterday 16:45] "need to add image compression"

# The AI automatically includes relevant context hierarchy
$ ai "how should I implement the rate limiting?"
# AI sees: repo context + branch context + directory context + parent memories
```

**Smart Context Features**:
- **Repository Awareness**: Separate contexts per git repository
- **Branch Isolation**: Each git branch maintains its own memory
- **Directory Stack**: Memories inherit from parent directories
- **Project Type Context**: Language/framework-specific knowledge
- **Time Awareness**: Recent memories weighted higher
- **Cross-Reference**: Find related memories across contexts

**Coming Soon**: 
- Global knowledge base across all your projects
- Team shared contexts (opt-in)
- Context templates for common patterns
- Automatic context from README/docs
- Integration with issue trackers

### 🔒 Security Features (Core Focus)
- **No eval commands**: All dynamic execution eliminated
- **Input sanitization**: Comprehensive filtering of dangerous characters
- **Command injection protection**: Safe command execution throughout
- **Session isolation**: Each terminal session has isolated AI context
- **Validated inputs**: Pattern matching for all user inputs

### 🌿 Enhanced Git Commands
```bash
gst              # Visual git status with icons and colors
gc "fix: typo"   # Smart commit with auto-generated messages
gac "wip"        # Quick add-all + commit
gl               # Pretty log graph (last 10 commits)
```

📖 **[See all git shortcuts →](COMMANDS.md#-git-shortcuts)**

### 📊 System Management
```bash
dotfiles status   # Show system status and session info
dotfiles health   # Run comprehensive health check
dotfiles backup   # Create timestamped backup
```

📖 **[See all system commands →](COMMANDS.md#-dotfiles-system-commands)**

### 🎯 What's Included

#### Core Features (All Versions)
- **AI Assistant Integration** - Ask questions without leaving your terminal
- **Smart Context Memory** - Remembers what you're working on across sessions
- **Security Hardening** - No eval, comprehensive input sanitization
- **Visual Git Commands** - Beautiful status displays and smart commits
- **System Health Monitoring** - Know when something's wrong
- **Universal Migration** - Keep your existing setup

#### Advanced Features (Full Version)
- **Project Auto-Detection** - Knows if you're in Node, Python, or other projects
- **Bootstrap Automation** - Set up new machines in minutes
- **Performance Caching** - Lightning-fast command execution
- **Modular Architecture** - Load only what you need

### 📁 Smart Context Navigation
```bash
```bash
# Context automatically tracked at multiple levels
$ cd ~/projects/api
$ git checkout feature/auth
$ ai remember "implementing JWT with refresh tokens"
💾 Remembered at 3 context levels

$ ai recall
📚 Smart Context Recall:

Current Location:
- Repo: api (feature/auth)
- Path: ~/projects/api

📁 This Directory:
  [19:25] implementing JWT with refresh tokens

🌿 This Branch (feature/auth):
  [19:25] [~/projects/api] implementing JWT with refresh tokens

📦 This Repository:
  [19:25] [feature/auth:~/projects/api] implementing JWT with refresh tokens

# Navigate your context stack
$ ai stack
📚 Context Stack Navigation:
📁 ~/projects/api
    └── implementing JWT with refresh tokens
  📁 ~/projects
    📁 ~/
```
```

### 🔄 Universal Migration
```bash
# Intelligent migration that preserves your existing setup
./migrate-universal.sh

# What gets preserved:
- Custom aliases and functions
- Git configurations
- Shell history
- SSH configs
- Environment variables
- Existing dotfiles

# Creates backups before any changes
# Non-destructive - can rollback anytime
```

## 📊 Comparison with Alternatives

| Feature | Dotfiles Plus | Oh My Zsh | Bash-it | Prezto |
|---------|--------------|-----------|---------|--------|
| **Bash 3.2 Support** | ✅ Yes | ✅ Yes | ✅ Yes | ❌ Zsh only |
| **AI Integration** | ✅ Built-in | Via plugins | Via plugins | Via plugins |
| **Multi-Level Context** | ✅ Built-in | ❌ No | ❌ No | ❌ No |
| **Security Focus** | ✅ Primary | Standard | Standard | Standard |
| **Migration Tool** | ✅ Universal | Manual | Manual | Manual |
| **No eval Usage** | ✅ Yes | ❌ Uses eval | ❌ Uses eval | ❌ Uses eval |
| **Session Isolation** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Community Size** | 🌱 New | ⭐ Huge | ⭐ Large | ⭐ Large |

**Note**: Dotfiles Plus is new and focused on security and AI integration. The established projects have larger communities and more themes/plugins.

## 🚀 Installation

### Quick Install
```bash
# Clone the repository
git clone https://github.com/anivar/dotfiles-plus.git
cd dotfiles-plus

# For bash 3.2+ or zsh (recommended)
source dotfiles-plus.sh

# For bash 4+ with all features
source dotfiles-plus-full.sh
```

### Add to Your Shell
```bash
# For Bash users
echo 'source ~/path/to/dotfiles-plus/dotfiles-plus.sh' >> ~/.bashrc

# For Zsh users
echo 'source ~/path/to/dotfiles-plus/dotfiles-plus.sh' >> ~/.zshrc

# Note: Some advanced features may work better in bash
# If you experience issues in zsh, try using bash or report an issue
```

### Migrate Existing Setup
```bash
./migrate-universal.sh
```

## 💡 Real Usage Examples

### AI Integration in Action
```bash
# Direct questions
$ ai "what is the command to find large files?"
🤖 AI Query [session_123]: what is the command to find large files?
📍 Directory: dotfiles-plus
🔵 Using claude...
To find large files, you can use: find . -type f -size +100M

# Remember across sessions
$ ai remember "working on authentication bug - check JWT expiry"
💾 Remembered at 3 context levels: working on authentication bug - check JWT expiry

$ ai recall
📚 Smart Context Recall:
[Shows your memories organized by repository, branch, and directory]
```

### Visual Git Workflow
```bash
$ gst
🌿 Git Status
📍 Branch: main

📝 Modified:   README.md
➕ Added:      new-feature.js
❓ Untracked:  .env.local

$ gc "feat: add new feature"
💬 Suggested: update README.md new-feature.js
Use this message? [Y/n] n
Enter message: feat: implement user authentication
✅ Committed: feat: implement user authentication
```

### Health Monitoring
```bash
$ dotfiles health
🏥 Dotfiles Plus Health Check
====================================
🔧 Core functionality...
  Security functions: ✅ OK
💾 File system...
  Home directory: ✅ OK
🤖 AI providers...
  AI providers: ✅ OK

🎉 All health checks passed!
```

## 🛠️ Troubleshooting

### Common Issues

**"declare: -A: invalid option"**
- You're using bash 3.x. Use `dotfiles-plus.sh` instead of `dotfiles-plus-full.sh`

**AI commands not working**
- Install an AI provider: [Claude](https://claude.ai/code) or [Gemini CLI](https://www.npmjs.com/package/@google/generative-ai-cli)
- Configure API keys if needed: See [Configuration Guide](CONFIGURATION.md)
- Check with `dotfiles health`

**Context features not available**
- The context module is automatically sourced with dotfiles-plus.sh
- If using zsh and experiencing issues, try using bash: `bash -l`

**Functions not found in zsh**
- This is a known compatibility issue with some zsh configurations
- Try using bash for full functionality: `bash`
- Or add `setopt NO_KSH_ARRAYS` to your .zshrc before sourcing

## 🤝 Contributing

Contributions welcome! Areas that need help:
- Testing on different shells and systems
- Additional AI provider integrations
- Performance optimizations
- Documentation improvements

## 💖 Support the Project

If you find Dotfiles Plus useful, consider:

- ⭐ **Star** this repository
- 💝 **[Sponsor](https://github.com/sponsors/anivar)** the development
- 🐛 **Report** issues you encounter
- 💡 **Suggest** features you'd like to see
- 📣 **Share** with other developers

Your support helps keep the project active and motivates new features!

## 📁 Project Structure

```
dotfiles-plus/
├── dotfiles-plus.sh          # Shell-compatible version (bash 3.2+)
├── dotfiles-plus-full.sh     # Full version (bash 4+ only)
├── ai/
│   ├── providers.sh          # AI provider management
│   ├── context.sh            # Advanced context (bash 4+)
│   └── context-compat.sh     # Context for bash 3.2+
├── core/
│   ├── security.sh           # Security functions
│   ├── config.sh             # Configuration management
│   └── performance.sh        # Performance optimizations
├── tests/
│   └── test-suite.sh         # Comprehensive test suite
└── migrate-universal.sh      # Migration tool
```

## 🔒 Security Features Detail

1. **Input Sanitization**: All user input filtered for dangerous characters
2. **No eval**: Zero use of eval throughout the codebase
3. **Command Validation**: Only whitelisted commands can be executed
4. **Session Isolation**: Each terminal session has unique context
5. **Safe Execution**: All commands use quoted parameters

## 🙏 Acknowledgments

Inspired by the excellent work of:
- Oh My Zsh - For the plugin ecosystem model
- Bash-it - For the modular approach
- Prezto - For performance considerations
- The security community - For highlighting shell vulnerabilities

## 📄 License

MIT - Because sharing is caring.

---

## 📖 Documentation

- **[Complete Command Reference](COMMANDS.md)** - All commands with examples
- **[Context Features Guide](CONTEXT_FEATURES.md)** - Deep dive into AI memory system
- **[Installation Guide](#-installation)** - Setup instructions
- **[Troubleshooting](#-troubleshooting)** - Common issues and solutions

## 🚦 Quick Start

1. **Clone**: `git clone https://github.com/anivar/dotfiles-plus.git`
2. **Source**: `source dotfiles-plus/dotfiles-plus.sh`
3. **Test**: `ai "hello world"` and `dotfiles status`
4. **Explore**: Check out the [Command Reference](COMMANDS.md)

---

**Remember**: Choose the dotfiles manager that fits your workflow. Dotfiles Plus focuses on security and AI integration, which might not be everyone's priority.

*Built with focus on security and AI integration*