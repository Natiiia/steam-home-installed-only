param([string]$SteamPath)
$ErrorActionPreference = 'Stop'
if (Get-Process -Name steam -ErrorAction SilentlyContinue) { throw 'Please fully exit Steam before installing.' }
if (-not $SteamPath) { $SteamPath = (Get-ItemProperty -LiteralPath 'HKCU:/Software/Valve/Steam' -Name SteamPath).SteamPath }
if (-not (Test-Path -LiteralPath (Join-Path $SteamPath 'steam.exe'))) { throw 'Steam executable not found. Supply -SteamPath.' }
$pluginDir = Join-Path $SteamPath 'millennium/plugins'
if (-not (Test-Path -LiteralPath (Join-Path $SteamPath 'millennium'))) { throw 'Install Millennium first.' }
$source = Join-Path $PSScriptRoot 'home-installed-only.star'
if (-not (Test-Path -LiteralPath $source)) { $source = Join-Path $PSScriptRoot 'releases/home-installed-only.star' }
if (-not (Test-Path -LiteralPath $source)) { throw 'home-installed-only.star is missing.' }
New-Item -ItemType Directory -Path $pluginDir -Force | Out-Null
$target = Join-Path $pluginDir 'home-installed-only.star'
if (Test-Path -LiteralPath $target) { Copy-Item -LiteralPath $target -Destination ($target + '.backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss')) }
Copy-Item -LiteralPath $source -Destination $target -Force
Write-Output 'Installed. Enable Home Installed Only in Millennium plugin settings, then restart Steam.'
