#!/usr/bin/env bash
# ⚡ Performance Optimization Module
# Addresses frequent subprocess calls and performance degradation

# ============================================================================
# PERFORMANCE CACHE SYSTEM
# ============================================================================

# Performance cache to avoid repeated expensive operations
declare -A PERF_CACHE
declare -A PERF_CACHE_TIMESTAMPS

# Get cached value or execute function
_perf_cache_get_or_set() {
    local cache_key="$1"
    local ttl="${2:-300}"    # 5 minutes default TTL
    local command_func="$3"
    shift 3
    local func_args=("$@")
    
    local current_time="$(_config_get_timestamp)"
    local cached_value="${PERF_CACHE[$cache_key]}"
    local cache_time="${PERF_CACHE_TIMESTAMPS[$cache_key]:-0}"
    
    # Check if cache is valid
    if [[ -n "$cached_value" && $((current_time - cache_time)) -lt $ttl ]]; then
        echo "$cached_value"
        return 0
    fi
    
    # Execute function and cache result
    if declare -f "$command_func" >/dev/null; then
        local result
        result=$("$command_func" "${func_args[@]}")
        local exit_code=$?
        
        if [[ $exit_code -eq 0 ]]; then
            PERF_CACHE["$cache_key"]="$result"
            PERF_CACHE_TIMESTAMPS["$cache_key"]="$current_time"
            echo "$result"
        fi
        
        return $exit_code
    else
        echo "❌ Function not found: $command_func" >&2
        return 1
    fi
}

# Clear cache entries older than TTL
_perf_cache_cleanup() {
    local current_time="$(_config_get_timestamp)"
    local default_ttl="${1:-3600}"  # 1 hour default
    
    for key in "${!PERF_CACHE_TIMESTAMPS[@]}"; do
        local cache_time="${PERF_CACHE_TIMESTAMPS[$key]}"
        if [[ $((current_time - cache_time)) -gt $default_ttl ]]; then
            unset PERF_CACHE["$key"]
            unset PERF_CACHE_TIMESTAMPS["$key"]
        fi
    done
}

# ============================================================================
# OPTIMIZED COMMAND FUNCTIONS
# ============================================================================

# Cached git status check
_perf_git_status() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        git status --porcelain
    fi
}

# Cached git branch detection
_perf_git_branch() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        git branch --show-current 2>/dev/null || echo "unknown"
    fi
}

# Cached git repository name
_perf_git_repo_name() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    fi
}

# Cached directory basename
_perf_directory_basename() {
    basename "$(pwd)"
}

# Cached file age calculation
_perf_file_age() {
    local file="$1"
    local current_time="$(_config_get_timestamp)"
    
    if [[ -f "$file" ]]; then
        local file_time
        if command -v stat >/dev/null 2>&1; then
            # Try Linux stat first, then macOS
            file_time=$(stat -c %Y "$file" 2>/dev/null || stat -f %m "$file" 2>/dev/null || echo 0)
        else
            echo 0
            return
        fi
        
        echo $((current_time - file_time))
    else
        echo 999999  # Very old if file doesn't exist
    fi
}

# ============================================================================
# OPTIMIZED SYSTEM INFORMATION
# ============================================================================

# Get system information with caching
_perf_get_system_info() {
    local platform="$(_config_get platform)"
    local arch="$(_config_get arch)"
    local shell="$(_config_get shell)"
    
    echo "$platform $arch ($shell)"
}

# Get startup time
_perf_get_startup_time() {
    _config_get_duration
}

# ============================================================================
# BATCH OPERATIONS
# ============================================================================

# Batch git operations
_perf_git_info_batch() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "not_a_repo||||"
        return
    fi
    
    local branch repo_name status commit_count
    branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")
    status=$(git status --porcelain 2>/dev/null | wc -l)
    commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    
    echo "$branch|$repo_name|$status|$commit_count"
}

# Batch file system operations
_perf_fs_info_batch() {
    local current_dir size file_count
    current_dir=$(basename "$(pwd)")
    size=$(du -sh . 2>/dev/null | cut -f1 || echo "unknown")
    file_count=$(find . -maxdepth 1 -type f 2>/dev/null | wc -l)
    
    echo "$current_dir|$size|$file_count"
}

