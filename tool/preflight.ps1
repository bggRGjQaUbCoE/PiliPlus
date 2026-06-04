$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$flutter = Get-Command flutter -ErrorAction SilentlyContinue

if (-not $flutter) {
    Write-Host "FAIL flutter is not available on PATH"
    Write-Host "local runtime unavailable: adb/emulator checks are intentionally not part of local preflight"
    exit 127
}

$steps = @(
    @{
        Name = "flutter pub get"
        Args = @("pub", "get")
    },
    @{
        Name = "flutter test test/features/shielding"
        Args = @("test", "test/features/shielding")
    },
    @{
        Name = "flutter test test/pages/setting/models/shielding_settings_test.dart"
        Args = @("test", "test/pages/setting/models/shielding_settings_test.dart")
    },
    @{
        Name = "flutter test test/bootstrap/bootstrap_app_test.dart"
        Args = @("test", "test/bootstrap/bootstrap_app_test.dart")
    },
    @{
        Name = "flutter analyze --no-fatal-infos"
        Args = @("analyze", "--no-fatal-infos")
    }
)

Push-Location $repoRoot
try {
    Write-Host "Local preflight only. GitHub Actions remains authoritative for APK build and runtime smoke."
    Write-Host "This script does not build APKs, start emulators, call adb, trigger workflows, or publish releases."
    Write-Host "local runtime unavailable: adb/emulator checks are intentionally not part of local preflight"

    foreach ($step in $steps) {
        Write-Host ""
        Write-Host "==> $($step.Name)"
        & $flutter.Source @($step.Args)
        $exitCode = $LASTEXITCODE

        if ($exitCode -ne 0) {
            Write-Host "FAIL $($step.Name) exit=$exitCode"
            exit $exitCode
        }

        Write-Host "PASS $($step.Name)"
    }

    Write-Host ""
    Write-Host "PASS local preflight"
    exit 0
}
finally {
    Pop-Location
}
