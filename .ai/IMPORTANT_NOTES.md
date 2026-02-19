# 重要提示和注意事项

## 关键代码位置

### Module和Import相关
- **go.mod**: 第1行声明了module为 `github.com/aaro-n/sonic`
- **所有.go文件**: import都使用 `github.com/aaro-n/sonic` 路径
- **Dockerfile**: ldflags中的变量引用也使用 `github.com/aaro-n/sonic` 路径

### Docker构建相关
- **Dockerfile路径**: `scripts/Dockerfile`
- **工作流路径**: `.github/workflows/release-docker.yml`
- **构建平台**: linux/amd64, linux/arm64, linux/arm/v7, linux/ppc64le, linux/s390x

### 版本标记相关
- **当前版本**: v1.1.5
- **git标签**: v1.1.5 指向commit `2a0f85a`
- **发布工作流触发**: 当push release类型[published]事件时

---

## 常用命令

### 版本发布流程
```bash
# 1. 删除旧标签
git tag -d v1.1.5
git push origin --delete v1.1.5

# 2. 创建新标签
git tag v1.1.5
git push origin v1.1.5
# 3. 创建GitHub Release（触发Docker构建）
gh release delete v1.1.5 -y 2>/dev/null
gh release create v1.1.5 --title "v1.1.5" --notes "Release v1.1.5"
```

### 查看工作流状态
```bash
# 查看最近的工作流运行
gh run list --workflow=release-docker.yml --limit=5

# 查看具体工作流的日志
gh run view <RUN_ID> --log
```

### 查看项目分支
```bash
# 列出所有分支
git branch -a -v

# 当前项目分支信息
master: 主分支，包含v1.1.5版本
chore/theme_update: 主题更新分支
feat/new_theme: 新主题功能分支
```

---

## 文件修改检查清单
修改任何以下文件时需要特别注意：

### ⚠️ 关键文件

| 文件 | 修改前检查 | 修改后验证 |
|------|----------|--------|
| `go.mod` | 确认module声明的一致性 | 检查go mod tidy是否报错 |
| `scripts/Dockerfile` | 验证ldflags语法正确 | 尝试本地docker build测试 |
| `.github/workflows/release-docker.yml` | 检查YAML语法 | 使用github actions验证器检查 |
| 所有.go文件 | 确认import路径是否统一 | 运行go build验证 |

### ✅ 安全操作方式

1. **修改go.mod之前**:
   ```bash
   git status  # 确保工作目录干净
   git log --oneline -1  # 记录当前commit
   ```

2. **批量替换import之前**:
   ```bash
   # 先查看会被替换多少个文件
   grep -r "old_path" --include="*.go" . | wc -l
   # 然后执行替换
   find . -name "*.go" -type f ! -path "./vendor/*" ! -path "./.git/*" -print0 | xargs -0 sed -i "s|old_path|new_path|g"
   # 验证替换结果
   grep -r "old_path" --include="*.go" . | wc -l  # 应该返回0
   ```

3. **修改Dockerfile之前**:
   ```bash
   # 检查Dockerfile语法
   docker build --dry-run -f scripts/Dockerfile .
   ```

---

## 常见错误和解决

### 1. Docker构建时ldflags错误
**症状**: 构建失败，提示无法找到package
**原因**: ldflags中的module路径与代码中实际的import不匹配
**解决**: 确保go.mod的module声明 + Dockerfile ldflags + 代码import 三者一致

### 2. Go编译错误：cannot find module
**症状**: go build失败，显示找不到某个module
**原因**: 可能是go.mod更新了但import语句没同步更新
**解决**: 运行 `go mod tidy` 并检查所有import语句

### 3. GitHub Actions工作流失败
**症状**: Release创建了但工作流失败
**原因**: 通常是Docker Hub凭证问题或yaml语法错误
**解决**: 
- 检查secrets是否配置：Settings → Secrets and variables → Actions
- 检查workflow yaml语法：使用github actions lint工具
- 查看工作流日志：gh run view <ID> --log

### 4. Docker镜像标签混乱
**症状**: 镜像标签格式不一致或缺少某些标签
**原因**: 工作流中tags定义有误
**解决**: 检查工作流中的tags格式，确保与预期一致

### 5. 中文文件名编码问题（OSS/MinIO）
**症状**: 上传中文名文件到OSS，访问时报 `NoSuchKey` 错误
**原因**: 
- 使用 `url.JoinPath()` 生成Object Key时，自动进行了URL编码
- 将已编码的路径作为Key存储到OSS
- 访问时URL再次编码，导致Key不匹配
**解决**: 
- 分离编码逻辑：storage层的getRelativePath()返回**未编码**的原始路径
- GetFilePath()中使用url.JoinPath()对路径进行URL编码
- 参考: service/storage/impl/url_file_descriptor.go 的修改
- 关键：OSS/MinIO需要原始Key，HTTP访问需要编码URL

---

## AI助手行为规范

### 🚨 强制规则（MUST DO）

**每次修改代码后，MUST更新.ai文件夹**:
```
代码修改完 → 更新 .ai/ISSUES_AND_SOLUTIONS.md
         → 更新 .ai/IMPORTANT_NOTES.md（如有新发现）
         → git commit 包含.ai更改
```

**没有例外**！即使修改很小，也要更新记录。

---

## 文件监控清单

每次修改代码前都要检查这些文件的内容：

- [ ] `go.mod` - module声明是否正确
- [ ] `scripts/Dockerfile` - ldflags中的module路径是否正确
- [ ] `.github/workflows/release-docker.yml` - 工作流配置是否完整
- [ ] `.ai/ISSUES_AND_SOLUTIONS.md` - 查看是否有相关的已知问题
- [ ] `.ai/IMPORTANT_NOTES.md` - 查看是否有特殊注意事项

**修改代码后必须做**:
- [ ] 立即更新 `.ai/ISSUES_AND_SOLUTIONS.md`
- [ ] 如有新发现则更新 `.ai/IMPORTANT_NOTES.md`
- [ ] commit包含.ai文件的更改

---

## 快速参考

### 版本和分支信息
- **主分支**: master
- **当前版本**: v1.1.5
- **上游仓库**: https://github.com/go-sonic/sonic (最高v1.1.4)
- **当前fork**: https://github.com/aaro-n/sonic

### Docker相关
- **GHCR仓库**: ghcr.io/aaro-n/sonic
- **Docker Hub仓库**: 需要配置DOCKERHUB_USERNAME
- **支持架构**: 5种（amd64, arm64, arm/v7, ppc64le, s390x）
### 重要命令别名
```bash
# 重新发布版本
git tag -d v1.1.5 && git push origin --delete v1.1.5 && git tag v1.1.5 && git push origin v1.1.5 && gh release delete v1.1.5 -y 2>/dev/null; gh release create v1.1.5 --title "v1.1.5" --notes "Release v1.1.5"
```

---

最后更新: 2026-02-20 19:30
