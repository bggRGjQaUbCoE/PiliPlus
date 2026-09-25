param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = 'Stop'

$ImageFileMachineArm64 = 0xAA64

function Get-PeMachine([byte[]]$Bytes) {
    if ($Bytes.Length -lt 64 -or $Bytes[0] -ne 0x4D -or $Bytes[1] -ne 0x5A) {
        return $null
    }
    $E = [BitConverter]::ToUInt32($Bytes, 0x3C)
    if (($E + 24) -gt $Bytes.Length) { return $null }
    if ([Text.Encoding]::ASCII.GetString($Bytes, [int]$E, 4) -ne "PE`0`0") { return $null }
    return [BitConverter]::ToUInt16($Bytes, [int]$E + 4)
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

Write-Host "Checking FEAT_DotProd (sdot/udot) in libmpv-2.dll"
$Mpv = $PeFiles | Where-Object { $_.Name -ieq 'libmpv-2.dll' } | Select-Object -First 1
if (-not $Mpv) {
    Write-Host "FAIL missing libmpv-2.dll"
    $Failed = $true
} else {
    $Bytes = [IO.File]::ReadAllBytes($Mpv.FullName)
    $Hits = 0
    $E = [BitConverter]::ToInt32($Bytes, 0x3C)
    $Nsec = [BitConverter]::ToUInt16($Bytes, $E + 6)
    $OptSz = [BitConverter]::ToUInt16($Bytes, $E + 20)
    $Sec0 = $E + 24 + $OptSz
    for ($i = 0; $i -lt $Nsec; $i++) {
        $Off = $Sec0 + ($i * 40)
        $Raw = [BitConverter]::ToInt32($Bytes, $Off + 20)
        $Rsz = [BitConverter]::ToInt32($Bytes, $Off + 16)
        $Chars = [BitConverter]::ToUInt32($Bytes, $Off + 36)
        if (($Chars -band 0x20000000) -eq 0 -or $Rsz -le 0) { continue }
        $End = [Math]::Min($Raw + $Rsz, $Bytes.Length)
        $N = $End - $Raw
        $N = $N - ($N % 4)
        for ($j = 0; $j -lt $N; $j += 4) {
            $W = [BitConverter]::ToUInt32($Bytes, $Raw + $j)
            if ((Test-SdotUdotVec $W) -or (Test-SdotUdotElem $W)) { $Hits++ }
        }
    }
    if ($Hits -gt 0) {
        Write-Host "FAIL libmpv-2.dll sdot_udot=$Hits (Snapdragon 850 WOA traps FEAT_DotProd)"
        $Failed = $true
    } else {
        Write-Host "OK   libmpv-2.dll no sdot/udot"
    }
}

if ($Failed) {
    throw 'Windows ARM64 PE / DotProd check failed'
}

Write-Host 'Windows ARM64 PE / DotProd check passed'
