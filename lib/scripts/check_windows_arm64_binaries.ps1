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

if ($Failed) {
    throw 'Windows ARM64 PE machine check failed'
}

Write-Host 'Windows ARM64 PE machine check passed'
