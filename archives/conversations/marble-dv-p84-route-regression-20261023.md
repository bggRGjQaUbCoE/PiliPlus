# marble DV P8.4 路由劣化到 reshape 且效果发灰（marble-dv-p84-route-regression-20261023）

## Current State（2026-10-24 晚·构建闭环及首因修复已验证，按用户授权本地提交归档，不推送；提交事实以 Git log 为准）

- **源码构建→最终 APK→LG 安装闭环通过。** media-kit 标准 wrapper 依次调用当前本地依赖/mpv/helper 构建，生成新 JAR，再由新增 `tool/verify_android_test_apk.py` 核对 native receipt/JAR/最终 APK 的 mpv、helper、libc++ 三成员。mpv/helper 与 JAR 原字节一致，libc++ 与 receipt 钉定的 NDK `llvm-strip --strip-unneeded` 结果逐字节一致；四项 SurfaceTexture/native DV 标记、重复 ZIP/foreign ABI 拒绝门均通过。`dev` 缺本地 JAR 直接拒绝，避免静默打发布库。源码前后冻结16组、实际archive19项，sourceDrift=false；保留所有既有本地修改，无拉远程/切分支/复用发布JAR。
- **真实构建暴露并修复额外 ABI 问题：** 第一轮 Flutter `--target-platform android-arm64` 仍把其它插件的 v7a/x86_64 库打进 APK，新门正确拒绝，未安装。wrapper 改为始终 `--split-per-abi` 并只核验 arm64 split，拒绝关闭或覆盖原生来源/ABI 的参数；完整重跑后成功，不放宽检查。
- **最终产物：** JAR `46bba27c9f416362017936c62a2aa4bad722f4967852487af5b0ae7b0c974bc1`；APK `build/app/outputs/flutter-apk/lg-dvp84-source-20261024-release.apk`，27,541,013 B，SHA-256 `e17d3aee262d5e229df23d26b6d2d0c759d359ddab5eb98de55f11bf6bf028c9`；libmpv `6a657dd0da70af5ab7f562624c0b940b8b77c5a5dd9ebd736068cdde14ecc43a`。LG `com.example.piliplus.dev` 安装后 base.apk 回读同 SHA。native receipt `../media-kit/build/android-native/lg-dvp84-source-20261024-20261024-212929-74977/`；构建日志 `/tmp/lg-dvp84-source-build-20261024.log`（拒绝轮）、`/tmp/lg-dvp84-source-build-20261024-r2.log`（通过轮）。
- **构建规则归档：** PiliPlus `AGENTS.local.md` 已记录必须经 media-kit 当前源码构建原生库、核验最终 APK 库与本次产物一致，禁止直接使用旧 JAR 打包。
- **首因修复：** `hdr_video_session.dart` review 中 hwdec 不符后重规划耗尽，抛 `hwdecMismatch` 而非末选候选的 skipReason。新增 LG P8.4 唯一 PQ 路线+实际软解回归；确认无 applied/SDR 放行，report/error 都为 mismatch。原始 native DV 准入失败仍保留 `nativeDvUnavailable`。session53/构建工具11全过、定向analyze无问题，独立V2审核及 ABI split 增量审核无阻塞。
- **独立 LG 实机验证：** `BV1vY4y1N7TY` 3840×1920 与 `BV1uZ4y1U7h8` 本轮实际3840×2160，均 facts DV8/compat4、`OMX.qcom.video.decoder.hevc`、`hwdec-current=surfacetexture`、`baseLayerConvert → PQ/ext:lg-pq verified=true`。视频format43/7FA30C04、panel `is_hdr_enabled=1`、SDM CS=9；约73s和61s采样窗中真实视频块 ACQUIRED slot/handle轮换，首源后期FIFO时间戳也推进。两段FATAL/ANR/HdrPlaybackBlocked/hwdecMismatch均0。本轮验收结束时 LG 正在播放第二源，未改亮度/旋转/偏好。
- **人眼及测量边界：** 用户直接回复“能看到正常视频”。系统截图原生视频区仍黑，截图不作可读画面证据；此机同名多Surface导致 `--latency` 命中零值，未取得可靠FPS，不宣称逐帧零掉帧或亮度色彩光学校准。buf轮换是跨检查点推进，不是每帧连续性证明。第二源证据文件沿用历史 `1080p-*` 前缀，不代表本轮分辨率。验收报告 `/tmp/lg-dvp84-fixed-20261024/REPORT.md`、原始SF/log及 `machine-summary.json`；持久摘要已入 `../media-kit/docs/validation/lg-dvp84-source-build-20261024.json`。

## 诊断依据（2026-10-24 晚·接管复核）

