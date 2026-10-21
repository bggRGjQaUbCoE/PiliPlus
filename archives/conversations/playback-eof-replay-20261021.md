# 播放结束后无法重播或拖动（2026-10-21）

## Current State

**进行中，未修复；临时诊断未提交**。用户明确补充：播完后放置超过30分钟再操作才发现重播/seek失效。当前新源码诊断包在LG运行，15:33:07.822自然EOF，原页被动停留31分钟，16:04:07.822之前不唤醒、不点播放或拖动；仅只读采集，允许系统按原设置自然熄屏。31分钟后同页恢复测试，失败则冻结现场。

旧现场已保存并复现，但在同进程重进同视频后，立即EOF重播、EOF后直接seek、熄屏唤醒、全屏EOF自动退竖屏均成功且命令reply0/真实新帧。不能宣称已修好或归因生命周期。PiliPlus业务代码没有新增修改；media-kit只新增临时默认关闭的标量诊断，保留之前已验收的gamma+3（用户现授权先提交该已验收修复和记录，临时诊断不纳入）；mpv未改。取证根目录 `/tmp/pili-eof-20261021/`。下面“初始现场”与历史实验保留时序，不当成当前屏幕状态。

## 初始现场

用户在已验收提亮候选上报告：播放完成后不能再次开始，拖动进度也无效，当前现场仍保留。调查中，不提交。已安装包 `pili-brightness-20261021-release.apk` SHA256 `16bd9761a71d6df26f0c31b9c4e49472b8ebe8faee610eb52cfe2c39a58869ff`，PiliPlus.dev PID3277，北海道视频；初始 MediaSession state2 position1170730ms，此值为会话更新基准，不能单独证明当前mpv状态。先采完整日志/图层/会话状态，再复现play/seek；不重开App覆盖现场，不触PiliPlusX。

保留media-kit当前未提交gamma+3和测试、文档；其面板验收结论见 `video-gray-getx-20261021.md`，与本次EOF问题分别验收。目标优先在media-kit修复；需覆盖自然EOF后重播、EOF后seek、重复结束、HDR/SDR与画面帧推进，构建安装不替代实机验收。

## 首轮现场与分支实验

- `/tmp/pili-eof-20261021/summary.json` 和 baseline/play-at-eof/seek-after-eof/double-tap：旧现场已复现，UI播放、129ms有效双击raw seek/play、拖动到09:45均无新SF帧；会话仍state2、1170730ms，UI时间会变。无直接mpv property/command回读，不能区分命令未完成与seek后的解码/网络失败。debuggerd只读回溯被权限拒绝，没有提权或信号终止。
- 原进程不force-stop，退出页面后同北海道深链重新获取源，15:15:08 nativeHdr/HLG/baseLayerConvert/PQ applied verified=true。两次近片尾后自然EOF均可恢复：第1轮按钮重播state3/position0且新SF帧；第2轮直接拖到中间自动恢复，position585017且新帧。不能将“重进恢复”当成原故障修复；旧源或长会话相关仅是假设，未发现明确HTTP403。
- 代码排查：routed/session不直接因EOF退租或清ready；播放按钮本身走raw player，排除“仅routed gate失效”充分解释。mpv给当前同项playlist-pos赋值不重载。MediaCodec flush源码正常清EOS，但当前没有原生线程栈证实运行行为。
- App `seek(isSeek:true)` 等buffer.first是独立潜在隐患，但当前slider和水平拖动均显式isSeek:false，不解释本现场。临时小修已精确撤回，补丁留 `/tmp/pili-eof-20261021/deferred-buffer-wait.patch`，App业务代码未新增改动。
- 下一步：库内临时、默认关闭的标量transport诊断，区分API入/锁取得/seek submit/reply/EOF/hook；保护签名URL不入日志。询问用户失败是否紧随EOF或长时间放置；需复现后再决定行为修复，不凭假设改codec或强制重开。

## 临时诊断与扩展复现（进行中）

- 仅media-kit native `real.dart` 临时加入默认关闭的 `MEDIA_KIT_TRANSPORT_TRACE`，包含本地player标识、API/锁/命令提交和回复、EOF及hook标量；不记录地址。Dart分析通过，补丁在 `/tmp/pili-eof-20261021/trace.patch`，最终需根据调查结果撤回无用诊断，不作为行为修复。
- 源码诊断APK `pili-eof-trace-20261021` 构建中。短EOF确认诊断后，优先覆盖EOF后熄屏/唤醒再重播（App在completed后500ms关闭wake lock，属实际源码事实；是否相关未知），然后视结果从0连续1x播放到自然EOF。没有确认修复，不提交。

## 诊断包短测结果

源码诊断APK安装成功：SHA256 `433b04c12499843ac166b4878295d711b80d5c5a8cb3d9a5a4016de7a8b65169`，包内libmpv `81386a07de9af47ff5deff8ad99c44574ac9b11cd01a34f99143322c79616a1a` 与本轮源码shipping一致。新PID10190；短EOF后熄屏/唤醒/原页重播通过：15:24:16 raw seek0及pause属性均reply code0，随后eof=false、state3、SF新帧。没有复现原故障，也未见bridge not initialized；不能以潜在源码生命周期缺口为本次根因。证据 `/tmp/pili-eof-20261021/trace-wake/`。15:24:17起从0、1x连续播放，不跳转，等待约15:43:47自然EOF（缓冲会顺延）。

## 全屏退出分支

原19.5min连续测试在约3分钟暂停计数（正常片段保留，不当作完整EOF）。新加入真横屏全屏→近片尾自然EOF→自动退竖屏：15:28:02结束后按钮重播同样成功，seek/pause reply0、eof=false及新SF帧；待第二轮退全屏后直接seek及全屏完整1x。纯尺寸更新经android-surface-size→external resize，不主动vo=null；所以未实际发生bridge shutdown/reinit前不能以源码假设归因。

## 提交范围（2026-10-21）

用户在31分钟被动停留测试期间要求“先把代码提交了”。本次本地提交只包含此前已验收的gamma提亮及测试/任务记录；本EOF上下文归档当前调查事实，不宣称已修复。native transport/deadline临时诊断留工作区，不纳入提交；App业务代码没有新增改动，mpv没有新增改动，不推送。31分钟测试继续，不因Git提交重启App或换包。
