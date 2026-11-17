$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$taskPackages = Get-Content -LiteralPath "$taskRoot/.dart_tool/package_config.json" -Raw | ConvertFrom-Json
$taskWebView = $taskPackages.packages | Where-Object name -eq 'flutter_inappwebview_android'
$taskWebViewRoot = ([uri]$taskWebView.rootUri).LocalPath
$taskRepoRoot = (git -C $taskWebViewRoot rev-parse --show-toplevel).Trim()
$taskPatch = "$PSScriptRoot/webview/renderer_disposal.patch"
git -C $taskRepoRoot apply --directory=flutter_inappwebview_android --ignore-space-change --reverse --check $taskPatch 2>$null
if ($LASTEXITCODE -ne 0) {
    git -C $taskRepoRoot apply --directory=flutter_inappwebview_android --ignore-space-change --check $taskPatch
    if ($LASTEXITCODE -ne 0) { throw 'WebView renderer disposal patch does not match the resolved dependency' }
    git -C $taskRepoRoot apply --directory=flutter_inappwebview_android --ignore-space-change $taskPatch
    if ($LASTEXITCODE -ne 0) { throw 'WebView renderer disposal patch failed' }
}
$taskSource = Get-Content -LiteralPath "$taskWebViewRoot/android/src/main/java/com/pichillilorenzo/flutter_inappwebview_android/webview/in_app_webview/InAppWebView.java" -Raw
if (-not $taskSource.Contains('public boolean onRenderProcessGone(WebView view, android.webkit.RenderProcessGoneDetail detail)')) {
    throw 'WebView renderer disposal handler was not applied'
}
