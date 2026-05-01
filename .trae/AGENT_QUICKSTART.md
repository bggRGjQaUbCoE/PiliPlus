# PiliPlus 智能体快速启动指南

> ⚡ 5 分钟上手，避免踩坑
> 
> 本文档面向 AI 智能体，提供最小可行操作路径
> 更新日期: 2026-04-30 | 版本: 2.0.6

---

## 🎯 核心原则 (必看)

### 1. 永远使用 FVM Flutter
```powershell
# ❌ 错误 - 系统 Flutter 版本太低
flutter build apk --debug

# ✅ 正确 - 使用 FVM 管理的 Flutter
fvm flutter build apk --debug
# 或完整路径
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug
```

### 2. 永远设置 JAVA_TOOL_OPTIONS
```powershell
# ❌ 错误 - 直接构建
fvm flutter build apk --debug

# ✅ 正确 - 先设置环境变量
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
fvm flutter build apk --debug
```

### 3. 永远不要修改镜像配置
项目已配置阿里云镜像，无需也不应修改：
- `android/build.gradle.kts` ✓ 已配置
- `android/settings.gradle.kts` ✓ 已配置

---

## 🚀 一键构建脚本

### PowerShell 完整脚本
```powershell
# ============================================
# PiliPlus 一键构建脚本
# 复制以下全部代码执行即可
# ============================================

# 1. 设置环境变量 (必需)
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"

# 2. 进入项目目录
Set-Location "c:\traeapp\PiliPlusgzy622Mod"

# 3. 检查设备
Write-Host "📱 检查设备连接..." -ForegroundColor Cyan
& "c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe" devices

# 4. 获取依赖
Write-Host "📦 获取 Flutter 依赖..." -ForegroundColor Cyan
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" pub get

# 5. 构建 APK
Write-Host "🔨 构建 Debug APK..." -ForegroundColor Cyan
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug

# 6. 安装到设备
Write-Host "📲 安装到设备..." -ForegroundColor Cyan
& "c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe" install -r "c:\traeapp\PiliPlusgzy622Mod\build\app\outputs\flutter-apk\app-debug.apk"

# 7. 启动应用
Write-Host "🚀 启动应用..." -ForegroundColor Cyan
& "c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe" shell am start -n com.example.piliplus.debug/com.example.piliplus.MainActivity

Write-Host "✅ 完成!" -ForegroundColor Green
```

---

## 📋 分步操作指南

### Step 0: 环境检查 (首次必做)
```powershell
# 检查环境变量
echo $env:ANDROID_HOME
echo $env:JAVA_TOOL_OPTIONS

# 检查 FVM
fvm --version

# 检查 Flutter 版本 (必须是 3.41.6)
fvm flutter --version

# 检查设备
adb devices
```

### Step 1: 获取依赖
```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
fvm flutter pub get
```

### Step 2: 构建
```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
fvm flutter build apk --debug
```

### Step 3: 安装
```powershell
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

### Step 4: 启动
```powershell
adb shell am start -n com.example.piliplus.debug/com.example.piliplus.MainActivity
```

---

## 🆘 故障速查

### 问题 1: "requires SDK version >=3.10.0"
**原因**: 使用了系统 Flutter  
**解决**: 使用 `fvm flutter` 而不是 `flutter`

### 问题 2: "TLS protocol versions"
**原因**: 未设置 JAVA_TOOL_OPTIONS  
**解决**: 
```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
```

### 问题 3: "NDK did not have source.properties"
**解决**:
```powershell
Remove-Item -Recurse -Force "$env:ANDROID_SDK/ndk/28.2.13676358"
sdkmanager --install "ndk;28.2.13676358"
```

### 问题 4: "symlink support"
**解决**: 以管理员身份运行 PowerShell，或启用开发者模式

### 问题 5: 构建卡住不动
**解决**: 
1. 检查 JAVA_TOOL_OPTIONS 是否设置
2. 检查网络连接
3. 等待 10-30 分钟 (首次构建正常)

---

## 📁 关键文件位置

| 文件 | 路径 | 用途 |
|------|------|------|
| 环境配置 | `.trae/environment.yml` | 完整环境定义 |
| Flutter 版本 | `.fvmrc` | Flutter 3.41.6 |
| 依赖配置 | `pubspec.yaml` | Dart 包依赖 |
| Android 构建 | `android/app/build.gradle.kts` | 应用构建配置 |
| 镜像配置 | `android/build.gradle.kts` | 阿里云镜像 |
| 权限声明 | `android/app/src/main/AndroidManifest.xml` | 安卓权限 |

---

## ⚠️ 常见错误 (避免踩坑)

### ❌ 错误 1: 使用系统 Flutter
```powershell
# 错误!
C:\dev\flutter\bin\flutter.bat build apk

# 正确!
C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat build apk
```

### ❌ 错误 2: 忘记设置环境变量
```powershell
# 错误!
fvm flutter build apk

# 正确!
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
fvm flutter build apk
```

### ❌ 错误 3: 修改镜像配置
项目已配置阿里云镜像，**不要**修改：
- `android/build.gradle.kts`
- `android/settings.gradle.kts`

### ❌ 错误 4: 首次构建不耐烦
首次构建需要下载：
- Gradle Wrapper (~100MB)
- NDK (~1GB)
- Android SDK Platforms (~500MB)
- 项目依赖 (~200MB)

**耗时 10-30 分钟是正常的！**

---

## 🔧 实用命令

### 清理构建
```powershell
fvm flutter clean
```

### 重新获取依赖
```powershell
fvm flutter pub get
```

### 检查环境
```powershell
fvm flutter doctor -v
```

### 查看设备日志
```powershell
adb logcat -s flutter
```

### 卸载应用
```powershell
adb uninstall com.example.piliplus.debug
```

---

## 📚 延伸阅读

- [完整环境配置](environment.yml) - 环境变量和路径定义
- [故障排查](TROUBLESHOOTING.md) - 常见问题及解决方案

---

## 💡 智能体提示词

当你需要让其他 AI 完成构建任务时，使用以下提示词：

```
请帮我构建 PiliPlus Flutter Android 项目并安装到设备。

关键要求:
1. 必须使用 FVM 的 Flutter 3.41.6 (路径: C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat)
2. 必须设置环境变量: $env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
3. 不要修改任何镜像配置
4. 项目路径: c:\traeapp\PiliPlusgzy622Mod
5. 设备 ID: 10AD133K3D0011C

步骤:
1. 设置环境变量
2. fvm flutter pub get
3. fvm flutter build apk --debug
4. adb install -r build/app/outputs/flutter-apk/app-debug.apk
5. adb shell am start -n com.example.piliplus.debug/com.example.piliplus.MainActivity

如遇问题，参考 .trae/environment.yml 中的 known_issues。
```
