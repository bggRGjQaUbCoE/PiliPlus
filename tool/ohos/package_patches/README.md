# OHOS 依赖补丁

这里的补丁只应用到导出构建副本的 `.ohos-dependencies/`。原 checkout 的
`pubspec.yaml`、`pubspec.lock`、业务源码及全局 Pub cache 不会被此工具改写。
源包版本、归档 SHA-256 和完整 Git commit 由相邻的 `dependencies.json` 固定。
更新上游锁文件后必须先复核清单；工具不会自动套用旧覆盖规则。

## 保留的上游接口

| 范围 | 隔离副本中的处理 |
| --- | --- |
| `material_ui 1.6.0`、`cupertino_ui 1.1.2`、`flex_seed_scheme 5.0.1` | 保留原锁定版本和配色算法。应用 PiliPlus 自带的 Material 补丁，并为 OHOS 加入对应的移动平台分支；没有退回旧版主题算法。 |
| `petitparser 7.1.0` | 将 117 个 Dart 3.13 构造函数声明和一个空类声明改为 Dart 3.12 的等价语法；保留其余算法正文、字段、参数、初始化表达式和控制流。 |
| `file_picker 13.1.0` / interface `4.2.0` | 保留主包接口，新增 OHOS 叶子适配器。文件导出把调用者传入的 bytes 实际写入系统选择器返回的 URI；取消返回 null，读写失败上报错误。目录返回值必须能被 Dart 文件 API 访问。 |
| `connectivity_plus` | 叶子适配当前列表接口，原生读取真实网络能力并返回全部 bearer；方法失败上报错误。 |
| `permission_handler_platform_interface` | 将应用使用的权限映射到实际 OHOS access-token 接口；未审核的映射抛出 UnsupportedError，系统拒绝保持拒绝。 |
| `share_plus` | 接入当前 `ShareParams`；内存文件先真实写入临时目录，再交给系统 Share Kit。插件只能确认面板调用，因此最终分享结果为 unavailable，不能据此宣称用户已完成分享。 |
| `image_cropper 12.2.1` | 保留当前 Dart 主包与 interface；仅添加固定版本 OHOS 原生实现，并将现有裁剪配置映射为对应 OHOS 参数。 |
| 原生模块入口 | `native_device_orientation` 的清单指向实际小写 `index.ets`；`image_crop_ohos` 作为真实源码 HAR 注册到导出副本的项目模块清单，保留裁剪代码、资源和页面路由。 |
| `audio_service` | 保留 PiliPlus 锁定的 Dart fork，只移入原生 OHOS AVSession。修正原生倍速事件误送为 seek，以及 shuffle 枚举索引。 |
| `audio_session` | 保留原有 Android/Darwin 代码，只添加 OHOS channel 和相应 core 分支。 |
| `flutter_inappwebview` | 保留当前主包，接入固定的 OHOS 叶子和匹配接口；回退参考 fork 中与 OHOS 无关的 localhost 错误页面变更。 |
| `wakelock_plus` | 将原生 Pigeon `IsEnabledMessage` 标签与锁定的 interface `1.7.0` 对齐；缺少 Window 或系统调用失败必须抛错。 |
| `screen_brightness_ohos` | 绑定真实 UIAbility/Window、修正系统亮度事件处理器；等待窗口亮度修改/重置完成，失败上报错误，系统全局亮度写入仍明确不支持。 |
| `flutter_volume_controller` | 原生每个请求只回传一次结果；缺少 controller、panel 或已就绪节点时明确失败，不保留失败请求的待执行音量更改。 |
| 桌面 `nativeapi` | 使用同一上游包已提供的纯 Dart API 镜像，保留值类型；真正桌面操作明确 UnsupportedError。删除这份副本对 `cnativeapi` 的依赖，隔离桌面 C 构建 hook。 |

其余 OHOS 插件按清单接入实际原生实现；只在需要时修正包的 SDK 下限、
federated interface 依赖及错误放在生产依赖中的 lint 配置。`meta 1.19.0`
保留原锁定版本，因为原锁定的 `petitparser 7.1.0` 使用它提供的 `preferInline`
注解；此覆盖仍需随完整应用 analyzer 和 kernel 编译验证。

## 复验和边界

`dependencies.prepare()` 下载后验证固定来源、应用补丁并记录规则摘要和运行源码
摘要。`dependencies.patch()` 在 Pub 解析后核对所有本地覆盖的实际 package roots，
并拒绝 `cnativeapi` 重新进入 OHOS 图。修改补丁或生成代码后必须重新导出构建副本，
不能静默复用旧准备结果。

`pub get` 仅验证依赖解析。ArkTS/HAP 编译、设备安装、系统授权/取消、文件 URI
访问、裁剪输出、分享面板、后台控制及窗口事件仍需各自的实际验证。系统明确不支持
的能力保持错误或上游既有回退，不伪造成功结果。media-kit 保留原有依赖与 Dart
接口，OHOS 播放后端按当前任务要求暂缓；本目录没有加入 HDR 或参考项目的业务功能。

`validation/petitparser_312.dart` 是独立编译与行为夹具，使用准备后的应用
`.dart_tool/package_config.json` 运行。它覆盖表达式、Unicode、失败结果、语法引用、
token 位置、匹配迭代、反射、缩进、profile 和原 XML 包集成。使用官方 SDK 的
`dart compile kernel --packages=<package_config.json> --output=<probe.dill> <fixture.dart>`
编译，再执行 `dart <probe.dill>`；不要启用实验语言标志。
