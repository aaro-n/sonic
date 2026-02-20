# Sonic 模板与动态代码常见问题 - 社区版
> 可直接复制到 GitHub Issue、论坛或文档中使用

---

## 问题 1：关于处理用户输入的动态模板代码的最佳实践

### 标题
> 关于处理用户输入的动态模板代码的最佳实践

### 问题描述
1. 用户在后台填入包含模板变量的代码（如 `{{ .post.FullPath }}`），这些变量在最终渲染时会被编译吗？
2. 如果不会自动编译，是否需要在模板中手动使用 `replace` 函数替换？
3. 是否有更好的方式来处理评论框架、分析脚本等"用户可配置代码块"的场景？

### 答案

#### 1️⃣ 模板变量会被编译吗？

**不会。** Sonic 的模板引擎**仅在启动时编译一次**。

- **数据库中的字符串**：`Artalk.init({ pageKey: '{{ .post.FullPath }}' })`
- **模板中的输出**：`{{ noescape .options.comment_code }}`
- **最终 HTML**：`<script>Artalk.init({ pageKey: '{{ .post.FullPath }}' })</script>`

注意：`{{ .post.FullPath }}` 保持**字面量**，不会被替换。

**技术原因：**
- Sonic 使用 Go 的 `html/template` 包
- 模板在启动时通过 `template.ParseFiles()` 编译为二进制对象
- `noescape` 函数只是将字符串按原样转换为 `HTML` 类型，不会重新解析

#### 2️⃣ 需要手动替换吗？

**取决于你的需求：**

**方案 A：不替换（适合 Artalk 等库）**
```go
// 数据库选项
comment_code: Artalk.init({ el: '#comment' })

// 模板
{{noescape .options.comment_code}}

// 输出
<script>Artalk.init({ el: '#comment' })</script>
```
✅ Artalk 等客户端库会自己处理 `pageKey`

**方案 B：后端替换（推荐，适合需要实际值的场景）**
```go
// handler/content/post.go
code := getOptionValue("comment_code")
code = strings.ReplaceAll(code, "{{ .post.FullPath }}", post.FullPath)
code = strings.ReplaceAll(code, "{{ .post.Title }}", post.Title)

model["comment_code"] = code
```

```tmpl
<!-- 模板直接输出 -->
{{noescape .comment_code}}
```

✅ 在后端处理，逻辑清晰，性能最优

**❌ 不推荐方案 C：在模板中用 replace**
```tmpl
<!-- 复杂且脆弱 -->
{{$code := replace .options.code "{{ .post.FullPath }}" .post.FullPath}}
{{noescape $code}}
```

#### 3️⃣ 最佳实践

对于"用户可配置的代码块"功能：

```
┌─ 数据层 ───────────────┐
│ 数据库中存储原始代码          │
│ comment_code: "Artalk.init({...})" │
└──────────────────┘
        ↓
┌─ 业务层 ─────────────────┐
│ 后端处理：替换变量、验证           │
│ code = strings.ReplaceAll(...)     │
└────────────────────┘
      ↓
┌─ 表现层 ────────────────┐
│ 模板直接输出           │
│ {{noescape .comment_code}}         │
└────────────────────┘
        ↓
最终 HTML（包含实际值）
```

**优点：**
- ✅ 关注点分离，易于测试
- ✅ 性能最优（避免模板编译开销）
- ✅ 代码清晰易维护
- ✅ 完整的输入验证能力

---

## 问题 2：参数保存时是否可以创建/修改模板文件？

### 问题描述
主题是否可以在参数保存时创建或修改模板文件？是否存在"参数保存钩子"或"生命周期函数"来监听参数变化？

### 答案

#### 现状

Sonic 提供了**事件系统**来监听参数变化：

```go
// event/listener/template_config.go 中已注册
bus.Subscribe(event.OptionUpdateEventName, listener.HandleOptionUpdateEvent)
```

#### 实现方案

