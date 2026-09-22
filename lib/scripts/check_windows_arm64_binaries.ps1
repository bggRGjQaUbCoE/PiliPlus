param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [string[]]$OpcodeFiles = @('libmpv-2.dll', 'libEGL.dll', 'libGLESv2.dll'),
    [switch]$AllowMissingOpcodeFiles
)

$ErrorActionPreference = 'Stop'

$ImageFileMachineArm64 = 0xAA64
$ImageScnMemExecute = 0x20000000

function Get-PeMachine([byte[]]$Bytes) {
    if ($Bytes.Length -lt 64 -or $Bytes[0] -ne 0x4D -or $Bytes[1] -ne 0x5A) {
        return $null
    }
    $E = [BitConverter]::ToUInt32($Bytes, 0x3C)
    if (($E + 24) -gt $Bytes.Length) { return $null }
    if ([Text.Encoding]::ASCII.GetString($Bytes, [int]$E, 4) -ne "PE`0`0") { return $null }
    return [BitConverter]::ToUInt16($Bytes, [int]$E + 4)
}

function Get-ExecutableSections([byte[]]$Bytes) {
    $E = [BitConverter]::ToInt32($Bytes, 0x3C)
    $Nsec = [BitConverter]::ToUInt16($Bytes, $E + 6)
    $OptSz = [BitConverter]::ToUInt16($Bytes, $E + 20)
    $Sec0 = $E + 24 + $OptSz
    $Secs = @()
    for ($i = 0; $i -lt $Nsec; $i++) {
        $Off = $Sec0 + ($i * 40)
        $Raw = [BitConverter]::ToInt32($Bytes, $Off + 20)
        $Rsz = [BitConverter]::ToInt32($Bytes, $Off + 16)
        $Chars = [BitConverter]::ToUInt32($Bytes, $Off + 36)
        if (($Chars -band $ImageScnMemExecute) -ne 0 -and $Rsz -gt 0) {
            $Secs += [pscustomobject]@{ Raw = $Raw; Rsz = $Rsz }
        }
    }
    return $Secs
}

function Test-Cas([uint32]$W) {
    return ((($W -shr 23) -band 0x7F) -eq 0x11) -and ((($W -shr 21) -band 1) -eq 1) -and ((($W -shr 15) -band 1) -eq 0) -and ((($W -shr 10) -band 0x3F) -eq 0x1F)
}

function Test-LdaddFamily([uint32]$W) {
    if ((($W -shr 24) -band 0x3F) -ne 0x38) { return $false }
    if ((($W -shr 21) -band 1) -ne 1) { return $false }
    return ((($W -shr 10) -band 0x1F) -le 7)
}

function Test-SdotUdotVec([uint32]$W) {
    if (($W -shr 31) -band 1) { return $false }
    if ((($W -shr 24) -band 0x1F) -ne 0x0E) { return $false }
    if ((($W -shr 21) -band 7) -ne 4) { return $false }
    return ((($W -shr 10) -band 0x3F) -eq 0x25)
}

function Test-SdotUdotElem([uint32]$W) {
    if (($W -shr 31) -band 1) { return $false }
    if ((($W -shr 24) -band 0x1F) -ne 0x0F) { return $false }
    if ((($W -shr 22) -band 3) -ne 2) { return $false }
    if ((($W -shr 12) -band 0xF) -ne 0x0E) { return $false }
    return ((($W -shr 10) -band 1) -eq 0)
}

function Scan-Arm64Opcodes([byte[]]$Bytes) {
    $Counts = @{
        cas           = 0
        ldadd_family  = 0
        sdot_udot     = 0
    }
    foreach ($Sec in (Get-ExecutableSections $Bytes)) {
        $Raw = $Sec.Raw
        $Rsz = $Sec.Rsz
        $End = [Math]::Min($Raw + $Rsz, $Bytes.Length)
        $N = $End - $Raw
        $N = $N - ($N % 4)
        for ($i = 0; $i -lt $N; $i += 4) {
            $W = [BitConverter]::ToUInt32($Bytes, $Raw + $i)
            if (Test-Cas $W) { $Counts.cas++ }
            if (Test-LdaddFamily $W) { $Counts.ldadd_family++ }
            if ((Test-SdotUdotVec $W) -or (Test-SdotUdotElem $W)) { $Counts.sdot_udot++ }
        }
    }
    return $Counts
}

if (-not (Test-Path $Path)) {
    throw "bundle not found: $Path"
}

$Failed = $false
$PeFiles = Get-ChildItem -Path $Path -Recurse -Include *.exe, *.dll
if (-not $PeFiles) {
    throw "no PE files under $Path"
}

Write-Host "Checking PE machine type under $Path"
foreach ($File in $PeFiles) {
    $Bytes = [IO.File]::ReadAllBytes($File.FullName)
    $Machine = Get-PeMachine $Bytes
    $Rel = $File.FullName.Substring((Resolve-Path $Path).Path.Length).TrimStart('\')
    if ($null -eq $Machine) {
        Write-Host "FAIL $Rel is not a PE file"
        $Failed = $true
        continue
    }
    if ($Machine -ne $ImageFileMachineArm64) {
        Write-Host ("FAIL {0} machine 0x{1:X4} (want ARM64 0xAA64)" -f $Rel, $Machine)
        $Failed = $true
        continue
    }
    Write-Host "OK   $Rel ARM64"
}

Write-Host "Checking ARMv8.1 / ARMv8.2 opcodes (cas, ldadd, sdot, udot)"
foreach ($Name in $OpcodeFiles) {
    $File = $PeFiles | Where-Object { $_.Name -ieq $Name } | Select-Object -First 1
    if (-not $File) {
        if ($AllowMissingOpcodeFiles) {
            Write-Host "SKIP missing $Name"
            continue
        }
        Write-Host "FAIL missing $Name"
        $Failed = $true
        continue
    }
    $Counts = Scan-Arm64Opcodes ([IO.File]::ReadAllBytes($File.FullName))
    $Hits = $Counts.cas + $Counts.ldadd_family + $Counts.sdot_udot
    if ($Hits -gt 0) {
        Write-Host ("FAIL {0} cas={1} ldadd={2} sdot_udot={3}" -f $File.Name, $Counts.cas, $Counts.ldadd_family, $Counts.sdot_udot)
        $Failed = $true
    } else {
        Write-Host "OK   $($File.Name) no v8.1/v8.2 opcodes"
    }
}

$Engine = $PeFiles | Where-Object { $_.Name -ieq 'flutter_windows.dll' } | Select-Object -First 1
if ($Engine) {
    $Counts = Scan-Arm64Opcodes ([IO.File]::ReadAllBytes($Engine.FullName))
    Write-Host ("INFO flutter_windows.dll cas={0} ldadd={1} sdot_udot={2}" -f $Counts.cas, $Counts.ldadd_family, $Counts.sdot_udot)
    if ($Counts.sdot_udot -gt 0) {
        Write-Host "FAIL flutter_windows.dll contains SDOT/UDOT; Flutter 3.47.5 cannot target Snapdragon 835"
        $Failed = $true
    } elseif (($Counts.cas + $Counts.ldadd_family) -gt 0) {
        Write-Host "WARN flutter_windows.dll has LSE encodings (Google prebuilt; may be CRT dispatch)"
    }
}

if ($Failed) {
    throw 'Windows ARM64 Snapdragon 835 baseline check failed'
}

Write-Host 'Windows ARM64 baseline check passed'
