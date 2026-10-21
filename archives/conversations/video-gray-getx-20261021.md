# LG HDR 播放灰屏：GetX ErrorWidget 根因与验证（2026-10-21）

## Current State

### HDR 亮度调整（面板验收通过，本地提交归档，2026-10-21）

用户取消与 PiliPlusX 对比（其高光有过曝），改为保守整体提亮；初期要求不提交，现已授权先提交已验收代码。LG 基线 driver `hdr_mode=1`、背光255/255、thermal=0，不能据此宣称实测峰值或亮度达标。基线 `/tmp/pili-brightness-20261021/baseline/summary.json`。当前方案仅在 media-kit 的已验证 LG YUV HLG→PQ 路由对中性 gamma 做 +3 调整，保持 target-peak=1000；保留非中性用户值并在会话结束恢复。候选定向23项、全量1031通过/8跳过，V1独立复核通过；已修正跨session重新捕获gamma，覆盖浮点回读、scope、非0用户偏好、重复配置和失败恢复。源码APK `pili-brightness-20261021-release.apk` 已构建安装LG，SHA256 `16bd9761a71d6df26f0c31b9c4e49472b8ebe8faee610eb52cfe2c39a58869ff`；同PID HDR→SDR→HDR均applied verified=true，零已观察GetX/FATAL/ANR。gamma数值不单独打日志，applied与源码的条件/配置回读串联，不能冒称直接runtime property采样。临时App亮度随重启/退出恢复，背光从基线255降为100/255（系统auto1、window override=-1），没有写系统设置；已请用户按常用播放器亮度确认；用户明确回复“亮度合适，高光正常”，本候选的北海道HDR亮度与高光面板验收通过。用户回复时的最终背光数值未另采样，不据此推断物理峰值。用户现授权本地提交已验收提亮代码和记录，不推送；media-kit提亮修复已本地提交为 `98c611a3`（`fix(android): 小幅提亮 LG HLG 视频并保留高光`）；后续EOF调查的临时诊断留工作区、不纳入本次提交。永久证据：`../evidence/hdr-brightness-20261021.txt`。PiliPlus业务代码和mpv保持不变。

### 已完成灰层修复

灰层根因已闭合：字幕 Obx 的同步作用域未读取 Rx，Release ErrorWidget 用 `F0C0C0C0` 覆盖整个视频。最小修复版已获用户“画面正常，控件可见”确认。

跨目录复核、回退和上游同步精简已完成。PiliPlus 相对本次提交前 HEAD 的业务代码只剩两个文件（8行新增、4行删除）：页面挂载条件、字幕同步Rx读取、viewport参数。vendor依赖迁入media-kit视频聚合包，App pubspec/lock/controller/styles/macOS配置/gitignore已恢复HEAD。mpv仅保留占位尺寸的有效初始化；SDK源文件与快照完全一致。完整处理清单：`../../docs/plans/video-gray-cleanup-audit-20261021.md`。回退前125文件备份已校验：`/Users/wuweiwei1/.local/state/piliplus-review/20261021-095952/`。

最终精简源码全量测试1023通过、8跳过；APK `pili-minimal-20261021-release.apk` 已构建并安装LG。HDR首启/重进、SDR、另一HDR均达到真实 `applied verified=true`，已采日志无GetX improper-use、routed fallback、ANR/FATAL。最终精简包已获用户明确确认“画面和控件都正常”，完成迁移依赖和恢复原FittedBox后的面板验收。手机最后回北海道HDR。本轮保留修复和相关任务记录随三仓本地提交归档；不推送。

## 证据与判定

- 09:51:07 的设备 logcat 报告 `[Get] the improper use of a GetX has been detected.`；同一轮 `PlatformOverlayView.draw` 离屏 bitmap 的网格采样为 alpha 240、RGB `(192,192,192)`，即 ARGB `0xF0C0C0C0`。
- 本机 Flutter 3.47.7 `packages/flutter/lib/src/rendering/error.dart` 中，`RenderErrorBox._initBackgroundColor()` 在 Release 默认返回 `Color(0xF0C0C0C0)`（debug assertion 下才切到暗红）。像素值与 Release ErrorBox 默认背景精确相等。
- routed 字幕的外层 `Obx` 原先在嵌套 `ValueListenableBuilder` builder 中才读取 `subtitleConfig.value`。该 Rx 读取不在外层 `Obx` 的同步构建作用域内，logcat 的 GetX improper-use 报错与释放模式错误框颜色为这条路径提供了相互吻合的证据。
- 旧 Java `TransparentRegionRestorer` 装机后，SurfaceFlinger 的应用窗口 `transparentRegion` 已是视频矩形 `[0,141,1440,861]`；设备截图仍呈均匀灰，且用户确认面板仍灰。这证伪了“恢复透明洞即可修好画面”的充分性结论。截图对 PQ 面板内容仍有采集限制；本轮此处结论以用户面板确认和 ErrorBox 像素证据为准。

## 初次实施阶段（历史，已由末尾最终验收覆盖）

- PiliPlus `lib/plugin/pl_player/view/view.dart`：在字幕 `Obx` 回调开头同步读出 `subtitleConfig.value`，再把同一配置传给当前 routed controller 或 legacy controller 的 `SubtitleView`。
- media-kit `media_kit_video/android/.../PlatformVideoView.java`：临时 `diagRelaxOverlaySiblings`、`TransparentRegionRestorer` 与相关诊断代码已删除。
- media-kit `routed_simple_video.dart`、`simple_video.dart`：删除“cover 会创建/污染 PlatformOverlayView 并导致灰屏”的因果断言，改为说明 routed view 的挂载/ready 时序、texture 尚无视频尺寸时的 fill，以及 platform viewport 的用途；功能代码保持原样。
- 构建命令走 `media-kit/tool/build-android-test.sh --app-dir /Users/wuweiwei1/src/PiliPlus ...`，由脚本按 mpv → media-kit 本地 JAR → PiliPlus Flutter 构建。构建进行中，产物尚未确认。
- 完成门槛：确认新 APK 的源码/JAR 身份并安装 LG；复播 HDR 样片，检查 GetX improper-use 消失、面板颜色正常、控件可见可点；退出重进并回归 SDR `BV1T7t96BECu` 与 DV `BV1uZ4y1U7h8`，确认零 ANR/FATAL。构建、安装和日志检查不能替代面板验收。

