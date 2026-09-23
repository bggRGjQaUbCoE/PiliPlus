param()

$ErrorActionPreference = 'Stop'

$VendorPath = Join-Path $env:GITHUB_WORKSPACE 'windows/packaging/arm64/vendor.json'
if (-not (Test-Path $VendorPath)) {
    throw "missing $VendorPath"
}

$Vendor = Get-Content -Raw -Path $VendorPath | ConvertFrom-Json
$Server = if ($env:GITHUB_SERVER_URL) { $env:GITHUB_SERVER_URL } else { 'https://github.com' }
$Repository = if ($env:GITHUB_REPOSITORY) { $env:GITHUB_REPOSITORY } else { 'bggRGjQaUbCoE/PiliPlus' }

function Expand-VendorUrl([string]$Url) {
    return $Url.Replace('{server}', $Server).Replace('{repository}', $Repository)
}

$PackageConfig = Join-Path $env:GITHUB_WORKSPACE '.dart_tool/package_config.json'
if (-not (Test-Path $PackageConfig)) {
    throw 'package_config.json not found; run flutter pub get first'
}

$Config = Get-Content -Raw -Path $PackageConfig | ConvertFrom-Json
$Pkg = $Config.packages | Where-Object { $_.name -eq 'media_kit_libs_windows_video' } | Select-Object -First 1
if (-not $Pkg) {
    throw 'media_kit_libs_windows_video not in package_config.json'
}

$RootUri = [Uri]$Pkg.rootUri
if ($RootUri.IsAbsoluteUri -and $RootUri.IsFile) {
    $PkgRoot = [Uri]::UnescapeDataString($RootUri.LocalPath)
} else {
    $PkgRoot = [IO.Path]::GetFullPath((Join-Path (Split-Path $PackageConfig) $Pkg.rootUri))
}
$CMakePath = Join-Path $PkgRoot 'windows/CMakeLists.txt'
if (-not (Test-Path $CMakePath)) {
    throw "CMakeLists.txt not found at $CMakePath"
}

function Get-RemoteMd5([string]$Url, [string]$Expected) {
    if (-not [string]::IsNullOrWhiteSpace($Expected)) {
        return $Expected.ToLowerInvariant()
    }
    $Tmp = Join-Path $env:TEMP ([IO.Path]::GetFileName($Url))
    Write-Host "pin MD5 is empty; downloading $Url to hash"
    Invoke-WebRequest -Uri $Url -OutFile $Tmp
    $Hash = (Get-FileHash -Algorithm MD5 -Path $Tmp).Hash.ToLowerInvariant()
    Write-Host "computed MD5 $Hash for $Url"
    return $Hash
}

$LibmpvUrl = Expand-VendorUrl $Vendor.libmpv.url
$AngleUrl = Expand-VendorUrl $Vendor.angle.url
$LibmpvMd5 = Get-RemoteMd5 $LibmpvUrl ([string]$Vendor.libmpv.md5)
$AngleMd5 = Get-RemoteMd5 $AngleUrl ([string]$Vendor.angle.md5)

$CMake = Get-Content -Raw -Path $CMakePath
$LibmpvBlock = @"
# libmpv archive containing the pre-built shared libraries & headers.
if(FLUTTER_TARGET_PLATFORM STREQUAL "windows-arm64")
  set(LIBMPV "$($Vendor.libmpv.filename)")
  set(LIBMPV_URL "$LibmpvUrl")
  set(LIBMPV_MD5 "$LibmpvMd5")
else()
  set(LIBMPV "mpv-dev-x86_64-20260607-git-43b14a4.7z")
  set(LIBMPV_URL "https://github.com/bggRGjQaUbCoE/mpv-winbuild-cmake/releases/download/20260607/`${LIBMPV}")
  set(LIBMPV_MD5 "b84900bbc6fcb995ca6a24f62bee671f")
endif()
"@

$AngleBlock = @"
# ANGLE archive containing the pre-built shared libraries & headers.
if(FLUTTER_TARGET_PLATFORM STREQUAL "windows-arm64")
  set(ANGLE "$($Vendor.angle.filename)")
  set(ANGLE_URL "$AngleUrl")
  set(ANGLE_MD5 "$AngleMd5")
else()
  set(ANGLE "ANGLE.7z")
  set(ANGLE_URL "https://github.com/alexmercerind/flutter-windows-ANGLE-OpenGL-ES/releases/download/v1.0.1/ANGLE.7z")
  set(ANGLE_MD5 "e866f13e8d552348058afaafe869b1ed")
endif()
"@

$CMake2 = [regex]::Replace(
    $CMake,
    '(?s)# libmpv archive containing the pre-built shared libraries & headers\.\r?\nset\(LIBMPV "[^"]+"\)\r?\n\r?\n# Download URL & MD5 hash of the libmpv archive\.\r?\nset\(LIBMPV_URL "[^"]+"\)\r?\nset\(LIBMPV_MD5 "[^"]+"\)',
    $LibmpvBlock.TrimEnd()
)
if ($CMake2 -eq $CMake) {
    throw 'failed to replace libmpv archive block in media_kit CMakeLists.txt'
}

$CMake3 = [regex]::Replace(
    $CMake2,
    '(?s)# ANGLE archive containing the pre-built shared libraries & headers\.\r?\nset\(ANGLE "[^"]+"\)\r?\n\r?\n# Download URL & MD5 hash of the ANGLE archive\.\r?\nset\(ANGLE_URL "[^"]+"\)\r?\nset\(ANGLE_MD5 "[^"]+"\)',
    $AngleBlock.TrimEnd()
)
if ($CMake3 -eq $CMake2) {
    throw 'failed to replace ANGLE archive block in media_kit CMakeLists.txt'
}

Set-Content -Path $CMakePath -Value $CMake3 -NoNewline
Write-Host "patched $CMakePath"
Write-Host "libmpv $($Vendor.libmpv.filename) $LibmpvUrl"
Write-Host "angle $($Vendor.angle.filename) $AngleUrl"
