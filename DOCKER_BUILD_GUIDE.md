# Docker 多架构镜像构建指南

## 概述

本项目已配置GitHub Actions工作流，支持自动构建和推送多架构Docker镜像到GitHub Container Registry (GHCR)和Docker Hub。

## 支持的架构

- **linux/amd64** (x86_64) - Intel/AMD处理器
- **linux/arm64** (ARM64/aarch64) - 64位ARM处理器
- **linux/arm/v7** (ARM32) - 32位ARM处理器

## 工作流配置

### 1. GitHub Actions环境变量

在仓库设置中配置以下环保密变量：

#### Docker Hub
- `DOCKERHUB_USERNAME` - Docker Hub用户名
- `DOCKERHUB_TOKEN` - Docker Hub访问令牌

#### GitHub Container Registry (GHCR)
- 自动使用 `GITHUB_TOKEN` (无需手动配置)

### 2. 现有工作流

#### release-docker.yml
- **触发条件**: 发布新版本 (release published)
- **镜像推送**: 推送到GHCR和Docker Hub
- **架构**: linux/amd64, linux/arm64, linux/arm/v7

## 工作流详细说明

### 发布流程

1. **创建Release标签**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **在GitHub上发布Release**
   - 进入Releases页面
   - 发布新版本
   - 自动触发Docker构建

3. **镜像标签生成**

根据SemVer版本号自动生成多个标签：

```
v1.2.3 版本会生成以下标签:
├── GHCR
│   ├── ghcr.io/go-sonic/sonic:v1.2.3  (完整版本)
│   ├── ghcr.io/go-sonic/sonic:v1.2    (主.小版本)
│   ├── ghcr.io/go-sonic/sonic:v1      (主版本)
│   ├── ghcr.io/go-sonic/sonic:latest  (最新)
│   └── ghcr.io/go-sonic/sonic:sha-xxx (commit SHA)
│
└── Docker Hub
    ├── gosonic/sonic:v1.2.3
    ├── gosonic/sonic:v1.2
    ├── gosonic/sonic:v1
    ├── gosonic/sonic:latest
    └── gosonic/sonic:sha-xxx
```

## 镜像拉取

### 从GHCR拉取
```bash
docker pull ghcr.io/go-sonic/sonic:latest
docker pull ghcr.io/go-sonic/sonic:v1.0.0
```

### 从Docker Hub拉取
```bash
docker pull gosonic/sonic:latest
docker pull gosonic/sonic:v1.0.0
```

## 跨平台运行

### 在不同架构的机器上运行

```bash
# x86_64 (Intel/AMD)
docker run --platform linux/amd64 -d gosonic/sonic:latest
# ARM64 (树莓派4/5、Apple Silicon等)
docker run --platform linux/arm64 -d gosonic/sonic:latest

# ARM32 (树莓派0/1/2等旧款)
docker run --platform linux/arm/v7 -d gosonic/sonic:latest
```

### Docker Buildx本地多架构构建

如果需要在本地构建多架构镜像：

```bash
# 创建buildx实例（如果尚未创建）
docker buildx create --name mybuilder --use

# 构建多架构镜像
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t gosonic/sonic:latest \
  -f scripts/Dockerfile \
  --push .
```

## 构建参数

Docker构建时传递以下参数：

| 参数 | 来源 | 说明 |
|------|------|------|
| `SONIC_VERSION` | `github.ref_name` | Git标签/分支名 |
| `BUILD_COMMIT` | `github.sha` | 提交hash |
| `BUILD_TIME` | `date -u` | ISO 8601格式时间戳 |

## 故障排除

### 镜像推送失败

1. **验证凭证**
   ```bash
   # 检查Docker Hub凭证
   echo $DOCKERHUB_TOKEN | docker login -u $DOCKERHUB_USERNAME --password-stdin
   ```

2. **检查Secrets配置**
   - 进入仓库Settings → Secrets and variables → Actions
   - 确认`DOCKERHUB_USERNAME`和`DOCKERHUB_TOKEN`已设置

3. **查看Actions日志**
   - 进入GitHub仓库 → Actions标签
   - 找到失败的工作流
   - 查看详细日志

### 架构构建错误

1. **QEMU兼容性**
   ```bash
   # 确保系统支持QEMU模拟
   docker run --rm --privileged tonistiigi/binfmt --install all
   ```

2. **缓存清除**
   ```bash
   # 清除Docker缓存后重新构建
   docker buildx prune -a
   ```

## 最佳实践

1. **版本号规范**: 使用SemVer标签 (v1.2.3)
2. **提交信息**: 清晰的提交信息便于追踪
3. **测试**: 在创建Release前在PR中测试镜像
4. **标签维护**: 定期清理旧的镜像标签

## 相关资源

- [Docker官方文档](https://docs.docker.com/)
- [GitHub Actions文档](https://docs.github.com/en/actions)
- [Docker Buildx文档](https://docs.docker.com/build/architecture/)
- [QEMU文档](https://www.qemu.org/documentation/)

## 文件位置

- Docker构建文件: `./scripts/Dockerfile`
- GitHub Actions工作流: `./.github/workflows/release-docker.yml`
