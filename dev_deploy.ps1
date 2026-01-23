# dev_deploy.ps1
# 快速将当前插件代码部署到 Kodi Addons 目录进行测试

$addonId = "plugin.service.emby-next-gen"

# 尝试自动检测 Kodi Addons 路径
$possiblePaths = @(
    "$env:APPDATA\Kodi\addons",                                                                     # 标准安装版 (exe)
    "$env:LOCALAPPDATA\Packages\XBMCFoundation.Kodi_4n2hpmxwrvr6p\LocalCache\Roaming\Kodi\addons"   # UWP版
)

$kodiAddonsPath = $null

foreach ($path in $possiblePaths) {
    if (Test-Path -Path $path) {
        $kodiAddonsPath = $path
        Write-Host "Found Kodi addons directory at: $path" -ForegroundColor Green
        break
    }
}

if ($null -eq $kodiAddonsPath) {
    Write-Error "Could not find Kodi addons directory at any known location."
    exit 1
}

# 构建源路径和目标路径
$sourcePath = $PSScriptRoot
$destPath = Join-Path -Path $kodiAddonsPath -ChildPath $addonId

Write-Host "============================" -ForegroundColor Cyan
Write-Host "Deploying $addonId to Kodi" -ForegroundColor Cyan
Write-Host "Source: $sourcePath" -ForegroundColor Gray
Write-Host "Dest:   $destPath" -ForegroundColor Gray
Write-Host "============================" -ForegroundColor Cyan

# 检查目标目录是否存在，如果不存在则创建
if (-not (Test-Path -Path $destPath)) {
    Write-Host "Target directory does not exist. Creating..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $destPath | Out-Null
}

# 使用 Robocopy 镜像同步目录
# /MIR: 镜像目录树 (等于 /E 加 /PURGE)
# /XD: 排除目录 (.git, .idea, __pycache__, .vscode)
# /XF: 排除文件 (dev_deploy.ps1, .gitignore, *.pyc)
# /NDL: 不记录目录名
# /NFL: 不记录文件名
# /NJH: 不记录作业头
# /NJS: 不记录作业摘要
# /R:0 /W:0 : 失败不重试

$robocopyArgs = @(
    $sourcePath,
    $destPath,
    "/MIR",
    "/XD", ".git", ".idea", "__pycache__", ".vscode", "venv",
    "/XF", "dev_deploy.ps1", ".gitignore", "*.pyc", "*.pyo", ".DS_Store",
    "/R:0", "/W:0"
)

# 执行 Robocopy
Write-Host "Syncing files..." -ForegroundColor Green
& robocopy @robocopyArgs

# Robocopy 的退出代码比较特殊，< 8 就算成功
if ($LASTEXITCODE -lt 8) {
    Write-Host "`nDeployment Success!" -ForegroundColor Green
} else {
    Write-Host "`nDeployment Failed with error code $LASTEXITCODE" -ForegroundColor Red
}
