# LG H870DS HDR 灰屏覆盖：排查总结与待查假设（2026-10-20 深夜，已停止）

> **已被后续证据更正（2026-10-21）**：本文件保留为历史调查，旧灰屏归因与执行计划不再作为当前结论。真实灰层为字幕 Obx 构建异常产生的 Flutter Release ErrorWidget；最小修复已获用户面板与控件确认。当前事实见 `../../archives/conversations/video-gray-getx-20261021.md`。

> 状态：**未修复**。本轮为定位灰屏做了多项实验，均未生效；已按用户要求回退未被验证的改动，仅保留用户确认有效的 `target-peak`。未提交任何东西。

## 1. 设备与已确认事实

- 设备：LG H870DS（`LGH870DS42e27764`，Android 7.0/API 24，Adreno 530，DV+HDR10 面板）。
- PiliPlus HDR 路由（实机 `HdrDiag HDR decision`）：
  - `phase=applied`
  - `class=dvP84 selected=baseLayerConvert`
  - `vo=gpu-next hwdec=surfacetexture output=pq`
  - `topology=platformView surface=pq`
  - `path=ext:lg-pq`
  - `verified=true degrade=none`
- 视频管线本身在跑：`YUV-DIAG` final-pass draw/swap、config49 缓冲轮转、`phase=applied`；**灰屏不是「没有输出」**。
- 用户观感：
  - 视频矩形内是**页面背景的浅灰色**（与视频页下方内容同色），不是视频内容。
  - 起播有一次「先黑再灰」，之后持续灰。
  - 偶发蓝屏；进度条在重开时曾出现 `0 ↔ 原位置` 跳动（`POSJUMP` 日志实测 976→0→976）。
- **已验证有效并保留**：`target-peak=1000`（用户确认「亮度现在可接受」）。与本灰屏无关。

## 2. 灰屏的直接证据（SurfaceFlinger）

灰屏时（竖屏示例）：

- final-pass（config49）层：`z=21020`，`visibleRegion=[0,96][1440,816]`，有 QUEUED/ACQUIRED 缓冲。
- 应用表面（`com.example.piliplus.dev`）：`z=21025`（在视频层之上），
  - `visibleRegion=[0,0][1440,2672]`（整屏）
  - `transparentRegion=[0,0][0,0]`（**空**）
- HWC 表：应用表面 `RGBA_8888` 整屏、`blnd=0105`，叠在 config49 之上。
- 结论：应用表面没有为视频矩形挖透明洞，页面背景把视频盖住。

对照 PiliPlusX（同设备、同一样片、同一 HDR 路由）：

- PiliPlusX 的 HDR 路由也是 `baseLayerConvert / surfacetypexture / platformView / output=pq / ext:lg-pq`。
- 它的应用表面：
  - `transparentRegion=[0,52][2672,1388]`（**正好是视频矩形**）
  - `visibleRegion=[104,0][2776,1440]`
- 横竖屏都正常（用户确认），所以不是方向/全屏问题。

## 3. 已做但未生效的实验（均已回退）

1. **视频矩形 viewport 化**：把平台视图尺寸从视频原生尺寸（3413×1706）改为播放器区域（1440×720/810），图层 transform 变成 1:1；洞仍为空。
   - 改动：`simple_video.dart`、`routed_simple_video.dart`、PiliPlus `view.dart`。
2. **改用 PiliPlusX 的 `HdrVideo(session, width: maxWidth, height: maxHeight)` 形状**，去掉外层 `FittedBox`；视频层位置/尺寸正确（`[0,141,1440,861]`），洞仍为空。
3. **自定义 `SurfaceView.gatherTransparentRegion`**：引擎确实调用，区域正确 `[0,96][1440,816]`，但窗口的 `transparentRegion` 仍为空。
4. **回退 compat 额外 Z 序/可见性改动**（`HoleSurfaceView`、强制 media overlay、销毁时隐藏），恢复 routing 分支的原生 `SurfaceView` + 原始 Z 序逻辑；洞仍为空。
5. **平台视图合成入口**：compat 分支对 `rgba1010102` 强制 `initSurfaceAndroidView`；PiliPlusX routing 分支走默认 `initAndroidView`。改为默认入口后仍为空。
6. **Flutter engine 版本**：PiliPlusX 用 brew Flutter **3.47.2**（`.fvmrc`），PiliPlus 用 3.47.7。临时把 PiliPlus 降到 3.47.2（并临时注释 3.47.7 才有的 `super.checkUp`）构建装机：**仍然灰，应用表面洞仍为空**。因此引擎版本不是唯一原因（该测试仍使用 compat 媒体库与 compat 视图链）。
7. `setZOrderOnTop`（交接文档已验证能正常显示画面）**未在本轮部署**：它会盖住 Flutter 控件，用户明确要求保留控件；代码中已回退。

