param([Parameter(Mandatory=$true)][string]$FlutterRoot)
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path "$PSScriptRoot/../..").Path
$sdk = (Resolve-Path -LiteralPath $FlutterRoot).Path
# Apply only the existing common patches to a dedicated SDK/package cache.
# Unlike lib/scripts/patch.ps1, no global Git config, resets or deletions occur.
function Apply-VerifiedPatch([string]$root, [string]$patch) {
    git -C $root apply --check $patch 2>$null
    if ($LASTEXITCODE -eq 0) {
        git -C $root apply $patch
        if ($LASTEXITCODE -ne 0) { throw "Patch apply failed: $patch" }
        return
    }
    git -C $root apply --reverse --check $patch 2>$null
    if ($LASTEXITCODE -ne 0) { throw "Patch does not match baseline: $patch" }
}
$common = @('modal_barrier','text_selection','mouse_cursor','image_anim',
 'layout_builder','navigation_drawer','popup_menu','fab',
 'null_safety_for_selectable_region','selectable_region','editable_text',
 'text_field','scroll_position','scrollable','scrollable_gesture',
 'draggable_scrollable_sheet','scaffold','text','text_painter','sliver','refresh_indicator')
foreach ($name in $common) {
    Apply-VerifiedPatch $sdk "$repo/lib/scripts/$name.patch"
}
$configFile = "$repo/.dart_tool/package_config.json"
$config = Get-Content -LiteralPath $configFile -Raw | ConvertFrom-Json
$material = $config.packages | Where-Object name -EQ 'material_ui'
$baseUri = [UriBuilder]::new()
$baseUri.Scheme = 'file'
$baseUri.Host = ''
$baseUri.Path = (Resolve-Path $configFile).Path
$uri = [Uri]::new($baseUri.Uri, $material.rootUri)
$packageRoot = $uri.LocalPath
foreach ($name in @('modal_barrier_material','navigation_drawer','popup_menu','fab',
 'text_field','scaffold','refresh_indicator','tabs')) {
    Apply-VerifiedPatch $packageRoot "$repo/lib/scripts/material/$name.patch"
}
Write-Output 'PILIBOOST_TEST_ENVIRONMENT PASS existing-common-patches'
