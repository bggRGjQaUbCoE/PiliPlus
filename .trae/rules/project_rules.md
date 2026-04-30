# PiliPlus 项目全局规则

## 项目概况
- **名称**: PiliPlus (B站第三方客户端)
- **类型**: Flutter Android 应用
- **Flutter**: 3.41.6 (FVM 管理)
- **Dart**: >=3.10.0

## 核心约束

### 1. 必须使用 FVM Flutter
```powershell
# 正确
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" <command>

# 错误 - 系统 Flutter 版本不兼容
flutter <command>
```

### 2. 必须设置环境变量
```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
```

### 3. 代码规范
- 遵循现有代码风格，不引入新依赖除非必要
- 修改前检查周边代码的框架和库使用方式
- 安全：不暴露/提交密钥和敏感信息

## 参考文档
- 构建指南: `.trae/AGENT_QUICKSTART.md`
- 故障排查: `.trae/TROUBLESHOOTING.md`
