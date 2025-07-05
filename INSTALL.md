# 🚀 Installing Dotfiles Plus

Choose your preferred installation method:

## 🍺 Install with Homebrew (Recommended)

```bash
# Add the official tap
brew tap anivar/dotfiles-plus

# Install Dotfiles Plus
brew install dotfiles-plus

# Add to your shell configuration:
# For Bash:
echo 'source $(brew --prefix)/opt/dotfiles-plus/bin/dotfiles-plus-init' >> ~/.bashrc

# For Zsh:
echo 'source $(brew --prefix)/opt/dotfiles-plus/bin/dotfiles-plus-init' >> ~/.zshrc

# Reload your shell
exec $SHELL

# Run initial setup
dotfiles setup
```

**Note**: The Homebrew formula automatically installs Bash 5+ if needed.

## 📦 Quick Install (One-liner)

```bash
curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash
```

Or with wget:

```bash
wget -qO- https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash
```

## 🐳 Docker Try-Out

Try without installing:

```bash
docker run -it anivar/dotfiles-plus
```

## 🛠️ Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/anivar/dotfiles-plus.git ~/.dotfiles-plus
   cd ~/.dotfiles-plus
   ```

2. **Run installer:**
   ```bash
   ./install.sh
   ```

3. **Reload shell:**
   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

4. **Run setup:**
   ```bash
   dotfiles setup
   ```

## 🎯 Quick Start After Installation

### 1. Setup AI Provider

The setup wizard will guide you, but you can also:

```bash
# If you have Claude Code installed
dotfiles config ai_provider claude

# If you have Gemini CLI
dotfiles config ai_provider gemini

# If you have Ollama
dotfiles config ai_provider ollama

# If you have an API key
dotfiles secret set OPENAI_API_KEY "your-key"
dotfiles config ai_provider openai-api
```

### 2. Initialize Your Project

For existing projects:
```bash
curl -sSL https://dotfiles.plus/init | bash -s -- --project
```

For new projects:
```bash
curl -sSL https://dotfiles.plus/init | bash -s -- --new my-project
```

### 3. Try It Out

```bash
# Ask AI anything
ai "how do I find large files in this directory?"

# Remember important context
ai remember "working on authentication feature using JWT"

# Get smart git status
gst

# See all commands
dotfiles help
```

## 📋 System Requirements

- **Shell**: Bash 5.0+ or Zsh
- **OS**: macOS, Linux, WSL
- **Optional**: AI provider (Claude, Gemini, Ollama, or API key)

## 🔧 Configuration Files

After installation, your config lives in:
- `~/.dotfiles-plus/` - Main configuration directory
- `~/.bashrc` or `~/.zshrc` - Shell integration

## 🆘 Troubleshooting

### Command not found

```bash
# Reload your shell config
source ~/.bashrc  # or ~/.zshrc

# Or start a new terminal
```

### AI not working

```bash
# Check AI provider
dotfiles config ai_provider

# Test connection
dotfiles test_ai
```

### Permission issues

```bash
# Fix permissions
dotfiles fix-permissions
```

## 🔄 Updating

### With Homebrew
```bash
brew update && brew upgrade dotfiles-plus
```

### Manual update
```bash
cd ~/.dotfiles-plus
git pull
./install.sh --update
```

## 🗑️ Uninstalling

### With Homebrew
```bash
brew uninstall dotfiles-plus
```

### Manual uninstall
```bash
~/.dotfiles-plus/uninstall.sh
```

## 📚 Next Steps

- Read the [Quick Start Guide](README.md#-quick-start)
- Explore [Advanced Features](README.md#-features)
- Check out [Examples](examples/)
- Join our [Community](https://github.com/anivar/dotfiles-plus/discussions)

---

Need help? [Open an issue](https://github.com/anivar/dotfiles-plus/issues) or check our [FAQ](https://github.com/anivar/dotfiles-plus/wiki/FAQ).