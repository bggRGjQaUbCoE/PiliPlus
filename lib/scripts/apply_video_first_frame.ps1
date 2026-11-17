$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$taskPackages = Get-Content -LiteralPath "$taskRoot/.dart_tool/package_config.json" -Raw | ConvertFrom-Json
$taskVideo = $taskPackages.packages | Where-Object name -eq 'media_kit_video'
$taskVideoRoot = ([uri]$taskVideo.rootUri).LocalPath
$taskRepoRoot = (git -C $taskVideoRoot rev-parse --show-toplevel).Trim()
$taskPatch = "$PSScriptRoot/media_kit/first_frame.patch"
git -C $taskRepoRoot apply --reverse --check $taskPatch 2>$null
if ($LASTEXITCODE -ne 0) {
    git -C $taskRepoRoot apply --check $taskPatch
    if ($LASTEXITCODE -ne 0) { throw 'Video first-frame patch does not match dependency' }
    git -C $taskRepoRoot apply $taskPatch
    if ($LASTEXITCODE -ne 0) { throw 'Video first-frame patch failed' }
}
$taskMediaPatch = "$PSScriptRoot/media_kit/media_frame.patch"
git -C $taskRepoRoot apply --reverse --check $taskMediaPatch 2>$null
if ($LASTEXITCODE -ne 0) {
    git -C $taskRepoRoot apply --check $taskMediaPatch
    if ($LASTEXITCODE -ne 0) { throw 'Per-media frame patch does not match dependency' }
    git -C $taskRepoRoot apply $taskMediaPatch
    if ($LASTEXITCODE -ne 0) { throw 'Per-media frame patch failed' }
}
