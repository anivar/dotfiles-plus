# Changelog

All notable changes to Dotfiles Plus will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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