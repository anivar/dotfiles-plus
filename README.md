# 🚀 Dotfiles Plus v1.0

A security-focused dotfiles manager with built-in AI integration, smart context awareness, and seamless migration from existing setups. Works with bash 3.2+ and zsh.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version: 1.0](https://img.shields.io/badge/Version-1.0-blue.svg)](https://github.com/anivar/dotfiles-plus/releases)
[![Shell: Bash 3.2+/Zsh](https://img.shields.io/badge/Shell-Bash%203.2%2B%2FZsh-green.svg)](https://github.com/anivar/dotfiles-plus)
[![Security: Hardened](https://img.shields.io/badge/Security-Hardened-red.svg)](https://github.com/anivar/dotfiles-plus)

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

## ✅ Tested & Working Features

### 🤖 AI Integration
```bash
# Ask questions directly from your terminal
ai "how do I fix this error: permission denied"
ai "explain this regex: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

# Context-aware memory system
ai remember "debugging authentication issue in user service"
ai recall                    # Shows context at multiple levels
ai forget                    # Clear current session context
ai stack                     # Navigate context hierarchy
ai projects                  # View memories across all projects

# Supports multiple AI providers
# Works with: Claude (claude.ai/code), Gemini CLI, and others
```

#### 🧠 Multi-Level Context Memory (Tested & Working)
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
g                # Alias for git

# Git status shows:
# 📍 Repository name and current branch
# 📝 Modified files
# ➕ Added files  
# 🗑️  Deleted files
# ❓ Untracked files
```

### 📊 System Management
```bash
dotfiles status   # Show system status, version, and session info
dotfiles health   # Run comprehensive health check
dotfiles version  # Display version and security features
dotfiles backup   # Create timestamped backup of all configs
dotfiles help     # Show all available commands
```

### 📚 Working Features by Version

#### Shell-Compatible Version (bash 3.2+/zsh)
- ✅ AI integration with multiple providers
- ✅ Multi-level context memory (with context-compat.sh)
- ✅ Security hardening and input sanitization
- ✅ Enhanced git commands
- ✅ System status and health checks
- ✅ Configuration backup
- ✅ Session isolation
- ✅ Basic aliases and shortcuts

#### Full Version (bash 4+ only)
- ✅ All shell-compatible features
- ✅ Advanced project detection
- ✅ Bootstrap automation
- ✅ Performance optimizations
- ✅ Modular lazy loading
- ✅ Extended configuration management

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
# Add to ~/.bashrc or ~/.zshrc
echo 'source ~/path/to/dotfiles-plus/dotfiles-plus.sh' >> ~/.bashrc

# For enhanced AI context features
echo 'source ~/path/to/dotfiles-plus/ai/context-compat.sh' >> ~/.bashrc
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
- Check with `dotfiles health`

**Context features not available**
- Source the context module: `source ~/path/to/dotfiles-plus/ai/context-compat.sh`

## 🤝 Contributing

Contributions welcome! Areas that need help:
- Testing on different shells and systems
- Additional AI provider integrations
- Performance optimizations
- Documentation improvements

## 💖 Support the Project

If you find Dotfiles Plus useful, consider:

- ⭐ Starring the repository
- 🐛 Reporting issues you encounter
- 💡 Suggesting features you'd like to see
- 📣 Sharing with other developers

### Sponsorship
If you'd like to support development:

[![Sponsor](https://img.shields.io/badge/Sponsor-%E2%9D%A4-pink)](https://github.com/sponsors/anivar)

Every bit helps keep the project going and motivates new features!

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

## 🚦 Quick Start Guide

1. **Clone**: `git clone https://github.com/anivar/dotfiles-plus.git`
2. **Source**: `source dotfiles-plus/dotfiles-plus.sh`
3. **Test**: `ai "hello world"` and `dotfiles status`
4. **Customize**: Add to your `.bashrc` or `.zshrc`

---

**Remember**: Choose the dotfiles manager that fits your workflow. Dotfiles Plus focuses on security and AI integration, which might not be everyone's priority.

*Built with focus on security and AI integration*