## 4. 当前工作区状态

保留：

- `target-peak=1000`：
  - `media_kit_video/lib/src/hdr/hdr_yuv_presentation_contract.dart`（`targetPeak`）
  - `media_kit_video/lib/src/hdr/hdr_player_backend.dart`（owned 写入/读回/恢复）
  - `media_kit_video/test/hdr_yuv_presentation_contract_test.dart`（断言与 fake 基线）
- 构建基础设施（非功能性）：本地 JAR 移到 `libs/android/media_kit_libs_android_video/android/jars/mks-arm64-v8a.jar`（不受 `gradlew clean` 影响）；JAR 已按**上一轮 mpv 源**（1×1 占位 + P0 观察，无本轮 FBO/not-ready 改动）重建，SHA-256 `c6d989f7be7a2168ca31cdfd20625e234e47ef26063d0de8838fbc90d1f45930`；`build.gradle`/`CHANGELOG.md` 已同步。

已回退：

- mpv fork `video/out/opengl/context_android.c`：离屏 FBO 清黑、not-ready 黑帧（均未验证有效）。
- media_kit `clearSurfaceBlack`（已删）。
- `HoleSurfaceView`、强制 media overlay、销毁/释放/重建可见性守卫。
- `simple_video.dart` viewport、`routed_simple_video.dart` HdrVideo 路径、`routed_video_playback.dart` session getter/seek、`hdr_video_session.dart` seek。
- `platform_view_video.dart` 的 TLHC 入口移除。
- PiliPlus `POSJUMP`/`POSREBUILD`/`POSSEEK` 日志与位置守卫。
- PiliPlus 3.47.2 临时 pin/`.fvmrc`/lock 与 `image_double_tap_gesture_recognizer.dart` 的临时注释；已恢复 **3.47.7** 并重新 `pub get`。
- `PlatformVideoView.java` 的 Z 序/可见性实验：已恢复到**本轮开始时的工作区状态**（media overlay + 非 rgba1010102 视图 INVISIBLE）。

设备：

- 当前安装的是最后一版 **3.47.2 验证 APK**（源码已恢复 3.47.7，需重新构建/安装才能与源码一致）。
- 已恢复 `svc power stayon false` 与自动旋转。
- PiliPlusX（`com.example.piliplusx`）原先被禁用，本轮为对照测试已 `pm enable`；保持启用（用户对照用）。

## 5. 待查假设（按优先级）

1. **视图层级/父容器差异（最高优先）**
   - PiliPlusX 的 `_videoWidget` 是 `Stack` 中直接放 `HdrVideo`；PiliPlus 的平台视图在 `RepaintBoundary` → `MouseInteractiveViewer` → `FittedBox` → 视频页滚动容器内。
   - 虽然 `gatherTransparentRegion` 拿到的窗口坐标正确，但**应用表面的透明区没有被 ViewRoot/窗口应用**。平台视图处于滚动/变换子树中可能是触发条件。
   - 建议：做一个最小页面（视频直接放 `Stack`，去掉 FittedBox/RepaintBoundary/MouseInteractiveViewer/sliver），对比洞是否出现；或把 PiliPlusX 的 `_videoWidget` 结构逐层移植到 PiliPlus。
2. **compat 媒体库 vs routing 分支**
   - 两分支的 HDR 路由相同；Java 引擎源码（`PlatformViewsController`/`FlutterView`/`PlatformViewWrapper`）在两版 SDK 中逐字相同；差异在 native engine + compat 的 media-kit 代码。
   - 建议：用 PiliPlusX 的 media-kit 分支（routing）构建 PiliPlus（App 不改），看洞是否恢复；若恢复，直接 diff compat/routing 的 `PlatformVideoView`、`PlatformViewVideoFactory`、`video_texture.dart`、`real.dart`。
