# OHOS 兼容性审计与最小改动实施边界

## 1. 当前目标与证据边界

本分支只进行 **OHOS 适配**，应用功能、界面、导航、主题和业务逻辑以
`Goodwu/PiliPlus@849c56b035ac8acf1b4fd677c2c94debe161da8e` 为基线。
不进行 HDR 规划或开发，不移植 PiliPlusX 的功能、设置、媒体路由或界面改动。
PiliPlusX 仅用于查找原生工程和插件的参考来源，其构建或实机结果不能代替本分支的验证。

本轮按用户的新指令，**只使用官方 `CPF-Flutter/flutter_flutter:oh-3.44.9-dev`，
并暂缓 media-kit 的 OHOS 后端接入**。因此普通视频、直播、音频、动态图片的视频播放
和依赖 libmpv 的转码目前不能标为已适配。原应用代码和播放器 Dart API 保留；生成的
OHOS 开发副本在这些操作处明确提示后端未接入。这个临时边界已经得到用户授权，
但它不等于“原有播放功能已完整保留且可用”。

当前工作采用三层组织：

1. Git 开发分支保留原上游文件，平台工程、补丁、工具和说明放在新增目录。
2. 从选定提交导出隔离的构建副本，先逐一核对原上游 Git blob，再执行明确的兼容补丁。
3. 在副本内准备固定来源的依赖和构建产物，分别记录源代码变更、依赖解析、Dart 编译、
   HAP 构建与设备验证结果。

**修改发生在生成副本中仍然是实际修改。** 补丁上下文和插件 API 会随上游变化而变化，
不能把冲突移到脚本中后宣称没有维护成本。当前 `app_compat.py` 标准模式明确修改
16 个原应用 Dart 文件；启动、平台桥接、媒体暂缓、pubspec 与依赖处理另有记录。
多个步骤可能修改同一个文件，最终数量以生成副本的
`ohos/source-manifest.json` 内 `generated_original_file_changes` 为准，不能直接相加。

截至本轮文档更新，已经核实源码保护、指定 SDK 启动、SDK 补丁和小范围控件测试，
应用补丁也通过了真实 main 源码 fixture 的上下文与隔离测试。完整应用依赖求解曾成功，
随后首次 `flutter analyze lib --no-pub` 得到 7 个错误、0 个警告、40 条提示；
7 个错误均为应用层 Dart 3.12 差异，对应补丁已纳入本分支，等待新构建副本复验。
**Pub 后续原生插件注入、完整应用分析通过、Dart 编译、ArkTS/HAP 构建和设备功能
仍需单独验证，本文不将它们记为成功。** 临时构建环境重置后，应从固定来源重新执行，
不能把此前依赖解析或首次分析的结果当作新副本已经通过。
完整操作命令见 [构建工具说明](../../tool/ohos/README.md)，后续实测结果见
[验证记录](README.md)。

