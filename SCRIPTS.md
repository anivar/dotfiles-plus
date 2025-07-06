# 📜 Scripts Documentation

This document explains all the scripts in Dotfiles Plus and their purposes.

## 🚀 Installation Scripts

### `install.sh`
**Purpose**: Full system installation of Dotfiles Plus

**Usage**: 
```bash
./install.sh
# or
curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash
```

**What it does**:
- Checks system requirements (Bash 5+, OS compatibility)
- Creates directory structure in `~/.dotfiles-plus`
- Copies all files and plugins
- Sets up shell integration (.bashrc/.zshrc)
- Creates initial configuration
- Runs verification tests
- Provides setup instructions

**When to use**: First-time installation or complete reinstallation

---

### `init.sh`
**Purpose**: Initialize AI memory for specific projects

**Usage**:
```bash
cd /path/to/project
~/.dotfiles-plus/init.sh
```

**What it does**:
- Creates `.ai-memory` file with project template
- Creates `.ai-templates/` directory for custom prompts
- Updates `.gitignore` to exclude local AI files
- Can also perform full installation if not already installed

**When to use**: Adding AI capabilities to an existing project

---

## 🧪 Testing Scripts

### `test.sh`
**Purpose**: Comprehensive test suite for all functionality

**Usage**:
```bash
./test.sh [options]
```

**Options**:
- `--verbose`: Show detailed output
- `--quick`: Run only essential tests
- `--shell <shell>`: Test with specific shell (bash/zsh)

**What it tests**:
- Core functionality
- Plugin loading
- AI commands
- Configuration management
- Security features
- Performance benchmarks

---

### `test-both-shells.sh`
**Purpose**: Test compatibility with both Bash and Zsh

**Usage**:
```bash
./test-both-shells.sh
```

**What it does**:
- Runs full test suite in Bash
- Runs full test suite in Zsh
- Compares results
- Reports compatibility issues

---

## 🔧 Maintenance Scripts

### `scripts/update-version.sh`
**Purpose**: Update version numbers across all files

**Usage**:
```bash
./scripts/update-version.sh <new-version>
# Example: ./scripts/update-version.sh 2.0.2
```

**What it updates**:
- VERSION file
- dotfiles-plus.sh version export
- plugins/config.plugin.sh version display
- CLAUDE.md headers
- _config.yml on gh-pages branch
- Homebrew formula (version only, not SHA)

**Features**:
- Validates semantic versioning
- Creates CHANGELOG template entry
- Updates multiple branches if needed
- Provides next steps for release

---

### `scripts/update-homebrew-sha.sh`
**Purpose**: Update Homebrew formula SHA256 after release

**Usage**:
```bash
./scripts/update-homebrew-sha.sh <version-tag>
# Example: ./scripts/update-homebrew-sha.sh v2.0.2
```

**What it does**:
- Downloads release tarball from GitHub
- Calculates SHA256 checksum
- Updates Formula/dotfiles-plus.rb on homebrew-tap branch
- Commits the change
- Provides push instructions

**When to use**: After creating a GitHub release

---

### `scripts/release-checklist.sh`
**Purpose**: Interactive release preparation checklist

**Usage**:
```bash
./scripts/release-checklist.sh
```

**What it checks**:
- Git status (clean working directory)
- Current branch (must be main)
- Sync with remote
- Test results
- Version consistency
- CHANGELOG entry

**Features**:
- Interactive prompts
- Step-by-step release guide
- Pre-flight checks
- Post-release instructions

---

## 🛠️ Utility Scripts

### `uninstall.sh`
**Purpose**: Clean uninstallation of Dotfiles Plus

**Usage**:
```bash
~/.dotfiles-plus/uninstall.sh [--keep-memories]
```

**Options**:
- `--keep-memories`: Preserve AI memories and contexts

**What it does**:
- Backs up configurations and memories
- Removes shell integration
- Deletes installation directory
- Shows backup location

---

### `migrate-universal.sh`
**Purpose**: Migrate from older versions to v2.0+

**Usage**:
```bash
./migrate-universal.sh
```

**What it does**:
- Detects current version
- Backs up existing installation
- Migrates configurations
- Updates file structure
- Preserves AI memories
- Runs verification tests

---

## 📁 Core System Scripts

### `dotfiles-plus.sh`
**Purpose**: Main entry point and core functionality

**Loaded by**: Shell initialization (.bashrc/.zshrc)

**Provides**:
- Environment setup
- Plugin loading system
- Configuration management
- Command routing
- Performance monitoring

---

### `lib/core.sh`
**Purpose**: Core utility functions

**Provides**:
- Logging functions
- Error handling
- Path utilities
- Security utilities
- Platform detection

---

### `lib/hooks.sh`
**Purpose**: Event-driven hook system

**Provides**:
- Hook registration
- Hook execution
- Priority management
- Event triggering

---

### `lib/registry.sh`
**Purpose**: Command and plugin registry

**Provides**:
- Command registration
- Plugin discovery
- Lazy loading support
- Dependency management

---

## 🎯 Best Practices

1. **Always run tests** before committing changes:
   ```bash
   ./test.sh --verbose
   ```

2. **Use version update script** for releases:
   ```bash
   ./scripts/update-version.sh 2.0.3
   ```

3. **Test both shells** for compatibility:
   ```bash
   ./test-both-shells.sh
   ```

4. **Follow release checklist**:
   ```bash
   ./scripts/release-checklist.sh
   ```

5. **Initialize projects** properly:
   ```bash
   cd /your/project
   ~/.dotfiles-plus/init.sh
   ```

## 🔍 Script Locations

```
dotfiles-plus/
├── install.sh              # System installation
├── init.sh                 # Project initialization
├── test.sh                 # Test suite
├── test-both-shells.sh     # Shell compatibility tests
├── uninstall.sh           # Uninstaller
├── migrate-universal.sh    # Version migration
├── dotfiles-plus.sh       # Main entry point
├── lib/                   # Core libraries
│   ├── core.sh
│   ├── hooks.sh
│   └── registry.sh
└── scripts/               # Maintenance scripts
    ├── update-version.sh
    ├── update-homebrew-sha.sh
    └── release-checklist.sh
```

## 📚 See Also

- [INSTALL.md](INSTALL.md) - Installation guide
- [COMMANDS.md](COMMANDS.md) - Command reference
- [CONFIGURATION.md](CONFIGURATION.md) - Configuration guide
- [ROADMAP.md](ROADMAP.md) - Development roadmap