3. **窗口透明区应用路径**
   - `gatherTransparentRegion` 被调用 → `ViewRootImpl` 应把 region 设到窗口 `SurfaceControl`；实际 `transparentRegion` 为空。
   - 建议：在 `FlutterView`/`PlatformViewWrapper`/`ViewRootImpl` 侧加一次性日志（或对比 PiliPlusX 的同一调用），确认 region 是否被 `FlutterSurfaceView.gatherTransparentRegion` 的 `Region.Op.DIFFERENCE` 抵消、或窗口是否被判定为 opaque。
4. **compat 平台视图的创建/可见性时序**
   - compat 的 `surfaceCreated` 里先 `registerManagedOutputSurface`/`armManagedOutputSurface`/初始 dataspace，再发布 surface 事件；routing 分支的序列可能不同。
   - 虽然 Z 序/可见性已回退，仍建议对比两分支 `PlatformVideoView.java` 的完整 `surfaceCreated`/`PlatformVideoViewFactory` 差异。
5. **引擎 3.47.2 vs 3.47.7**
   - 3.47.2 测试仍灰，不能单独归因；但该测试仍跑 compat 库。可用「PiliPlusX App + compat 库」或「PiliPlus App + routing 库」做 2×2 对照，隔离 App/库/引擎三因素。

## 6. 关键证据位置

- `/tmp/sf-pili-landscape.txt`、`/tmp/sf-hole-revert.txt`、`/tmp/sf-gather.txt`、`/tmp/sf-tlhc.txt`、`/tmp/sf-3472.txt`、`/tmp/sf-piliplusx-hdr.txt`：各阶段 SurfaceFlinger dump（应用表面 `transparentRegion` 与 HWC 顺序）。
- `/tmp/hdr-targetpeak-run.log`、`/tmp/hdr-fbo-run.log`：target-peak/FBO 轮 logcat。
- PiliPlusX 对照：`/tmp/sf-piliplusx-hdr.txt`（应用表面洞 = 视频矩形）。
- 截图：`/tmp/pili-yuv/` 与本轮 scratchpad 的 `now.png`/`pili-controls.png`（视频矩形为页面背景灰）。
- 注意：`/tmp` 可能被清理；需要长期保留的证据请转存。

## 8. 第二轮续查（2026-10-20 深夜，同一设备 LG H870DS）

### 8.1 灰蒙的精确机制（实测）

- 视频区截图采样：PiliPlus = **均匀 (181,181,181)**；页面背景 = (251,253,248)；PiliPlusX 同一位置 = **均匀 (0,0,0)**（PQ 表面截图盲区）。
  → (181,181,181) ≈ 页面背景 × 0.72，即 **被 SurfaceView dim 层压暗的 Flutter 表面像素**：视频层之上仍有一层不透明内容。
- SF 层栈逐项对比（PiliPlus vs PiliPlusX，同一支样片、竖屏）：
  - 视频层：都是 `fmt=43`（vendor config49 0x7fa30c04）、1440×720 @ (0,141)、**tr=1:1**、visibleRegion = 视频矩形；
  - dim 层、视频层、Flutter 表面、窗口表面的 z 序、crop、flags、**HWC 合成表全部一致**；
  - **唯一差异**：窗口表面的 `transparentRegion` —— PiliPlusX = `[0,141,1440,861]`（= 视频矩形，被正确打洞），PiliPlus = **空**。
- 结论：框架给平台视图 SurfaceView 在**窗口表面**上打的洞在 PiliPlus 缺失 → 窗口表面（浅灰）在视频矩形不透明 → 蒙灰。

### 8.2 本轮落地并验证的三个修复

