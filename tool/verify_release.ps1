[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ApkPath,

    [switch]$AllowAlreadyDelivered
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$workspaceRoot = Split-Path -Parent $repoRoot
$baselinePath = Join-Path $scriptDir 'release_baseline.json'
$failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure([string]$Message) {
    $script:failures.Add($Message)
}

function Find-AndroidSdk {
    $candidates = [System.Collections.Generic.List[string]]::new()
    if ($env:ANDROID_HOME) {
        $candidates.Add($env:ANDROID_HOME)
    }
    if ($env:ANDROID_SDK_ROOT) {
        $candidates.Add($env:ANDROID_SDK_ROOT)
    }
    $candidates.Add((Join-Path $workspaceRoot 'toolchains\android-sdk'))

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate -PathType Container)) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }
    throw 'Android SDK not found. Set ANDROID_HOME or install the workspace toolchain.'
}

function Ensure-JavaHome {
    if ($env:JAVA_HOME -and (Test-Path -LiteralPath $env:JAVA_HOME -PathType Container)) {
        return
    }
    $candidate = Join-Path $workspaceRoot 'toolchains\jdk17\jdk-17.0.19+10'
    if (Test-Path -LiteralPath $candidate -PathType Container) {
        $env:JAVA_HOME = (Resolve-Path -LiteralPath $candidate).Path
        return
    }
    throw 'JAVA_HOME is not set and the workspace JDK 17 toolchain was not found.'
}

if (-not (Test-Path -LiteralPath $baselinePath -PathType Leaf)) {
    throw "Release baseline not found: $baselinePath"
}

$baseline = Get-Content -LiteralPath $baselinePath -Raw -Encoding UTF8 |
    ConvertFrom-Json
$resolvedApk = (Resolve-Path -LiteralPath $ApkPath).Path

