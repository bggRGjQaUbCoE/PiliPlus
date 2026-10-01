param(
    [Parameter(Mandatory=$true)][string]$FlutterRoot,
    [Parameter(Mandatory=$true)][string]$PythonPath
)
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path "$PSScriptRoot/../..").Path
$flutter = Join-Path $FlutterRoot 'bin/flutter.bat'
# Android-only registration fixture avoids Windows desktop symlink privileges.
# Neither source platforms nor OS Developer Mode are removed/changed.
$stage = Join-Path ([IO.Path]::GetTempPath()) ('piliboost-registration-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $stage | Out-Null
foreach ($name in @('pubspec.yaml','pubspec.lock')) {
    Copy-Item -LiteralPath (Join-Path $repo $name) -Destination $stage
}
New-Item -ItemType Directory -Path "$stage/android/app/src/main" -Force | Out-Null
Copy-Item -LiteralPath "$repo/android/app/src/main/AndroidManifest.xml" -Destination "$stage/android/app/src/main"
Push-Location $stage
try {
    & $flutter pub get --offline
    if ($LASTEXITCODE -ne 0) { throw 'Android-only pub get did not complete.' }
} finally { Pop-Location }
$generated = "$stage/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java"
if (!(Test-Path -LiteralPath $generated)) { throw 'Flutter did not generate Android plugin registration.' }
$target = "$repo/android/app/src/main/java/io/flutter/plugins"
New-Item -ItemType Directory -Path $target -Force | Out-Null
Copy-Item -LiteralPath $generated -Destination "$target/GeneratedPluginRegistrant.java"
Push-Location $repo
try {
    & $flutter build apk --debug --no-pub
    if ($LASTEXITCODE -ne 0) { throw 'Android debug build failed.' }
    & $PythonPath "$repo/tool/phase1/verify_android_apk.py" "$repo/build/app/outputs/flutter-apk/app-debug.apk"
    if ($LASTEXITCODE -ne 0) { throw 'APK registration validation failed; do not distribute this APK.' }
} finally { Pop-Location }
Write-Output 'ANDROID_TEST_BUILD PASS complete registration and APK validation'
Write-Output "Registration fixture retained: $stage"
