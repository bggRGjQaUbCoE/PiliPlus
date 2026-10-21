# TASKS.md

任务事实源：只保留当前状态、验收门槛和下一步；按各项 `context` 查看持续更新的依据。
姊妹仓：本地 media-kit checkout 在 `../media-kit`（compat 分支），本仓的一切播放器行为变化先看其 `TASKS.md` 的 MK-ROUTING 段。
**镜像红线（2026-10-17 起）**：本仓 `main/dev/dom` 与全部 tag 由 `ci/upstream-sync` 孤儿分支每日强镜像自上游（force+prune），自有提交只能放特性分支（当前工作分支 `feature/ohos`，不受镜像影响）。

## ANDROID-LOCAL-MEDIA-KIT-20261020（本地 media-kit 构建与路由播放主线）

- 2026-10-21 **所有权管理下沉完成，LG短测及15min恢复通过，按授权提交推送**：用户授权将播放器替换串行队列、旧 owner 清理重试迁至 media-kit 的显式共享实例；App 保留页面/源请求/业务判断并精简辅助包装。App净减79行；slot10/App2定向、App14/库1048+8skip全量、V2及源码构建通过，新包6155accc LG切页/快速返回/EOF重播20s/EOF拖动/暂停拖动/HDR-SDR/退出重进通过；Home仍有20秒恢复迟滞。用户改为15min，实际939.565秒同源零输入静置后单次重播20s及再次EOF直接拖动通过；不声称本轮30min覆盖，系统媒体位置基准同步缺口单列。本次提交正式修复和验收记录，临时transport诊断及独立仓迁移/配置改动排除。context：[`playback-eof-replay-20261021.md`](archives/conversations/playback-eof-replay-20261021.md)。

- 2026-10-21 **重播/切页恢复短测通过，31min静置后恢复未验证，未提交**：两类本轮HDR接入回归已修正：隐藏页挂载/旧请求fallback竞争、raw重播与routed seek意图失配；另以真实completed保存状态修正返回末帧不能重播边界，不扩大50ms判断。第三源码包完成单次重播20s、普通近尾paused返回、Home迟滞自动恢复；第二包EOF直接拖/主动暂停拖/SDR-HDR通过。库focused59/59、全量1038/8，Apphelper6/6、V2通过。gen6真EOF完成1876.879秒零输入/源变化静置；首次点空白处控件未显示，未点play/seek，保留现场，不能记长时重播通过。计时前极近尾seek缓冲及未明refresh单独保留。context：[`playback-eof-replay-20261021.md`](archives/conversations/playback-eof-replay-20261021.md)。

- 2026-10-21 **HDR提亮验收通过，本地提交归档**：取消PiliPlusX对比，media-kit侧保守gamma候选，保持peak1000；定向23项/全量1031通过8跳过、V1通过；源码包已装LG，HDR→SDR→HDR applied通过；用户确认“亮度合适，高光正常”，面板验收通过；确认时最终背光未另采样。用户现授权本地提交已验收修复及记录：media-kit `98c611a3`，本仓仅相关记录。不推送，临时EOF诊断不提交。context：[`video-gray-getx-20261021.md`](archives/conversations/video-gray-getx-20261021.md) 顶部Current State。

- 本次按用户授权分别本地提交：配套 `mpv@1af17925fb`、`media-kit@917405a7`；App保留修复与本任务/验收记录随当前提交归档。不推送，不含环境配置。

