#!/bin/bash
# AI Initialization Compliance Check
# This script verifies that AI assistants have read all required .ai/ files
# Usage: bash scripts/check-ai-init.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════╗${NC}"
echo -e "${BLUE}║  Sonic AI Initialization Compliance      ║${NC}"
echo -e "${BLUE}╚══════════════════════╝${NC}"
echo ""

# Check if .ai/ folder exists
if [ ! -d ".ai" ]; then
    echo -e "${RED}❌ ERROR: .ai/ folder not found!${NC}"
    echo "This project requires the .ai/ knowledge base folder."
    exit 1
fi

# Check critical files
FILES=(
    ".ai/.INIT_REQUIRED"
    ".ai/MUST_READ_FIRST.md"
    ".ai/PROJECT_OVERVIEW.md"
    ".ai/IMPORTANT_NOTES.md"
    ".ai/ISSUES_AND_SOLUTIONS.md"
)

MISSING_FILES=()

echo "Checking required .ai/ files..."
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}✓${NC} $file"
    else
        echo -e "  ${RED}✗${NC} $file (MISSING)"
        MISSING_FILES+=("$file")
    fi
done

echo ""

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo -e "${RED}❌ ERROR: Missing critical files:${NC}"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    exit 1
fi

# Check if .INIT_REQUIRED file exists
if [ ! -f ".ai/.INIT_REQUIRED" ]; then
    echo -e "${RED}❌ CRITICAL: .ai/.INIT_REQUIRED not found!${NC}"
    echo "This file is mandatory for AI initialization."
    exit 1
fi

# Verify all files are not empty
echo ""
echo "Verifying file contents..."
EMPTY_FILES=()

for file in "${FILES[@]}"; do
    if [ -s "$file" ]; then
        SIZE=$(wc -c < "$file")
        echo -e "  ${GREEN}✓${NC} $file ($SIZE bytes)"
    else
        echo -e "  ${RED}✗${NC} $file (EMPTY)"
      EMPTY_FILES+=("$file")
    fi
done

if [ ${#EMPTY_FILES[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️  WARNING: Some files are empty:${NC}"
    for file in "${EMPTY_FILES[@]}"; do
        echo "  - $file"
    done
fi

echo ""
echo -e "${BLUE}══════════════════════${NC}"
echo -e "${GREEN}✅ AI Initialization Compliance Passed!${NC}"
echo ""
echo "For AI Assistants - You MUST read these files in order:"
echo "  1. .ai/.INIT_REQUIRED (this file marks initialization requirement)"
echo "  2. .ai/MUST_READ_FIRST.md (behavioral rules)"
echo "  3. .ai/PROJECT_OVERVIEW.md (project structure)"
echo "  4. .ai/IMPORTANT_NOTES.md (critical information)"
echo "  5. .ai/ISSUES_AND_SOLUTIONS.md (known problems and solutions)"
echo ""
echo "After reading all files, you are ready to work on this project."
echo -e "${BLUE}═════════════${NC}"

exit 0