# ============================================================================
# PERFORMANCE MONITORING
# ============================================================================

# Performance event logging
_perf_log_event() {
    local event="$1"
    local start_time="$2"
    local end_time="${3:-$(_config_get_timestamp)}"
    
    local duration=$((end_time - start_time))
    local time_format="$(_config_get time_format)"
    
    if [[ "$time_format" == "milliseconds" ]]; then
        _secure_perf_log "$event" "${duration}ms"
    else
        _secure_perf_log "$event" "${duration}s"
    fi
}

# Measure function execution time
_perf_measure() {
    local func_name="$1"
    shift
    local args=("$@")
    
    if ! declare -f "$func_name" >/dev/null; then
        echo "❌ Function not found: $func_name" >&2
        return 1
    fi
    
    local start_time="$(_config_get_timestamp)"
    local result
    result=$("$func_name" "${args[@]}")
    local exit_code=$?
    local end_time="$(_config_get_timestamp)"
    
    _perf_log_event "$func_name" "$start_time" "$end_time"
    
    if [[ $exit_code -eq 0 ]]; then
        echo "$result"
    fi
    
    return $exit_code
}

# ============================================================================
# STARTUP OPTIMIZATION
# ============================================================================

# Optimize startup by deferring expensive operations
_perf_defer_operation() {
    local operation="$1"
    local defer_file="$(_config_get home)/cache/deferred_ops"
    
    echo "$operation" >> "$defer_file"
}

# Execute deferred operations
_perf_execute_deferred() {
    local defer_file="$(_config_get home)/cache/deferred_ops"
    
    if [[ -f "$defer_file" ]]; then
        while read -r operation; do
            if [[ -n "$operation" ]]; then
                eval "$operation" 2>/dev/null &
            fi
        done < "$defer_file"
        
        # Clear deferred operations
        rm -f "$defer_file"
    fi
}

# ============================================================================
# MEMORY MANAGEMENT
# ============================================================================

# Clean up performance data
_perf_cleanup() {
    # Clear cache
    _perf_cache_cleanup
    
    # Compress old performance logs
    local perf_log="$(_config_get perf_log)"
    local log_dir="$(dirname "$perf_log")"
    
    if [[ -d "$log_dir" ]]; then
        find "$log_dir" -name "*.log" -mtime +7 -exec gzip {} \; 2>/dev/null
    fi
}

# ============================================================================
# PERFORMANCE TESTING
# ============================================================================

# Benchmark function execution
_perf_benchmark() {
    local func_name="$1"
    local iterations="${2:-5}"
    shift 2
    local args=("$@")
    
    if ! declare -f "$func_name" >/dev/null; then
        echo "❌ Function not found: $func_name" >&2
        return 1
    fi
    
    echo "🔍 Benchmarking $func_name ($iterations iterations)..."
    
    local total_time=0
    local times=()
    
    for ((i=1; i<=iterations; i++)); do
        local start_time="$(_config_get_timestamp)"
        "$func_name" "${args[@]}" >/dev/null 2>&1
        local end_time="$(_config_get_timestamp)"
        local duration=$((end_time - start_time))
        
        times+=("$duration")
        total_time=$((total_time + duration))
    done
    
    local avg_time=$((total_time / iterations))
    local time_format="$(_config_get time_format)"
    local unit="s"
    [[ "$time_format" == "milliseconds" ]] && unit="ms"
    
    echo "📊 Average execution time: ${avg_time}${unit}"
    echo "📈 All times: ${times[*]/%/$unit}"
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export performance functions
export -f _perf_cache_get_or_set
export -f _perf_cache_cleanup
export -f _perf_git_status
export -f _perf_git_branch
export -f _perf_git_repo_name
export -f _perf_directory_basename
export -f _perf_file_age
export -f _perf_get_system_info
export -f _perf_get_startup_time
export -f _perf_git_info_batch
export -f _perf_fs_info_batch
export -f _perf_log_event
export -f _perf_measure
export -f _perf_defer_operation
export -f _perf_execute_deferred
export -f _perf_cleanup
export -f _perf_benchmark