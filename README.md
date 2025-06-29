# 🚀 Dotfiles Plus v1.0

A modern dotfiles manager that includes many features developers have been asking for - AI integration, enhanced security, and seamless migration from existing setups.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version: 1.0](https://img.shields.io/badge/Version-1.0-blue.svg)](https://github.com/anivar/dotfiles-plus/releases)
[![Shell: Bash/Zsh](https://img.shields.io/badge/Shell-Bash%2FZsh-green.svg)](https://github.com/anivar/dotfiles-plus)

## 🎯 Why Another Dotfiles Manager?

After years of using various dotfiles managers, I kept running into the same wishes:
- "I wish I could ask my AI assistant questions directly from the terminal"
- "I wish my dotfiles were more secure against command injection"
- "I wish I could migrate from my current setup without starting over"
- "I wish git commands showed more visual feedback"
- "I wish my terminal knew what type of project I'm working on"

Dotfiles Plus attempts to address these common requests while respecting the excellent work done by existing solutions.

## 📋 Features You Might Have Been Looking For

### 🤖 AI Integration (Finally!)
```bash
# That feature where you can ask questions without leaving the terminal
ai "how do I fix this error: permission denied"
ai "explain this regex: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

# Remember context across your session
ai remember "debugging authentication issue in user service"
ai "what was I working on?"
```

#### 🧠 AI Context Memory Explained
The AI memory system is intelligently context-aware, understanding where you are and what you're working on:

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

### 🔒 Security Features (Because We've All Been There)
- No more `eval` commands that keep security teams up at night
- Input sanitization that actually works
- Session isolation so your AI contexts don't mix
- That script verification feature we all should have been using

### 🌿 Git Shortcuts (The Ones We Actually Use)
```bash
gst              # Visual git status that's actually readable
gc "fix: typo"   # Quick commits without the ceremony
gac "wip"        # Because sometimes you just need to save
gl               # Pretty logs without remembering the flags
```

### 📂 Smart Project Detection (It Just Works™)
```bash
cd ~/projects/my-node-app
# Automatically detects: Node.js project with npm
# Sets up: proper paths, aliases, completions

cd ~/projects/django-site  
# Automatically detects: Python project with Django
# Configures: virtual env awareness, manage.py shortcuts
```

### 📚 Intelligent Folder Stack Context
```bash
# The AI remembers your navigation patterns
$ cd ~/projects/api
$ ai remember "working on v2 API design"

$ cd src/routes
$ ai remember "need to add pagination to GET endpoints"

$ cd ../models
$ ai remember "User model needs email verification field"

# Later, from anywhere in the project:
$ ai "what did I need to do in this project?"

📚 Context-Aware Memory Stack:
~/projects/api (git: main)
├── "working on v2 API design"
├── /src
│   ├── /routes
│   │   └── "need to add pagination to GET endpoints"
│   └── /models
│       └── "User model needs email verification field"
└── Related contexts from feature branches...

# Jump between projects and maintain context
$ cd ~/projects/frontend
$ ai "what APIs am I integrating with?"
# AI knows you were just in the api project and provides relevant context
```

### 🔄 Universal Migration (Keep Everything You Love)
```bash
# Works with your existing setup - no need to start over
./migrate-universal.sh

# Supports migration from:
# - Oh My Zsh (keeps all your plugins and themes)
# - Bash-it (preserves your aliases and completions)
# - Prezto (maintains your modules and settings)
# - Your custom setup (intelligently detects and preserves)
```

## 📊 Honest Comparison with Popular Alternatives

| What You Get | Dotfiles Plus | Oh My Zsh | Bash-it | Prezto |
|--------------|--------------|-----------|---------|--------|
| **Established Community** | 🌱 Just starting | ⭐ 170k+ stars | ⭐ 14k+ stars | ⭐ 13k+ stars |
| **Plugin Ecosystem** | Basic for now | 300+ plugins | 150+ plugins | 50+ modules |
| **Themes** | Minimal | 150+ themes | 140+ themes | Many themes |
| **AI Integration** | ✅ Built-in | Via plugins | Via plugins | Via plugins |
| **Security Hardening** | ✅ Primary focus | Standard | Standard | Standard |
| **Migration from Others** | ✅ Universal | Start fresh | Start fresh | Start fresh |
| **Auto Project Detection** | ✅ Built-in | Manual setup | Manual setup | Manual setup |

**The Truth**: Oh My Zsh, Bash-it, and Prezto are mature, battle-tested projects with huge communities. They're excellent choices! Dotfiles Plus is new and offers a different approach for those interested in built-in AI features and enhanced security.

## 🚀 Installation

### One-Line Install (The Dream We All Had)
```bash
curl -fsSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash
```

### Migrate from Your Current Setup (Yes, It Actually Works)
```bash
# Keeps all your existing configurations
./migrate-universal.sh
```

## 💡 Real-World Usage Examples

### The "I'm Stuck on an Error" Workflow
```bash
# Getting an error? Ask about it directly
$ npm run build
Error: Module not found: 'react-router-dom'

$ ai "npm error Module not found react-router-dom"
# AI explains the issue and suggests: npm install react-router-dom
```

### The "What Was I Doing?" Monday Morning
```bash
$ ai recall
📚 Smart Context Recall:

Current Location:
- Repo: api-backend (main branch)
- Path: ~/projects/api-backend/src/auth

Relevant Memories:
[Last Week - This Directory] "implement JWT with 15min expiry"
[Friday - Parent Directory] "add refresh token endpoint"
[Friday - Same Branch] "need to update API docs"
[2 Days Ago - Related Branch] "check auth middleware performance"

$ ai "show me what I was doing across all projects"
📊 Cross-Project Context:
- api-backend: Working on JWT authentication
- frontend-app: Integrating with new auth endpoints  
- mobile-app: Updating token refresh logic
- docs: Writing authentication guide
```

### The "Make Git Less Painful" Experience
```bash
$ gst
🌿 Git Status
📍 Branch: feature/user-auth

📝 Modified:   src/auth/jwt.js
➕ Added:      src/auth/refresh.js
❓ Untracked:  .env.example
```

## 🤝 Contributing

This project is new and could use your help! Whether it's:
- Reporting bugs (there probably are some)
- Suggesting features (the weirder, the better)
- Improving documentation (it always needs work)
- Adding your favorite aliases

All contributions are welcome. Check out [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

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

## 🙏 Acknowledgments

Dotfiles Plus stands on the shoulders of giants:
- **Oh My Zsh** - For showing us what's possible with shell customization
- **Bash-it** - For the community-driven approach to dotfiles
- **Prezto** - For performance-focused design
- **All the developers** who've shared their dotfiles publicly

## 📄 License

MIT - Because sharing is caring.

---

**Remember**: The best dotfiles manager is the one that works for you. If that's Oh My Zsh, Bash-it, Prezto, or your own custom setup - that's perfect! Dotfiles Plus is just another option for those looking for something different.

*Built with ❤️ by developers who wanted their AI assistant in the terminal*