- **定位到装机原生库与上层路由不匹配。** 从在线 LG `LGH870DS42e27764` 的 `/data/app/com.example.piliplus.dev-2/base.apk` 重新提取：APK 77,864,898 B，SHA-256 `ec7f6ef4fad5e02faebb254a737721d3530d7d3635dc35fb4298e7e25e9548d2`；arm64 `libmpv.so` 为 `176bc5a6248cda28980fcdb86141a16a800f94d1c9e25aeaa0d134bbc11ab3c7`，原始字节中完全不存在 `surfacetexture`、`MKSURF: version` 或 `android-native-dv-bridge-api`。其指纹与本档既有发布库指纹一致；本机当前无缓存 default JAR，未重新下载比对容器。
- **纠正上一轮“同二进制/设置被覆盖”的推断。** `/tmp/pili-lg-fit-build-20261022.log:14-18,35` 记录此前成功候选使用本地源码构建 JAR `23c7aeba19aad5d8aa648992764e56659bf77d386de5416b9df0e0aa87837f1e`，其 libmpv 为 `81386a07de9af47ff5deff8ad99c44574ac9b11cd01a34f99143322c79616a1a`，与当前装机不同。`hwdec` 是请求选项，`hwdec-current` 是实际使用状态；写入读回成功后观察到 `hwdec-current=no`，不能推导选项被改写。
- **源码解释与现场一致：** 发布基线 mpv `d24c59905b`（10-02）早于 `7163121865`（10-10，注册 `hwdec=surfacetexture`）。该基线 `video/decode/vd_lavc.c:148` 用 `OPT_STRINGLIST` 接收名称，未知方法在 614 行告警 `Unsupported hwdec`，632 行走软件解码。因此设置名称成功并不代表方法存在；缺失方法解释零 MediaCodec 日志、`decoder=hevc`、`hwdec-current=no`。App release 只请求 error 级且不订阅普通 log，warn 级未知方法提示未进入现有采集并不反证。
- **故障链：** 上层选 `baseLayerConvert + surfacetexture + PQ` → 所打包 libmpv 缺该方法 → 实际软解 → session 按既有硬解约束拒绝 → 重规划无可行候选 → `nativeDvUnavailable` 被当作最终提示。LG native DV 缺 P8 profile 的准入拒绝仍属既有边界；不应为此放松 HDR/硬解要求。
- **独立 V1 复核支持上述定位。** reviewer 独立核对 APK 内外 libmpv 字节一致、缺失方法标记、旧基线选择器与双源日志。边界：当前日志没有捕获 mpv 的 `Unsupported hwdec` warning，因果判断由已验证的二进制缺口、对应源码行为与现场状态共同支持，尚非完整 runtime trace；当前发布 JAR 容器未另行取得，精确发布归属依赖既有指纹及构建配置。未重建装机，不宣告修复或 HDR 观感验收完成。
- **后续：** 若进入修复验证，使用 media-kit 仓内 `tool/build-android-test.sh --app-dir /Users/wuweiwei1/src/PiliPlus` 从当前本地源码重建完整原生链和 APK，装包前核对方法与来源，装后复验同源硬解、PQ 层及帧推进；本轮用户要求分析，未构建、未安装、未修改播放实现。另应修复阻断提示的首因归属，并考虑为 SurfaceTexture 路由加入真实原生方法能力探测，避免仅凭 setter 成功准入；这些建议尚未实施。证据 `/tmp/lg-dvp84-diag/installed.apk`、`binary-comparison.json`、各 ABI 提取的 `libmpv.so`；旧双源日志沿用。

## 历史诊断（2026-10-24 晚·初轮，原生库排除及设置覆盖推断已由上方纠正）

- **LG H870DS DV P8.4 播放被阻断，toast 显示 nativeDvUnavailable——真实根因是 routed open 后 mpv 恒软解（hwdec-current=no），hwdecMismatch 把唯一可行候选 baseLayerConvert 排除，回退链无解**。用户报障"LG 解码 DV P8.4 失败提示 nativeDvUnavailable"，复现两轮（深链 BV1vY4y1N7TY 4K 与 BV1uZ4y1U7h8 1080p，/tmp/lg-dvp84-diag/lg.log、lg-1080p.log）：
  1. plan（origin=hint）选 `baseLayerConvert`（vo=gpu-next hwdec=surfacetexture output=pq ext=lg-pq applied）→ review entry=1 **2s 内** outcome=success 但 `hwdec-current=no`、`current-tracks/video/decoder=hevc`、`android-mediacodec-info=`（空）、全 logcat **零 MediaCodec/OMX 系统日志**——mpv 从未尝试 mediacodec，1080p 同样复现（非 4K 解码能力问题）。
  2. session 判 `hwdecMismatch`（`hdr_video_session.dart:1400`）→ replan 排除 `hwdec:surfacetexture` 依赖 → baseLayerConvert 变 `hwdecMismatch`、LG 上其余候选全不可行（nativeDolbyVision:nativeDvUnavailable【LG 解码器无 P8 profile 0x100，设计内】、metadataReshape:pqRgbPresentationUnavailable、baseLayerDirect/toneMapSdr:displayLacksTransfer）→ `HdrPlaybackBlocked`。**toast 文案取 replan 末选候选的 skipReason（nativeDvUnavailable），掩盖真实根因 hwdecMismatch，属误导性归因**。
  3. 排除项：libmpv JAR 自 10-11（v2026.013 vkweak）未变、与 10-21 LG 成功轮同二进制；session 的 mismatch→replan→block 逻辑 10-12（91521544/b5c50670）即存在；realizer surfacetexture 载体 10-15（2276715a）即存在——10-21 同视频同设备成功（entry=1 mediacodec-copy 11.9s→entry=2 surfacetexture applied）。`_setOwned('hwdec','surfacetexture')` 带读回校验通过（写入成功），故 hwdec 在 configure 后、解码器初始化前被改回 no——嫌疑集中于 10-21 之后 media-kit 提交（cf246c85 21:10 所有权下沉、56cff892、e2e6f41c 10-22 hint直开/切换延迟/属性批读，或控制器创建默认 `hwdec=auto-safe` 覆盖时序），未定位到具体提交。
  4. 待办：①二分 media-kit 10-21→10-24 提交定位 hwdec 被重置点；②`HdrPlaybackBlocked` 归因取真实 first-cause（hwdecMismatch）而非末候选 skipReason；③修复后 LG 回归。注：LG nativeDvUnavailable 本身是设计内拒绝（与本次故障无关），勿混淆。
  - 上轮（10-23 修复轮）状态见下；本轮为 LG 新故障诊断，不改变 marble 侧结论。

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