- 2026-10-21（三）**灰屏根因修复、跨仓回退与上游同步精简已完成（本地提交归档，不推送）**：真实灰层为字幕Obx异常的Release ErrorWidget，原修复版用户确认画面及控件正常。最终App业务差异只剩两个文件（8新增/4删除）；vendor依赖已迁到media-kit；mpv只保留有效占位初始化；SDK项目补丁保留。最终源码1023测试通过/8跳过，精简包已装LG，HDR/SDR/重进真实复核通过；末版用户已明确确认“画面和控件都正常”，本次灰屏修复与精简验收完成。详见 [`archives/conversations/video-gray-getx-20261021.md`](archives/conversations/video-gray-getx-20261021.md) 与 [`docs/plans/video-gray-cleanup-audit-20261021.md`](docs/plans/video-gray-cleanup-audit-20261021.md)。以下旧透明洞根因和实验结论仅作历史，已被本条更正。
- 2026-10-21（三）**历史实验结论（已证伪，非当前状态）：曾归因为 API24 透明洞，修复候选未验收**。现状：**未完成验收**。LG 设备 `LGH870DS42e27764` 本轮末从 USB 消失（`adb devices` 空、USB 树无 LGE 项），装机与面板验收阻塞。
  - **根因（实测闭合，非推断）**：PiliPlus 的 Flutter 平台视图容器 `fr`（FlutterView）比 PiliPlusX 多一个 **`PlatformOverlayView`（obfuscated `ba0`）**，与视频矩形完全重合且排在视频 `FlutterMutatorView`（`nq`）之后。API24 AOSP `ViewGroup.gatherTransparentRegion` 按子节点顺序走：绘制型 View 用 `DIFFERENCE` 扣掉自身矩形，SurfaceView 用 `UNION` 加回；该 overlay 在视频 SurfaceView 的 `UNION` 之后扣掉视频矩形 → 窗口 `transparentRegion` 变空 → 应用窗口表面在视频矩形保持不透明 → 均匀 (181,181,181)。PiliPlusX 无此 overlay → `transparentRegion=[0,141,1440,861]` → 画面正常。层级身份经 DEX 结构 + 运行时 `instanceof PlatformOverlayView` 双证（`eq`=`FlutterImageView` 根图，`ba0`=`PlatformOverlayView`）。
  - **判别实验（每个都装机实测，APK 内 libmpv 恒 `fbe0bc8b`）**：①对 overlay `setWillNotDraw(true)` → `transparentRegion` 恢复视频矩形、采样 (0,0,0)，机制成立；②对 overlay `setAlpha(0f)`（不画但仍参与扣减）→ **仍然灰、region 仍空** ⇒ 成因是**空透明区**，不是 overlay 的像素内容；③把 overlay 移到 `nq` 之前（preDraw 持续纠正）→ region 正确、视频可见，但**控件不可见**（`SurfaceView.draw`/`dispatchDraw` 恒对自身矩形 `CLEAR`，先画的都被擦掉），且**退出再进复现灰**；④移除 media-kit 两处 Flutter 覆盖层（ready/visible cover）→ overlay 照旧创建、仍灰 ⇒ **此前"cover 触发 overlay"假设已证伪**；⑤去掉 `SimpleVideo` 外层 Stack → overlay 照旧创建 ⇒ Stack 不是触发条件。PiliPlusX 点击后视频矩形出现 15 种颜色 ⇒ 参考实现的控件确实画在视频之上（由全屏 `FlutterImageView` 承担，其扣减发生在视频 `UNION` 之前故洞存活）。
  - **结构约束（为什么简单改法都不行）**：`SurfaceView` 始终 `CLEAR` 自身矩形 ⇒ 画在它之前的被擦除；画在它之后的必然扣减透明区。API24 下"视频上方有窗口内容 + 窗口挖洞"不能靠常规 View 顺序共存。
  - **修复候选（已构建，未装机）**：media-kit `PlatformVideoView.java` 新增 `TransparentRegionRestorer` —— 不绘制（`setWillNotDraw(true)`）的 View，覆写 `gatherTransparentRegion` 把视频矩形 `UNION` 回去，插到 FlutterView 中 overlay 之后并用 `OnPreDrawListener` 持续保持最后。预期同时满足：洞恢复 + overlay 仍绘制控件。构建 `BUILD_EXIT=0`（Gradle 57.5s），随后 adb 安装时设备消失。
  - **测试/静态**：`flutter test test/routed_simple_video_test.dart test/piliplus_view_compat_test.dart` → 8/8 通过；两文件 `dart analyze` 仅 2 条既有 warning（`unnecessary_non_null_assertion`、`unnecessary_import`）。
  - **更正（撤回前文错误结论）**：①此前断言 `eq`=`PlatformOverlayView` 错误，`eq` 为 `FlutterImageView`、`ba0` 才是 `PlatformOverlayView`；②此前"根因已确定=Flutter cover"错误，cover 与 overlay 创建无关；③`transparentRegion` 不是"逐像素 alpha 证据"，但①/②实验证明它在本机型上确实是成因环节。
  - **工作区（未提交）**：media-kit Dart `routed_simple_video.dart`（ready cover 已删，待定稿）、`simple_video.dart`（cover 改为 `!visible && !platformSurface && !platformOutput`，并实验性去掉无 cover 时的 Stack）；media-kit Java `PlatformVideoView.java`（`diagRelaxOverlaySiblings()` 诊断 + `TransparentRegionRestorer`，交付前须清理）；mpv 工作区补丁已备份到 scratchpad（`mpv-context_android-working.patch`、`context_android.c.working-backup`）。保留项未动：viewport、pending-open 稳定性、HC 入口、`target-peak=1000`。
  - **下一步（设备恢复后）**：装机 → 校验 `transparentRegion=[0,141,1440,861]` → 面板确认"视频正常 + 控件可见可点" → 退出重进一次确认不复发 → BV1uZ4y1U7h8 / BV1T7t96BECu 回归 + 零 ANR/FATAL。证据：scratchpad `x4..x8*.png/sf/vh/logcat`、`arm-X2-*`、`arm-X3-*`。
