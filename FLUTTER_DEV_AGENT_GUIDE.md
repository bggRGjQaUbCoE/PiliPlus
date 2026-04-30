# Flutter Android 开发智能体指导文档

> 本机通用 Flutter Android 开发环境配置与操作指南
> 更新日期: 2026-04-30 | 版本: 2.0.6

---

## 环境概览

### 系统信息

- **操作系统**: Windows
- **项目位置**: `c:\traeapp\PiliPlusgzy622Mod`
- **Flutter 版本**: 3.41.6 (FVM 管理)

### 关键路径

| 工具 | 路径 |
|------|------|
| FVM Flutter | `C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat` |
| Android SDK | `c:\traeapp\PiliPlusgzy622Mod\.android-sdk` |
| ADB | `.android-sdk\platform-tools\adb.exe` |

---

## 环境变量

```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
```

---

## 核心原则

### 1. 必须使用 FVM Flutter

```powershell
# 错误 - 系统 Flutter 版本不兼容
flutter build apk --debug

# 正确
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug
```

### 2. 必须设置 JAVA_TOOL_OPTIONS

每次构建前必须设置，否则会出现 TLS 握手失败。

### 3. 不要修改镜像配置

项目已配置阿里云镜像，无需修改：
- `android/build.gradle.kts` ✓ 已配置
- `android/settings.gradle.kts` ✓ 已配置

---

## 常用命令

### 构建

```powershell
# Debug
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug

# Release (优化版)
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --release --obfuscate --split-debug-info=build/debug_info

# 清理
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" clean

# 获取依赖
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" pub get
```

### ADB

```powershell
# 设备列表
adb devices

# 安装 APK
adb install -r build\app\outputs\flutter-apk\app-debug.apk

# 启动应用
adb shell am start -n com.example.piliplus.debug/com.example.piliplus.MainActivity

# 查看日志
adb logcat -s flutter
```

---

## 项目结构

```
lib/
├── pages/           # 页面 (view.dart + controller.dart)
├── common/          # 共享组件
├── models/          # 数据模型
├── services/        # API 服务
├── utils/           # 工具类
└── plugin/          # 自定义插件
```

---

## 故障排查

详见 `.trae/TROUBLESHOOTING.md`

常见错误:
- `requires SDK version >=3.10.0` → 使用 FVM Flutter
- `TLS protocol versions` → 设置 JAVA_TOOL_OPTIONS
- `Missing class com.google.android.play.core` → 已修复，ProGuard 规则已更新
