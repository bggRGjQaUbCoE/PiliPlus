# marble DV P8.4 路由劣化到 reshape 且效果发灰（marble-dv-p84-route-regression-20261023）

## Current State（2026-10-23 凌晨·修复轮）

- **两项修复已实施并实机验证；media-kit（Java+Dart 注释+需求文档）与 App（零改动，仅重建）改动在工作区未提交。**
  - **修复A（reshape dataspace 生效）**：`PlatformVideoView.java setColorSpace(Surface,String)` 重排 API≥34 路径——先 `setSurfaceDataSpace`（native 桥 `ANativeWindow_setBuffersDataSpace`，dlsym 解析，API28+ 恒在），成功即返回 `ndk`；`surfaceControl` 一次性层事务降级为窗口设置失败后的回退（保留 readback 豁免语义）。根因：一次性 `SurfaceControl.Transaction.setDataSpace` commit 后被 BLAST 逐帧 buffer 事务（携带窗口默认 SRGB dataspace）覆盖，层恒 V0_SRGB；生产者侧窗口设置让每帧事务自带 PQ。API<34 分支零改动。验证（中间包 `83af7d78…`，不带本地 JAR→reshape 路径）：`setBuffersDataSpace symbol=resolved dataspace=163971072 publicResult=0 actualDataspace=163971072`；`HdrDiag HDR readback: path=ndk applied=true readback=DATASPACE_BT2020_PQ`；SF 视频层 `dataspace=BT2020_PQ (163971072)`（修复前 20 层全 SRGB/UNKNOWN 零 PQ）；播放推进（6%→采样时）、零 FATAL/ANR；`platform_video_view_dataspace_report_test` 7/7。需求文档 §8 第 268 行补 API≥34 首台实机注记。**待用户面板观感验收**；dvP84×reshape 仍 experimental（RPU 到不了 gpu-next，HLG 基层→PQ 非真 DV 观感——恢复 native DV 后此路径仅作无 bridge 链的安全网）。
  - **修复B（恢复硬解 DV）**：`flutter build apk … --android-project-arg mediaKitLocalArm64Jar=/Users/wuweiwei1/src/media-kit/libs/android/media_kit_libs_android_video/android/build/libmpv-android-v2026.013/mks-arm64-v8a-opaquealpha.jar`（gradle 输出确认 `Using local arm64 libmpv jar SHA-256: f5461124…`；APK libmpv 含 bridge 字符串）。APK SHA-256 `2367b927ab9dc84ad8bf8054584a051dcf32cb73631081d320e3bf3fe1165de1`（27.7MB）已装 marble。验证（深链 BV1vY4y1N7TY）：`HDR predict selected=nativeDolbyVision confidence=verified candidates=nativeDolbyVision:ok,…`；`phase=applied vo=mediacodec_embed hwdec=mediacodec output=dolbyVision verified=true`；MediaMetrics `c2.dolby.decoder.hevc: configure 3840x1920`（pid 11872 当前进程）；播放推进 14%；零 FATAL/ANR。
  - **开放项**：①发布 JAR v2026.013 缺 native DV bridge（mpv d24c59905 早于 `ca571a35a8`+FFmpeg native_dv），默认构建在 P8.4/P5 硬解设备必落 reshape——发布 JAR 升版收录待立项（与 LYA 任务的"发布 JAR 更新方式待定"同题）；②reshape 面板观感用户验收；③改动提交需用户授权（media-kit 工作区另有 ROUTED-REPORT-EXPOSURE 未提交改动，互不冲突）。
