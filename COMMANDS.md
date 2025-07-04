# 📚 Dotfiles Plus Command Reference

Complete reference for all commands available in Dotfiles Plus v1.0.

## 📑 Table of Contents

- [AI Commands](#-ai-commands)
- [Dotfiles System Commands](#-dotfiles-system-commands)
- [Git Shortcuts](#-git-shortcuts)
- [Shell Aliases](#-shell-aliases)
- [Configuration Commands](#-configuration-commands)
- [Project Management](#-project-management)
- [Bootstrap Commands](#-bootstrap-commands)

---

## 🤖 AI Commands

### Basic AI Query
```bash
ai "your question here"
```
Ask any question to your AI assistant. The query is automatically enhanced with context about your current location, repository, and branch.

**Examples:**
```bash
ai "how do I create a git branch?"
ai "explain this error: ECONNREFUSED"
ai "what's the regex for email validation?"
```

### Memory Management

#### `ai remember`
```bash
ai remember [options] "information to save"
```
Stores information at multiple context levels with support for importance and tagging.

**Options:**
- `--important`, `-i` - Mark memory as important (shows with ⚠️)
- `--tag <tag>`, `-t <tag>` - Add a custom tag for categorization

**Auto-tagging:**
- Content with TODO/FIXME/BUG gets tagged as `task`
- URLs get tagged as `link`
- Content with error/failed/issue gets tagged as `issue` and marked important

**Examples:**
```bash
ai remember "API endpoint is at /api/v2/users"
ai remember --important "critical bug: user data not saving"
ai remember --tag todo "implement rate limiting"
ai remember --tag meeting "discussed new architecture with team"
```

#### `ai recall`
```bash
ai recall [options] [search_term]
```
Displays relevant memories with powerful filtering capabilities.

**Options:**
- `--important`, `-i` - Show only important memories
- `--tag <tag>`, `-t <tag>` - Filter by specific tag

**Examples:**
```bash
ai recall                    # Show all recent memories
ai recall "authentication"   # Search for specific term
ai recall --important        # Show only important items
ai recall --tag todo        # Show all TODO items
ai recall --tag meeting "api" # Search meetings about API
```

**Output includes:**
- Current directory memories
- Current git branch memories
- Repository-wide memories
- Filtered by your criteria

#### `ai forget`
```bash
ai forget
```
Clears the session context for the current directory. Does not affect other context levels.

### Advanced Context Navigation

#### `ai stack`
```bash
ai stack
```
Shows the context stack navigation - displays directory hierarchy with associated memories at each level.

**Example output:**
```
📚 Context Stack Navigation:
📁 ~/projects/api-backend/src/auth
    └── implementing JWT tokens
  📁 ~/projects/api-backend/src
    └── refactoring authentication module
    📁 ~/projects/api-backend
      └── starting OAuth2 implementation
```

#### `ai projects`
```bash
ai projects
```
Displays memories from all projects you've worked on, giving you a cross-project overview.

**Example output:**
```
📊 Cross-Project Context:
📦 api-backend:
  working on JWT authentication
  need to add rate limiting
```

#### `ai stats`
```bash
ai stats
```
Shows memory distribution statistics and usage patterns.

**Output includes:**
- Number of memories by context level (directory, branch, repository)
- Total storage used
- Top 5 most used tags
- Memory distribution across projects

**Example output:**
```
📊 Memory Statistics:

Memory Distribution:
  📁 Directory contexts: 15 files, 342 memories
  🌿 Branch contexts: 8 files, 156 memories
  📦 Repository contexts: 4 files, 89 memories

Total storage: 124K

Top Tags:
  #todo: 23 uses
  #bug: 15 uses
  #feature: 12 uses
  #meeting: 8 uses
  #api: 7 uses
```

#### `ai clean`
```bash
ai clean [days]
```
Cleans up old memories to prevent storage bloat.

**Parameters:**
- `days` - Number of days to keep (default: 30)

**Actions:**
- Removes session files older than specified days
- Compacts context files by keeping only recent 100 entries
- Preserves important memories regardless of age

**Examples:**
```bash
ai clean        # Clean memories older than 30 days
ai clean 7      # Clean memories older than 7 days
ai clean 90     # Clean memories older than 90 days

📦 frontend-app:
  integrating with new auth API
  update token refresh logic
```

### AI Provider Management

#### `ai help`
```bash
ai help
```
Shows all available AI commands with brief descriptions.

---

## 🚀 Dotfiles System Commands

### `dotfiles status`
```bash
dotfiles status
```
Displays comprehensive system status including:
- Version information
- Current session ID
- Platform details
- Shell information
- Configuration home directory

### `dotfiles health`
```bash
dotfiles health
```
Runs a complete health check on the Dotfiles Plus installation:
- Core functionality verification
- Security functions check
- File system permissions
- AI provider availability
- Configuration validation

### `dotfiles version`
```bash
dotfiles version
```
Shows version information and active security features:
- Current version number
- Session identifier
- Platform details
- Security feature status

### `dotfiles backup`
```bash
dotfiles backup
```
Creates a timestamped backup of all configurations:
- Saves to `~/.dotfiles-plus/backups/`
- Filename: `backup-YYYYMMDD-HHMMSS.tar.gz`
- Includes all configs, contexts, and settings

### `dotfiles help`
```bash
dotfiles help
```
Displays help information for all dotfiles commands.

---

## 🌿 Git Shortcuts

### `gst` - Enhanced Git Status
```bash
gst
```
Visual git status with icons and colors:
- 📍 Shows current branch
- 📝 Modified files
- ➕ Added files
- 🗑️ Deleted files
- ❓ Untracked files

### `gc` - Smart Commit
```bash
gc "commit message"
gc  # Without message - suggests one based on changes
```
Intelligent git commit that can auto-generate messages:
- If no message provided, suggests one based on changed files
- Prompts for confirmation of suggested message
- Only works if there are staged changes

**Example:**
```bash
$ gc
💬 Suggested: update README.md package.json
Use this message? [Y/n] n
Enter message: feat: add new authentication system
✅ Committed: feat: add new authentication system
```

### `gac` - Add All + Commit
```bash
gac "commit message"
```
Shortcut for `git add .` followed by `gc`. Stages all changes and commits in one command.

### `gl` - Pretty Git Log
```bash
gl        # Shows last 10 commits
gl 20     # Shows last 20 commits
```
Displays git log in a pretty, graph format with decorations.

### `g` - Git Alias
```bash
g status
g add .
g push
```
Short alias for the `git` command.

---

## 🔧 Shell Aliases

### Navigation
- `..` - Go up one directory (`cd ..`)
- `ll` - List files with details (`ls -la`)

### Text Processing
- `grep` - Grep with color enabled by default

### AI Shortcuts
- `remember` - Alias for `ai remember`
- `forget` - Alias for `ai forget`

---

## ⚙️ Configuration Commands
*Available in Full Version (bash 4+)*

### `config get`
```bash
config get <key> [default_value]
```
Retrieves a configuration value. Returns default if key doesn't exist.

**Examples:**
```bash
config get shell
config get custom_key "default_value"
```

### `config set`
```bash
config set <key> <value>
```
Sets a configuration value persistently.

**Example:**
```bash
config set editor "nvim"
config set theme "dark"
```

### `config save`
```bash
config save
```
Saves current configuration to disk.

### `config edit`
```bash
config edit
```
Opens the main configuration file in your default editor.

### `config providers edit`
```bash
config providers edit
```
Opens the AI providers configuration file for editing.

### `config providers test`
```bash
config providers test
```
Tests all configured AI providers for availability.

---

## 📂 Project Management
*Available in Full Version (bash 4+)*

### `project init`
```bash
project init [name]
```
Initializes project-specific configuration in the current directory.

### `project detect`
```bash
project detect
```
Auto-detects the project type (Node.js, Python, Go, etc.) and configures appropriate settings.

### `project current`
```bash
project current
```
Shows information about the current project:
- Project type
- Configuration status
- Available commands

### `project list`
```bash
project list
```
Lists all known projects with their configurations.

### Project-Specific Commands
```bash
project build    # Run project build command
project test     # Run project tests
project dev      # Start development server
project install  # Install dependencies
```
These commands automatically use the appropriate tool for your project type (npm, pip, cargo, etc.).

---

## 🛠️ Bootstrap Commands
*Available in Full Version (bash 4+)*

### `bootstrap macos`
```bash
bootstrap macos
```
Configures macOS with sensible defaults:
- Finder settings
- Dock configuration
- Security preferences
- Developer tools

### `bootstrap linux`
```bash
bootstrap linux
```
Sets up Linux environment with:
- Package manager configuration
- Development tools
- System preferences

### `bootstrap apps`
```bash
bootstrap apps
```
Installs essential applications based on your platform.

### `bootstrap dev`
```bash
bootstrap dev
```
Sets up complete development environment:
- Programming languages
- Version managers
- Development tools
- IDEs and editors

### `bootstrap all`
```bash
bootstrap all
```
Runs complete system setup - combines all bootstrap commands.

### `bootstrap install`
```bash
bootstrap install <package_name>
```
Cross-platform package installation that uses the appropriate package manager.

### `bootstrap update`
```bash
bootstrap update
```
Updates all system packages using the platform's package manager.

---

## 🎯 Quick Command Lookup

### Most Used Commands
| Command | Description |
|---------|-------------|
| `ai "question"` | Ask AI assistant |
| `ai remember` | Save context info |
| `ai recall` | Show saved context |
| `gst` | Visual git status |
| `gc` | Smart git commit |
| `dotfiles status` | System status |

### Context Commands
| Command | Description |
|---------|-------------|
| `ai stack` | Show context hierarchy |
| `ai projects` | Cross-project view |
| `ai forget` | Clear session |

### System Commands
| Command | Description |
|---------|-------------|
| `dotfiles health` | Health check |
| `dotfiles backup` | Create backup |
| `dotfiles version` | Version info |

---

## 💡 Pro Tips

1. **Context Awareness**: The AI system automatically includes context from your current directory, git branch, and repository. You don't need to explain where you are.

2. **Memory Hierarchy**: When you `ai remember` something, it's saved at multiple levels. Switch branches or directories and you'll see relevant memories for that context.

3. **Smart Commits**: Let `gc` suggest commit messages - it analyzes your changes and creates meaningful messages.

4. **Session Isolation**: Each terminal session has its own context. Open multiple terminals for different tasks without context mixing.

5. **Quick Access**: Use the shorter aliases (`remember`, `forget`, `g`) for frequently used commands.

---

## 🔍 Getting Help

- For any command, try adding `help` after it
- Check system health: `dotfiles health`
- View this reference: `cat ~/.dotfiles-plus/COMMANDS.md`
- Report issues: [GitHub Issues](https://github.com/anivar/dotfiles-plus/issues)