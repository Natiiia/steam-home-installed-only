# Home Installed Only — Windows / Millennium

**简体中文** | [English](README.en.md)

当前版本：**0.3.1**。修复 Steam 更新后主页代码移至 `sp.js` 导致过滤失效的问题，兼容旧版文件位置。详见[变更记录](CHANGELOG.md)。

在 Windows Steam 大屏模式的主页隐藏未安装游戏。直接过滤主页生成卡片时使用的游戏列表，所以未安装游戏不会占据空位，也不会被手柄选中。库页面保持完整。

## 安装

需要支持 `.star` 插件和源代码钩子的 Millennium（本项目模板面向 3.4 及以上版本）。[Millennium 官方安装说明](https://docs.steambrew.app/users/getting-started/installation)。

1. 下载本仓库 `home-installed-only.star`，或下载 GitHub Release 中的安装包。
2. 完全退出 Steam。
3. 把文件复制到 Steam 安装目录下的 `millennium/plugins/`。例如 `C:\Program Files (x86)\Steam\millennium\plugins\home-installed-only.star`。
4. 启动 Steam，在 Millennium 的插件设置中启用 **Home Installed Only**（ID：`local.home-installed-only`），重启 Steam 后进入大屏模式。

安装包也包含 `install.ps1`，可通过 Windows 注册表自动查找 Steam 并复制插件。脚本不会修改插件启用配置；复制后仍需在 Millennium 设置里启用插件。

## 与 CSS Loader 同时使用

主页过滤插件本身不需要额外启动参数。在已验证的 Windows 环境中，CSS Loader Desktop 与 Millennium 同时运行时需要固定的 CEF 调试端口。完全退出 Steam，把平时使用的 Steam 快捷方式“目标”改为：

```text
"你的Steam目录\steam.exe" -cef-enable-debugging -devtools-port 8080 -gamepadui
```

`-gamepadui` 用于直接进入大屏模式，不需要时可以删除。本方案无需 `-dev` 开发者模式。若 Steam 已经运行，再打开带参数的快捷方式不会重新应用参数。其他主题可继续启用；旧的主页隐藏 CSS 建议关闭，避免重复处理。

## 行为

- 过滤发生在 Steam 原生的 20 个条目上限之前。
- 保留本机安装状态为 `installed === true` 的游戏、非 Steam 快捷方式和 Steam 运行中占位项。
- 沿用 Steam 原有主页列表合并及排序方式；不承诺列出所有已安装游戏，也不替换库。
- 不删除游戏，不更改库记录，不改写磁盘上的 Steam JavaScript 文件。
- 仅匹配大屏主页最近游戏函数。Steam 更新若改变函数结构，可能需要更新匹配规则。

Windows 0.3.0 已在开发设备验证：主页移除未安装条目，用户确认插件可用；去掉 `-dev` 后仍加载 CSS Loader 样式。其他 Steam 版本需要自行验证。

## 构建和检查

需要 Node.js 和 pnpm：

```sh
pnpm install
pnpm run build
node validate.cjs
node validate.cjs "你的Steam目录/steamui"
```

生成 `home-installed-only.star`。无参数检查过滤行为；提供 steamui 路径时，还检查当前所有 chunk 中唯一的主页函数匹配及修改后 JavaScript 的语法。Steam 客户端源文件不会被打包或上传。

诊断变量（SharedJSContext）：`window.__homeInstalledOnlySource`，包含 `before`、`removed`、`ids`。

## 卸载

在 Millennium 设置中禁用插件并重启 Steam；也可在完全退出 Steam 后移除 `millennium/plugins/home-installed-only.star`。保留 CSS Loader 时保留其所需启动参数。

此仓库发布 Windows Millennium 版。SteamOS Decky 版是独立实现，不使用这个 `.star` 安装包。