基线来源：[应用提交](https://github.com/Goodwu/PiliPlus/commit/849c56b035ac8acf1b4fd677c2c94debe161da8e)、
[pubspec.yaml](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/pubspec.yaml)、
[pubspec.lock](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/pubspec.lock)、
[.fvmrc](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/.fvmrc)。
该提交没有 `AGENTS.md` 或 OHOS 工程；原树共有 1,639 个文件。

## 2. 官方 3.44 工具链与兼容方式

原 `.fvmrc` 指定 Flutter `3.47.7`，原 `pubspec.yaml` 声明 Dart `>=3.13.0`、
Flutter `3.47.7`。这些文件在 Git 开发目录中仍保持上游内容。只有 OHOS 构建副本
使用 Dart `>=3.12.0 <4.0.0` 和 Flutter `>=3.44.0 <3.45.0`，再通过真实依赖解析
与编译确认兼容性；降低声明本身不是兼容证明。

| 工具链项 | 固定值或已观察结果 |
| --- | --- |
| 官方仓库与分支 | `https://gitcode.com/CPF-Flutter/flutter_flutter.git`，`oh-3.44.9-dev` |
| SDK 提交 | `3ffe70c6280cc6ddf613bffa59dd70611f238f7e` |
| 真实官方标签 | `3.44.9+ohos-0.0.1-canary1`，标签提交 `39285df71a97ffe0c23241dcc459d997a9d8b7c6` |
| 实际 Flutter / Dart | `3.44.9+ohos-0.0.1-canary1` / `3.12.2` |
| 宿主 engine | `5a2a6a42cce67f965cf540fcecf616faca624aa1` |
| OHOS engine | `24497d6833225b0445953e1dd05dc6538c16a8dd` |
| 上游 Flutter 补丁 | 完整保留原 `lib/scripts/patch.ps1` 的 22 个补丁及原顺序；19 个直接应用，3 个做上下文兼容，产生 35 个 SDK 源文件变化 |
| 已执行的 SDK 验证 | 官方 CLI 启动、真实版本核对、补丁准备/重复准备/复验；4 项独立 Flutter 控件测试通过 |
| 尚不能据此证明 | 完整 PiliPlus 应用编译、OHOS 原生插件链接、HAP 打包、安装和真实设备操作 |

固定配置和摘要见 [sdk_compat/manifest.json](../../tool/ohos/sdk_compat/manifest.json)，
验证命令与测试边界见 [SDK 准备与复验说明](../../tool/ohos/sdk_compat/README.md)。
官方标签及其祖先历史被真实获取，没有修改版本字符串或将 3.12 的 Dart 二进制标成 3.13。

`text_selection`、`selectable_region`、`scrollable_gesture` 的兼容版本仅调整固定
OHOS SDK 上有差异的上下文和仍需保留的实现；不采用参考项目的全 SDK 平台伪装或额外
指针过滤。独立测试覆盖 `WidgetSpan.rawText`、富文本全选，以及 OHOS 下
PageView / TabBarView 自定义手势工厂的实际滑动，不能外推成全部应用 UI 已验证。

两个容易误判的点已有运行证据：

- `Future.syncValue` 在实际 Dart `3.12.2` 中可执行，不能列为 Dart 3.13 独占阻塞。
- 官方 Dart `3.12.2` 对 `name: PiliPlus`、`publish_to: none` 的独立包执行
  `dart pub get --offline` 成功。因此本轮保留原包名和所有 `package:PiliPlus/` 导入，
  不进行无必要的大范围小写改名。该小包结果不是完整应用 Pub 解析结果。

此前检查过的非官方 `oh-3.47.7-dev` 候选下载了 Dart `3.12.2`，Flutter 工具自身因
`dwds 27.1.2` 要求更高 Dart 版本而不能完成 bootstrap。这是历史审计事实，不是
对所有可能工具链的否定；该候选不再是本轮构建路径。当前方案以用户指定的官方 3.44
为唯一工具链来源。

## 3. 媒体依赖的确认事实与本轮暂缓行为

### 3.1 保留当前 Dart API 和固定来源

表面版本号不能代表实际媒体实现；原 `dependency_overrides` 与锁文件固定了以下源码：

| 包组 | 当前锁定来源 |
| --- | --- |
| `media_kit`、多个 `media_kit_libs_*`、`media_kit_native_event_loop` | `My-Responsitories/media-kit@73771ec38176be2d984a3049c28177bce23b54a0` |
| `media_kit_video` | `bggRGjQaUbCoE/media-kit@fd8421d21eade4d6d12de137fa7df902fec20292` |
| `audio_service 0.18.19` | `bggRGjQaUbCoE/audio_service@9f91eb8d6aa0905661ab3914ebdd3c9fb5c37cc2` |
| `audio_session 0.2.4` | `bggRGjQaUbCoE/audio_session@c8c2143c1720292801f72867e29ddeb50c36134e` |
| `native_device_orientation 2.0.5` | `bggRGjQaUbCoE/flutter_native_device_orientation@7be186c79adca7d3ff5abc34bc75d171c68c2694` |

应用使用异步 `Player.create()` / `VideoController.create()`、当前 `Player` /
`NativePlayer` 关系、`setMediaHeader()`、同步属性读取、属性/命令接口、
`NativePlayer.apiVersion` 和 `NativePlayer.mpv`。动图导出还直接使用内部
`Initializer.create()` / `dispose()` 以及生成的 libmpv FFI。不能用另一个仅名称相同、
API 形态不同的旧播放器分叉替代。

调用证据：[播放器控制器](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/plugin/pl_player/controller.dart)、
[听视频控制器](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/pages/audio/controller.dart)、
[MpvConvertWebp](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/plugin/pl_player/widgets/mpv_convert_webp.dart)、
[启动入口](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/main.dart)。

### 3.2 尚未接入的真实 OHOS 后端

固定媒体源码的
[`native_library.dart`](https://github.com/My-Responsitories/media-kit/blob/73771ec38176be2d984a3049c28177bce23b54a0/media_kit/lib/src/player/native/core/native_library.dart)
默认库名分支没有 `ohos`；原 main 启动时直接调用 `MediaKit.ensureInitialized()`。
仅提供一个 `.so` 文件或给出显式路径，不能证明初始化、事件循环和资源释放已经适配。

固定视频源码的
[`platform_video_controller.dart`](https://github.com/bggRGjQaUbCoE/media-kit/blob/fd8421d21eade4d6d12de137fa7df902fec20292/media_kit_video/lib/src/video_controller/platform_video_controller.dart)
只有已有 Native / Android 控制器选择，
[`media_kit_video/pubspec.yaml`](https://github.com/bggRGjQaUbCoE/media-kit/blob/fd8421d21eade4d6d12de137fa7df902fec20292/media_kit_video/pubspec.yaml)
没有 OHOS 平台注册。真正接入时仍需匹配当前 API 的 OHOS 视频输出、纹理/原生视图生命周期、
尺寸变更、首帧与释放实现。

### 3.3 生成副本的明确行为

[build_profile.py](../../tool/ohos/build_profile.py) 只在真实 OHOS 判断下执行暂缓分支：

| 入口 | 当前生成行为 | 不能据此声称的能力 |
| --- | --- | --- |
| 启动与日志 | 跳过未适配的 `MediaKit.ensureInitialized()`；日志媒体版本标明后端暂缓，不读取 native 字段 | 不能声称 libmpv 初始化成功 |
| 视频/直播播放 | 在创建原播放器前提示并抛出明确的未支持错误，让既有播放器错误流程处理 | 不能声称首帧、声音、进度或播放状态可用 |
| 听视频/音频 | 在 `_onOpenMedia` 开头提示后返回，避免未捕获的原生加载异常和错误设置初始化状态 | 不能声称音频播放或媒体通知的播放控制已成功 |
| 动态图片预览 | 视频后端未接入时提示，并复用原网络图片显示分支展示静态部分 | 静态封面不是动态图片视频播放 |
| libmpv 动图转码 | 在用户操作入口提示后端暂缓，避免构造器读取 `NativePlayer.mpv` | 不能声称导出已经实现 |

这里没有构造假的 `Player`、假的帧、假的解码器或成功返回。媒体依赖源仍固定在原锁定
提交，不接入 PiliPlusX 的媒体路由策略。音频服务/会话的原生适配仍可推进，但必须将
“平台插件已准备”和“有可用播放后端”分开记录。

## 4. 原生插件和 native assets

固定源码与生成规则见 [dependencies.json](../../tool/ohos/dependencies.json)、
[dependencies.py](../../tool/ohos/dependencies.py) 和
[package_patches](../../tool/ohos/package_patches)。这些规则已经提供可审查的实现，
完整依赖求解已有一次成功记录，生成了隔离锁文件与 package config；当次 Pub 命令
在后续原生插件注入阶段因缺少 `HOS_SDK_HOME` 退出，不能据此记录整个命令通过。
当前副本的重新求解、原生编译和设备结果仍待验证。

### 4.1 nativeapi 的隔离边界

原应用锁定 `nativeapi 0.5.2` / `cnativeapi 0.5.2`。发布标签对应
`libnativeapi/nativeapi@60910d7d492d24497c13c172e2a270c7a7f0cae2`，其
[`cnativeapi/hook/build.dart`](https://github.com/libnativeapi/nativeapi/blob/60910d7d492d24497c13c172e2a270c7a7f0cae2/bindings/dart/cnativeapi/hook/build.dart)
只处理 Android、iOS、Linux、macOS、Windows，其他目标抛出 `UnsupportedError`。
运行时 `isDesktop == false` 无法自动移除构建 hook。

当前 OHOS 专用包副本选择该包自身已经生成的纯 Dart API 镜像，保留应用使用的
`Size` / `Rectangle` 等值类型，并从这一图中移除桌面 C hook 的依赖。镜像中的系统
操作明确抛出不支持错误，不会让窗口、托盘或屏幕操作假称成功。原应用桌面 gate 保留，
普通平台的原包与锁文件不改。

该做法是 **桌面能力的构建隔离**，不是 nativeapi 的 OHOS 窗口/托盘实现。
解析后的图必须复验 `cnativeapi` 没有被其他依赖带回；其他 native-assets hooks、
JNI、`win32` 也仍需通过实际编译核查。`DeviceUtils.sdkInt` 是惰性静态字段，已观察
调用点有 Android 条件保护，不能仅凭 JNI import 就改写应用或全局伪装平台。

### 4.2 当前准备的原生接口

| 功能 | 当前专用依赖/桥接方式 | 明确的后续验证 |
| --- | --- | --- |
| 文件选择与导入导出 | 保留 `file_picker 13.1.0` 及静态 API；新增叶子适配到固定 OHOS 原生文件选择实现 | `XFile` 内容/路径、取消、多选、导入导出、非沙箱 URI |
| 图片选择与裁剪 | 固定 OHOS image picker；`image_cropper 12.2.1` 追加同版本 OHOS 原生目录 | 原裁剪参数、返回图片、取消和错误 |
| 内嵌 WebView | 固定 `CPF-Flutter/flutter_inappwebview@88c6360100725c4723675721f5f615c9f2e0a7a1` 的 OHOS 实现与匹配接口 | 登录验证码 JavaScript handler、Cookie、导航、网页下载 |
| 音频服务/会话 | 保留当前锁定 Dart fork，嫁接固定 OHOS 原生目录并增加对应平台分支 | AVSession、音频焦点/打断、耳机断开、后台任务；有实际播放后端后再验完整播放控制 |
| 方向传感器 | 保留当前 `native_device_orientation` Dart API，追加 OHOS 原生实现 | 传感器事件、权限、横竖屏与资源释放 |
| 路径、链接、网络、设备信息、电量 | 固定真实 OHOS 叶子，必要时增加与当前 platform interface 匹配的 Dart 适配 | 冷/热启动深链、目录可写、网络变化、字段与事件类型 |
| 分享 | `share_plus_ohos 1.0.0` 与当前 `ShareParams` API；为内存文件准备真实临时文件 | 文本、URL、文件/内存图片、用户取消和目标应用读取 |
| 屏幕亮度、媒体音量、常亮 | 真实 OHOS brightness / volume / wakelock 实现 | 获取/修改/监听、注销、退出恢复；系统亮度写入限制不得伪报成功 |
| 图片/视频保存 | 原锁定 `saver_gallery 5.1.0` 已含 OHOS 系统逐次保存确认与实际复制 | 取消、拒绝、失败和保存内容完整性 |
| 权限 | 真实 permission-handler OHOS 通道及当前 Dart platform interface 适配 | 仅将原生实际结果转换为对应状态，不将未知权限或未实现能力标为已授权 |
| 根页面返回 | 新增 `PiliPlusPlatformPlugin` 的 `piliplus/ohos` 通道，调用 `UIAbilityContext.moveAbilityToBackground()` | 返回桌面后进程/页面/数据仍在，前后台生命周期正确；ArkTS 编译与设备操作待验 |

关键 OHOS 原生来源固定在以下提交，完整 URL、包版本和发布包 SHA-256 以依赖 manifest
为准，不能用浮动分支最新状态替代：

| 原生来源 | 固定提交 |
| --- | --- |
| `openharmony-sig/fluttertpc_file_picker` | `aae2f8828ea4d631362d6252e78d2773412747ff` |
| `openharmony-sig/flutter_packages`，image picker | `881e0dbe8fbf67faf541574f93557f826f3ceb3e` |
| `openharmony-sig/fluttertpc_image_cropper` | `6844f7d86b7dfc34e164fa913d8624fd114f3a32` |
| `openharmony-sig/fluttertpc_audio_service` | `c37addafcebc615c3cf6feb9e3e40440bd15b0c9` |
| `openharmony-sig/flutter_audio_session` | `62af3718564bca39e8eba77c9cf8a75aeebfd43e` |
| `openharmony-sig/fluttertpc_native_device_orientation` | `fb062f19fb6ea3c5d889bf9b508d70e50af63c4e` |

音频和文件选择的原生来源版本与当前 Dart 包并非完全相同，因此保留上层 API 后的
适配是需要编译和行为验证的工作，不能把“拿到原生目录”当作接口已经兼容。

### 4.3 移动端调用不能被静默关闭

新增 `PlatformUtils.isOHOS` 使用实际系统名称判断并纳入 `isMobile`，会让原 main
执行 `setupServiceLocator()`、方向/系统栏配置和非 Android 移动端的
`ScreenBrightnessPlatform.instance.setAutoReset(false)`。原亮度叶子确有对应实现，
但真实初始化和原生注册仍要验证。

还会启用原音量/亮度手势、方向订阅、`mobile_observer`、分享、相册和已有移动端设置。
不能为了绕开缺失插件再次把 OHOS 归为桌面或关闭这些入口。播放器暂缓是本轮明确的
例外；不应借它删除其他移动端功能。

`path_provider` 的支持目录和临时目录在启动早期使用；`PiliScheme` 在主页面初始化；
验证码同样使用内嵌 WebView。把验证码改成外部浏览器、只提供静态首页或复制参考项目
的功能精简入口，都不满足本任务要求。

## 5. 应用源码补丁与主题保留

当前补丁在 [app_patches](../../tool/ohos/app_patches/README.md) 中以普通 unified diff
保存，由唯一完整上下文匹配执行，不根据行号做模糊匹配。旧/新上下文缺失、重复或
同一文件部分应用均失败；全部预检后才写文件，写入错误会回滚本批修改。

### 5.1 六个自定义控件的 43 个 switch

| 应用原文件 | switch 兼容点 |
| --- | ---: |
| `lib/common/widgets/flutter/vertical_slider.dart` | 3 |
| `lib/common/widgets/flutter/text_field/editable.dart` | 3 |
| `lib/common/widgets/flutter/text_field/text_field.dart` | 5 |
| `lib/common/widgets/flutter/text_field/text_selection.dart` | 17 |
| `lib/common/widgets/flutter/text_field/editable_text.dart` | 11 |
| `lib/common/widgets/flutter/text_field/cupertino/text_field.dart` | 4 |

官方 SDK 增加了 `TargetPlatform.ohos`。当前补丁补全 41 个 case 与 2 个 switch
表达式，保留原有平台的分支和实现。选择控件沿用原触摸平台处理；选择菜单滚动淡出
遵循官方 OHOS SDK 的关闭值。仅修改枚举 case 不足以完成文本输入适配，因此还对
移动端方向变化时隐藏菜单、密码末字显示和分享按钮顺序增加真实 OHOS 条件。

应用的 `EditableText` / 文本选择控件是本项目自己的源码，不会自动继承 SDK 同名
文件的 OHOS 修复。输入连接配置刷新、失焦结束 composing、输入法 composing
期间的选择手柄/长按/多击处理，采用固定官方 3.44 控件中的对应小块，放到原控件
的相同职责位置。来源见
[官方 editable_text.dart](https://gitcode.com/CPF-Flutter/flutter_flutter/blob/3ffe70c6280cc6ddf613bffa59dd70611f238f7e/packages/flutter/lib/src/widgets/editable_text.dart) 与
[官方 text_selection.dart](https://gitcode.com/CPF-Flutter/flutter_flutter/blob/3ffe70c6280cc6ddf613bffa59dd70611f238f7e/packages/flutter/lib/src/widgets/text_selection.dart)。
需要在中文输入法和真实键盘上验证 composing、提交、选择与取消，不以补丁应用成功
替代设备测试。

另外四个应用文件处理最小的平台入口：

| 文件 | 改动原因 |
| --- | --- |
| `lib/utils/platform_utils.dart` | 真实 OHOS 判断和移动端归类 |
| `lib/common/widgets/image_viewer/gallery_viewer.dart` | 沿用移动端图片预览的系统栏隐藏/恢复，不调用 Android JNI 窗口判断 |
| `lib/utils/image_utils.dart` | OHOS 保存前不请求不适用的全图库权限；真正调用系统保存确认，并检查批量图片与动态图片视频的 `SaveResult` |
| `lib/pages/webview/view.dart` | 给已实现的 OHOS `onDownloadStartRequest` 接上原应用下载提示与处理 |

`saver_gallery 5.1.0` 的 `SaverGalleryPlugin.ets` 使用
`photoAccessHelper.showAssetsCreationDialog` 逐次授权后实际复制文件；取消和失败
会返回 `SaveResult(false, ...)`。应用补丁不修改 `Permission.photos` 的授权状态，
只让 OHOS 走这个真实授权流程。WebView 的原生下载开始事件、MethodChannel 发送与
Dart 回调分派也已在固定依赖源码中逐层确认。

### 5.2 六个文件中的 Dart 3.12 兼容

首次使用完整依赖图与实际官方 Dart 3.12.2 分析 `lib`，出现的 7 个错误分别来自
下列 6 个文件。补丁按实际诊断添加，不复制另一项目的页面或减少原等待时间：

| 文件 | 保留行为的兼容处理 |
| --- | --- |
| `lib/pages/blacklist/view.dart` | `_BlockType` 构造器显式加 `const`，枚举值与标签不变 |
| `lib/pages/common/publish/common_publish_page.dart` | 隐藏输入面板前保留原 100 毫秒等待 |
| `lib/pages/episode_panel/view.dart` | 切换分集标签后保留原 225 毫秒等待 |
| `lib/pages/live_room/superchat/superchat_card.dart` | 截图等待使用零参数回调及 `Duration.zero`，保留异步事件轮次 |
| `lib/utils/reply_utils.dart` | 回复检查保留原 8 秒等待 |
| `lib/utils/request_utils.dart` | 动态插入与检查保留原 450 毫秒、5 秒等待 |

[官方 `Future.pause` 文档](https://api.dart.dev/dart-async/Future/pause.html) 标记
`@Since("3.13")`；实际 Dart 3.12 中用 `Future<void>.delayed` 表达同样的等待，
不改变 `Duration`、请求顺序或条件。截图原回调没有参数，所以用
`() => Future<void>.delayed(Duration.zero)`，不能直接用需要时长参数的构造器 tear-off，
也不能替换为同步完成而不等待事件轮次的 Future。

### 5.3 不改变原主题算法

保留原锁定 `flex_seed_scheme 5.0.1`、`material_ui 1.6.0`、`cupertino_ui 1.1.2`
的 API 形态，主题继续调用 `SeedColorScheme.fromSeeds`，保留 `variant` 和
`useExpressiveOnContainerColors: false`。Flex 5.x 已使用 `material_ui`；不采用参考
脚本将 Flex 降级后再换成 `ColorScheme.fromSeed` 的方式。

原非 iOS 配置默认尝试动态色，而初始化仅捕获 `PlatformException`。当前 OHOS 没有
已验证的系统动态调色板插件，所以启动兼容只对 OHOS 补充 `MissingPluginException`
处理，继续原有 seed 配色回退，不替换颜色算法、不全局关闭设置、不声称已读取系统壁纸色。

不设置 `debugDefaultTargetPlatformOverride = TargetPlatform.android`。
[FontUtils](https://github.com/Goodwu/PiliPlus/blob/849c56b035ac8acf1b4fd677c2c94debe161da8e/lib/utils/font_utils.dart)
在未知系统有原本的默认路径；伪装 Android 反而会执行 Android JNI 的字体枚举。
自定义字体文件导入仍由原逻辑和真实文件选择接口处理。

## 6. 源码保护、验证记录和维护成本

当前检查与隔离约束如下：

- `check-source` 比较实际合入的上游共同祖先，同时检查提交、工作文件和 Git 暂存区，
  防止仅恢复工作文件后漏掉暂存区原文件变更。本轮重新执行时，1,639 个原文件差异为 0。
- `prepare` 只导出选定 Git 提交，拒绝仓库内输出、已有输出和不安全归档路径；不把
  未跟踪签名、缓存或本机内容带入，并验证全部原文件 Git blob。
- `prepare-build` 在导出副本中按环境、应用、平台、媒体、依赖的顺序执行。
  标记过失败或已配置的副本不能重放为新构建。平台步骤也逐级拒绝父目录符号链接，
  避免在副本之外写入原文件。
- 原 API、原补丁和包源码都有固定来源。原 SDK 补丁漂移、应用唯一上下文失配、
  下载摘要或固定提交不匹配都会明确失败；维护时应先审查内容，不能只更新摘要以跳过检查。
- 生成 manifest 记录真实原文件差异；依赖覆盖只存在于副本。新生成的锁文件和缓存
  不得反写标准 `pubspec.lock` 或原平台目录。

当前应用补丁的 13 项 Python 回归检查使用真实 main 文件复制出的 fixture，覆盖
16 个目标路径、其他文件保留、等待时长保留、摘要和变更计数、幂等、无关上游插入、末期上下文漂移、
重复锚点、部分应用、仓库/符号链接拒绝、可选包 URI 改名和写失败回滚。
这验证的是补丁工具的行为，不是 Flutter 控件或原生插件运行结果。

真实文件的集成检查也验证了应用补丁与 main/媒体补丁的先后顺序：重复应用既有
9 个应用路径时没有重复修改；新增 WebView 补丁只改变该第 10 个文件。后续完整
应用分析给出的 7 个错误已有另外 6 个文件的精确兼容补丁。新生成副本仍须重新执行
依赖求解、分析与编译，不能用这种文本级检查或旧环境的结果代替。

## 7. 后续实施顺序

| 阶段 | 当前基础 | 下一步与完成条件 |
| --- | --- | --- |
| 官方工具链 | 固定官方 3.44 提交、真实 Dart、完整 22 补丁与独立控件测试 | 将相同工具链用于完整应用；验证目标 engine / native 产物与宿主编译链配套 |
| 应用与依赖兼容 | 精确补丁、原生接口与固定依赖已新增；完成过依赖求解和首次应用分析，7 个具体兼容错误已有补丁 | 新副本重新完成 Pub 全流程和 analyzer，验证全部包解析到指定副本；依据实际编译继续修复具体错误 |
| 原生工程 | 新 OHOS 工程、资源、权限和 Ability 后台化桥接 | 生成实际插件注册、执行 ArkTS 与 HAP 构建，核查目标 ABI、原生库、资源和权限 |
| 非媒体功能 | 原页面与业务入口保留，文件/相册/WebView/系统能力有专用接入路径 | 真实设备完成下表非媒体验收，记录失败与限制；不能仅以主页可见认定完成 |
| 媒体后端 | 按用户指令暂缓；当前 API 与来源保留 | 收到后端接入任务后再实现库加载、视频输出、生命周期、普通播放及既有功能；本轮不提前扩大范围 |
| 上游同步 | 开发树原文件保护与上下文失败门禁 | 合并新的 main 后生成新副本，审查必要补丁漂移，只重复受影响能力的验证 |

## 8. 功能验收矩阵

每项实测记录应包含应用提交、固定 SDK/依赖组合、设备和系统版本、操作步骤、
实际结果及日志/截图位置。下表状态没有用 SDK 小测试或参考项目的成功结果代填。

| 功能组 | 必须验证的操作与结果 | 当前验收状态 |
| --- | --- | --- |
| 原界面与业务 | 首页、搜索、动态、消息、个人/详情页和设置仍来自 main；无参考项目页面或设置；主题、列表、输入、选择/复制正常 | 待完整应用与设备验证 |
| 启动与持久化 | 首装/冷启动、数据升级、设置和账号保留、支持/临时/缓存目录真实可读写 | 待验证 |
| 登录与验证码 | 原登录方式、验证码页面加载、JavaScript 回调、Cookie 交付、取消和失败 | 待验证，必须使用原内嵌流程 |
| 深链 | 冷启动与运行中接收 scheme / 支持链接，参数和导航正确且不重复处理 | 待验证 |
| 文件与数据 | 原文件选择、导入/导出设置、字体和字幕文件、取消、无空间及 URI 访问 | 待验证 |
| 分享与相册 | 文本/URL/图片/内存文件分享；图片/视频真实保存；用户取消或拒绝不报成功 | 待验证 |
| WebView | 网页、导航、Cookie、JS 桥、下载回调、返回、外部浏览器操作 | 待验证 |
| 根页面返回 | 系统返回和既有主页返回触发后台化；重新进入后页面/状态保留 | 原生桥接已编写，待 ArkTS/设备验证 |
| 系统能力 | 网络变化、应用信息、电量、权限、方向、常亮、亮度/音量事件和注销 | 待验证；应用亮度和系统亮度权限需区分 |
| 下载 | 原有下载、暂停恢复、缓存列表和清理、文件完整性、失败重试 | 待验证；离线播放属于下列媒体暂缓项 |
| 视频与直播 | 普通视频、番剧、直播、首帧、声音、清晰度/音轨、seek、倍速、循环/连播和 EOS | 媒体后端按用户要求暂缓 |
| 弹幕、字幕与播放器操作 | 既有弹幕/字幕与布局，手势、全屏、方向、预览和画面操作 | 与媒体接入后一起验收 |
| 后台与音频 | 系统会话、音频服务开关、焦点/打断、耳机断开、锁屏控制、听视频和后台播放 | 插件准备中；完整播放行为随媒体暂缓 |
| 动态图片与转码 | 动态图片视频播放、原动图导出、本地缓存播放 | 暂缓；静图显示和视频文件保存另行验证 |
| 画中画 | 支持平台上的进入、退出、恢复和播放状态 | 未接入，不能标为已保留可用 |
| 其他平台与同步 | 标准源文件/依赖差异为 0；合并新 main 后重新生成，复验受影响功能 | 源码保护已检查；新基线同步和编译另验 |

原平台特有能力如果 OHOS 暂无对应实现，应记下具体限制和用户可见结果。原系统字体
枚举、Android 专用刷新率/快捷方式/画中画等条件不能全局改成 OHOS 后直接调用 JNI，
也不能因源代码仍在就声称这些系统能力已经工作。只有当前基线的真实构建和功能证据，
才能将相应项目从待验证或暂缓更新为通过。
