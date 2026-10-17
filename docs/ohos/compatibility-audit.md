# OHOS 兼容性审计与最小改动实施边界

## 1. 目标与基线

本分支的当前目标只有 **OHOS 适配**：以 PiliPlus 当前 `main` 为唯一的应用功能和界面基线，使原有功能能够在 OHOS 上工作，并尽量降低以后合并上游的成本。

- 应用基线：`Goodwu/PiliPlus@849c56b035ac8acf1b4fd677c2c94debe161da8e`。
- 参考项目：`Goodwu/PiliPlusX` 的 `routing/MK-ROUTING-20261011` 分支，仅用于定位 OHOS 平台工程、插件和构建经验。
- 当前范围不包含 HDR 规划或实现，也不移植 PiliPlusX 的其他功能、界面、设置项、媒体路由策略。
- 新增文件数量不设上限；既有文件的每处修改都必须说明对应的 OHOS 障碍和无法在平台层解决的原因。
- 参考项目曾经通过构建或实机验证，不能作为本基线、依赖版本和工具链组合已经可用的证据。

本报告来自固定提交的代码、锁文件和相关依赖源码审查。除非另有明确记录，以下结论均不代表本项目已经完成 OHOS 编译、安装或实机功能验证。

基线来源：[应用提交](https://github.com/Goodwu/PiliPlus/commit/849c56b035ac8acf1b4fd677c2c94debe161da8e)、[pubspec.yaml](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/pubspec.yaml)、[pubspec.lock](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/pubspec.lock)、[.fvmrc](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/.fvmrc)。该提交树中没有 `AGENTS.md`，也没有 OHOS 平台工程。

## 2. 已确认的阻塞与待验证事项

| 项目 | 已观察事实 | 对适配的影响 | 当前结论 |
| --- | --- | --- | --- |
| Flutter / Dart | `.fvmrc` 指定 Flutter `3.47.7`；`pubspec.yaml` 声明 Dart `>=3.13.0`、Flutter `3.47.7`；锁文件对应 Dart `>=3.13.0 <4.0.0` | 不能直接将较旧 OHOS SDK 当作等价构建工具；降低版本声明不会补全缺少的语言、框架或依赖 API | 工具链兼容性是首要门槛；新候选 SDK 需单独核验 |
| libmpv 加载 | 当前锁定的 `NativeLibrary.ensureInitialized()` 默认名称分支不包含 `ohos` | 原始 `main()` 在启动时调用 `MediaKit.ensureInitialized()`；没有新增初始化或依赖适配时，默认 OHOS 路径会抛出异常 | 已确认默认启动路径不支持 OHOS |
| 视频控制器 | 当前 `PlatformVideoController.create()` 只在已有 Native / Android 控制器间选择；该依赖没有 OHOS 插件声明与 OHOS 平台文件 | 提供一个 `libmpv.so` 还不够，必须有匹配当前 Dart API 的 OHOS 视频输出与纹理生命周期实现 | 已确认缺少 OHOS 后端接入 |
| native assets | 锁定的 `cnativeapi 0.5.2` 构建 hook 只处理五种既有系统，对其他目标抛出 `UnsupportedError` | 桌面代码在运行时不被执行，不能证明相关依赖能够通过 OHOS 构建 | 已确认该 hook 没有 OHOS 目标处理；需验证所选 SDK 的 target 传递与依赖隔离方案 |
| 移动平台识别 | `PlatformUtils.isMobile` 仅包含 Android 和 iOS | OHOS 不会进入移动端初始化、部分手势与生命周期路径；将其加入移动端又会启用多组原生插件调用 | 已确认需要集中适配，不能只加一个布尔条件就宣布完成 |
| 框架平台枚举 | 六个自定义 Flutter 控件文件存在约 43 处显式 Android switch 分支 | 若所选 OHOS SDK 增加 `TargetPlatform.ohos`，原有穷尽表达式及依赖完整分支赋值的代码需要适配 | 已确认存在源代码兼容面；具体修改集合由该 SDK 的分析和编译结果确定 |
| 插件能力 | 当前锁文件没有 OHOS 插件闭环；上层已经调用 WebView、音频服务、文件与相册、分享、权限、亮度等接口 | 需要保留当前应用调用的 API 和功能语义，不能以未实现桩或隐藏入口代替 | 每项能力均待本基线验证 |

工具链的固定提交、engine/artifact 可获取性及实际运行证据见 [工具链审计](toolchain-audit.md)。审计过程中另有维护者个人 `oh-3.47.7-dev` 分支被列为候选，但该候选下载的实际 Dart 为 `3.12.2`，其 Flutter 工具自身依赖解析遇到要求更高 Dart 版本的 `dwds`，尚未形成可用组合。**候选分支名称不构成完整可用性的证明；该候选失败也不能被扩大为对所有可能 SDK 的否定**。最终需记录 Flutter、Dart、engine、DevEco/OHOS SDK 的完整组合及其来源。

本次可交付的是新分支、平台工程基础、可执行的源码准备/差异检查及明确的后续工作边界。源码准备成功不能替代 HAP 编译、安装和功能验收；在工具链与依赖闭环完成前，不应将自动构建命令或 OHOS 依赖替换标为已验证可用。

## 3. 媒体依赖必须保持当前 API

### 3.1 当前应用实际上锁定的实现

`pubspec.yaml` 表面的 `media_kit` 版本号不足以描述实际依赖；`dependency_overrides` 和 `pubspec.lock` 决定了当前使用的定制实现。

| 包组 | 锁定源码 |
| --- | --- |
| `media_kit`、多个 `media_kit_libs_*`、`media_kit_native_event_loop` | `My-Responsitories/media-kit@73771ec38176be2d984a3049c28177bce23b54a0` |
| `media_kit_video` | `bggRGjQaUbCoE/media-kit@fd8421d21eade4d6d12de137fa7df902fec20292` |
| `audio_service` | `bggRGjQaUbCoE/audio_service@9f91eb8d6aa0905661ab3914ebdd3c9fb5c37cc2`，包版本 `0.18.19` |
| `audio_session` | `bggRGjQaUbCoE/audio_session@c8c2143c1720292801f72867e29ddeb50c36134e`，包版本 `0.2.4` |
| `native_device_orientation` | `bggRGjQaUbCoE/flutter_native_device_orientation@7be186c79adca7d3ff5abc34bc75d171c68c2694` |

锁文件证据见上文 `pubspec.lock`，尤其媒体包及音频包对应条目。

当前应用直接使用如下接口，不应为了采用旧 OHOS 分叉而改写播放器业务层：

- `VideoController.create(...)` 的异步创建流程。
- 当前 `Player` / `NativePlayer` 类型关系及其事件流。
- `setMediaHeader(...)`、`getProperty(...)`、`setProperty(...)`、`command(...)`。
- `NativePlayer.apiVersion`、`NativePlayer.mpv`。
- `media_kit` 内部 `Initializer.create()` / `dispose()` 及生成的 libmpv FFI：原项目的动图导出代码也依赖这些接口。

调用证据：[播放器控制器](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/plugin/pl_player/controller.dart)、[播放器信息与控制界面](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/pages/video/widgets/header_control.dart)、[MpvConvertWebp](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/plugin/pl_player/widgets/mpv_convert_webp.dart)、[启动入口](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/main.dart)。

### 3.2 已确认缺少的 OHOS 部分

当前 [`native_library.dart`](https://github.com/My-Responsitories/media-kit/blob/73771ec38176be2d984a3049c28177bce23b54a0/media_kit/lib/src/player/native/core/native_library.dart) 的默认加载分支只包含 Windows、Linux、macOS、iOS、Android，其他系统抛出 `UnimplementedError`。该方法允许显式指定 `libmpv` 路径；是否可通过新增 OHOS 入口完成所需初始化，仍需核验完整初始化调用链，不能仅凭该参数认定问题已解决。

当前 [`platform_video_controller.dart`](https://github.com/bggRGjQaUbCoE/media-kit/blob/fd8421d21eade4d6d12de137fa7df902fec20292/media_kit_video/lib/src/video_controller/platform_video_controller.dart) 的工厂在 Native 与 Android 后端之间选择，否则抛出异常；对应 [`media_kit_video/pubspec.yaml`](https://github.com/bggRGjQaUbCoE/media-kit/blob/fd8421d21eade4d6d12de137fa7df902fec20292/media_kit_video/pubspec.yaml) 没有 OHOS 注册。

因此优先方案是在**当前 API 形态**下补充 OHOS 库加载、插件注册、视频输出和资源释放。可以参考已有 OHOS 实现的原生部分，但不能将包含其他路由或应用策略改动的整套 fork 直接换入。

需要专门验证初始化、首帧、seek、暂停恢复、页面切换、横竖屏、前后台、播放结束与销毁，避免“能出一帧”被误记为播放器已经适配。

## 4. 原生依赖和插件闭环

### 4.1 nativeapi 的构建问题

应用锁定 `nativeapi 0.5.2` / `cnativeapi 0.5.2`。发布标签 `libnativeapi/nativeapi:v0.5.2` 指向 `60910d7d492d24497c13c172e2a270c7a7f0cae2`；该提交的 [`cnativeapi/hook/build.dart`](https://github.com/libnativeapi/nativeapi/blob/60910d7d492d24497c13c172e2a270c7a7f0cae2/bindings/dart/cnativeapi/hook/build.dart) 根据目标系统选择原生实现目录，仅处理 Android、iOS、Linux、macOS、Windows，其他值明确抛错。

应用在 `device_utils.dart`、桌面窗口工具、播放器控制器、主页面中导入 `nativeapi`，不仅使用窗口操作，还在类型层面使用 `Size` / `Rectangle`。此外 `window_manager`、`tray_manager`、`screen_retriever` 等依赖也需要整体审查。因此不能简单删除一个 import 或让 `isDesktop == false` 就认为构建依赖消失。

优先审查方法：

1. 在隔离的 OHOS 依赖图中枚举所有 native-assets hooks 和原生插件。
2. 确认当前 OHOS SDK 向 hook 传递的目标值、工具链及原生资源打包方式。
3. 对 OHOS 实际需要的原生能力进行真实适配；对仅用于其他平台的依赖，验证可明确隔离、且不会影响其 Dart 类型及编译。
4. 只有经过编译和产物检查，才能判断未使用的原生代码是否被排除。不能用空 hook、伪造成功返回或不完整的同名包来掩盖缺失功能。

JNI、`win32` 也需要检查编译和原生资源处理。但当前看到的 `DeviceUtils.sdkInt` 是惰性静态字段，调用点有 Android 条件保护；**仅出现 JNI import 不是必须改写该文件的证据**。

### 4.2 扩展 isMobile 后的实际调用链

当前 [`platform_utils.dart`](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/utils/platform_utils.dart) 只有 Android / iOS 被归入移动端。扩展 OHOS 会启用这些既有路径：

| 既有代码 | 被启用的行为 | 需要验证的 OHOS 能力 |
| --- | --- | --- |
| `lib/main.dart` | 移动端初始化、方向与系统栏设置、`setupServiceLocator()`、亮度设置 | 音频服务/会话、系统栏、方向、屏幕亮度 |
| `lib/plugin/pl_player/controller.dart` | 方向监听、移动端音量策略、手势/全屏相关路径 | 方向事件、真实系统媒体音量、窗口方向 |
| `lib/plugin/pl_player/view/view.dart` | 音量和亮度查询、事件订阅、播放器手势 | 亮度与音量读写及事件、注销行为 |
| `lib/utils/mobile_observer.dart` 及其调用者 | 前后台生命周期监听 | 正确的 Flutter / Ability 生命周期传递 |
| `lib/utils/share_utils.dart`、`image_utils.dart` | 系统分享、图片/视频保存、权限流程 | 分享、相册写入、权限申请与结果 |
| `lib/pages/setting/models/play_settings.dart` | 显示已有移动端设置，包括后台播放和音频服务 | 对应功能实际可用，不能仅显示可点击界面 |

启动阶段还需核验 `path_provider`、缓存、主题与深链：

- `getApplicationSupportDirectory()` / `getTemporaryDirectory()` 在启动流程中执行，OHOS 必须提供真实可写目录。
- `Pref.dynamicColor` 在非 iOS 上默认开启；当前初始化直接调用 `DynamicColorPlugin.channel` 并捕获 `PlatformException`。插件完全缺失与平台明确返回“不支持”是不同的情况，应接入可验证的 OHOS 实现或明确走原项目允许的主题回退，不能依赖未处理的 `MissingPluginException`。
- 主页面会初始化 `PiliScheme`，需要冷启动和 `onNewWant` 等情况下的深链交付与去重。

WebView 不只是网页浏览功能：[登录验证码](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/pages/login/geetest/geetest_webview_dialog.dart) 同样依赖 `flutter_inappwebview` 的页面加载与 JavaScript handler。将内部 WebView 换成外部浏览器不满足原有登录流程的验收条件。

## 5. 自定义控件与平台判断

固定提交中，平台相关判断分布于约 150 个 Dart 文件，但这不是需要修改 150 个文件的结论。多数判断描述的是原本就有的平台能力或平台交互差异，应该保留。

显式 Android switch 分支集中在以下六个文件，共约 43 处；数量用于定位审查面，不代表 43 处都已被证明需要修改：

| 文件 | 显式 Android switch 分支数 |
| --- | ---: |
| `lib/common/widgets/flutter/vertical_slider.dart` | 3 |
| `lib/common/widgets/flutter/text_field/editable.dart` | 3 |
| `lib/common/widgets/flutter/text_field/text_field.dart` | 5 |
| `lib/common/widgets/flutter/text_field/text_selection.dart` | 17 |
| `lib/common/widgets/flutter/text_field/editable_text.dart` | 11 |
| `lib/common/widgets/flutter/text_field/cupertino/text_field.dart` | 4 |

例如 `editable_text.dart` 中 `_platformSupportsFadeOnScroll` 和平台布尔返回逻辑使用穷尽 switch 表达式。如果 SDK 新增平台枚举值，运行时把平台临时改成 Android 无法修复编译时的穷尽性问题。

适配原则：

- 保留原有六种平台的分支、返回值和执行顺序。
- 按实际分析/编译诊断添加最小的新平台或默认分支；OHOS 的分支行为需对照手机交互需求验证。
- 公共源码仍应能由原上游标准 Flutter SDK 编译，避免在公共路径无条件引用该 SDK 不存在的 `TargetPlatform.ohos` 成员。
- 不复制整套控件，不替换原来的颜色算法、布局或文本编辑实现来迎合较旧 SDK。
- 不全局设置 `debugDefaultTargetPlatformOverride = TargetPlatform.android`。这还会让 `FontUtils` 按 Android 路径调用 `AndroidHelper.fontFamilies()`，在 OHOS 错误进入 JNI；也会影响应用及依赖的其他平台判断。

相关证据：[editable_text.dart](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/common/widgets/flutter/text_field/editable_text.dart)、[font_utils.dart](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/utils/font_utils.dart)。

## 6. 最小改动候选清单

以下是实施顺序和候选边界，不是已决定必须提交的修改清单。每一项应以实际错误和功能验证收敛。

| 位置 | 优先做法 | 触碰既有文件的条件 |
| --- | --- | --- |
| OHOS Ability / 工程 / 资源 | 新增 `ohos/` 平台工程，按所选 SDK 生成并审查插件注册 | 不改 Android、iOS、桌面平台工程 |
| OHOS 依赖组合 | 新增 OHOS 专用依赖描述、固定 SHA 与独立锁定记录；生成到隔离构建目录 | 标准 `pubspec.yaml` / `pubspec.lock` 保持上游基线；确有必要时再审查小范围共用依赖变更 |
| 启动 | 优先新增 OHOS 入口和平台初始化包，复用现有 `main()` | 如果现有初始化顺序无法由外部入口满足，只加入一个有明确职责的初始化接入点；不复制 `main.dart` |
| `lib/utils/platform_utils.dart` | 增加基于实际运行系统的 OHOS 检测，并纳入移动端定义 | 核心候选修改；须同时具备被启用插件能力的验证记录 |
| 六个自定义控件文件 | analyzer 证明需要时增加最小 switch 分支 | 不引入框架源码副本，不整段替换控件 |
| 媒体后端 | 在依赖层增加与当前 API 一致的 OHOS 库加载和视频控制器实现 | 尽量不改业务播放器、视频页和直播页；只有平台能力接入无法下沉时才增加薄入口 |
| 权限、分享、文件、相册、WebView、音频、亮度等 | 优先新增或适配 federated OHOS 实现，并固定来源 | 不通过修改业务流程、隐藏入口或成功桩减少原功能 |
| 具体 OS 能力，例如画中画、根页面返回 | 平台桥接实现后再连接既有控制流程 | 保留现有 UI 结构，只修改必要的平台能力条件与调用入口 |

新增 `pubspec_overrides.yaml` 本身不能替代依赖图设计：它不能随意新增原 manifest 完全没有引用的功能入口，而且一个包根目录中的 overrides 会影响该目录中的所有平台构建。因此本项目优先使用隔离的 OHOS 构建副本，防止覆盖标准依赖或污染上游同步工作区。

构建副本必须从当次源代码生成，不能成为另一份手工维护的应用源码。如果使用补丁，应显式记录目标文件、基准摘要、唯一锚点或上下文及适配理由；锚点变化时停止并报告。**把对旧文件的修改移到脚本里，只是改变冲突暴露的位置，不会消除维护成本。** 少量可读的直接补丁可以比宽泛的自动重写更容易长期合并。

## 7. 分步实施与完成条件

### 阶段 A：工具链与源码能力门槛

1. 固定应用基线，记录候选 Flutter OHOS 的仓库、提交、Dart 和 engine 版本、制品地址及摘要。
2. 核验与 Dart `3.13` / Flutter `3.47.7` 声明要求及实际源码/依赖的兼容性。API 检查必须以运行证据为准：例如本项目使用的 `Future.syncValue` 已在所检查的 Dart `3.12.2` 中执行成功，不能把它列为 Dart `3.13` 独占 API 或已经确认的阻塞。
3. 使用候选 SDK 做小规模 OHOS 模板应用编译，再验证当前项目的依赖解析及 Dart 分析。
4. 对所有失败分类：SDK API、插件 API、native assets、平台工程、应用平台判断。保留完整可复现命令和错误摘要。

完成条件：有可获取、可运行、能解释当前源代码诊断的固定工具链。改低版本号或仅能运行 `flutter --version` 不满足此条件。

### 阶段 B：最小平台工程与插件注册

1. 新增 OHOS 原生工程、资源、必要权限和 Ability 生命周期桥接。
2. 以当前 Dart 插件接口逐项接入路径、应用信息、深链、网络、WebView、权限等基础能力。
3. 生成并检查实际插件注册结果，不能沿用参考工程的陈旧生成文件。
4. 确认冷启动到原版主页，保留原主题、导航、设置和业务页面。

完成条件：启动、基础页面、设置读写和登录验证码流程可工作；所有未完成项仍明确标为未完成。

### 阶段 C：当前媒体 API 的 OHOS 后端

1. 提供与当前事件循环和 FFI 兼容的 libmpv 及其原生依赖。
2. 实现 OHOS 视频输出、纹理注册/更新、尺寸变更和释放；接入既有 `VideoController.create()`。
3. 接通真实音量、亮度、方向、wakelock、音频焦点与音频服务。
4. 验证视频、直播、听视频/纯音频、本地缓存和已有字幕/弹幕/画面操作。

完成条件：普通播放链路和既有播放功能通过下表验收；不引入当前范围之外的播放策略。

### 阶段 D：全功能闭环与上游同步验证

1. 补齐分享、选择/导入/导出文件、相册保存、下载、后台、深链及平台窗口能力。
2. 在真实 OHOS 设备完成操作级验收；模拟器和静态分析作为辅助证据。
3. 验证标准平台依赖文件及原有平台源码的差异仍符合白名单。
4. 在隔离分支试合并新的上游提交，重建 OHOS 构建副本；检查补丁漂移并重复受影响功能验证。

完成条件：能解释每一处既有文件修改，并有当前基线的完整验收记录；不存在通过隐藏功能来获取成功构建的措施。

## 8. 功能验收矩阵

每项记录至少包含应用提交、工具链/依赖组合、设备与系统版本、操作步骤、实际结果和日志/截图位置。以下项目当前均为待验证；只有真实执行后才能更新状态。

| 功能组 | 需要验证的操作与结果 |
| --- | --- |
| 原版界面与业务 | 首页、分区/搜索、动态、消息、个人页面、详情页、各设置项与主题仍来自 main；无参考项目新增页面/设置；列表、文本输入、选择/复制与键盘正常 |
| 启动与持久化 | 首装冷启动、已有数据升级、重新启动、设置与账号保留、支持/临时/缓存目录真实可读写 |
| 登录与验证码 | 原有登录方式、验证码 WebView 加载、JavaScript 回调、Cookie/登录态交付、取消及失败返回均可操作 |
| 深链 | 冷启动和运行中打开原有 scheme / 支持的链接；正确导航、不丢参数、不重复处理 |
| 视频与直播 | 既有普通视频、番剧及直播入口；首帧、声音、清晰度/音轨切换、缓冲、seek、倍速、循环/连播、EOS；失败时正确提示 |
| 弹幕与字幕 | 既有弹幕展示与交互、字幕选择/样式、进度预览等功能；与视频布局和横竖屏一致 |
| 播放器手势与显示 | 亮度/音量滑动、双击、长按、进度条、全屏/退出、重力方向、屏幕常亮、系统栏和安全区域 |
| 亮度与音量 | 初始值读取、系统按键变化、拖动修改、事件订阅注销、页面退出/切后台后的恢复与保留行为 |
| 后台与音频 | 原有后台播放设置、音频服务开关、锁屏/系统媒体会话控制、音频焦点、打断恢复、耳机断开、前后台切换、听视频模式 |
| 画中画与返回 | 平台支持时通过原有交互进入、退出、恢复页面与播放；系统返回和根页面返回合理处理；未实现不得标成全功能完成 |
| 下载与本地播放 | 原有下载、暂停恢复、缓存条目与清理、文件完整性、离线播放、失败重试；无需用公开目录替代应用沙箱 |
| 文件与数据 | 文件选择、导入/导出设置及数据、字幕和字体相关操作、用户取消、无权限及无空间场景 |
| 分享与相册 | 文本/图片分享、图片/视频保存、权限拒绝与重试、系统选择器取消；实际生成可打开的目标内容 |
| WebView | 原有网页加载、导航、JS 桥、Cookie、返回、外部浏览器打开；应用内验证码不被外链替换 |
| 系统与资源 | 网络变化、应用信息、电量、权限、资源释放；反复进入/退出视频与直播不残留声音或原生资源 |
| 其他平台与同步 | 原有平台的依赖解析/必要编译检查；上游合并后差异统计、补丁锚点和受影响功能验证 |

平台本身确实没有的能力应记录具体限制、对应用户可见行为和处理决定，不能静默返回成功，也不能将能力缺失解释为已经“严格保留全部功能”。
