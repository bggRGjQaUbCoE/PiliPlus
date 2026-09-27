param(
    # Android 传入 android；其他平台可留空。
    [string]$Arg = ''
)

# 发布构建的预计算脚本：以完整 Git 历史中的提交数作为递增 build number，
# 并把同一份版本信息写入 pubspec.yaml 与 pili_release.json。
try {
    $versionName = $null

    # workflow 使用 fetch-depth: 0；浅克隆会导致 build number 不完整。
    $versionCode = [int](git rev-list --count HEAD).Trim()

    $commitHash = (git rev-parse HEAD).Trim()

    # 仅替换 pubspec 中的版本行，保留人工维护的发布版本名（versionName）。
    $updatedContent = foreach ($line in (Get-Content -Path 'pubspec.yaml' -Encoding UTF8)) {
        if ($line -match '^\s*version:\s*([\d\.]+)') {
            $versionName = $matches[1]
            if ($Arg -eq 'android') {
                $versionName += '-' + $commitHash.Substring(0, 9)
            }
            "version: $versionName+$versionCode"
        }
        else {
            $line
        }
    }

    if ($null -eq $versionName) {
        throw 'version not found'
    }

    $updatedContent | Set-Content -Path 'pubspec.yaml' -Encoding UTF8

    $buildTime = [int]([DateTimeOffset]::Now.ToUnixTimeSeconds())

    # --dart-define-from-file 读取此 JSON；字段名必须与 BuildConfig 保持一致。
    $data = @{
        'pili.name' = $versionName
        'pili.code' = $versionCode
        'pili.hash' = $commitHash
        'pili.time' = $buildTime
    }

    $data | ConvertTo-Json -Compress | Out-File 'pili_release.json' -Encoding UTF8

    # 后续打包步骤通过 ${env.version} 构造产物文件名。
    Add-Content -Path $env:GITHUB_ENV -Value "version=$versionName+$versionCode"
}
catch {
    Write-Error "Prebuild Error: $($_.Exception.Message)"
    exit 1
}