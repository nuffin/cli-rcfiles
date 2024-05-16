# RC Files

[English edition](README.md

本仓库包含一些命令行环境（cli）下常用的运行时配置（Runtime Configuration，RC）文件。从个人常用的内容里派生出来的，如果有其他需要的软件相关配置文件，请提 issue。

## 功能与主治

- 同步各种 rc 文件 - 一个仓库，到处使用

  欢迎克隆后生成自己的个人仓库，管理自己的配置偏好。（事实上，我还有一个个人仓库，保存一些私密的或者其他人用不到的内容）

  - 可以使用 `zprofiles update` 命令，拉取最新的 rc 文件配置。

- bash / zsh
  - 结构化配置文件管理
  - `clonegit` 命令，方便在任何目录工作时，都按照统一的仓库目录结构克隆代码。bash 和 zsh 通用
- tmux 配置文件
- vim 配置文件（vimrc）
- PowerShell
  - `Clone-Git` 命令，方便在任何目录工作时，都按照统一的仓库目录结构克隆代码。

## 如何使用

### macOS/Linux

克隆本仓库，然后执行 `./deploy.sh` 即可

有可能你需要修改一些变量定义，可以修改 `shrc.d/rc.vars` 文件

注意

- 目前，代码只支持在自动安装 Debian/Ubuntu 系列发行版盅所需软件，这个过程需要 apt 安装。
- 如果你有 IMAP ID 扩展的需求，比如 163 或 126 邮箱，可以使用我修改过的 getmail6 版本，我把他放在 [这个](https://github.com/nuffin/getmail6/) 仓库的 [feature/rfc2971-imap-id-extension](https://github.com/nuffin/getmail6/tree/feature/rfc2971-imap-id-extension) 分支了.

### Windows

Windows 系统中支持的功能不多，可以直接下载 `deploy-windows.ps` 文件并执行


## Notice

安装过程中，deploy 脚本绘自动备份原有系统生成的 rc 文件，并建立仓库中的文件的符号链接
