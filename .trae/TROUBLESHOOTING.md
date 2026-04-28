# PiliPlus 故障排查速查表

> 🔧 按症状快速定位问题和解决方案

---

## 快速诊断流程

```
遇到问题?
    │
    ▼
┌─────────────────────────────────────┐
│ 1. 是否设置了 JAVA_TOOL_OPTIONS?    │
│    echo $env:JAVA_TOOL_OPTIONS      │
└─────────────────────────────────────┘
    │
    ├── 否 → 设置环境变量后重试
    │
    ▼
┌─────────────────────────────────────┐
│ 2. 是否使用了 FVM Flutter?          │
│    (fvm flutter --version)          │
└─────────────────────────────────────┘
    │
    ├── 否 → 使用 fvm flutter 而非 flutter
    │
    ▼
┌─────────────────────────────────────┐
│ 3. 查看下方症状匹配表               │
└─────────────────────────────────────┘
```

---

## 症状匹配表

### 🔴 构建错误

| 症状关键词 | 错误 ID | 快速解决 |
|-----------|---------|----------|
| `requires SDK version >=3.10.0` | [E001](#e001-dart-sdk-版本不匹配) | 使用 `fvm flutter` |
| `TLS protocol versions` | [E002](#e002-tls-握手失败) | 设置 `JAVA_TOOL_OPTIONS` |
| `NDK at ... source.properties` | [E003](#e003-ndk-未找到或损坏) | 重装 NDK |
| `symlink support` | [E004](#e004-windows-符号链接权限) | 启用开发者模式 |
| `Could not resolve git reference` | [E005](#e005-git-依赖下载失败) | 检查网络/Git |
| `No Android SDK found` | [E006](#e006-android-sdk-未找到) | 设置 `ANDROID_HOME` |
| `Gradle task assembleDebug failed` | [E007](#e007-gradle-构建失败) | 检查网络和 TLS |
| `Connection reset` / `timeout` | [E008](#e008-网络连接超时) | 检查镜像和网络 |

### 🟡 安装错误

| 症状关键词 | 错误 ID | 快速解决 |
|-----------|---------|----------|
| `INSTALL_FAILED_ABORTED` | [I001](#i001-安装被拒绝) | 确认手机弹窗 |
| `device unauthorized` | [I002](#i002-设备未授权) | 允许 USB 调试 |
| `device offline` | [I003](#i003-设备离线) | 重新插拔 USB |

### 🟢 运行时错误

| 症状关键词 | 错误 ID | 快速解决 |
|-----------|---------|----------|
| 应用闪退 | [R001](#r001-应用闪退) | 查看日志 |
| 白屏/黑屏 | [R002](#r002-白屏或黑屏) | 检查 Flutter 引擎 |

---

## 详细解决方案

### E001: Dart SDK 版本不匹配

**完整错误:**
```
Because PiliPlus requires SDK version >=3.10.0, version solving failed.
```

**根本原因:**
使用了系统 Flutter (3.24.5) 而非项目要求的 Flutter (3.41.6)

**解决方案:**
```powershell
# ❌ 错误
flutter build apk --debug

# ✅ 正确
fvm flutter build apk --debug

# 或完整路径
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug
```

**预防措施:**
- 永远使用 `fvm flutter` 命令
- 永远不要直接使用系统 Flutter

---

### E002: TLS 握手失败

**完整错误:**
```
The server may not support the client's requested TLS protocol versions: (TLSv1.2, TLSv1.3)
Remote host terminated the handshake
```

**根本原因:**
Java/Gradle 的 TLS 配置与国内网络环境不兼容

**解决方案:**
```powershell
# 设置环境变量 (每次构建前必须执行)
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"

# 然后构建
fvm flutter build apk --debug
```

**验证设置:**
```powershell
echo $env:JAVA_TOOL_OPTIONS
# 应输出: -Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3
```

**预防措施:**
- 将环境变量设置加入 PowerShell 配置文件
- 或使用一键构建脚本

---

### E003: NDK 未找到或损坏

**完整错误:**
```
NDK at c:\traeapp\PiliPlusgzy622Mod\.android-sdk\ndk\28.2.13676358 did not have a source.properties file
```

**根本原因:**
NDK 下载不完整或损坏

**解决方案:**
```powershell
# 1. 删除损坏的 NDK 目录
Remove-Item -Recurse -Force "$env:ANDROID_SDK\ndk\28.2.13676358"

# 2. 重新安装 NDK
sdkmanager --install "ndk;28.2.13676358" --sdk_root="$env:ANDROID_SDK"
```

**验证安装:**
```powershell
Test-Path "$env:ANDROID_SDK\ndk\28.2.13676358\source.properties"
# 应返回 True
```

---

### E004: Windows 符号链接权限

**完整错误:**
```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```

**根本原因:**
Windows 未启用开发者模式，无法创建符号链接

**解决方案 (PowerShell 管理员):**
```powershell
# 启用开发者模式
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" `
  /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
```

**或 GUI 方式:**
1. 打开 `设置` → `隐私和安全性` → `开发者选项`
2. 开启 `开发人员模式`

**替代方案:**
以管理员身份运行 PowerShell 或 IDE

---

### E005: Git 依赖下载失败

**完整错误:**
```
Could not resolve git reference
Failed to clone repository
```

**根本原因:**
网络问题或 Git 配置问题，无法访问 GitHub

**解决方案:**
```powershell
# 1. 检查 Git 是否可用
git --version

# 2. 检查网络连接
ping github.com

# 3. 配置 Git 代理 (如需要)
git config --global http.proxy http://proxy.example.com:8080
git config --global https.proxy https://proxy.example.com:8080

# 4. 重试获取依赖
fvm flutter pub get
```

**预防措施:**
- 确保 Git 可以访问 GitHub
- 考虑使用 Git 镜像或代理

---

### E006: Android SDK 未找到

**完整错误:**
```
No Android SDK found. Try setting the ANDROID_HOME environment variable.
```

**解决方案:**
```powershell
# 设置环境变量
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"

# 验证
Test-Path $env:ANDROID_HOME
# 应返回 True
```

---

### E007: Gradle 构建失败

**完整错误:**
```
Gradle task assembleDebug failed with exit code 1
```

**排查步骤:**
```powershell
# 1. 确保 JAVA_TOOL_OPTIONS 已设置
echo $env:JAVA_TOOL_OPTIONS

# 2. 清理构建缓存
fvm flutter clean

# 3. 重新获取依赖
fvm flutter pub get

# 4. 重新构建
fvm flutter build apk --debug
```

**如仍失败，查看详细日志:**
```powershell
fvm flutter build apk --debug --verbose 2>&1 | Tee-Object build.log
```

---

### E008: 网络连接超时

**完整错误:**
```
Connection reset
Read timed out
Could not GET
```

**根本原因:**
网络不稳定或镜像访问失败

**解决方案:**
```powershell
# 1. 检查网络连接
ping maven.aliyun.com

# 2. 确保 JAVA_TOOL_OPTIONS 已设置
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"

# 3. 重试 (可能需要多次)
fvm flutter build apk --debug
```

**注意:** 项目已配置阿里云镜像，无需修改配置

---

### I001: 安装被拒绝

**完整错误:**
```
INSTALL_FAILED_ABORTED: User rejected permissions
```

**解决方案:**
1. 检查手机屏幕，确认安装权限弹窗
2. 手动允许安装
3. 或卸载后重新安装:
```powershell
adb uninstall com.example.piliplus.debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

---

### I002: 设备未授权

**完整错误:**
```
device unauthorized
```

**解决方案:**
1. 检查手机屏幕，允许 USB 调试授权
2. 重新插拔 USB
3. 重启 ADB:
```powershell
adb kill-server
adb start-server
adb devices
```

---

### I003: 设备离线

**完整错误:**
```
device offline
```

**解决方案:**
```powershell
# 重启 ADB 服务
adb kill-server
adb start-server

# 重新检查设备
adb devices
```

---

### R001: 应用闪退

**排查步骤:**
```powershell
# 1. 查看日志
adb logcat -s flutter

# 2. 过滤错误
adb logcat | findstr "AndroidRuntime"

# 3. 查看 Flutter 特定日志
adb logcat -d | findstr "flutter"
```

**常见原因:**
- 依赖版本不匹配
- 原生代码错误
- 资源文件缺失

---

### R002: 白屏或黑屏

**排查步骤:**
```powershell
# 1. 检查 Flutter 引擎是否加载
adb logcat -s flutter | findstr "FlutterEngine"

# 2. 检查是否有渲染错误
adb logcat | findstr "EGL"
```

**解决方案:**
- 确保 `android/app/src/main/AndroidManifest.xml` 中启用了 Impeller
- 检查 GPU 驱动

---

## 一键修复脚本

### 深度清理并重建
```powershell
# 深度清理脚本
Write-Host "🧹 开始深度清理..." -ForegroundColor Yellow

# 1. Flutter 清理
fvm flutter clean

# 2. 删除 Gradle 缓存
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\caches" -ErrorAction SilentlyContinue

# 3. 删除构建目录
Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ".dart_tool" -ErrorAction SilentlyContinue

# 4. 重新获取依赖
fvm flutter pub get

Write-Host "✅ 清理完成，请重新构建" -ForegroundColor Green
```

### 环境修复脚本
```powershell
# 环境修复脚本
Write-Host "🔧 修复环境配置..." -ForegroundColor Yellow

# 1. 设置环境变量
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"

# 2. 验证环境
Write-Host "验证环境变量..." -ForegroundColor Cyan
echo "ANDROID_HOME: $env:ANDROID_HOME"
echo "JAVA_TOOL_OPTIONS: $env:JAVA_TOOL_OPTIONS"

# 3. 检查工具
Write-Host "检查工具..." -ForegroundColor Cyan
fvm --version
adb devices

Write-Host "✅ 环境修复完成" -ForegroundColor Green
```

---

## 联系与反馈

如以上方案无法解决问题，请收集以下信息:
1. 完整错误日志
2. `fvm flutter doctor -v` 输出
3. 环境变量设置: `Get-ChildItem Env:`
4. 项目路径: `Get-Location`
