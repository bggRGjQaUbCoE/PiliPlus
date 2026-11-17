$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$taskPackages = Get-Content -LiteralPath "$taskRoot/.dart_tool/package_config.json" -Raw | ConvertFrom-Json
$taskMaterial = $taskPackages.packages | Where-Object name -eq 'material_ui'
$taskMaterialRoot = ([uri]$taskMaterial.rootUri).LocalPath
$taskPatch = "$PSScriptRoot/material/advanced_materials.patch"
git -C $taskMaterialRoot apply --ignore-space-change --reverse --check $taskPatch 2>$null
if ($LASTEXITCODE -ne 0) {
    git -C $taskMaterialRoot apply --ignore-space-change --check $taskPatch
    if ($LASTEXITCODE -ne 0) { throw 'material_ui surface patch does not match the resolved dependency' }
    git -C $taskMaterialRoot apply --ignore-space-change $taskPatch
    if ($LASTEXITCODE -ne 0) { throw 'material_ui surface patch failed' }
}
