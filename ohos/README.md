# OHOS 原生应用工程

本目录是 PiliPlus 原有 `lib/main.dart` 的 OHOS 平台入口。应用标识为
`com.example.piliplus`，显示名称为 `PiliPlus`；图标直接复用原仓库
`assets/images/logo/logo.png`。应用界面与业务保持 PiliPlus 主线，当前媒体
后端按用户要求暂缓接入。

完整构建入口见 [构建工具](../tool/ohos/README.md)，各阶段实际结果见
[验证记录](../docs/ohos/README.md)。仅使用官方
[CPF Flutter oh-3.44.9-dev](https://gitcode.com/CPF-Flutter/flutter_flutter/tree/oh-3.44.9-dev)，
固定提交、原生工具版本及验证证据见 [工具链记录](../docs/ohos/toolchain-audit.md)。

## 宿主与系统交互

- `EntryAbility.ets` 使用 `FlutterAbility`，注册工具生成的插件及本地
  `PiliPlusPlatformPlugin`。SDK 可空的插件注册表已经显式检查。
- `Index.ets` 使用 `FlutterPage`，通过 SDK 的 `EVENT_BACK_PRESS` 转交返回键。
- `PiliPlusPlatformPlugin` 提供 `piliplus/ohos` 的 `moveToBackground` 通道，
  调用真实 `UIAbilityContext.moveAbilityToBackground()`，将系统失败传回 Dart。
  原主页返回逻辑只在生成副本新增这一平台分支。
- `hvigorconfig.ts` 注入 Flutter 原生模块，保留调用者传入的 `DART_DEFINES`。
- 原生目标为 `arm64-v8a`。配置中的 compatible / target SDK 为
  `5.0.3(15)`；本轮使用 26.0.0.621 command line tools 编译。
  API 15 设备兼容性尚未通过安装验证。

模块声明了真实网络状态、Wi-Fi 信息、剪贴板、后台音频、振动及加速度计实现
所需权限，后台模式包括 `audioPlayback`。相册保存使用 `saver_gallery` 的
系统逐次保存确认；不会因添加声明而伪造权限或保存成功。

`app_links_ohos` 接收系统 Want，继续交给原有 `AppScheme` 路由。模块声明
`bilibili:` 及 `b23.tv`、Bilibili 根域和常用子域的 HTTP/HTTPS URI；具体列表
在 `entry/src/main/module.json5`。这不是经过站点所有权验证的 App Linking
声明，Android 中任意通配子域的匹配及系统选择器行为仍需在设备核对。

结构参考指定 Flutter 模板及
[PiliPlusX 原生工程](https://github.com/Goodwu/PiliPlusX/tree/997244ba9dfe8177f600c3a85b89d7cf7f112608/ohos)。
依赖版本和接口适配独立记录在 `tool/ohos/dependencies.json` 与
`tool/ohos/package_patches/`。

## 生成内容

`entry/src/main/ets/plugins/GeneratedPluginRegistrant.ets` 由 Flutter OHOS
工具按实际解析的插件生成，不提交静态注册表。`flutter pub get` 的 OHOS
插件注入也需要正确设置 `HOS_SDK_HOME` 和 OHPM 环境。

`entry/src/main/resources/base/profile/buildinfo.json5` 保留模板的 Impeller
配置；Flutter 构建时复制到 `rawfile/` 并写入实际开关。`oh_modules`、原生
库、Flutter assets、Hvigor 中间文件及生成注册器均由构建工具生成。

构建副本还生成源码与依赖清单、日志、版本 defines 和构建结果。Git 原目录
只保存适配实现；这些输出不提交到主线的依赖锁文件或原平台工程。

## 签名与版本

`signingConfigs` 为空，`enableSignTask` 为 `false`，用于 unsigned HAP。
设备签名在本地构建副本或 DevEco 配置中完成。

`prepare-build` 从实际源 `pubspec.yaml` 同步 `AppScope/app.json5` 的版本，
并生成 `ohos/build-defines.json`，将原有 `BuildConfig` 的 `pili.name`、
`pili.code`、`pili.hash`、`pili.time` 与所构建源码对应。`tool/ohos/build.py`
自动传入该文件，并核对产物中的版本、应用标识与 arm64 ELF。
