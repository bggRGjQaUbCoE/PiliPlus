# Flutter Android 项目构建指南

> 基于 PiliPlus 项目的实战经验总结
> 更新日期: 2026-04-30 | 版本: 2.0.6

---

## 环境要求

| 工具 | 版本 | 说明 |
|------|------|------|
| Flutter | 3.41.6 | 必须使用 FVM 管理 |
| Dart SDK | >=3.10.0 | |
| Android SDK | 35 | 位于 `.android-sdk` |
| NDK | 28.2.13676358 | 必需 |
| Java | 17 | |

---

## 快速开始

### 1. 设置环境变量

```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
```

### 2. 构建 Debug APK

```powershell
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug
```

### 3. 构建 Release APK (优化版)

```powershell
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --release --obfuscate --split-debug-info=build/debug_info
```

---

## 常见问题

### TLS 握手失败

**错误:**
```
The server may not support the client's requested TLS protocol versions
```

**解决:** 确保设置 `JAVA_TOOL_OPTIONS` 环境变量

### Dart SDK 版本不匹配

**错误:**
```
Because PiliPlus requires SDK version >=3.10.0, version solving failed
```

**解决:** 使用 FVM Flutter，而非系统 Flutter

```powershell
# 错误
flutter build apk --debug

# 正确
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug
```

### R8 混淆失败 (Release)

**错误:**
```
Missing class com.google.android.play.core.splitcompat.SplitCompatApplication
```

**状态:** ✅ 已修复 - `android/app/proguard-rules.pro` 已添加 Play Core 规则

---

## Release 构建优化配置

当前项目已配置:

- **R8 全模式**: `android.enableR8.fullMode=true`
- **代码混淆**: `--obfuscate`
- **资源压缩**: `isShrinkResources = true`
- **ProGuard 优化**: 5 遍优化，日志代码移除

输出路径: `build/app/outputs/flutter-apk/app-release.apk`

---

## 故障排查

详见 `.trae/TROUBLESHOOTING.md`
