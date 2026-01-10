param(
    [string]$Arg = ''
)

try {
    $versionName = $null

    $flutterVersion = $null

    $versionCode = [int](git rev-list --count HEAD).Trim()

    $commitHash = (git rev-parse HEAD).Trim()

    $updatedContent = foreach ($line in (Get-Content -Path 'pubspec.yaml' -Encoding UTF8)) {
        if ($line -match '^\s*(version|flutter):\s*([\d\.]+)') {
            if ('version' -eq $matches[1]) {
                $versionName = $matches[2]
                if ('android' -eq $Arg) {
                    $versionName += '-' + $commitHash.Substring(0, 9)
                }
                "version: $versionName+$versionCode"
            } else {
                $flutterVersion = $matches[2]
                $line
            }
        }
        else {
            $line
        }
    }

    if ($null -eq $versionName -or $null -eq $flutterVersion) {
        throw 'version not found'
    }

    Set-Content -Path '.fvmrc' -Value "{`"flutter`":`"$flutterVersion`"}"

    $updatedContent | Set-Content -Path 'pubspec.yaml' -Encoding UTF8

    $buildTime = [int]([DateTimeOffset]::Now.ToUnixTimeSeconds())

    $data = @{
        'pili.name' = $versionName
        'pili.code' = $versionCode
        'pili.hash' = $commitHash
        'pili.time' = $buildTime
    }

    $data | ConvertTo-Json -Compress | Out-File 'pili_release.json' -Encoding UTF8

    Add-Content -Path $env:GITHUB_ENV -Value "version=$versionName+$versionCode"
}
catch {
    Write-Error "Prebuild Error: $($_.Exception.Message)"
    exit 1
}