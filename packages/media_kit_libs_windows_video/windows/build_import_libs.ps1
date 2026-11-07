param(
    [Parameter(Mandatory)][string]$AngleDirectory,
    [Parameter(Mandatory)][string]$LibmpvDirectory,
    [Parameter(Mandatory)][string]$ToolDirectory
)

$ErrorActionPreference = 'Stop'
$dumpbin = Join-Path $ToolDirectory 'dumpbin.exe'
$librarian = Join-Path $ToolDirectory 'lib.exe'

foreach ($dll in @(
    (Join-Path $LibmpvDirectory 'libmpv-2.dll'),
    (Join-Path $AngleDirectory 'libEGL.dll'),
    (Join-Path $AngleDirectory 'libGLESv2.dll'),
    (Join-Path $AngleDirectory 'd3dcompiler_47.dll')
)) {
    $stream = [IO.File]::OpenRead($dll)
    $reader = [IO.BinaryReader]::new($stream)
    try {
        if ($reader.ReadUInt16() -ne 0x5A4D) {
            throw "Invalid DLL: $dll"
        }
        $stream.Position = 60
        $stream.Position = $reader.ReadInt32()
        if ($reader.ReadUInt32() -ne 0x4550 -or $reader.ReadUInt16() -ne 0xAA64) {
            throw "Expected an ARM64 PE DLL: $dll"
        }
    } finally {
        $reader.Dispose()
    }
}

foreach ($name in @('libEGL', 'libGLESv2')) {
    $dll = Join-Path $AngleDirectory "$name.dll"
    $library = Join-Path $AngleDirectory "lib/$name.dll.lib"
    if (Test-Path -LiteralPath $library) {
        continue
    }
    $output = & $dumpbin /nologo /exports $dll
    if ($LASTEXITCODE -ne 0) {
        throw "Could not read exports from $dll"
    }
    $exports = @($output | ForEach-Object {
        if ($_ -match '^\s+\d+\s+[0-9A-F]+\s+[0-9A-F]+\s+([A-Za-z_]\w*)\s*$') {
            $matches[1]
        }
    })
    if ($exports.Count -eq 0) {
        throw "No exports found in $dll"
    }
    $definition = Join-Path $AngleDirectory "lib/$name.def"
    @("LIBRARY $name.dll", 'EXPORTS') + $exports |
        Set-Content -LiteralPath $definition -Encoding ascii
    & $librarian /nologo /machine:ARM64 "/def:$definition" "/out:$library"
    if ($LASTEXITCODE -ne 0) {
        throw "Could not generate $library"
    }
}
