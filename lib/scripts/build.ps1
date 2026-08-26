param(
    [string]$Arg = ''
)

try {
    $pubspecVersion = $null
    foreach ($line in (Get-Content -Path 'pubspec.yaml' -Encoding UTF8)) {
        if ($line -match '^\s*version:\s*([\d\.]+)') {
            $pubspecVersion = $matches[1]
            break
        }
    }

    if ($null -eq $pubspecVersion) {
        throw 'version not found in pubspec.yaml'
    }

    # workflow_dispatch keeps its inputs in the GitHub event payload, including
    # when this script runs inside a reusable workflow. A real tag ref is also
    # supported so the same script can be reused if tag-push builds are added later.
    $releaseTag = ''
    if ($env:GITHUB_EVENT_PATH -and (Test-Path $env:GITHUB_EVENT_PATH)) {
        try {
            $eventPayload = Get-Content -Raw -Path $env:GITHUB_EVENT_PATH -Encoding UTF8 | ConvertFrom-Json
            if ($null -ne $eventPayload.inputs -and $null -ne $eventPayload.inputs.tag) {
                $releaseTag = [string]$eventPayload.inputs.tag
            }
        }
        catch {
            # A malformed/missing event payload should not break local or PR builds.
            $releaseTag = ''
        }
    }

    if ([string]::IsNullOrWhiteSpace($releaseTag) -and $env:GITHUB_REF_TYPE -eq 'tag') {
        $releaseTag = [string]$env:GITHUB_REF_NAME
    }

    $versionName = $pubspecVersion
    if (-not [string]::IsNullOrWhiteSpace($releaseTag)) {
        if ($releaseTag -match '(?<!\d)(\d+\.\d+\.\d+)(?!\d)') {
            $versionName = $matches[1]
        }
        else {
            throw "release tag '$releaseTag' does not contain a x.y.z version"
        }
    }

    $versionCode = [int](git rev-list --count HEAD).Trim()
    $commitHash = (git rev-parse HEAD).Trim()

    $updatedContent = foreach ($line in (Get-Content -Path 'pubspec.yaml' -Encoding UTF8)) {
        if ($line -match '^\s*version:\s*[\d\.]+(?:\+\d+)?') {
            "version: $versionName+$versionCode"
        }
        else {
            $line
        }
    }
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
