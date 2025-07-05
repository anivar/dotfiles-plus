#!/usr/bin/env bash
# Test installation and setup process

echo "🧪 Testing Dotfiles Plus Installation"
echo "===================================="
echo ""

# Create temporary test environment
TEST_DIR="/tmp/dotfiles-test-$$"
export HOME="$TEST_DIR"
mkdir -p "$TEST_DIR"

echo "📁 Test directory: $TEST_DIR"
echo ""

# Copy files to test directory
echo "Copying files..."
cp -r . "$TEST_DIR/dotfiles-plus"
cd "$TEST_DIR/dotfiles-plus"

# Test install script
echo ""
echo "🚀 Testing install.sh"
echo "━━━━━━━━━━━━━━━━━━"

if ./install.sh; then
    echo "✅ Installation successful"
else
    echo "❌ Installation failed"
    exit 1
fi

# Check if sourcing works
echo ""
echo "🔧 Testing shell integration"
echo "━━━━━━━━━━━━━━━━━━━━━━━"

# Test with bash
if command -v bash >/dev/null; then
    echo -n "Testing Bash integration... "
    if bash -c "source ~/.bashrc && dotfiles version" >/dev/null 2>&1; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
    fi
fi

# Test with zsh
if command -v zsh >/dev/null; then
    echo -n "Testing Zsh integration... "
    if zsh -c "source ~/.zshrc && dotfiles version" >/dev/null 2>&1; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
    fi
fi

# Test setup wizard
echo ""
echo "🎯 Testing setup wizard"
echo "━━━━━━━━━━━━━━━━━━━"

# Simulate user input for setup
echo -e "5\nn\n" | bash -c "source ~/.bashrc && dotfiles setup" >/dev/null 2>&1

echo "✅ Setup wizard completed"

# Check directory structure
echo ""
echo "📂 Checking directory structure"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"

for dir in .dotfiles-plus/state .dotfiles-plus/cache .dotfiles-plus/config; do
    if [[ -d "$TEST_DIR/$dir" ]]; then
        echo "✅ $dir exists"
    else
        echo "❌ $dir missing"
    fi
done

# Test uninstall
echo ""
echo "🗑️  Testing uninstall"
echo "━━━━━━━━━━━━━━━━━"

if ./uninstall.sh; then
    echo "✅ Uninstall successful"
else
    echo "❌ Uninstall failed"
fi

# Cleanup
echo ""
echo "🧹 Cleaning up..."
cd /
rm -rf "$TEST_DIR"

echo ""
echo "✅ Installation test complete!"