- **experimental 条件控制复查轮（2026-10-23 凌晨）**：用户重申既有决策"maturity 只作诊断、出问题解决问题"，指令复查并取消全部残留。方法：对 media-kit `media_kit_video/lib`、`media_kit/lib`、Java/C、App `lib/` 全量 grep `experimental`/`maturity`/`实验`，逐一判读命中。结论：**无任何 maturity/experimental 行为分支残留**（此前决策已在代码层完全落地）——planner/realizer/session/native-DV-policy/open-plan/review/report 层 maturity 仅作字段携带与诊断字符串；`HdrStrategyMaturity` 唯一比较在 `HdrCandidate==`。表面命中两处非门控：`VideoRouteOptions.fromMap` 的 `'experimental'` 键是丢弃旧字段的迁移代码；`demuxer-lavf-o=strict=experimental` 为上游 media-kit 的 FFmpeg demuxer 标志。处置：`HdrRoutePlanner._evaluate(_candidates)` 的 `gateMaturity` 参数（已移除门控的历史命名，现仅取反为 `isSafetyNet`）改名 `safetyNet`（默认 false、fallback 传 true、`isSafetyNet: safetyNet`），doc 同步去"maturity gate"措辞——纯重命名零行为。保留项及理由：`experimentalStrategySkipped` 死枚举（"kept only as part of the typed reason vocabulary"，planner_test 三处以 `isNot` 反向断言钉住不产生，删之反失护栏）。相邻结构性拒绝（非 experimental、未动）：nativeDV 白名单 P5/P8.4=FFmpeg 单层契约、dvP10/AV1=Phase1 范围、Hdr10Plus/Vivid=无实现、dvP5 baseLayer=错色安全、`_convertRouteLock`=lab define 生产默认 pq。验证：`hdr_route_planner_test` 48/48、maturity_table/route_admission/v73_no_implicit_sdr/source_routing 批 29/29、目标 analyze 零问题。

## 诊断轮（2026-10-23 00:41，只读）

### 原因1：路由劣化＝装机 APK 的 libmpv 缺 native DV bridge（构建通道回退到钉住发布 JAR）

复现（marble `dede0cd2`，装机 `bd8a2d4f` 2026-10-23 00:28:57，深链 BV1vY4y1N7TY）：

```
HdrDiag HDR capability: sdk=35 displayHdrTypes=1,2,3,4 hevcDecoders=8 hevcMain10=true hevc4k=true dvDecoders=2 p5Pipeline=true bridge=true ext=none
HdrDiag HDR predict: source=hevc,hlg,bt.2020,dolbyVision,8,4,false class=dvP84 selected=metadataReshape candidates=nativeDolbyVision:nativeDvUnavailable,metadataReshape:ok,baseLayerDirect:ok,baseLayerConvert:ok,toneMapSdr:displayLacksTransfer×3
HdrDiag HDR decision: phase=applied ... selected=metadataReshape vo=gpu-next hwdec=mediacodec output=pq surface=pq requested=pq path=surfaceControl verified=true
```

- `nativeDvUnavailable` 的判定链（`hdr_strategy_realizer.dart:272-281`）：需要 dolbyVisionDecoders 含硬解器且 profiles 含 256（marble 满足，`dumpsys media.player` 确认 `c2.dolby.decoder.hevc`）**且** `nativeDvBridgeApi==1`。
- `nativeDvBridgeApi` 来源：`MpvPipelineProbe` → 一次性 mpv 实例读 fork 属性 `android-native-dv-bridge-api`（`player/command.c:4601`，提交 `ca571a35a8`）→ 属性处理器依赖 FFmpeg fork `hevc_mediacodec` 的 native_dv 选项集（`native_dv_api_version` 等导出项）。
- **装机 APK 的 libmpv.so（提取自设备 base.apk，SHA-256 176bc5a6…）不含 `android-native-dv-bridge-api`/`native_dv_api_version` 字符串**（`dovi-p5-pipeline` 在）→ 探针必然 0。
- JAR 指纹比对：APK helper.so `a6862031` ＝发布 JAR＝opaquealpha JAR（三者相同无区分度）；libmpv 字符串：钉住发布 JAR v2026.013（`media-kit-d24c59905-ffmpeg-b4d2ea4-arm64-v8a-vkweak.jar`，SHA 0e06f383…）**缺** bridge；mks JAR f9205a77 与 opaquealpha f5461124 均**含**。结论：bd8a2d4f 构建未带 `--android-project-arg mediaKitLocalArm64Jar=…`，打了发布 JAR 的 libmpv。
- 历史对照：r21 codec-stats APK（5734f95a，libmpv 5cccfaa8…，当时 marble 实测 MediaMetrics `c2.dolby.decoder.hevc` 进 native DV）libmpv 含 bridge → **native DV 一直依赖 mks 本地 JAR 通道；发布 JAR（mpv d24c59905）从未含 bridge**。诊断行三个构建（23:43/23:57/00:28）都没带本地 JAR。
- 取证教训：macOS `strings` 会漏报部分 .rodata 字符串（opaquealpha JAR 曾被误判缺属性），二进制字符串结论一律 `grep -a` 复核。

