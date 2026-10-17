# OHOS 应用工程壳

此目录为 `Goodwu/PiliPlus` 的 OHOS 平台入口。应用标识使用
`com.example.piliplus`，显示名称为 `PiliPlus`；两个原生图标均直接取自
仓库的 `assets/images/logo/logo.png`，没有重新设计。

当前交付状态是**工程壳及静态检查完成，尚未构建或验收 HAP**。它不代表
现有依赖已经支持 OHOS，也不代表首页、播放或其他功能已经在 OHOS 运行。
共享 Dart 入口继续使用原有 `lib/main.dart`，本目录没有替代入口或业务界面。

## 工程边界

- `EntryAbility.ets` 使用标准 `FlutterAbility` 注册流程。
- `Index.ets` 容纳 `FlutterPage`，并通过 SDK 的 `EVENT_BACK_PRESS` 事件转交返回键。
- `hvigorconfig.ts` 注入 Flutter 原生模块；不会重写调用者的 `DART_DEFINES`。
- `build-profile.json5` 声明 HarmonyOS API 15，原生目标为 `arm64-v8a`。
  这是初始工程配置，不是已经验证的最低系统版本。最终应以选定的 Flutter OHOS
  SDK、插件清单以及真实 HAP 编译结果共同确定兼容和目标 API。
- 当前只声明 Flutter 网络应用所需的 `ohos.permission.INTERNET`。文件、媒体服务、
  相册等功能的权限应随对应的真实平台实现接入；不能仅添加权限便宣称功能可用。

工程结构参照 Flutter OHOS `oh-3.44.9-dev` 的应用模板，以及
[PiliPlusX 的 OHOS 工程](https://github.com/Goodwu/PiliPlusX/tree/997244ba9dfe8177f600c3a85b89d7cf7f112608/ohos)。
该模板来源仅用于确认原生结构，并不是将当前应用降级到 Flutter 3.44 的构建声明。

## 生成文件

`entry/src/main/ets/plugins/GeneratedPluginRegistrant.ets` **由 Flutter OHOS 工具生成**，
不提交静态插件列表。Flutter 工具的 `injectPlugins` / `_writeOhosPluginRegistrant`
根据实际解析且声明 OHOS 支持的依赖生成注册表。使用已经完成兼容性核对的 SDK
执行 `flutter pub get` 后，应确认此文件已经生成，再运行 HAP 构建；直接打开尚未
准备依赖的 ArkTS 工程会缺少此导入，这不应通过空注册类掩盖。

`entry/src/main/resources/base/profile/buildinfo.json5` 保留 Flutter OHOS 模板的
`enable_impeller` 配置。Flutter 的 HAP 构建流程会将其复制到
`entry/src/main/resources/rawfile/buildinfo.json5`，并写入实际构建开关；该输出已忽略。

`oh_modules`、Flutter 原生库、`flutter_assets` 和 Hvigor 中间文件也由工具生成，
不从其他分支复制。

## 构建前置条件

主线 `pubspec.yaml` 要求 Dart `>=3.13.0`、Flutter `3.47.7`。必须先解决
OHOS SDK 与该版本及主线插件接口的兼容性，才能按以下顺序尝试完整应用构建：

1. 在隔离的构建目录中准备经核对的 Flutter OHOS SDK、HarmonyOS SDK 和依赖。
2. 解析依赖，确认生成的 OHOS 插件注册表与选定依赖清单一致。
3. 使用原有 `lib/main.dart` 构建 arm64 unsigned HAP。
4. 检查包内模块、ABI、版本及所需原生库；随后单独验收安装、启动与完整功能。

普通 Flutter SDK 不提供该 HAP 构建目标。仅新增此目录、降低 SDK 约束，或让
缺失插件返回空的成功结果，都不能满足完整应用适配要求。

## 签名与版本

提交的 `signingConfigs` 为空，`enableSignTask` 为 `false`，用于生成 unsigned HAP。
设备签名在本地构建副本或本地 DevEco 配置中完成；不将证书、私钥、设备 profile
或本机绝对路径写入本目录的版本记录。

`AppScope/app.json5` 初始版本对应本次主线基线 `2.1.6+1`。正式产物的版本名、
版本号和 Dart 构建信息必须在构建准备阶段与实际源版本同步，不能把工程壳中的
初始值当成新的发布版本。
