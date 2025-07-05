class DotfilesPlus < Formula
  desc "🚀 Supercharge your terminal with AI-powered shell enhancements"
  homepage "https://github.com/anivar/dotfiles-plus"
  url "https://github.com/anivar/dotfiles-plus/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "22ff5eefc9523ee0e63151a2ce4d97f2aea4045f06e37f6130d219a2c11ab009"
  license "MIT"
  version "2.0.1"

  depends_on "bash" => "5.0"
  
  # Optional dependencies for AI providers
  depends_on "ollama" => :optional
  depends_on "jq" => :recommended

  def install
    # Install main script
    bin.install "dotfiles.sh" => "dotfiles-plus"
    
    # Install directories
    prefix.install "lib"
    prefix.install "plugins"
    prefix.install "install.sh"
    prefix.install "uninstall.sh"
    prefix.install "init.sh"
    
    # Create wrapper script
    (bin/"dotfiles-plus-init").write <<~EOS
      #!/usr/bin/env bash
      # Initialize Dotfiles Plus
      export DOTFILES_ROOT="#{prefix}"
      source "#{prefix}/dotfiles.sh"
    EOS
  end

  def caveats
    <<~EOS
      To complete the installation, add this to your shell config:

      For Bash (~/.bashrc):
        source #{opt_bin}/dotfiles-plus-init

      For Zsh (~/.zshrc):
        source #{opt_bin}/dotfiles-plus-init

      Then run:
        dotfiles setup

      For AI features, install one of:
        - Claude Code: https://claude.ai/download
        - Gemini CLI: npm install -g @google/generative-ai-cli
        - Ollama: brew install ollama
    EOS
  end

  test do
    system "bash", "-c", "source #{bin}/dotfiles-plus-init && dotfiles version"
  end
end