# Claude AI Context - Dotfiles Plus v2.0.2

## Project Overview
Dotfiles Plus is an AI-powered shell enhancement system with enterprise-grade security features. Version 2.0.2 features a complete plugin-based architecture with advanced AI capabilities.

## Current State (July 2025)
- **Version**: 2.0.2 (Latest stable release)
- **Architecture**: Plugin-based with lazy loading (replacing monolithic structure)
- **Shell Requirements**: Bash 5.0+ or Zsh (upgraded from Bash 4.0+)
- **Status**: ~95% complete, minor Zsh compatibility issues remaining

## Key Architecture Changes in v2.0

### 1. Plugin System
- Modular architecture with plugins in `/plugins/*.plugin.sh`
- Core libraries in `/lib/*.sh`
- Lazy loading for performance
- Hook system for event-driven automation

### 2. Unified Command Interface
```bash
dotfiles <command> [options]  # All commands under dotfiles namespace
ai <query>                    # AI commands with smart routing
```

### 3. Directory Structure
```
~/.dotfiles-plus/
├── plugins/          # Feature plugins
├── lib/             # Core libraries
├── config/          # User configuration
├── state/           # Runtime state
├── cache/           # Performance cache
├── freezes/         # Saved AI conversations
└── templates/       # AI prompt templates
```

## Features Implemented from Roadmap

### AI Features (v1.3-v1.6)
- ✅ **@file syntax**: `ai "explain @config.json"`
- ✅ **Freeze/thaw**: Save/restore AI conversation states
- ✅ **Test generation**: AI-powered unit test creation
- ✅ **AI perspectives**: `ai-arch`, `ai-dev`, `ai-fix`, `ai-test`, `ai-review`, `ai-debug`
- ✅ **Natural language CLI**: `aig` (git), `aif` (find), `ais` (search), `aih` (help)

### Security Features
- ✅ Encrypted secrets management
- ✅ Audit logging for sensitive operations
- ✅ Permission auto-fixing
- ✅ Secret scanning in code

### Performance Features
- ✅ Command profiling and benchmarking
- ✅ Smart caching with TTL
- ✅ Async job execution
- ✅ Performance monitoring

## Known Issues

### Zsh Compatibility
1. **Fixed**: `dirname` usage before lib loading
2. **Fixed**: Regex syntax with `|` operator  
3. **Remaining**: Some array syntax differences need addressing

### Installation Behavior
- Installs only for current shell ($SHELL)
- Does NOT auto-configure for multiple shells
- Users with both Bash/Zsh must install twice or manually configure

## Testing Commands
```bash
# Test with both shells
./test-both-shells.sh

# Run comprehensive tests
./test-all-features.sh

# Check health
dotfiles health

# Test AI
ai "hello world"
```

## Important Code Patterns

### Plugin Registration
```bash
# In plugin files
command_register "cmdname" "handler_function" "Description"
alias_register "alias" "expansion"
hook_register "event" "handler" priority
```

### Shell Compatibility
```bash
# Use this pattern for Zsh compatibility
if [[ -n "$var" ]]; then
    # Don't use complex regex with |
    [[ "$var" =~ pattern1 ]] || [[ "$var" =~ pattern2 ]]
fi
```

## Development Guidelines

### Adding New Features
1. Create plugin in `/plugins/` if substantial
2. Or add to existing plugin if related
3. Register commands/aliases/hooks
4. Test with both Bash 5 and Zsh

### Code Style
- NO comments unless requested
- Use 4-space indentation
- Prefer `[[` over `[` for conditionals
- Always quote variables: `"$var"`
- Use `local` for function variables

## Release Checklist for v2.0.0
- [ ] Fix remaining Zsh compatibility issues
- [ ] Run full test suite
- [ ] Test fresh installation on macOS
- [ ] Test migration from v1.x
- [ ] Update GitHub Pages site
- [ ] Create git tag and release
- [ ] Submit to Homebrew

## Common Tasks

### Run Linting/Checks
```bash
# Currently no standard linting commands defined
# Ask user for specific commands if needed
```

### Create Commit
```bash
# When ready to commit (only when explicitly asked):
git add -A
git commit -m "feat: migrate to plugin architecture for v2.0

- Add modular plugin system with lazy loading
- Implement hook system for extensibility  
- Create unified dotfiles command interface
- Add all v1.3-v1.6 roadmap features
- Upgrade requirement to Bash 5.0+
- Add Homebrew formula and GitHub Pages

BREAKING CHANGE: Requires Bash 5.0+ (was 4.0+)

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Session Context
This is a continuation of a major refactor where we:
1. Moved from monolithic to plugin architecture
2. Implemented all missing roadmap features
3. Upgraded Bash requirement from 4+ to 5+
4. Created installation infrastructure (Homebrew, GitHub Pages)
5. Fixed most compatibility issues

The user values:
- Preserving ALL existing features during refactor
- Multi-shell support (Bash and Zsh)
- Clean, modular architecture
- Comprehensive testing