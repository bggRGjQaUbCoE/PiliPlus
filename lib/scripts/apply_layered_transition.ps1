$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$taskPackages = Get-Content -LiteralPath "$taskRoot/.dart_tool/package_config.json" -Raw | ConvertFrom-Json
$taskGet = $taskPackages.packages | Where-Object name -eq 'get'
$taskGetRoot = ([uri]$taskGet.rootUri).LocalPath
$taskPatch = "$PSScriptRoot/getx/layered_page_transition.patch"
git -C $taskGetRoot apply --ignore-space-change --reverse --check $taskPatch 2>$null
if ($LASTEXITCODE -ne 0) {
    git -C $taskGetRoot apply --ignore-space-change --check $taskPatch
    if ($LASTEXITCODE -ne 0) { throw 'GetX route transition patch does not match the resolved dependency' }
    git -C $taskGetRoot apply --ignore-space-change $taskPatch
    if ($LASTEXITCODE -ne 0) { throw 'GetX route transition patch failed' }
}