- 2026-10-20（一）**零改动 Android 构建链跑通 + brightness 供给修复**：PiliPlus 源码/pubspec 零改动，经根级 `pubspec_overrides.yaml`（全量 path 指向 `../media-kit`，保留 inappwebview 两条 git override，`media_kit_native_event_loop` 无本地包且无代码引用可安全移除）构建 Android arm64。compat 分支 direction B 兼容层实测消除 lib/ 全部 156 个 API 错误；`flutter test` 通过；analyze 剩余错误全在 `tool/ohos/`（Android 不编译）。装机后「手势调亮度数字变但亮度不变」根因＝PiliPlus 直依赖 `screen_brightness_platform_interface`，原生实现历来由旧 media_kit_video fork（bggRGjQaUbCoE native）依赖声明带入，本地库缺该声明→插件从 GeneratedPluginRegistrant 消失；修复在 media-kit 侧 `media_kit_video/pubspec.yaml`（f61311fc），App 零改动。
- 2026-10-20（二）**路由验收定位门死锁与丢帧根因**：零改动路径不走路由（legacy 默认 texture），LYA 播 BV1vY4y1N7TY（4K DV）SF 层实测 **15.3fps**（中位 65.4ms、64/126 间隔>2 vsync＝丢半帧），根因＝copy+gpu-next DV→SDR 色调映射+4K 纹理上传链。显式 `RoutedVideoPlayback` 接线后复核门确定性拒绝（iter=7 endpoint-changed，direct 与 copy 候选同拒）；LG 另有 outputBindTimeout（挂载门环）与 SDK16-25 默认 embed 载体挂死。EDL 双流源规划时事实全空（source=none class=sdr）。证据 `/tmp/pili-verify-20261020/`。
- 2026-10-20（三）**接线落地 + 自动播放修复 + 三机路由验收全绿**（App `a01f8ff53` + media-kit `26a2c2c6`）：播放器接 `RoutedVideoPlayback/RoutedSimpleVideo`（transport 走 binding、属性/订阅留原 player、`onlyPlayAudio` 传 `video:false`、open 被拒时 `_switchToLegacyOutput` 回退兜底）；修复两处视图侧死锁——页面挂载门 `videoController==null` 改为 `videoController==null && playback==null`（会话控制器在 open 期间才出现，Obx 只对 Rx 响应），`RoutedSimpleVideo` 空控制器占位是 1px 盒需 `aspectRatio: videoFit.aspectRatio ?? 16/9` 兜底；字幕改跟随 `playback.controller` listenable。`autoPlayEnable` 默认改 **true**（用户目标；旧行为＝深链不播、单击只切控制条、需拖推荐栏才触发）。终版实测（深链+自动播放零手工干预）：LYA review×2 success→dvP84 事实→toneMapSdr→applied，**30.6fps**（中位 32.7ms、5/126 超限）；LG review×2 success→applied（OMX.qcom HEVC 硬解），**30.4fps**；marble（displayHdrTypes=1,2,3,4 全能力）applied+播放推进；三机零 ANR/FATAL。
- 关键机理（写入 media-kit 侧但 App 验收依赖）：hisi/qcom 直连 attach 本可成功，旧复核门飞行中采样-重建风暴才是端点翻覆元凶；media-kit 已改静止后单采样+复核超时候选回退，legacy 桥 require(sdr)+sdrEmbed:false。App 侧不得再自造 preferCopy/回退优先级——候选序交给规划器。

### 构建手册（复现）
### 2026-10-20（二）晚 HDR 点亮轮（matched full 配对 + Z 序修复 + 契约写入，接路由验收三）

