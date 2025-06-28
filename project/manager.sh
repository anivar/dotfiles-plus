#!/usr/bin/env bash
# 📂 Project Management Module
# Smart project detection and configuration

# ============================================================================
# PROJECT DETECTION
# ============================================================================

# Detect project type based on files and structure
project_detect() {
    local project_type="unknown"
    local confidence=0
    local details=""
    
    # Node.js projects
    if [[ -f "package.json" ]]; then
        project_type="nodejs"
        confidence=95
        local framework
        framework=$(project_detect_nodejs_framework)
        details="Framework: $framework"
        
    # Python projects
    elif [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]]; then
        project_type="python"
        confidence=90
        local framework
        framework=$(project_detect_python_framework)
        details="Framework: $framework"
        
    # Rust projects
    elif [[ -f "Cargo.toml" ]]; then
        project_type="rust"
        confidence=95
        details="Rust project with Cargo"
        
    # Go projects
    elif [[ -f "go.mod" ]]; then
        project_type="go"
        confidence=95
        details="Go module project"
        
    # Java projects
    elif [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]]; then
        project_type="java"
        confidence=90
        if [[ -f "pom.xml" ]]; then
            details="Maven project"
        else
            details="Gradle project"
        fi
        
    # PHP projects
    elif [[ -f "composer.json" ]]; then
        project_type="php"
        confidence=90
        details="Composer project"
        
    # Ruby projects
    elif [[ -f "Gemfile" ]] || [[ -f "*.gemspec" ]]; then
        project_type="ruby"
        confidence=85
        details="Ruby project with Bundler"
        
    # Docker projects
    elif [[ -f "Dockerfile" ]] || [[ -f "docker-compose.yml" ]]; then
        project_type="docker"
        confidence=80
        details="Containerized project"
        
    # Generic git repository
    elif [[ -d ".git" ]]; then
        project_type="git"
        confidence=60
        details="Generic git repository"
    fi
    
    echo "$project_type|$confidence|$details"
}

# Detect Node.js framework
project_detect_nodejs_framework() {
    if [[ -f "package.json" ]]; then
        # Check for common frameworks in dependencies
        if grep -q '"react"' package.json; then
            echo "React"
        elif grep -q '"vue"' package.json; then
            echo "Vue.js"
        elif grep -q '"angular"' package.json; then
            echo "Angular"
        elif grep -q '"express"' package.json; then
            echo "Express.js"
        elif grep -q '"next"' package.json; then
            echo "Next.js"
        elif grep -q '"nuxt"' package.json; then
            echo "Nuxt.js"
        elif grep -q '"gatsby"' package.json; then
            echo "Gatsby"
        else
            echo "Node.js"
        fi
    else
        echo "Unknown"
    fi
}

# Detect Python framework
project_detect_python_framework() {
    # Check requirements.txt
    if [[ -f "requirements.txt" ]]; then
        if grep -q "django" requirements.txt; then
            echo "Django"
        elif grep -q "flask" requirements.txt; then
            echo "Flask"
        elif grep -q "fastapi" requirements.txt; then
            echo "FastAPI"
        elif grep -q "tornado" requirements.txt; then
            echo "Tornado"
        else
            echo "Python"
        fi
    # Check for Django manage.py
    elif [[ -f "manage.py" ]]; then
        echo "Django"
    # Check pyproject.toml
    elif [[ -f "pyproject.toml" ]]; then
        if grep -q "fastapi" pyproject.toml; then
            echo "FastAPI"
        elif grep -q "django" pyproject.toml; then
            echo "Django"
        else
            echo "Python"
        fi
    else
        echo "Python"
    fi
}

# ============================================================================
# PROJECT CONFIGURATION
# ============================================================================

