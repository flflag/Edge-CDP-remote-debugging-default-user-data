# Edge-CDP-remote-debugging-default-user-data

[![Release](https://img.shields.io/github/v/release/flflag/edge-cdp-remote-debugging-default-user-data?label=release&color=blue)](https://github.com/flflag/edge-cdp-remote-debugging-default-user-data/releases)
[![Downloads](https://img.shields.io/github/downloads/flflag/edge-cdp-remote-debugging-default-user-data/total?label=downloads&color=green)](https://github.com/flflag/edge-cdp-remote-debugging-default-user-data/releases)
[![License](https://img.shields.io/github/license/flflag/edge-cdp-remote-debugging-default-user-data?label=license&color=orange)](LICENSE)
[![Email](https://img.shields.io/badge/email-flflag@163.com-red)](mailto:flflag@163.com)

[English](README.md) | **中文**

一个 Windows PowerShell 工具，让 Edge 在**默认用户数据目录**上开启 **DevTools 远程调试（CDP）**，绕过 Chromium 136+ 禁止在默认配置文件上开启远程调试的安全限制。

## 🧩 问题背景

从 Chromium 136 开始（Chrome 和 Edge 均受影响），浏览器拒绝在默认用户数据目录上开启远程调试端口，报错为：

```text
DevTools remote debugging requires a non-default data directory. Specify this using --user-data-dir.
```

这意味着你无法在日常使用的浏览器配置文件上使用 CDP 工具（AI Agent、自动化框架、调试器）——也就是那个已经保存了你所有登录状态、书签、扩展和历史记录的配置文件。

## 💡 本工具的解决思路

与其对抗限制，不如改变 Edge 认定的“正式”数据目录：

1. 把 `User Data` 改名为 `My User Data`（改名不改变文件时间戳）。
2. 再把 `My User Data` 复制一份为 `User Data`，作为配置前的备份快照。
3. 设置注册表策略 `HKLM\SOFTWARE\Policies\Microsoft\Edge\UserDataDir` 指向 `My User Data`。

Edge 从此把 `My User Data` 当作它的正式数据目录。因为它不再是默认路径，Chromium 136 的限制不再生效，远程调试正常工作。

你的所有登录状态、书签、密码、扩展、历史记录、缓存和网站数据都完整保留。

## 📋 环境要求

- Windows 10 或 Windows 11
- Microsoft Edge 安装在默认位置
- 管理员权限（脚本需要写入 `HKLM` 注册表）

## 🚀 使用方法

### 配置

1. 从 [Releases 页面](../../releases) 下载最新版本。
2. 解压 zip。
3. 双击 `.bat` 文件。
4. 选择选项 `1`（配置）。
5. 输入端口，或直接回车使用默认端口 `9222`。
6. 弹出 UAC 窗口时点击 **是**。

配置完成后，桌面和开始菜单会各出现一个名为 `Edge remote debugging` 的快捷方式。

### 日常使用

| 场景 | 操作 |
|---|---|
| 平时自己用 | 任意方式启动 Edge 即可。 |
| 需要 AI Agent 接管 | 完全退出 Edge（包括托盘），再双击 `Edge remote debugging`。 |
| 切换回来 | 完全退出 Edge，再正常启动 Edge。 |

**为什么必须完全退出？** Edge 是单实例应用。如果已经有一个实例在运行，新的命令行参数会被转发给已有进程，调试端口不会开启。

### 回退

运行同一个 `.bat`，选择选项 `2`（回退）。回退会：

1. 关闭 Edge 及相关进程。
2. 列出与配置时相比消失的扩展（仅告知）。
3. 删除 `User Data` 备份。
4. 把 `My User Data` 改名回 `User Data`。
5. 删除注册表策略和两个快捷方式。

## ⚠️ 重要限制

- **这不是微软官方工具。** 这是一个社区变通方案，使用风险自负。
- 回退过程会删除 `User Data` 备份快照以完全恢复原状。如果你想保留它，请在回退前手动复制到别处。

## 🔧 原理说明（技术细节）

Chromium 136 引入了一项安全检查：当数据目录匹配默认路径时，远程调试被禁用。该检查使用路径规范化，因此尾随反斜杠、`..` 变体、目录联接（Junction）都无法绕过。

注册表策略 `UserDataDir` 改变了 Edge 对“默认目录”本身的认定。一旦设置，Edge 将无条件使用指定的路径，忽略任何 `--user-data-dir` 命令行参数。由于新路径不是内置默认值，安全检查得以通过。

## 📈 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=flflag/edge-cdp-remote-debugging-default-user-data&type=Date)](https://star-history.com/#flflag/edge-cdp-remote-debugging-default-user-data&Date)

## 📄 许可证

MIT
