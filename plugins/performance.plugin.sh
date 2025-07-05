#!/usr/bin/env bash
# Performance Plugin - Optimization and monitoring

# ============================================================================
# PERFORMANCE MONITORING
# ============================================================================

# Command timing
DOTFILES_PERF_START=""

# Start timing
perf_start() {
    DOTFILES_PERF_START=$(date +%s.%N 2>/dev/null || date +%s)
}

# End timing and report
perf_end() {
    local label="${1:-Command}"
    local end=$(date +%s.%N 2>/dev/null || date +%s)
    
    if [[ -n "$DOTFILES_PERF_START" ]]; then
        local duration=$(echo "$end - $DOTFILES_PERF_START" | bc -l 2>/dev/null || echo "0")
        echo "⏱️  $label took ${duration:0:5}s"
    fi
}

# Profile command execution
profile() {
    local cmd="$@"
    
    echo "📊 Profiling: $cmd"
    echo "━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Memory before
    local mem_before=$(ps -o rss= -p $$ | tr -d ' ')
    
    # Time execution
    local start=$(date +%s.%N 2>/dev/null || date +%s)
    eval "$cmd"
    local exit_code=$?
    local end=$(date +%s.%N 2>/dev/null || date +%s)
    
    # Memory after
    local mem_after=$(ps -o rss= -p $$ | tr -d ' ')
    
    # Calculate
    local duration=$(echo "$end - $start" | bc -l 2>/dev/null || echo "0")
    local mem_used=$((mem_after - mem_before))
    
    echo ""
    echo "📊 Results:"
    echo "  Time:     ${duration:0:5}s"
    echo "  Memory:   ${mem_used}KB"
    echo "  Exit:     $exit_code"
    
    return $exit_code
}

# ============================================================================
# CACHE MANAGEMENT
# ============================================================================

# Enhanced cache with TTL
cache() {
    local cmd="${1:-help}"
    shift
    
    case "$cmd" in
        get)
            local key="$1"
            cache_get "$key" "${2:-3600}"
            ;;
            
        set)
            local key="$1"
            local value="$2"
            cache_set "$key" "$value"
            ;;
            
        clear)
            cache_clear
            log success "Cache cleared"
            ;;
            
        stats)
            local cache_dir="$DOTFILES_HOME/cache"
            if [[ -d "$cache_dir" ]]; then
                local count=$(find "$cache_dir" -type f | wc -l)
                local size=$(du -sh "$cache_dir" 2>/dev/null | cut -f1)
                echo "📊 Cache Statistics"
                echo "━━━━━━━━━━━━━━━━"
                echo "Items: $count"
                echo "Size:  $size"
            else
                echo "No cache data"
            fi
            ;;
            
        gc)
            # Garbage collect old cache entries
            local ttl="${1:-3600}"
            local cache_dir="$DOTFILES_HOME/cache"
            local cleaned=0
            
            if [[ -d "$cache_dir" ]]; then
                echo "🗑️  Cleaning cache (TTL: ${ttl}s)..."
                
                find "$cache_dir" -type f -mtime +$(($ttl/86400))d -delete 2>/dev/null
                cleaned=$?
                
                log success "Cache cleaned"
            fi
            ;;
            
        help|*)
            echo "💾 Cache Commands:"
            echo "  cache get <key> [ttl]  # Get cached value"
            echo "  cache set <key> <val>  # Set cache value"
            echo "  cache clear            # Clear all cache"
            echo "  cache stats            # Show statistics"
            echo "  cache gc [ttl]         # Garbage collect"
            ;;
    esac
}

# ============================================================================
# LAZY LOADING
# ============================================================================

