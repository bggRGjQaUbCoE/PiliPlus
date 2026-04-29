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

# https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1906
$BottomSheetIOSFlutterPatch = "lib/scripts/bottom_sheet_ios_flutter.patch"
$BottomSheetIOSPiliPlusPatch = "lib/scripts/bottom_sheet_ios_piliplus.patch"

$ScrollViewPatch = "lib/scripts/scroll_view.patch"

$TextSelectionPatch = "lib/scripts/text_selection.patch"

# TODO: remove
# https://github.com/flutter/flutter/issues/90223
$ModalBarrierPatch = "lib/scripts/modal_barrier.patch"

# TODO: remove
# https://github.com/flutter/flutter/issues/182466
$MouseCursorPatch = "lib/scripts/mouse_cursor.patch"

if ($platform.ToLower() -eq "ios") {
    git apply $BottomSheetIOSPiliPlusPatch
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$BottomSheetIOSPiliPlusPatch applied"
    }
}

Set-Location $env:FLUTTER_ROOT

$picks   = @()
$reverts = @()
$patches = @($ModalBarrierPatch, $TextSelectionPatch, $MouseCursorPatch)

switch ($platform.ToLower()) {
    "android" {
        $reverts += $NewOverScrollIndicator
        $patches += $BottomSheetAndroidPatch
        $patches += $ScrollViewPatch
    }
    "ios" {
        $patches += $ScrollViewPatch
        $patches += $BottomSheetIOSFlutterPatch
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