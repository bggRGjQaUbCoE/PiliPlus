$pubspec = Get-Content -Raw -Encoding UTF8 'pubspec.yaml'
$match = [regex]::Match(
    $pubspec,
    '(?m)^\s*version:\s*(?<name>\d+(?:\.\d+){2})\+(?<code>\d+)\s*$'
)
if (!$match.Success) {
    throw 'pubspec.yaml must define a semantic version and Android versionCode'
}

$versionName = $match.Groups['name'].Value
$versionCode = $match.Groups['code'].Value
$commitHash = (git rev-parse HEAD).Trim()
$buildTime = [int][DateTimeOffset]::UtcNow.ToUnixTimeSeconds()

@{
    'pili.name' = $versionName
    'pili.code' = $versionCode
    'pili.hash' = $commitHash
    'pili.time' = $buildTime
} | ConvertTo-Json -Compress | Set-Content -Encoding UTF8 'pili_release.json'

if ($env:GITHUB_ENV) {
    Add-Content -Path $env:GITHUB_ENV -Value "version=$versionName+$versionCode"
}
