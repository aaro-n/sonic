# Sonic 模板与动态代码 - 代码示例集合

> 可直接复制使用的代码片段

---

## 目录
1. [基础示例](#基础示例)
2. [评论框架集成](#评论框架集成)
3. [统计代码集成](#统计代码集成)
4. [自定义代码处理](#自定义代码处理)
5. [事件监听器](#事件监听器)
6. [模板定义](#模板定义)
7. [高级用例](#高级用例)

---

## 基础示例

### 示例 1.1：最简单的使用方式

**场景：** 输出用户在后台输入的 HTML/JS 代码（无需替换变量）

```go
// handler/content/post.go
package content

import (
    "github.com/gin-gonic/gin"
    "github.com/aaro-n/sonic/service"
    "github.com/aaro-n/sonic/template"
    "github.com/aaro-n/sonic/model/property"
)

type PostHandler struct {
    OptionService service.ClientOptionService
    Template      *template.Template
}

func (h *PostHandler) GetPost(ctx *gin.Context) (interface{}, error) {
    slug := ctx.Param("slug")
    
    // 获取自定义代码（从选项表）
    customHead := h.OptionService.GetOrByDefault(
        ctx,
        property.CustomHead,
    ).(string)
    
    model := template.Model{
        "custom_head": customHead,
    }
    
    return model, nil
}
```

**模板：**
```tmpl
<!-- template/post.tmpl -->
<!DOCTYPE html>
<html>
<head>
    {{noescape .custom_head}}  <!-- 直接输出 -->
</head>
<body>
    ...
</body>
</html>
```

---

### 示例 1.2：验证用户输入

**场景：** 保存用户输入前进行验证

```go
// handler/admin/option.go
package admin

import (
    "github.com/gin-gonic/gin"
    "github.com/microcosm-cc/bluemonday"
    "github.com/aaro-n/sonic/service"
    "github.com/aaro-n/sonic/util/xerr"
)

type OptionHandler struct {
    OptionService service.OptionService
    Sanitizer     *bluemonday.Policy
}

// NewOptionHandler 初始化时创建 sanitizer
func NewOptionHandler(optionService service.OptionService) *OptionHandler {
    return &OptionHandler{
        OptionService: optionService,
        // 允许常见的 HTML 标签（a, img, script 等）
        // 但移除危险属性
        Sanitizer: bluemonday.UGCPolicy(),
    }
}

func (h *OptionHandler) SaveOption(ctx *gin.Context) (interface{}, error) {
    var req struct {
        Key   string `json:"key" binding:"required"`
        Value string `json:"value" binding:"required"`
    }
    
    if err := ctx.ShouldBindJSON(&req); err != nil {
        return nil, xerr.BadParam.New(err.Error())
    }
    
    // 对某些敏感字段进行清理
    if req.Key == "comment_code" || req.Key == "blog_custom_head" {
      // 保留 HTML，但移除危险属性
        req.Value = h.Sanitizer.Sanitize(req.Value)
    }
    
    // 保存选项
    err := h.OptionService.Save(ctx, map[string]string{
        req.Key: req.Value,
    })
    
    return nil, err
}
```

---

## 评论框架集成

### 示例 2.1：Artalk 集成（基础）

**场景：** 用户配置 Artalk 初始化代码，直接输出

**后端：**
```go
// handler/content/post.go
func (h *PostHandler) GetPost(ctx *gin.Context) (interface{}, error) {
    slug := ctx.Param("slug")
    post, err := h.PostService.GetBySlug(ctx, slug)
    if err != nil {
        return nil, err
    }
    
    // 获取用户配置的 Artalk 代码
    artalkCode := h.OptionService.GetOrByDefault(
     ctx,
        property.CommentCode,
    ).(string)
    
    model := template.Model{
        "post": post,
        "artalk_code": artalkCode,
    }
    
    return model, nil
}
```

**模板：**
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
    
    <!-- Artalk 评论框 -->
    {{noescape .artalk_code}}
</body>
</html>
```

**后台默认值配置：**
```yaml
# 在初始化选项时设置
comment_code: |
  <div id="artalk"></div>
  <script src="https://cdn.jsdelivr.net/npm/artalk"></script>
  <script>
    Artalk.init({
      el: '#artalk',
      pageKey: window.location.pathname,
      server: 'https://artalk.example.com'
    });
  </script>
```

---

### 示例 2.2：Artalk 集成（高级 - 后端替换）

**场景：** 用户输入中包含模板变量，后端进行替换

**后端：**
```go
// handler/content/post.go
import (
    "strings"
    "github.com/aaro-n/sonic/model/property"
)

type PostHandler struct {
    PostService   service.PostService
    OptionService service.ClientOptionService
    Template      *template.Template
}

// processCommentCode 处理评论框代码中的变量替换
func (h *PostHandler) processCommentCode(code string, post *vo.Post) string {
    replacements := map[string]string{
        "{{ .post.FullPath }}": post.FullPath,
        "{{ .post.Title }}":    post.Title,
        "{{ .post.ID }}":       strconv.Itoa(int(post.ID)),
    }
    
    result := code
    for placeholder, value := range replacements {
        result = strings.ReplaceAll(result, placeholder, value)
    }
    
    return result
}

func (h *PostHandler) GetPost(ctx *gin.Context) (interface{}, error) {
    slug := ctx.Param("slug")
    post, err := h.PostService.GetBySlug(ctx, slug)
    if err != nil {
        return nil, err
    }
    
    // 获取原始代码
    artalkCode := h.OptionService.GetOrByDefault(
        ctx,
        property.CommentCode,
    ).(string)
    
    // 处理变量替换
    artalkCode = h.processCommentCode(artalkCode, post)
    
    model := template.Model{
        "post": post,
        "artalk_code": artalkCode,  // 已处理
    }
    
    return model, nil
}
```

**模板（不变）：**
```tmpl
{{noescape .artalk_code}}
```

**后台可接受的配置：**
```yaml
comment_code: |
  <div id="artalk"></div>
  <script>
    Artalk.init({
      pageKey: '{{ .post.FullPath }}',  # 将被替换为 /blog/hello-world
      pageTitle: '{{ .post.Title }}',    # 将被替换为 Hello World
      el: '#artalk'
    });
  </script>
```

---

## 统计代码集成

### 示例 3.1：Google Analytics

**场景：** 用户输入 GA 统计代码

**后端：** 无需特殊处理

**模板（Sonic 官方实现）：**
```tmpl
<!-- resources/template/common/macro/common_macro.tmpl -->
{{- /* 统计代码 */ -}}
{{define "global.statistics"}}
    {{noescape .options.blog_statistics_code}}
{{end}}
```

**在页面底部使用：**
```tmpl
<!-- theme/footer.tmpl -->
{{define "footer"}}
    <footer>
        <p>© 2024 My Blog</p>
    </footer>
    {{template "global.statistics" .}}
{{end}}
```

**用户在后台输入：**
```html
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_ID');
</script>
```
---

### 示例 3.2：自定义统计脚本

**后端：**
```go
// handler/content/base.go
func (h *BaseHandler) addCommonModel(ctx *gin.Context, model template.Model) {
    // 添加统计相关数据
    statisticsCode := h.OptionService.GetOrByDefault(
        ctx,
        property.StatisticsCode,
    ).(string)
    
    model["statistics_code"] = statisticsCode
}
```

**模板：**
```tmpl
<!-- theme/layout.tmpl -->
<!DOCTYPE html>
<html>
<head>
    ...
</head>
<body>
    ...
    
    <!-- 统计代码 -->
    {{noescape .statistics_code}}
</body>
</html>
```

---

## 自定义代码处理

### 示例 4.1：自定义 HTML 头部代码

**场景：** 用户可在 `<head>` 中注入自定义代码（如 meta 标签、CSS 等）

**后端：**
```go
// handler/content/base.go
func (h *BaseHandler) addHeadModel(ctx *gin.Context, model template.Model) {
    customHead := h.OptionService.GetOrByDefault(
        ctx,
        property.CustomHead,
    ).(string)
    
    customContentHead := h.OptionService.GetOrByDefault(
        ctx,
        property.CustomContentHead,
    ).(string)
    
    model["custom_head"] = customHead
    model["custom_content_head"] = customContentHead
}
```

**模板：**
```tmpl
<!-- theme/header.tmpl -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    {{- /* 官方自定义头部代码 */ -}}
    {{noescape .custom_head}}
    
    {{- /* 仅在文章/页面中显示的自定义代码 */ -}}
    {{if or .is_post .is_sheet}}
        {{noescape .custom_content_head}}
    {{end}}
</head>
<body>
    ...
</body>
</html>
```

---

### 示例 4.2：自定义底部代码

**后端：**
```go
// handler/content/base.go
func (h *BaseHandler) addFooterModel(ctx *gin.Context, model template.Model) {
    footerInfo := h.OptionService.GetOrByDefault(
        ctx,
        property.FooterInfo,
    ).(string)
    
    model["footer_info"] = footerInfo
}
```

**模板：**
```tmpl
<!-- theme/footer.tmpl -->
{{define "footer"}}
    <footer>
        {{noescape .footer_info}}
    </footer>
{{end}}
```

**用户可输入的内容：**
```html
<p>Copyright © 2024 My Blog | <a href="/about">About</a></p>
```

---

## 事件监听器

### 示例 5.1：监听选项更新事件

**场景：** 当用户保存选项时，自动生成动态模板文件

**创建新文件：** `service/listener/option_hook.go`

```go
package listener

import (
    "context"
    "fmt"
    "os"
    "path/filepath"
    "go.uber.org/zap"
    "github.com/aaro-n/sonic/event"
    "github.com/aaro-n/sonic/service"
)

type OptionUpdateHookListener struct {
    ThemeService  service.ThemeService
    OptionService service.ClientOptionService
    Logger        *zap.Logger
}

func NewOptionUpdateHookListener(
    bus event.Bus,
    themeService service.ThemeService,
    optionService service.ClientOptionService,
    logger *zap.Logger,
) {
    listener := &OptionUpdateHookListener{
        ThemeService:  themeService,
        OptionService: optionService,
        Logger:        logger,
    }
    
    bus.Subscribe(event.OptionUpdateEventName, listener.OnOptionUpdate)
}

func (l *OptionUpdateHookListener) OnOptionUpdate(ctx context.Context, e event.Event) error {
    l.Logger.Info("option updated, processing dynamic templates")
    
    // 获取当前激活的主题
    theme, err := l.ThemeService.GetActivateTheme(ctx)
    if err != nil || theme == nil {
        return nil
    }
    
    // 创建生成的模板目录
    generatedDir := filepath.Join(theme.ThemePath, "generated")
    if err := os.MkdirAll(generatedDir, 0755); err != nil {
        l.Logger.Error("failed to create generated template dir", zap.Error(err))
        return err
    }
    
    // 处理评论代码
    if err := l.generateCommentTemplate(ctx, theme, generatedDir); err != nil {
        l.Logger.Error("failed to generate comment template", zap.Error(err))
    }
    
    // 处理统计代码
    if err := l.generateStatisticsTemplate(ctx, theme, generatedDir); err != nil {
        l.Logger.Error("failed to generate statistics template", zap.Error(err))
    }
    
    return nil
}

func (l *OptionUpdateHookListener) generateCommentTemplate(
    ctx context.Context,
    theme *dto.ThemeProperty,
    targetDir string,
) error {
    commentCode := l.OptionService.GetOrByDefault(
        ctx,
        property.CommentCode,
    ).(string)
    
    if commentCode == "" {
      return nil
    }
    
    // 生成模板定义
    templateContent := fmt.Sprintf(`{{- /* 自动生成的评论框模板 */ -}}
{{define "generated/comment"}}
    %s
{{end}}`, commentCode)
    
    // 写入文件
    filePath := filepath.Join(targetDir, "comment.tmpl")
    if err := os.WriteFile(filePath, []byte(templateContent), 0644); err != nil {
        return err
    }
    
    l.Logger.Info("comment template generated", zap.String("path", filePath))
    return nil
}

func (l *OptionUpdateHookListener) generateStatisticsTemplate(
    ctx context.Context,
  theme *dto.ThemeProperty,
    targetDir string,
) error {
    statsCode := l.OptionService.GetOrByDefault(
        ctx,
        property.StatisticsCode,
    ).(string)
    
    if statsCode == "" {
        return nil
    }
    
    templateContent := fmt.Sprintf(`{{- /* 自动生成的统计代码模板 */ -}}
{{define "generated/statistics"}}
    %s
{{end}}`, statsCode)
    
    filePath := filepath.Join(targetDir, "statistics.tmpl")
    if err := os.WriteFile(filePath, []byte(templateContent), 0644); err != nil {
        return err
    }
    
    l.Logger.Info("statistics template generated", zap.String("path", filePath))
    return nil
}
```

**在 DI 容器中注册（通常在 main.go 或 fx.go）：**

```go
// main.go 或 injection/fx.go
import "github.com/go-sonic/sonic/service/listener"

// ... 在 fx.Provide 中添加 ...
fx.Provide(listener.NewOptionUpdateHookListener)
```

---

### 示例 5.2：主题激活时的钩子

**场景：** 当用户切换主题时，自动重新生成动态模板

**代码：**

```go
// service/listener/theme_hook.go
package listener

import (
    "context"
    "go.uber.org/zap"
    "github.com/aaro-n/sonic/event"
)

type ThemeActivatedHookListener struct {
    optionHook *OptionUpdateHookListener
    Logger     *zap.Logger
}

func NewThemeActivatedHookListener(
    bus event.Bus,
    optionHook *OptionUpdateHookListener,
    logger *zap.Logger,
) {
    listener := &ThemeActivatedHookListener{
        optionHook: optionHook,
        Logger:     logger,
    }
    
    bus.Subscribe(event.ThemeActivatedEventName, listener.OnThemeActivated)
}

func (l *ThemeActivatedHookListener) OnThemeActivated(ctx context.Context, e event.Event) error {
    l.Logger.Info("theme activated, regenerating dynamic templates")
    // 重复调用选项更新钩子的逻辑
    return l.optionHook.OnOptionUpdate(ctx, e)
}
```

---

## 模板定义

### 示例 6.1：标准模板宏定义

**文件：** `theme/macro/custom_code.tmpl`

```tmpl
{{- /* 自定义代码宏定义 */ -}}

{{- /* 页面头部 */ -}}
{{define "macro.custom_head"}}
    {{noescape .options.blog_custom_head}}
{{end}}

{{- /* 内容头部（仅在文章/页面中） */ -}}
{{define "macro.custom_content_head"}}
    {{if or .is_post .is_sheet}}
        {{noescape .options.blog_custom_content_head}}
    {{end}}

{{- /* 统计代码 */ -}}
{{define "macro.statistics"}}
    {{noescape .options.blog_statistics_code}}
{{end}}

{{- /* 页脚信息 */ -}}
{{define "macro.footer_info"}}
  {{noescape .options.blog_footer_info}}
{{end}}
```

**在 base.tmpl 中使用：**

```tmpl
<!-- theme/base.tmpl -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    {{template "macro.custom_head" .}}
    {{template "macro.custom_content_head" .}}
</head>
<body>
    {{block "content" .}}{{end}}
    
    <footer>
        {{template "macro.footer_info" .}}
        {{template "macro.statistics" .}}
    </footer>
</body>
</html>
```

---

### 示例 6.2：条件渲染（基于功能开关）

**模板：**

```tmpl
<!-- theme/post.tmpl -->
<!DOCTYPE html>
<html>
<head>
    <title>{{.post.Title}}</title>
    {{template "macro.custom_head" .}}
</head>
<body>
    <article>
     <h1>{{.post.Title}}</h1>
        <div class="content">{{.post.Content}}</div>
    </article>
    
    {{- /* 仅在允许评论时显示 */ -}}
    {{if not .post.DisallowComment}}
        {{noescape .comment_code}}
    {{end}}
    
    {{- /* 仅在已启用统计时显示 */ -}}
    {{if .options.statistics_enabled}}
      {{noescape .options.blog_statistics_code}}
    {{end}}
</body>
</html>
```

---

## 高级用例

### 示例 7.1：带版本控制的代码注入

**场景：** 管理不同版本的脚本，避免缓存问题

**后端：**

```go
// util/script_version.go
package util

import (
    "crypto/md5"
    "fmt"
    "io"
)

// GetScriptHash 计算脚本的 hash 值
func GetScriptHash(script string) string {
    h := md5.New()
    io.WriteString(h, script)
    return fmt.Sprintf("%x", h.Sum(nil))[:8]
}
```

**在选项中存储版本：**

```go
// handler/content/post.go
func (h *PostHandler) GetPost(ctx *gin.Context) (interface{}, error) {
    // ...
    
    commentCode := h.OptionService.GetOrByDefault(
        ctx,
        property.CommentCode,
    ).(string)
    
    // 添加版本 hash
    codeHash := util.GetScriptHash(commentCode)
    
    model := template.Model{
        "comment_code": commentCode,
        "comment_code_version": codeHash,  // 可用于 CDN 缓存破坏
  }
}
```

**模板：**

```tmpl
<!-- 在脚本 src 中使用版本号 -->
<script src="/assets/comment.js?v={{.comment_code_version}}"></script>
{{noescape .comment_code}}
```

---

### 示例 7.2：环境相关的代码注入

**场景：** 开发环境和生产环境使用不同的脚本

**后端：**

```go
// handler/content/post.go
func (h *PostHandler) GetPost(ctx *gin.Context) (interface{}, error) {
    // ...
    
    commentCode := h.OptionService.GetOrByDefault(
        ctx,
        property.CommentCode,
    ).(string)
    
  // 根据环境修改代码
    if h.Config.Server.Env == "development" {
        // 开发环境：添加调试代码
        commentCode = fmt.Sprintf(`
<script>console.log('Loading comment system...');</script>
%s
<script>console.log('Comment system loaded.');</script>
        `, commentCode)
    }
    
    model := template.Model{
        "comment_code": commentCode,
    }
}
```

---

### 示例 7.3：带降级处理的脚本

**后端：**

```go
// util/resilient_script.go
func AddFallback(primaryScript, fallbackScript string) string {
    return fmt.Sprintf(`
<script>
try {
    %s
} catch (error) {
    console.error('Primary script failed:', error);
    %s
}
</script>
    `, primaryScript, fallbackScript)
}
```

**使用：**

```go
// handler/content/post.go
commentCode := h.OptionService.GetOrByDefault(ctx, property.CommentCode).(string)

fallbackCode := `console.log('Using fallback comment system');`

safeCode := util.AddFallback(commentCode, fallbackCode)

model := template.Model{
    "comment_code": safeCode,
}
```

---

## 测试示例

### 示例 8.1：单元测试

```go
// handler/content/post_test.go
package content

import (
    "context"
    "strings"
    "testing"
)

func TestProcessCommentCode(t *testing.T) {
    handler := &PostHandler{}
    
    tests := []struct {
        name     string
        code     string
      post     *vo.Post
        expected string
    }{
        {
            name: "replace post full path",
         code: "pageKey: '{{ .post.FullPath }}'",
            post: &vo.Post{FullPath: "/blog/hello"},
            expected: "pageKey: '/blog/hello'",
        },
        {
          name: "replace post title",
        code: "title: '{{ .post.Title }}'",
            post: &vo.Post{Title: "Hello World"},
            expected: "title: 'Hello World'",
        },
        {
     name: "no placeholder",
      code: "el: '#comment'",
       post: &vo.Post{},
        expected: "el: '#comment'",
        },
    }
    
    for _, tc := range tests {
        t.Run(tc.name, func(t *testing.T) {
            result := handler.processCommentCode(tc.code, tc.post)
            if !strings.Contains(result, tc.expected) {
                t.Errorf("expected %q, got %q", tc.expected, result)
            }
        })
    }
}
```

---

## 快速复制清单

- [ ] 后端处理变量替换的函数
- [ ] 模板中使用 noescape 的宏定义
- [ ] 事件监听器的实现
- [ ] 单元测试
- [ ] 错误处理和日志记录

---

**最后更新：** 2026年2月20日  
**适用版本：** Sonic v1.0.0+
