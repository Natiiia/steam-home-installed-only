# Changelog / 变更记录

## 0.3.1 — 2026-10-14

### 简体中文

- 修复 Steam 更新后插件已启用但主页过滤不生效的问题：主页逻辑从 `chunk~…js` 移到了 `sp.js`，旧规则未能匹配新文件。
- 源码钩子同时支持 `sp.js` 和旧版 `chunk~…js`，仍仅修改匹配到的主页最近游戏函数。
- 验证脚本同时检查这两类文件，确认主页函数匹配唯一，并检查修改后的完整 JavaScript 语法。
- Windows 实机验证：19 个候选条目过滤为 7 个，移除 12 个未安装条目，剩余列表没有未安装游戏；CSS Loader 的 17 个样式继续加载，无需 `-dev`。

### English

- Fixed home filtering doing nothing despite the plugin being enabled after a Steam update. Steam moved the home logic from `chunk~…js` into `sp.js`, which the old file rule did not match.
- The source hook now supports both `sp.js` and legacy `chunk~…js` files while still targeting only the matched recent-games home function.
- Validation now scans both file types, verifies a unique home-function match, and parses the complete patched JavaScript.
- Verified on Windows: 19 candidate entries became 7, removing 12 uninstalled entries with none remaining in the output. All 17 CSS Loader styles still loaded without `-dev`.

## 0.3.0 — 2026-10-12

- 首次发布 Windows Millennium 版：在原生 20 个条目上限之前过滤主页未安装游戏，保留快捷方式和运行中占位项。
- 提供安装脚本、中英文说明及 CSS Loader 共用启动参数。
- Initial Windows Millennium release: filter uninstalled home games before the native 20-entry limit while retaining shortcuts and the running-app placeholder.
- Added an installation script, Chinese/English documentation, and launch arguments for running alongside CSS Loader.