# Initialize project configuration
project_init() {
    local project_name="${1:-$(basename "$(pwd)")}"
    
    # Validate project name
    local safe_name
    safe_name=$(_secure_validate_input "$project_name" "^[a-zA-Z0-9_.-]+$")
    if [[ $? -ne 0 ]]; then
        echo "❌ Invalid project name: $project_name" >&2
        return 1
    fi
    
    echo "🚀 Initializing project: $safe_name"
    
    # Detect project details
    local detection_result
    detection_result=$(project_detect)
    IFS='|' read -r project_type confidence details <<< "$detection_result"
    
    echo "📊 Detection: $project_type ($confidence% confidence)"
    [[ -n "$details" ]] && echo "📋 Details: $details"
    
    # Create project configuration
    local project_config="$(_config_get home)/projects/${safe_name}.project"
    mkdir -p "$(dirname "$project_config")"
    
    cat > "$project_config" << EOF
# Project Configuration: $safe_name
# Generated: $(date)

[project]
name=$safe_name
type=$project_type
confidence=$confidence
details=$details
path=$(pwd)
created=$(date +%s)

[detection]
framework=$(_project_get_framework_for_type "$project_type")
package_manager=$(_project_get_package_manager_for_type "$project_type")
build_command=$(_project_get_build_command_for_type "$project_type")
test_command=$(_project_get_test_command_for_type "$project_type")
dev_command=$(_project_get_dev_command_for_type "$project_type")

[aliases]
build=project build
test=project test
dev=project dev
install=project install
EOF
    
    echo "✅ Project configuration saved: $project_config"
    
    # Auto-setup based on project type
    project_auto_setup "$project_type"
}

# Get framework for project type
_project_get_framework_for_type() {
    local project_type="$1"
    
    case "$project_type" in
        nodejs) project_detect_nodejs_framework ;;
        python) project_detect_python_framework ;;
        *) echo "$project_type" ;;
    esac
}

# Get package manager for project type
_project_get_package_manager_for_type() {
    local project_type="$1"
    
    case "$project_type" in
        nodejs)
            if [[ -f "yarn.lock" ]]; then echo "yarn"
            elif [[ -f "pnpm-lock.yaml" ]]; then echo "pnpm"
            else echo "npm"; fi
            ;;
        python)
            if [[ -f "poetry.lock" ]]; then echo "poetry"
            elif [[ -f "Pipfile" ]]; then echo "pipenv"
            else echo "pip"; fi
            ;;
        rust) echo "cargo" ;;
        go) echo "go" ;;
        java)
            if [[ -f "pom.xml" ]]; then echo "maven"
            else echo "gradle"; fi
            ;;
        php) echo "composer" ;;
        ruby) echo "bundle" ;;
        *) echo "unknown" ;;
    esac
}

# Get build command for project type
_project_get_build_command_for_type() {
    local project_type="$1"
    
    case "$project_type" in
        nodejs) echo "npm run build" ;;
        python) echo "python setup.py build" ;;
        rust) echo "cargo build" ;;
        go) echo "go build" ;;
        java)
            if [[ -f "pom.xml" ]]; then echo "mvn compile"
            else echo "gradle build"; fi
            ;;
        *) echo "" ;;
    esac
}

# Get test command for project type
_project_get_test_command_for_type() {
    local project_type="$1"
    
    case "$project_type" in
        nodejs) echo "npm test" ;;
        python) echo "python -m pytest" ;;
        rust) echo "cargo test" ;;
        go) echo "go test" ;;
        java)
            if [[ -f "pom.xml" ]]; then echo "mvn test"
            else echo "gradle test"; fi
            ;;
        *) echo "" ;;
    esac
}

# Get dev command for project type
_project_get_dev_command_for_type() {
    local project_type="$1"
    
    case "$project_type" in
        nodejs) echo "npm run dev" ;;
        python) echo "python manage.py runserver" ;;
        rust) echo "cargo run" ;;
        go) echo "go run ." ;;
        *) echo "" ;;
    esac
}

# ============================================================================
# PROJECT OPERATIONS
# ============================================================================

# Execute project command
project_exec() {
    local command="$1"
    shift
    local args=("$@")
    
    # Get current project configuration
    local project_config
    project_config=$(project_get_current_config)
    if [[ $? -ne 0 ]]; then
        echo "❌ No project configuration found. Run 'project init' first." >&2
        return 1
    fi
    
    # Read project configuration
    local project_type package_manager
    project_type=$(project_config_get "$project_config" "project" "type")
    package_manager=$(project_config_get "$project_config" "detection" "package_manager")
    
    case "$command" in
        build)
            local build_cmd
            build_cmd=$(project_config_get "$project_config" "detection" "build_command")
            [[ -n "$build_cmd" ]] && _secure_execute_command $build_cmd || echo "❌ No build command configured"
            ;;
        test)
            local test_cmd
            test_cmd=$(project_config_get "$project_config" "detection" "test_command")
            [[ -n "$test_cmd" ]] && _secure_execute_command $test_cmd || echo "❌ No test command configured"
            ;;
        dev)
            local dev_cmd
            dev_cmd=$(project_config_get "$project_config" "detection" "dev_command")
            [[ -n "$dev_cmd" ]] && _secure_execute_command $dev_cmd || echo "❌ No dev command configured"
            ;;
        install)
            project_install_dependencies "$project_type" "$package_manager"
            ;;
        *)
            echo "❌ Unknown project command: $command" >&2
            echo "Available commands: build, test, dev, install" >&2
            return 1
            ;;
    esac
}

