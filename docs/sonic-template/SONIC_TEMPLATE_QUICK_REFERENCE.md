# Sonic 模板变量 - 快速参考

> 快速查询版本，详见 [SONIC_TEMPLATE_VARIABLES_ANSWERS.md](SONIC_TEMPLATE_VARIABLES_ANSWERS.md)

---

## ❓➤ ✅ 快速问答

### Q1: 用户输入的 `{{ .post.FullPath }}` 会被编译吗？

**答：不会**

```
数据库中：Artalk.init({ pageKey: '{{ .post.FullPath }}' })
  ↓
{{ noescape .settings.comment_code }}
  ↓
最终 HTML：Artalk.init({ pageKey: '{{ .post.FullPath }}' })
                 ↑ 仍然是字面量
```

**原因：** `noescape` 函数直接输出字符串，不重新编译模板。

---

### Q2: 需要手动替换变量吗？

**答：取决于场景**

**方案A：不替换（输出字面文本）** - 适合 Artalk 等库
```go
// 模板
{{noescape .options.comment_code}}

// 输出的 HTML 中 {{ .post.FullPath }} 保持不变
// Artalk 等 JS 库自己处理 pageKey
```

**方案B：后端替换（推荐）** - 适合需要实际值的场景
```go
// handler/content/post.go
code := getOption("comment_code")
code = strings.ReplaceAll(code, "{{ .post.FullPath }}", post.FullPath)

model["comment_code"] = code
```

```tmpl
<!-- 模板 -->
{{noescape .comment_code}}  <!-- 已包含实际值 -->
```

---

### Q3: 是否需要在参数保存时创建模板文件？

**答：通常不需要。但可以做。**

```
用户保存参数
  ↓ OptionUpdateEvent 事件触发
  ↓ 自定义监听器处理
  ↓ 可选：生成新的 .tmpl 文件
  ↓ 文件监听器自动重新加载
```

**何时需要：** 需要根据参数动态生成新模板时（高级功能）

---

## 📋 使用指南

### 场景1：评论框架配置（最常见）

```yaml
# 数据库选项
comment_code: |
  <div id="comment"></div>
  <script src="https://cdn.jsdelivr.net/npm/artalk"></script>
  <script>
    Artalk.init({
      el: '#comment',
      pageKey: window.location.pathname
    });
  </script>
```

```tmpl
<!-- 模板：post.tmpl -->
{{noescape .options.comment_code}}
```

✅ **直接使用，无需替换**

---

### 场景2：自定义统计代码

```yaml
# 数据库选项
blog_statistics_code: |
  <script>
    (function() {
      console.log('Page: ' + document.location.href);
    })();
  </script>
```

```tmpl
<!-- 模板：footer.tmpl（已在 common_macro.tmpl 中定义）-->
{{define "global.statistics"}}
  {{noescape .options.blog_statistics_code}}
{{end}}
```

✅ **Sonic 官方示例，直接使用**

---

### 场景3：需要动态值的代码

**需求：** 输出包含实际文章路径的代码

```go
// handler/content/post.go - 新增函数
func (h *PostHandler) processCommentCode(ctx *gin.Context, code string, post *vo.Post) string {
    code = strings.ReplaceAll(
        code,
        "{{ .post.FullPath }}",
        post.FullPath,
    )
    code = strings.ReplaceAll(
        code,
        "{{ .post.Title }}",
      html.EscapeString(post.Title),
    )
    return code
}

// 在 GetPost 函数中
func (h *PostHandler) GetPost(ctx *gin.Context) (interface{}, error) {
    post, _ := h.PostService.GetBySlug(ctx, slug)
    
    commentCode := h.OptionService.GetOrByDefault(
        ctx,
        property.CommentCode,
    ).(string)
    
    // 处理代码
    commentCode = h.processCommentCode(ctx, commentCode, post)
    
    model := template.Model{
        "post": post,
        "comment_code": commentCode,
    }
    
    // render...
}
```

