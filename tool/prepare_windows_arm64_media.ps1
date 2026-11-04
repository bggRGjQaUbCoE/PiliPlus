param(
  [Parameter(Mandatory = $true)][string]$MsysRoot,
  [string]$PackageRoot = ''
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
foreach ($header in 'EGL/egl.h', 'GLES2/gl2.h', 'GLES3/gl3.h', 'KHR/khrplatform.h') {
  if (!(Test-Path "$MsysRoot/include/$header")) {
    throw "Missing MSYS2 ARM64 header: $header. Install the headers, egl-headers and gles-headers packages."
  }
}
$repoRoot = Split-Path $PSScriptRoot -Parent
$buildRoot = Join-Path $repoRoot 'build/windows/arm64'
$mpvRoot = Join-Path $buildRoot 'libmpv'
$angleRoot = Join-Path $buildRoot 'ANGLE'
$toolsRoot = Join-Path $repoRoot '.build-tools'
New-Item -ItemType Directory -Path $mpvRoot, "$angleRoot/lib", "$angleRoot/include", $toolsRoot -Force | Out-Null

$archive = Join-Path $toolsRoot 'mpv-dev-aarch64-20260607-git-43b14a4.7z'
if (!(Test-Path $archive)) {
  Invoke-WebRequest 'https://github.com/bggRGjQaUbCoE/mpv-winbuild-cmake/releases/download/20260607/mpv-dev-aarch64-20260607-git-43b14a4.7z' -OutFile $archive
}
if ((Get-FileHash $archive -Algorithm SHA256).Hash -ne '9769066DE97AED0B100D5F1EB002C7C47BC9808EA3AD26C19FD3FA47EA73F335') {
  throw 'ARM64 mpv archive checksum mismatch.'
}
& tar -xf $archive -C $mpvRoot
if ($LASTEXITCODE -ne 0) { throw 'ARM64 mpv extraction failed.' }
if (Test-Path "$mpvRoot/include/mpv/client.h") {
  Copy-Item "$mpvRoot/include/mpv/*" "$mpvRoot/include" -Recurse -Force
}
foreach ($headers in 'EGL', 'GLES2', 'GLES3', 'KHR') {
  Copy-Item "$MsysRoot/include/$headers" "$angleRoot/include" -Recurse -Force
}
Copy-Item "$MsysRoot/lib/libEGL.dll.a" "$angleRoot/lib/libEGL.dll.lib" -Force
Copy-Item "$MsysRoot/lib/libGLESv2.dll.a" "$angleRoot/lib/libGLESv2.dll.lib" -Force
foreach ($dll in 'libEGL.dll', 'libGLESv2.dll', 'libc++.dll', 'zlib1.dll') {
  Copy-Item "$MsysRoot/bin/$dll" $angleRoot -Force
}
Copy-Item "$MsysRoot/share/licenses/angleproject/LICENSE" "$angleRoot/LICENSE.angle.txt" -Force
Copy-Item "$MsysRoot/share/licenses/libc++/LICENSE" "$angleRoot/LICENSE.libc++.txt" -Force
Copy-Item "$MsysRoot/share/licenses/zlib/LICENSE" "$angleRoot/LICENSE.zlib.txt" -Force

# Check the PE machine field before CMake can link or package the runtimes.
foreach ($dll in "$mpvRoot/libmpv-2.dll", "$angleRoot/libEGL.dll", "$angleRoot/libGLESv2.dll", "$angleRoot/libc++.dll", "$angleRoot/zlib1.dll") {
  $stream = [System.IO.File]::OpenRead($dll)
  $reader = [System.IO.BinaryReader]::new($stream)
  try {
    $stream.Position = 0x3c
    $peOffset = $reader.ReadInt32()
    $stream.Position = $peOffset
    if ($reader.ReadUInt32() -ne 0x00004550 -or $reader.ReadUInt16() -ne 0xaa64) {
      throw "Expected an ARM64 PE library: $dll"
    }
  } finally { $reader.Dispose() }
}
if (!$PackageRoot) {
  $configPath = Join-Path $repoRoot '.dart_tool/package_config.json'
  $config = Get-Content $configPath -Raw | ConvertFrom-Json
  $package = @($config.packages | Where-Object name -eq 'media_kit_libs_windows_video')
  if ($package.Count -ne 1) { throw 'media_kit_libs_windows_video package not found.' }
  $baseUri = [System.Uri]::new($configPath)
  $PackageRoot = [System.Uri]::new($baseUri, [string]$package[0].rootUri).LocalPath
}
# The upstream package hardcodes x64 downloads. Override only its CI cache copy.
Copy-Item (Join-Path $PSScriptRoot 'windows_arm64_media.cmake') (Join-Path $PackageRoot 'windows/CMakeLists.txt') -Force
Write-Output 'Prepared ARM64 mpv and ANGLE libraries and patched the CI package cache.'
