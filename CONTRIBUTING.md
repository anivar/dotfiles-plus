# Contributing to Dotfiles Plus

Thank you for your interest in contributing to Dotfiles Plus! This document provides guidelines and information for contributors.

## 🎯 Project Vision

Dotfiles Plus aims to be the most secure, intelligent, and developer-friendly dotfiles management system. We prioritize:

1. **Security First** - All contributions must maintain our security standards
2. **Developer Experience** - Features should enhance productivity
3. **Reliability** - Code must be tested and stable
4. **Performance** - Optimizations are always welcome

## 🚀 Quick Start for Contributors

### Development Setup
```bash
# Clone and setup
git clone https://github.com/anivar/dotfiles-plus.git
cd dotfiles-plus

# Test your setup
./tests/test-suite.sh

# Make your changes
# ... edit files ...

# Test your changes
./tests/test-suite.sh
```

### Code Standards
- **Security**: All user input must be sanitized
- **No eval()**: Use secure alternatives to dynamic execution
- **Error Handling**: Comprehensive error checking
- **Shell Compatibility**: Support bash 3.2+ and zsh
- **Performance**: Consider lazy loading and caching

## 🔒 Security Requirements

### Input Validation
All functions that accept user input must use our security framework:

```bash
# Good - secure input handling
_secure_sanitize_input "$user_input"
_secure_validate_input "$command" "^[a-zA-Z0-9_-]+$"

# Bad - direct execution of user input
eval "$user_input"  # NEVER DO THIS
```

### Command Execution
Use our secure execution framework:

```bash
# Good - secure command execution
_secure_execute_command "git" "status" "--porcelain"

# Bad - shell injection vulnerable
git $user_args  # VULNERABLE
```

## 🧪 Testing Guidelines

### Required Tests
All contributions must include tests:

```bash
# Add tests to tests/test-suite.sh
test_your_new_feature() {
    echo "Testing your feature..."
    
    # Test success case
    result=$(your_function "valid_input")
    assert_equals "expected" "$result" "Feature works correctly"
    
    # Test security
    your_function "malicious;input" >/dev/null 2>&1
    assert_failure $? "Malicious input rejected"
}
```

### Test Categories
- **Security Tests** - Input sanitization and validation
- **Functionality Tests** - Feature works as expected
- **Integration Tests** - Works with other components
- **Performance Tests** - No significant performance degradation

## 📝 Documentation Standards

### Code Documentation
```bash
# Document all functions
# Description: What the function does
# Arguments: $1 - description, $2 - description
# Returns: What it returns
# Example: usage example
your_function() {
    local arg1="$1"
    local arg2="$2"
    # Implementation
}
```

### User Documentation
- Update README.md for user-facing features
- Add examples to FEATURES.md
- Update CHANGELOG.md for all changes

## 🎨 Code Style

### Shell Script Style
```bash
# Use consistent formatting
function_name() {
    local variable="value"
    
    if [[ condition ]]; then
        command
    fi
    
    return 0
}

# Variable naming
local_variable="value"
GLOBAL_CONSTANT="VALUE"
```

### Git Commit Style
```bash
# Format: type(scope): description
feat(ai): add support for new AI provider
fix(security): improve input sanitization 
docs(readme): update installation instructions
test(core): add tests for configuration system
```

## 🌟 Contribution Types

### 🐛 Bug Fixes
- Include reproduction steps
- Add regression tests
- Verify security implications

### ✨ New Features  
- Discuss in issues first
- Follow security guidelines
- Include comprehensive tests
- Update documentation

### 📚 Documentation
- Improve clarity and examples
- Fix typos and formatting
- Add missing information

### 🔒 Security Improvements
- Follow responsible disclosure
- Include security impact analysis
- Add tests for security fixes

## 🔄 Pull Request Process

### Before Submitting
1. **Test Thoroughly**
   ```bash
   ./tests/test-suite.sh
   ```

2. **Check Security**
   ```bash
   # Verify no new security issues
   grep -r "eval" . --include="*.sh"  # Should find none
   ```

3. **Update Documentation**
   - README.md (if user-facing)
   - FEATURES.md (if new feature)
   - CHANGELOG.md (always)

### PR Guidelines
- **Clear Title**: Describe what the PR does
- **Detailed Description**: Explain the changes and why
- **Testing**: Describe how you tested the changes
- **Breaking Changes**: Clearly mark any breaking changes

### Review Process
1. **Automated Checks** - Tests must pass
2. **Security Review** - Security implications assessed
3. **Code Review** - Code quality and style
4. **Documentation Review** - Documentation completeness

## 🎯 Specific Areas for Contribution

### High Priority
- **Additional AI Providers** - Support for more AI services
- **Performance Optimizations** - Faster loading and execution
- **Security Enhancements** - Additional security measures
- **Platform Support** - Windows/WSL improvements

### Medium Priority
- **Plugin System** - Extensible architecture
- **Themes and Customization** - Visual customization options
- **Team Features** - Multi-user and team workflows
- **Advanced Git Integration** - More git workflow enhancements

### Documentation Needs
- **Video Tutorials** - Installation and usage guides
- **Migration Guides** - More detailed migration documentation
- **Best Practices** - Developer workflow recommendations
- **Troubleshooting** - Common issues and solutions

## 🚨 Security Reporting

### Reporting Security Issues
**DO NOT** create public issues for security vulnerabilities.

Instead:
1. Email: security@[domain] (replace with actual)
2. Include: Detailed description and reproduction steps
3. Wait: For acknowledgment before public disclosure

### Security Review Process
All security-related contributions go through enhanced review:
1. **Static Analysis** - Automated security scanning
2. **Manual Review** - Security expert review
3. **Penetration Testing** - Active security testing
4. **Documentation** - Security impact documentation

## 🏆 Recognition

### Contributors
All contributors are recognized in:
- README.md contributors section
- Release notes for their contributions
- Project documentation

### Maintainer Path
Regular contributors may be invited to become maintainers:
- Consistent quality contributions
- Security-aware development
- Community engagement
- Documentation contributions

## 📞 Getting Help

### Community Channels
- **GitHub Issues** - Bug reports and feature requests
- **GitHub Discussions** - General questions and ideas
- **Documentation** - Built-in help system

### Maintainer Contact
For complex contributions or questions:
- Create a draft PR with questions
- Tag maintainers in issues
- Use GitHub discussions for design questions

## 🙏 Code of Conduct

### Our Standards
- **Respectful** - Treat all contributors with respect
- **Inclusive** - Welcome diverse perspectives
- **Constructive** - Provide helpful feedback
- **Professional** - Maintain professional standards

### Enforcement
Violations of our standards will be addressed through:
1. **Warning** - First violations get a warning
2. **Temporary Ban** - Repeated violations result in temporary ban
3. **Permanent Ban** - Severe violations result in permanent ban

## 📄 License

By contributing to Dotfiles Plus, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Dotfiles Plus!**

Your contributions help make terminal environments more secure, intelligent, and productive for developers worldwide.