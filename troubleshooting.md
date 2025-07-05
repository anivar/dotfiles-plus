---
layout: default
title: Troubleshooting Guide - Fix AI Terminal Issues
description: Solve common problems with AI-powered terminal. Fix Claude CLI errors, ChatGPT terminal issues, bash configuration problems, and shell startup errors.
keywords: ai terminal troubleshooting, fix bash errors, claude cli problems, chatgpt terminal issues, shell configuration fix, terminal debugging
---

# 🔧 Troubleshooting Guide

Having issues? This guide covers common problems and their solutions.

## 🚨 Common Issues

### Installation Problems

#### "Bash 5.0+ required" Error

**Problem**: macOS ships with Bash 3.2 (from 2007)

**Solution**:
```bash
# Install modern Bash
brew install bash

# Add to allowed shells
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells

# Set as default
chsh -s "$(brew --prefix)/bin/bash"

# Verify
bash --version  # Should show 5.0+
```

#### "Command not found" After Installation

**Problem**: Shell configuration not loaded

**Solution**:
```bash
# Check if sourced
grep dotfiles ~/.bashrc ~/.zshrc

# If missing, add manually
echo 'source ~/.dotfiles-plus/dotfiles.sh' >> ~/.bashrc

# Reload shell
exec $SHELL

# Verify
dotfiles version
```

#### Installation Hangs or Fails

**Problem**: Network issues or permissions

**Solution**:
```bash
# Manual installation
git clone https://github.com/anivar/dotfiles-plus.git ~/.dotfiles-plus
cd ~/.dotfiles-plus
chmod +x install.sh
./install.sh

# If git fails, download ZIP
curl -L https://github.com/anivar/dotfiles-plus/archive/main.zip -o dotfiles.zip
unzip dotfiles.zip
mv dotfiles-plus-main ~/.dotfiles-plus
```

### AI Command Issues

#### "AI provider not configured"

**Problem**: No AI provider set up

**Solution**:
```bash
# Check current provider
dotfiles config get ai_provider

# Configure provider
# For Claude (auto-detected if installed)
dotfiles config set ai_provider claude

# For OpenAI
dotfiles secret set OPENAI_API_KEY "sk-..."
dotfiles config set ai_provider openai

# For Ollama (local)
ollama pull llama3
dotfiles config set ai_provider ollama

# Test
ai test
```

#### AI Commands Return Empty/No Response

**Problem**: API issues or timeout

**Solution**:
```bash
# Check API connectivity
dotfiles ai test --verbose

# Increase timeout
dotfiles config set ai_timeout 60

# Check API key
dotfiles secret get OPENAI_API_KEY

# Try different model
dotfiles config set openai_model gpt-3.5-turbo

# Enable debug mode
dotfiles config set debug_ai true
ai "test query"
```

#### "Model not found" with Ollama

**Problem**: Model not downloaded

**Solution**:
```bash
# List available models
ollama list

# Pull required model
ollama pull llama3
ollama pull codellama

# Set model
dotfiles config set ollama_model llama3

# Verify
echo "test" | ollama run llama3
```

### Performance Issues

#### Slow Shell Startup

**Problem**: Too many features loading

**Solution**:
```bash
# Profile startup
dotfiles profile startup

# Enable minimal mode
dotfiles config set performance_mode minimal

# Disable heavy features
dotfiles config set git_auto_fetch false
dotfiles config set ai_preload false
dotfiles config set plugin_lazy_load true

# Check specific plugin impact
dotfiles profile plugins
```

#### High Memory Usage

**Problem**: Cache or memory growth

**Solution**:
```bash
# Check memory usage
dotfiles stats memory

# Clear caches
dotfiles cache clean
ai memories clean

# Limit memory retention
dotfiles config set ai_memory_max_count 500
dotfiles config set cache_max_size "50M"

# Disable unused plugins
dotfiles plugin list
dotfiles plugin disable heavy-plugin
```

### Git Enhancement Issues

#### Git Commands Not Working

**Problem**: Git enhancements conflict

**Solution**:
```bash
# Check if enhanced
dotfiles config get git_enhanced_commands

# Disable if needed
dotfiles config set git_enhanced_commands false

# Or use original commands
\git status  # Bypass alias
command git status  # Use original
```

#### "Command not found: gst"

**Problem**: Aliases not loaded

**Solution**:
```bash
# Reload configuration
dotfiles reload

# Check aliases
alias | grep "gst"

# Manually source
source ~/.dotfiles-plus/plugins/git.plugin.sh

# Verify
type gst
```

### Memory System Issues

#### Memories Not Persisting

**Problem**: Storage or permissions issue

**Solution**:
```bash
# Check memory directory
ls -la ~/.dotfiles-plus/memories/

# Fix permissions
chmod -R 755 ~/.dotfiles-plus/memories/

# Test memory system
ai remember "test memory"
ai recall "test"

# Check memory file
cat ~/.dotfiles-plus/memories/general.json
```

#### "Memory full" Errors

**Problem**: Memory limit reached

**Solution**:
```bash
# Check memory stats
ai stats

# Clean old memories
ai memories clean --older-than 30

# Increase limit
dotfiles config set ai_memory_max_count 2000

# Export and reset
ai memories export > memories-backup.json
ai memories clear
```

## 🐛 Debugging Techniques

### Enable Debug Mode

