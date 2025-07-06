---
layout: default
---

# Dotfiles Plus

AI-powered terminal productivity suite. Brings Claude, ChatGPT, Gemini, and Ollama directly to your command line.

<div class="badges">
  <img alt="Version" src="https://img.shields.io/github/v/release/anivar/dotfiles-plus?style=flat-square">
  <img alt="License" src="https://img.shields.io/github/license/anivar/dotfiles-plus?style=flat-square">
  <img alt="Platform" src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL-blue?style=flat-square">
</div>

<div class="announcement">
  <strong>🎉 v2.0.3 Released!</strong> Autoupdate system added • Submitted to Homebrew Core
</div>

## Quick Install

<div class="install-methods">
  <div class="method">
    <h3>Homebrew</h3>
    <pre><code>brew tap anivar/dotfiles-plus
brew install dotfiles-plus</code></pre>
  </div>
  
  <div class="method">
    <h3>One-liner</h3>
    <pre><code>curl -sSL https://raw.githubusercontent.com/anivar/dotfiles-plus/main/install.sh | bash</code></pre>
  </div>
</div>

## What It Does

<div class="terminal">
<span class="prompt">$</span> ai "how do I find large files?"
<span class="comment"># AI responds with the exact command you need</span>

<span class="prompt">$</span> ai remember "using PostgreSQL 15 with TimescaleDB"
<span class="comment"># Your AI now knows your project context</span>

<span class="prompt">$</span> ai "explain @package.json"
<span class="comment"># AI reads and explains your files</span>

<span class="prompt">$</span> gst
<span class="comment"># Beautiful git status with visual indicators</span>
</div>

## Core Features

→ **Universal AI** - Works with Claude, ChatGPT, Gemini, Ollama  
→ **Smart Memory** - Remembers context across projects and sessions  
→ **File Integration** - Use `@filename` to include files in queries  
→ **Enhanced Git** - Visual status, smart commits, better workflow  
→ **Secure by Design** - Input sanitization, no eval, encrypted secrets  
→ **Fast** - Under 100ms startup with lazy loading  

## Requirements

- Bash 5.0+ or Zsh
- macOS, Linux, BSD, or WSL
- AI provider (optional)

## Documentation

- [Installation Guide](installation)
- [AI Features](ai-features)
- [Configuration](configuration)
- [Commands Reference](commands)
- [Troubleshooting](troubleshooting)

## Links

[GitHub](https://github.com/anivar/dotfiles-plus) • 
[Releases](https://github.com/anivar/dotfiles-plus/releases) • 
[Issues](https://github.com/anivar/dotfiles-plus/issues) • 
[Support](support)