param(
    [string]$platform = ""
)

# TODO: remove
# https://github.com/flutter/flutter/issues/182468
$ToolTipFix = "56956c33ef102ac0b5fc46b62bd2dd9f50a86616";

# TODO: remove
# https://github.com/flutter/flutter/issues/182281
$NewOverScrollIndicator = "362b1de29974ffc1ed6faa826e1df870d7bec75f";

$BottomSheetAndroidPatch = "lib/scripts/bottom_sheet_android.patch"

$ScrollViewPatch = "lib/scripts/scroll_view.patch"

$TextSelectionPatch = "lib/scripts/text_selection.patch"

$NavigationBarPatch = "lib/scripts/navigation_bar.patch"

$PaddingPatch = "lib/scripts/padding.patch"

# https://github.com/flutter/flutter/issues/56239
# ref https://github.com/flutter/flutter/pull/184549
$ImagePatch = "lib/scripts/image.patch"

# TODO: remove
# https://github.com/flutter/flutter/issues/90223
$ModalBarrierPatch = "lib/scripts/modal_barrier.patch"

# TODO: remove
# https://github.com/flutter/flutter/issues/182466
$MouseCursorPatch = "lib/scripts/mouse_cursor.patch"

Set-Location $env:FLUTTER_ROOT

$picks   = @()
$reverts = @()
$patches = @($ModalBarrierPatch, $TextSelectionPatch, $MouseCursorPatch,
            $NavigationBarPatch, $PaddingPatch, $ImagePatch)

switch ($platform.ToLower()) {
    "android" {
        $reverts += $NewOverScrollIndicator
        $patches += $BottomSheetAndroidPatch
        $patches += $ScrollViewPatch
    }
    "ios" {
        $patches += $ScrollViewPatch
    }
    "linux" {
        $picks += $ToolTipFix
    }
    "macos" {
        $picks += $ToolTipFix
    }
    "windows" {
        $picks += $ToolTipFix
    }
    default {}
}

git config --global user.name "ci"
git config --global user.email "example@example.com"

git reset --hard HEAD

foreach ($pick in $picks) {
    git stash
    git cherry-pick $pick --no-edit
    if ($LASTEXITCODE -eq 0) {
        git reset --soft HEAD~1
        Write-Host "$pick picked"
    }
    git stash pop
}

foreach ($revert in $reverts) {
    git stash
    git revert $revert --no-edit
    if ($LASTEXITCODE -eq 0) {
        git reset --soft HEAD~1
        Write-Host "$revert reverted"
    }
    git stash pop
}

foreach ($patch in $patches) {
    git apply "$env:GITHUB_WORKSPACE/$patch"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$patch applied"
    }
}

# TODO: remove
if ($platform.ToLower() -eq "android") {
    "69e31205362b4e59b7eb89b24797e687b4b67afe" | Set-Content -Path .\bin\internal\engine.version
    Remove-Item -Path ".\bin\cache" -Recurse -Force
    flutter --version
}