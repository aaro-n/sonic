# 阿里云OSS中文文件名无法打开问题修复

## 问题描述

当上传包含中文名的图片到阿里云OSS时，虽然上传成功并生成了正确的URL，但访问时会出现：
```
<Error>
<Code>NoSuchKey</Code>
<Message>The specified key does not exist.</Message>
<Key>sonic/最近的几次打车.jpg</Key>
</Error>
```

## 根本原因

代码中使用 `url.JoinPath()` 来生成文件的相对路径，这个函数会自动对路径进行URL编码。

**问题流程：**
1. 文件名：`最近的几次打车.jpg`
2. `url.JoinPath()` 编码后：`%E6%9C%80%E8%BF%91%E7%9A%84%E5%87%A0%E6%AC%A1%E6%89%93%E8%BD%A6.jpg`
3. 上传到OSS时，**已编码的路径被作为Object Key上传**
4. 访问URL被再次编码，变成二次编码的路径
5. OSS中存储的Key是已编码的版本，二次编码的访问当然找不到

## 解决方案

分离路径生成的两个用途：

### 1. OSS对象Key（用原始的、未编码的路径）
- **文件**：`service/storage/impl/url_file_descriptor.go`
- **修改**：`getRelativePath()` 方法改为使用字符串拼接，返回未编码的路径
```go
func (f *urlFileDescriptor) getRelativePath() string {
	// 返回未编码的原始路径 - 将在GetFilePath中进行URL编码生成HTTP URL
	if f.SubPath == "" {
		return f.getFullName()
	}
	// 直接使用斜杠拼接，避免url.JoinPath导致的编码
	return f.SubPath + "/" + f.getFullName()
}
```

### 2. HTTP访问URL（在GetFilePath中进行URL编码）
- **文件**：`service/storage/impl/aliyun.go`、`service/storage/impl/minio.go`
- **修改**：`GetFilePath()` 方法中使用 `url.JoinPath()` 对路径进行适当的URL编码

**阿里云OSS示例：**
```go
func (a *Aliyun) GetFilePath(ctx context.Context, relativePath string) (string, error) {
	// ... 获取配置 ...
	// 在这里使用url.JoinPath进行URL编码
	fullPath, _ := url.JoinPath(basePath, relativePath)
	return fullPath, nil
}
```

## 修改文件清单

1. ✅ `service/storage/impl/url_file_descriptor.go` - 修改 `getRelativePath()` 返回未编码路径
2. ✅ `service/storage/impl/aliyun.go` - 添加注释说明GetFilePath进行URL编码
3. ✅ `service/storage/impl/minio.go` - 添加注释说明GetFilePath进行URL编码

## 修复后的工作流程

### 上传流程
1. 用户上传文件：`最近的几次打车.jpg`
2. 生成相对路径（未编码）：`sonic/最近的几次打车.jpg`
3. 上传到OSS：使用**未编码**的路径作为Object Key
4. OSS中存储的Key：`sonic/最近的几次打车.jpg`（原始中文）

### 访问流程
1. 调用 `GetFilePath(ctx, "sonic/最近的几次打车.jpg")`
2. 通过 `url.JoinPath()` 进行URL编码：
   - 生成：`https://cf-image.676232.xyz/sonic/%E6%9C%80%E8%BF%91%E7%9A%84%E5%87%A0%E6%AC%A1%E6%89%93%E8%BD%A6.jpg`
3. 客户端访问编码后的URL
4. OSS中文件存在，成功返回

## 验证

```
Raw path: sonic/最近的几次打车.jpg
HTTP URL: https://cf-image.676232.xyz/sonic/%E6%9C%80%E8%BF%91%E7%9A%84%E5%87%A0%E6%AC%A1%E6%89%93%E8%BD%A6.jpg
✓ 完全正确
```

## 涉及的存储方式

此修复适用于所有基于 `urlFileDescriptor` 的云存储方式：
- ✅ 阿里云OSS
- ✅ MinIO
- ℹ️ 本地存储（使用 `localFileDescriptor`，已经正确处理）

## 后续测试建议

1. 上传包含中文名的图片到阿里云OSS
2. 验证能否正常访问和显示
3. 测试特殊字符（空格、符号等）

## 相关问题

- 之前对本地存储、MinIO的修复报告请参考：`CHINESE_FILENAME_FIX_REPORT.md`
