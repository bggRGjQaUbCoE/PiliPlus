param(
    [string]$FlutterRoot = $env:FLUTTER_ROOT,
    [string]$Arm64JavaHome = $env:PILI_WINDOWS_ARM64_JAVA_HOME,
    [switch]$NoPub
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$flutter = if ($FlutterRoot) {
    Join-Path $FlutterRoot 'bin/flutter.bat'
} else {
    (Get-Command flutter -ErrorAction Stop).Source
}
$buildArgs = @('build', 'windows', '--release')
if ($Arm64JavaHome) {
    if (-not (Test-Path -LiteralPath "$Arm64JavaHome/lib/jvm.lib")) {
        throw "ARM64 JDK import library not found: $Arm64JavaHome/lib/jvm.lib"
    }
    $env:PILI_WINDOWS_ARM64_JAVA_HOME = $Arm64JavaHome
}
if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -ne 'Arm64') {
    # Stock Flutter 3.47.7 only selects the host architecture. Cross builds
    # require flutter-windows-arm64.patch in a dedicated SDK checkout.
    $buildArgs += '--target-platform=windows-arm64'
}
if ($NoPub) {
    $buildArgs += '--no-pub'
}
if (Test-Path -LiteralPath (Join-Path $projectRoot 'pili_release.json')) {
    $buildArgs += '--dart-define-from-file=pili_release.json'
}

Push-Location $projectRoot
try {
    & $flutter @buildArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Windows ARM64 build failed with exit code $LASTEXITCODE"
    }
    $bundle = Join-Path $projectRoot 'build/windows/arm64/runner/Release'
    if (-not (Test-Path -LiteralPath "$bundle/piliplus.exe")) {
        throw "ARM64 executable not found at $bundle"
    }
    # Reject accidentally packaged x64 DLLs, including transitive native assets.
    Get-ChildItem -LiteralPath $bundle -Recurse -File |
        Where-Object Extension -In @('.exe', '.dll') |
        ForEach-Object {
            $stream = [IO.File]::OpenRead($_.FullName)
            $reader = [IO.BinaryReader]::new($stream)
            try {
                if ($reader.ReadUInt16() -ne 0x5A4D) {
                    throw "Invalid PE file: $($_.FullName)"
                }
                $stream.Position = 60
                $stream.Position = $reader.ReadInt32()
                if ($reader.ReadUInt32() -ne 0x4550) {
                    throw "Invalid PE signature: $($_.FullName)"
                }
                $machine = $reader.ReadUInt16()
                if ($machine -ne 0xAA64) {
                    throw "Expected ARM64, found PE machine 0x$('{0:X4}' -f $machine): $($_.FullName)"
                }
            } finally {
                $reader.Dispose()
            }
        }
    $aot = [IO.File]::ReadAllBytes((Join-Path $bundle 'data/app.so'))
    if ([BitConverter]::ToUInt32($aot, 0) -ne 0x464C457F -or
        $aot[4] -ne 2 -or $aot[5] -ne 1 -or
        [BitConverter]::ToUInt16($aot, 18) -ne 183) {
        throw 'Expected an AArch64 ELF64 AOT snapshot: data/app.so'
    }
    $versionLine = Select-String -LiteralPath pubspec.yaml -Pattern '^version:\s*(\S+)'
    $version = $versionLine.Matches[0].Groups[1].Value
    $destination = Join-Path $projectRoot "dist/PiliPlus_windows_${version}_arm64_portable.zip"
    New-Item -ItemType Directory -Path (Split-Path $destination) -Force | Out-Null
    Compress-Archive -Path "$bundle/*" -DestinationPath $destination -Force
    Write-Output "ARM64 portable package: $destination"
} finally {
    Pop-Location
}
