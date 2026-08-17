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

$gradleFiles = @(Get-ChildItem -Path $cacheRoot -Recurse -File -Filter 'build.gradle' |
    Where-Object {
        $_.FullName -match 'media-kit-[^\\/]+[\\/]libs[\\/]android[\\/]media_kit_libs_android_video[\\/]android[\\/]build\.gradle$' -and
        (Select-String -Path $_.FullName -Pattern 'bggRGjQaUbCoE/libmpv-android-video-build/releases/download/vnext' -Quiet)
    })

if ($gradleFiles.Count -gt 1) {
    $packageConfigPath = Join-Path (Get-Location) '.dart_tool/package_config.json'
    if (Test-Path -LiteralPath $packageConfigPath) {
        $packageConfig = Get-Content -Raw -Encoding UTF8 $packageConfigPath |
            ConvertFrom-Json
        $package = $packageConfig.packages |
            Where-Object { $_.name -eq 'media_kit_libs_android_video' } |
            Select-Object -First 1
        if ($package -and $package.rootUri -match '^file:') {
            $packageRoot = ([Uri]$package.rootUri).LocalPath
            $gradleFiles = @($gradleFiles |
                Where-Object { $_.FullName.StartsWith($packageRoot, [StringComparison]::OrdinalIgnoreCase) })
        }
    }
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
$matchedCount = 0
foreach ($entry in $expected.GetEnumerator()) {
    $escapedName = [regex]::Escape($entry.Key)
    $pattern = '(?<prefix>"(?:name|url)"\s*:\s*"[^"\r\n]*' +
        $escapedName + '"\s*,\s*"md5"\s*:\s*")' +
        '(?<checksum>[0-9a-f]{32})(?<suffix>")'
    $matches = [regex]::Matches($content, $pattern)
    if ($matches.Count -ne 1) {
        throw "Expected exactly one checksum entry for $($entry.Key) in $path, found $($matches.Count)"
    }

    $matchedCount++
    if ($matches[0].Groups['checksum'].Value -eq $entry.Value) {
        continue
    }

    $replacement = '${prefix}' + $entry.Value + '${suffix}'
    $updated = [regex]::Replace($content, $pattern, $replacement, 1)
    if ($updated -ne $content) {
        $content = $updated
        $changed = $true
    }
}

if ($matchedCount -ne $expected.Count) {
    throw "Expected to validate $($expected.Count) media_kit checksums in $path, matched $matchedCount"
}

if ($changed) {
    Set-Content -Path $path -Value $content -Encoding UTF8 -NoNewline
    Write-Host "Updated media_kit native checksums in $path"
} else {
    Write-Host "media_kit native checksums already current in $path"
}