```bash
# Global debug
dotfiles config set debug_mode true
dotfiles config set log_level debug

# Component debugging
dotfiles config set debug_ai true
dotfiles config set debug_git true
dotfiles config set debug_hooks true

# View logs
tail -f ~/.dotfiles-plus/logs/debug.log
```

### Trace Command Execution

```bash
# Trace shell execution
set -x  # Enable
your_command
set +x  # Disable

# Trace specific function
dotfiles trace ai "hello world"
```

### Check System Health

```bash
# Full health check
dotfiles health --verbose

# Specific checks
dotfiles test config
dotfiles test ai
dotfiles test plugins
dotfiles test permissions
```

## 🔍 Platform-Specific Issues

### macOS Issues

#### "Operation not permitted" Errors

**Problem**: macOS security restrictions

**Solution**:
```bash
# Grant terminal full disk access
# System Preferences → Security & Privacy → Privacy → Full Disk Access
# Add Terminal.app or iTerm.app

# Reset permissions
tccutil reset All com.apple.Terminal
```

#### Homebrew Formula Not Found

**Problem**: Tap not added

**Solution**:
```bash
# Add tap explicitly
brew tap anivar/dotfiles-plus https://github.com/anivar/dotfiles-plus

# Update and retry
brew update
brew install dotfiles-plus
```

### Linux Issues

#### "No such file or directory"

**Problem**: Different path structure

**Solution**:
```bash
# Check shell paths
echo $PATH

# Add to PATH if needed
export PATH="$HOME/.dotfiles-plus/bin:$PATH"

# Make permanent
echo 'export PATH="$HOME/.dotfiles-plus/bin:$PATH"' >> ~/.bashrc
```

### WSL Issues

#### Slow Performance

**Problem**: Windows filesystem overhead

**Solution**:
```bash
# Use Linux filesystem
cd ~  # Stay in Linux filesystem

# Disable Windows PATH
dotfiles config set wsl_windows_path false

# Optimize for WSL
dotfiles config set wsl_optimizations true
```

## 💊 Quick Fixes

### Reset Everything

```bash
# Backup current config
dotfiles backup create "before-reset"

# Reset to defaults
dotfiles config reset
dotfiles cache clean
dotfiles plugin reset

# Reload
dotfiles reload
```

### Reinstall Specific Component

```bash
# Reinstall plugins
dotfiles plugin reinstall git-enhanced

# Reinstall AI provider
dotfiles ai setup --force

# Rebuild cache
dotfiles cache rebuild
```

### Emergency Unload

```bash
# Temporarily disable
export DOTFILES_PLUS_DISABLE=1
exec $SHELL

# Remove from shell
sed -i '/dotfiles-plus/d' ~/.bashrc

# Full uninstall
~/.dotfiles-plus/uninstall.sh
```

## 📋 Diagnostic Commands

### Collect System Info

```bash
# Generate diagnostic report
dotfiles diagnose > diagnostic.txt

# What's included:
# - System info
# - Configuration
# - Installed plugins  
# - Recent errors
# - Performance metrics
```

### Check Specific Features

```bash
# AI system
dotfiles diagnose ai

# Git integration  
dotfiles diagnose git

# Plugin system
dotfiles diagnose plugins

# Performance
dotfiles diagnose performance
```

## 🆘 Getting Help

### Built-in Help

```bash
# General help
dotfiles help

# Command help
dotfiles help <command>
ai help

# Show examples
dotfiles examples
```

### Community Support

```bash
# Open GitHub issues
dotfiles issues

# Search existing issues
dotfiles issues search "your problem"

# Join discussions
dotfiles community
```

### Reporting Bugs

When reporting issues, include:

```bash
# 1. System info
dotfiles version --full
echo $SHELL
echo $OSTYPE

# 2. Configuration
dotfiles config list

# 3. Error messages
dotfiles logs --recent

# 4. Steps to reproduce
# List exact commands that cause the issue
```

## 🔄 Recovery Procedures

### Restore from Backup

```bash
# List backups
dotfiles backup list

# Restore
dotfiles backup restore <backup-name>

# Manual restore
cp -r ~/.dotfiles-plus-backup/* ~/.dotfiles-plus/
```

### Safe Mode

```bash
# Start in safe mode
DOTFILES_SAFE_MODE=1 bash

# Minimal features only
dotfiles safe-mode

# Fix issues
dotfiles repair
```

## 📚 Additional Resources

- [GitHub Issues](https://github.com/anivar/dotfiles-plus/issues)
- [Discussions](https://github.com/anivar/dotfiles-plus/discussions)
- [Wiki](https://github.com/anivar/dotfiles-plus/wiki)
- [Discord Community](https://discord.gg/dotfiles-plus)

---

<div style="text-align: center; margin-top: 3em;">
  <a href="plugins.html" class="btn-secondary">← Plugins</a>
  <a href="index.html" class="btn-secondary">Home</a>
  <a href="https://github.com/anivar/dotfiles-plus/issues" class="btn">Report Issue →</a>
</div>

## 💖 Support the Project

If Dotfiles Plus helps your productivity, consider supporting development:

<div style="text-align: center; margin: 2em 0;">
  <a href="https://github.com/sponsors/anivar" class="btn">💖 GitHub Sponsors</a>
  <a href="https://buymeacoffee.com/anivar" class="btn-secondary">☕ Buy Me a Coffee</a>
</div>