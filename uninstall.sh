#!/usr/bin/env bash
# Uninstall script for Dotfiles Plus

echo "🗑️  Uninstalling Dotfiles Plus..."
echo ""

# Remove from shell configs
for rc in ~/.bashrc ~/.zshrc ~/.bash_profile ~/.zprofile; do
    if [[ -f "$rc" ]]; then
        echo "Cleaning $rc..."
        # Remove our source line
        grep -v "source.*dotfiles-plus/dotfiles.sh" "$rc" > "$rc.tmp"
        mv "$rc.tmp" "$rc"
        
        # Remove our source line (alternative formats)
        grep -v "source.*dotfiles-plus/dotfiles-plus.sh" "$rc" > "$rc.tmp"
        mv "$rc.tmp" "$rc"
        
        grep -v ". .*dotfiles-plus/dotfiles" "$rc" > "$rc.tmp"
        mv "$rc.tmp" "$rc"
    fi
done

# Ask about removing data
echo ""
echo -n "Remove all Dotfiles Plus data? [y/N]: "
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Removing data directory..."
    rm -rf ~/.dotfiles-plus
    echo "✅ Data removed"
else
    echo "📁 Data preserved in ~/.dotfiles-plus"
fi

# Remove from PATH if added
if [[ -f ~/.dotfiles-plus/bin ]]; then
    echo "Note: You may need to manually remove ~/.dotfiles-plus/bin from your PATH"
fi

echo ""
echo "✅ Dotfiles Plus has been uninstalled"
echo ""
echo "Thank you for using Dotfiles Plus!"
echo "We'd love to hear your feedback: https://github.com/anivar/dotfiles-plus/discussions"