- 2026-10-20（二）晚 **HDR 链路实机点亮 + 灰蒙根因闭环 + 剩余四项记录**（全部 media-kit 侧，App 零代码改动，仅构建 define）：BV1vY4y1N7TY 实测 `phase=applied selected=baseLayerConvert presentation=nativeHdr vo=gpu-next hwdec=surfacetexture output=pq` **零降级零回退**、lg-pq dataspace applied、MKSURF latch 30fps 连续（4179 帧 733→844s 实时推进）、playing=true position 推进、零 ANR/FATAL——**面板 HDR 输出端到端点亮**（screencap 对 PQ 层只能拍均匀灰=采集盲区，面板观感待人眼最终确认）。
- 三因子修复（均 media-kit 侧，详见 `../media-kit/archives/conversations/piliplus-lg-hdr-lit-handoff-20261020.md`）：
  ①**双 SurfaceView Z 序竞态**——fork 的 PlatformVideoView（offscreen swapchain + final-pass vendor 窗口）attach 顺序竞态让 offscreen（uniform PQ 灰）盖住 YUV 窗口=灰盖视频/全屏灰条；修复=final-pass（rgba1010102 格式）`setZOrderOnTop` 钉图层栈最顶 + offscreen 保持 media overlay（PlatformVideoView.java）。
  ②**HLG→PQ 转换缺失**——契约写入从未下发 `target-trc`，HLG 数值被 PQ 容器按绝对亮度解释=亮部约 2 倍过曝；修复=契约写入补 `target-trc=pq`（hdr_player_backend.dart，同块）。
  ③**full/limited 标签错配**——`surfaceTransfer='pq'`（FULL 标签）配 route 契约 full 电平=matched full 配对（euv13/euv17 已验证接受的组合），实机确认"过曝轻一些"。
- **videoState 循环等待门修复**（pages/video/view.dart）：页面要求 open 完成才挂播放器，平台视图 open 又要视图先挂载=循环等待；修复=routed 会话存在（playback!=null）即挂载，不等 videoState（RoutedSimpleVideo 自带 ready 遮罩）。
- **sessionReady 门控**（pl_player/controller.dart `panelHdrCapable`）：仅当 `displayHdrTypes 非空 && (sdkInt>=28 || ext.applicable && ext.validatedPredictionTransfers 非空)` 才进会话；lg-pq 已声明 `validated={pq}`（vendor 插件 Java 覆写，实测注释指向本轮）→ LG `sessionReady=true` 门控放行；API≥28 设备照常。
- **遗留四项**（全 media-kit 侧或 App 一处小改，详见 media-kit 侧 handoff 文档）：
  ①~~亮部残余过曝~~——**已验证有效并保留**：契约写入追加 `target-peak=1000`（HLG 参考峰值，`HdrYuvPresentationContract.targetPeak`，owned 写入/回读/恢复，契约测试钉住）；用户确认「亮度现在可接受」；
  ②**出视频前灰屏 + 全屏灰条——未修复**：实际是 Flutter 应用表面没有为平台视图挖透明洞（`transparentRegion` 为空），页面背景盖住视频；PiliPlusX 同路由同设备洞正常。本轮尝试的 FBO 清黑、not-ready 黑帧、`clearSurfaceBlack`、HdrVideo/无 FittedBox、viewport、TLHC 入口、Z 序/可见性回退、Flutter 3.47.2 降级均**未生效**，已回退。完整证据、对照与待查假设见 `docs/plans/lg-hdr-gray-cover-investigation-20261020.md`；
  ③播放控件被 ON-TOP 视频盖住（可点击不可见）——已知兜底 `setZOrderOnTop` 能恢复画面但会盖住控件；用户要求保留控件，暂不采用；
  ④滑动时 final-pass 重建空隙短暂蓝屏——偶发，未专项定位。
- **后续轮实机（2026-10-20 晚）**：target-peak 版实测 BV1vY4y1N7TY / BV1uZ4y1U7h8 均 `phase=applied nativeHdr/surfacetexture/pq` 零降级，SDR BV1T7 正常，三样片零 ANR/FATAL；亮度用户确认可接受。灰屏仍在（见上）。最后一版验证 APK 是临时 3.47.2 构建；源码已恢复 3.47.7，需重新构建/安装。证据 `/tmp/hdr-targetpeak-run.log`、`/tmp/sf-*.txt`。
- **验收记录**：BV1T7（SDR）全彩播放 motion 47；BV1vY4y1N7TY（4K DV）applied 零降级 sat 58→蓝屏闪后 legacy 回退色彩正常；BV1uZ/BV1W（DV）applied 零降级 sat 127/125；四样片零 ANR/FATAL。证据 `/tmp/pili-yuv/`（yuv8-19、vfinal-*、fin2/fin3-*、confirm、itu-*）。
- **依赖变化**：pubspec.yaml 新增 `media_kit_android_dataspace_vendor: 1.0.0`（vendor 插件入包，ext=lg-pq 注册的前提）；flutter 约束曾临时放宽 pub get 后已恢复 3.47.7 钉值。


