# LG H870DS HDR 蒙灰：下一阶段工作计划（2026-10-21，供其他 agent 执行）

> **已被后续证据更正（2026-10-21）**：本文件保留为历史调查，旧灰屏归因与执行计划不再作为当前结论。真实灰层为字幕 Obx 构建异常产生的 Flutter Release ErrorWidget；最小修复已获用户面板与控件确认。当前事实见 `../../archives/conversations/video-gray-getx-20261021.md`。

> 状态：**蒙灰未修复**（面板确认）。本文是执行计划，接手者按步骤做，不要重新推翻已排除项。
> 约束：**不要提交任何仓库改动**；控件必须保持可见（禁用 `setZOrderOnTop` 作为最终方案）；`target-peak=1000` 已由用户确认（亮度可接受）必须保留。

## 0. 一句话现状

视频层在正常渲染（config49、1440×720 @ (0,141)、tr=1:1、buffer 轮转、final-pass 连续 draw），
但**视频表面呈现的是一个平色灰帧**（截图 72 点采样唯一值 (181,181,181)；PiliPlusX 同位置恒 (0,0,0)）。
面板因此蒙灰。参考实现 PiliPlusX 同设备同路由同几何，画面正常。

## 1. 已确证事实（勿重复验证）

| 项 | PiliPlus（灰） | PiliPlusX（正常） |
|---|---|---|
| 视频层 | fmt=43 (0x7fa30c04) 1440×720 @(0,141) tr=1:1 | 同（尺寸同） |
| 视频区截图采样 | **(181,181,181) 平色** | **(0,0,0) 平色** |
| SF 层栈/z/crop/flags/HWC 合成表 | 一致 | 一致 |
| Android 视图层级 (dumpsys activity top) | wrapper (0,141-1440,861) > SurfaceView (0,0-1440,720) | 一致（仅 PiliPlus 多一个空 View `ba0`） |
| libflutter.so | 与 PiliPlusX 逐字节相同（d70bbedc，3.47.2） | 同 |
| libmpv.so | **fbe0bc8b**（10-20 源码重建） | **8de38a2d**（10-19 构建） |
| HDR 路由 | `phase=applied verified=true topology=platformView surface=pq path=ext:lg-pq` | 同 |
| 主题/窗口背景 | 相同；**改成纯红后视频区仍是 (181,181,181)** → 灰与窗口背景无关 | 同主题 |

**已排除**：引擎版本（3.47.7 与 3.47.2 同结果）、窗口背景、App 主题、Java/Dart 平台视图代码（现已与 routing 等价）、Android 视图层级、层栈/HWC、布局几何（已修，见 §2）。

**唯一未排除的实质差异**：**native libmpv 二进制不同**（10-20 源码 vs 10-19 构建），以及 compat 分支 Dart/Java 的 HDR carrier 细节（dataspace/格式/几何写入时序）。

## 2. 已落地的三个修复（必须保留，勿回退）

1. **几何**：routed 路径按播放器槽位布局平台视图（新增 `SimpleVideo.viewport` / `RoutedSimpleVideo.viewport`，平台视图路径 fit=contain）。修复前平台视图按视频原生像素 3413×1706 布局、被 FittedBox 缩放 0.42/0.47（画面拉伸、坐标错位）。现为 1440×720 @(0,141)、tr=1:1，与 PiliPlusX 逐位一致。
   - 文件：`~/src/media-kit/media_kit_video/lib/src/video/simple_video.dart`、`.../integration/routed_simple_video.dart`、`~/src/PiliPlus/lib/plugin/pl_player/view/view.dart`
2. **路由稳定性**：capability 事件不再用无事实计划覆盖 pending open（`hdr_video_session.dart` 的 `handleCapabilitiesChanged`）。修复前首启会走 `sdrDirect/texture` → `Routed open has no verified output` → 回退 SDR（这解释了「第一次好、重播灰」）。现首启即 `phase=applied verified=true`。
   - 文件：`~/src/media-kit/media_kit_video/lib/src/hdr/hdr_video_session.dart`
3. **合成入口**：`platform_view_video.dart` 中 `rgba1010102` 不再强制 `initSurfaceAndroidView`，统一走 `initExpensiveAndroidView`（与 routing/PiliPlusX 一致）。carrier 仍完好（managed armed、config49、offscreen 1440×810、final-pass draw）。

## 3. 判定基准（每个实验都用这套判据）

