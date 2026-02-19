# 🚨 AI Compliance Enforcement Guide

## 概述

本项目实现了**多层次的强制执行机制**来确保AI助手和开发者遵守`.ai/`知识库更新约定。

---

## 🏗️ 四层强制执行系统

### 第1层：文件级强制 ✅ （已部署）

**文件**: `.ai/.INIT_REQUIRED`

**作用**: 
- 标记`.ai/`初始化为强制性
- 明确说明忽视后果
- 提供强制规则

**触发机制**: 文件存在即表示强制要求（无需编程）

---

### 第2层：文档级强制 ✅ （已部署）

**文件**: `README.md` (新增 "🤖 AI Assistant Knowledge Base" 部分)

**作用**:
- 对所有使用者（AI和人类）明确说明规则
- 标记为"MANDATORY"强制部分
- 解释不遵守的后果

**触发机制**: 任何人clone仓库都会看到

---

### 第3层：本地强制 ✅ （已部署）

**脚本**: `scripts/install-git-hooks.sh`

**创建**: `.git/hooks/pre-commit`

**作用**:
- 提交时检查代码是否修改
- 如果代码修改但`.ai/`未更新，发出警告
- 用户可选择继续或中止提交

**安装方法**:
```bash
bash scripts/install-git-hooks.sh
```

**效果**:
```
⚠️  WARNING: Code modified but .ai/ knowledge base not updated!
Code files being committed:
  ✗ service/storage/impl/aliyun.go

Missing .ai/ updates! According to project rules:
  • Update .ai/ISSUES_AND_SOLUTIONS.md
  • Update .ai/IMPORTANT_NOTES.md (if needed)
  • Stage changes: git add .ai/

Proceed without .ai/ updates? (y/N)
```

---

### 第4层：CI/CD强制 ✅ （已部署）
**工作流**: `.github/workflows/enforce-ai-updates.yml`

**作用**:
- 在GitHub上自动运行
- Pull Request和push都会触发
- 检查代码修改是否伴随`.ai/`更新
- 检查critical `.ai/`文件是否被删除

**触发条件**:
- 任何PR到master/main分支
- 任何push到master/main分支
**失败条件**:
- ❌ 代码修改但`.ai/`未更新 → CI失败，阻止merge
- ❌ `.ai/`关键文件被删除 → CI失败
- ❌ 关键`.ai/`文件为空 → CI失败

**成功示例**:
```
✅ Code modifications found and .ai/ updates are present

Code files:
  - service/storage/impl/url_file_descriptor.go
  - service/storage/impl/aliyun.go

AI knowledge base updates:
  - .ai/ISSUES_AND_SOLUTIONS.md
  - .ai/IMPORTANT_NOTES.md
```

---

## 🔍 验证工具

### check-ai-init.sh - 初始化检查

**用途**: 验证`.ai/`知识库完整性

**用法**:
```bash
bash scripts/check-ai-init.sh
```

**检查项**:
- ✅ 所有5个关键`.ai/`文件存在
- ✅ 所有文件不为空
- ✅ 文件内容完整

**输出示例**:
```
╔═══════════════════╗
║  Sonic AI Initialization Compliance      ║
╚══════════════╝

Checking required .ai/ files...
  ✓ .ai/.INIT_REQUIRED
  ✓ .ai/MUST_READ_FIRST.md
  ✓ .ai/PROJECT_OVERVIEW.md
  ✓ .ai/IMPORTANT_NOTES.md
  ✓ .ai/ISSUES_AND_SOLUTIONS.md

✅ AI Initialization Compliance Passed!
```

---

## 📋 强制规则汇总

### 对AI助手（如GitHub Copilot、Claude等）

**🚨 MUST DO（强制做的事）**:

1. **每个新会话开始**:
   - [ ] 读取 `.ai/.INIT_REQUIRED`
   - [ ] 读取 `.ai/MUST_READ_FIRST.md`
   - [ ] 读取 `.ai/PROJECT_OVERVIEW.md`
   - [ ] 读取 `.ai/IMPORTANT_NOTES.md`
   - [ ] 读取 `.ai/ISSUES_AND_SOLUTIONS.md`

2. **每次修改代码**:
   - [ ] 修改代码
   - [ ] 更新 `.ai/ISSUES_AND_SOLUTIONS.md`
   - [ ] 更新 `.ai/IMPORTANT_NOTES.md` (如需)
   - [ ] `git add .ai/`
   - [ ] `git commit -m "..."` (包含.ai/更改)

3. **提交前验证**:
   - [ ] 代码修改已完成
   - [ ] `.ai/`文件已更新
   - [ ] commit message提及.ai/更改
   - [ ] 没有遗漏任何文件

### 对人类开发者

**🔍 遵守CI/CD检查**:
- PR时如果修改了代码，必须更新`.ai/`
- CI会自动检查并失败（需要修复）
- 无法merge不完整的修改

**📚 可选参考**:
- 参考`.ai/`中的知识库
- 理解AI为什么需要这些信息
- 在自己的任务中也可遵循类似模式

---

## 🛠️ 设置步骤

### 1. 为开发者启用Pre-commit Hook

```bash
# 进入项目目录
cd /path/to/sonic

# 安装pre-commit hook
bash scripts/install-git-hooks.sh

# 验证安装
ls -la .git/hooks/pre-commit
```

### 2. 验证.ai/完整性

```bash
# 运行初始化检查
bash scripts/check-ai-init.sh

# 输出应该包含: ✅ AI Initialization Compliance Passed!
```

### 3. 验证GitHub Actions配置

```bash
# 检查工作流是否存在
ls -la .github/workflows/enforce-ai-updates.yml

# 查看工作流内容
cat .github/workflows/enforce-ai-updates.yml
```

---

## ⚡ 常见场景

### 场景1: 修改代码后提交

❌ **错误做法**:
```bash
git add service/storage/impl/aliyun.go
git commit -m "fix: bug in aliyun storage"
git push origin master
```
**结果**: 
- 本地pre-commit hook: ⚠️ 警告，你选择继续
- GitHub CI: ❌ 失败！Push被拒绝

✅ **正确做法**:
```bash
# 修改代码
# ... modify files ...

# 更新知识库
vim .ai/ISSUES_AND_SOLUTIONS.md  # 记录问题和解决方案
vim .ai/IMPORTANT_NOTES.md       # 添加新发现

# 提交
git add service/storage/impl/aliyun.go .ai/
git commit -m "fix: bug in aliyun storage

Also update .ai/ knowledge base with solution details"
git push origin master
```
**结果**: ✅ 通过pre-commit hook，✅ 通过GitHub CI

---

### 场景2: 新对话开始时

❌ **错误做法（之前的问题）**:
```
User: "修复这个bug"
AI: "好的，修改代码..."
（完成后没有读取.ai/，不知道历史）
```

✅ **正确做法**:
```
User: "修复这个bug"
AI: 
  1. 首先读取 .ai/.INIT_REQUIRED
  2. 读取 .ai/MUST_READ_FIRST.md
  3. 读取 .ai/PROJECT_OVERVIEW.md
  4. 读取 .ai/IMPORTANT_NOTES.md
  5. 读取 .ai/ISSUES_AND_SOLUTIONS.md (找到相关历史)
  6. "现在我了解了项目背景，可以开始修复..."
```

---

### 场景3: 尝试删除关键文件

❌ **尝试删除.ai/.INIT_REQUIRED**:
```bash
git rm .ai/.INIT_REQUIRED
git commit -m "remove unused file"
```

**结果**: 
- Pre-commit hook: ❌ 拒绝！"Cannot delete .ai/.INIT_REQUIRED file!"
- GitHub CI (如果绕过): ❌ 拒绝！"ERROR: Cannot delete .ai/.INIT_REQUIRED!"