```bash
export PATH=~/flutter-sdks/3.47.7/bin:$PATH          # 独立 SDK（pubspec 精确钉 3.47.7；全局 3.47.2 不可用）
export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
cd ~/src/PiliPlus
flutter pub get                                       # 首次或 media-kit 依赖变化后
flutter build apk --release --split-per-abi --target-platform android-arm64 \
  --android-project-arg dev=1 --no-pub                # dev 变体＝debug 签名+.dev 包名后缀
adb -s <serial> install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

前置一次性：Flutter SDK 补丁链（等效 `lib/scripts/patch.ps1 android`，bash 版）——SDK 25 补丁（modal_barrier…double_tap_gesture + bottom_sheet_android/scroll_view/navigator）打在 `~/flutter-sdks/3.47.7`，material_ui 9 补丁打在 `~/.pub-cache/hosted/pub.dev/material_ui-*`（删缓存重新 pub get 后打）。残留 Gradle daemon 锁 `journal-1` 时 `cd android && ./gradlew --stop`。

### 设备与取证经验

- 三机 serial：LG `LGH870DS42e27764`（API24，lucye）、LYA `3EP7N18C28016072`（API29，hisi）、marble `dede0cd2`（API35，HyperOS）。
- 帧率证据用 `dumpsys SurfaceFlinger --latency`：华为层名带空格 `SurfaceView - pkg/act#0`，LG（Nougat）不带 `#0`；先 `--latency-clear` 再采样；截图像素差不可作帧推进判据（多次 0% 假阴性）。
- LG 的 uiautomator dump 无输出、交互 shell logcat 为空：一律 `adb exec-out`；进度判据用 uiautomator（LYA/marble 可用）读 `N%, 进度条`。
- 长构建期间设备会自动锁屏：每轮先 `input keyevent KEYCODE_WAKEUP` + 上滑解锁，再 force-stop+深链。
- marble USB 安装被「应用安装拦截」需机主放开开发者选项，不绕过；同包名升级安装不触发拦截。
- 深链验收 URL：`https://www.bilibili.com/video/BV1vY4y1N7TY`（4K DV 样片）/ `BV1T7t96BECu`（SDR 复入片）。
- 路由证据通道：`lib/main.dart` 的 `HdrOutputDiagnostics.enabled = true`（HdrDiag 行；`routed error:`/`routed open failed,` 标记为 App 侧回退路径指示）。

### 开放项

- [ ] 发布前移除 `lib/main.dart` 的 HdrDiag 诊断行（或改 kDebugMode 门控）。
- [ ] media-kit 侧不变量 3（唯一重开权威）落地后评估删除 App 侧 `_switchToLegacyOutput` 回退。
- [ ] media-kit DV nativeHdr 实现段在 LYA 静默停滞待查——legacy 桥已 require(sdr) 规避，显式 HDR 接入前不解锁。
- [ ] marble 帧率未量化（本轮只验 applied+进度+零崩溃）。
- [ ] media-kit 本地提交（f61311fc/4df7755e/26a2c2c6 等）与 App `a01f8ff53` 均未推送，推送需用户确认。
- [ ] `pubspec.lock`/`pubspec_overrides.yaml` 已随 `a01f8ff53` 提交在 `feature/ohos`；该分支不受每日镜像影响，合回 main 前须评估镜像语义。
- [ ] HDR 点亮轮遗留（2026-10-20 晚）：亮部残余过曝（target-peak=1000 A/B，media-kit 侧）；出视频前短暂灰屏+pillarbox 灰条（vendor native clearSurfaceBlack，media-kit 侧）；播放控件被 ON-TOP 视频盖住（App 侧控件迁移平台视图或维持现状）；滑动蓝屏观察。详见 `../media-kit/archives/conversations/piliplus-lg-hdr-lit-handoff-20261020.md`。
- [ ] 本轮 App 侧变更（pages/video/view.dart playerReady 门、pl_player controller 门控+看门狗+liveness、pubspec vendor 依赖）未 commit；`.gitignore`/`.commandcode/`/AGENTS 等非本轮产物未动。

## 接手入口

- 播放器接线：`lib/plugin/pl_player/controller.dart`（`_initPlayer`/`_createVideoController`/`_switchToLegacyOutput`）、`lib/plugin/pl_player/view/view.dart`（RoutedSimpleVideo/字幕）、`lib/pages/video/view.dart`（挂载门）。
- 依赖接线：`pubspec_overrides.yaml`；构建输入变化后重跑 pub get。
- media-kit 侧对应任务/设计：`../media-kit/TASKS.md` MK-ROUTING 段、`../media-kit/docs/plans/review-gate-invariants-auto-routing-20261020.md`。
- 本轮证据：`/tmp/pili-verify-20261020/`（lya-final/lg-final/marble-final 含 HdrDiag 全序列与 SF 帧率）。