- **像素代理**（截图对 PQ 表面是盲区，但颜色可作代理）：
  - 视频区矩形（竖屏）= 物理坐标 `[0,141,1440,861]`；采样点 (720,400)。
  - **(0,0,0) = 正常**（PQ 表面被正确呈现，PiliPlusX 的形态）
  - **(181,181,181) = 蒙灰**（当前形态）
- **面板是最终裁判**：每轮请用户看面板确认。
- 日志关键字（`adb -s LGH870DS42e27764 exec-out logcat -d`，注意 shell logcat 在本机返回空，必须 exec-out）：
  - `HdrDiag HDR decision`（路由：必须 `phase=applied ... verified=true`）
  - `YUV-DIAG` / `MKSURF`（mpv 渲染管线）
  - `lgPqApply`（vendor dataspace 写入）
  - `PlatformVideoView`（surface 生命周期）
- SF 解析器：`/private/tmp/commandcode-502/-Users-wuweiwei1-src-PiliPlus/529226d0-e0c9-4a9e-85a8-d90fbfaff8c6/scratchpad/sfan.py`（用法 `python3 sfan.py <dump>`，输出各层 z/pos/size/tr/transparentRegion/visibleRegion）。

## 4. 执行步骤（按优先级，每步都有判别作用）

### 阶段 A：native 二进制 A/B（首选，直接判别）

目的：验证「10-20 源码的 libmpv 让画面变成平色灰帧」这一假设。

1. 备份现有 JAR：`~/src/media-kit/libs/android/media_kit_libs_android_video/android/jars/mks-arm64-v8a.jar` → 备份到 scratchpad（如 `jar-current-backup/`）。
2. 取 PiliPlusX 的 native：
   - `adb -s LGH870DS42e27764 pull /data/app/com.example.piliplusx-2/base.apk`，解出 `lib/arm64-v8a/libmpv.so`（sha 8de38a2d…）。
3. 换装：解开现有 JAR，仅替换 `lib/arm64-v8a/libmpv.so`，保留 `libmediakitandroidhelper.so`、`libc++_shared.so`，重打 JAR；`shasum -a 256` 记录新 sha。
4. 更新 `~/src/media-kit/libs/android/media_kit_libs_android_video/android/build.gradle` 中该 JAR 条目的 `sha256`（`libs/android/media_kit_libs_android_video/CHANGELOG.md` 同步记录来源）。
5. 构建并安装 PiliPlus：
   ```bash
   cd ~/src/PiliPlus
   export PATH=~/flutter-sdks/3.47.7/bin:$PATH
   export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
   flutter build apk --release --split-per-abi --target-platform android-arm64 --android-project-arg dev=1 --no-pub
   adb -s LGH870DS42e27764 install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
   adb -s LGH870DS42e27764 shell am force-stop com.example.piliplus.dev
   adb -s LGH870DS42e27764 shell am start -a android.intent.action.VIEW \
     -d "https://www.bilibili.com/video/BV1vY4y1N7TY" -p com.example.piliplus.dev
   ```
6. 判定：
   - 像素采样 (720,400) → (0,0,0) 且面板正常 ⇒ **native 是根因**，进入阶段 B。
   - 仍是 (181,181,181) ⇒ native 不是根因，进入阶段 C。
   - 若路由没起来（无 `phase=applied`）或 carrier 崩（无 config49/final-pass）⇒ 记录日志，说明 10-20 Dart/Java 与 10-19 native 不兼容，转阶段 C 并在结论中说明。

> 样片：BV1vY4y1N7TY（DV 8.4 / HLG / BT.2020，3840×1920）。回归样片：BV1T7（SDR，必须仍正常）、BV1uZ4y1U7h8（DV）。

### 阶段 B：native 源码二分（阶段 A 确认 native 后）

**关键前提**：`~/src/mpv` 的 `video/out/opengl/context_android.c` 有**未提交的工作区改动**（10-20 的补丁全在工作区里，git log 看不到）。**先整文件备份**，任何 stash/checkout 前都要确认备份。

