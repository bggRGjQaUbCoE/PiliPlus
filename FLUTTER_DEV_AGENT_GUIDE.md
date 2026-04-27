# Flutter Android 开发智能体指导文档

> 本机通用 Flutter Android 开发环境配置与操作指南

---

## 环境概览

### 系统信息

- **操作系统**: Windows
- **用户名**: VG622
- **Flutter 版本管理**: FVM (Flutter Version Management)
- **项目位置**: `c:\traeapp\PiliPlusgzy622Mod`

### 已安装工具

| 工具 | 路径 | 用途 |
|------|------|------|
| Flutter SDK | `C:\dev\flutter` | 系统 Flutter (3.24.5) |
| FVM Flutter | `C:\Users\VG622\fvm\versions\3.41.6` | 项目 Flutter (3.41.6) |
| FVM CLI | `C:\Users\VG622\AppData\Local\Pub\Cache\bin\fvm.bat` | Flutter 版本管理 |
| Android SDK | `c:\traeapp\PiliPlusgzy622Mod\.android-sdk` | Android 开发工具 |
| ADB | `.android-sdk\platform-tools\adb.exe` | Android 调试桥 |
| SDK Manager | `.android-sdk\cmdline-tools\latest\bin\sdkmanager.bat` | SDK 包管理 |

---

## 环境变量配置

### 用户级环境变量（已设置）

```powershell
# Android SDK
ANDROID_HOME=c:\traeapp\PiliPlusgzy622Mod\.android-sdk
ANDROID_SDK_ROOT=c:\traeapp\PiliPlusgzy622Mod\.android-sdk

# Java TLS 配置（解决网络问题）
JAVA_TOOL_OPTIONS=-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3

# PATH 包含（已添加）
C:\Users\VG622\fvm\versions\3.41.6\bin
C:\Users\VG622\AppData\Local\Pub\Cache\bin
c:\traeapp\PiliPlusgzy622Mod\.android-sdk\cmdline-tools\latest\bin
c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools
```

### 验证环境

```powershell
# 检查 Flutter
fvm flutter --version

# 检查 Android SDK
adb devices
sdkmanager --list

# 检查环境变量
echo $env:ANDROID_HOME
echo $env:JAVA_TOOL_OPTIONS
```

---

## 项目开发流程

### 1. 进入项目

```powershell
cd c:\traeapp\PiliPlusgzy622Mod
```

### 2. 检查 Flutter 版本

```powershell
# 查看项目配置的 Flutter 版本
cat .fvm\fvm_config.json

# 使用 FVM 运行 Flutter
fvm flutter --version
```

### 3. 获取依赖

```powershell
fvm flutter pub get
```

### 4. 连接设备

```powershell
# 检查设备
adb devices

# 预期输出：
# List of devices attached
# 10AD133K3D0011C device
```

### 5. 构建 APK

```powershell
# Debug 版本
fvm flutter build apk --debug

# Release 版本
fvm flutter build apk --release
```

### 6. 安装到设备

```powershell
# 自动安装并运行
fvm flutter run -d 10AD133K3D0011C

# 或手动安装
adb install -r build\app\outputs\flutter-apk\app-debug.apk
```

### 7. 启动应用

```powershell
adb shell am start -n com.example.piliplus.debug/com.example.piliplus.MainActivity
```

---

## 常用命令速查

### Flutter 命令

```powershell
# 检查环境
fvm flutter doctor -v

# 清理构建缓存
fvm flutter clean

# 获取依赖
fvm flutter pub get

# 运行应用
fvm flutter run

# 构建 APK
fvm flutter build apk --debug
fvm flutter build apk --release

# 分析代码
fvm flutter analyze

# 格式化代码
fvm flutter format lib/
```

### ADB 命令

```powershell
# 设备管理
adb devices                    # 列出设备
adb connect <ip>:<port>        # 无线连接
adb disconnect                 # 断开无线

# 安装卸载
adb install app.apk            # 安装
adb install -r app.apk         # 覆盖安装
adb uninstall com.example.app  # 卸载

# 启动应用
adb shell am start -n com.example.app/.MainActivity

# 查看日志
adb logcat                     # 全部日志
adb logcat -s flutter          # Flutter 日志
adb logcat -c                  # 清除日志

# 文件传输
adb push local.txt /sdcard/    # 推送文件
adb pull /sdcard/remote.txt    # 拉取文件

# Shell 操作
adb shell                      # 进入 shell
adb shell pm list packages     # 列出应用
adb shell dumpsys package com.example.app  # 应用详情
```

