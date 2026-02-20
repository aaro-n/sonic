# 🤖 AI Assistant Knowledge Base

**⚠️ IMPORTANT: Any AI assistant working on this project MUST read this file and the .ai folder contents before making ANY changes.**

## Quick Start for AI Assistants

### First Thing: Read These Files IN ORDER

1. **[.ai/README.md](.ai/README.md)** - Understand the .ai system
2. **[.ai/PROJECT_OVERVIEW.md](.ai/PROJECT_OVERVIEW.md)** - Learn project structure
3. **[.ai/ISSUES_AND_SOLUTIONS.md](.ai/ISSUES_AND_SOLUTIONS.md)** - Know about past problems
4. **[.ai/IMPORTANT_NOTES.md](.ai/IMPORTANT_NOTES.md)** - Check critical information

**Reading these 4 files should take 5-10 minutes and will save hours of debugging!**

---
## For Every New Conversation

```
1. ✅ Read all 4 files above (use semantic_search or read_file tools)
2. ✅ Understand the project context
3. ✅ Check if your task relates to known issues
4. ✅ Review IMPORTANT_NOTES.md for relevant guidelines
```

**Don't skip this - it's not optional!**

---

## ⚠️ CRITICAL: Before Making Code Changes

Always check:
- [ ] Read `.ai/IMPORTANT_NOTES.md` file monitoring checklist
- [ ] Look for related problems in `.ai/ISSUES_AND_SOLUTIONS.md`
- [ ] Follow the modification guidelines in `.ai/IMPORTANT_NOTES.md`
- [ ] Check critical file locations in `.ai/IMPORTANT_NOTES.md`

---

## 🔴 MANDATORY: After Every Code Change

**This is NOT optional - EVERY code modification MUST trigger .ai updates!**

### Step 1: Update `.ai/ISSUES_AND_SOLUTIONS.md`
```markdown
### Problem X: [Brief Title]
**Problem Description**: ...
**Solution**: ✅ (success) or ❌ (failure/rollback)
**Files Changed**: [list files]
**Key Insights**: ...
```

### Step 2: Update `.ai/IMPORTANT_NOTES.md`
If you discovered:
- New common errors
- New command patterns
- Changed critical locations
- Important warnings

### Step 3: Commit with .ai changes
```bash
git add -A
git commit -m "description: change what you did
docs: update .ai knowledge base"
```

**IF YOU DON'T UPDATE .AI, THE NEXT AI ASSISTANT WILL REPEAT YOUR MISTAKES!**

---

## After Completing Tasks

Update the `.ai` folder IMMEDIATELY:
1. Update `.ai/ISSUES_AND_SOLUTIONS.md` with:
   - Problems encountered (if any) - 📋
   - Solutions applied (✅ for success, ❌ for failures)
   - What you learned - 📚
   - Warnings for future reference - ⚠️

2. Update `.ai/IMPORTANT_NOTES.md` if:
   - New command patterns discovered - 🔧
   - New common errors found - 🐛
   - Critical locations changed - 📌
   - Important new insights - 💡

**This is the payment you owe for the next AI to understand your work!**

---
## The .ai Folder Structure

```
.ai/
├── README.md                    # System documentation
├── PROJECT_OVERVIEW.md         # Project structure and features
├── ISSUES_AND_SOLUTIONS.md    # Problem history and solutions (UPDATE THIS!)
└── IMPORTANT_NOTES.md          # Critical info and quick reference (UPDATE THIS!)
```

**These files are NOT optional documentation - they are essential for efficient project maintenance.**

---

## Key Project Information

- **Project**: Sonic - High-performance blog platform
- **Language**: Go 1.21
- **Current Version**: v1.1.5
- **Module Path**: `github.com/aaro-n/sonic`
- **Key Issue**: Module path and ldflags must stay consistent
- **Docker**: Multi-arch builds (5 platforms supported)

---

## Common Pitfalls to Avoid

⚠️ **Read `.ai/IMPORTANT_NOTES.md` for detailed info on:**
- Docker/ldflags consistency issues
- Module path synchronization
- Git workflow for releases
- Common build errors

---

## Questions?

All answers are in the `.ai` folder. Most problems have been encountered and documented already!

---

**Last Updated**: 2026-02-20
**Maintained By**: GitHub Copilot / AI Assistant
**Status**: Active Knowledge Base