## 证据文件

- `/tmp/pili-gray-20261021/flutter.log`：设备 logcat 摘录，包括 GetX 报错、PlatformOverlayView 采样与 HDR 路由。
- `/tmp/pili-gray-20261021/restorer-sf.txt`：restorer 候选装机时的 SurfaceFlinger dump，窗口透明区恢复至视频矩形。
- `/tmp/pili-gray-20261021/restorer.png`：同一轮截图；PQ 层截图受采集限制，不能单独代表面板画面。

## 2026-10-21 实机确认与清理

- 修复版构建：`tool/build-android-test.sh --app-dir /Users/wuweiwei1/src/PiliPlus --tag pili-gray-fix-20261021 -- --split-per-abi --android-project-arg dev=1 --no-pub`，构建与安装成功。
- APK SHA-256：`1a36189162db0fb56a23b37348c5b38e7bb8bf58b529c618b467a587e7f33a95`；包内 libmpv SHA-256：`af0151cb692b983dcdbb5da38d944c5ee4f6a0e34e393d994a6476d24dcced52`，与本次源码构建产物一致。
- `/tmp/pili-gray-20261021/fixed-hdr.log`：09:55:38 `phase=applied verified=true presentation=nativeHdr output=pq`，无 improper-use；`controls-after-frame.png` 可见播放控件及 00:29 进度。PQ 内容在截图中为黑色，面板正常以用户确认作为验收证据。
- 用户确认：“画面正常，控件可见”。后续全面回退实验残留会生成新包，不能将此包验收自动沿用到清理后包。

## 上游同步精简（2026-10-21）

用户进一步要求App补丁尽量少并迁入media-kit。业务源码目前仅两个文件：页面挂载门的一处条件、字幕Rx的同步读取及viewport参数一行。App的vendor依赖已迁到media-kit_libs_video聚合包；pubspec/lock、播放器controller、红背景、macOS生成include和tracked gitignore均恢复HEAD；本地AGENTS忽略移到git/info/exclude。mpv只保留有效占位分配，诊断代码全删。无事实pending期间直接忽略能力变化的workaround也已撤回。该阶段全量测试1023通过/8跳过；后续构建、装机与用户验收已完成，见下方最终记录。逐文件表见 `../../docs/plans/video-gray-cleanup-audit-20261021.md`。

## 最终精简包验证

- APK SHA-256：`1686aeb3fd2cba04145f0f6472774d0957b85b122835f0764ecea74d56c3c308`；包内libmpv：`3a3edc4732c92732b9706373afecfe26838f4f0969b4749bb2aa93c199e5085d`，含源码构建的vendor native插件。
- 10:21:07 北海道首启、10:22:56 退出重进：`nativeHdr/surfacetexture/pq verified=true`；原FittedBox恢复后SF仍为1440×720@(0,141)、1:1矩阵。
- 10:23:26 SDR：`sdrDirect/gpu-next/mediacodec-copy/texture verified=true`；普通UI仍自行自动播放，移除重复player.play调用后媒体状态为playing。
- 另一HDR首次16秒采样不足以等完两轮复核，已延长重测：10:25:35达到`nativeHdr/surfacetexture/pq verified=true`。两轮真实review分别11946ms和5202ms，证明保留20秒预算有当前直接依据，不需要55秒或造假facts兜底。
- 机器证据：`/tmp/pili-gray-20261021/minimal-device/`；精简后全量测试：`minimal-final-tests.log`；永久关键摘要：`../evidence/video-gray-20261021.txt`。
- 全量测试1023通过/8跳过；App定向analyze无error/warning，仅既有unused多下划线info；各仓diff-check通过。SDK 72个源文件的SHA与清理前备份一致。

## 最终面板验收（2026-10-21）

用户针对进一步精简后的最终包明确回复：“画面和控件都正常”。该确认对应迁移vendor依赖、恢复原FittedBox、精简App补丁后的 `pili-minimal-20261021-release.apk`（SHA-256 `1686aeb3fd2cba04145f0f6472774d0957b85b122835f0764ecea74d56c3c308`）。本次灰层修复及精简后的画面、控件验收完成；未提交、未推送。

## 本地提交归档（2026-10-21）

用户明确授权按仓提交本次保留修复及相关任务记录，不推送、不带入无关改动。

- mpv：`media-kit/android@1af17925fb`，仅占位初始化与本仓任务/验收记录。
- media-kit：`compat/piliplus-zero-change-20261018@917405a7`，保留的HDR/生命周期/布局/构建/依赖修复、回归测试及相关调查记录（旧结论已标为失效）。
- PiliPlus：随本次提交归档，提交标识见本仓git log；业务源码仅页面挂载条件、字幕Rx读取和viewport参数，另含任务记录、证据摘要及清理审计。
- `.commandcode/`、`AGENTS.local.md`、`AI_WORK_OS.md`、`CLAUDE.md` 等环境配置不暂存；SDK和其它仓库不提交。
- 本次只更新提交/归档状态，未修改已验收源码；沿用1023通过/8跳过及最终包用户面板验收，不重复构建。