### 原因2：reshape 发灰＝API≥34 surfaceControl dataspace 事务 commit 但不生效（PQ 被按 SDR 合成）

- apply 机制（`PlatformVideoView.java:787-818`）：API≥34 分支一次性 `SurfaceControl.Transaction.setDataSpace(surfaceView.getSurfaceControl(), DATASPACE_BT2020_PQ)` + commit 监听，**完全跳过 ndk 生产者侧路径**（`ANativeWindow_setBuffersDataSpace` 仅 API<34 分支使用）。日志 `setColorSpace: transfer=pq, transactionCommitted=true` ×2（00:41:01.270/.337）→ `path=surfaceControl applied=true`；`readback=0x00000000`（buffer 侧，此路径文档明示不保证一致）。
- 合成层实测（`/tmp/marble-sf-reshape.txt`）：**全机 20 个层 dataspace＝15×V0_SRGB + 5×UNKNOWN，零 BT2020_PQ**、`hdr metadata types=0`；面板能力齐全（displayHdrTypes=[1,2,3,4] maxLum 420）。→ rgb1010102 PQ 编码输出按 SRGB 合成＝颜色偏淡、无 HDR。
- 佐证边界：dvP84×metadataReshape 成熟度 experimental（"重建管线只在 P5 验证过"）；LYA reshape 正常靠 `ext:lya-pq` 厂商扩展（其 SF 层实测 BT2020 SMPTE2084）。surfaceControl 路径在 marble 属首次真实踩到，从未验证过。
- 附注（设计层）：P8.4 reshape 走 `hwdec=mediacodec` 时 DV RPU 到不了 gpu-next/libplacebo，动态元数据无法真正应用；即便 dataspace 修复，也只是 HLG 基层→PQ，不是真 DV 观感。真正符合红线（HDR 必须真实输出且硬解）的路是恢复 nativeDolbyVision。

### 修复方向（待用户定夺，未实施）

1. 恢复 marble native DV：构建带 `--android-project-arg mediaKitLocalArm64Jar=<mks JAR>`（opaquealpha f5461124 即含 bridge+全量 fork 功能）；或发布 JAR 升版收录 `ca571a35a8`+FFmpeg native_dv。
2. reshape API≥34 dataspace 路径真修复（生产者侧 setBuffersDataSpace/逐帧事务），media-kit 侧独立工作包；在修复前该格在 marble 观感不可用。

## 证据清单

- 修复轮：logcat 01:33（reshape 验证，path=ndk/readback PQ）与 01:35（native DV 恢复，applied verified）；`/tmp/marble-sf-reshape-fixed.txt`（BT2020_PQ 层）、`/tmp/marble-reshape-fixed.png`；中间包 `83af7d78…`、最终包 `2367b927…`。
- 诊断轮：logcat 00:41 复现轮 HdrDiag 全序列（HdrDiag HDR capability/predict/decision/readback/review/classify + setColorSpace）。
- `/tmp/marble-sf-reshape.txt`（SF 全量 dump，零 PQ 层）、`/tmp/marble-reshape-washed.png`（发灰画面截屏）。
- JAR/APK：`/tmp/jar-cmp/{oa,oldmks,def13}/lib/arm64-v8a/libmpv.so`、`/tmp/marble-apk-ext/…`、`/tmp/codecstats-ext/…`；各 SHA 与字符串判定见 TASKS.md 条目。
