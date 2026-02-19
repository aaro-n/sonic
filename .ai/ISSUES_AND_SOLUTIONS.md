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

### 问题5: 阿里云OSS中文文件名无法打开

**问题描述**:
- 用户上传包含中文名的图片到阿里云OSS
- 文件上传成功并生成了正确的URL
- 但访问时报错：`NoSuchKey` - 指定的key不存在

**根本原因**:
- 代码中使用 `url.JoinPath()` 生成文件的相对路径
- `url.JoinPath()` 会自动对中文字符进行URL编码
- **问题链路**:
  1. 文件名：`最近的几次打车.jpg`
  2. `url.JoinPath()` 编码后：`%E6%9C%80%E8%BF%91%E7%9A%84%E5%87%A0%E6%AC%A1%E6%89%93%E8%BD%A6.jpg`
  3. **上传到OSS时，已编码的路径被作为Object Key上传**（这是错误的！）
  4. 访问时URL再次被编码
  5. OSS中存储的Key是编码版本，但访问要求匹配原始Key，所以报NoSuchKey

**解决方案**:
1. ✅ 分离路径生成的两个用途：
   - **OSS对象Key**: 需要原始未编码的路径
   - **HTTP访问URL**: 需要URL编码的路径
2. ✅ 修改 `url_file_descriptor.getRelativePath()` 返回未编码的原始路径
3. ✅ `GetFilePath()` 中使用 `url.JoinPath()` 进行适当的URL编码

**关键修改文件**:
- `service/storage/impl/url_file_descriptor.go` - 核心修复
  - `getRelativePath()` 改为: `return f.SubPath + "/" + f.getFullName()` (不使用url.JoinPath)
- `service/storage/impl/aliyun.go` - 添加注释说明GetFilePath中URL编码
- `service/storage/impl/minio.go` - 同样添加注释

**关键提交**:
- `c25c98e` - fix: OSS Chinese filename encoding issue

**工作流程修复前后对比**:
```
❌ 修复前:
getRelativePath() 使用url.JoinPath → 返回已编码路径 → 
PutObject(已编码路径) → OSS存储已编码Key → 
访问时URL再编码 → 找不到Key → NoSuchKey错误

✅ 修复后:
getRelativePath() 返回未编码路径 → 
PutObject(未编码路径) → OSS存储原始中文Key → 
GetFilePath()使用url.JoinPath进行编码 → 
返回正确编码的HTTP URL → 成功访问
```

**涉及的存储方式**:
- ✅ 阿里云OSS - 已修复
- ✅ MinIO - 已修复
- ℹ️ 本地存储 - 使用localFileDescriptor，不受影响

**验证**:
```python
# Python验证的编码逻辑
rawPath = "sonic/最近的几次打车.jpg"
httpURL = "https://cf-image.676232.xyz" + "/" + quote(rawPath, safe='/')
# 结果: https://cf-image.676232.xyz/sonic/%E6%9C%80%E8%BF%91%E7%9A%84%E5%87%A0%E6%AC%A1%E6%89%93%E8%BD%A6.jpg
# ✓ 完全正确匹配用户反馈
```

**注意事项**:
- ⚠️ 这是编码分离的经典问题：存储Key需要原始形式，HTTP URL需要编码形式
- ⚠️ 所有基于urlFileDescriptor的存储方式都需要遵循这个原则
- ⚠️ 未来如果添加其他云存储，务必记住这一点

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

### 问题7: AI知识库发现和自动更新机制
**问题描述**:
- 新对话启动时无法自动发现和读取`.ai`文件夹
- 即使有`.ai`系统，新AI助手也不知道要读取和更新它

**解决方案**:
1. ✅ 在项目根目录创建 `AI_KNOWLEDGE_BASE.md`
   - 显眼的位置，新对话必定看到
   - 明确的指示"必须读取.ai文件夹"
   - 包含读取顺序和工作流

2. ✅ 在项目根目录创建 `.copilot` 配置文件
   - 为自动化工具提供标记
   - 指定AI知识库路径

**关键文件修改**:
- 新增 `AI_KNOWLEDGE_BASE.md` - AI助手指导文档
- 新增 `.copilot` - 配置文件

**重要发现**:
- ⚠️ 仅仅有`.ai`文件夹是不够的
- ⚠️ 新对话和AI助手不会主动知道要读取它
- ⚠️ 需要在**项目根目录**创建显眼的指导文件
- ✅ `AI_KNOWLEDGE_BASE.md` 成为了访问`.ai`的入口点

**经验教训**:
- 必须有明确、显眼的指导文件在根目录
- 新AI对话只会看到根目录的文件
- `.ai`文件夹本身不够，还需要根目录的`AI_KNOWLEDGE_BASE.md`指向它
- 规则的存在和执行是两回事

**待改进问题**:
- ⚠️ 新对话是否会主动更新`.ai`内容？
  - 答：**不会**，除非在任务描述中明确要求
  - 解决方案：应该在`AI_KNOWLEDGE_BASE.md`中强制要求每个任务结束后都要更新
  - 或者：需要一个自动化脚本来提醒AI更新

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
- [x] 修复OSS中文文件名编码问题（2026-02-20 完成）
- [x] 重新发布v1.1.5版本（2026-02-20 完成）

---

最后更新: 2026-02-20 19:30
