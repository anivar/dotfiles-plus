# Enhanced AI Context Features

## Overview
The Dotfiles Plus system now includes sophisticated multi-level AI context awareness that intelligently tracks and recalls information based on your current location in the filesystem and git repository.

## How It Works

### Context Hierarchy
The system tracks context at multiple levels:
1. **Session Level** - Isolated to current terminal session
2. **Directory Level** - Specific to current directory
3. **Branch Level** - Tracks context per git branch
4. **Repository Level** - Shared across entire repository

### Smart Memory Storage
When you use `ai remember "information"`, it automatically stores at all relevant levels:
```bash
$ ai remember "API endpoint is at /api/v2/users"
💾 Remembered at 3 context levels: API endpoint is at /api/v2/users
```

### Intelligent Recall
The `ai recall` command shows relevant memories from all context levels:
```bash
$ ai recall
📚 Smart Context Recall:

Current Location:
- Repo: my-project (feature-branch)
- Path: /home/user/my-project/src

📁 This Directory:
  [2025-06-29 19:20:55] Working on user authentication

🌿 This Branch (feature-branch):
  [2025-06-29 19:15:30] [/home/user/my-project] Feature: Adding OAuth support

📦 This Repository:
  [2025-06-29 18:00:00] [main:/home/user/my-project] Project uses PostgreSQL
```

### Context Navigation
View your context stack with `ai stack`:
```bash
$ ai stack
📚 Context Stack Navigation:

📁 /home/user/my-project/src/auth
    └── [19:20] Implementing JWT tokens
  📁 /home/user/my-project/src
    └── [19:15] Refactoring authentication module
    📁 /home/user/my-project
      └── [18:00] Starting new feature development
```

### Cross-Project Awareness
See memories from all your projects with `ai projects`:
```bash
$ ai projects
📊 Cross-Project Context:

📦 dotfiles-plus:
  [19:10] Testing new AI context features
  [18:45] Fixed security vulnerabilities
  
📦 my-api:
  [17:30] Deployed to staging environment
  [16:00] Updated database schema
```

## Implementation Details

### File Storage
Context files are stored in `~/.dotfiles-plus/contexts/`:
- `dir_[hash].context` - Directory-specific memories
- `repo_[name].context` - Repository-level memories
- `repo_[name]_branch_[branch].context` - Branch-specific memories
- `session_[id]_[path].context` - Session-specific memories

### Shell Compatibility
Two implementations are provided:
1. **context.sh** - Full featured with bash 4+ associative arrays
2. **context-compat.sh** - Compatible with bash 3.x and other shells

### Automatic Loading
The enhanced context is automatically loaded if available, with fallback to basic context for compatibility.

## Use Cases

### Development Workflow
```bash
# Starting work on a feature
$ ai remember "Working on user authentication feature"

# In a specific directory
$ cd src/auth
$ ai remember "JWT implementation goes here"

# Switch branches
$ git checkout main
$ ai recall  # Shows main branch context

$ git checkout feature-auth
$ ai recall  # Shows feature branch context
```

### Project Documentation
```bash
# Document important decisions
$ ai remember "Decided to use PostgreSQL for better JSON support"

# Track TODOs
$ ai remember "TODO: Add rate limiting to API endpoints"

# Record debugging insights
$ ai remember "Bug: Race condition in session management - check mutex"
```

### Cross-Project Learning
```bash
# See what you were working on across projects
$ ai projects

# Navigate between projects with context preserved
$ cd ~/project-a
$ ai recall  # Shows project-a context

$ cd ~/project-b  
$ ai recall  # Shows project-b context
```

## Benefits

1. **Never Lose Context** - Memories persist across terminal sessions
2. **Branch Isolation** - Each git branch maintains its own context
3. **Hierarchical Organization** - Information is naturally organized by location
4. **Cross-Project Intelligence** - Learn from patterns across all your projects
5. **AI Integration** - Context automatically included in AI queries

This system transforms how you interact with AI assistants by providing rich, location-aware context that makes every query more intelligent and relevant.