1. **几何（App + 库）**：routed 路径原先把平台视图按**视频原生像素**布局（3413×1706），再由外层 FittedBox 缩放 0.42/0.47 → 画面被拉伸、洞也落在错误坐标空间。现改为按**播放器槽位**布局（新增 `SimpleVideo.viewport` / `RoutedSimpleVideo.viewport`，平台视图路径 fit=contain）。结果：平台视图 1440×720 @ (0,141)、tr=1:1，**与 PiliPlusX 逐位一致**。
2. **路由稳定性（库）**：capability 事件在 pending open 期间用**无事实计划**重建会话（`source=none` → `sdrDirect/texture`）→ routed open 报 `Routed open has no verified output` → App 回退到色调映射 SDR。现改为：事实/提示皆未知的 pending open 不被 capability 快照覆盖（该 open 自行查询能力再规划）。结果：**首启即 `phase=applied verified=true`**（此前需重进页面才成立）。
3. **合成入口（库）**：compat 分支对 `rgba1010102` 强制 `initSurfaceAndroidView`，routing 分支（PiliPlusX）用 `initExpensiveAndroidView`（HC）。已统一为 HC（`platform_view_video.dart`）。实测 carrier 仍完好：`managed surface armed=true`、`config49 selected`、`offscreen 1440x810`、final-pass 连续 draw。该项**未改变打洞行为**，但消除了与参照实现的一处分歧。

### 8.3 已排除

- Flutter 引擎版本：3.47.7 与 3.47.2 结果相同；且两 APK 的 `libflutter.so` 逐字节一致（d70bbedc）。
- App 主题/窗口背景：把 `NormalTheme.windowBackground` 改为透明后灰蒙不变 → 灰不是窗口背景。
- Java 平台视图实现：两分支 `PlatformVideoView.java` 仅构造函数不同，且 HDR 路径行为等价（都 setZOrderMediaOverlay、rgba1010102 可见）。
- Dart 平台视图代码：现已与 routing 分支等价。
- Android 视图层级（`dumpsys activity top`）：两 App 的平台视图包装器都在 (0,141)-1440×861、SurfaceView 都在 0,0-1440×720（仅 PiliPlus 多一个同级空 View `ba0`）。
- media-kit 的 HDR 会话实现差异：不涉及打洞路径。

### 8.4 仍存疑的差异（下一步候选）

1. **native libmpv**：PiliPlusX 的 APK 里是 2026-10-19 构建（8de38a2d），我们的是同源重建（fbe0bc8b）。可做 A/B：把 8de38a2d 装进 JAR 重建，看灰蒙是否消失（YUV 窗口的 dataspace/format 处理差异）。
2. **App 侧视图树**：把平台视图从 MouseInteractiveViewer / RepaintBoundary / Transform.flip 中直接挂到 Stack 上做 A/B（Android 层级已一致，但 Flutter 侧变换仍可能影响引擎的表面定位）。
3. **框架打洞路径**：若以上都无效，说明 API 24 上 `initExpensiveAndroidView` 下的嵌套 SurfaceView 打洞在两 App 行为不同，需从引擎/框架侧取证（对比 `libflutter.so` 中 platform view 定位与 `gatherTransparentRegion` 路径）。
4. **兜底**：`setZOrderOnTop` 已知能让画面正常但盖住控件；长期方案是控件改平台侧绘制。

### 8.5 当前工作区状态

- 保留：上表三个修复 + `target-peak=1000`（用户确认亮度可接受）。
- 已回退：窗口背景透明（无效）、3.47.2 临时 pin 与 `checkUp` 注释（已恢复 3.47.7 与原覆写）。
- 设备：安装的是 3.47.7 + 三个修复的 APK；`svc power stayon true`（试验用，需还原为 false）；PiliPlusX 已 `pm enable`（对照用）。
- 证据：`/tmp/sf-first-play.txt`、`/tmp/sf-after-replay.txt`、`/tmp/sf-hc-race.txt`、`/tmp/sf-3472b.txt`、`/tmp/sf-xplay-portrait.txt`（PiliPlusX 参照）、scratchpad 的 `sfan.py`（层栈解析器）与各次截图。

## 7. 结论一句话

HDR 解码/呈现路由与 PiliPlusX 完全一致且 `applied/verified`；灰屏是 **Flutter 应用表面没有为平台视图挖出透明洞**，而 PiliPlusX 在同一设备、同一路由下洞是正常的。差异已排除方向、布局尺寸、HdrVideo 形状、Z 序/可见性、平台视图入口和单一 Flutter 版本；最可疑的是 **PiliPlus 的视频视图父容器/视图层级** 或 **compat 媒体库的平台视图实现**。`setZOrderOnTop` 是已知能绕过洞的兜底，但会盖住控件；保留控件的最终方案需继续定位上述两点，或改为平台侧控件。
