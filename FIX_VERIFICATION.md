# Feed & Sitemap URL 修复验证

## 问题描述

### 问题1：RSS源链接双重拼接
- **症状**：启用"全局绝对路径"时，RSS源链接变成 `https://www.itansuo.infohttps://www.itansuo.info/archives/xxx`
- **原因**：模板层在已包含完整URL的 `$post.FullPath` 基础上，又额外拼接 `{{$.blog_url}}`

### 问题2：关闭绝对路径时Sitemap无法被Google抓取
- **症状**：关闭"全局绝对路径"后，sitemap.xml 中部分链接只有相对路径
- **原因**：Sitemap XML规范要求绝对URL，Google无法解析相对路径
- **差异**：Bing能够容错处理相对路径，所以能抓取

---
## 修复方案

### 架构设计

**后端（Go）** 负责构建 `FullPath`：
- 启用绝对路径：`FullPath = "https://domain.com/archives/xxx"`
- 禁用绝对路径：`FullPath = "/archives/xxx"`

**模板（Go Template）** 只负责输出：
- **Feed & Sitemap XML**：直接输出 `{{.blog_url}}{{.FullPath}}` 
  - 启用时：`domain.com + /archives/xxx` → 完整URL ✅
  - 禁用时：`domain.com + /archives/xxx` → 完整URL ✅
- **HTML Sitemap**：直接输出 `{{.FullPath}}`（已包含绝对/相对路径）

---

## 修改清单

### 1. 后端代码检查 ✅

| 文件 | 函数 | 逻辑检查 | 状态 |
|------|------|------|------|
| base_post.go | buildPostFullPath | `if isEnabled { fullPath.WriteString(blogBaseURL) }` | ✅ 正确 |
| category.go | ConvertToCategoryDTO | `if isEnabled { fullPath.WriteString(blogBaseURL) }` | ✅ 正确 |
| category.go | ConvertToCategoryDTOs | `if isEnabled { fullPath.WriteString(blogBaseURL) }` | ✅ 正确 |
| tag.go | ConvertToDTO | `if isEnabled { fullPath.WriteString(blogBaseURL) }` | ✅ 正确 |
| tag.go | ConvertToDTOs | `if isEnabled { fullPath.WriteString(blogBaseURL) }` | ✅ 正确 |

**结论**：后端逻辑完全正确，无需修改。

### 2. 模板代码修改 ✅

#### A. sitemap_xml.tmpl
**修改前**：
```gotmpl
<loc>{{- if $.globalAbsolutePathEnabled}}{{$.blog_url}}{{end}}{{$post.FullPath}}</loc>
```

**修改后**：
```gotmpl
<loc>{{$.blog_url}}{{$post.FullPath}}</loc>
```

**影响范围**：文章、分类、标签（3处）

#### B. rss.tmpl
**修改前**：
```gotmpl
<link>{{- if $.globalAbsolutePathEnabled}}{{$.blog_url}}{{end}}{{$post.FullPath}}</link>
```

**修改后**：
```gotmpl
<link>{{.blog_url}}{{$post.FullPath}}</link>
```

**修改处**：分类链接、文章链接（2处）

#### C. atom.tmpl
**修改前**：
```gotmpl
href="{{- if $.globalAbsolutePathEnabled}}{{$.blog_url}}{{end}}{{$post.FullPath}}"
```

**修改后**：
```gotmpl
href="{{.blog_url}}{{$post.FullPath}}"
```

**修改处**：分类链接、文章链接（2处）

#### D. sitemap_html.tmpl
**修改前**：
```gotmpl
href="{{- if $.globalAbsolutePathEnabled}}{{$.blog_url}}{{end}}{{$category.FullPath}}"
```

**修改后**：
```gotmpl
href="{{$category.FullPath}}"
```

**修改处**：分类、标签链接（2处）

---

## 验证逻辑

### 场景1：启用全局绝对路径

**后端生成**：
- `$post.FullPath` = `"https://www.itansuo.info/archives/GitHubActionsESA"`

**模板输出**：
- Sitemap XML：`<loc>https://www.itansuo.info + https://www.itansuo.info/archives/GitHubActionsESA</loc>`

⚠️ **问题发现！** 这里会出现双URL拼接！

**根本原因**：`{{.blog_url}}` 和 `FullPath` 都包含了完整URL

**正确方案**：需要修改后端逻辑

---

## 后端逻辑优化方案

### 当前问题分析

后端在启用绝对路径时，FullPath 已经包含了 `blogBaseURL`：
```go
if isEnabled {
    fullPath.WriteString(blogBaseURL)  // 已包含: https://www.itansuo.info
}
fullPath.WriteString("/archives/xxx")   // 结果: https://www.itansuo.info/archives/xxx
```

而模板还在做：
```gotmpl
{{.blog_url}}{{$post.FullPath}}
// 结果: https://www.itansuo.info + https://www.itansuo.info/archives/xxx
// = https://www.itansuo.infohttps://www.itansuo.info/archives/xxx ❌
```

### 修复方案选项

**选项A**：修改后端 - FullPath 始终为相对路径，由模板组装
```go
// 后端：始终只返回相对路径
fullPath.WriteString("/archives/xxx")

// 模板：根据需要添加域名
{{.blog_url}}{{$post.FullPath}}  // Feed & Sitemap XML
{{$post.FullPath}}            // HTML
```

**选项B**：修改模板 - 直接输出 FullPath（不再添加blog_url）
```gotmpl
{{$post.FullPath}}  // 所有地方都直接输出
```

### 推荐方案：选项A（更规范）

**原因**：
1. 后端只负责数据，模板负责展现
2. FullPath 作为相对路径更通用（可用于多种场景）
3. 模板层可灵活控制是否添加域名

**实现步骤**：
1. 修改后端所有 FullPath 生成函数，移除 `blogBaseURL` 部分
2. 保持模板 `{{.blog_url}}{{$post.FullPath}}` 的做法
3. 无条件地输出绝对URL（满足Sitemap规范）
---

## 最终修改方案

### 推荐：选项A - 修改后端逻辑

#### 1. base_post.go::buildPostFullPath
```go
fullPath := strings.Builder{}
// 移除 isEnabled 和 blogBaseURL 的判断
// if isEnabled { 
//     fullPath.WriteString(blogBaseURL)
// }
fullPath.WriteString("/")
// 继续添加路径
```

#### 2. category.go::ConvertToCategoryDTO / ConvertToCategoryDTOs
同样移除 isEnabled 和 blogBaseURL 的判断

#### 3. tag.go::ConvertToDTO / ConvertToDTOs
同样移除 isEnabled 和 blogBaseURL 的判断

#### 4. 模板层保持现状
```gotmpl
{{.blog_url}}{{$post.FullPath}}  // Feed & Sitemap XML
{{$post.FullPath}}           // HTML sitemap
```

---
## 验证清单

- [ ] 修改后端逻辑（移除 isEnabled 条件）
- [ ] 验证 `buildPostFullPath` 函数
- [ ] 验证 `ConvertToCategoryDTO(s)` 函数  
- [ ] 验证 `ConvertToDTO(s)` 函数（Tag）
- [ ] 运行单元测试
- [ ] 本地集成测试
  - [ ] 关闭绝对路径：URL应为 `domain/path`
  - [ ] 启用绝对路径：URL应为 `domain/path` (相同的 FullPath)
  - [ ] 模板输出：Feed应为 `domain.com/path`，HTML应为 `/path`
- [ ] 推送到 GitHub

---