**方案 1：订阅现有事件（推荐）**

在 `OptionUpdateEvent` 触发时，你可以在自定义监听器中生成模板文件：

```go
// 创建自定义事件监听器（新文件）
// service/listener/dynamic_template_hook.go
package listener

import (
    "context"
    "os"
    "path/filepath"
    "go.uber.org/zap"
    "github.com/aaro-n/sonic/event"
    "github.com/aaro-n/sonic/service"
)

type DynamicTemplateHookListener struct {
    ThemeService service.ThemeService
    OptionService service.OptionService
    Logger *zap.Logger
}

func NewDynamicTemplateHookListener(
    bus event.Bus,
    themeService service.ThemeService,
  optionService service.OptionService,
    logger *zap.Logger,
) {
    listener := &DynamicTemplateHookListener{
        ThemeService: themeService,
        OptionService: optionService,
        Logger: logger,
    }
    // 监听选项更新事件
    bus.Subscribe(event.OptionUpdateEventName, listener.OnOptionUpdate)
}

func (l *DynamicTemplateHookListener) OnOptionUpdate(ctx context.Context, e event.Event) error {
    // 当选项更新时调用
    
    // 获取当前激活的主题
    theme, err := l.ThemeService.GetActivateTheme(ctx)
    if err != nil || theme == nil {
        return nil
    }
    
    // 读取特定选项（如 comment_code）
    commentCode := l.OptionService.GetOrByDefault(
        ctx,
      property.CommentCode,
    ).(string)
    
    // 生成模板文件
    templateDir := filepath.Join(theme.ThemePath, "generated")
    os.MkdirAll(templateDir, 0755)
    
    templatePath := filepath.Join(templateDir, "comment.tmpl")
    
    templateContent := `{{define "comment"}}
    {{noescape .comment_code}}
{{end}}`
    
    err = os.WriteFile(templatePath, []byte(templateContent), 0644)
    if err != nil {
        l.Logger.Error("failed to write template file", zap.Error(err))
        return err
    }
    
    l.Logger.Info("dynamic template created", zap.String("path", templatePath))
    return nil
}
```

**方案 2：在选项服务中触发自定义事件**

```go
// 在 service/impl/option.go 的 Save 方法中

func (o *optionServiceImpl) Save(ctx context.Context, optionMap map[string]string) error {
    // ... 保存逻辑 ...
    
    // 发布自定义事件
    o.bus.Publish(ctx, &event.CustomOptionSavedEvent{
        Options: optionMap,
        Timestamp: time.Now(),
    })
    
    return nil
}
```
#### 权限与安全

- ✅ 只要 Sonic 运行用户有写权限，就可以创建文件
- ✅ 建议在主题目录的特定子目录（如 `generated/`）中创建
- ✅ 创建的 `.tmpl` 文件会被自动监听和重新加载

**文件自动检测机制：**
```go
// template/watcher.go 中
// 任何 .tmpl 文件的创建/修改都会触发重新加载
case event.Op&fsnotify.Write == fsnotify.Write:
    t.Reload([]{event.Name})
```

---

## 问题 3：其他博客平台是怎么处理的？

### Hugo
- ✅ 静态生成器，编译时全部处理
- ✅ 使用 Shortcodes 处理动态内容
- ❌ 不支持运行时模板变量替换

### WordPress
- ✅ 支持动态代码执行（PHP）
- ❌ 安全风险：用户代码直接执行
- ❌ 性能差：需要逐次解析

### Hexo
- ✅ 静态生成，编译时完成
- ❌ 不支持动态配置
- ✅ 性能最优

### Sonic（推荐做法）
- ✅ 编译一次，高性能
- ✅ 后端处理变量，安全可控
- ✅ 灵活性与安全的平衡
- ✅ 事件系统支持扩展

---

## 问题 4：如何在评论框架等场景中实现？

### 用例：Artalk 评论框

**需求：** 用户在后台配置 Artalk 的初始化代码

