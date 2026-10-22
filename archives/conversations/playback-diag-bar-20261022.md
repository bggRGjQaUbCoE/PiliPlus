# PLAYBACK-DIAG-BAR-20261022

## Current State

- **已本地提交（未推送）**：视频页底部控制栏两行播放诊断信息（设置→播放设置→「播放诊断信息」开关，默认关）。行1 路由事实：`kind strategy/presentation/outputTransfer topology vo=<vo> ds=<dataSpacePath> ✓verified | degraded:<reason> | route-error | route:pending`（取自 `HdrOutputReport.actual` 与 `sourceFacts.source.kind`）；行2 解码事实：`decoderDescription→decoder→hwdecCurrent` 逐级回退（实际解码器组件名）+ `WxH@fps` + hwPixelFormat/pixelFormat 去重；legacy 分支 `hwdec=` 同步读 + async `current-tracks/video/decoder` 缓存。
- **依赖 fork 接口**（media-kit `ROUTED-REPORT-EXPOSURE-20261023`，同批提交）：`RoutedVideoPlayback.report` 转发 getter + export `HdrDecoderObservation`。App 经此消费 `HdrOutputReport`，无其它路径。
- **验收状态**：analyze 72 issues 持平零新增；两轮 V1 review 可交付；APK `bd8a2d4f…e466cf` 已装 marble（2026-10-23 00:28:57）。**实机显示与路由事实正确性待用户目检**（建议 HDR/DV 源对照 logcat `HdrDiag`）。
- 遗留（可接受/待定）：非 Android 恒显示 `route:pending`（路由报告仅 Android 有）；开关为设置项，用户可要求换控制方式；player 替换后 tracks 订阅指向旧流仅影响 legacy 分支 decoder 新鲜度。
- **构建环境事实（重要，影响后续所有 Android 构建）**：本机 Homebrew JDK 已升 27，其 jlink 拒绝 AGP 合成 java_base.jmod（JdkImageTransform 失败）；已 `brew install openjdk@21`（keg-only），构建须带 `JAVA_HOME=/opt/homebrew/Cellar/openjdk@21/21.0.13/libexec/openjdk.jdk/Contents/Home`，或 `flutter config --jdk-dir` 持久化（未做，待用户定）。Flutter SDK 必须用 `~/flutter-sdks/3.47.7`。

## 需求演变与实施历史

1. **2026-10-22 晚 初版（用户："状态栏加路由信息和编解码信息，改动尽量小"→"加在控制栏吧"）**：两 scout 调研后定为 BottomControl 内单行 `routed:ok | hwdec=… | codec WxH pixfmt | /videoV`，开关三层（storage_key/storage_pref/play_settings），APK `86133b99…` 装 marble。
2. **首验失败（用户："没看到"）**：screencap 取证——全屏控制栏收起，诊断行随 AppBarAni 滑出；且 GetX 路由栈保留视频页、开关切换不触发 build。改常驻 OSD 层（view.dart Positioned bottom:12 + Obx 读 showControls 即时生效），APK `e01e6036…` 装 marble。
3. **二轮改版（用户："回退控制栏显示；开关是你加的？；重复多信息少，要具体路由不要 routed:ok；要编码类型，mediacodec 有两个；videoV 信息不明"）**：
   - fork scout 确认 `HdrOutputReport.actual`/`decoderObservation`/`sourceFacts.source.kind` 全在库内，只差暴露。
   - fork worker：`RoutedVideoPlayback` 加转发式 `report`（`_reportView` 永不 dispose、闭包捕获局部 session、退役/dispose 重置 const），export `hdr_decoder_review.dart`；测试 14/14 + 契约 9/9（全量 1231 过/1 既有失败无关）。
   - App worker：view.dart 还原零 diff；bottom_control.dart +3 重插；playback_diag_bar.dart 重写两行（去 /videoV、去 routed:ok、字段去重）；APK `bd8a2d4f…` 装 marble。
   - V1 review（两仓）：可交付无阻断；建议项见"遗留"。

## 关键依据

- 字段事实：`HdrOutputReport`（`../media-kit/media_kit_video/lib/src/hdr/hdr_output_report.dart`：actual/hwdecCurrent/verified/degradeReason/sourceFacts/decoderObservation/dataSpacePath）、`HdrRoute`（hdr_route.dart：strategy/presentation/outputTransfer/topology/vo/hwdec）、`HdrDecoderObservation`（hdr_decoder_review.dart:14-54：decoderDescription=decoder-desc 实际组件名）。
- 挂载点：`bottom_control.dart` Column 首 child（控制栏内，随 AppBarAni 动画）；live 页独立 bottom_control 不受影响。
- 三轮 APK：`86133b99…`（初版控制栏内）→ `e01e6036…`（常驻版，已回退）→ `bd8a2d4f…`（二轮改版，当前）。
