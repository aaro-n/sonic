# GitHub Actions 设置指南

## 如何为Docker镜像构建配置Secrets

### Step 1: 获取Docker Hub访问令牌

1. 访问 [Docker Hub](https://hub.docker.com/)
2. 登录您的账户
3. 点击右上角头像 → Account Settings
4. 在左侧菜单选择 **Security** → **Personal access tokens**
5. 点击 **Generate new token**
6. 设置token名称 (例如: `github-actions`)
7. 选择权限:
   - **Read, Write & Delete** (读取、写入、删除)
8. 点击 **Generate** 
9. **复制token值**（页面关闭后无法再看到）

### Step 2: 在GitHub仓库配置Secrets

1. 进入GitHub仓库页面
2. 点击 **Settings** (仓库设置)
3. 在左侧菜单选择 **Secrets and variables** → **Actions**
4. 点击 **New repository secret**

#### 添加Docker Hub凭证

**第一个Secret:**
- Name: `DOCKERHUB_USERNAME`
- Value: 您的Docker Hub用户名

**第二个Secret:**
- Name: `DOCKERHUB_TOKEN`
- Value: 在Step 1中复制的token

### Step 3: 验证配置

点击 **Actions** 标签页，检查最近的工作流运行是否成功。

## GitHub Container Registry (GHCR) 自动配置

GHCR使用GitHub的内置 `GITHUB_TOKEN`，**无需手动配置**。
## 工作流触发

### 创建版本发布

当您推送一个版本标签时，Docker镜像会自动构建并推送：

```bash
# 创建并推送标签
git tag v1.0.0
git push origin v1.0.0

# 然后在GitHub上创建Release
# 进入Releases页面 → Create a new release
# 选择标签 → Publish release
```

这会自动触发 `.github/workflows/release-docker.yml` 工作流。

## 工作流状态监控

1. 进入GitHub仓库
2. 点击 **Actions** 标签
3. 查看工作流运行列表
4. 点击相应的运行查看详细日志

## 常见问题

### Q: 如何获取Docker Hub用户名？
A: 登录Docker Hub后，在右上角头像菜单中可以看到用户名。

### Q: Token过期了怎么办？
A: 可以生成新的Personal access token并更新GitHub Secrets。

### Q: 如何推送到多个镜像仓库？
A: 当前工作流同时支持GHCR和Docker Hub，无需额外配置。

### Q: 如何手动触发构建？
A: 在GitHub仓库 → Actions → 选择工作流 → Run workflow

## 镜像标签策略

### 自动生成的标签

当推送版本标签如 `v1.2.3` 时，会自动生成：

```
最新版本标签:
- v1.2.3      (完整版本)
- v1.2      (主.小版本)
- v1        (主版本)
- latest      (最新标签)
- sha-<hash>  (commit SHA)

示例:
- ghcr.io/go-sonic/sonic:v1.2.3
- gosonic/sonic:v1.2.3
```

## Docker镜像使用

### 拉取镜像

```bash
# 从GHCR拉取
docker pull ghcr.io/go-sonic/sonic:latest

# 从Docker Hub拉取
docker pull gosonic/sonic:latest
```

### 运行容器

```bash
# 基本运行
docker run -d \
  -p 8080:8080 \
  --name sonic \
  gosonic/sonic:latest

# 挂载数据卷
docker run -d \
  -p 8080:8080 \
  -v sonic-data:/sonic \
  --name sonic \
  gosonic/sonic:latest
```

### 跨平台运行

```bash
# 明确指定平台运行
docker run --platform linux/arm64 -d gosonic/sonic:latest
docker run --platform linux/amd64 -d gosonic/sonic:latest
docker run --platform linux/arm/v7 -d gosonic/sonic:latest
```

## 工作流文件位置

- **工作流配置**: `.github/workflows/release-docker.yml`
- **Dockerfile**: `scripts/Dockerfile`

## 相关文档

- [Docker Hub 文档](https://docs.docker.com/docker-hub/)
- [GitHub Actions 秘密管理](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## 需要帮助？

如果遇到问题，请：
1. 检查GitHub Actions日志
2. 验证Docker Hub凭证是否正确
3. 查看 [GitHub Actions 故障排除文档](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows)