# Install project dependencies
project_install_dependencies() {
    local project_type="$1"
    local package_manager="$2"
    
    echo "📦 Installing dependencies using $package_manager..."
    
    case "$package_manager" in
        npm) npm install ;;
        yarn) yarn install ;;
        pnpm) pnpm install ;;
        pip) pip install -r requirements.txt ;;
        poetry) poetry install ;;
        pipenv) pipenv install ;;
        cargo) cargo build ;;
        go) go mod download ;;
        maven) mvn install ;;
        gradle) gradle build ;;
        composer) composer install ;;
        bundle) bundle install ;;
        *) echo "❌ Unknown package manager: $package_manager" ;;
    esac
}

# ============================================================================
# PROJECT CONFIGURATION UTILITIES
# ============================================================================

# Get current project configuration file
project_get_current_config() {
    local project_name="$(basename "$(pwd)")"
    local project_config="$(_config_get home)/projects/${project_name}.project"
    
    if [[ -f "$project_config" ]]; then
        echo "$project_config"
    else
        return 1
    fi
}

# Read project configuration value
project_config_get() {
    local config_file="$1"
    local section="$2"
    local key="$3"
    
    awk -F= -v section="[$section]" -v key="$key" '
        $0 == section { in_section = 1; next }
        /^\[/ { in_section = 0; next }
        in_section && $1 == key { print $2; exit }
    ' "$config_file"
}

# Auto-setup project based on type
project_auto_setup() {
    local project_type="$1"
    
    case "$project_type" in
        nodejs)
            echo "🔧 Setting up Node.js project..."
            # Create common directories if they don't exist
            [[ ! -d "src" ]] && mkdir -p src
            [[ ! -d "test" ]] && mkdir -p test
            ;;
        python)
            echo "🔧 Setting up Python project..."
            [[ ! -d "tests" ]] && mkdir -p tests
            [[ ! -f ".gitignore" ]] && echo "__pycache__/\n*.pyc\n.pytest_cache/" > .gitignore
            ;;
        rust)
            echo "🔧 Setting up Rust project..."
            # Cargo handles most setup
            ;;
        *)
            echo "✅ Basic project setup complete"
            ;;
    esac
}

# ============================================================================
# PROJECT LISTING AND MANAGEMENT
# ============================================================================

# List all projects
project_list() {
    local projects_dir="$(_config_get home)/projects"
    
    if [[ ! -d "$projects_dir" ]]; then
        echo "No projects configured yet."
        return
    fi
    
    echo "📂 Configured Projects:"
    
    for project_file in "$projects_dir"/*.project; do
        [[ ! -f "$project_file" ]] && continue
        
        local project_name="${project_file##*/}"
        project_name="${project_name%.project}"
        
        local project_type
        project_type=$(project_config_get "$project_file" "project" "type")
        
        local project_path
        project_path=$(project_config_get "$project_file" "project" "path")
        
        echo "  📝 $project_name ($project_type) -> $project_path"
    done
}

# Show current project information
project_current() {
    local project_config
    project_config=$(project_get_current_config)
    
    if [[ $? -ne 0 ]]; then
        echo "❌ No project configuration found for current directory"
        echo "💡 Run 'project init' to configure this project"
        return 1
    fi
    
    echo "📊 Current Project Information:"
    echo "  Name: $(project_config_get "$project_config" "project" "name")"
    echo "  Type: $(project_config_get "$project_config" "project" "type")"
    echo "  Framework: $(project_config_get "$project_config" "detection" "framework")"
    echo "  Package Manager: $(project_config_get "$project_config" "detection" "package_manager")"
    echo "  Path: $(project_config_get "$project_config" "project" "path")"
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export project functions
export -f project_detect
export -f project_init
export -f project_exec
export -f project_list
export -f project_current