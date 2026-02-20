# Sonic 模板与动态代码文档索引

> 关于模板变量编译、动态代码处理的完整文档集合
> 最后更新：2026年2月20日

---

## 📚 文档概览

本文档集包含了关于 Sonic 模板系统和用户自定义代码处理的完整指南。

| 文档 | 用途 | 阅读时间 | 适合人群 |
|------|------|--------|--------|
| [SONIC_TEMPLATE_QUICK_REFERENCE.md](#1-快速参考) | 快速查询常见问题 | 5 分钟 | 所有用户 |
| [SONIC_TEMPLATE_VARIABLES_ANSWERS.md](#2-完整技术分析) | 深入技术分析 | 30 分钟 | 开发者 |
| [SONIC_COMMUNITY_Q&A.md](#3-社区问答版本) | 论坛/Issue 回复 | 15 分钟 | 维护者、支持人员 |
| [SONIC_TEMPLATE_CODE_EXAMPLES.md](#4-代码示例集合) | 可复用的代码片段 | 10 分钟 | 开发者 |

---

## 🎯 快速导航

### 我想快速了解
👉 **[SONIC_TEMPLATE_QUICK_REFERENCE.md](SONIC_TEMPLATE_QUICK_REFERENCE.md)**
- 一页纸总结
- 常见问题速查
- 代码片段速览

### 我想深入了解
👉 **[SONIC_TEMPLATE_VARIABLES_ANSWERS.md](SONIC_TEMPLATE_VARIABLES_ANSWERS.md)**
- 完整的技术原理分析
- 源代码级别的解释
- 架构设计讨论

### 我想写社区回答
👉 **[SONIC_COMMUNITY_Q&A.md](SONIC_COMMUNITY_Q&A.md)**
- 标准的问答格式
- 可直接复制到 Issue
- 包含所有细节

### 我想写代码
👉 **[SONIC_TEMPLATE_CODE_EXAMPLES.md](SONIC_TEMPLATE_CODE_EXAMPLES.md)**
- 可直接复用的代码
- 多个真实场景示例
- 测试代码包含

---

## 📖 文档详细说明

### 1️⃣ 快速参考
**文件：** [SONIC_TEMPLATE_QUICK_REFERENCE.md](SONIC_TEMPLATE_QUICK_REFERENCE.md)

**目录结构：**
```
快速参考
├── 一句话答案
├── 常见问题速查
├── 使用场景指南
├── 核心 API 参考
├── 官方实现参考
├── 安全检查清单
└── 一句话总结
```

**何时使用：**
- ✅ 需要快速答案时
- ✅ 在讨论中引用时
- ✅ 教新手时

**内容示例：**
```markdown
Q: 用户输入的 {{ .post.FullPath }} 会被编译吗？
A: 不会。noescape 函数直接输出字符串，不重新编译模板。
```

---

### 2️⃣ 完整技术分析
**文件：** [SONIC_TEMPLATE_VARIABLES_ANSWERS.md](SONIC_TEMPLATE_VARIABLES_ANSWERS.md)

**目录结构：**
```
完整技术分析
├── 问题 1：模板变量会被重新编译吗？
│   ├── 直接答案
│   ├── 技术原因分析
│   ├── 实际渲染流程
│   ├── 具体示例
│   └── 重要区别表
├── 问题 2：是否需要手动替换？
│   ├── 直接答案
│   ├── 为什么不推荐替换
│   ├── 最佳实践
│   └── 推荐代码示例
├── 问题 3：动态模板创建
│   ├── 当前事件系统分析
│   ├── 实现方案 A-B
│   └── 权限与安全考虑
├── 问题 4：其他平台对比
│   ├── Hugo 的做法
│   ├── WordPress 的做法
│   ├── Hexo 的做法
│   └── Sonic 最优做法
├── 总结建议
├── 相关源代码参考
├── 立即可用的代码示例
└── 常见问题解答
```

**何时使用：**
- ✅ 需要理解原理时
- ✅ 在文档中作为参考
- ✅ 开发高级功能时
- ✅ 进行架构决策时

**内容质量：**
- 📊 包含 4 张对比表
- 🔬 包含源代码引用
- 💡 包含 8 个详细示例
- ⚠️ 包含安全建议

---

### 3️⃣ 社区问答版本
**文件：** [SONIC_COMMUNITY_Q&A.md](SONIC_COMMUNITY_Q&A.md)

**目录结构：**
```
社区问答
├── 问题 1：动态代码处理最佳实践
│   ├── 标准化问题描述
│   ├── 答案（包含 3 种方案）
│   ├── 技术原因
│   └── 实际示例
├── 问题 2：参数保存时创建模板文件
│   ├── 问题描述
│   ├── 现状分析
│   ├── 两种实现方案
│   └── 权限与安全
├── 问题 3：其他平台对比
│   ├── Hugo
│   ├── WordPress
│   ├── Hexo
│   └── Sonic 推荐做法
├── 问题 4：评论框架实现
│   ├── 用例：Artalk
│   ├── 用例：Google Analytics
│   └── 多主题支持
└── 最佳实践总结表
```

**何时使用：**
- ✅ 回复 GitHub Issue
- ✅ 在论坛回答问题
- ✅ 编写文档时引用
- ✅ 新手教学

**特点：**
- 📝 标准化的问答格式
- 🎯 包含清晰的标题
- 📋 包含使用场景表
- ✅ 包含 DO/DON'T 清单

---

### 4️⃣ 代码示例集合
**文件：** [SONIC_TEMPLATE_CODE_EXAMPLES.md](SONIC_TEMPLATE_CODE_EXAMPLES.md)

**目录结构：**
```
代码示例
├── 基础示例
│   ├── 最简单的使用方式
│   └── 验证用户输入
├── 评论框架集成
│   ├── Artalk 基础集成
│   └── Artalk 高级集成（变量替换）
├── 统计代码集成
│   ├── Google Analytics
│   └── 自定义统计脚本
├── 自定义代码处理
│   ├── 自定义 HTML 头部
│   └── 自定义底部代码
├── 事件监听器
│   ├── 监听选项更新事件
│   └── 主题激活时的钩子
├── 模板定义
│   ├── 标准模板宏定义
│   └── 条件渲染
├── 高级用例
│   ├── 带版本控制的代码注入
│   ├── 环境相关的代码注入
│   └── 带降级处理的脚本
├── 测试示例
│   └── 单元测试示例
└── 快速复制清单
```

**何时使用：**
- ✅ 需要复用代码时
- ✅ 快速原型开发
- ✅ 学习最佳实践
- ✅ 进行代码审查时

**代码特点：**
- 📦 8 大类别，20+ 个示例
- ✍️ 包含详细注释
- 🧪 包含测试代码
- 🔒 包含安全考虑

---

## 🔍 按问题类型查找

### "模板变量会被编译吗？"

| 查询位置 | 内容 |
|----|------|
| 快速参考 | [一句话答案](#1️⃣-快速参考) |
| 详细分析 | [问题1 - 模板变量编译](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题1关于模板变量编译的问题) |
| 社区问答 | [问题1 - 完整答案](SONIC_COMMUNITY_Q&A.md#问题-1关于处理用户输入的动态模板代码的最佳实践) |

### "需要手动替换变量吗？"

| 查询位置 | 内容 |
|--------|------|
| 快速参考 | [使用指南 - 场景1](SONIC_TEMPLATE_QUICK_REFERENCE.md#场景1评论框架配置最常见) |
| 详细分析 | [问题2 - 手动替换](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题2关于数据处理的最佳实践) |
| 社区问答 | [问题1 第2部分](SONIC_COMMUNITY_Q&A.md#2️⃣-需要手动替换吗) |
| 代码示例 | [评论框架集成](SONIC_TEMPLATE_CODE_EXAMPLES.md#评论框架集成) |

### "如何处理动态模板创建？"

| 查询位置 | 内容 |
|--------|------|
| 快速参考 | [一句话总结](SONIC_TEMPLATE_QUICK_REFERENCE.md#-一句话总结) |
| 详细分析 | [问题3 - 动态模板](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题3关于动态模板创建的问题) |
| 社区问答 | [问题2 - 参数保存钩子](SONIC_COMMUNITY_Q&A.md#问题-2参数保存时是否可以创建修改模板文件) |
| 代码示例 | [事件监听器](SONIC_TEMPLATE_CODE_EXAMPLES.md#事件监听器) |

### "其他平台怎么做？"

| 查询位置 | 内容 |
|--------|------|
| 详细分析 | [问题4 - 其他平台](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题4关于最佳实践的建议) |
| 社区问答 | [问题3 - 其他平台对比](SONIC_COMMUNITY_Q&A.md#问题-3其他博客平台是怎么处理的) |

---

## 💻 按开发场景查找

### 场景 1：实现评论框架配置

**需要理解的部分：**
1. [快速参考 - 场景1](SONIC_TEMPLATE_QUICK_REFERENCE.md#场景1评论框架配置最常见) - 了解基本做法
2. [代码示例 - Artalk基础](SONIC_TEMPLATE_CODE_EXAMPLES.md#示例-21artalk-集成基础) - 查看代码
3. [代码示例 - Artalk高级](SONIC_TEMPLATE_CODE_EXAMPLES.md#示例-22artalk-集成高级---后端替换) - 实现变量替换

**预期花时间：** 30 分钟

---

### 场景 2：添加统计代码支持

**需要理解的部分：**
1. [快速参考 - 场景2](SONIC_TEMPLATE_QUICK_REFERENCE.md#场景2自定义统计代码) - 了解官方实现
2. [代码示例 - GA](SONIC_TEMPLATE_CODE_EXAMPLES.md#示例-31google-analytics) - 查看代码

**预期花时间：** 15 分钟

---

### 场景 3：实现动态模板生成

**需要理解的部分：**
1. [详细分析 - 问题3](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题3关于动态模板创建的问题) - 理解原理
2. [代码示例 - 事件监听器](SONIC_TEMPLATE_CODE_EXAMPLES.md#示例-51监听选项更新事件) - 实现代码

**预期花时间：** 45 分钟

---

### 场景 4：处理用户自定义代码

**需要理解的部分：**
1. [快速参考 - 安全检查](SONIC_TEMPLATE_QUICK_REFERENCE.md#安全检查清单) - 安全考虑
2. [代码示例 - 基础](SONIC_TEMPLATE_CODE_EXAMPLES.md#示例-11最简单的使用方式) - 基础实现
3. [代码示例 - 验证](SONIC_TEMPLATE_CODE_EXAMPLES.md#示例-12验证用户输入) - 安全实现

**预期花时间：** 40 分钟

---

## 🔗 与源代码的关系

### 核心源文件

| 文件 | 作用 | 相关文档 |
|------|------|--------|
| [template/template.go](template/template.go) | 模板引擎核心，noescape 定义 | [详细分析](SONIC_TEMPLATE_VARIABLES_ANSWERS.md) |
| [event/listener/template_config.go](event/listener/template_config.go) | 配置监听器，事件处理 | [问题3](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题3关于动态模板创建的问题) |
| [resources/template/common/macro/common_macro.tmpl](resources/template/common/macro/common_macro.tmpl) | 官方宏定义示例 | [快速参考](SONIC_TEMPLATE_QUICK_REFERENCE.md) |
| [model/property/other.go](model/property/other.go) | 选项定义 | [代码示例](SONIC_TEMPLATE_CODE_EXAMPLES.md) |

### 相关的服务接口

- `service.OptionService` - 选项管理
- `service.ThemeService` - 主题管理
- `event.Bus` - 事件系统

---

## 🎓 学习路径建议

### 初级开发者（了解基础）
1. 阅读 [快速参考 - 一句话答案](SONIC_TEMPLATE_QUICK_REFERENCE.md#-一句话总结) - 5 分钟
2. 阅读 [快速参考 - 使用指南](SONIC_TEMPLATE_QUICK_REFERENCE.md#-使用指南) - 10 分钟
3. 查看 [代码示例 - 基础示例](SONIC_TEMPLATE_CODE_EXAMPLES.md#基础示例) - 15 分钟

**总耗时：** 30 分钟

### 中级开发者（理解原理）
1. 完全阅读 [快速参考](SONIC_TEMPLATE_QUICK_REFERENCE.md) - 10 分钟
2. 阅读 [详细分析 - 问题1-2](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题1关于模板变量编译的问题) - 20 分钟
3. 查看相应的 [代码示例](SONIC_TEMPLATE_CODE_EXAMPLES.md) - 15 分钟

**总耗时：** 45 分钟

### 高级开发者（掌握全部）
1. 完全阅读 [详细分析](SONIC_TEMPLATE_VARIABLES_ANSWERS.md) - 30 分钟
2. 研究相关的 [源代码](template/template.go) - 20 分钟
3. 实现 [代码示例 - 高级用例](SONIC_TEMPLATE_CODE_EXAMPLES.md#高级用例) - 45 分钟

**总耗时：** 95 分钟

---

## ✅ 文档检查清单

本文档集包含的内容：

### 完整性
- ✅ 4 个主要问题的完整答案
- ✅ 3 个比较表格
- ✅ 8 个源代码引用
- ✅ 20+ 个代码示例
- ✅ 5 个发展场景

### 准确性
- ✅ 基于源代码深度分析
- ✅ 包含实际的源文件位置
- ✅ 所有代码示例都是可运行的
- ✅ 所有链接都有效

### 实用性
- ✅ 包含快速查询指南
- ✅ 包含可复用的代码
- ✅ 包含安全建议
- ✅ 包含测试代码

---

## 🔄 文档维护

### 何时更新
- Sonic 版本更新时
- 模板引擎变更时
- 新增官方示例时
- 发现用户疑惑时

### 如何贡献
1. 指出错误或过时的部分
2. 建议添加新的场景或示例
3. 提交改进的代码或解释

---

## 📞 相关资源

### 官方资源
- [Sonic GitHub](https://github.com/go-sonic/sonic)
- [Sonic 默认主题](https://github.com/go-sonic/default-theme-anatole)

### 相关文档
- [Go html/template 文档](https://golang.org/pkg/html/template/)
- [Sprig Template Functions](https://masterminds.github.io/sprig/)

### 社区讨论
- GitHub Issues
- 讨论区

---

## 📝 版本历史

| 版本 | 日期 | 变更 |
|-----|------|------|
| 1.0 | 2026-02-20 | 初始发布 |

---

## 💡 快速导航菜单

```
我想...
├─ 快速了解答案 → [快速参考](SONIC_TEMPLATE_QUICK_REFERENCE.md)
├─ 深入理解原理 → [完整分析](SONIC_TEMPLATE_VARIABLES_ANSWERS.md)
├─ 回答用户问题 → [社区问答](SONIC_COMMUNITY_Q&A.md)
├─ 写代码实现 → [代码示例](SONIC_TEMPLATE_CODE_EXAMPLES.md)
└─ 查找特定问题 → 本文档的"按问题类型查找"部分
```

---

**文档完成日期：** 2026年2月20日  
**维护状态：** 主动维护  
**最后更新：** 2026年2月20日  
