# 当前 media-kit 方向 B 接入

本记录取代先前媒体后端暂缓的构建目标，最终应用是 `Goodwu/PiliPlus:feature/ohos`；PiliPlusX 仅供参考。实现继续沿用现有 OHOS 构建副本，不改 Git 中主线的应用、网络、账户或其他平台文件。

## 本次实现

构建副本先应用 media-kit 仓中经过摘要和七文件前后像复核的方向 B 接入，再应用本分支已有的 OHOS 平台和 Dart 3.12 补丁。实际源码已检查两层可以完整叠加，无模糊匹配。主播放器、直播和画廊使用 `RoutedVideoPlayback` / `RoutedSimpleVideo`；OHOS 使用既有普通输出，不冒称 Android HDR 路由验证。

原 `defer_media` 不再运行：`lib/main.dart` 恢复媒体初始化和 API 版本读取；音频和 WebP 沿用真实入口；Live Photo 不再被强制退化成静态图。恢复正常播放器后，直播聊天沿用原有播放与路由生命周期，不叠加原本为“播放暂缓”设计的额外聊天启动器。

所有 media-kit 包从本轮所选干净 SDK checkout 导出到副本，保留 SHA、Git tree、逐文件原像和补丁摘要。应用已有的无关 OHOS 依赖和补丁保留；解析后必须检查实际包路径，不接受旧 fork、旧事件循环包或其他源混入。准备后的应用 Dart 和 SDK 源码在构建前后再次核验。

原生库由当前 `Goodwu/libmpv-ohos-build:main` 配方从源码重新构建，保留 source-lock、补丁、SBOM、manifest 及产物摘要；CMake 消费明确的归档/SHA256 对，不允许失败时回退历史下载。完整 `lib/main.dart` HAP 检查应用版本、ARM64 ELF，并核验包内 `libmpv.so` 与本轮库逐字节一致以及两个 OHOS 桥。

## 构建输入

除原构建文档的官方 CPF SDK、独立 Pub 缓存、OHPM/Hvigor 和 Java 17 外，需要四个真实输入：

```sh
export PILIPLUS_MEDIA_KIT_ROOT=/absolute/path/to/clean-current-media-kit-checkout
export MEDIA_KIT_OHOS_LIBMPV_ARCHIVE=/absolute/path/to/current-build/libmpv_aarch64.zip
export MEDIA_KIT_OHOS_LIBMPV_SHA256=$(sha256sum "$MEDIA_KIT_OHOS_LIBMPV_ARCHIVE" | cut -d' ' -f1)
export PILIPLUS_OHOS_LIBMPV_LIBRARY=/absolute/path/to/current-build/libmpv.so
```

SDK 使用 `Goodwu/media-kit:compat/piliplus-zero-change-20261018`；每轮解析当前 HEAD，SHA 仅标识实际输入，不是旧二进制的长期钉定。已有官方 Flutter 回移配方及插件源锁继续做精确校验，不伪造版本。按原 `prepare-build` 和 `build.py` 入口执行；工作流会设置输入并完成原生重编。

## 验收边界

源码与补丁保护、parser/UI 测试、完整应用分析、目标 HAP、包内原生库身份均为独立门禁。新状态仅在这些步骤成功后写为 `built-unsigned-media-integrated-device-unverified`。这不是设备播放、字幕/画中画/截图/WebP 或 HDR 认证；真实设备功能仍需另行记录。旧 `validation.json` 是媒体暂缓构建的历史记录，不能用于认证本次新代码。

首批本地结果：原 31 项源码保护测试和新增 14 项媒体输入/补丁门禁测试全部通过；两套真实应用补丁完整叠加通过。完整应用 CI 结果待本轮执行，失败不会跳过或通过更改状态名称掩盖。