✅ **这是故意的**：
- 这个文件不能被删除
- 它标记了`.ai/`的强制性质
- 如需修改，需要特殊审批

---

## 🎯 预期效果

### 对新对话的影响

**之前** ❌:
- AI修改代码但忘记更新`.ai/`
- 提交不完整，违反约定

**之后** ✅:
- 如果本地安装了hook：⚠️ 收到警告，被迫确认或修复
- 如果没安装hook：❌ GitHub CI拒绝merge，需要修复
- 无论如何都无法提交不完整的修改

### 对现有流程的影响

**贡献者流程**:
```
修改代码 → 更新.ai/ → 本地hook检查 → commit → GitHub CI检查 → merge
         警告(可覆盖)    自动检查      失败时修复   自动检查
```

**AI助手流程**:
```
新会话 → 读.ai/文件 → 了解约定和历史 → 修改代码时更新.ai/ → 完整提交
强制      5个文件      避免重复错误      必须做    可merge
```

---

## 📞 故障排除

### 问题1: Pre-commit hook提示权限错误

```
permission denied: .git/hooks/pre-commit
```

**解决**:
```bash
chmod +x .git/hooks/pre-commit
```

### 问题2: GitHub CI失败："Code modified but .ai/ not updated"

**解决**:
```bash
# 更新.ai/文件
git add .ai/
git commit --amend --no-edit
git push origin your-branch
```

### 问题3: 找不到.ai/.INIT_REQUIRED文件

**解决**:
```bash
# 检查文件是否存在
ls -la .ai/.INIT_REQUIRED

# 如果不存在，从git恢复
git checkout .ai/.INIT_REQUIRED

# 如果still不行，pull最新版本
git pull origin master
```

### 问题4: 想要跳过check怎么办？

**对于pre-commit hook** (本地):
```bash
# 可以用--no-verify跳过（但会警告）
git commit --no-verify -m "message"
```

**对于GitHub CI** (远程):
- ❌ 无法跳过！这是设计来确保代码质量
- 必须修复violations才能merge

---

## 🔐 安全性

### 为什么这么严格？

1. **防止知识丢失**: 每个问题和解决方案都会被记录
2. **防止重复错误**: 未来的贡献者可以查看历史
3. **AI上下文完整**: AI不会因为缺少背景信息而犯同样的错误
4. **项目可维护性**: 代码修改总是伴随着文档

### 这是否太严格？
**不是，因为**:
- 对大多数修改影响不大（只需更新.ai/）
- 如果是文档/配置修改可能不需要更新.ai/
- Hook提供了override选项（有确认）
- CI会最终确保质量

---

## 📈 监控和报告

### 查看CI执行情况

```bash
# 查看最近的GitHub Actions运行
gh run list --workflow=enforce-ai-updates.yml --limit=10

# 查看具体运行的详情
gh run view <RUN_ID>

# 查看完整日志
gh run view <RUN_ID> --log
```

### 检查Hook安装情况

```bash
# 检查是否安装了hook
ls -l .git/hooks/pre-commit

# 查看hook内容
cat .git/hooks/pre-commit

# 测试hook
git commit --dry-run
```

---

## ✅ 最终检查清单

在开始工作前验证:

- [ ] `.ai/.INIT_REQUIRED` 存在
- [ ] `.ai/MUST_READ_FIRST.md` 存在且可读
- [ ] `.ai/PROJECT_OVERVIEW.md` 存在
- [ ] `.ai/IMPORTANT_NOTES.md` 存在
- [ ] `.ai/ISSUES_AND_SOLUTIONS.md` 存在
- [ ] Pre-commit hook已安装 (可选): `ls .git/hooks/pre-commit`
- [ ] 初始化检查通过: `bash scripts/check-ai-init.sh`

如果所有项都通过，项目已准备好开始工作！

---

**最后更新: 2026-02-20 20:00**
