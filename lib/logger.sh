#!/usr/bin/env bash
# Logging functions

# Log levels
readonly LOG_LEVEL_ERROR=1
readonly LOG_LEVEL_WARNING=2
readonly LOG_LEVEL_INFO=3
readonly LOG_LEVEL_DEBUG=4

# Current log level (default: INFO)
DOTFILES_LOG_LEVEL="${DOTFILES_LOG_LEVEL:-3}"

# Log to file and/or stdout
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(timestamp)
    
    # Format message
    local formatted="[$timestamp] [$level] $message"
    
    # Log to file if enabled
    if [[ -n "$DOTFILES_LOG_FILE" ]] && [[ -d "$(dirname "$DOTFILES_LOG_FILE")" ]]; then
        echo "$formatted" >> "$DOTFILES_LOG_FILE"
    fi
    
    # Log to stdout if interactive
    if is_interactive; then
        case "$level" in
            ERROR)   echo -e "${COLOR_RED}${ICON_ERROR} ${COLOR_RESET}$message" ;;
            WARNING) echo -e "${COLOR_YELLOW}${ICON_WARNING} ${COLOR_RESET}$message" ;;
            INFO)    echo -e "${COLOR_BLUE}${ICON_INFO} ${COLOR_RESET}$message" ;;
            DEBUG)   echo -e "${COLOR_CYAN}[DEBUG] ${COLOR_RESET}$message" ;;
            SUCCESS) echo -e "${COLOR_GREEN}${ICON_SUCCESS} ${COLOR_RESET}$message" ;;
        esac
    fi
}

# Convenience functions
log_error() {
    [[ $DOTFILES_LOG_LEVEL -ge $LOG_LEVEL_ERROR ]] && log "ERROR" "$@"
}

log_warning() {
    [[ $DOTFILES_LOG_LEVEL -ge $LOG_LEVEL_WARNING ]] && log "WARNING" "$@"
}

log_info() {
    [[ $DOTFILES_LOG_LEVEL -ge $LOG_LEVEL_INFO ]] && log "INFO" "$@"
}

log_debug() {
    [[ $DOTFILES_LOG_LEVEL -ge $LOG_LEVEL_DEBUG ]] && log "DEBUG" "$@"
}

log_success() {
    log "SUCCESS" "$@"
}

# Show spinner for long operations
show_spinner() {
    local pid="$1"
    local message="${2:-Working...}"
    local spin='⣾⣽⣻⢿⡿⣟⣯⣷'
    local i=0
    
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) % ${#spin} ))
        printf "\r${COLOR_BLUE}%s${COLOR_RESET} %s" "${spin:$i:1}" "$message"
        sleep 0.1
    done
    
    printf "\r%*s\r" "${#message}" ""  # Clear line
}

# Progress bar
show_progress() {
    local current="$1"
    local total="$2"
    local width="${3:-50}"
    
    local percent=$((current * 100 / total))
    local filled=$((width * current / total))
    
    printf "\r["
    printf "%${filled}s" | tr ' ' '='
    printf "%$((width - filled))s" | tr ' ' '-'
    printf "] %d%%" "$percent"
    
    [[ $current -eq $total ]] && echo ""
}