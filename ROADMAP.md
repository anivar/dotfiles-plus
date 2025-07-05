# 🚀 Dotfiles Plus Roadmap

Based on analysis of Claude Code, Cursor 1.2, and Gemini CLI features - adapted for shell environments.

## Version 1.2 - Memory Import System ✅
- [x] Import external memory files with `@path` syntax
- [x] Recursive memory discovery up directory tree
- [x] Maximum import depth configuration
- [x] Support for .ai-memory and CLAUDE.md files
- [x] Memory templates (bug-report, feature-planning, code-review)

## Version 1.3 - Extended Thinking & Conversations ✅
- [x] Thinking mode for complex problem solving
- [x] Continue last conversation
- [x] Resume with interactive picker
- [x] Freeze points (save/restore conversation states)
- [x] Test generation command (ai testgen)
- [x] Context perspectives (ai-arch, ai-dev, ai-fix, etc.)
- [ ] Export/import conversations to files
- [ ] Conversation search and filtering

## Version 1.4 - Enhanced Memory Management
- [ ] Separate project-level memories (AI_MEMORY.md)
- [ ] User-level preferences (~/.ai-memory)
- [ ] Memory tagging and categorization improvements
- [ ] Memory expiration and cleanup
- [ ] Team-shared vs personal memory scopes

## Version 1.5 - Shell Commands & Productivity
- [ ] Shell function aliases for common AI queries
- [ ] Auto-discovery of project type (git, npm, cargo, etc.)
- [ ] Custom command shortcuts (like slash commands but shell-based)
- [ ] Integration with fzf for fuzzy memory search
- [ ] Stats tracking (usage counts, popular queries)

## Version 1.6 - Advanced Integration
- [ ] Integration with more AI providers (OpenAI, local models)
- [ ] Hooks for shell events (cd, git operations)
- [ ] Project-specific AI configurations
- [ ] Memory sync across machines (opt-in)
- [ ] Shell completion for AI commands

## Features Excluded (Not Shell-Compatible)
- ❌ Image/screenshot support (requires GUI)
- ❌ MCP server integration (too complex)
- ❌ JSON configuration (using shell variables instead)
- ❌ Complex ReAct loops (better for dedicated CLIs)

## Design Principles
1. **Security First**: All features must maintain security standards
2. **Shell Compatibility**: Work across bash 3.2+ and zsh
3. **Simplicity**: Commands should be intuitive and memorable
4. **Performance**: Features should not slow down shell startup
5. **Privacy**: User data stays local unless explicitly shared
6. **Unix Philosophy**: Do one thing well, compose with other tools