# Lazy load expensive functions
lazy_load() {
    local func_name="$1"
    local file_path="$2"
    
    # Create wrapper function
    eval "
    $func_name() {
        # Load the real implementation
        if [[ -f \"$file_path\" ]]; then
            source \"$file_path\"
            
            # Call the real function
            if command_exists \"$func_name\"; then
                \"$func_name\" \"\$@\"
            else
                log error \"Failed to load $func_name\"
                return 1
            fi
        else
            log error \"Cannot find $file_path\"
            return 1
        fi
    }
    "
}

# ============================================================================
# RESOURCE LIMITS
# ============================================================================

# Set resource limits for commands
with_limits() {
    local memory="${DOTFILES_MAX_MEMORY:-512M}"
    local cpu="${DOTFILES_MAX_CPU:-50}"
    local time="${DOTFILES_MAX_TIME:-30}"
    
    # Parse options
    while [[ "$1" =~ ^- ]]; do
        case "$1" in
            -m|--memory) memory="$2"; shift 2 ;;
            -c|--cpu) cpu="$2"; shift 2 ;;
            -t|--time) time="$2"; shift 2 ;;
            *) break ;;
        esac
    done
    
    local cmd="$@"
    
    # Apply limits based on platform
    if command_exists timeout; then
        timeout "$time" "$@"
    else
        "$@"
    fi
}

# ============================================================================
# OPTIMIZATION HELPERS
# ============================================================================

# Optimize shell startup
optimize_startup() {
    echo "🚀 Optimizing shell startup..."
    echo ""
    
    local start=$(date +%s.%N 2>/dev/null || date +%s)
    
    # Measure current startup
    local shell_cmd="$SHELL -c 'source $DOTFILES_ROOT/dotfiles.sh && exit'"
    local startup_time=$(time -p eval "$shell_cmd" 2>&1 | grep real | awk '{print $2}')
    
    echo "Current startup time: ${startup_time}s"
    echo ""
    
    # Analyze slow parts
    echo "Analyzing components..."
    
    # Check plugin load times
    for plugin in "$DOTFILES_HOME/plugins/"*.plugin.sh; do
        [[ -f "$plugin" ]] || continue
        local plugin_name=$(basename "$plugin")
        
        local plugin_start=$(date +%s.%N 2>/dev/null || date +%s)
        source "$plugin" 2>/dev/null
        local plugin_end=$(date +%s.%N 2>/dev/null || date +%s)
        
        local plugin_time=$(echo "$plugin_end - $plugin_start" | bc -l 2>/dev/null || echo "0")
        echo "  $plugin_name: ${plugin_time:0:5}s"
    done
    
    echo ""
    echo "💡 Optimization suggestions:"
    
    # Suggestions based on findings
    if (( $(echo "$startup_time > 0.5" | bc -l) )); then
        echo "  • Enable lazy loading for heavy plugins"
        echo "  • Use 'dotfiles config lazy_load true'"
    fi
    
    echo "  • Disable unused plugins"
    echo "  • Clear old cache: cache gc"
}

# Benchmark commands
benchmark() {
    local iterations="${1:-10}"
    shift
    local cmd="$@"
    
    echo "📊 Benchmarking: $cmd"
    echo "Iterations: $iterations"
    echo "━━━━━━━━━━━━━━━━━━━━━"
    
    local total=0
    local min=999999
    local max=0
    
    for i in $(seq 1 "$iterations"); do
        local start=$(date +%s.%N 2>/dev/null || date +%s)
        eval "$cmd" >/dev/null 2>&1
        local end=$(date +%s.%N 2>/dev/null || date +%s)
        
        local duration=$(echo "$end - $start" | bc -l 2>/dev/null || echo "0")
        total=$(echo "$total + $duration" | bc -l)
        
        # Update min/max
        if (( $(echo "$duration < $min" | bc -l) )); then
            min=$duration
        fi
        if (( $(echo "$duration > $max" | bc -l) )); then
            max=$duration
        fi
        
        echo -n "."
    done
    echo ""
    
    local avg=$(echo "$total / $iterations" | bc -l)
    
    echo ""
    echo "Results:"
    echo "  Average: ${avg:0:5}s"
    echo "  Min:     ${min:0:5}s"
    echo "  Max:     ${max:0:5}s"
}

# ============================================================================
# ASYNC OPERATIONS
# ============================================================================