```tmpl
<!-- 模板：post.tmpl -->
{{noescape .comment_code}}
```

✅ **推荐方案：逻辑清晰、性能最优**

---

## 🔧 核心 API 参考

### 模板函数

```go
// 在 template/template.go 中定义
t.funcMap["noescape"] = func(str string) htmlTemplate.HTML {
    return htmlTemplate.HTML(str)
}
```

**用途：** 输出 HTML 字符串而不转义

```tmpl
<!-- 转义（默认） -->
{{.user_input}}  <!-- 如果输入是 <script>alert(1)</script> 会被转义为 &lt;script&gt; -->

<!-- 不转义 -->
{{noescape .user_input}}  <!-- 原样输出 -->
```

### 可用的 Sprig 函数

Sonic 集成了 [Sprig v3](https://github.com/Masterminds/sprig/v3)

```tmpl
<!-- 字符串替换 -->
{{replace "hello world" "world" "Sonic"}}

<!-- 包含检查 -->
{{contains "hello world" "world"}}

<!-- 字符串转大写/小写 -->
{{upper "hello"}}
{{lower "HELLO"}}
```

### 共享变量（在所有模板中可用）

```go
// 在 template_config.go 中设置
t.Template.SetSharedVariable("options", optionMap)   // 所有选项
t.Template.SetSharedVariable("user", user)            // 当前用户
t.Template.SetSharedVariable("theme", theme)          // 当前主题
t.Template.SetSharedVariable("settings", settings)    // 主题设置
```

---

## 📚 官方实现参考

### Sonic 如何使用 noescape？

```tmpl
<!-- resources/template/common/macro/common_macro.tmpl -->

{{define "global.custom_head"}}
  {{noescape .options.blog_custom_head}}
{{end}}

{{define "global.statistics"}}
  {{noescape .options.blog_statistics_code}}
{{end}}

{{define "global.custom_content_head"}}
  {{if or .is_post .is_sheet}}
  {{noescape .options.blog_custom_content_head}}
  {{end}}
{{end}}
```

✅ 官方示例中，所有用户自定义 HTML/JS 代码都使用 `noescape` 直接输出。

---

## ⚠️ 安全检查清单

在使用用户输入的代码时：

- [ ] 验证输入不包含恶意脚本（可选，取决于场景）
- [ ] 如不必要，不要使用 `noescape`，使用默认的转义
- [ ] 如使用 `noescape`，确保只用于可信的预定义选项
- [ ] 定期审计哪些选项使用了 `noescape`
- [ ] 在后端替换变量时，转义动态值

**示例：错误的做法**
```go
// ❌ 不安全：直接使用用户输入
code := ctx.PostForm("code")  // 用户输入
model["code"] = code
// 模板：{{noescape .code}}
```

**示例：正确的做法**
```go
// ✅ 安全：仅允许预定义的选项中的代码
code := optionService.GetOrByDefault(ctx, property.CommentCode)
// 额外验证：使用 sanitizer 清理（可选）
// code = sanitizer.Sanitize(code)
model["code"] = code
// 模板：{{noescape .code}}
```

---

## 🚀 一句话总结

> **用户输入的模板变量不会被重新编译。如需动态值，在后端用 `strings.ReplaceAll` 处理。**

---

## 📖 相关文档

| 文件 | 用途 |
|------|------|
| [SONIC_TEMPLATE_VARIABLES_ANSWERS.md](SONIC_TEMPLATE_VARIABLES_ANSWERS.md) | 详细技术分析 |
| [template/template.go](template/template.go) | 模板引擎源码 |
| [event/listener/template_config.go](event/listener/template_config.go) | 配置监听器源码 |
| [resources/template/common/macro/common_macro.tmpl](resources/template/common/macro/common_macro.tmpl) | 官方使用示例 |

---

**最后更新：** 2026年2月20日