1. 先列出未提交差异：`git -C ~/src/mpv status --short`、`git -C ~/src/mpv diff --stat`，并把 diff 存档到 scratchpad。
2. 确定 8de38a2d 的源状态：`git -C ~/src/mpv stash push`（或用备份副本构建）后重建 → 得到的 libmpv 与 8de38a2d 比对（shasum）。若一致 → 10-19 = HEAD 干净态。
3. 逐条恢复工作区补丁并重建（每步都做阶段 A 的像素+面板判定），优先怀疑顺序（都可能造成「平色灰帧」）：
   1. **1×1 占位几何**：`ANativeWindow_setBuffersGeometry(..., 1x1)` + `placeholder resize 1x1 skipped` 路径（日志见 `presetting window format 0x7fa30c04 (1x1)`）。
   2. **离屏 FBO 清黑**（曾实施后被回退）：若 libplacebo 未写入 FBO，未初始化灰会被整帧呈现。
   3. **not-ready swap 黑帧**（曾实施后被回退）：final-pass 未就绪时提交未初始化缓冲。
   4. **final-pass 元数据**（matched full / target-trc / target-peak 写入时序）。
4. 每一步记录：`YUV-DIAG`/`MKSURF` 日志、像素采样、面板观感。

### 阶段 C：compat carrier 与 routing 的差异（阶段 A 否定 native 后）

1. 对比两分支（`~/src/media-kit` 的 `compat/piliplus-zero-change-20261018` vs `routing/MK-ROUTING-20261011`）的 HDR carrier 写入路径：
   `media_kit_video/lib/src/hdr/hdr_player_backend.dart`、`hdr_yuv_window_arm.dart`、`hdr_yuv_presentation_contract.dart`、`hdr_strategy_realizer.dart`、`hdr_output_resources.dart`、`video_controller/android_video_controller/real.dart`。
   重点：**surface 的 dataspace/格式/几何写入的时机与顺序**（vendor `lgPqApply` 在 surfaceCreated 时写入，随后 mpv 的 `setBuffersGeometry` 可能重置 dataspace）。
2. 验证 dataspace 是否在最终态仍为 PQ：在 `PlatformVideoView.surfaceCreated`/`surfaceChanged` 后读回 surface dataspace（现有 `needsPqResetMonitoring` 机制可扩展为读回日志），与 PiliPlusX 的日志对比。
3. 终极对照实验：把 PiliPlusX 的 media-kit（routing 分支）接入 PiliPlus 构建（App 不改），看灰是否消失——可直接判定是 App 侧还是库侧（注意 API 差异，可能需要一层适配）。

### 阶段 D：兜底（若 A/B/C 都不能解决）

- `setZOrderOnTop` 已知能让画面正常但盖住 Flutter 控件（用户拒绝此状态）。长期方案：控件改平台侧绘制，或把控件渲染到视频层之上的独立 surface。
- 记录为已知限制，并给出「控件平台侧化」的设计要点。

## 5. 交付与验收

每轮实验必须产出：
1. 像素采样结果（视频区 (720,400) 及 72 点网格）。
2. SF dump（`adb shell dumpsys SurfaceFlinger > /tmp/sf-<tag>.txt`）+ `sfan.py` 摘要。
3. `exec-out logcat` 中 `HdrDiag`/`YUV-DIAG`/`MKSURF`/`lgPqApply` 关键行。
4. 面板观感（请用户确认）。

最终验收：
- 面板显示视频（用户确认），控件可见可点。
- 视频区像素采样 = (0,0,0)（与 PiliPlusX 同形态）。
- SDR BV1T7 正常、BV1uZ4y1U7h8 正常、零 ANR/FATAL。
- 三个已落地修复与 `target-peak=1000` 保留。

## 6. 环境与素材

- 设备：`adb -s LGH870DS42e27764`（LG H870DS，Android 7/API 24，Adreno 530）。试验期间 `svc power stayon true`，**结束时还原为 false**。
- App：`com.example.piliplus.dev`（工作区 ~/src/PiliPlus，Flutter 3.47.7 钉值）；参照 `com.example.piliplusx`（保持启用便于对照，结束时可 disable）。
- 样片深链：`https://www.bilibili.com/video/BV1vY4y1N7TY`。
- 参考证据：`/tmp/sf-xplay-portrait.txt`（PiliPlusX 正常态）、`/tmp/sf-first-play.txt`（旧几何灰态）、`/tmp/sf-hc-race.txt`、`/tmp/sf-3472b.txt`；scratchpad 的 `sfan.py`、`sfkey.sh`、各截图。
- 调查文档：`~/src/PiliPlus/docs/plans/lg-hdr-gray-cover-investigation-20261020.md`（§8 是本轮证据与排除清单）。
