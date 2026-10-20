# TASKS.md

任务事实源：只保留当前状态、验收门槛和下一步；按各项 `context` 查看持续更新的依据。
姊妹仓：本地 media-kit checkout 在 `../media-kit`（compat 分支），本仓的一切播放器行为变化先看其 `TASKS.md` 的 MK-ROUTING 段。
**镜像红线（2026-10-17 起）**：本仓 `main/dev/dom` 与全部 tag 由 `ci/upstream-sync` 孤儿分支每日强镜像自上游（force+prune），自有提交只能放特性分支（当前工作分支 `feature/ohos`，不受镜像影响）。

## ANDROID-LOCAL-MEDIA-KIT-20261020（本地 media-kit 构建与路由播放主线）

- 2026-10-20（一）**零改动 Android 构建链跑通 + brightness 供给修复**：PiliPlus 源码/pubspec 零改动，经根级 `pubspec_overrides.yaml`（全量 path 指向 `../media-kit`，保留 inappwebview 两条 git override，`media_kit_native_event_loop` 无本地包且无代码引用可安全移除）构建 Android arm64。compat 分支 direction B 兼容层实测消除 lib/ 全部 156 个 API 错误；`flutter test` 通过；analyze 剩余错误全在 `tool/ohos/`（Android 不编译）。装机后「手势调亮度数字变但亮度不变」根因＝PiliPlus 直依赖 `screen_brightness_platform_interface`，原生实现历来由旧 media_kit_video fork（bggRGjQaUbCoE native）依赖声明带入，本地库缺该声明→插件从 GeneratedPluginRegistrant 消失；修复在 media-kit 侧 `media_kit_video/pubspec.yaml`（f61311fc），App 零改动。
- 2026-10-20（二）**路由验收定位门死锁与丢帧根因**：零改动路径不走路由（legacy 默认 texture），LYA 播 BV1vY4y1N7TY（4K DV）SF 层实测 **15.3fps**（中位 65.4ms、64/126 间隔>2 vsync＝丢半帧），根因＝copy+gpu-next DV→SDR 色调映射+4K 纹理上传链。显式 `RoutedVideoPlayback` 接线后复核门确定性拒绝（iter=7 endpoint-changed，direct 与 copy 候选同拒）；LG 另有 outputBindTimeout（挂载门环）与 SDK16-25 默认 embed 载体挂死。EDL 双流源规划时事实全空（source=none class=sdr）。证据 `/tmp/pili-verify-20261020/`。
- 2026-10-20（三）**接线落地 + 自动播放修复 + 三机路由验收全绿**（App `a01f8ff53` + media-kit `26a2c2c6`）：播放器接 `RoutedVideoPlayback/RoutedSimpleVideo`（transport 走 binding、属性/订阅留原 player、`onlyPlayAudio` 传 `video:false`、open 被拒时 `_switchToLegacyOutput` 回退兜底）；修复两处视图侧死锁——页面挂载门 `videoController==null` 改为 `videoController==null && playback==null`（会话控制器在 open 期间才出现，Obx 只对 Rx 响应），`RoutedSimpleVideo` 空控制器占位是 1px 盒需 `aspectRatio: videoFit.aspectRatio ?? 16/9` 兜底；字幕改跟随 `playback.controller` listenable。`autoPlayEnable` 默认改 **true**（用户目标；旧行为＝深链不播、单击只切控制条、需拖推荐栏才触发）。终版实测（深链+自动播放零手工干预）：LYA review×2 success→dvP84 事实→toneMapSdr→applied，**30.6fps**（中位 32.7ms、5/126 超限）；LG review×2 success→applied（OMX.qcom HEVC 硬解），**30.4fps**；marble（displayHdrTypes=1,2,3,4 全能力）applied+播放推进；三机零 ANR/FATAL。
- 关键机理（写入 media-kit 侧但 App 验收依赖）：hisi/qcom 直连 attach 本可成功，旧复核门飞行中采样-重建风暴才是端点翻覆元凶；media-kit 已改静止后单采样+复核超时候选回退，legacy 桥 require(sdr)+sdrEmbed:false。App 侧不得再自造 preferCopy/回退优先级——候选序交给规划器。

### 构建手册（复现）

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

## 接手入口

- 播放器接线：`lib/plugin/pl_player/controller.dart`（`_initPlayer`/`_createVideoController`/`_switchToLegacyOutput`）、`lib/plugin/pl_player/view/view.dart`（RoutedSimpleVideo/字幕）、`lib/pages/video/view.dart`（挂载门）。
- 依赖接线：`pubspec_overrides.yaml`；构建输入变化后重跑 pub get。
- media-kit 侧对应任务/设计：`../media-kit/TASKS.md` MK-ROUTING 段、`../media-kit/docs/plans/review-gate-invariants-auto-routing-20261020.md`。
- 本轮证据：`/tmp/pili-verify-20261020/`（lya-final/lg-final/marble-final 含 HdrDiag 全序列与 SF 帧率）。
