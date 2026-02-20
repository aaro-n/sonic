# 📚 Sonic 模板与动态代码文档集

> 关于模板变量编译、动态代码处理的完整指南

**生成日期：** 2026年2月20日  
**总字数：** 40,000+  
**代码示例：** 20+  

---

## 🎯 这个文件夹里有什么？

这里包含了关于 Sonic 模板系统和用户自定义代码处理的 **6 份完整文档**。

### 📄 文档清单

#### 1. 📌 [README_SONIC_DOCS.md](README_SONIC_DOCS.md)
**总入口与快速导航**
- 30秒快速答案
- 5种使用场景
- 3条学习路径
- ⏱️ 阅读时间：5分钟

#### 2. ⚡ [SONIC_TEMPLATE_QUICK_REFERENCE.md](SONIC_TEMPLATE_QUICK_REFERENCE.md)
**快速参考指南**
- 4个问题的一句话答案
- 6个场景使用指南
- API 速查表
- 安全检查清单
- ⏱️ 阅读时间：5分钟

#### 3. 📚 [SONIC_TEMPLATE_VARIABLES_ANSWERS.md](SONIC_TEMPLATE_VARIABLES_ANSWERS.md)
**完整技术分析**
- 4个问题的详细答案
- 源代码级别的解释（8+ 个文件引用）
- 实际渲染流程分析
- 与其他平台对比
- ⏱️ 阅读时间：30分钟

#### 4. 💬 [SONIC_COMMUNITY_Q&A.md](SONIC_COMMUNITY_Q&A.md)
**社区问答版本**
- 标准化的问答格式
- 可直接复制到 GitHub Issue
- 最佳实践总结表
- DO/DON'T 清单
- ⏱️ 阅读时间：15分钟

#### 5. 💻 [SONIC_TEMPLATE_CODE_EXAMPLES.md](SONIC_TEMPLATE_CODE_EXAMPLES.md)
**代码示例集合**
- 20+ 个完整示例
- 8 大场景覆盖
- Artalk 评论框集成
- GA 统计代码集成
- 事件监听器实现
- 高级用例
- 测试代码
- ⏱️ 时间：按需查询

#### 6. 🗺️ [SONIC_TEMPLATE_DOCUMENTATION_INDEX.md](SONIC_TEMPLATE_DOCUMENTATION_INDEX.md)
**文档索引与导航**
- 文档总览表
- 快速导航菜单
- 按问题类型查找
- 按场景查找
- 学习路径规划
- ⏱️ 阅读时间：10分钟

---

## 🚀 快速开始

### 第一步：选择你的时间

**只有 5 分钟？**
→ [快速参考](SONIC_TEMPLATE_QUICK_REFERENCE.md) 的"快速问答"部分

**有 30 分钟？**
→ [README_SONIC_DOCS.md](README_SONIC_DOCS.md) 的推荐路径

**要写代码？**
→ [代码示例](SONIC_TEMPLATE_CODE_EXAMPLES.md)，按场景搜索

**完全迷茫？**
→ [文档索引](SONIC_TEMPLATE_DOCUMENTATION_INDEX.md) 的导航部分

---

## 💡 你的 4 个核心问题

### Q1: 模板变量会被二次编译吗？
**答：❌ 不会** | `noescape` 只原样输出  
👉 [详细分析](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题1关于模板变量编译的问题)

