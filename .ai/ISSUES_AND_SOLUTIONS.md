# 问题和解决方案日志

## 当前会话（2026-02-19 ~ 2026-02-20）

### 问题1: v1.1.5版本Docker镜像构建失败

**问题描述**:
- 用户要求重新发布v1.1.5版本
- Docker构建时ldflags中的module路径出现问题
- 在fork仓库中无法找到上游仓库的v1.1.5版本

**根本原因**:
1. 原始fork仓库 fork自 `https://github.com/go-sonic/sonic`
2. v1.1.5版本只存在于用户的fork中，上游仓库最高版本是v1.1.4
3. go.mod中声明的module是 `module github.com/go-sonic/sonic`
4. Docker构建时ldflags引用了上游仓库的module路径，导致Go编译器尝试从上游获取v1.1.5，但找不到

**解决方案**:
1. ✅ 修改go.mod，将module从 `github.com/go-sonic/sonic` 改为 `github.com/aaro-n/sonic`
2. ✅ 批量替换所有Go文件的import语句（227个文件）
3. ✅ 更新Dockerfile中ldflags的module路径引用
4. ✅ 重新标记和发布v1.1.5版本

**关键提交**:
- `61e64e4` - refactor: change module from github.com/go-sonic/sonic to github.com/aaro-n/sonic

**注意事项**:
- ⚠️ 更改module路径会影响整个项目，所有import都要同步改变
- ⚠️ ldflags中的module路径也要同步更新，否则构建时无法正确链接变量

---

### 问题2: Docker镜像标签不完整

**问题描述**:
- 生成的Docker镜像只有基础标签（:latest 和 :版本号）
- 需要更多标签便于追踪构建时间

**解决方案**:
1. ✅ 在GitHub Actions工作流中添加日期和时间戳变量
2. ✅ 为Docker镜像添加额外标签：
   - `ghcr.io/aaro-n/sonic:v1.1.5-2026-02-20`（版本号+日期）
   - `ghcr.io/aaro-n/sonic:v1.1.5-<timestamp>`（版本号+时间戳）

**关键修改**:
- `.github/workflows/release-docker.yml` - 添加日期和时间戳变量，扩展tags列表

**注意事项**:
- 日期格式: `YYYY-MM-DD` (使用date +%Y-%m-%d)
- 时间戳格式: Unix秒级时间戳

---

### 问题3: Docker构建平台支持不足

**问题描述**:
- 原始工作流只支持两个平台：linux/amd64 和 linux/arm64
- Sonic应支持更多平台以覆盖更广泛的用户

**解决方案**:
1. ✅ 扩展平台支持到5个：
   - linux/amd64（x86-64）
   - linux/arm64（ARM 64位）
   - linux/arm/v7（ARM 32位）
   - linux/ppc64le（PowerPC 64位小端）
   - linux/s390x（IBM System Z）

**关键修改**:
- `.github/workflows/release-docker.yml` - platforms字段更新

---

### 问题4: Docker Hub推送凭证问题

**问题描述**:
- Docker构建到Docker Hub推送步骤失败
- 错误：`push access denied, repository does not exist or may require authorization`

**根本原因**:
- GitHub Actions中缺少Docker Hub的凭证secrets配置
- DOCKERHUB_USERNAME 和 DOCKERHUB_TOKEN 可能为空或过期

**临时解决方案**:
1. ✅ 工作流中使用 `${{ secrets.DOCKERHUB_USERNAME }}` 动态获取用户名
2. 需要用户在GitHub仓库Settings中配置以下secrets：
   - `DOCKERHUB_USERNAME`: Docker Hub用户名
   - `DOCKERHUB_TOKEN`: Docker Hub访问token

**关键修改**:
- `.github/workflows/release-docker.yml` - Docker Hub tags和凭证配置

**注意事项**:
- ⚠️ 需要用户手动在GitHub Actions secrets中配置Docker Hub凭证
- ⚠️ 如果不配置，Docker Hub推送会跳过或失败（但GHCR推送仍正常）

