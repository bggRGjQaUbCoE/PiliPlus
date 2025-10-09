param(
    [string]$Arg = ''
)

try {
    $versionName = (Get-Content pubspec.yaml | Select-String 'version:\s*([\d\.]+)').Matches[0].Groups[1].Value

    $commitHash = (git rev-parse HEAD).Trim()

    if ($Arg -eq 'android') {
        $versionName += '-' + $commitHash.Substring(0, 9)
    }

    $versionCode = [int](git rev-list --count HEAD).Trim()

    $buildTime = [int]([DateTimeOffset]::Now.ToUnixTimeSeconds())

    $data = @{
        'pili.name' = $versionName
        'pili.code' = $versionCode
        'pili.hash' = $commitHash
        'pili.time' = $buildTime
    }

    $data | ConvertTo-Json -Compress | Out-File 'pili_release.json' -Encoding UTF8

    Add-Content -Path $env:GITHUB_ENV -Value "version=$versionName"
    Add-Content -Path $env:GITHUB_ENV -Value "number=$versionCode"
}
catch {
    Write-Error "Prebuild Error: $($_.Exception.Message)"
    exit 1
}