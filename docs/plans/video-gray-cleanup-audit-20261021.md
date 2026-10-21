# 播放灰屏修复：跨目录修改复核与回退（2026-10-21）

回退前快照：`/Users/wuweiwei1/.local/state/piliplus-review/20261021-095952`。包含工作区文件、HEAD diff、index diff、每文件 SHA-256；仅逐项回退已审核内容，清理阶段未提交；本次按用户明确授权分别在三仓本地提交，仍不推送。

## 范围与处理

PiliPlus、media-kit、mpv、Flutter 3.47.7、Homebrew Flutter 3.47.2，以及 PiliPlusX、material_ui 缓存、native 构建仓和 media-kit-build。源码、项目补丁与验收产物分开判定。

## PiliPlus

| 文件 | 复核结论 |
|---|---|
| `.commandcode/settings.json` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `.commandcode/taste/taste.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `.commandcode/taste/taste/taste.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `.gitignore` | 移入本地 .git/info/exclude；tracked .gitignore 已恢复HEAD。 |
| `AGENTS.local.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `AI_WORK_OS.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `CLAUDE.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `TASKS.md` | 更新：真实根因、验收与本次清理入口。 |
| `android/app/src/main/res/values/styles.xml` | 回退：纯红背景 A/B 已证明无效。 |
| `archives/conversations/video-gray-getx-20261021.md` | 保留：历史调查材料，标为已被GetX实证更正。 |
| `docs/plans/lg-hdr-gray-cover-investigation-20261020.md` | 保留：历史调查材料，标为已被GetX实证更正。 |
| `docs/plans/lg-hdr-gray-next-plan-20261021.md` | 保留：历史调查材料，标为已被GetX实证更正。 |
| `lib/pages/video/controller.dart` | 回退：灰屏 workaround 的 HDR 白名单/codec 猜测及日志；恢复 SDK 统一规划。 |
| `lib/pages/video/view.dart` | 保留：平台视图 open 前必须挂载，避免循环等待。 |
| `lib/plugin/pl_player/controller.dart` | 全部恢复HEAD；新增自动播放与既有_initializePlayer回调重复，已一并撤回。 |
| `lib/plugin/pl_player/view/view.dart` | 保留：Obx 真修复与 viewport 几何；改正错误归因注释。 |
| `macos/Flutter/Flutter-Debug.xcconfig` | 恢复HEAD：Flutter pub get自动添加但与本轮Android修复无关，避免App维护额外补丁。 |
| `macos/Flutter/Flutter-Release.xcconfig` | 恢复HEAD：Flutter pub get自动添加但与本轮Android修复无关，避免App维护额外补丁。 |
| `pubspec.lock` | 恢复HEAD：pub get证实插件仍由聚合包传递引入并注册。 |
| `pubspec.yaml` | 恢复HEAD：vendor依赖迁入media-kit的media_kit_libs_video聚合包。 |

## media-kit

| 文件 | 复核结论 |
|---|---|
| `.commandcode/taste/communication/taste.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `.commandcode/taste/taste.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `.commandcode/taste/technical/taste.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `.commandcode/taste/tooling/taste.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `.commandcode/taste/workflow/taste.md` | 保留：原有工具/偏好/协作配置，无证据表明是无效实验。 |
| `TASKS.md` | 更新：纠正旧假设，指向唯一上下文。 |
| `archives/conversations/piliplus-lg-gray-veil-hdr-gate-20261020.md` | 保留：历史调查材料，标为已被GetX实证更正。 |
| `archives/conversations/piliplus-lg-hdr-lit-handoff-20261020.md` | 保留：历史调查材料，标为已被GetX实证更正。 |
| `archives/conversations/piliplus-lg-yuv-carrier-execution-20261020.md` | 保留：历史调查材料，标为已被GetX实证更正。 |
| `libs/android/media_kit_android_dataspace_vendor/android/src/main/java/com/alexmercerind/media_kit_android_dataspace_vendor/LgPqDataSpaceExt.java` | 保留：精确机型 PQ 能力声明，已有真实解码与用户面板证据。 |
| `libs/android/media_kit_libs_android_video/CHANGELOG.md` | 回退：默认本地 JAR 说明已失效，来源记于归档。 |
| `libs/android/media_kit_libs_android_video/android/build.gradle` | 回退：绝对 file:// 默认发布依赖；源码测试使用显式 local-JAR 通道。 |
| `libs/android/media_kit_libs_android_video/android/jars/mks-arm64-v8a.jar` | 已备份移出：冗余实验JAR；不再改变默认发布链。 |
| `media_kit_video/android/src/main/java/com/alexmercerind/media_kit_video/platformview/PlatformVideoView.java` | 回退：全局 Z 序与非1010102 INVISIBLE 实验；诊断/restorer 已删。 |
| `media_kit_video/lib/src/hdr/hdr_decoder_review.dart` | 保留：真实 4K review 超过8s的独立证据，20s仍有限界。 |
| `media_kit_video/lib/src/hdr/hdr_output_resources.dart` | 保留：accepted output 的活跃资源接口。 |
| `media_kit_video/lib/src/hdr/hdr_player_backend.dart` | 保留PQ/peak1000；回退hint剥离、55s与伪造复核事实。 |
| `media_kit_video/lib/src/hdr/hdr_strategy_realizer.dart` | 回退：无效gpu替换、等价谓词变更与错误解释。 |
| `media_kit_video/lib/src/hdr/hdr_video_session.dart` | 保留20s与安全保活；撤回预热和忽略无事实pending能力事件的临时分支，恢复正常能力变化处理。 |
| `media_kit_video/lib/src/hdr/hdr_yuv_presentation_contract.dart` | 仅保留peak1000；恢复原严格carrier识别，缺失契约仍拒绝。 |
| `media_kit_video/lib/src/hdr/hdr_yuv_window_arm.dart` | 保留活跃输出；修正提前释放所有权及managed失败清理，独立V2复核。 |
| `media_kit_video/lib/src/integration/routed_simple_video.dart` | 仅保留viewport；恢复原ready cover与Stack。 |
| `media_kit_video/lib/src/integration/routed_video_playback.dart` | 仅保留HDR自动规划；撤回急建/空预热/stop实验。 |
| `media_kit_video/lib/src/video/platform_view_video.dart` | 回退：无行为变化的错误注释。 |
| `media_kit_video/lib/src/video/simple_video.dart` | 仅保留viewport/notifier布局；恢复原cover/Stack。 |
| `media_kit_video/lib/src/video_controller/android_video_controller/real.dart` | 回退：任意64px阈值；由真实viewport及mpv占位resize处理。 |
| `media_kit_video/lib/src/video_controller/video_controller.dart` | 保留：idle树需ensureVisualUpdate，避免post-frame永久悬挂。 |
| `media_kit_video/test/hdr_sdr_embed_candidate_test.dart` | 回退：恢复gpu-next后不再需要替换测试预期。 |
| `media_kit_video/test/hdr_video_session_test.dart` | 保留并加强：跨会话/代次抢占/同owner重开与保活回归。 |
| `media_kit_video/test/hdr_yuv_presentation_contract_test.dart` | 保留PQ/peak写入恢复断言；还原被放宽的缺失契约拒绝测试。 |
| `media_kit_video/test/hdr_yuv_window_arm_test.dart` | 恢复原严格测试，新增managed生产路径/失败清理测试。 |
| `tool/build-android-test.sh` | 保留：显式app-dir源码构建、准确选择新鲜APK。 |

## mpv

| 文件 | 复核结论 |
|---|---|
| `video/out/opengl/context_android.c` | 仅保留有效占位初始化（4行新增/8行删除）；回退P0开关、resize诊断及冗余日志。 |

## Flutter SDK 与其它目录

- Flutter 3.47.7：36 个差异文件均对应项目补丁清单，Android 25 个 patch 的反向应用检查全部通过，全部保留。
- Homebrew Flutter 3.47.2：同一实体由 Caskroom 链接；36 个差异文件中35个路径在项目补丁清单，另有旧手势定制。`pointerDownFilter` 被 PiliPlusX 使用；没有证据为灰屏实验，全部保留。两个SDK本次均零写入。
- material_ui-1.6.0：项目所需9个material补丁反向检查全部通过，未发现10月20日以后改动，保留。
- PiliPlusX：当前Git工作区干净，未改动。
- libmpv-android-video-build-dv-experiment：无tracked修改，两个旧Python缓存与本任务无关，未动。
- media-kit-build：源码构建产物与native-candidate.json为可复现和回退证据，保留；不作为源代码修改。

新增测试变更：`hdr_native_dv_session_observer_test.dart` 的测试fixture显式指定8秒期限，保持原“观察回调消耗producer期限”断言，避免依赖生产默认期限。

## SDK 逐文件清单

### flutter-3.47.7

- `packages/flutter/lib/src/gestures/multitap.dart`：保留。
- `packages/flutter/lib/src/gestures/tap_and_drag.dart`：保留。
- `packages/flutter/lib/src/material/bottom_sheet.dart`：保留。
- `packages/flutter/lib/src/material/floating_action_button.dart`：保留。
- `packages/flutter/lib/src/material/navigation_drawer.dart`：保留。
- `packages/flutter/lib/src/material/popup_menu.dart`：保留。
- `packages/flutter/lib/src/material/progress_indicator.dart`：保留。
- `packages/flutter/lib/src/material/scaffold.dart`：保留。
- `packages/flutter/lib/src/material/tabs.dart`：保留。
- `packages/flutter/lib/src/material/text_field.dart`：保留。
- `packages/flutter/lib/src/painting/inline_span.dart`：保留。
- `packages/flutter/lib/src/painting/placeholder_span.dart`：保留。
- `packages/flutter/lib/src/painting/text_painter.dart`：保留。
- `packages/flutter/lib/src/painting/text_span.dart`：保留。
- `packages/flutter/lib/src/rendering/editable.dart`：保留。
- `packages/flutter/lib/src/rendering/paragraph.dart`：保留。
- `packages/flutter/lib/src/rendering/selection.dart`：保留。
- `packages/flutter/lib/src/widgets/draggable_scrollable_sheet.dart`：保留。
- `packages/flutter/lib/src/widgets/editable_text.dart`：保留。
- `packages/flutter/lib/src/widgets/gesture_detector.dart`：保留。
- `packages/flutter/lib/src/widgets/image.dart`：保留。
- `packages/flutter/lib/src/widgets/layout_builder.dart`：保留。
- `packages/flutter/lib/src/widgets/modal_barrier.dart`：保留。
- `packages/flutter/lib/src/widgets/navigator.dart`：保留。
- `packages/flutter/lib/src/widgets/page_view.dart`：保留。
- `packages/flutter/lib/src/widgets/routes.dart`：保留。
- `packages/flutter/lib/src/widgets/scroll_position_with_single_context.dart`：保留。
- `packages/flutter/lib/src/widgets/scrollable.dart`：保留。
- `packages/flutter/lib/src/widgets/selectable_region.dart`：保留。
- `packages/flutter/lib/src/widgets/selection_container.dart`：保留。
- `packages/flutter/lib/src/widgets/sliver.dart`：保留。
- `packages/flutter/lib/src/widgets/text.dart`：保留。
- `packages/flutter/lib/src/widgets/text_selection.dart`：保留。
- `packages/flutter/lib/src/widgets/widget_span.dart`：保留。
- `packages/flutter/lib/src/widgets/widget_state.dart`：保留。
- `packages/flutter/test/widgets/selectable_region_test.dart`：保留。

### flutter-homebrew

- `packages/flutter/lib/src/gestures/tap_and_drag.dart`：保留。
- `packages/flutter/lib/src/material/bottom_sheet.dart`：保留。
- `packages/flutter/lib/src/material/floating_action_button.dart`：保留。
- `packages/flutter/lib/src/material/navigation_drawer.dart`：保留。
- `packages/flutter/lib/src/material/popup_menu.dart`：保留。
- `packages/flutter/lib/src/material/progress_indicator.dart`：保留。
- `packages/flutter/lib/src/material/scaffold.dart`：保留。
- `packages/flutter/lib/src/material/tabs.dart`：保留。
- `packages/flutter/lib/src/material/text_field.dart`：保留。
- `packages/flutter/lib/src/painting/inline_span.dart`：保留。
- `packages/flutter/lib/src/painting/placeholder_span.dart`：保留。
- `packages/flutter/lib/src/painting/text_painter.dart`：保留。
- `packages/flutter/lib/src/painting/text_span.dart`：保留。
- `packages/flutter/lib/src/rendering/editable.dart`：保留。
- `packages/flutter/lib/src/rendering/paragraph.dart`：保留。
- `packages/flutter/lib/src/rendering/selection.dart`：保留。
- `packages/flutter/lib/src/widgets/draggable_scrollable_sheet.dart`：保留。
- `packages/flutter/lib/src/widgets/editable_text.dart`：保留。
- `packages/flutter/lib/src/widgets/gesture_detector.dart`：保留。
- `packages/flutter/lib/src/widgets/image.dart`：保留。
- `packages/flutter/lib/src/widgets/layout_builder.dart`：保留。
- `packages/flutter/lib/src/widgets/modal_barrier.dart`：保留。
- `packages/flutter/lib/src/widgets/navigator.dart`：保留。
- `packages/flutter/lib/src/widgets/page_view.dart`：保留。
- `packages/flutter/lib/src/widgets/routes.dart`：保留。
- `packages/flutter/lib/src/widgets/scroll_position_with_single_context.dart`：保留。
- `packages/flutter/lib/src/widgets/scroll_view.dart`：保留。
- `packages/flutter/lib/src/widgets/scrollable.dart`：保留。
- `packages/flutter/lib/src/widgets/selectable_region.dart`：保留。
- `packages/flutter/lib/src/widgets/selection_container.dart`：保留。
- `packages/flutter/lib/src/widgets/sliver.dart`：保留。
- `packages/flutter/lib/src/widgets/text.dart`：保留。
- `packages/flutter/lib/src/widgets/text_selection.dart`：保留。
- `packages/flutter/lib/src/widgets/widget_span.dart`：保留。
- `packages/flutter/lib/src/widgets/widget_state.dart`：保留。
- `packages/flutter/test/widgets/selectable_region_test.dart`：保留。

## 验收边界

- 最小Obx修复版已获用户“画面正常，控件可见”确认；清理后版本必须重新构建/装机。
- 当前HDR验证仅适用于 `tool/build-android-test.sh --app-dir ...` 显式注入源码JAR；默认发布下载链已恢复但未升级native资产，不能沿用本轮HDR验收。
- 最终测试与设备结果见唯一上下文 `../../archives/conversations/video-gray-getx-20261021.md`。

## 上游同步最小化（用户后续要求）

- PiliPlus 相对本次提交前 HEAD 的业务源码仅两个文件：`pages/video/view.dart` 一处挂载条件；`pl_player/view/view.dart` 一处同步 Rx 读取（两条字幕分支共用）和一行 viewport 参数。库负责实际几何/渲染，App仅提供自己的槽位。
- `pubspec.yaml`、`pubspec.lock`、`pl_player/controller.dart`、`pages/video/controller.dart`、Android styles、两个 macOS xcconfig 和 `.gitignore` 已恢复HEAD。
- 新增 `media-kit/libs/universal/media_kit_libs_video/pubspec.yaml` 的vendor依赖。依赖图为bundle→vendor→video→media_kit，pub get已验证无环且Android注册项仍包含vendor。此fork的bundle包含设备门控的HDR能力，消费者需满足vendor的Android最低版本；App原本已包含这些包，因此没有增加其运行门槛。
- mpv 1×1路径有源码调用链：AndroidVideoController在rect为空时写android-surface-size=1x1→native优先采用该属性→原offscreen初始化直接失败；viewport改变Flutter布局但不能保证异步WID绑定前rect已更新。保留占位分配，后续沿用正常resize。此为初始化时序修复，不是ErrorWidget灰层修复。
- 再次全量测试：1023通过、8跳过，日志 `/tmp/pili-gray-20261021/minimal-final-tests.log`。

## 最终验证状态

最终精简包已源码构建并安装，SHA-256为`1686aeb3fd2cba04145f0f6472774d0957b85b122835f0764ecea74d56c3c308`。HDR首启/重进、SDR及另一HDR均达到真实复核applied/verified。另一HDR首次review耗时11946ms，支持保留20秒预算；没有依赖55秒或计划伪造事实。全量测试1023通过/8跳过。最终精简包已由用户明确确认“画面和控件都正常”，面板验收完成。

本地提交归档：mpv `1af17925fb`；media-kit `917405a7`；PiliPlus随本次提交归档（见git log）。仅相关修复和任务/调查/验收记录，排除环境配置。