### FVM 命令

```powershell
# 安装 Flutter 版本
fvm install 3.41.6

# 使用指定版本
fvm use 3.41.6

# 查看已安装版本
fvm list

# 运行 Flutter
fvm flutter run
```

### SDK Manager 命令

```powershell
# 列出已安装包
sdkmanager --list_installed

# 安装 NDK
sdkmanager --install "ndk;28.2.13676358"

# 安装平台
sdkmanager --install "platforms;android-31"

# 安装构建工具
sdkmanager --install "build-tools;31.0.0"
```

---

## 故障排查

### 问题 1: Flutter 命令找不到

**症状**: `'flutter' is not recognized`

**解决**:
```powershell
# 使用 FVM 完整路径
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" --version

# 或使用 fvm 命令
fvm flutter --version
```

### 问题 2: Dart SDK 版本不匹配

**症状**: `requires SDK version >=3.10.0, version solving failed`

**解决**:
```powershell
# 必须使用 FVM 的 Flutter，不是系统 Flutter
# 错误: C:\dev\flutter\bin\flutter.bat
# 正确: C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat

fvm flutter build apk --debug
```

### 问题 3: Android SDK 未找到

**症状**: `No Android SDK found`

**解决**:
```powershell
# 设置环境变量
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
```

### 问题 4: TLS 握手失败

**症状**: `The server may not support the client's requested TLS protocol versions`

**解决**:
```powershell
# 设置 Java TLS 选项
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
```

### 问题 5: Gradle 下载超时

**症状**: 构建卡在 `Running Gradle task 'assembleDebug'`

**解决**:
- 已配置阿里云镜像，无需修改
- 确保 `JAVA_TOOL_OPTIONS` 已设置
- 检查网络连接

### 问题 6: 设备未授权

**症状**: `device unauthorized`

**解决**:
1. 检查手机屏幕，允许 USB 调试
2. 重新插拔 USB
3. 执行 `adb kill-server` 后 `adb start-server`

---

## 项目特定信息

### PiliPlus 项目

- **路径**: `c:\traeapp\PiliPlusgzy622Mod`
- **Flutter 版本**: 3.41.6
- **Dart SDK**: >=3.10.0
- **包名**: `com.example.piliplus.debug` (debug)
- **主 Activity**: `com.example.piliplus.MainActivity`

### 构建配置

- **Gradle**: 已配置阿里云镜像
- **TLS**: 已配置 JAVA_TOOL_OPTIONS
- **NDK**: 28.2.13676358 (已安装)

### 项目规则文件

详细构建规则见: `.trae/rules/project_rules.md`

---

## 最佳实践

### 1. 始终使用 FVM

```powershell
# 正确
fvm flutter run

# 避免直接使用系统 Flutter
# flutter run  # 可能版本不匹配
```

### 2. 设置环境变量

```powershell
# 每次新终端都需要设置
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
```

### 3. 检查设备连接

```powershell
adb devices
# 确保显示 device 而不是 unauthorized 或 offline
```

### 4. 清理后重新构建

```powershell
fvm flutter clean
fvm flutter pub get
fvm flutter build apk --debug
```

### 5. 查看日志调试

```powershell
adb logcat -s flutter
```

---

## 参考资源

- [项目构建规则](.trae/rules/project_rules.md)
- [Flutter Android 构建指南](FLUTTER_ANDROID_BUILD_GUIDE.md)
- [Flutter 官方文档](https://docs.flutter.dev/)
- [FVM 文档](https://fvm.app/)

---

## 快速开始模板

```powershell
# 1. 进入项目
cd c:\traeapp\PiliPlusgzy622Mod

# 2. 设置环境
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"

# 3. 检查设备
adb devices

# 4. 构建并运行
fvm flutter run -d 10AD133K3D0011C
```

---

> **提示**: 重启终端后环境变量会自动加载，无需重复设置。
