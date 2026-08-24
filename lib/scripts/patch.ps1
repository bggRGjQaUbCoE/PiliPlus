param(
    [string]$platform = ""
)

git config --global user.name "ci"
git config --global user.email "example@example.com"

# TODO: remove
# https://github.com/flutter/flutter/issues/182281
$NewOverScrollIndicator = "362b1de29974ffc1ed6faa826e1df870d7bec75f";

# set `gestureSettings`
$BottomSheetAndroidPatch = "lib/scripts/bottom_sheet_android.patch"

# https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1906
$BottomSheetIOSFlutterPatch = "lib/scripts/bottom_sheet_ios_flutter.patch"
$BottomSheetIOSPiliPlusPatch = "lib/scripts/bottom_sheet_ios_piliplus.patch"

# https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1662
# handle bottom scroll event
$ScrollViewPatch = "lib/scripts/scroll_view.patch"

# https://github.com/bggRGjQaUbCoE/PiliPlus/issues/2106
# use `TouchGestureRecognizer` on all platforms
$TextSelectionPatch = "lib/scripts/text_selection.patch"

# https://github.com/bggRGjQaUbCoE/PiliPlus/issues/1947
$NavigatorPatch = "lib/scripts/navigator.patch"

# https://github.com/bggRGjQaUbCoE/PiliPlus/issues/2107
$ImageAnimPatch = "lib/scripts/image_anim.patch"

# remove `_scheduleRebuild`
$LayoutBuilderPatch = "lib/scripts/layout_builder.patch"

# https://github.com/bggRGjQaUbCoE/PiliPlus/issues/2308
$NavigationDrawerPatch = "lib/scripts/navigation_drawer.patch"

# apply text color to icon color
$PopupMenuPatch = "lib/scripts/popup_menu.patch"

# remove `Hero` effect
$FABPatch = "lib/scripts/fab.patch"

# https://github.com/flutter/flutter/issues/139890
# https://github.com/flutter/flutter/issues/174689
# separator support
# clamp handle offset
# widgetspan selection support
# clear selection when tapping outside
# free selection if there is only one text
# clamp dragging selection behavior on Android
# show selection menu if secondary tap position is in text region on desktop
$SelectableRegionPatch = "lib/scripts/selectable_region.patch"

# https://github.com/flutter/flutter/issues/132047
# https://github.com/flutter/flutter/issues/174689
$EditableTextPatch = "lib/scripts/editable_text.patch"

# set `selectAllOnFocus` to `false` by default
$TextFieldPatch = "lib/scripts/text_field.patch"

# notify `userScrollDirection` only if position is actually changing
$ScrollPositionPatch = "lib/scripts/scroll_position.patch"

# expose `_shouldIgnorePointer`
$ScrollablePatch = "lib/scripts/scrollable.patch"

# expose
$ScaffoldPatch = "lib/scripts/scaffold.patch"

# fix nested scrollable gesture
# custom `HorizontalDragGestureRecognizer` support
$ScrollableGesturePatch = "lib/scripts/scrollable_gesture.patch"

# expose
$DraggableScrollableSheetPatch = "lib/scripts/draggable_scrollable_sheet.patch"

# expose
$TextPatch = "lib/scripts/text.patch"

# expose
$TextPainterPatch = "lib/scripts/text_painter.patch"

$SliverPatch = "lib/scripts/sliver.patch"

$RefreshIndicatorPatch = "lib/scripts/refresh_indicator.patch"

# TODO: remove
# https://github.com/flutter/flutter/issues/124078
# https://github.com/flutter/flutter/pull/183261
$NullSafetySelectableRegionPatch = "lib/scripts/null_safety_for_selectable_region.patch"

# TODO: remove
# https://github.com/flutter/flutter/issues/90223
$ModalBarrierPatch = "lib/scripts/modal_barrier.patch"

# TODO: remove
# https://github.com/flutter/flutter/issues/182466
$MouseCursorPatch = "lib/scripts/mouse_cursor.patch"

$GeetestIOSPatch = "lib/scripts/geetest_ios.patch"

if ($platform.ToLower() -eq "ios") {
    git apply $BottomSheetIOSPiliPlusPatch
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$BottomSheetIOSPiliPlusPatch applied"
    } else {
        throw "$LASTEXITCODE"
    }
    git apply $GeetestIOSPatch
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$GeetestIOSPatch applied"
    } else {
        throw "$LASTEXITCODE"
    }
}

Set-Location $env:FLUTTER_ROOT

$picks   = @()
$reverts = @()
$patches = @($ModalBarrierPatch, $TextSelectionPatch, $MouseCursorPatch,
            $ImageAnimPatch, $LayoutBuilderPatch, $NavigationDrawerPatch,
            $PopupMenuPatch, $FABPatch, $NullSafetySelectableRegionPatch,
            $SelectableRegionPatch, $EditableTextPatch, $TextFieldPatch,
            $ScrollPositionPatch, $ScrollablePatch, $ScrollableGesturePatch,
            $DraggableScrollableSheetPatch, $ScaffoldPatch, $TextPatch,
            $TextPainterPatch, $SliverPatch, $RefreshIndicatorPatch)

switch ($platform.ToLower()) {
    "android" {
        $patches += $BottomSheetAndroidPatch
        $patches += $ScrollViewPatch
        $patches += $NavigatorPatch

        git reset --hard HEAD
    }
    "ios" {
        $patches += $ScrollViewPatch
        $patches += $BottomSheetIOSFlutterPatch
        $patches += $NavigatorPatch
    }
    "linux" {
        git reset --hard HEAD
    }
    "macos" {
    }
    "windows" {
    }
    default {}
}

