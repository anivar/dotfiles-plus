# 🎯 Best Practices Enforcement with Dotfiles Plus

How to use Dotfiles Plus to enforce best practices across different domains for terminal users.

## 📋 Table of Contents

- [Development Best Practices](#-development-best-practices)
- [Security Best Practices](#-security-best-practices)
- [DevOps Best Practices](#-devops-best-practices)
- [Documentation Best Practices](#-documentation-best-practices)
- [Team Collaboration](#-team-collaboration)
- [Custom Domain Practices](#-custom-domain-practices)

---

## 💻 Development Best Practices

### 1. Code Review Habits
```bash
# Before committing, always review with AI
alias pre-commit='ai-review "review my staged changes" && git diff --staged'

# Enforce test-first development
alias new-feature='ai template feature-planning && ai testgen'
```

### 2. Consistent Architecture Decisions
```bash
# Create architecture decision records
ai template feature-planning > docs/ADR-$(date +%Y%m%d).md
ai-arch "what's the best pattern for this use case?"

# Maintain consistency
ai remember --tag architecture "using repository pattern for data access"
ai recall --tag architecture  # Check previous decisions
```

### 3. Debugging Discipline
```bash
# Always document debugging sessions
alias debug-start='ai remember --tag debug "starting debug session: $1"'
alias debug-end='ai remember --tag debug "found issue: $1"'

# Use structured debugging
ai-debug "why is this function returning null?"
```

### 4. Test Coverage Standards
```bash
# Enforce test generation for new code
function safe-commit() {
    ai testgen "$1"
    echo "Have you written/updated tests? (y/n)"
    read response
    [[ "$response" == "y" ]] && git commit -m "$2"
}
```

---

## 🔒 Security Best Practices

### 1. Security-First Code Reviews
```bash
# Always check for security issues
alias sec-check='ai-review "check for security vulnerabilities in:" '

# Remember security decisions
ai remember --tag security "using bcrypt with 12 rounds for passwords"
```

### 2. Credential Management
```bash
# Never commit secrets
function check-secrets() {
    ai-review "check if these files contain any secrets or API keys"
    git diff --staged --name-only | xargs grep -E "(api_key|password|secret|token)" || echo "✅ No obvious secrets found"
}
```

### 3. Dependency Auditing
```bash
# Regular security audits
alias audit-deps='ai "check security vulnerabilities in package.json dependencies"'
alias audit-py='ai "check security issues in requirements.txt"'
```

---

## 🚀 DevOps Best Practices

### 1. Infrastructure as Code Reviews
```bash
# Review infrastructure changes carefully
alias tf-review='ai-arch "review this terraform configuration for best practices"'
alias k8s-review='ai-review "check this kubernetes yaml for security and efficiency"'
```

### 2. Deployment Checklists
```bash
# Maintain deployment procedures
ai template deployment-checklist > deploy/checklist-$(date +%Y%m%d).md
ai remember --tag deployment "production deploy requires 2 approvals"
```

### 3. Incident Management
```bash
# Document incidents immediately
function incident() {
    local severity=$1
    local description=$2
    ai remember --important --tag incident "[$severity] $description"
    ai template bug-report > incidents/$(date +%Y%m%d-%H%M%S).md
}
```

---

## 📚 Documentation Best Practices

### 1. Auto-Documentation
```bash
# Document as you code
alias doc-func='ai "generate documentation for this function"'
alias doc-api='ai "create OpenAPI spec for this endpoint"'
```

### 2. Knowledge Persistence
```bash
# Save important decisions
function decision() {
    ai remember --important --tag decision "$*"
    echo "Decision recorded: $*"
}

# Weekly knowledge dumps
alias weekly-review='ai recall --tag important | tee weekly-$(date +%Y%W).md'
```

### 3. README Maintenance
```bash
# Keep READMEs updated
alias update-readme='ai "update README based on recent changes in this project"'
```

---

## 👥 Team Collaboration

### 1. Shared Context
```bash
# Team memory files
echo "# Team Knowledge Base" > CLAUDE.md
echo "- API conventions: RESTful, versioned endpoints" >> CLAUDE.md
echo "- Testing: Jest for unit, Cypress for E2E" >> CLAUDE.md

# Auto-discover on cd
ai discover  # Loads team knowledge automatically
```

### 2. Code Style Enforcement
```bash
# Consistent code style discussions
ai-review "does this follow our team's coding standards?"
ai remember --tag style "team prefers early returns over nested ifs"
```

### 3. Onboarding New Members
```bash
# Create onboarding docs
ai template onboarding > docs/onboarding.md
ai "create a getting started guide based on this project structure"
```

---

## 🛠 Custom Domain Practices

### 1. Domain-Specific Aliases
```bash
# For web developers
alias comp-review='ai-review "check React component for performance and accessibility"'
alias css-help='ai "suggest CSS for this responsive layout requirement"'

# For data scientists
alias data-review='ai-review "check this data pipeline for efficiency"'
alias ml-explain='ai "explain this machine learning model's approach"'

# For system administrators
alias script-review='ai-review "check this bash script for safety and efficiency"'
alias troubleshoot='ai-debug "diagnose this system issue:"'
```

### 2. Workflow Automation
```bash
# Enforce PR workflow
function create-pr() {
    # Run checks
    ai-review "review all changes"
    check-secrets
    ai testgen "changed files"
    
    # Create PR with template
    gh pr create --template .github/pull_request_template.md
}
```

### 3. Learning Patterns
```bash
# Track what you're learning
alias til='ai remember --tag learning "today I learned: $*"'
alias learning-review='ai recall --tag learning'

# Get explanations
alias explain='ai "explain this concept in simple terms:"'
```

---

## 🔧 Implementation Tips

### 1. Add to Your Shell RC
```bash
# ~/.bashrc or ~/.zshrc
source ~/dotfiles-plus/dotfiles-plus.sh

# Your domain-specific aliases
source ~/my-practices.sh
```

### 2. Create Team Standards File
```bash
# team-standards.sh
# Source this in your shell RC

# Enforce commit message format
function commit-msg() {
    echo "$1" | ai "format as conventional commit message"
}

# Require documentation
alias new-function='echo "Write function docs first!" && ai template function-doc'
```

### 3. Use Freeze Points for Complex Tasks
```bash
# Save state before major changes
ai freeze "before-refactor"

# Work on refactoring...

# Can always go back
ai thaw "before-refactor"
```

### 4. Regular Reviews
```bash
# Weekly codebase health check
function weekly-health() {
    echo "=== Weekly Health Check ===" 
    ai stats
    ai recall --important
    ai-review "what are the main code quality issues to address?"
}
```

---

## 🎓 Training Your AI Context

The more you use the memory system, the better your AI assistant becomes at understanding your specific domain:

```bash
# Build domain knowledge
ai remember "our API always returns JSON with {data, error, meta} structure"
ai remember "we use feature flags for all new functionality"
ai remember "performance budget: <3s page load, <100ms API response"

# Your AI now knows your standards
ai "implement user endpoint"  # Will follow your patterns
```

---

## 🚦 Getting Started

1. **Pick your domain** from the examples above
2. **Create your practices file** with relevant aliases and functions
3. **Share with your team** via git repository
4. **Iterate and improve** based on what works

Remember: Best practices are most effective when they're easy to follow. Dotfiles Plus makes them part of your natural workflow.