# 快速开始指南

## 📋 概述

本项目已完成以下改进：

1. ✅ **修复中文文件名URL编码问题**
2. ✅ **配置Docker多架构镜像构建**
3. ✅ **支持自动推送到GitHub Container Registry和Docker Hub**

---

## 🚀 立即开始

### 1. 配置Docker Hub (必需)

**获取Docker Hub凭证:**

1. 访问 [Docker Hub Security](https://hub.docker.com/settings/security)
2. 点击 "New Access Token"
3. 输入名称 (如: `github-actions`)
4. 选择权限: Read, Write, Delete
5. 点击 "Generate"
6. 复制生成的Token

**在GitHub配置Secrets:**

1. 进入GitHub仓库 → Settings → Secrets and variables → Actions
2. 点击 "New repository secret"
3. 添加两个Secrets:

| 名称 | 值 |
|------|-----|
| `DOCKERHUB_USERNAME` | 你的Docker Hub用户名 |
| `DOCKERHUB_TOKEN` | 上面复制的Token |

### 2. 创建Release触发构建

```bash
# 创建版本标签
git tag v1.0.0
git push origin v1.0.0

# 然后在GitHub上创建Release
# → Releases → Create a new release → 选择标签 → Publish release
```

### 3. 验证镜像构建

在GitHub → Actions 页面查看工作流运行进度。

完成后拉取镜像测试：

```bash
docker pull gosonic/sonic:v1.0.0
docker pull ghcr.io/go-sonic/sonic:v1.0.0
```

---

## 📚 文档导览

| 文档 | 内容 |
|------|------|
| [DOCKER_BUILD_GUIDE.md](DOCKER_BUILD_GUIDE.md) | Docker镜像详细指南 |
| [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md) | GitHub Actions配置指南 |
| [docker-compose.example.yml](docker-compose.example.yml) | Docker Compose部署示例 |
| [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) | 完整实现总结 |
| [README_FIXES.md](README_FIXES.md) | 修复总结 |

---

## 🐳 镜像使用

### 拉取镜像

```bash
# 最新版本
docker pull gosonic/sonic:latest

# 特定版本
docker pull gosonic/sonic:v1.0.0

# 从GHCR
docker pull ghcr.io/go-sonic/sonic:latest
```

### 运行容器

```bash
# 基本运行
docker run -d -p 8080:8080 gosonic/sonic:latest

# 使用卷持久化数据
docker run -d \
  -p 8080:8080 \
  -v sonic-data:/sonic \
  gosonic/sonic:latest

# 使用Docker Compose
docker-compose -f docker-compose.example.yml up -d
```

### 跨平台运行

```bash
# 在ARM64系统运行 (树莓派4/5)
docker run --platform linux/arm64 -d gosonic/sonic:latest

# 在ARM32系统运行 (树莓派Zero/1/2/3)
docker run --platform linux/arm/v7 -d gosonic/sonic:latest

# 在x86_64系统运行
docker run --platform linux/amd64 -d gosonic/sonic:latest
```

---

## ✨ 支持的架构

| 架构 | 描述 | 常见设备 |
|------|------|
| linux/amd64 | x86_64 | PC、服务器 |
| linux/arm64 | ARM 64位 | 树莓派4/5、Mac M1/M2 |
| linux/arm/v7 | ARM 32位 | 树莓派Zero/1/2/3 |

---

## 🔧 已修复的问题

### 中文文件名URL编码

**问题**: 中文文件名的图片返回URL不正确

**修复文件**:
- ✅ `service/storage/impl/aliyun.go`
- ✅ `service/storage/impl/local.go`
- ✅ `service/storage/impl/minio.go`

**原理**: 移除了不必要的URL解码，保持中文字符的URL编码形式

---

## ❓ 常见问题

### Q: Docker Hub凭证在哪里设置？
A: GitHub仓库 → Settings → Secrets and variables → Actions

### Q: 如何手动触发Docker构建?
A: 
```bash
git tag v1.0.0
git push origin v1.0.0
# 然后在GitHub创建Release
```

### Q: 镜像推送失败怎么办?
A: 
1. 检查Docker Hub Token是否有效
2. 检查GitHub Actions日志获取错误信息
3. 确认Secrets已正确配置

### Q: 支持哪些镜像标签?
A: 对于 v1.2.3 版本：
- `v1.2.3` (完整版本)
- `v1.2` (主.小版本)  
- `v1` (主版本)
- `latest` (最新)
- `sha-<hash>` (commit哈希)

### Q: 如何在特定架构上运行?
A: 使用 `--platform` 标志：
```bash
docker run --platform linux/arm64 gosonic/sonic:latest
```

---

## 📞 需要帮助?

1. 📖 查看相应的详细文档
2. 🔍 检查GitHub Actions日志
3. 💬 提交GitHub Issue

---

## ✅ 检查清单

在开始使用前，确保您已完成：

- [ ] 阅读本快速开始指南
- [ ] 配置Docker Hub凭证
- [ ] 在GitHub设置Secrets
- [ ] 创建测试Release
- [ ] 验证镜像成功构建和推送
- [ ] 成功拉取并运行镜像

---

**准备好了? 立即配置Docker Hub凭证开始吧! 🚀**

详见: [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)