$buildGradlePath = Join-Path $repoRoot 'android\app\build.gradle.kts'
$buildGradle = Get-Content -LiteralPath $buildGradlePath -Raw -Encoding UTF8
$expectedApplicationId = [string]$baseline.applicationId
$expectedNamespace = [string]$baseline.namespace
if ($buildGradle -notmatch [regex]::Escape("applicationId = `"$expectedApplicationId`"")) {
    Add-Failure "Android applicationId is not $expectedApplicationId."
}
if ($buildGradle -notmatch [regex]::Escape("namespace = `"$expectedNamespace`"")) {
    Add-Failure "Android namespace is not $expectedNamespace."
}

$pubspecPath = Join-Path $repoRoot 'pubspec.yaml'
$pubspec = Get-Content -LiteralPath $pubspecPath -Raw -Encoding UTF8
$pubspecVersion = [regex]::Match(
    $pubspec,
    '(?m)^version:\s*([^+\s]+)\+(\d+)\s*$'
)
if (-not $pubspecVersion.Success) {
    Add-Failure 'pubspec.yaml does not contain a valid versionName+versionCode value.'
    $sourceVersionName = ''
    $sourceVersionCode = 0L
} else {
    $sourceVersionName = $pubspecVersion.Groups[1].Value
    $sourceVersionCode = [long]$pubspecVersion.Groups[2].Value
}

$lastDeliveredVersionCode = [long]$baseline.lastDelivered.versionCode
if ($sourceVersionCode -lt $lastDeliveredVersionCode) {
    Add-Failure "versionCode $sourceVersionCode is below the delivered baseline $lastDeliveredVersionCode."
} elseif ($sourceVersionCode -eq $lastDeliveredVersionCode -and -not $AllowAlreadyDelivered) {
    Add-Failure "versionCode $sourceVersionCode was already delivered. Increment it before a new release."
}

$playSettingsPath = Join-Path $repoRoot 'lib\pages\setting\models\play_settings.dart'
$playSettings = Get-Content -LiteralPath $playSettingsPath -Raw -Encoding UTF8
if ($playSettings -notmatch '(?s)SettingBoxKey\.inAppMiniPlayer,\s*defaultVal:\s*false') {
    Add-Failure 'The in-app mini-player setting is not defaulted to false.'
}
$storagePrefPath = Join-Path $repoRoot 'lib\utils\storage_pref.dart'
$storagePref = Get-Content -LiteralPath $storagePrefPath -Raw -Encoding UTF8
if ($storagePref -notmatch '(?s)SettingBoxKey\.inAppMiniPlayer,\s*defaultValue:\s*false') {
    Add-Failure 'Pref.inAppMiniPlayer is not defaulted to false.'
}

$androidSdk = Find-AndroidSdk
$buildToolsRoot = Join-Path $androidSdk 'build-tools'
$buildTools = Get-ChildItem -LiteralPath $buildToolsRoot -Directory |
    Sort-Object Name -Descending |
    Select-Object -First 1
if (-not $buildTools) {
    throw "No Android build-tools installation found under $buildToolsRoot."
}
$aapt = Join-Path $buildTools.FullName 'aapt.exe'
$apksigner = Join-Path $buildTools.FullName 'apksigner.bat'
if (-not (Test-Path -LiteralPath $aapt -PathType Leaf)) {
    throw "aapt.exe not found: $aapt"
}
if (-not (Test-Path -LiteralPath $apksigner -PathType Leaf)) {
    throw "apksigner.bat not found: $apksigner"
}

$badgingOutput = (& $aapt dump badging $resolvedApk 2>&1 | Out-String)
if ($LASTEXITCODE -ne 0) {
    throw "aapt failed to inspect the APK:`n$badgingOutput"
}
$packageMatch = [regex]::Match(
    $badgingOutput,
    "package: name='([^']+)' versionCode='(\d+)' versionName='([^']+)'"
)
if (-not $packageMatch.Success) {
    Add-Failure 'Could not parse APK package metadata.'
    $apkApplicationId = ''
    $apkVersionCode = 0L
    $apkVersionName = ''
} else {
    $apkApplicationId = $packageMatch.Groups[1].Value
    $apkVersionCode = [long]$packageMatch.Groups[2].Value
    $apkVersionName = $packageMatch.Groups[3].Value
}

if ($apkApplicationId -ne $expectedApplicationId) {
    Add-Failure "APK applicationId is '$apkApplicationId', expected '$expectedApplicationId'."
}
$labelMatch = [regex]::Match($badgingOutput, "(?m)^application-label:'([^']*)'")
$apkApplicationLabel = if ($labelMatch.Success) { $labelMatch.Groups[1].Value } else { '' }
$expectedApplicationLabel = [string]$baseline.applicationLabel
if ($apkApplicationLabel -ne $expectedApplicationLabel) {
    Add-Failure "APK application label is '$apkApplicationLabel', expected '$expectedApplicationLabel'."
}
if ($apkVersionName -ne $sourceVersionName) {
    Add-Failure "APK versionName '$apkVersionName' does not match pubspec '$sourceVersionName'."
}
if ($apkVersionCode -ne $sourceVersionCode) {
    Add-Failure "APK versionCode '$apkVersionCode' does not match pubspec '$sourceVersionCode'."
}

$apkFileName = Split-Path -Leaf $resolvedApk
if (-not $apkFileName.StartsWith('pili++')) {
    Add-Failure "APK file name must start with 'pili++': $apkFileName"
}
$versionToken = "$apkVersionName-$apkVersionCode"
if (-not $apkFileName.Contains($versionToken)) {
    Add-Failure "APK file name does not contain '$versionToken': $apkFileName"
}
if (-not $apkFileName.Contains('release')) {
    Add-Failure "APK file name does not identify a release build: $apkFileName"
}

if ($apkFileName.Contains('universal')) {
    foreach ($abi in $baseline.requiredUniversalAbis) {
        if ($badgingOutput -notmatch "native-code:[^\r\n]*'$([regex]::Escape([string]$abi))'") {
            Add-Failure "Universal APK is missing required ABI '$abi'."
        }
    }
}

Ensure-JavaHome
$signingOutput = (& $apksigner verify --verbose --print-certs $resolvedApk 2>&1 |
    Out-String)
if ($LASTEXITCODE -ne 0) {
    Add-Failure "APK signature verification failed: $signingOutput"
}
$certificateMatch = [regex]::Match(
    $signingOutput,
    'Signer #1 certificate SHA-256 digest:\s*([0-9a-fA-F]+)'
)
$certificateSha256 = if ($certificateMatch.Success) {
    $certificateMatch.Groups[1].Value.ToUpperInvariant()
} else {
    ''
}
$expectedCertificate = ([string]$baseline.releaseCertificateSha256).ToUpperInvariant()
if ($certificateSha256 -ne $expectedCertificate) {
    Add-Failure "Release certificate is '$certificateSha256', expected '$expectedCertificate'."
}

$apkSha256 = (Get-FileHash -LiteralPath $resolvedApk -Algorithm SHA256).Hash.ToUpperInvariant()

if ($failures.Count -gt 0) {
    Write-Host 'Release verification FAILED:' -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host " - $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host 'Release verification PASSED' -ForegroundColor Green
Write-Host "APK: $resolvedApk"
Write-Host "applicationId: $apkApplicationId"
Write-Host "application label: $apkApplicationLabel"
Write-Host "versionName: $apkVersionName"
Write-Host "versionCode: $apkVersionCode"
Write-Host "certificate SHA-256: $certificateSha256"
Write-Host "APK SHA-256: $apkSha256"
