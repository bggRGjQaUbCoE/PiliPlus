$ErrorActionPreference = 'Stop'
$root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$packages = (Get-Content -LiteralPath "$root/.dart_tool/package_config.json" -Raw | ConvertFrom-Json).packages
foreach ($entry in @(
    @{ Name = 'cached_network_image_ce'; Patch = 'image_cache_budget.patch' },
    @{ Name = 'font_awesome_flutter'; Patch = 'unused_brands_font.patch' }
)) {
    $package = $packages | Where-Object name -eq $entry.Name
    $packageRoot = ([uri]$package.rootUri).LocalPath
    $repo = (git -C $packageRoot rev-parse --show-toplevel).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Cannot resolve checkout for $($entry.Name)" }
    $patch = Join-Path $PSScriptRoot $entry.Patch
    git -C $repo apply --reverse --check $patch 2>$null
    if ($LASTEXITCODE -eq 0) { continue }
    git -C $repo apply $patch
    if ($LASTEXITCODE -ne 0) { throw "Dependency patch failed for $($entry.Name)" }
}
