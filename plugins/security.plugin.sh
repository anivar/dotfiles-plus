#!/usr/bin/env bash
# Security Plugin - Enhanced security features

# ============================================================================
# SECRET MANAGEMENT
# ============================================================================

# Secure secret storage
dotfiles_secret() {
    local cmd="${1:-list}"
    local key="$2"
    local value="$3"
    
    local secrets_file="$DOTFILES_HOME/config/secrets.sh"
    local encrypted_file="$DOTFILES_HOME/config/secrets.enc"
    
    case "$cmd" in
        set)
            [[ -z "$key" ]] && { log error "Key required"; return 1; }
            [[ -z "$value" ]] && { log error "Value required"; return 1; }
            
            # Validate key
            if ! validate "$key" '^[A-Z_]+$'; then
                log error "Key must be uppercase with underscores only"
                return 1
            fi
            
            # Append to secrets file
            ensure_dir "$(dirname "$secrets_file")"
            echo "export $key='$value'" >> "$secrets_file"
            chmod 600 "$secrets_file"
            
            log success "Secret stored: $key"
            ;;
            
        get)
            [[ -z "$key" ]] && { log error "Key required"; return 1; }
            
            if [[ -f "$secrets_file" ]]; then
                grep "^export $key=" "$secrets_file" | cut -d"'" -f2
            fi
            ;;
            
        list)
            if [[ -f "$secrets_file" ]]; then
                echo "🔐 Stored Secrets:"
                grep "^export" "$secrets_file" | sed 's/export /  /' | sed "s/=.*//"
            else
                echo "No secrets stored."
            fi
            ;;
            
        encrypt)
            if [[ -f "$secrets_file" ]]; then
                if command_exists openssl; then
                    echo -n "Enter encryption password: "
                    read -rs password
                    echo
                    
                    openssl enc -aes-256-cbc -salt -in "$secrets_file" \
                        -out "$encrypted_file" -pass "pass:$password"
                    
                    log success "Secrets encrypted to $encrypted_file"
                else
                    log error "OpenSSL not found"
                fi
            fi
            ;;
            
        decrypt)
            if [[ -f "$encrypted_file" ]]; then
                echo -n "Enter decryption password: "
                read -rs password
                echo
                
                openssl enc -aes-256-cbc -d -in "$encrypted_file" \
                    -out "$secrets_file" -pass "pass:$password"
                
                chmod 600 "$secrets_file"
                log success "Secrets decrypted"
            fi
            ;;
            
        clear)
            echo -n "Clear all secrets? [y/N]: "
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                rm -f "$secrets_file" "$encrypted_file"
                log success "Secrets cleared"
            fi
            ;;
    esac
}

# ============================================================================
# PERMISSION CHECKS
# ============================================================================

# Check file permissions
check_permissions() {
    local issues=0
    
    echo "🔍 Security Check"
    echo "━━━━━━━━━━━━━━━"
    echo ""
    
    # Check SSH keys
    if [[ -d "$HOME/.ssh" ]]; then
        echo "SSH Keys:"
        for key in "$HOME/.ssh/"id_*; do
            [[ ! -f "$key" ]] && continue
            [[ "$key" =~ \.pub$ ]] && continue
            
            local perms=$(stat -f %p "$key" 2>/dev/null | tail -c 4)
            if [[ "$perms" != "600" ]]; then
                echo "  ⚠️  $key has incorrect permissions: $perms (should be 600)"
                ((issues++))
            else
                echo "  ✅ $key"
            fi
        done
    fi
    
    echo ""
    echo "Config Files:"
    
    # Check dotfiles permissions
    for file in "$DOTFILES_HOME/config/secrets.sh" \
                "$HOME/.netrc" \
                "$HOME/.aws/credentials"; do
        [[ ! -f "$file" ]] && continue
        
        local perms=$(stat -f %p "$file" 2>/dev/null | tail -c 4)
        if [[ "$perms" != "600" ]]; then
            echo "  ⚠️  $file has incorrect permissions: $perms"
            ((issues++))
        else
            echo "  ✅ $file"
        fi
    done
    
    echo ""
    if [[ $issues -eq 0 ]]; then
        log success "All permissions correct!"
    else
        log warning "Found $issues permission issues"
        echo ""
        echo "Fix with: dotfiles fix-permissions"
    fi
}

# Fix permissions
fix_permissions() {
    log info "Fixing file permissions..."
    
    # SSH keys
    if [[ -d "$HOME/.ssh" ]]; then
        chmod 700 "$HOME/.ssh"
        find "$HOME/.ssh" -name "id_*" ! -name "*.pub" -exec chmod 600 {} \;
        find "$HOME/.ssh" -name "*.pub" -exec chmod 644 {} \;
    fi
    
    # Config files
    [[ -f "$DOTFILES_HOME/config/secrets.sh" ]] && chmod 600 "$DOTFILES_HOME/config/secrets.sh"
    [[ -f "$HOME/.netrc" ]] && chmod 600 "$HOME/.netrc"
    [[ -f "$HOME/.aws/credentials" ]] && chmod 600 "$HOME/.aws/credentials"
    
    log success "Permissions fixed!"
}

