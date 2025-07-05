# Homebrew Tap Setup Using Branch

Instead of a separate repository, we'll use a `homebrew-tap` branch in the main repo.

## Setup Instructions

1. **Create the homebrew-tap branch**:
   ```bash
   git checkout -b homebrew-tap
   git rm -rf . --cached
   git clean -fdx
   ```

2. **Create tap structure**:
   ```bash
   mkdir Formula
   cp ../main/homebrew/dotfiles-plus.rb Formula/
   
   echo "# Dotfiles Plus Homebrew Tap
   
   ## Installation
   
   \`\`\`bash
   brew tap anivar/dotfiles-plus https://github.com/anivar/dotfiles-plus
   brew install dotfiles-plus
   \`\`\`" > README.md
   
   git add Formula/ README.md
   git commit -m "Homebrew tap formula"
   git push origin homebrew-tap
   ```

3. **Users can then install via**:
   ```bash
   brew tap anivar/dotfiles-plus https://github.com/anivar/dotfiles-plus
   brew install dotfiles-plus
   ```

This approach keeps everything in one repository!