# Run command asynchronously
async() {
    local cmd="$@"
    local job_id="job_$(date +%s)_$$"
    local job_file="$DOTFILES_HOME/jobs/$job_id"
    
    ensure_dir "$(dirname "$job_file")"
    
    # Start job in background
    {
        echo "running" > "$job_file.status"
        echo "$cmd" > "$job_file.cmd"
        
        # Execute command
        if eval "$cmd" > "$job_file.out" 2> "$job_file.err"; then
            echo "success" > "$job_file.status"
        else
            echo "failed" > "$job_file.status"
        fi
    } &
    
    local pid=$!
    echo "$pid" > "$job_file.pid"
    
    echo "🚀 Started job: $job_id (PID: $pid)"
    echo "   Check status: jobs status $job_id"
}

# Job management
jobs() {
    local cmd="${1:-list}"
    shift
    
    case "$cmd" in
        list)
            echo "📋 Active Jobs"
            echo "━━━━━━━━━━━━━"
            
            local job_dir="$DOTFILES_HOME/jobs"
            if [[ -d "$job_dir" ]]; then
                for job_file in "$job_dir"/job_*.status; do
                    [[ -f "$job_file" ]] || continue
                    
                    local job_id=$(basename "$job_file" .status)
                    local status=$(cat "$job_file")
                    local cmd=$(cat "${job_file%.status}.cmd" 2>/dev/null)
                    
                    echo "$job_id: $status - ${cmd:0:50}..."
                done
            else
                echo "No active jobs"
            fi
            ;;
            
        status)
            local job_id="$1"
            local job_file="$DOTFILES_HOME/jobs/$job_id"
            
            if [[ -f "$job_file.status" ]]; then
                local status=$(cat "$job_file.status")
                echo "Job $job_id: $status"
                
                if [[ "$status" != "running" ]]; then
                    echo ""
                    echo "Output:"
                    cat "$job_file.out" 2>/dev/null
                    
                    if [[ -s "$job_file.err" ]]; then
                        echo ""
                        echo "Errors:"
                        cat "$job_file.err"
                    fi
                fi
            else
                echo "Job not found: $job_id"
            fi
            ;;
            
        clean)
            local job_dir="$DOTFILES_HOME/jobs"
            local cleaned=0
            
            if [[ -d "$job_dir" ]]; then
                for job_file in "$job_dir"/job_*.status; do
                    [[ -f "$job_file" ]] || continue
                    
                    local status=$(cat "$job_file")
                    if [[ "$status" != "running" ]]; then
                        local job_id=$(basename "$job_file" .status)
                        rm -f "$job_dir/$job_id".*
                        ((cleaned++))
                    fi
                done
            fi
            
            log success "Cleaned $cleaned completed jobs"
            ;;
    esac
}

# ============================================================================
# PERFORMANCE HOOKS
# ============================================================================

# Track slow commands
perf_track_command() {
    local cmd="$1"
    local threshold="${DOTFILES_PERF_THRESHOLD:-1.0}"
    
    local start=$(date +%s.%N 2>/dev/null || date +%s)
    
    # Let command execute
    return 0
}

perf_track_result() {
    local cmd="$1"
    local exit_code="$2"
    
    if [[ -n "$start" ]]; then
        local end=$(date +%s.%N 2>/dev/null || date +%s)
        local duration=$(echo "$end - $start" | bc -l 2>/dev/null || echo "0")
        
        # Log slow commands
        if (( $(echo "$duration > $threshold" | bc -l) )); then
            echo "[$(timestamp)] SLOW: ${duration}s - $cmd" >> "$DOTFILES_HOME/logs/slow-commands.log"
        fi
    fi
}

# ============================================================================
# REGISTRATION
# ============================================================================

# Register commands
command_register "profile" "profile" "Profile command execution"
command_register "benchmark" "benchmark" "Benchmark commands"
command_register "cache" "cache" "Cache management"
command_register "optimize" "optimize_startup" "Optimize shell startup"
command_register "async" "async" "Run command asynchronously"
command_register "jobs" "jobs" "Manage async jobs"
command_register "limits" "with_limits" "Run with resource limits"

# Register performance tracking hooks
hook_register "pre_command" "perf_track_command" 5
hook_register "post_command" "perf_track_result" 95

# Enable performance mode if requested
if [[ "${DOTFILES_PERF_MODE:-}" == "true" ]]; then
    export PS4='+ $(date "+%s.%N") ${BASH_SOURCE}:${LINENO}: '
    set -x
fi