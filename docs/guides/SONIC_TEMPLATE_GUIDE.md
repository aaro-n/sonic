# 📚 Sonic 模板与动态代码指南

> 关于模板变量编译、动态代码处理的完整文档  
> 所有文档已整理到 `docs/sonic-template/` 文件夹

---

## 🚀 快速导航

所有相关文档都在 [`docs/sonic-template/`](docs/sonic-template/) 目录中：

| 文档 | 用途 | 阅读时间 |
|------|------|--------|
| [README_SONIC_DOCS.md](docs/sonic-template/README_SONIC_DOCS.md) | **🎯 总入口与快速导航** | 5分钟 |
| [SONIC_TEMPLATE_QUICK_REFERENCE.md](docs/sonic-template/SONIC_TEMPLATE_QUICK_REFERENCE.md) | **⚡ 快速参考** | 5分钟 |
| [SONIC_TEMPLATE_VARIABLES_ANSWERS.md](docs/sonic-template/SONIC_TEMPLATE_VARIABLES_ANSWERS.md) | **📚 完整技术分析** | 30分钟 |
| [SONIC_COMMUNITY_Q&A.md](docs/sonic-template/SONIC_COMMUNITY_Q&A.md) | **💬 社区问答版本** | 15分钟 |
| [SONIC_TEMPLATE_CODE_EXAMPLES.md](docs/sonic-template/SONIC_TEMPLATE_CODE_EXAMPLES.md) | **💻 代码示例** | 按需 |
| [SONIC_TEMPLATE_DOCUMENTATION_INDEX.md](docs/sonic-template/SONIC_TEMPLATE_DOCUMENTATION_INDEX.md) | **🗺️ 文档索引** | 10分钟 |

---

## ⚡ 30秒快速答案

### Q1: 用户输入的 `{{ .post.FullPath }}` 会被二次编译吗？
**A:** ❌ **不会** | `noescape` 只原样输出
### Q2: 需要手动替换变量吗？
**A:** 📌 **在后端处理** | 用 `strings.ReplaceAll`

### Q3: 能否创建动态模板文件？
**A:** ✅ **可以** | 通过 `OptionUpdateEvent` 事件
### Q4: 最佳实践是什么？
**A:** 📚 **后端处理 + 模板输出** | 与其他平台一致

---

## 🎯 我想...

- 🏃 **只有 5 分钟** → [快速参考](docs/sonic-template/SONIC_TEMPLATE_QUICK_REFERENCE.md)
- 📚 **有 30 分钟** → [完整分析](docs/sonic-template/SONIC_TEMPLATE_VARIABLES_ANSWERS.md)
- 💻 **要写代码** → [代码示例](docs/sonic-template/SONIC_TEMPLATE_CODE_EXAMPLES.md)
- 💬 **要回答问题** → [社区问答](docs/sonic-template/SONIC_COMMUNITY_Q&A.md)
- 🗺️ **需要导航** → [文档索引](docs/sonic-template/SONIC_TEMPLATE_DOCUMENTATION_INDEX.md)

---

## 📊 文档统计

- 📄 6 份主要文档
- 📝 40,000+ 字
- 💻 20+ 代码示例
- 🔗 8+ 源代码引用
- ✅ 4 个问题完整覆盖

---

**👉 [进入 docs/sonic-template 文件夹查看所有文档](docs/sonic-template/)**

---

*这些文档是为 Sonic 社区精心准备的完整指南。希望能帮助你！*
