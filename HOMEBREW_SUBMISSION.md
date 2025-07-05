# Homebrew Submission Guide

This guide documents the process for submitting Dotfiles Plus to Homebrew.

## Current Status

- ✅ Formula created and tested
- ✅ Personal tap ready: `anivar/dotfiles-plus`
- ⏳ Pending submission to `homebrew-core`

## Personal Tap Setup

The formula is currently available via personal tap:

```bash
brew tap anivar/dotfiles-plus
brew install dotfiles-plus
```

## Submitting to Homebrew Core

### Prerequisites for homebrew-core

1. **Popularity**: The formula needs to demonstrate usage
   - GitHub stars (aim for 75+)
   - Download statistics
   - Active community

2. **Quality Requirements**:
   - ✅ Stable release (v2.0.1)
   - ✅ Tagged releases
   - ✅ License (MIT)
   - ✅ Tests included
   - ⏳ No deprecated dependencies

3. **Formula Requirements**:
   - ✅ Correct SHA256
   - ✅ Proper dependencies
   - ✅ Test block
   - ✅ No emoji in desc (homebrew-core rule)

### Submission Process

1. **Fork homebrew-core**:
   ```bash
   gh repo fork homebrew/homebrew-core --clone
   cd homebrew-core
   ```

2. **Create branch**:
   ```bash
   git checkout -b dotfiles-plus-2.0.1
   ```

3. **Add formula** (modified for homebrew-core):
   ```ruby
   class DotfilesPlus < Formula
     desc "Supercharge your terminal with AI-powered shell enhancements"
     homepage "https://github.com/anivar/dotfiles-plus"
     url "https://github.com/anivar/dotfiles-plus/archive/refs/tags/v2.0.1.tar.gz"
     sha256 "22ff5eefc9523ee0e63151a2ce4d97f2aea4045f06e37f6130d219a2c11ab009"
     license "MIT"
     
     depends_on "bash" => "5.0"
     depends_on "jq" => :recommended
     
     def install
       bin.install "dotfiles.sh" => "dotfiles-plus"
       prefix.install "lib"
       prefix.install "plugins"
       prefix.install "install.sh"
       prefix.install "uninstall.sh"
       prefix.install "init.sh"
       
       (bin/"dotfiles-plus-init").write <<~EOS
         #!/usr/bin/env bash
         export DOTFILES_ROOT="#{prefix}"
         source "#{prefix}/dotfiles.sh"
       EOS
     end
     
     def caveats
       <<~EOS
         Add this to your shell configuration:
           source #{opt_bin}/dotfiles-plus-init
       EOS
     end
     
     test do
       system "bash", "-c", "source #{bin}/dotfiles-plus-init && dotfiles version"
     end
   end
   ```

4. **Test locally**:
   ```bash
   brew install --build-from-source Formula/dotfiles-plus.rb
   brew test dotfiles-plus
   brew audit --strict dotfiles-plus
   ```

5. **Create PR**:
   ```bash
   git add Formula/dotfiles-plus.rb
   git commit -m "dotfiles-plus 2.0.1 (new formula)"
   git push origin dotfiles-plus-2.0.1
   gh pr create
   ```

### Alternative: Homebrew Tap

For now, maintain personal tap at:
- https://github.com/anivar/homebrew-dotfiles-plus

This allows immediate availability while building community support for homebrew-core submission.

## Tap Repository Structure

Create separate repository `homebrew-dotfiles-plus`:

```
homebrew-dotfiles-plus/
├── Formula/
│   └── dotfiles-plus.rb
└── README.md
```

## Marketing for Adoption

To meet homebrew-core requirements:

1. **Documentation**:
   - Improve GitHub Pages site
   - Create video tutorials
   - Write blog posts

2. **Community**:
   - Share on Reddit (r/bash, r/commandline)
   - Post on Hacker News
   - Twitter/X announcements

3. **Integration**:
   - VSCode extension
   - Oh My Zsh plugin
   - Prezto module

## Timeline

1. **Now**: Personal tap available
2. **Next 3 months**: Build community and stars
3. **Future**: Submit to homebrew-core when criteria met