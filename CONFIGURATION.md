# 🔧 Configuration Guide

This guide covers how to configure Dotfiles Plus, including AI provider setup, API keys, and customization options.

## 📋 Table of Contents

- [AI Provider Setup](#-ai-provider-setup)
- [API Key Configuration](#-api-key-configuration)
- [Environment Variables](#-environment-variables)
- [Configuration Files](#-configuration-files)
- [Security Best Practices](#-security-best-practices)

---

## 🤖 AI Provider Setup

Dotfiles Plus supports multiple AI providers. The `ai` command automatically detects and uses the first available provider.

### Supported Providers

1. **Claude (Anthropic)**
   - Install: Visit [claude.ai/code](https://claude.ai/code)
   - Command: `claude`
   - No API key needed for Claude Code

2. **Gemini (Google)**
   - Install: `npm install -g @google/generative-ai-cli`
   - Command: `gemini`
   - Requires API key setup

3. **Other Providers**
   - Can be added by modifying `ai/providers.sh`

## 🔑 API Key Configuration

### Method 1: Environment Variables (Recommended)

Add to your `.bashrc` or `.zshrc`:

```bash
# For Gemini
export GEMINI_API_KEY="your-api-key-here"

# For OpenAI (if added as provider)
export OPENAI_API_KEY="your-api-key-here"

# For custom providers
export YOUR_PROVIDER_API_KEY="your-api-key-here"
```

### Method 2: Secure Token Management

Dotfiles Plus includes a secure token management system:

```bash
# Create secure tokens file
cat > ~/.config/secure-tokens.zsh << 'EOF'
# Secure token storage
export GEMINI_API_KEY="your-api-key-here"
export OPENAI_API_KEY="your-api-key-here"
EOF

# Set proper permissions
chmod 600 ~/.config/secure-tokens.zsh
```

This file is automatically sourced if it exists and has proper permissions.

### Method 3: Provider Configuration File

For provider-specific settings:

```bash
# Edit provider configuration
cat > ~/.dotfiles-plus/config/providers.conf << 'EOF'
# Provider configuration
default_provider=claude
gemini_model=gemini-pro
temperature=0.7
EOF
```

## 🌍 Environment Variables

### Core Variables

These are set automatically by Dotfiles Plus:

- `DOTFILES_CONFIG_HOME` - Base configuration directory
- `DOTFILES_PLUS_VERSION` - Current version
- `DOTFILES_PLUS_SESSION_ID` - Unique session identifier

### Optional Variables

You can set these for customization:

```bash
# Change default AI provider
export DOTFILES_AI_PROVIDER="gemini"

# Set memory retention days (default: 30)
export DOTFILES_MEMORY_RETENTION=60

# Enable debug mode
export DOTFILES_DEBUG=1
```

## 📁 Configuration Files

### Directory Structure

```
~/.dotfiles-plus/
├── config/
│   ├── dotfiles.conf      # Main configuration
│   └── providers.conf     # AI provider settings
├── contexts/              # Memory storage
├── sessions/              # Session data
└── backups/              # Configuration backups
```

### Main Configuration (`dotfiles.conf`)

```bash
# Example configuration
version=1.0
theme=default
memory_limit=1000
auto_cleanup=true
```

### Customizing Behavior

You can override default behaviors by editing configuration files:

```bash
# Edit main configuration
dotfiles config set memory_limit 500
dotfiles config set auto_cleanup false

# View current configuration
dotfiles config list
```

## 🔒 Security Best Practices

### 1. API Key Security

- **Never commit API keys** to version control
- Use environment variables or secure token files
- Set restrictive permissions: `chmod 600 ~/.config/secure-tokens.zsh`
- Rotate keys regularly

### 2. File Permissions

```bash
# Secure your configuration
chmod 700 ~/.dotfiles-plus
chmod 600 ~/.dotfiles-plus/config/*
chmod 600 ~/.config/secure-tokens.zsh
```

### 3. Backup Sensitive Data

```bash
# Backup configuration (excludes sensitive data)
dotfiles backup create

# Restore from backup
dotfiles backup restore
```

### 4. Audit Access

```bash
# Check for exposed secrets
dotfiles security audit

# View access logs
dotfiles security logs
```

## 🔗 Additional Resources

- [AI Commands Documentation](COMMANDS.md#-ai-commands)
- [Security Features](FEATURES.md#-security-features)
- [Troubleshooting Guide](README.md#-troubleshooting)
- [Contributing Guidelines](CONTRIBUTING.md)

---

For more help, visit the [Dotfiles Plus repository](https://github.com/anivar/dotfiles-plus) or open an issue.