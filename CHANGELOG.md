# Changelog

All notable changes to Dotfiles Plus will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.2] - 2025-01-06

### Added
- 🚀 Comprehensive release automation with GitHub Actions
- 📝 Version update script handling all branches (main, gh-pages, homebrew-tap)
- ✅ Release checklist and automation scripts
- 🪝 Optional non-blocking git hooks for developers
- 📚 SCRIPTS.md documenting all scripts and their purposes
- 🧹 Repository cleanliness checker
- 📖 Clear documentation explaining install.sh vs init.sh
- 📂 REPOSITORY_STRUCTURE.md explaining what's included and why

### Changed
- 🔧 Enhanced .gitignore with comprehensive exclusions
- 📝 Updated documentation to clarify script purposes
- 🎯 Improved installation instructions with script explanations

### Fixed
- 🔢 Version consistency across all files (now 2.0.2)
- 📄 All references updated from v1.2.0 to current version

## [2.0.1] - 2025-01-06

### Fixed
- 🔧 Version number consistency across all files
- 📝 Removed duplicate files from release
- 🌐 GitHub Pages website with clean developer-friendly theme
- 🍺 Homebrew tap integration on dedicated branch
- 📚 Documentation sync workflow between main and gh-pages

### Added
- 🤖 Support for additional Ollama models (Gemma, Qwen 3, Qwen 2.5-coder)
- 💝 Unified support page combining GitHub Sponsors and Buy Me a Coffee
- 🎨 Professional GitHub-inspired website theme

## [2.0.0] - 2025-01-05

### 🚀 Major Breaking Release

Complete architecture refactor with plugin-based system and advanced features from the roadmap.

### Added

#### Architecture
- 🏗️ **Plugin-based architecture** - Modular design with lazy loading support
- 🎯 **Smart command routing** - Intelligent command dispatch system
- 🪝 **Hook system** - Event-driven automation with priority support
- 🔌 **Unified interface** - Consistent `dotfiles` command structure

#### AI Features (from v1.3-v1.6 roadmap)
- 📁 **@file syntax** - Include files in AI queries (`ai "explain @config.json"`)
- 🔧 **Shell automation** - `ai fix`, `ai explain-last`, `ai suggest`
- 🤖 **AI-powered commands** - `aig`, `aif`, `ais`, `aih` for natural language CLI
- ❄️ **Freeze/thaw states** - Save and restore conversation contexts
- 🧪 **Test generation** - AI-powered unit test creation
- 👥 **Context perspectives** - `ai-arch`, `ai-dev`, `ai-fix`, `ai-test`, `ai-review`, `ai-debug`

#### Security Features
- 🔐 **Encrypted secrets** - Secure credential storage with encryption
- 📝 **Audit logging** - Track sensitive command execution
- 🔍 **Secret scanning** - Detect exposed credentials in code
- 🛡️ **Permission management** - Auto-fix file permissions

#### Performance Features
- ⚡ **Command profiling** - Profile and benchmark commands
- 💾 **Smart caching** - TTL-based cache with garbage collection
- 🚀 **Async jobs** - Background job execution and management
- 📊 **Performance monitoring** - Track slow commands and optimize

#### Installation & Setup
- 🍺 **Homebrew support** - Official Homebrew formula
- 🌐 **GitHub Pages site** - https://dotfiles.plus
- 💰 **GitHub Sponsors** - Support development
- 📦 **Easy installation** - Multiple installation methods

### Changed

#### Breaking Changes
- **Requires Bash 5.0+** (upgraded from Bash 4.0+ requirement for modern features)
- **New directory structure** - Configuration in `~/.dotfiles-plus/`
- **Plugin system** - Replaces monolithic structure
- **Command structure** - All commands now under `dotfiles` namespace

#### Improvements
- Better AI provider detection
- Enhanced memory system with better filtering
- Improved git commands with AI integration
- Comprehensive test suite
- Better documentation with SEO optimization

### Fixed
- All security vulnerabilities from v1.x
- Memory leaks in long-running sessions
- Context collision issues
- Shell compatibility problems

### Removed
- Legacy configuration format
- Bash 3.2 compatibility code
- Deprecated commands

## [1.2.0] - 2025-01-04

