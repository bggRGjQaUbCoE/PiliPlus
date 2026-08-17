$ErrorActionPreference = 'Stop'

$cacheRoot = if ($env:PUB_CACHE) {
    $env:PUB_CACHE
} elseif ($env:LOCALAPPDATA) {
    Join-Path $env:LOCALAPPDATA 'Pub\Cache'
} else {
    throw 'PUB_CACHE or LOCALAPPDATA is required'
}

$expected = [ordered]@{
    'default-arm64-v8a.jar' = '7b99319dd82f2f5af0471b4b6eea90f6'
    'default-armeabi-v7a.jar' = 'dca808ed563275ecdafcd2c002e7b5e6'
    'default-x86_64.jar' = 'aadbf500b0d7dcdd84ff3bff69bcfb93'
}

$gradleFiles = Get-ChildItem -Path $cacheRoot -Recurse -File -Filter 'build.gradle' |
    Where-Object {
        $_.FullName -match 'media-kit-[^\\/]+[\\/]libs[\\/]android[\\/]media_kit_libs_android_video[\\/]android[\\/]build\.gradle$' -and
        (Select-String -Path $_.FullName -Pattern 'bggRGjQaUbCoE/libmpv-android-video-build/releases/download/vnext' -Quiet)
    }
if ($gradleFiles.Count -ne 1) {
    throw "Expected exactly one media_kit Android build.gradle, found $($gradleFiles.Count) under $cacheRoot"
}

$path = $gradleFiles[0].FullName
$content = Get-Content -Raw -Encoding UTF8 $path
if ($content -notmatch 'https://github\.com/bggRGjQaUbCoE/libmpv-android-video-build/releases/download/vnext/') {
    throw "Unexpected media_kit source in $path"
}

$changed = $false
$updatedCount = 0
foreach ($entry in $expected.GetEnumerator()) {
    $escapedName = [regex]::Escape($entry.Key)
    $pattern = '(?<prefix>' + $escapedName + '",\s*"md5":\s*")[0-9a-f]{32}(?<suffix>")'
    $replacement = '${prefix}' + $entry.Value + '${suffix}'
    $updated = [regex]::Replace($content, $pattern, $replacement, 1)
    if ($updated -ne $content) {
        $content = $updated
        $changed = $true
        $updatedCount++
    }
}

if (!$changed -or $updatedCount -ne $expected.Count) {
    throw "Expected to update $($expected.Count) media_kit checksums in $path, updated $updatedCount"
}

Set-Content -Path $path -Value $content -Encoding UTF8 -NoNewline
Write-Host "Updated media_kit native checksums in $path"
