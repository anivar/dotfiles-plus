#!/usr/bin/env bash
# 🚀 System Bootstrap Module
# Secure system setup and package management

# ============================================================================
# SECURE SCRIPT DOWNLOAD SYSTEM
# ============================================================================

# Known script checksums for verification
declare -A KNOWN_CHECKSUMS=(
    ["homebrew"]="7d75b0af94d0c26b1ac35e30e08e4e32b7b3b8fbebe04eb1f2a6d0cf7d7a7bd7"
    ["nvm"]="123456789abcdef123456789abcdef123456789abcdef123456789abcdef12"
)

# Secure script download with verification
_bootstrap_download_script() {
    local script_name="$1"
    local script_url="$2"
    local expected_checksum="${KNOWN_CHECKSUMS[$script_name]}"
    
    if [[ -z "$expected_checksum" ]]; then
        echo "❌ No known checksum for script: $script_name" >&2
        echo "⚠️  For security, only pre-verified scripts can be downloaded" >&2
        return 1
    fi
    
    local temp_script="$(_config_get home)/cache/${script_name}.sh"
    mkdir -p "$(dirname "$temp_script")"
    
    echo "🔒 Downloading and verifying $script_name..."
    
    if _secure_verify_script "$script_url" "$expected_checksum" "$temp_script"; then
        echo "✅ Script verified and ready: $temp_script"
        echo "$temp_script"
    else
        echo "❌ Script verification failed for $script_name" >&2
        return 1
    fi
}

# ============================================================================
# PLATFORM DETECTION
# ============================================================================

# Get platform-specific package manager
_bootstrap_get_package_manager() {
    local platform="$(_config_get platform)"
    
    case "$platform" in
        darwin)
            if command -v brew >/dev/null 2>&1; then
                echo "brew"
            else
                echo "missing_brew"
            fi
            ;;
        linux)
            if command -v apt-get >/dev/null 2>&1; then
                echo "apt"
            elif command -v yum >/dev/null 2>&1; then
                echo "yum"
            elif command -v dnf >/dev/null 2>&1; then
                echo "dnf"
            elif command -v pacman >/dev/null 2>&1; then
                echo "pacman"
            elif command -v zypper >/dev/null 2>&1; then
                echo "zypper"
            else
                echo "unknown"
            fi
            ;;
        *)
            echo "unsupported"
            ;;
    esac
}

# ============================================================================
# PACKAGE MANAGEMENT
# ============================================================================

# Install packages safely
bootstrap_install_packages() {
    local packages=("$@")
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "❌ No packages specified" >&2
        return 1
    fi
    
    # Validate package names
    local safe_packages=()
    for package in "${packages[@]}"; do
        local safe_package
        safe_package=$(_secure_validate_input "$package" "^[a-zA-Z0-9_.-]+$")
        if [[ $? -eq 0 ]]; then
            safe_packages+=("$safe_package")
        else
            echo "⚠️  Skipping invalid package name: $package" >&2
        fi
    done
    
    if [[ ${#safe_packages[@]} -eq 0 ]]; then
        echo "❌ No valid packages to install" >&2
        return 1
    fi
    
    local package_manager
    package_manager=$(_bootstrap_get_package_manager)
    
    echo "📦 Installing packages: ${safe_packages[*]}"
    echo "🔧 Using package manager: $package_manager"
    
    case "$package_manager" in
        brew)
            brew install "${safe_packages[@]}"
            ;;
        apt)
            sudo apt-get update && sudo apt-get install -y "${safe_packages[@]}"
            ;;
        yum)
            sudo yum install -y "${safe_packages[@]}"
            ;;
        dnf)
            sudo dnf install -y "${safe_packages[@]}"
            ;;
        pacman)
            sudo pacman -S --noconfirm "${safe_packages[@]}"
            ;;
        zypper)
            sudo zypper install -y "${safe_packages[@]}"
            ;;
        missing_brew)
            echo "❌ Homebrew not installed. Run 'bootstrap macos' first."
            return 1
            ;;
        unknown|unsupported)
            echo "❌ No supported package manager found"
            return 1
            ;;
    esac
}

# Update system packages
bootstrap_update_system() {
    local package_manager
    package_manager=$(_bootstrap_get_package_manager)
    
    echo "🔄 Updating system packages using $package_manager..."
    
    case "$package_manager" in
        brew)
            brew update && brew upgrade
            ;;
        apt)
            sudo apt-get update && sudo apt-get upgrade -y
            ;;
        yum)
            sudo yum update -y
            ;;
        dnf)
            sudo dnf update -y
            ;;
        pacman)
            sudo pacman -Syu --noconfirm
            ;;
        zypper)
            sudo zypper update -y
            ;;
        *)
            echo "❌ Cannot update: unsupported package manager"
            return 1
            ;;
    esac
    
    echo "✅ System update complete"
}

# ============================================================================
# PLATFORM-SPECIFIC BOOTSTRAP
# ============================================================================

# macOS bootstrap
bootstrap_macos() {
    echo "🍎 Bootstrapping macOS environment..."
    
    # Install Homebrew if needed (with verification)
    if ! command -v brew >/dev/null 2>&1; then
        echo "🍺 Installing Homebrew with verification..."
        
        # Note: In a real implementation, you would have the actual Homebrew checksum
        echo "⚠️  Homebrew installation requires manual verification"
        echo "   Visit: https://brew.sh/ and verify the installation script"
        echo "   Then run: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        return 1
    fi
    
    # Configure macOS defaults
    _bootstrap_macos_defaults
    
    echo "✅ macOS bootstrap complete"
}