# ============================================================================
# AUDIT LOGGING
# ============================================================================

# Log sensitive commands
audit_log() {
    local cmd="$1"
    local audit_file="$DOTFILES_HOME/logs/audit.log"
    
    ensure_dir "$(dirname "$audit_file")"
    echo "[$(timestamp)] [$$] [$(whoami)@$(hostname)] $cmd" >> "$audit_file"
}

# Enable audit mode
enable_audit() {
    export DOTFILES_AUDIT=true
    log info "Audit mode enabled"
}

# View audit log
view_audit() {
    local audit_file="$DOTFILES_HOME/logs/audit.log"
    
    if [[ -f "$audit_file" ]]; then
        echo "📜 Audit Log"
        echo "━━━━━━━━━━━"
        tail -20 "$audit_file"
    else
        echo "No audit log found."
    fi
}

# ============================================================================
# SECURITY SCANNING
# ============================================================================

# Scan for secrets in code
scan_secrets() {
    local path="${1:-.}"
    
    echo "🔍 Scanning for secrets in: $path"
    echo ""
    
    # Patterns to search for
    local patterns=(
        "password.*=.*['\"]"
        "api_key.*=.*['\"]"
        "secret.*=.*['\"]"
        "token.*=.*['\"]"
        "AWS[A-Z0-9]{16}"
        "AKIA[A-Z0-9]{16}"
        "-----BEGIN.*PRIVATE KEY-----"
    )
    
    local found=0
    for pattern in "${patterns[@]}"; do
        local matches=$(grep -r -i "$pattern" "$path" 2>/dev/null | grep -v "Binary file" | head -5)
        if [[ -n "$matches" ]]; then
            echo "⚠️  Found potential secrets matching: $pattern"
            echo "$matches" | sed 's/^/   /'
            echo ""
            ((found++))
        fi
    done
    
    if [[ $found -eq 0 ]]; then
        log success "No obvious secrets found!"
    else
        log warning "Found $found potential secret patterns"
        echo ""
        echo "Remember to:"
        echo "  • Use environment variables for secrets"
        echo "  • Add sensitive files to .gitignore"
        echo "  • Use 'dotfiles secret' for secure storage"
    fi
}

# ============================================================================
# SECURE OPERATIONS
# ============================================================================

# Secure file deletion
secure_delete() {
    local file="$1"
    
    if [[ -z "$file" ]] || [[ ! -f "$file" ]]; then
        log error "File not found: $file"
        return 1
    fi
    
    echo -n "Securely delete $file? [y/N]: "
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        if command_exists shred; then
            shred -vfz -n 3 "$file"
        elif command_exists gshred; then
            gshred -vfz -n 3 "$file"
        else
            # Fallback: overwrite with random data
            dd if=/dev/urandom of="$file" bs=1024 count=$(du -k "$file" | cut -f1) 2>/dev/null
            rm -f "$file"
        fi
        
        log success "Securely deleted: $file"
    fi
}

# Generate secure password
generate_password() {
    local length="${1:-20}"
    local charset="${2:-all}"
    
    case "$charset" in
        alpha)   chars='A-Za-z' ;;
        alnum)   chars='A-Za-z0-9' ;;
        simple)  chars='A-Za-z0-9!@#$%' ;;
        all|*)   chars='A-Za-z0-9!@#$%^&*()_+-=[]{}|;:,.<>?' ;;
    esac
    
    if command_exists openssl; then
        openssl rand -base64 48 | tr -d "=+/" | cut -c1-"$length"
    else
        < /dev/urandom tr -dc "$chars" | head -c"$length"
    fi
    echo
}

# ============================================================================
# HOOKS
# ============================================================================

# Pre-command security check
security_pre_command() {
    local cmd="$1"
    
    # Audit sensitive commands
    if [[ "${DOTFILES_AUDIT:-}" == "true" ]]; then
        case "$cmd" in
            *secret*|*password*|*key*|*token*)
                audit_log "$cmd"
                ;;
        esac
    fi
    
    # Warn about dangerous commands
    case "$cmd" in
        *"rm -rf /"*|*"dd if="*|*"mkfs"*)
            log warning "Potentially dangerous command detected!"
            echo -n "Continue? [y/N]: "
            read -r response
            [[ ! "$response" =~ ^[Yy]$ ]] && return 1
            ;;
    esac
}

# ============================================================================
# REGISTRATION
# ============================================================================

# Register commands
command_register "secret" "dotfiles_secret" "Manage secrets"
command_register "check-security" "check_permissions" "Security audit"
command_register "fix-permissions" "fix_permissions" "Fix file permissions"
command_register "scan-secrets" "scan_secrets" "Scan for exposed secrets"
command_register "secure-delete" "secure_delete" "Securely delete files"
command_register "generate-password" "generate_password" "Generate secure password"
command_register "audit-log" "view_audit" "View audit log"
command_register "audit-enable" "enable_audit" "Enable audit mode"

# Register hooks
hook_register "pre_command" "security_pre_command" 10

# Auto-load secrets on startup
if [[ -f "$DOTFILES_HOME/config/secrets.sh" ]]; then
    source "$DOTFILES_HOME/config/secrets.sh"
fi