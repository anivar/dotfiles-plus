class DotfilesPlus < Formula
  desc "🚀 AI-powered terminal productivity suite"
  homepage "https://github.com/anivar/dotfiles-plus"
  url "https://github.com/anivar/dotfiles-plus/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "placeholder_will_be_updated_after_release"
  license "MIT"
  version "2.0.3"

  depends_on "bash" => "5.0"
  
  # Optional dependencies for AI providers
  depends_on "jq" => :recommended

  def install
    # Install all files to libexec
    libexec.install Dir["*"]
    
    # Create main executable
    (bin/"dotfiles-plus").write <<~EOS
      #!/usr/bin/env bash
      # Dotfiles Plus launcher
      
      # Check if already initialized
      if [[ -z "$DOTFILES_PLUS_HOME" ]]; then
        export DOTFILES_PLUS_HOME="$HOME/.dotfiles-plus"
        
        # First time setup
        if [[ ! -d "$DOTFILES_PLUS_HOME" ]]; then
          echo "🚀 First time setup..."
          bash "#{libexec}/install.sh"
          exit 0
        fi
      fi
      
      # Source the main script
      source "#{libexec}/dotfiles-plus.sh"
    EOS
    
    (bin/"dotfiles-plus").chmod 0755
  end

  def caveats
    <<~EOS
      🚀 Dotfiles Plus has been installed!
      
      To get started:
        dotfiles-plus
      
      This will set up Dotfiles Plus in your home directory and configure your shell.
      
      To add to your shell manually, add this to your ~/.bashrc or ~/.zshrc:
        source $(brew --prefix)/bin/dotfiles-plus
      
      AI Providers (install separately):
        • Claude Code: Visit https://claude.ai/code
        • Gemini CLI: npm install -g @google/generative-ai-cli
        • Ollama: brew install ollama
      
      ☕ Support the project: https://buymeacoffee.com/anivar
    EOS
  end

  test do
    system "#{bin}/dotfiles-plus", "--version"
  end
end