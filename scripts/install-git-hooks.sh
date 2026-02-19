#!/bin/bash
# Install git hooks to enforce .ai/ knowledge base updates
# Usage: bash scripts/install-git-hooks.sh

set -e

HOOKS_DIR=".git/hooks"
HOOK_FILE="$HOOKS_DIR/pre-commit"

echo "Installing git hooks for Sonic project..."

# Create pre-commit hook
mkdir -p "$HOOKS_DIR"

cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash
# Pre-commit hook: Enforce .ai/ knowledge base updates
# Ensures that code changes are accompanied by knowledge base updates

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get staged files
STAGED_FILES=$(git diff --cached --name-only)

# Separate code files from .ai files
CODE_FILES=$(echo "$STAGED_FILES" | grep -E '\.(go|yaml|yml|mod|sum|java|py|ts|js)$' || true)
AI_FILES=$(echo "$STAGED_FILES" | grep '^\.ai/' || true)

# If code is modified but .ai/ is not, require user confirmation
if [ -n "$CODE_FILES" ] && [ -z "$AI_FILES" ]; then
    echo -e "${RED}⚠️  WARNING: Code modified but .ai/ knowledge base not updated!${NC}"
    echo ""
    echo "Code files being committed:"
    echo "$CODE_FILES" | sed 's/^/  ✗ /'
    echo ""
    echo "Missing .ai/ updates! According to project rules:"
    echo "  • Update .ai/ISSUES_AND_SOLUTIONS.md"
    echo "  • Update .ai/IMPORTANT_NOTES.md (if needed)"
    echo "  • Stage changes: git add .ai/"
    echo ""
    echo -e "${YELLOW}Proceed without .ai/ updates? (y/N)${NC}"
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${RED}Commit cancelled. Please update .ai/ files first.${NC}"
        exit 1
    fi
fi

# Prevent deletion of critical .ai/ files
if git diff --cached --diff-filter=D --name-only | grep -q '\.ai/\.INIT_REQUIRED'; then
    echo -e "${RED}❌ ERROR: Cannot delete .ai/.INIT_REQUIRED!${NC}"
    echo "This file is mandatory for AI initialization."
    exit 1
fi

if git diff --cached --diff-filter=D --name-only | grep -q '\.ai/MUST_READ_FIRST.md'; then
    echo -e "${RED}❌ ERROR: Cannot delete .ai/MUST_READ_FIRST.md!${NC}"
    echo "This file documents critical project conventions."
    exit 1
fi

echo -e "${GREEN}✓ Pre-commit check passed${NC}"
exit 0
EOF

chmod +x "$HOOK_FILE"

echo -e "✅ Git hook installed: $HOOK_FILE"
echo "   The hook will warn when code is modified without .ai/ updates"
echo ""
echo "To uninstall, run: rm $HOOK_FILE"