**步骤 1：定义选项**
```go
// model/property/comment.go
var CommentCode = Property{
    KeyValue: "comment_code",
    DefaultValue: `<div id="comment"></div>
<script>
  Artalk.init({
    el: '#comment',
    pageKey: window.location.pathname
  });
</script>`,
    Kind: reflect.String,
}
```

**步骤 2：后端处理（可选，如果需要动态值）**
```go
// handler/content/post.go
func (h *PostHandler) GetPost(ctx *gin.Context) (interface{}, error) {
    post, _ := h.PostService.GetBySlug(ctx, slug)
    
    // 从数据库获取选项
    commentCode := h.OptionService.GetOrByDefault(
        ctx,
        property.CommentCode,
    ).(string)
    
    // 如果需要动态值，在后端替换
  // （可选步骤）
    commentCode = strings.ReplaceAll(
        commentCode,
        "window.location.pathname",
        fmt.Sprintf("'%s'", post.FullPath),
    )
    
    model := template.Model{
        "post": post,
        "comment_code": commentCode,
    }
    
    return h.Template.ExecuteTemplate(ctx.Writer, "post", model)
}
```

**步骤 3：模板使用**
```tmpl
<!-- theme/post.tmpl -->
<!DOCTYPE html>
<html>
<head>
    <title>{{.post.Title}}</title>
</head>
<body>
    <article>
        <h1>{{.post.Title}}</h1>
        <div class="content">{{.post.Content}}</div>
  </article>
    
    <!-- 输出用户配置的评论框代码 -->
    {{noescape .comment_code}}
</body>
</html>
```

### 用例：Google Analytics

**需求：** 用户配置自己的 GA 统计代码

**步骤 1：选项定义**
```go
var StatisticsCode = Property{
    KeyValue: "blog_statistics_code",
    DefaultValue: "",
    Kind: reflect.String,
}
```

**步骤 2：模板使用（Sonic 官方已实现）**
```tmpl
<!-- resources/template/common/macro/common_macro.tmpl -->
{{define "global.statistics"}}
    {{noescape .options.blog_statistics_code}}
{{end}}

<!-- 在页面底部包含 -->
{{template "global.statistics" .}}
```

✅ 直接输出，无需后端处理

---

## 最佳实践总结表

| 功能 | 处理方式 | 适用场景 |
|------|--------|----|
| **Artalk 评论框** | 直接输出 | 库自己处理 pageKey |
| **GA 统计代码** | 直接输出 | 无需动态值 |
| **自定义 CSS** | 直接输出 | 纯 CSS，无变量 |
| **需要 URL 的脚本** | 后端替换 | 需要实际的文章 URL |
| **需要用户信息** | 后端替换 | 需要登录用户信息 |
| **多主题支持** | 文件生成 | 根据配置生成主题文件 |

---

## 核心要点

### ✅ DO（推荐）
- ✅ 在后端处理变量替换
- ✅ 使用预定义的选项字段
- ✅ 验证用户输入的内容
- ✅ 对动态值进行 HTML 转义
- ✅ 在模板中使用 `noescape` 输出代码

### ❌ DON'T（不推荐）
- ❌ 在模板中重新编译用户输入
- ❌ 在模板中进行复杂的字符串替换
- ❌ 直接执行用户输入的代码
- ❌ 跳过输入验证
- ❌ 在模板中处理业务逻辑

---

## 参考资源

- 📄 [完整技术分析](SONIC_TEMPLATE_VARIABLES_ANSWERS.md)
- 📋 [快速参考](SONIC_TEMPLATE_QUICK_REFERENCE.md)
- 📖 [模板源码](template/template.go)
- 📖 [事件系统](event/listener/template_config.go)
- 📖 [官方宏定义](resources/template/common/macro/common_macro.tmpl)

---

**更新日期：** 2026年2月20日  
**维护：** Sonic 社区  
**基于版本：** v1.0.0