foreach ($pick in $picks) {
    git stash
    git cherry-pick $pick --no-edit
    if ($LASTEXITCODE -eq 0) {
        git reset --soft HEAD~1
        Write-Host "$pick picked"
    } else {
        throw "$LASTEXITCODE"
    }
    git stash pop
}

foreach ($revert in $reverts) {
    git stash
    git revert $revert --no-edit
    if ($LASTEXITCODE -eq 0) {
        git reset --soft HEAD~1
        Write-Host "$revert reverted"
    } else {
        throw "$LASTEXITCODE"
    }
    git stash pop
}

foreach ($patch in $patches) {
    git apply "$env:GITHUB_WORKSPACE/$patch"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$patch applied"
    } else {
        throw "$LASTEXITCODE"
    }
}

Set-Location $env:GITHUB_WORKSPACE

$BottomSheetAndroidPatchMaterial = "lib/scripts/material/bottom_sheet_android.patch"

$BottomSheetIOSFlutterMaterialPatchMaterial = "lib/scripts/material/bottom_sheet_ios_flutter_material.patch"

$ModalBarrierPatchMaterial = "lib/scripts/material/modal_barrier_material.patch"

$NavigationDrawerPatchMaterial = "lib/scripts/material/navigation_drawer.patch"

$PopupMenuPatchMaterial = "lib/scripts/material/popup_menu.patch"

$FABPatchMaterial = "lib/scripts/material/fab.patch"

$TextFieldPatchMaterial = "lib/scripts/material/text_field.patch"

$ScaffoldPatchMaterial = "lib/scripts/material/scaffold.patch"

$RefreshIndicatorPatchMaterial = "lib/scripts/material/refresh_indicator.patch"

$TabsPatchMaterial = "lib/scripts/material/tabs.patch"

$patches_material = @($ModalBarrierPatchMaterial, $NavigationDrawerPatchMaterial, $PopupMenuPatchMaterial,
                    $FABPatchMaterial, $TextFieldPatchMaterial, $ScaffoldPatchMaterial, $RefreshIndicatorPatchMaterial,
                    $TabsPatchMaterial)

$PubCacheDir = "~/.pub-cache"

switch ($platform.ToLower()) {
    "android" {
        $patches_material += $BottomSheetAndroidPatchMaterial
    }
    "ios" {
        $patches_material += $BottomSheetIOSFlutterMaterialPatchMaterial
    }
    "linux" {
    }
    "macos" {
    }
    "windows" {
        $PubCacheDir = "$env:LOCALAPPDATA/Pub/Cache"
    }
    default {}
}

try {
    $MaterialUiDir = Get-ChildItem "$PubCacheDir/hosted/pub.dev" -Directory |
        Where-Object { $_.Name -like "material_ui-*" } |
        Select-Object -Last 1

    if ($MaterialUiDir) {
        Remove-Item -Path $MaterialUiDir.FullName -Recurse -Force
    }
} catch {
}

flutter pub get

$MaterialUiDir = Get-ChildItem "$PubCacheDir/hosted/pub.dev" -Directory |
    Where-Object { $_.Name -like "material_ui-*" } |
    Select-Object -Last 1

if (-not $MaterialUiDir) {
    throw "material_ui package not found in pub cache"
}

Write-Host "material_ui dir: $($MaterialUiDir.FullName)"

Get-ChildItem -Path "$env:GITHUB_WORKSPACE/lib/scripts/material" -Filter *.patch | ForEach-Object {
    (Get-Content $_.FullName -Raw) -replace "`r`n", "`n" | 
        Set-Content -NoNewline $_.FullName
}

cd $MaterialUiDir.FullName

foreach ($patch in $patches_material) {
    git apply "$env:GITHUB_WORKSPACE/$patch"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$patch applied"
    } else {
        throw "$LASTEXITCODE"
    }
}

$BottomSheetIOSFlutterPatchCupertino = "lib/scripts/cupertino/bottom_sheet_ios_flutter.patch"

$patches_cupertino = @()

switch ($platform.ToLower()) {
    "android" {
    }
    "ios" {
        $patches_cupertino += $BottomSheetIOSFlutterPatchCupertino
    }
    "linux" {
    }
    "macos" {
    }
    "windows" {
    }
    default {}
}

$CupertinoUiDir = Get-ChildItem "$PubCacheDir/hosted/pub.dev" -Directory |
    Where-Object { $_.Name -like "cupertino_ui-*" } |
    Select-Object -Last 1

if (-not $CupertinoUiDir) {
    throw "cupertino_ui package not found in pub cache"
}

Write-Host "cupertino_ui dir: $($CupertinoUiDir.FullName)"

Get-ChildItem -Path "$env:GITHUB_WORKSPACE/lib/scripts/cupertino" -Filter *.patch | ForEach-Object {
    (Get-Content $_.FullName -Raw) -replace "`r`n", "`n" | 
        Set-Content -NoNewline $_.FullName
}

cd $CupertinoUiDir.FullName

foreach ($patch in $patches_cupertino) {
    git apply "$env:GITHUB_WORKSPACE/$patch"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$patch applied"
    } else {
        throw "$LASTEXITCODE"
    }
}