### Q2: 需要手动替换变量吗？
**答：📌 在后端处理** | 用 `strings.ReplaceAll`  
👉 [代码示例](SONIC_TEMPLATE_CODE_EXAMPLES.md#示例-22artalk-集成高级---后端替换)

### Q3: 能否创建动态模板文件？
**答：✅ 可以** | 通过 `OptionUpdateEvent` 事件  
👉 [完整实现](SONIC_TEMPLATE_CODE_EXAMPLES.md#示例-51监听选项更新事件)

### Q4: 最佳实践是什么？
**答：📚 后端处理 + 模板输出** | 与其他平台一致  
👉 [对比分析](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题4关于最佳实践的建议)

---

## 📊 内容统计

| 指标 | 数值 |
|------|------|
| 总文档数 | 6 份 |
| 总字数 | 40,000+ |
| 代码示例 | 20+ 个 |
| 源代码引用 | 8+ 个 |
| 对比表格 | 3 个 |
| 代码行数 | 2,000+ |
| 问题覆盖 | 4/4 ✅ |

---

## 🎓 推荐学习路径

### 路径 A：快速上手（15分钟）
```
1. 本文件           2分钟
2. 快速参考        5分钟
3. 场景指南        5分钟
4. 扫一眼代码      3分钟

结果：获得答案 ✅
```

### 路径 B：充分理解（1小时）
```
1. 快速参考       10分钟
2. 完整分析       25分钟
3. 代码示例       15分钟
4. 文档索引       10分钟

结果：理解原理 ✅
```

### 路径 C：精通掌握（2小时）
```
1. 完整分析       40分钟
2. 代码示例       30分钟
3. 文档索引       10分钟
4. 源代码阅读     20分钟
5. 总结和实践     20分钟

结果：完全掌握 ✅
```

---

## 🔗 目录结构

```
docs/sonic-template/
├── README.md (本文件)
├── README_SONIC_DOCS.md (总入口)
├── SONIC_TEMPLATE_QUICK_REFERENCE.md (快速参考)
├── SONIC_TEMPLATE_VARIABLES_ANSWERS.md (完整分析)
├── SONIC_COMMUNITY_Q&A.md (社区问答)
├── SONIC_TEMPLATE_CODE_EXAMPLES.md (代码示例)
├── SONIC_TEMPLATE_DOCUMENTATION_INDEX.md (文档索引)
├── SONIC_DOCUMENTATION_SUMMARY.md (生成报告)
└── DOCUMENTATION_GENERATED.md (完成报告)
```

---

## ⭐ 使用场景

### 场景 1：快速查询
```
需求：快速找到答案
时间：3-5分钟
文件：快速参考 → 快速问答部分
```

### 场景 2：深入学习
```
需求：完全理解原理
时间：30-40分钟
文件：完整分析 → 全部阅读
```

### 场景 3：社区回答
```
需求：在论坛/Issue 回答问题
时间：5-10分钟
文件：社区问答 → 复制相关部分
```

### 场景 4：代码实现
```
需求：实现新功能
时间：30分钟左右
文件：代码示例 → 找到场景 → 复制改进
```

---

## ✅ 文档特色

✅ **完整** - 回答了所有 4 个核心问题  
✅ **深入** - 源代码级别的技术分析  
✅ **实用** - 20+ 个可运行的代码示例  
✅ **易用** - 快速查询 + 深度学习 + 社区版本  
✅ **安全** - 包含完整的安全建议  
✅ **可维护** - 清晰的结构和交叉引用  

---

## 🔍 快速搜索

**"模板变量会被编译吗？"**  
👉 [快速参考 - Q1](SONIC_TEMPLATE_QUICK_REFERENCE.md#q1-用户输入的--postfullpath--会被编译吗)

**"需要手动替换吗？"**  
👉 [完整分析 - 问题2](SONIC_TEMPLATE_VARIABLES_ANSWERS.md#-问题2关于数据处理的最佳实践)

**"怎么创建动态模板？"**  
👉 [代码示例 - 事件监听](SONIC_TEMPLATE_CODE_EXAMPLES.md#事件监听器)

**"最佳实践是什么？"**  
👉 [社区问答 - 问题4](SONIC_COMMUNITY_Q&A.md#问题-4如何在评论框架等场景中实现)

---

## 📞 获取帮助

**找不到答案？**  
👉 [文档索引](SONIC_TEMPLATE_DOCUMENTATION_INDEX.md) - "按问题类型查找"

**想看代码？**  
👉 [代码示例](SONIC_TEMPLATE_CODE_EXAMPLES.md) - 按场景搜索

**想回答别人？**  
👉 [社区问答](SONIC_COMMUNITY_Q&A.md) - 直接复制

**想理解原理？**  
👉 [完整分析](SONIC_TEMPLATE_VARIABLES_ANSWERS.md) - 系统学习

---

## 🎁 相关资源

### Sonic 源文件
- [template/template.go](../../template/template.go) - 模板引擎核心
- [event/listener/template_config.go](../../event/listener/template_config.go) - 事件系统
- [resources/template/common/macro/common_macro.tmpl](../../resources/template/common/macro/common_macro.tmpl) - 官方宏定义

### 外部资源
- [Go html/template](https://golang.org/pkg/html/template/)
- [Sprig Functions](https://masterminds.github.io/sprig/)
- [Sonic GitHub](https://github.com/go-sonic/sonic)

---

## 📝 版本信息

| 项目 | 说明 |
|------|------|
| 生成日期 | 2026年2月20日 |
| Sonic 版本 | v1.0.0+ |
| 文档版本 | 1.0 |
| 维护状态 | 主动维护 |

---

## 🚀 现在就开始！

**推荐起点：**
1. 阅读 [README_SONIC_DOCS.md](README_SONIC_DOCS.md)（总入口，2分钟）
2. 按推荐选择查看对应文档

或者根据你的需求直接选择：
- ⚡ [快速参考](SONIC_TEMPLATE_QUICK_REFERENCE.md) - 5分钟快速查询
- 📚 [完整分析](SONIC_TEMPLATE_VARIABLES_ANSWERS.md) - 30分钟深入讲解
- 💬 [社区问答](SONIC_COMMUNITY_Q&A.md) - 可直接复用的回答
- 💻 [代码示例](SONIC_TEMPLATE_CODE_EXAMPLES.md) - 20+ 个可运行代码

---

**祝你使用愉快！** 🎉

*这是为 Sonic 社区精心准备的完整文档集。希望能帮助你解决关于模板和动态代码处理的所有疑惑！*
