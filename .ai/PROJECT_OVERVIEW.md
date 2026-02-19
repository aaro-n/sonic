# Sonic 项目概览

## 项目基本信息

**项目名称**: Sonic - 高效博客平台
**开源地址**: https://github.com/aaro-n/sonic (fork from https://github.com/go-sonic/sonic)
**当前版本**: v1.1.5
**主要语言**: Go 1.21
**License**: MIT

## 项目描述

Sonic 是一个用Go语言开发的高性能博客平台，致力于成为最快速的开源博客系统。

### 核心特性
- 支持多数据库：SQLite、MySQL（待支持PostgreSQL）
- 体积小：安装文件仅10MB
- 高性能：详情页面可承受2500 QPS
- 支持主题切换
- 跨平台支持：Linux、Windows、Mac OS、多架构(x86、x64、Arm、Arm64、MIPS)
- 对象存储支持：MINIO、Google Cloud、AWS、AliYun

## 项目结构

```
sonic/
├── cmd/              # 命令行工具
├── config/           # 配置管理
├── consts/           # 常量定义
├── dal/              # 数据访问层（自动生成的GORM查询）
├── event/            # 事件总线系统
├── handler/          # HTTP请求处理
│   ├── admin/        # 后台管理API
│   ├── binding/      # 请求绑定
│   ├── content/      # 内容相关
│   └── middleware/   # 中间件
├── injection/        # 依赖注入配置
├── log/              # 日志管理
├── model/            # 数据模型
│   ├── dto/          # 数据传输对象
│   ├── entity/       # 数据库实体
│   ├── param/        # 请求参数
│   ├── projection/   # 数据投影
│   ├── property/     # 属性配置
│   └── vo/           # 值对象
├── resources/        # 静态资源
│   ├── admin/        # 后台UI资源
│   └── template/     # 主题模板
├── scripts/          # 构建脚本和Dockerfile
├── service/      # 业务逻辑层
│   ├── impl/         # 接口实现
│   └── storage/      # 存储相关
├── template/         # 模板处理
├── util/             # 工具函数
└── main.go           # 主入口
```

## 依赖关系

主要Go模块依赖：
- **Web框架**: gin-gonic/gin
- **ORM**: gorm/gorm
- **依赖注入**: go.uber.org/fx
- **日志**: go.uber.org/zap
- **配置**: spf13/viper
- **Git操作**: go-git/go-git
- **对象存储**: minio/minio-go
- **2FA**: pquerna/otp
- **二维码**: yeqown/go-qrcode

## 数据库

支持：
- SQLite（默认）
- MySQL
- 计划支持：PostgreSQL

## 前端

前端代码来自Console项目fork，集成到resources/admin目录

## 主题生态

官方主题仓库：
- Anatole（默认主题）
- Journal
- Clark
- Earth
- PaperMod
- Tink

## 重要配置文件

- `conf/config.yaml` - 应用配置
- `conf/config.dev.yaml` - 开发配置
- `go.mod` - Go模块依赖
- `.github/workflows/release-docker.yml` - Docker自动构建工作流
- `scripts/Dockerfile` - Docker构建文件

---
最后更新: 2026-02-20
