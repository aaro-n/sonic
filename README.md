<p align="center">
   <img width="170" src="https://raw.githubusercontent.com/go-sonic/resources/master/logo/logo.svg" />
</p>

<p align="center"><b>Sonic </b> [ˈsɒnɪk], Sonic is a Go Blogging Platform. Simple and Powerful.</p>

<p align="center">
<a href="https://github.com/go-sonic/sonic/releases"><img alt="GitHub release" src="https://img.shields.io/github/release/go-sonic/sonic.svg?style=flat-square&include_prereleases" /></a>
<a href="https://github.com/go-sonic/sonic/releases"><img alt="GitHub All Releases" src="https://img.shields.io/github/downloads/go-sonic/sonic/total.svg?style=flat-square" /></a>
<a href="https://hub.docker.com/r/gosonic/sonic"><img alt="Docker pulls" src="https://img.shields.io/docker/pulls/gosonic/sonic?style=flat-square" /></a>
<a href="https://github.com/go-sonic/sonic/commits"><img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/go-sonic/sonic.svg?style=flat-square" /></a>
<br />
<a href="https://t.me/go_sonic">Telegram Channel</a>
</p>


English | [中文](doc/README_ZH.md)

## 📖 Introduction

Sonic means as fast as sound speed. Like its name, sonic is a high-performance blog system developed using golang.

Thanks to the [Halo](https://github.com/halo-dev) project team, who inspired this project. The front-end is a project fork from Halo.

## 🚀 Features:
- Support multiple types of databases: SQLite、MySQL(TODO: PostgreSQL)
- Small: The installation file is only 10mb size
- High-performance: Post details page can withstand 2500 QPS(Enviroment:   Intel Xeon Platinum 8260 4C 8G ,SQLite3)
- Support changing theme
- Support Linux、Windows、Mac OS. And Support x86、x64、Arm、Arm64、MIPS
- Object storage(MINIO、Google Cloud、AWS、AliYun)


## 🎊 Preview

![Default Theme](https://github.com/go-sonic/default-theme-anatole/raw/master/screenshot.png)

![Console](https://github.com/go-sonic/resources/raw/master/console-screenshot.png)

## 🧰 Install

**Download the latest installation package**
> Please pay attention to the operating os and instruction set  and the version
```bash
wget https://github.com/go-sonic/sonic/releases/latest/download/sonic-linux-amd64.zip -O sonic.zip
```
**Decompression**
```bash
unzip -d sonic sonic.zip
```
**Launch**
```bash
cd sonic
./sonic -config conf/config.yaml
```

**Initialization**


Open http://ip:port/admin#install

Next, you can access sonic through the browser.

The URL of the admin console is http://ip:port/admin

The default port is 8080.

## 🔨️  Build
**1. Pull Project**
```bash
git clone --recursive --depth 1 https://github.com/go-sonic/sonic
```
**2. Run**
```bash
cd sonic
go run main.go
```
> To compile this package on Windows, you must have the gcc compiler installed，for example the TDM-GCC Toolchain can be found ([here](https://jmeubank.github.io/tdm-gcc/)).

🚀 Done! Your project is now compiled and ready to use.

## Docker
See: https://hub.docker.com/r/gosonic/sonic

## Theme ecology

| Theme   | 
|---------|
| [Anatole](https://github.com/go-sonic/default-theme-anatole) |
| [Journal](https://github.com/hooxuu/sonic-theme-Journal) |
| [Clark](https://github.com/ClarkQAQ/sonic_theme_clark)   |
| [Earth](https://github.com/Meepoljdx/sonic-theme-earth) |
| [PaperMod](https://github.com/jakezhu9/sonic-theme-papermod) |
| [Tink](https://github.com/raisons/sonic-theme-tink) |

## TODO
- [ ] i18n
- [ ] PostgreSQL
- [ ] Better error handling
- [ ] Plugin(base on Wasm)
- [ ] Use new web framework([Hertz](https://github.com/cloudwego/hertz))

## 🤖 AI Assistant Knowledge Base

This project includes a hidden `.ai/` folder containing critical information for AI assistants and developers:

**For AI Assistants (GitHub Copilot, Claude, etc.):**
- 🚨 **MANDATORY**: Read `.ai/.INIT_REQUIRED` file at the start of every new conversation
- 📋 **THEN READ**: `.ai/MUST_READ_FIRST.md` for behavioral rules
- 📚 **REFERENCE**: `.ai/PROJECT_OVERVIEW.md`, `.ai/IMPORTANT_NOTES.md`, `.ai/ISSUES_AND_SOLUTIONS.md`

**Key Rules:**
- Every code modification MUST update `.ai/ISSUES_AND_SOLUTIONS.md`
- Every commit involving code changes MUST include `.ai/` updates
- NO EXCEPTIONS - even small changes require knowledge base updates

**Why?** To prevent:
- ❌ Repeating mistakes already solved
- ❌ Missing critical context about the project
- ❌ Incomplete commits without documenting changes
- ❌ Breaking established conventions

**For Human Contributors:** The `.ai/` folder is a knowledge base maintained by contributors to help AI assistants understand project context and constraints. You can reference it too!

## Contributing

Feel free to dive in! [Open an issue](https://github.com/go-sonic/sonic/issues) or submit PRs.

Sonic follows the [Contributor Covenant](http://contributor-covenant.org/version/1/3/0/) Code of Conduct.

### Contributors

This project exists thanks to all the people who contribute. 
<a href="https://github.com/go-sonic/sonic/graphs/contributors"><img src="https://opencollective.com/go-sonic/contributors.svg?width=890&button=false" /></a>

Special thanks to Evan (evanzhao@88.com), who designed the logo.

## 📄 License

Source code in `sonic` is available under the [MIT License](/LICENSE.md).