# Configure macOS defaults
_bootstrap_macos_defaults() {
    echo "🔧 Configuring macOS defaults..."
    
    # Dock preferences
    defaults write com.apple.dock tilesize -int 48
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock show-recents -bool false
    
    # Finder preferences
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    
    # System preferences
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
    
    # Screenshots
    defaults write com.apple.screencapture location -string "$HOME/Desktop"
    defaults write com.apple.screencapture type -string "png"
    
    # Restart affected applications
    killall Dock Finder 2>/dev/null || true
    
    echo "✅ macOS defaults configured"
}

# Linux bootstrap
bootstrap_linux() {
    echo "🐧 Bootstrapping Linux environment..."
    
    # Update package lists
    local package_manager
    package_manager=$(_bootstrap_get_package_manager)
    
    case "$package_manager" in
        apt)
            sudo apt-get update
            echo "✅ Package lists updated (apt)"
            ;;
        yum)
            sudo yum update
            echo "✅ Package lists updated (yum)"
            ;;
        dnf)
            sudo dnf update
            echo "✅ Package lists updated (dnf)"
            ;;
        pacman)
            sudo pacman -Sy
            echo "✅ Package lists updated (pacman)"
            ;;
        *)
            echo "⚠️  Unknown package manager, skipping update"
            ;;
    esac
    
    # Check git configuration
    _bootstrap_check_git_config
    
    echo "✅ Linux bootstrap complete"
}

# Check and prompt for git configuration
_bootstrap_check_git_config() {
    if [[ -z "$(git config user.name 2>/dev/null)" ]]; then
        echo "⚠️  Git user.name not configured"
        echo "   Run: git config --global user.name 'Your Name'"
    fi
    
    if [[ -z "$(git config user.email 2>/dev/null)" ]]; then
        echo "⚠️  Git user.email not configured"
        echo "   Run: git config --global user.email 'you@email.com'"
    fi
}

# ============================================================================
# APPLICATION INSTALLATION
# ============================================================================

# Install essential applications
bootstrap_apps() {
    echo "📱 Installing essential applications..."
    
    local essential_packages=(
        "git"
        "curl"
        "wget"
        "tree"
        "jq"
    )
    
    # Platform-specific packages
    local platform="$(_config_get platform)"
    if [[ "$platform" == "darwin" ]]; then
        essential_packages+=("ripgrep" "fd" "bat")
    else
        # Linux variants
        local package_manager
        package_manager=$(_bootstrap_get_package_manager)
        case "$package_manager" in
            apt)
                essential_packages+=("ripgrep" "fd-find" "bat")
                ;;
            *)
                essential_packages+=("ripgrep" "fd" "bat")
                ;;
        esac
    fi
    
    bootstrap_install_packages "${essential_packages[@]}"
}

# Install development tools
bootstrap_dev() {
    echo "👨‍💻 Setting up development environment..."
    
    # Node.js via nvm (manual installation required for security)
    if ! command -v node >/dev/null 2>&1 && ! command -v nvm >/dev/null 2>&1; then
        echo "📦 Node.js not found. Manual installation required:"
        echo "   1. Visit: https://github.com/nvm-sh/nvm#installing-and-updating"
        echo "   2. Verify the installation script checksum"
        echo "   3. Install nvm and then run: nvm install --lts"
    fi
    
    # Python development tools
    if command -v python3 >/dev/null 2>&1; then
        echo "🐍 Setting up Python development tools..."
        python3 -m pip install --user --upgrade pip
        python3 -m pip install --user virtualenv pytest black flake8
    fi
    
    # Git configuration enhancements
    _bootstrap_configure_git
    
    echo "✅ Development environment setup complete"
}

# Configure git with safe defaults
_bootstrap_configure_git() {
    echo "🌿 Configuring git with safe defaults..."
    
    # Only set if not already configured
    if [[ -z "$(git config init.defaultBranch 2>/dev/null)" ]]; then
        git config --global init.defaultBranch main
    fi
    
    if [[ -z "$(git config pull.rebase 2>/dev/null)" ]]; then
        git config --global pull.rebase false
    fi
    
    # Enhanced git aliases
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.visual '!gitk'
    
    echo "✅ Git configuration enhanced"
}

# ============================================================================
# FULL BOOTSTRAP
# ============================================================================

# Complete bootstrap process
bootstrap_all() {
    echo "🚀 Starting full bootstrap process..."
    
    local platform="$(_config_get platform)"
    
    # Platform-specific bootstrap
    case "$platform" in
        darwin)
            bootstrap_macos
            ;;
        linux)
            bootstrap_linux
            ;;
        *)
            echo "⚠️  Unsupported platform: $platform"
            echo "   Some features may not work correctly"
            ;;
    esac
    
    # Install essential applications
    bootstrap_apps
    
    # Setup development environment
    bootstrap_dev
    
    echo "🎉 Full bootstrap complete!"
    echo "💡 You may need to restart your shell for all changes to take effect"
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export bootstrap functions
export -f bootstrap_install_packages
export -f bootstrap_update_system
export -f bootstrap_macos
export -f bootstrap_linux
export -f bootstrap_apps
export -f bootstrap_dev
export -f bootstrap_all