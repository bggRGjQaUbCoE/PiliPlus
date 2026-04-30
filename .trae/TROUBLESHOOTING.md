# PiliPlus 故障排查速查表

> 更新日期: 2026-04-30 | 版本: 2.0.6

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

### 构建错误

| 症状关键词 | 快速解决 |
|-----------|---------|
| `requires SDK version >=3.10.0` | 使用 `fvm flutter` |
| `TLS protocol versions` | 设置 `JAVA_TOOL_OPTIONS` |
| `Missing class com.google.android.play.core` | 已修复 - ProGuard 规则已更新 |
| `NDK at ... source.properties` | 重装 NDK |
| `No Android SDK found` | 设置 `ANDROID_HOME` |
| `Gradle task assembleRelease failed` | 检查网络和 TLS |

### 安装错误

| 症状关键词 | 快速解决 |
|-----------|---------|
| `INSTALL_FAILED_ABORTED` | 确认手机弹窗 |
| `device unauthorized` | 允许 USB 调试 |
| `device offline` | 重新插拔 USB |

---

## 详细解决方案

### E001: Dart SDK 版本不匹配

**错误:**
```
Because PiliPlus requires SDK version >=3.10.0, version solving failed.
```

**解决:**
```powershell
# 错误
flutter build apk --debug

# 正确
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug
```

---

### E002: TLS 握手失败

**错误:**
```
The server may not support the client's requested TLS protocol versions
```

**解决:**
```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
```

---

### E003: R8 混淆失败 (Release 构建)

**错误:**
```
Missing class com.google.android.play.core.splitcompat.SplitCompatApplication
```

**状态:** ✅ 已修复

**解决:** `android/app/proguard-rules.pro` 已添加 Play Core 规则:
```proguard
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
```

---

### E004: NDK 未找到

**错误:**
```
NDK at c:\traeapp\PiliPlusgzy622Mod\.android-sdk\ndk\28.2.13676358 did not have a source.properties file
```

**解决:**
```powershell
Remove-Item -Recurse -Force "$env:ANDROID_SDK\ndk\28.2.13676358"
sdkmanager --install "ndk;28.2.13676358" --sdk_root="$env:ANDROID_SDK"
```

---

### E005: Android SDK 未找到

**解决:**
```powershell
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
```

---

## 一键修复脚本

### 深度清理
```powershell
Write-Host "深度清理..." -ForegroundColor Yellow
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" clean
Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ".dart_tool" -ErrorAction SilentlyContinue
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" pub get
Write-Host "完成" -ForegroundColor Green
```

### 环境修复
```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
adb devices
```

---

## Release 构建优化

当前 Release 配置:
- ✅ R8 全模式混淆 (`android.enableR8.fullMode=true`)
- ✅ 代码混淆 (`--obfuscate`)
- ✅ 资源压缩 (`isShrinkResources = true`)
- ✅ 5 遍 ProGuard 优化
- ✅ 日志代码移除

构建命令:
```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --release --obfuscate --split-debug-info=build/debug_info
```

输出: `build/app/outputs/flutter-apk/app-release.apk`
