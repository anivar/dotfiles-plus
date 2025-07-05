#!/usr/bin/env bash
# Utility functions

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get current timestamp
timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Get epoch time
epoch() {
    date +%s
}

# Check if running in interactive shell
is_interactive() {
    [[ $- == *i* ]]
}

# Check if running in zsh
is_zsh() {
    [[ -n "${ZSH_VERSION:-}" ]]
}

# Check if running in bash
is_bash() {
    [[ -n "${BASH_VERSION:-}" ]]
}

# Get bash major version
bash_version() {
    echo "${BASH_VERSION%%.*}"
}

# Check if bash 4+
is_bash4_plus() {
    is_bash && [[ $(bash_version) -ge 4 ]]
}

# Trim whitespace
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace
    echo -n "$var"
}

# Join array elements with delimiter
join_by() {
    local delimiter="$1"
    shift
    local first="$1"
    shift
    printf '%s' "$first" "${@/#/$delimiter}"
}

# Check if array contains element
contains() {
    local needle="$1"
    shift
    local element
    for element in "$@"; do
        [[ "$element" == "$needle" ]] && return 0
    done
    return 1
}

# Get file age in days
file_age_days() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local now=$(epoch)
        local file_time=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null)
        echo $(( (now - file_time) / 86400 ))
    else
        echo 0
    fi
}

# Create directory if not exists
ensure_dir() {
    local dir="$1"
    [[ -d "$dir" ]] || mkdir -p "$dir"
}

# Read file safely
read_file() {
    local file="$1"
    [[ -f "$file" ]] && cat "$file" 2>/dev/null || true
}

# Write file safely with backup
write_file() {
    local file="$1"
    local content="$2"
    local backup="${3:-true}"
    
    ensure_dir "$(dirname "$file")"
    
    if [[ "$backup" == "true" ]] && [[ -f "$file" ]]; then
        cp "$file" "${file}.bak.$(epoch)"
    fi
    
    echo "$content" > "$file"
}