# GitHub Actions工作流修复指南

## 当前状态

`.github/workflows/release-docker.yml` 文件由于YAML格式问题需要修复。

## 解决方案

请按照以下步骤手动修复或使用提供的模板：

### 方法 1: 在GitHub UI中编辑

1. 访问您的GitHub仓库
2. 进入 `.github/workflows/release-docker.yml`
3. 点击编辑按钮
4. 替换为以下内容：

```yaml
name: Release-Docker

on:
  release:
    types: [published]

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
        username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Set build time
        run: echo "BUILD_TIME=$(date +%FT%T%z)" >> $GITHUB_ENV

      - name: Build and push to GHCR
     uses: docker/build-push-action@v5
        with:
          context: .
          file: ./scripts/Dockerfile
          platforms: linux/amd64,linux/arm64,linux/arm/v7
          push: true
          tags: |
            ghcr.io/${{ github.repository }}:latest
            ghcr.io/${{ github.repository }}:${{ github.ref_name }}
          build-args: |
            SONIC_VERSION=${{ github.ref_name }}
            BUILD_COMMIT=${{ github.sha }}
            BUILD_TIME=${{ env.BUILD_TIME }}

   - name: Build and push to Docker Hub
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./scripts/Dockerfile
          platforms: linux/amd64,linux/arm64,linux/arm/v7
        push: true
          tags: |
            gosonic/sonic:latest
      gosonic/sonic:${{ github.ref_name }}
          build-args: |
            SONIC_VERSION=${{ github.ref_name }}
            BUILD_COMMIT=${{ github.sha }}
        BUILD_TIME=${{ env.BUILD_TIME }}
```

### 方法 2: 命令行修复

在本地执行：

```bash
cat > .github/workflows/release-docker.yml << 'WORKFLOW'
name: Release-Docker

on:
  release:
    types: [published]

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
      username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Set build time
        run: echo "BUILD_TIME=$(date +%FT%T%z)" >> $GITHUB_ENV

      - name: Build and push to GHCR
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./scripts/Dockerfile
          platforms: linux/amd64,linux/arm64,linux/arm/v7
          push: true
       tags: |
            ghcr.io/${{ github.repository }}:latest
            ghcr.io/${{ github.repository }}:${{ github.ref_name }}
        build-args: |
        SONIC_VERSION=${{ github.ref_name }}
            BUILD_COMMIT=${{ github.sha }}
            BUILD_TIME=${{ env.BUILD_TIME }}

      - name: Build and push to Docker Hub
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./scripts/Dockerfile
          platforms: linux/amd64,linux/arm64,linux/arm/v7
          push: true
        tags: |
            gosonic/sonic:latest
          gosonic/sonic:${{ github.ref_name }}
          build-args: |
            SONIC_VERSION=${{ github.ref_name }}
            BUILD_COMMIT=${{ github.sha }}
         BUILD_TIME=${{ env.BUILD_TIME }}
WORKFLOW

git add .github/workflows/release-docker.yml
git commit -m "fix: correct GitHub Actions workflow YAML syntax"
git push origin main
```

## 工作流说明

### 触发条件
- 当在GitHub上发布新的Release时自动触发

### 支持的架构
- linux/amd64 (x86_64)
- linux/arm64 (ARM64/aarch64)
- linux/arm/v7 (ARM32)

### 镜像推送目标
1. **GitHub Container Registry (GHCR)**
   - `ghcr.io/<owner>/<repo>:latest`
   - `ghcr.io/<owner>/<repo>:<version>`

2. **Docker Hub**
   - `gosonic/sonic:latest`
   - `gosonic/sonic:<version>`

### 所需的GitHub Secrets
在GitHub仓库设置中配置以下Secrets：
- `DOCKERHUB_USERNAME`: Docker Hub用户名
- `DOCKERHUB_TOKEN`: Docker Hub Personal Access Token

GHCR使用内置的 `GITHUB_TOKEN`，无需额外配置。
## 验证工作流

修复后，可以通过以下方式验证：

1. **在GitHub Actions检查**
   - 进入Actions标签页
   - 查看workflow状态

2. **创建测试Release**
   ```bash
   git tag v0.1.0-test
   git push origin v0.1.0-test
   ```
   然后在GitHub上发布该Release

3. **检查镜像推送**
   ```bash
   docker pull ghcr.io/go-sonic/sonic:v0.1.0-test
   docker pull gosonic/sonic:v0.1.0-test
   ```

## 常见问题

**Q: 工作流为什么失败？**
A: 检查以下几点：
- YAML缩进是否正确
- Docker Hub Secrets是否已配置
- Dockerfile路径是否正确 (`./scripts/Dockerfile`)

**Q: 镜像没有推送到仓库**
A: 确认：
- `DOCKERHUB_USERNAME` 和 `DOCKERHUB_TOKEN` 已设置
- Token有正确的权限 (Read & Write)
- Release已发布（不仅仅是创建标签）

**Q: 如何调试工作流？**
A: 
1. 在GitHub Actions日志中查看详细输出
2. 添加 `debug` 步骤打印环境变量
3. 查看Docker构建的详细日志

## 下一步

完成工作流配置后：

1. ✅ 配置Docker Hub Secrets
2. ✅ 修复release-docker.yml文件
3. ✅ 创建测试Release进行验证
4. ✅ 查看GitHub Actions日志确认成功
5. ✅ 拉取镜像进行测试
6. ✅ 更新项目README文档

## 相关文档

- [DOCKER_BUILD_GUIDE.md](DOCKER_BUILD_GUIDE.md) - Docker镜像使用指南
- [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md) - GitHub Actions配置指南
- [docker-compose.example.yml](docker-compose.example.yml) - Docker Compose示例
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - 实现总结
