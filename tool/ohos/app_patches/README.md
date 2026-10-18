# Flutter OHOS 3.44 应用源码补丁

这些补丁仅由 `app_compat.prepare_application()` 应用到 `ohos.py prepare` 导出的
隔离副本；不修改开发分支的原始 `lib/`，也不修改 pubspec、SDK 或依赖包缓存。
基于 `Goodwu/PiliPlus@849c56b035ac8acf1b4fd677c2c94debe161da8e` 编写。

| 补丁 | 应用文件与行为 |
| --- | --- |
| `target-platform-344.patch` | 六个既有自定义控件，共补全 43 处 OHOS switch 分支，包含两个 switch 表达式。选择控件沿用原 Android 分支；滚动时选择菜单淡出采用官方 OHOS SDK 的关闭值。增加移动端方向变化、密码末字显示及输入法 composing 的 OHOS 条件。 |
| `mobile-platform-344.patch` | `PlatformUtils` 增加真实系统判断 `isOHOS` 并纳入 `isMobile`，让已有移动端插件初始化、生命周期、手势及设置入口运行。图片查看器沿用移动端系统栏隐藏与恢复逻辑，不进入 Android 的 JNI 窗口判断。 |
| `gallery-save-344.patch` | OHOS 图片与视频保存不先索取全图库权限，继续执行 `saver_gallery` 的真实系统逐次保存授权。批量图片与动态图片的视频保存会检查原生返回的 `SaveResult`，取消或失败返回 `false`，不误报保存成功。其他平台保留原路径。 |
| `webview-download-344.patch` | 将原先只有 Android 会接收的网页下载开始回调扩展到 OHOS，复用原下载确认与 URL 处理逻辑。 |
| `dart312-language.patch` | 首次完整应用分析发现的 6 个文件、7 处 Dart 3.12 不兼容点：枚举构造器显式加 `const`；5 处有时长的 `Future.pause` 改为等时长 `Future<void>.delayed`；截图等待回调保留零参数和下一事件轮次语义。 |

平台补丁只扩展真实平台分支，不把 OHOS 全局伪装为 Android。字体路径仍使用原有平台
判断，不会因此执行 `AndroidHelper.fontFamilies()`；JNI 相关 Android 条件保留。

自定义 `EditableText` 与 `TextSelectionGestureDetectorBuilder` 是应用自己的源码，
不会自动获得 SDK 同名控件的 OHOS 修复。输入连接配置刷新、失焦结束 composing、
composing 时不显示选择手柄/长按与多击菜单的几个小块，依据固定官方
[CPF-Flutter/flutter_flutter@3ffe70c6280cc6ddf613bffa59dd70611f238f7e 的 editable_text.dart](https://gitcode.com/CPF-Flutter/flutter_flutter/blob/3ffe70c6280cc6ddf613bffa59dd70611f238f7e/packages/flutter/lib/src/widgets/editable_text.dart)
与 [text_selection.dart](https://gitcode.com/CPF-Flutter/flutter_flutter/blob/3ffe70c6280cc6ddf613bffa59dd70611f238f7e/packages/flutter/lib/src/widgets/text_selection.dart)
移入原控件的对应位置，只在真实 OHOS 分支执行。没有复制另一项目的界面或业务代码。

保存流程依据原锁定的 `saver_gallery 5.1.0`（pub archive SHA256
`dcecd87113ffcb0eb467bb0ef5ed8f6dd894e26ff3dfd5822624281e7d2cb894`）。该包的
`ohos/src/main/ets/components/plugin/SaverGalleryPlugin.ets` 通过
`photoAccessHelper.showAssetsCreationDialog` 取得逐次保存许可，再实际复制文件。
前置条件跳过的是不适用的全图库请求，不会让 `Permission.photos` 假称已授权，
也不会跳过系统保存确认。

WebView 回调已在固定
[CPF-Flutter/flutter_inappwebview@88c6360100725c4723675721f5f615c9f2e0a7a1](https://gitcode.com/CPF-Flutter/flutter_inappwebview/tree/88c6360100725c4723675721f5f615c9f2e0a7a1/flutter_inappwebview_ohos)
的 `InAppWebViewClient.ets`、`WebViewChannelDelegate.ets` 和
`lib/src/in_app_webview/in_app_webview_controller.dart` 确认存在原生事件发送及
Dart 回调分派。本补丁只打开已实现能力的应用入口，没有改变网页或登录页面。

`dart312-language.patch` 来自使用实际官方 Dart 3.12.2 执行完整 `flutter analyze lib --no-pub`
得到的诊断，不是按版本号猜测。[官方 `Future.pause` API](https://api.dart.dev/dart-async/Future/pause.html)
标记为 `@Since("3.13")`。替换保留原有的 100、225、450 毫秒以及 8、5 秒等待，
不会减少回复或动态检查的等待时长。截图的零参数回调使用
`() => Future<void>.delayed(Duration.zero)`，保留等待事件轮次、让异步资源完成加载的行为；
不会改成同步完成的 Future。枚举只显式补全 `const`，原值、标签与业务分支不变。

主题继续使用原 `flex_seed_scheme` 的 `SeedColorScheme.fromSeeds`、原 `variant`
和 `useExpressiveOnContainerColors: false`。旧参考脚本将主题换成
`ColorScheme.fromSeed` 的做法没有采用。已锁定的 Flex 5.x 本身使用 `material_ui`，
相关 SDK/包级兼容由对应工具处理，不能通过换算法解决包类型问题。

每个 unified-diff hunk 被当作完整、唯一的旧/新上下文处理，不使用模糊匹配，
不以行号接近为理由选择重复的上下文。缺少、重复或同一文件内部分应用的上下文都明确失败；
所有文件通过预检后才写入。上游在其他位置增加内容不必重新生成整份应用副本补丁，
但确实触及这些上下文时仍需要维护，不能称为“零冲突”。

返回报告逐文件记录变更前后 SHA256、所用补丁和包 URI 替换数，并报告实际
`application_files_changed`。当前标准模式改变 16 个生成副本中的应用文件。
这些是实际源码改动，不会因为只发生在隔离副本中就省略。

包名小写规范化是可选项，默认关闭。在官方 OHOS Dart 3.12.2 上，包含
`name: PiliPlus`、`publish_to: none`、Dart `>=3.12.0 <4.0.0` 的独立包执行
`dart pub get --offline` 成功，因此本轮保留原包名。若后续实际编译明确要求
小写，调用者先修改副本 pubspec，再显式启用 `normalize_package_name=True`；
此时只改 `lib/`、`test/` 的 `package:PiliPlus/` URI，并单独报告扩大的文件数量，
不改变显示名称或任意包含 PiliPlus 的业务文本。

本模块不修改播放器、不制作播放器成功桩，也不宣称 HAP 或设备功能已经通过。
加入 `isMobile` 会实际启用音频、亮度、方向、分享等平台调用；对应真实插件和
原生权限仍须完成，不应为了隐藏缺失插件又关闭这些移动端路径。