### Added
- **AI Thinking Mode** (`ai think`)
  - Extended thinking capabilities for complex problem solving
  - Multi-step reasoning with progress tracking
  - Automatic context preservation
- **AI Import System** (`ai import`)
  - Import memories from files and URLs
  - Automatic project memory discovery
  - Bulk import with intelligent parsing
- **AI Hints System**
  - Command suggestions and tips
  - Context-aware command recommendations
- **AI Templates** (`ai template`)
  - Manage reusable prompt templates
  - Custom prompts for repeated tasks
- **Conversation Continuity**
  - `ai continue` - Continue previous conversation
  - `ai resume` - Resume with full context
- **Documentation**
  - BEST_PRACTICES.md - Comprehensive guide for optimal usage
  - ROADMAP.md - Future development plans
  - Example configurations in examples/ directory

### Changed
- Enhanced main script with new AI command integrations
- Improved command routing for new features
- Better error handling for unavailable features

## [1.1.0] - 2025-07-04

### Fixed
- Function definitions no longer displayed on terminal startup (#1)
- Fixed string concatenation issues in context building functions
- Removed problematic export -f statements

### Added
- **Enhanced AI Memory System** (#2)
  - Auto-tagging for TODOs, links, and issues
  - Importance levels with `--important` flag
  - Custom tags with `--tag` option
  - Advanced recall with search and filtering
  - Memory statistics with `ai stats` command
  - Memory cleanup with `ai clean` command
  - Auto-cleanup to prevent memory bloat (keeps last 100 entries)
- Comprehensive configuration documentation (CONFIGURATION.md)
- API key setup guide for AI providers

### Changed
- Improved ai recall command with search and filtering capabilities
- Enhanced ai remember with automatic content detection
- Updated documentation with new features and examples

## [1.0.0] - 2024-06-28

### Added
- **Core Security Framework**
  - Command injection protection with input sanitization
  - Secure command execution without eval() calls
  - Session isolation for AI contexts
  - Script verification with SHA256 checksums
  - Input validation with regex patterns

- **AI Integration System**
  - Native support for multiple AI providers (Claude, Gemini)
  - Session memory and context management
  - Secure AI command execution with input sanitization
  - Extensible provider framework

- **Enhanced Git Workflow**
  - Smart git status with visual indicators (`gst`)
  - Intelligent commit suggestions (`gc`)
  - Quick add+commit operations (`gac`)
  - Beautiful git log with graph visualization (`gl`)

- **Performance Optimizations**
  - Lazy loading system for modules
  - Intelligent caching with TTL support
  - Batch operations for git and filesystem
  - Performance monitoring and logging

- **Developer Tools**
  - Automatic project detection and configuration
  - Health monitoring and diagnostics
  - Configuration management system
  - Comprehensive backup and restore

- **Installation & Migration**
  - One-line installation script
  - Universal migration from any dotfiles system
  - Support for Oh My Zsh, Bash-it, Prezto, Chezmoi, YADM, and more
  - Zero-downtime migration with complete backups

- **Documentation**
  - Comprehensive README with developer focus
  - Feature guide with detailed examples
  - Security documentation and best practices
  - Migration guides for all major systems

- **Testing Framework**
  - Comprehensive test suite for all components
  - Security function validation
  - Cross-platform compatibility testing
  - Performance benchmarking

### Security
- Eliminated all command injection vulnerabilities
- Implemented comprehensive input sanitization
- Added session isolation for multi-user environments
- Secured AI provider integration with context isolation
- Added cryptographic verification for downloaded scripts

### Performance
- Optimized module loading with lazy initialization
- Implemented intelligent caching for expensive operations
- Added batch processing for git operations
- Minimized startup time with selective loading

### Developer Experience
- Created intuitive command structure
- Added comprehensive help system
- Implemented health monitoring and diagnostics
- Provided migration paths from all major dotfiles systems

---

## Future Releases

### [1.1.0] - Planned
- Enhanced project templates
- Extended AI provider support
- Team collaboration features
- Advanced performance analytics

### [1.2.0] - Planned  
- Plugin system architecture
- Custom theme support
- Enterprise SSO integration
- Advanced security auditing

---

For more details on each release, see the [GitHub Releases](https://github.com/anivar/dotfiles-plus/releases) page.