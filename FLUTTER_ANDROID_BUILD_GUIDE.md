# Flutter Android 项目构建指南

> 基于 PiliPlus 项目的实战经验总结，适用于在中国网络环境下构建 Flutter Android 应用。

---

## 目录

1. [环境准备](#环境准备)
2. [常见问题与解决方案](#常见问题与解决方案)
3. [构建流程](#构建流程)
4. [最佳实践](#最佳实践)
5. [故障排查清单](#故障排查清单)

---

## 环境准备

### 必需工具

| 工具 | 版本要求 | 用途 |
|------|---------|------|
| Flutter SDK | 项目指定版本 | 跨平台开发框架 |
| Android SDK | API 31+ | Android 开发工具包 |
| NDK | 项目指定版本 | 原生代码编译 |
| Java JDK | 17+ | 编译环境 |
| FVM | 最新版 | Flutter 版本管理 |

### 推荐配置

```powershell
# 设置环境变量（PowerShell）
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
```

---

## 常见问题与解决方案

### 1. Flutter SDK 版本不匹配

**症状：**
```
Because [project] requires SDK version >=3.x.x, version solving failed.
```

**解决方案：**

使用 FVM 安装项目指定版本：

```bash
# 安装 FVM
dart pub global activate fvm

# 安装项目指定版本
fvm install 3.41.6

# 使用 FVM 运行
fvm flutter run -d <device_id>
```

---

### 2. NDK 下载失败或损坏

**症状：**
```
NDK at [path] did not have a source.properties file
```

**解决方案：**

```bash
# 1. 删除损坏的 NDK 目录
Remove-Item -Recurse -Force "$env:ANDROID_SDK\ndk\[version]"

# 2. 手动安装 NDK
sdkmanager --install "ndk;28.2.13676358" --sdk_root="$env:ANDROID_SDK"
```

---

### 3. Windows 符号链接权限不足

**症状：**
```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```

**解决方案：**

以管理员身份运行 PowerShell：

```powershell
# 启用开发者模式
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" `
  /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
```

或通过 GUI 设置：
1. 打开 `设置` → `隐私和安全性` → `开发者选项`
2. 开启 `开发人员模式`

---

### 4. Gradle TLS 握手失败（最常见）

**症状：**
```
The server may not support the client's requested TLS protocol versions: (TLSv1.2, TLSv1.3)
Remote host terminated the handshake
```

**根本原因：**
- Java/Gradle 的 TLS 配置与某些网络环境不兼容
- 国内网络访问 Maven Central/Google 仓库不稳定

**解决方案：**

#### 方案 A：设置环境变量（推荐）

```powershell
# PowerShell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
fvm flutter run -d <device_id>
```

#### 方案 B：配置阿里云镜像

修改 `android/build.gradle.kts`：

```kotlin
allprojects {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
        maven { url = uri("https://maven.aliyun.com/repository/central") }
        google()
        mavenCentral()
    }
}
```

修改 `android/settings.gradle.kts`：

```kotlin
pluginManagement {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        gradlePluginPortal()
    }
}
```

---

### 5. APK 安装权限被拒绝

**症状：**
```
INSTALL_FAILED_ABORTED: User rejected permissions
```

**解决方案：**

1. 检查手机屏幕，确认安装权限弹窗
2. 手动安装：

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

3. 或卸载后重新安装：

```bash
adb uninstall com.example.app
adb install build/app/outputs/flutter-apk/app-debug.apk
```

---

## 构建流程

### 标准构建步骤

```bash
# 1. 检查环境
fvm flutter doctor -v

# 2. 清理缓存
fvm flutter clean

# 3. 获取依赖
fvm flutter pub get

# 4. 设置 TLS 环境变量（Windows PowerShell）
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"

# 5. 构建并运行
fvm flutter run -d <device_id>
```

### 首次构建流程

首次构建需要下载大量依赖，耗时较长（10-30分钟）：

```
1. 下载 Gradle Wrapper → 2-5 分钟
2. 下载 NDK → 5-10 分钟（约 1GB）
3. 下载 Android SDK Platforms → 2-5 分钟
4. 下载项目依赖 → 5-10 分钟
5. 编译原生代码 → 5-10 分钟
```

**建议：** 保持网络稳定，耐心等待。

---

## 最佳实践

### 1. 版本管理

```bash
# 使用 FVM 固定 Flutter 版本
fvm use 3.41.6

# 将 .fvm 目录加入 .gitignore
echo ".fvm/" >> .gitignore
```

### 2. 镜像配置模板

创建 `android/build.gradle.kts` 模板：

```kotlin
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        // 阿里云镜像（优先）
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
        maven { url = uri("https://maven.aliyun.com/repository/central") }
        // 官方仓库（备用）
        google()
        mavenCentral()
    }
}
```

### 3. 环境变量脚本

创建 `env.ps1`：

```powershell
# Flutter Android 构建环境配置
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_SDK="C:\path\to\android-sdk"

Write-Host "环境变量已设置！" -ForegroundColor Green
```

使用前运行：

```powershell
.\env.ps1
```

### 4. 清理脚本

创建 `clean.ps1`：

```powershell
# 深度清理
fvm flutter clean
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\caches" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue
Write-Host "清理完成！" -ForegroundColor Green
```

---

## 故障排查清单

### 构建前检查

- [ ] `fvm flutter doctor` 无错误
- [ ] Android SDK 已安装（API 31+）
- [ ] NDK 已安装（项目指定版本）
- [ ] Windows 开发者模式已启用
- [ ] 手机已连接并开启 USB 调试

### 构建中检查

- [ ] Java 进程正在运行（任务管理器）
- [ ] 网络连接正常
- [ ] 磁盘空间充足（至少 10GB）

### 构建后检查

- [ ] APK 文件已生成：`build/app/outputs/flutter-apk/`
- [ ] 应用能正常安装到设备
- [ ] 应用能正常启动

---

## 常用命令速查

### 设备管理

```bash
# 列出设备
flutter devices
adb devices

# 安装 APK
adb install -r app-debug.apk

# 卸载应用
adb uninstall com.example.app

# 查看日志
adb logcat
```

### 构建命令

```bash
# Debug 构建
flutter build apk --debug

# Release 构建
flutter build apk --release

# 指定设备运行
flutter run -d <device_id>
```

### Gradle 命令

```bash
cd android

# 清理
.\gradlew.bat clean

# 构建
.\gradlew.bat assembleDebug

# 查看依赖
.\gradlew.bat dependencies
```

---

## 参考资源

- [Flutter 官方文档](https://docs.flutter.dev/)
- [FVM 文档](https://fvm.app/)
- [阿里云 Maven 镜像](https://developer.aliyun.com/mirror/)
- [Gradle 官方文档](https://docs.gradle.org/)

---

## 版本历史

| 日期 | 版本 | 说明 |
|------|------|------|
| 2026-04-27 | 1.0 | 初始版本，基于 PiliPlus 项目经验总结 |

---

> **提示：** 本文档基于实际项目经验编写，如遇新问题，请根据错误信息搜索或查阅官方文档。
