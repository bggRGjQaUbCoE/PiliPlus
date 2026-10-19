# PiliPlus OHOS：当前 media-kit 已接入并完成 Release 编译

最终目标是 `Goodwu/PiliPlus:feature/ohos`。PiliPlusX 只作参考，不作为构建、交付或回退应用。方向 B 已批准，不再要求通用透明 Player 拦截。

## 本轮实际结果

完整应用构建 run **39257755406**、job **118077226999** 已成功；不是 SDK 示例，也不是旧媒体暂缓包。实际源码是应用 `6cf36e3591db01826c15abe5fd95fde91f2a3a0f`、SDK `b4cd48cdd900ece7e2628bd3dcc2b40f6dda3c02`、原生配方 `8bc1bd5840b626bebde2d9f37adcbe96dc15235b`。构建入口为原 `lib/main.dart`，产物为 ARM64 Release unsigned HAP，状态 `built-unsigned-media-integrated-device-unverified`。

| 验证 | 实际结果 |
| --- | --- |
| 原主线源码保护 | Git 输入的 1639 个原文件保持不变；导出副本中真实修改了 26 个原路径，逐一记录前后像 |
| 应用源码/媒体输入检查 | 54 项通过，保留原有 31 项 |
| SDK 原生归档/HAP 检查 | 14 项通过 |
| 原生 WebP 特性守卫 | 6 项本地及 CI 检查通过；真实 OHOS 交叉编译也通过 |
| 官方 CPF 框架完整 media_kit_video 回归 | run 39257755478：1025 通过、3 跳过、0 失败；Linux 主机端，不是真机 |
| 既有 SDK 扩展、parser 和应用 UI 检查 | SDK 4 项、UI 2 项通过；parser 通过 |
| 完整应用 Dart 分析 | 0 错误、1 警告、41 条提示，退出码 0；未修改原有非致命警告策略 |
| 真实完整应用 HAP | 编译、源码复核、包内本轮 libmpv 字节一致性及上传全部成功 |
| 签名、设备安装及媒体功能 | 未验证；没有可用签名/设备，不是上线认证 |

唯一 Dart 警告为 `lib/pages/video/controller.dart:79:48` 的 `hide Subtitle` 指向未导出的名字（`undefined_hidden_name`）。它不是编译错误，保留于日志；不能把本轮说成零警告或将 Dart 分析结论外推为原生工程无警告。

完整 HAP 为 **80,813,873 字节**，应用版本 **2.1.6+1**，保留目标原包名 `com.example.piliplus`。SHA256 为 `0d3f2aa62a5f84be2922d601c942ae4aa1563aa4977ef84f740e8909fe698d23`。包内 `libmpv.so` 与本轮新构建库逐字节相同，SHA256 为 `258c683580b6db227095b82d4329033cd778f70855f0ffa894c9f925bd05307f`；两个 OHOS 桥及所有七个原生库均为 ARM64 ELF。完整来源、artifact、摘要和开放验收见 [本轮媒体验证记录](media-integration-validation.json)。

## 实施内容

构建副本先应用经过七文件原像/后像和摘要审核的 SDK 方向 B 补丁，再叠加原有 OHOS 平台、Dart 3.12、Flutter 控件和插件适配。主视频、直播和画廊使用 `RoutedVideoPlayback` / `RoutedSimpleVideo`；媒体初始化、音频、Live Photo 和 WebP 恢复真实入口，移除旧媒体暂缓逻辑。原网络、账户、主题和业务基线保留。

SDK 从本轮干净 checkout 导出，1466 个源条目（含 39 个合法相对源码链接）均校验，解析中的 15 个 media-kit 包确认指向该导出而非旧 fork。原生库每轮重新从维护源码编译，补齐 WebP 动态编码器和封装器；manifest 绑定配置/注册表/最终库，不接受旧二进制或缺能力输入。细节见 [接入说明](media-integration.md)、[输入修复记录](media-build-input-fixes.md)。

OHOS 仍使用 SDK 既有 OHOS 输出，不借用 Android HDR 路由的验证结论。实际播放、鉴权/EDL、切源、暂停/后台恢复、字幕、画中画、截图、WebP 导出、HDR 持续显示和设备加载都要在签名后的目标设备逐项验证。原生编译具备 WebP 不等于设备导出成功。

## 构建入口和历史边界

请使用 [当前媒体构建指南](media-build-guide.md)，其中列出当前 SDK checkout、原生归档/SHA256/SO/manifest 输入和原有 prepare-build/build.py 用法。应用工作流与 SDK 仓库的 reusable workflow 均构建这个完整目标，而非另一个上游 main 的版本预检。

旧 [validation.json](validation.json)、部分旧 tool/ohos 文档及 doctor/依赖描述中的 deferred 字段属于媒体暂缓阶段资料，不是当前媒体状态；当前状态以本轮 `ohos/media-backend.json`、`ohos/source-manifest.json`、`ohos/build-result.json` 和本文对应的实际日志为准。旧证据原样保留，不覆盖成新成功结果。

收口提交仅更新 docs，不修改已测试的运行代码、构建脚本或测试。记录 SHA 是为了标识实际验证版本，不是长期钉定旧二进制。后续代码或来源发生变化必须重新构建验证，不用本轮绿灯代替。
