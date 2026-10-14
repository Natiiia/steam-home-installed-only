# Home Installed Only — Windows / Millennium

[简体中文](README.md) | **English**

Current version: **0.3.1**. Fixes filtering after Steam moved the home code into `sp.js`, while retaining support for the previous file location. See the [changelog](CHANGELOG.md).

Hide uninstalled games from the Windows Steam Big Picture home screen. The plugin filters the game list used to generate home cards, so removed games leave no empty slots and cannot be selected with a controller. Your library remains unchanged.

## Installation

Requires Millennium with `.star` plugin loading and source hooks. The project template targets Millennium 3.4 or later. See the [official Millennium installation guide](https://docs.steambrew.app/users/getting-started/installation).

1. Download `home-installed-only.star` from this repository, or download the Windows installation ZIP from [GitHub Releases](https://github.com/Natiiia/steam-home-installed-only/releases).
2. Fully exit Steam, including its system tray process.
3. Copy the plugin into `millennium/plugins/` inside your Steam installation. For example: `C:\Program Files (x86)\Steam\millennium\plugins\home-installed-only.star`.
4. Start Steam, enable **Home Installed Only** in Millennium's plugin settings (ID: `local.home-installed-only`), then restart Steam and enter Big Picture mode.

The installation ZIP also includes `install.ps1`, which finds Steam through the Windows registry and copies the plugin. It does not change your enabled-plugin configuration; enable the plugin in Millennium after copying it.

## Using CSS Loader alongside the plugin

The home filter itself does not require additional launch arguments. In the tested Windows setup, CSS Loader Desktop needs a fixed CEF debugging port when running alongside Millennium. Fully exit Steam, then change the **Target** field of your usual Steam shortcut to:

```text
"YourSteamDirectory\steam.exe" -cef-enable-debugging -devtools-port 8080 -gamepadui
```

`-gamepadui` opens Big Picture directly; remove it if you prefer to start in desktop mode. Full developer mode (`-dev`) is not required in this setup. Opening the shortcut while Steam is already running will not apply new launch arguments. Other themes can remain enabled. Disable any earlier CSS that hides uninstalled home games to avoid applying both methods.

## Behavior

- Filters games before Steam applies its native 20-entry home limit.
- Keeps locally installed games (`installed === true`), non-Steam shortcuts, and Steam's running-app placeholder.
- Preserves Steam's existing home-list merging and sorting. It does not guarantee that every installed game appears on the home screen, and it does not replace the library.
- Does not delete games, modify library records, or rewrite Steam's JavaScript files on disk.
- Matches only the Big Picture recent-games home function. Steam updates that change this function may require an updated matching rule.

Windows version 0.3.0 was tested on the development device: uninstalled entries were removed, and the user confirmed the plugin worked. CSS Loader styles also loaded after removing `-dev`. Other Steam client versions require verification.

## Build and validation

Requires Node.js and pnpm:

```sh
pnpm install
pnpm run build
node validate.cjs
node validate.cjs "YourSteamDirectory/steamui"
```

The build produces `home-installed-only.star`. Validation without arguments checks filtering behavior. With a `steamui` path, it also checks that exactly one home function matches across the current chunks and that the patched JavaScript parses successfully. Steam client source files are not packaged or uploaded.

Runtime diagnostics in SharedJSContext: `window.__homeInstalledOnlySource`, containing `before`, `removed`, and `ids`.

## Uninstallation

Disable the plugin in Millennium and restart Steam. Alternatively, fully exit Steam and remove `millennium/plugins/home-installed-only.star`. Keep the required launch arguments if you continue using CSS Loader.

This repository publishes the Windows Millennium version. The SteamOS Decky version is a separate implementation and does not use this `.star` package.
