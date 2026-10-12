param(
  [string]$VulkanLoaderRoot = 'C:\msys64\clangarm64',
  [string]$DownloadPrefix = ''
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$buildTools = Join-Path $repoRoot '.build-tools'
$archive = Join-Path $buildTools 'mpv-dev-aarch64-20261001.7z'
$bundle = Join-Path $buildTools 'mpv-20261001'
$url = 'https://github.com/shinchiro/mpv-winbuild-cmake/releases/download/20261001/mpv-dev-aarch64-20261001-git-3186d369f9.7z'
$archiveHash = '0D12FA1FE3BFA19265FFCFC00EC5D90DA1972DBDE2B36596803BBDCECDC5B6F8'
$loader = Join-Path $VulkanLoaderRoot 'bin/vulkan-1.dll'
$loaderLicense = Join-Path $VulkanLoaderRoot 'share/licenses/vulkan-loader/LICENSE'
$loaderHash = '664E7DAD1AD21AE26CFBFAF467B6FF1FDC1D73A7F82AF62D48C90920A6A35D85'

if (!(Test-Path -LiteralPath $loaderLicense) -or
    (Get-FileHash -LiteralPath $loader -Algorithm SHA256).Hash -ne $loaderHash) {
  throw 'Requires the validated MSYS2 clangarm64 Vulkan loader 1.4.357.0-1 and its license.'
}
New-Item -ItemType Directory -Path $buildTools, $bundle -Force | Out-Null
if (!(Test-Path -LiteralPath $archive)) {
  Invoke-WebRequest -Uri ($DownloadPrefix + $url) -OutFile $archive
}
if ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash -ne $archiveHash) {
  throw 'mpv archive does not match the upstream SHA256.'
}
& tar -xf $archive -C $bundle
if ($LASTEXITCODE -ne 0) { throw 'Could not extract the mpv archive.' }
Copy-Item -LiteralPath $loader -Destination (Join-Path $bundle 'vulkan-1.dll') -Force
Copy-Item -LiteralPath $loaderLicense -Destination (Join-Path $bundle 'LICENSE.vulkan-loader.txt') -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'windows_arm64_mpv_notice.txt') -Destination (Join-Path $bundle 'MPV-BUNDLE.txt') -Force
Write-Output "Prepared validated ARM64 mpv bundle: $bundle"