---

### 问题5: 动态module路径替换复杂性

**问题描述**:
- 用户希望module路径能自动根据fork仓库地址变化
- 提议使用占位符系统，在构建时动态替换

**设计过程**:
1. ❌ 尝试1：创建脚本读取git remote，根据当前module替换（多层fork兼容性差）
2. ❌ 尝试2：改进脚本实现多层fork支持，但复杂度高，维护困难
3. ✅ 最终决定：使用占位符配置文件系统
   - 创建 `scripts/MODULE_CONFIG` 配置文件
   - 创建 `scripts/setup-module.sh` 脚本
   - Dockerfile在构建前自动运行脚本

**反馈和调整**:
- ❌ 用户认为太复杂，不需要多层fork支持
- ✅ 用户决定保留硬编码方案：`github.com/aaro-n/sonic`
- ✅ 撤销所有动态替换代码，回到简洁硬编码

**提交历史**:
- `a0a5ee4` - feat: add dynamic module path setup for multi-fork compatibility (已撤销)
- `8406bb7` - improve: make module update script multi-fork compatible (已撤销)
- `b188d45` - refactor: implement placeholder-based module path setup system (已撤销)
- `2a0f85a` - optimize: add date/timestamp tags (回退到此版本)

**经验教训**:
- ⚠️ 不要过度设计，保持简洁
- ⚠️ 在实现复杂功能前要充分确认需求
- ✅ 及时撤销错误的设计，保持代码整洁

---

### 问题6: Docker Hub镜像仓库名称硬编码

**问题描述**:
- Docker Hub的tags中镜像名称硬编码为 `gosonic/sonic`
- 应该使用 `${{ secrets.DOCKERHUB_USERNAME }}/sonic` 动态获取

**解决方案**:
1. ✅ 修改工作流，Docker Hub tags改为：
   - `${{ secrets.DOCKERHUB_USERNAME }}/sonic:latest`
   - `${{ secrets.DOCKERHUB_USERNAME }}/sonic:v1.1.5`
   - `${{ secrets.DOCKERHUB_USERNAME }}/sonic:v1.1.5-<日期>`
   - `${{ secrets.DOCKERHUB_USERNAME }}/sonic:v1.1.5-<时间戳>`

**关键修改**:
- `.github/workflows/release-docker.yml` - 更新Docker Hub tags

---

## 重要学习要点

### 1. Module路径和ldflags

**关键**:
- Go的ldflags中的 `-X` 标志用于在编译时替换变量值
- 语法：`-X package/path.variableName=value`
- Module路径必须与go.mod声明一致，否则无法正确链接

### 2. Docker多架构构建

**关键**:
- 使用docker/setup-qemu-action支持多架构
- 使用docker/build-push-action的platforms参数指定目标架构
- 支持的架构取决于基础镜像（golang:1.19.3-alpine）

### 3. GitHub Actions工作流

**关键**:
- Secrets必须在仓库Settings中提前配置
- ${{ github.ref_name }} 获取当前分支或标签名
- ${{ github.sha }} 获取当前提交哈希
- release事件类型[published]表示release发布时触发

### 4. Git标签和Release

**关键**:
- git tag 创建本地标签
- git push origin <tag> 推送标签到远程
- GitHub Release是建立在git标签之上的更高级功能
- 删除本地标签：git tag -d <tag>
- 删除远程标签：git push origin --delete <tag>

### 5. 代码重构需谨慎

**关键**:
- 大规模改动（如module路径）需要充分测试
- 要有清晰的回退计划
- git reset --hard 和 git push --force 可以快速回退，但需谨慎

---

## 下一步待处理

- [ ] 配置Docker Hub secrets（需用户操作）
- [ ] 验证Docker镜像在所有平台上的构建成功
- [ ] 测试Docker镜像的实际运行
- [ ] 更新文档，说明Docker镜像的使用方式

---

最后更新: 2026-02-20 13:30
