# PiliPlus 项目构建规则

> 本文件指导其他智能体如何正确构建和安装此 Flutter Android 项目。

## 项目信息

- **项目名称**: PiliPlus
- **项目类型**: Flutter Android 应用
- **Flutter 版本**: 3.41.6 (使用 FVM 管理)
- **Dart SDK 版本**: >=3.10.0
- **Android SDK 路径**: `c:\traeapp\PiliPlusgzy622Mod\.android-sdk`

---

## 环境要求

### 已配置的环境变量

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `ANDROID_HOME` | `c:\traeapp\PiliPlusgzy622Mod\.android-sdk` | Android SDK 根目录 |
| `ANDROID_SDK_ROOT` | `c:\traeapp\PiliPlusgzy622Mod\.android-sdk` | Android SDK 根目录（兼容） |
| `JAVA_TOOL_OPTIONS` | `-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3` | 解决 TLS 握手问题 |
| `Path` | 包含 Flutter、FVM、Android SDK | 系统 PATH 已配置 |

### 关键路径

```
Flutter SDK:     C:\dev\flutter\bin\flutter.bat
FVM Flutter:     C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat
FVM 命令:        C:\Users\VG622\AppData\Local\Pub\Cache\bin\fvm.bat
Android SDK:     c:\traeapp\PiliPlusgzy622Mod\.android-sdk
ADB 工具:        c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe
```

---

## 构建命令

### 标准构建流程

```powershell
# 1. 设置环境变量（如未设置）
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"

# 2. 使用 FVM 的 Flutter 构建 APK
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug
```

### 构建并安装到设备

```powershell
# 设置环境变量
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"

# 构建 APK
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug

# 安装到设备
& "c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe" install -r "c:\traeapp\PiliPlusgzy622Mod\build\app\outputs\flutter-apk\app-debug.apk"

# 启动应用
& "c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe" shell am start -n com.example.piliplus.debug/com.example.piliplus.MainActivity
```

### 一键构建安装脚本

```powershell
# 完整构建安装流程
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"

# 检查设备
& "c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe" devices

# 构建
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug

# 安装
& "c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe" install -r "c:\traeapp\PiliPlusgzy622Mod\build\app\outputs\flutter-apk\app-debug.apk"

# 启动
& "c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe" shell am start -n com.example.piliplus.debug/com.example.piliplus.MainActivity
```

---

## 常见问题

### 1. Dart SDK 版本不匹配

**错误**: `Because PiliPlus requires SDK version >=3.10.0, version solving failed.`

**解决**: 必须使用 FVM 的 Flutter 3.41.6，不要使用系统 Flutter
```powershell
# 正确
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug

# 错误（系统 Flutter 版本太低）
flutter build apk --debug
```

### 2. Android SDK 未找到

**错误**: `No Android SDK found. Try setting the ANDROID_HOME environment variable.`

**解决**: 设置环境变量
```powershell
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
```

### 3. TLS 握手失败

**错误**: `The server may not support the client's requested TLS protocol versions`

**解决**: 设置 JAVA_TOOL_OPTIONS
```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
```

### 4. FVM 命令不可用

**错误**: `fvm: The term 'fvm' is not recognized`

**解决**: 使用完整路径
```powershell
& "C:\Users\VG622\AppData\Local\Pub\Cache\bin\fvm.bat" flutter build apk --debug
# 或直接调用 FVM Flutter
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" build apk --debug
```

---

## 设备信息

### 已配置设备

| 设备 ID | 型号 | 状态 |
|---------|------|------|
| 10AD133K3D0011C | V2232A | 已连接 |

### 检查设备

```powershell
& "c:\traeapp\PiliPlusgzy622Mod\.android-sdk\platform-tools\adb.exe" devices
```

### 包信息

- **Debug 包名**: `com.example.piliplus.debug`
- **主 Activity**: `com.example.piliplus.MainActivity`

---

## 项目结构

```
c:\traeapp\PiliPlusgzy622Mod\
├── .android-sdk\              # Android SDK
├── .fvm\                      # FVM 配置
│   └── fvm_config.json        # Flutter 版本: 3.41.6
├── android\                   # Android 项目
│   ├── build.gradle.kts       # 构建配置（已配置阿里云镜像）
│   ├── settings.gradle.kts    # 设置配置（已配置阿里云镜像）
│   └── gradle.properties      # Gradle 属性（已配置 TLS）
├── lib\                       # Flutter 源码
│   ├── pages\                 # 页面
│   ├── utils\                 # 工具类
│   └── ...
├── build\                     # 构建输出
│   └── app\outputs\flutter-apk\app-debug.apk
└── pubspec.yaml               # 依赖配置
```

---

## 镜像配置

项目已配置阿里云 Maven 镜像，无需额外修改：

- `android/build.gradle.kts` - 项目仓库配置
- `android/settings.gradle.kts` - 插件仓库配置

---

## 检查清单

构建前请确认：

- [ ] 手机已连接并开启 USB 调试
- [ ] 环境变量已设置（JAVA_TOOL_OPTIONS, ANDROID_HOME）
- [ ] 使用 FVM Flutter 3.41.6 而非系统 Flutter
- [ ] 网络连接正常

---

## 参考

- [Flutter Android 构建指南](../FLUTTER_ANDROID_BUILD_GUIDE.md)
- FVM 版本: 3.41.6
- 项目路径: `c:\traeapp\PiliPlusgzy622Mod`
