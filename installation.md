---
layout: default
title: Installation Guide
---

# 📦 Installation Guide

Dotfiles Plus offers multiple installation methods to suit your preferences and environment.

## 🚀 Quick Start

### Option 1: Homebrew (Recommended for macOS)

```bash
# Add tap and install
brew tap anivar/dotfiles-plus https://github.com/anivar/dotfiles-plus
brew install dotfiles-plus

# Verify installation
dotfiles version
```

### Option 2: One-Line Installer

```bash
# Install to ~/.dotfiles-plus
curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash

# Restart shell
exec $SHELL
```

### Option 3: Manual Installation

```bash
# Clone repository
git clone https://github.com/anivar/dotfiles-plus.git ~/.dotfiles-plus

# Run installer
cd ~/.dotfiles-plus
./install.sh

# Source in your shell
echo 'source ~/.dotfiles-plus/dotfiles.sh' >> ~/.bashrc  # or ~/.zshrc
exec $SHELL
```

## 📋 Prerequisites

### Shell Requirements

Dotfiles Plus requires **Bash 5.0+** or **Zsh**.

#### macOS Users
macOS ships with Bash 3.2 (from 2007). You need to upgrade:

```bash
# Install modern Bash
brew install bash

# Add to allowed shells
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells

# Set as default shell
chsh -s "$(brew --prefix)/bin/bash"

# Verify version
bash --version  # Should show 5.0+
```

#### Linux Users
Most modern Linux distributions include Bash 5+:

```bash
# Check version
bash --version

# Ubuntu/Debian upgrade if needed
sudo apt update && sudo apt install bash

# Fedora/RHEL upgrade if needed
sudo dnf update bash
```

### System Dependencies

Required tools (usually pre-installed):
- `git` - For version control
- `curl` or `wget` - For downloads
- `sed`, `awk` - Text processing
- `jq` (optional) - JSON processing

```bash
# macOS
brew install git curl jq

# Ubuntu/Debian
sudo apt install git curl jq

# Fedora/RHEL
sudo dnf install git curl jq
```

## 🔧 Post-Installation Setup

### 1. Verify Installation

```bash
# Check version
dotfiles version

# Run health check
dotfiles health

# View loaded plugins
dotfiles plugins list
```

### 2. Configure AI Provider

Dotfiles Plus supports multiple AI providers:

#### Claude (Auto-detected)
```bash
# If Claude Code is installed, it's automatically available
ai "hello world"
```

#### OpenAI API
```bash
# Set API key
dotfiles secret set OPENAI_API_KEY "sk-..."

# Configure provider
dotfiles config set ai_provider openai

# Test
ai "explain bash functions"
```

#### Google Gemini
```bash
# Set API key
dotfiles secret set GEMINI_API_KEY "..."

# Configure provider
dotfiles config set ai_provider gemini
```

#### Local Ollama
```bash
# Install Ollama
brew install ollama

# Pull a model
ollama pull llama3

# Configure
dotfiles config set ai_provider ollama
dotfiles config set ollama_model llama3
```

### 3. Import Existing Configuration

```bash
# Import from Oh My Zsh
dotfiles migrate oh-my-zsh

# Import from Prezto
dotfiles migrate prezto

# Import custom aliases
dotfiles import ~/.bash_aliases
```

## 🏗️ Advanced Installation

### Custom Installation Directory

```bash
# Set custom directory
export DOTFILES_PLUS_HOME="$HOME/.config/dotfiles-plus"

# Run installer
curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash
```

### Unattended Installation

```bash
# Skip all prompts
curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash -s -- --yes

# With custom options
curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash -s -- \
  --yes \
  --shell zsh \
  --no-git-enhancements
```

### Docker Installation

```dockerfile
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Dotfiles Plus
RUN curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash -s -- --yes

# Set as default shell
SHELL ["/bin/bash", "-c"]
RUN echo 'source ~/.dotfiles-plus/dotfiles.sh' >> ~/.bashrc
```

## 🔄 Updating

### Homebrew Users
```bash
brew update
brew upgrade dotfiles-plus
```

### Manual Update
```bash
# Built-in updater
dotfiles update

# Force update
dotfiles update --force

# Update to specific version
dotfiles update --version 2.0.0
```

## 🗑️ Uninstallation

### Complete Removal
```bash
# Run uninstaller
dotfiles uninstall

# Or manually
rm -rf ~/.dotfiles-plus
# Remove source line from ~/.bashrc or ~/.zshrc
```

### Backup First
```bash
# Create backup
dotfiles backup create pre-uninstall

# List backups
dotfiles backup list

# Restore if needed
dotfiles backup restore pre-uninstall
```

## 🆘 Troubleshooting

### Common Issues

#### "Command not found" after installation
```bash
# Ensure it's sourced
source ~/.dotfiles-plus/dotfiles.sh

# Check shell config
grep dotfiles ~/.bashrc ~/.zshrc
```

#### Slow shell startup
```bash
# Profile startup time
dotfiles profile

# Disable heavy plugins
dotfiles config set performance_mode true
```

#### AI commands not working
```bash
# Check provider
dotfiles config get ai_provider

# Test provider
dotfiles ai test

# View logs
dotfiles logs ai
```

### Getting Help

```bash
# Built-in help
dotfiles help
ai help

# Online resources
dotfiles docs
dotfiles issues
```

## 📝 Next Steps

- [Command Reference](commands.html) - Learn all available commands
- [Configuration Guide](configuration.html) - Customize your setup
- [AI Features](ai-features.html) - Master AI integration
- [Plugin Development](plugins.html) - Create custom plugins

---

<div style="text-align: center; margin-top: 3em;">
  <a href="index.html" class="btn-secondary">← Back to Home</a>
  <a href="commands.html" class="btn">Commands →</a>
</div>