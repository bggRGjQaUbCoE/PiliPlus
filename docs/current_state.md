# pili++ 当前项目状态

> 最后核对：2026-08-17 +08:00
>
> 本文件记录会随开发变化、但后续任务必须知道的事实。开始任务时先核对这里与实际
> Git、源码和构建产物；结束任务前更新。长期规则见 `AGENTS.md`，ExoPlayer 详细兼容
> 记录见 `docs/android_exoplayer.md`。

## 仓库基线

- 当前分支：`agent/exoplayer-concrete-hwdec`
- 本次播放器/上游合并基线：`03ed055`
  (`Merge remote-tracking branch 'upstream/main' into agent/exoplayer-concrete-hwdec`)；其后仅有
  状态文档提交。
- 最新 GitHub 发布源提交：`859d39c4ff3c77c37e1cc1d7131192df8f8b4241`
  (`chore: prepare 2.1.2 release`)
- 最新功能快照：`0c647b51ae60defc39c6171e5ca9387e43e596d2`
  (`feat: retry decoder failures with software video fallback`)
- 最新上游合并提交：`03ed055`
  (`Merge remote-tracking branch 'upstream/main' into agent/exoplayer-concrete-hwdec`)
- 上游：`https://github.com/bggRGjQaUbCoE/PiliPlus.git`
- 已获取并合入的 `upstream/main`：`f8b9ef3e6eca50dafb187cfbcdd67cab78ee4d61`
  (`upgrade deps`)
- 合并基线相对 `upstream/main` 已无落后；merge-base 即
  `f8b9ef3e6eca50dafb187cfbcdd67cab78ee4d61`。当前分支提交数以 `git rev-list` 为准。
- 应用内小窗、音频焦点/媒体控制、系统 PiP 恢复、版本更新和兼容记录已保存到上述
  功能快照。交接时应以实际 `git status` 为准；存在未提交修改时不得直接 merge 或
  rebase。
- `README.md` 已更新当前 ExoPlayer 迁移进度、应用内小窗行为、默认开关状态和
  上游同步说明；远程状态以实际 `git status` 和跟踪分支为准。
- 本次上游同步前的本地 CI 修复已提交为 `4207fb2`，成功 Android CI 记录为 `1582a5b`；
  合并提交 `03ed055` 已包含上游新增的 `810c26a`、`f73b9c9`、`f8b9ef3` 三个提交。
  当前工作区以实际 `git status` 为准。

## 应用与发布身份

- 用户可见名称：`pili++`
- Android applicationId：`com.shudo.plusplus`
- Android namespace：`com.shudo.plusplus`
- Java/Kotlin package：`com.example.piliplus`
- Release 证书 SHA-256：
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`
- 机器可读发布基线：`tool/release_baseline.json`

## 最近一次交付

- 版本：`2.1.8`
- versionCode：`2026081004`
- ABI：universal (`arm64-v8a`、`armeabi-v7a`、`x86_64`)
- 文件名：`pili++-2.1.8-2026081004-universal-release-pull-resize-v7-final.apk`
- APK SHA-256：
  `6748CDFF54C5B3C0BE7C2B5369AEE99CEF4486D838E250EDD2C3F43C6E3E40DA`
- 2026-08-10 14:36 已生成并交付播放页/竖屏全屏连续缩放动画通用 APK，尚未发布 GitHub
  Release；该 APK 已通过 `tool/verify_release.ps1` 的应用身份、版本、ABI 和签名校验。
  2026-08-15 用户确认视频页下拉、竖屏全屏连续缩放和 mpv/ExoPlayer 手势一致性验收完成。

## 已确认的产品决定

- ExoPlayer 完整兼容 mpv 是 Android 播放器的最终目标；未闭环前不得宣称完成替代。
- 应用内小窗开关默认关闭。
- 应用内小窗不显示“系统画中画”按钮。
- 小窗按视频真实宽高比适配，不强制使用 16:9。
- 视频页缩小、尺寸变化和圆角动画必须同时进行。
- 小窗恢复时，视频页加载和小窗归位必须同时进行，并复用原播放器会话。
- 应用内小窗进入系统 PiP 后，点击 PiP 全屏必须回到当前视频详情页；关闭 PiP 不得
  主动恢复详情页。
- 进程死亡后的任务恢复已按用户决定延期，不计为已完成。
- 2026-07-30 用户决定旧版仅含 `ExoPlayer: Source error` 且无堆栈的历史日志暂不处理，
  不纳入批次 3。
- 2026-08-02 用户确认接受 Media3 超分禁用/效率/画质的当前行为：运行时无缝切换不是
  缺陷，不要求复制上游 mpv/Anime4K 切换时的暂停加载；当前 Lanczos 效果即使肉眼差异
  不明显，也按“功能有效”处理。该决定关闭基础超分效果验收，不代表缓冲/硬解回退或
  其他第八批缺口一并完成。
- 2026-08-03 用户确认在 Samsung SM-S9180、Android 16 上安全缓冲隔离包不再黑屏。该结果
  把旧 P0 回归变量收敛到“解码器选择或加载控制”二选一，缓冲设置可标记为真机验收通过，
  并放行“只恢复解码器”的下一隔离组。

## 已验证状态

根据 `docs/android_exoplayer.md` 中记录的 2026-07-26、2026-07-28、2026-07-30 和
2026-08-15 用户真机验收反馈，以下场景已经过当前测试设备验证：

- 点击显示/隐藏控制层、双击播放/暂停、横向跳转、纵向亮度/音量和长按倍速；
- 清晰度、CDN、网络错误重载和分P切换的播放状态保持；
- 全屏、旋转、锁定、画面适配、缩放、翻转和常用手势；
- 弹幕、字幕、章节/看点、预览、高能进度和 SponsorBlock；
- ExoPlayer 自动进入系统 PiP；
- 应用内小窗的播放、暂停、拖动、关闭、恢复、动画与视频比例适配；
- 应用内小窗进入系统 PiP，以及 PiP 全屏恢复详情页的完整往返；
- 音频焦点、媒体通知、媒体按键和有线耳机/蓝牙控制；
- 小窗控件默认隐藏、点击淡入、3 秒自动淡出和操作后重置计时；完成播放后自动释放
  小窗、已完成视频页返回时不创建小窗，以及 A→B→C 叠加视频页逐层返回时不重复
  创建小窗。上述生命周期修复已提交为 `5ac01dd98a29584c1f5e27567fff9d42b25e7337`。
- 2026-07-30 用户反馈 ExoPlayer 适配批次 1、批次 2 在其已执行的真机流程中“貌似
  都没问题”。该反馈记录为当前测试流程未观察到回归；批次 1 明确未实现的 Media3
  截图/超分效果，以及批次 2 的 bitmap cue/竖排布局仍不因此标记为完成。
- Media3 直播闭环与 mpv 对照；独立音频的播放列表、循环、媒体控制、音频焦点、耳机/蓝牙
  与后台/息屏场景；
- 字幕边缘媒体：PGS/DVB bitmap cue 与 WebVTT `vertical-rl`/`vertical-lr`；
- 视频页下拉小窗、详情顶部下拉进入竖屏全屏、全屏上滑退出、连续缩放及 4:3/9:16
  同会话换源宽高比刷新；
- Media3 音视频轨道选择、播放器信息、响度归一化，以及当前已支持的音频滤镜映射；
- ExoPlayer 普通截图、评论区截图和动态 WebP 的预览、保存、取消及播放状态保持。

这些记录只代表当时设备和操作范围，不自动覆盖折叠屏、不同 Android 版本、不同芯片
或后续代码修改后的回归结果。

## 最近一次上游同步验证

- 2026-08-10 从本地 `2f512df47b308938164595ac3ba0f514fe53a5ac` 同步
  `upstream/main@36dec609315cd34f8895cf15607f1cc582a66f01`。同步前本地领先 67、
  落后 35；原有未提交音频滤镜、播放页手势、版本和文档修改先完整保存，合并后已恢复为
  未暂存状态。
- 三处文本冲突已人工审计：Android 保留 `com.shudo.plusplus` 和本地 Media3 依赖，接受
  上游 compile/target SDK 37；视频页采用上游 `SimpleScaffold`、`MiniScaffold`、状态栏、
  介绍区和刷新布局，同时保留 `_pageRootKey`、应用内小窗复用以及三组下拉/上滑手势；
  播放器头部保留本地 ExoPlayer 轨道/信息、SponsorBlock、字幕和 PiP 能力。
- 合并态全量 Flutter 测试通过 48/48；恢复本地修改后全量 `dart analyze` 为 0 error、
  0 warning、35 条 info，全量 Flutter 测试通过 61/61，Android
  `:app:testDebugUnitTest` 和 Android Release 构建通过。
- 当前官方 SDK 工具将 API 37 安装为 `platforms/android-37.0`，而 AGP 9.0.1 按上游整数
  `compileSdk = 37` 查找 `platforms/android-37`；专用 Android SDK 已建立指向同一平台的
  兼容目录联接。Gradle 仍提示 AGP 9.0.1 仅测试至 compile SDK 36.1、部分插件尚未迁移
  built-in Kotlin，这些是后续工具链升级风险，不是本次测试失败。
- 验证 APK 位于
  `build/app/outputs/flutter-apk/pili++-2.1.5-2026081001-universal-release-upstream-36dec60-validation.apk`，
  applicationId、应用名、版本、universal ABI 和签名证书均通过
  `tool/verify_release.ps1 -AllowAlreadyDelivered`；APK SHA-256 为
  `B2A8DC5D266B42571E22EF0A2628DEEB7CC690DDAF6763D4667CF543EDADB1CE`。该包仅用于同步验证，
  不替代已交付 v5，也不更新发布基线。
- 2026-08-10 上游同步验证时，mpv/ExoPlayer 点播、控制层、三组手势、应用内小窗恢复、
  系统 PiP、直播、独立音频、前后台和生命周期仍处于待回归状态；该历史记录已由
  2026-08-15 用户真机验收结论更新，当前已确认的项目见上方清单。

## 当前修改与验证记录

- ExoPlayer 音频滤镜链已新增 `highpass=f=<Hz>` 的 Media3 PCM 等价近似：Dart 侧解析
  单个高通阶段并把频率传入 Android，原生侧按声道使用一阶离散高通滤波器，再叠加既有
  音量/响度归一化和真峰值限制；畸形参数、重复高通或其他未知阶段仍显示明确未适配提示，
  mpv 继续使用原始 FFmpeg 链。代码、定向测试和 Release 审计包均已完成；2026-08-15 用户
  确认当前已支持滤镜的 Media3/mpv 真机听感与播放场景验收完成。

- 2026-08-15 继续适配明确音频能力缺口：ExoPlayer 现在支持按 FFmpeg 链顺序串联多个
  `equalizer=t=q` peaking 段。Dart 侧通过 `equalizerBands` 传递完整 band 列表，Android
  侧为每个 band 保留独立 RBJ biquad 状态；旧的单段字段仍保持兼容。多段 equalizer 的
  Dart 定向测试 22/22、Android `AudioNormalizationProcessorTest` 8/8 和 Release 构建
  均通过。其他 equalizer 类型、多响度阶段和任意复杂滤镜链仍明确不适配，当前多段
  equalizer 实现还需真机与 mpv 做听感、切换、后台、小窗和 PiP 对照。

- 2026-08-15 继续补齐 FFmpeg 音频滤镜：ExoPlayer 现在支持 peaking `equalizer=t=q` 以及
  独立的 `highshelf=`/`lowshelf=` 阶段，Dart 侧把类型随 `equalizerBands` 传入 Android，
  原生侧按 RBJ shelf/peaking 系数串联处理；`equalizer` 的其他宽度类型仍明确拒绝，旧的
  单段字段默认仍按 peaking 兼容。Dart 定向测试
  24/24、Android `AudioNormalizationProcessorTest` 11/11、定向 Dart 分析和 Android Release
  构建均通过。审计 APK 为
  `build/app/outputs/flutter-apk/pili++-2.1.8-2026081004-universal-release-exo-shelf-filter-audit-v2.apk`，
  SHA-256 `F4245A1398B63FFB5F067B1EB66C59F645D6D915108944C594365EA8B9D2AE5F`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、ABI
  和既有签名证书，审计包不更新发布基线。其他 equalizer 类型、多响度阶段和任意复杂滤镜链
  仍明确不适配，新增 shelf 与多段 equalizer 仍需真机与 mpv 做听感、切换、后台、小窗和 PiP
  对照。

- 2026-08-08 已恢复并确认固定构建工具链：Flutter/Dart 来自
  `D:\CodexToolchains\PiliPlus\flutter-sdk\flutter`，JDK 17 来自
  `D:\CodexToolchains\PiliPlus\jdk\jdk-17.0.19+10`，Android SDK 来自
  `D:\CodexToolchains\PiliPlus\android-sdk`。此前裸命令提示缺少 `dart`/`flutter`/`java`
  是当前终端未继承这些路径和 `JAVA_HOME`，不是工具链或仓库被删除。
- 本次高通滤镜修改的 Dart 定向测试已通过 17/17；`:app` 的
  `AudioNormalizationProcessorTest` 已通过 4/4。Gradle 输出仍有既有插件弃用和 SDK XML
  版本警告，但没有测试失败。全量 `flutter test --no-pub --concurrency=1` 已通过 50/50，
  新增高通实现相关文件定向 `dart analyze` 无问题。当前 Release 审计包已生成并通过
  `tool/verify_release.ps1 -AllowAlreadyDelivered`：
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-highpass-audit.apk`，
  versionCode `2026072808`，大小约 64.7 MiB，APK SHA-256 为
  `2796DDA63A4AA2CA626FBC6FE1A7C71758ED6F97E9DD060122F2918C12E1847B`，证书 SHA-256 为
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`；该包不更新正式
  发布基线，仍待真机听感和播放场景验证。

- ExoPlayer 适配批次 8 解码软解回退组已提交为
  `0c647b51ae60defc39c6171e5ca9387e43e596d2`：解码器/renderer 失败（Media3 decoder
  错误码）时，开启硬解的会话先自动重建为视频软件解码选择器并保留 position、
  playWhenReady、字幕和超分模式，提示“硬件解码失败，正在切换软件解码重试”；仅尝试
  一次，再次失败进入终态。网络/源错误重试逻辑不变；`PlaybackConfig` 在回退后显示
  `decoder=software`，终态诊断追加 `softwareVideoFallback: attempted`。
- 本组相关 Dart 文件已格式化并通过定向分析；完整 `dart analyze` 无 error/warning，保留
  37 条既有 info；完整 `flutter analyze` 仅因相同 37 条 info 返回非零；完整 `flutter test`
  共 48 项全部通过，新增解码失败触发一次软解回退、回退后不再重试、会话不活跃不重试、
  本地文件解码失败仍回退和网络重试不受影响测试；`:app` Kotlin 编译与单元测试通过；
  Android Release 构建通过。
- 解码回退审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-decoder-fallback-audit.apk`，
  嵌入提交 `0c647b51ae60defc39c6171e5ca9387e43e596d2`，构建时间
  `2026-08-03 13:48:47 +08:00`，大小 67,791,135 字节，SHA-256 为
  `209A2095E3680757F6A7F7F741759DD215CEF8F2DDB4D4F4709DDB28D1AEC9B6`。
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线；
  该包不更新正式发布基线。
- 本组待真机对照：构造硬件解码失败场景（不支持的编码/HDR/异常媒体），确认自动切软解
  后可继续播放、进度不丢、不黑屏，`PlaybackConfig` 变为 `decoder=software`；网络/源
  错误重试、直播和独立音频不受影响。完成该矩阵前只能标记为“实现完成、待真机验证”。

- ExoPlayer 适配批次 8 音频滤镜链组已提交为
  `531f2a854427de4ffccc6af711c01369e6aa6d84`：ExoPlayer 侧把 FFmpeg 滤镜链按 `,` 拆成
  受支持原语阶段（`volume=` 线性/dB 值、单个 `loudnorm=`、单个 `dynaudnorm=`）。音量阶段
  按“音量在后”语义折算进归一化目标（线性乘增益或折算目标响度），多个音量阶段相乘；
  链中任一未知滤镜（如 `highpass`）或多个响度归一化阶段整体回退，Toast 明确报出具体
  滤镜名。`volume=0` 直接映射为静音，避免目标响度取负无穷。mpv 路径保持原 FFmpeg 链。
- 本组 Dart 文件已格式化并通过定向分析；完整 `dart analyze` 无 error/warning，保留 37 条
  既有 info；完整 `flutter analyze` 仅因相同 37 条 info 返回非零；完整 `flutter test`
  共 43 项全部通过，新增纯音量链、dB 音量、音量折叠进 dynaudnorm/单遍/两遍 loudnorm、
  未知阶段精确报错、多响度阶段拒绝和畸形音量测试；Android Release 构建通过。
- 音频滤镜链审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-audio-filter-chain-audit.apk`，
  嵌入提交 `531f2a854427de4ffccc6af711c01369e6aa6d84`，构建时间
  `2026-08-03 13:31:47 +08:00`，大小 67,790,986 字节，SHA-256 为
  `A00834A02C86F0632E95DDB94B34F2DEC01A37006F5A1D2888396BD9BDA0EDCA`。
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线；
  该包不更新正式发布基线。
- 本组待真机对照：`volume=0.8,loudnorm=...`、`dynaudnorm=...,volume=-3dB` 等链与 mpv
  同参数听感对照，覆盖切换、后台、小窗和 PiP；含未知滤镜的链应显示具体滤镜名提示。
  完成该矩阵前只能标记为“实现完成、待真机验证”。

- ExoPlayer 适配批次 8 解码器隔离与动态音频组已提交为
  `3389f5a78beb1d7dca8f2ee1ece6ae7a78df0d74`：在安全缓冲隔离之上恢复 Media3 解码器
  选择。开启硬解时使用平台 MediaCodec 顺序并允许解码器回退；关闭时视频轨只选择软件
  MediaCodec，音频轨不受影响。`PlaybackConfig` 改为显示 `decoder=hardware/software`、
  `decoderFallback=true`，直播继续使用 Media3 默认低延迟 LoadControl。
- 单遍 `loudnorm`（无服务器测量值）和 `dynaudnorm` 预设/自定义参数已有 Media3 等价实现：
  原生 `AudioNormalizationProcessor` 新增分窗 RMS 自动增益（目标响度、最大增益、帧长、
  平滑系数）并在其后接真峰值限制器；输出缓冲显式沿用输入字节序，避免小端复用缓冲
  造成采样字节交换。链式及任意自定义 FFmpeg 滤镜仍无等价实现，保持明确未适配提示。
- 媒体源路由统一走 `resolveMediaUri`：本地裸路径转 `file://`，`http(s)://` 与
  `content://` 原样保留，本地视频/字幕路径和 SAF 内容 URI 不再混淆。
- 本组 Dart 文件已格式化并通过定向分析；完整 `dart analyze` 无 error/warning，保留 37 条
  既有 info；完整 `flutter analyze` 仅因相同 37 条 info 返回非零；完整 `flutter test`
  共 36 项全部通过；`:app` Kotlin 单元测试 14 项全部通过，覆盖动态归一化增益/限幅、
  禁用透传和 URI 路由；完整 Android Release 构建通过。
- 解码器/动态音频审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-decoder-dynamic-audio-audit.apk`，
  嵌入提交 `3389f5a78beb1d7dca8f2ee1ece6ae7a78df0d74`，构建时间
  `2026-08-03 10:49:16 +08:00`，大小 67,785,840 字节，SHA-256 为
  `55922DE3801947267B327ADFB696DDA47537DDF4907419ABE738F677AB5883A7`。
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线；
  该包不更新正式发布基线。
- 本组待真机对照：硬解开/关下的 AVC、HEVC、AV1、DASH、直播、本地文件、清晰度/分P、
  首帧、拖动、断网恢复、全屏、后台、小窗和 PiP，并核对 `PlaybackConfig` 的 decoder 字段；
  动态音量均衡与 mpv `dynaudnorm`/单遍 `loudnorm` 的听感对照，以及切换、后台、小窗和
  PiP 下的稳定性。完成该矩阵前只能标记为“实现完成、待真机验证”。

- ExoPlayer 适配批次 8 独立音频组已提交为
  `e1db70736210e0a30070c15ffd36d44a90ff8f8d`：Android 且启用 ExoPlayer 时，独立音频页
  不再创建 `media_kit Player`，而是通过现有 Media3 会话打开音频 URL；Android 关闭
  ExoPlayer 以及非 Android 平台仍保持原 mpv 路径。播放/暂停、跳转、倍速、播放器音量、
  起播位置、上下首/分段和循环模式均映射到公共音频页控制器，完成事件按 Media3 状态边沿
  只处理一次，释放后的旧事件不会触发连播。
- 独立音频已登记到后端中立的媒体通知和音频会话回调：首次自动播放先取得音频焦点；
  手动暂停、终止、失败和真正播完会释放焦点，连续播放保持同一会话；系统暂停/恢复、
  ducking、有线耳机拔出和蓝牙路由断开会控制当前独立音频播放器。媒体通知的播放、暂停、
  跳转和位置更新不再要求同时存在视频 `PlPlayerController`；多音频页按所有者恢复回调，
  旧页面销毁不会清掉新页面控制。
- 本组相关 Dart 文件已格式化，定向分析无问题；完整 `dart analyze` 无 error/warning，
  保留 37 条既有 info；完整 `flutter analyze` 完成仓库分析，仅因相同 37 条既有 info
  返回非零；完整 `flutter test --concurrency=1` 共 34 项全部通过，其中新增音频完成去重、
  释放后旧事件和 Media3 音频打开/控制参数测试；Android Release 构建通过。
- 独立音频审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-standalone-audio-audit.apk`，
  嵌入提交 `e1db70736210e0a30070c15ffd36d44a90ff8f8d`，构建时间
  `2026-08-02 20:14:34 +08:00`，大小 67,783,611 字节，SHA-256 为
  `DFEB317FAC607A2F91D539CB315B4215F674B421A2D8A700782CB55117DAA589`。
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线；
  该包不更新正式发布基线。
- 本组待真机对照：Android Media3 与 mpv 下的直接音频 URL、音频列表、UGC 分段、
  起播位置、播放/暂停、拖动、倍速、音量、上下首和全部循环模式；后台/息屏、通知、
  锁屏/耳机媒体键、来电或其他应用打断、ducking、有线耳机拔出、蓝牙断开；错误提示、
  关闭/重进和快速切歌。完成该矩阵前只能标记为“实现完成、待真机验证”。

- ExoPlayer 适配批次 8 在黑屏热修复后的第一项隔离恢复已提交为
  `c04a79fff718b4ce9024883d1bf898af43ddd7cc`：只恢复 Media3 点播缓冲设置，解码器仍固定
  使用已验证可播放的系统默认选择顺序，直播继续完整使用 Media3 默认 LoadControl。
  旧实现以默认约 8 MiB 为优先停止条件，可能在达到安全时间缓冲前停载；新实现对网络
  点播先保证最多 5 秒的安全最小时间，再由用户字节目标或最大缓冲时长停止，并保留同等
  时长的后向缓冲。极小值会被钳制到合法边界，本地媒体保留 Media3 本地时间阈值。
- 当时 `PlaybackConfig` 显示 `decoder=platform-default (requested=...)`，明确硬解开关
  尚未应用；该显示语义已由解码器隔离组（`3389f5a`）替换为 `decoder=hardware/software`。
- 本组 Dart 文件已格式化并通过定向分析；完整 `flutter analyze` 仅因 37 条既有 info
  返回非零，没有新增 error/warning；完整 `flutter test` 共 31 项全部通过；Android
  `testDebugUnitTest` 通过，包含 3 项新增的默认值、极小值和直播默认策略测试；完整
  Android Release 构建通过。
- 安全缓冲隔离审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-safe-buffer-isolation-audit.apk`，
  嵌入提交 `c04a79fff718b4ce9024883d1bf898af43ddd7cc`，构建时间
  `2026-08-02 16:59:28 +08:00`，大小 67,767,957 字节，SHA-256 为
  `98DC2B678746CA6C273EA625C0C87A4E06441B16FCE1CE0C83C67ABDDE49C836`。
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线；
  该包不更新正式发布基线。
- 2026-08-03 用户确认本组在 Samsung SM-S9180、Android 16 上不再黑屏，缓冲设置按用户
  反馈标记为真机验收通过；旧 P0 收敛到解码器配置，下一隔离组（`3389f5a`）已实现并
  生成审计包，仍待同机验证。

- 2026-08-02 用户在 Samsung SM-S9180、Android 16 上确认第八批第七组审计包
  (`cecd7d3`) 出现 P0 回归：所有视频均为黑屏，但播放器控制层可见、时间和进度继续
  前进。此前同一包的一条日志还记录了单个 bilivideo CDN URL 返回 HTTP 403；该条是
  独立的媒体源失败，不能解释进度已前进的全黑画面。
- 高置信回归范围是 `cecd7d3` 相对上一已知可播放版本新增的自定义 MediaCodec
  选择/回退和 `DefaultLoadControl`。热修复 `552e0bc` 先整体恢复 Media3 默认解码器与
  默认缓冲策略，以最小化继续全黑的风险；尚无真机结果证明具体是其中哪个子项，因此
  不把推断写成已确认根因。Flutter 仍传递用户偏好，但原生暂不应用，`PlaybackConfig`
  会显示 `compatibility defaults`，设置页也明确缓冲/硬解值当前仅作用于 mpv。
- 热修复同时避免在超分从未启用时调用 `setVideoEffects(emptyList())`，防止最新版为禁用
  模式无条件进入 Media3 effects 管线；只有旧媒体确实存在超分目标时才清理效果。原生
  新增 `onRenderedFirstFrame` 状态，播放信息 `VideoOutput` 显示
  `firstFrameRendered: true/false`，便于真机区分“解码器未输出首帧”和“首帧已输出但
  Flutter Texture 仍黑”。
- 热修复相关 Dart 文件已格式化，定向分析无问题；完整 `flutter analyze` 完成并仅因
  37 条既有 info 返回非零，没有新增 error/warning；完整 `flutter test` 共 31 项全部
  通过；Android Release Kotlin 编译和完整 Release 构建通过。
- 最终真机测试包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-black-video-hotfix-audit-v2.apk`，
  嵌入提交 `e0a3bffb16416ad489286c6ce8006622e2ffdcde`，构建时间
  `2026-08-02 15:31:34 +08:00`，大小 67,766,802 字节，SHA-256 为
  `BA6C5D09BDA28BC9C31B5F36D17EAAEEC8BB7211E6FC2BBE1F517DE9DF6B12B1`。
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线。
  首个未含准确设置说明的 `...black-video-hotfix-audit.apk` 已由 v2 替代，不作为测试
  目标；两者均为同 versionCode 审计包，不更新正式发布基线。
- 2026-08-02 用户覆盖安装 v2 后反馈视频画面“已经恢复了”，因此报告设备上的 P0 全黑
  回归已由该热修复解除。该反馈确认默认兼容路径能够恢复输出，但测试内容和完整场景
  矩阵未逐项报告，也不能区分原问题具体来自自定义 MediaCodec 还是 LoadControl。
  普通 UGC、PGC、DASH 独立音视频、短/长视频、清晰度与分P、全屏、后台、应用内小窗、
  系统 PiP 仍需扩展回归；缓冲/解码设置组仍为“兼容性回退、待重新实现”，所以第八批
  尚未结束。

- ExoPlayer 适配批次 8 第八组实现已提交为
  `720d161ef1812f3ce8481f57b280889753c364ef`：ExoPlayer 的番剧超分辨率入口不再复位
  为禁用或提示“适配尚未完成”。Android 新增同版本 `media3-effect`，在现有 Media3
  会话和 Flutter `Texture` 上实时应用 GPU Lanczos 重采样；“效率”最高约 1.5 倍并以
  1080p 为上限，“画质”最高 2 倍并以 4K 为上限，横屏、竖屏和方形视频均保持比例，
  已达到上限的源不会被反向降采样。
- 禁用/效率/画质可在播放中切换，不重新 `open` 媒体、不创建新会话、不跳转进度；
  换媒体时先清理旧目标尺寸，再按新源尺寸应用当前模式。截图继续读取同一处理后
  Texture。`SuperResolution` 播放信息会显示 disabled、等待尺寸、无需放大，或
  `source -> target` 的实际 Lanczos 尺寸；设置页区分 Media3 Lanczos 与 mpv Anime4K。
- 第八组相关 Dart 文件已格式化，定向分析无问题；完整 `dart analyze` 无 error/warning，
  当前工具链显示 38 条既有 info（其中包名提示重复显示）；完整 `flutter analyze` 完成
  仓库分析，仅因 37 条既有 info 返回非零；完整 `flutter test --concurrency=1` 共 31 项
  全部通过。Android Kotlin Debug 编译、4 项新增尺寸策略单元测试及 Release 构建通过。
- 第八组最终 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-media3-super-resolution-audit-v2.apk`，
  构建时间为 `2026-08-01 14:52:12 +08:00`，大小 67,767,758 字节，SHA-256 为
  `4D07B92A47B12400FA7C365D7A81309EC85AEFEBCDE05091524BC7B146E2CF8C`；三个 ABI 的
  `libapp.so` 均嵌入准确实现提交。`tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认
  applicationId、应用名、版本、universal ABI 和签名证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线。
  首个未注入 commit/buildTime 的 `...media3-super-resolution-audit.apk` 已由 v2 替代，
  不作为测试目标；两者都是审计包，不更新正式发布基线。
- 第八组仍待真机验证：禁用/效率/画质的即时切换、默认值恢复和播放状态/位置保持；
  480p/720p/1080p/4K、横屏/竖屏/方形、AVC/HEVC/AV1、SDR/HDR、DASH 独立音视频、
  本地文件、清晰度/分P切换；普通窗口、全屏、旋转、后台、应用内小窗、系统 PiP、
  截图；画质差异、帧率、GPU/内存、温度和耗电，并与 mpv 禁用/效率/画质逐项对照。
  本次 ADB server 探测未在时限内返回，未完成真机验证，因此只能标记为“实现完成、
  待真机验证”。
- 该超分 v2 审计包仍包含后来确认会导致报告设备全黑的 `cecd7d3` 播放构造，不再作为
  真机目标；全黑热修复 v2 已包含相同超分实现，后续超分验证统一使用热修复 v2。

- ExoPlayer 适配批次 8 第七组实现已提交为
  `cecd7d3c0fbd2c8470b19cbae208848d67f4744e`：Android Media3 会话创建时读取现有
  “开启硬解”“缓冲大小”和“缓冲时长”设置，不再静默忽略。开启硬解时使用平台
  MediaCodec 顺序并允许解码器回退；关闭时视频轨只选择软件 MediaCodec，音频轨不受
  影响。点播通过 `DefaultLoadControl` 同时应用缓冲时长、目标字节和后向保留；直播
  保持 Media3 默认低延迟时长策略，仅应用约为设置值双倍的总字节上限。
- 播放信息新增 `PlaybackConfig`，可直接核对 `decoder=hardware/software`、目标缓冲
  MiB 和点播缓冲毫秒数；直播显示 `bufferDuration=live-default`。设置页同步说明 Media3
  与 mpv 的实际缓冲语义，并把不能等价映射的“自动同步”“视频同步”“硬解模式”明确
  标成 mpv 专属；数值设置拒绝零、负数和非有限值。
- 第七组相关 Dart 文件已格式化；定向分析无问题；完整 `dart analyze` 无 error/warning，
  保留 37 条既有 info；完整 `flutter analyze` 完成仓库分析，仅因相同 37 条既有 info
  返回非零；完整 `flutter test --concurrency=1` 共 29 项全部通过；Android Kotlin Debug
  编译和 Release 构建通过。
- 第七组 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-buffer-decoder-audit.apk`，
  构建时间为 `2026-07-31 19:25:43 +08:00`，SHA-256 为
  `41EBB35F0FAC766786698DB244065C800AF5D4AE6BD77D438D41A976E3F1A6E5`；三个 ABI 的
  `libapp.so` 均嵌入准确实现提交。`tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认
  applicationId、应用名、版本、universal ABI 和签名证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线。
  该包是审计包，不更新正式发布基线。
- 第七组仍待真机验证：默认值与小/大缓冲值下的点播首开、拖动、连续播放、断网恢复和
  内存占用；直播延迟、稳定性、断网恢复及 `live-default` 时长策略；开启/关闭硬解后
  `PlaybackConfig` 与实际 Decoder 字段是否分别显示硬件/软件解码器；AVC、HEVC、AV1、
  DASH 独立音视频、本地文件、清晰度/分P切换、普通窗口、全屏、后台、小窗和 PiP；
  同时回归 mpv 缓冲、自动同步、视频同步和硬解模式。完成上述矩阵前只能标记为
  “实现完成、待真机验证”。
- 上述第七组结论已被 2026-08-02 的全黑真机反馈推翻；其审计 APK 不再作为验收目标，
  自定义缓冲/解码策略已在热修复中停用，后续必须在已恢复画面的基线上逐项重新引入和
  真机对照。

- ExoPlayer 适配批次 8 第六组实现已提交为
  `985d51a7fd270713af40af324e3aea9a2a1448f4`：Media3 bitmap cue 不再因 `text == null`
  被丢弃；Android 在有界单线程后台编码器中把 PGS/DVB 等位图编码为带透明度的 PNG，
  通过序号和媒体 generation 丢弃过期结果，并按字节内容去重，避免阻塞播放器主线程或
  重复推送相同画面。Flutter 保留 `size`、`bitmapHeight`、原始像素宽高、位置和锚点，
  位图相对完整视频视口渲染，不受用户文本字幕边距和拖动设置影响。
- Flutter 字幕层已实现 Media3 `vertical-rl`/`vertical-lr` 的分数和行号定位、列方向、
  自动换列、start/center/end 对齐、竖排 shear、OpenType `vert`/`vrt2` 字形及 Media3
  `HorizontalTextInVerticalContextSpan` 的 `text-combine-upright` 传递；文本、位图混合
  cue 仍按稳定 `zIndex` 顺序渲染。坏图片字节由 `errorBuilder` 安全忽略，不使播放器
  UI 抛异常。
- 本组相关 Dart 文件已格式化；定向分析无问题；完整 `dart analyze` 无 error/warning，
  保留 37 条既有 info；完整 `flutter analyze` 完成仓库分析，仅因相同 37 条既有 info
  返回非零；完整 `flutter test --concurrency=1` 共 27 项全部通过；Android Kotlin Debug
  编译和 Release 构建通过。
- 本组 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-subtitle-edge-audit.apk`，
  SHA-256 为
  `F84562BDC487741BB514ADB221648966EF836028ED4548E40921EDCDDC9BAFEE`；三个 ABI 的
  `libapp.so` 均嵌入准确实现提交。`tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认
  applicationId、应用名、版本、universal ABI 和签名证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线。
  该包是审计包，不更新正式发布基线。
- 第六组仍待真机验证：含 PGS/DVB bitmap cue 的本地/网络媒体，位图透明度、尺寸、位置、
  锚点和 cue 切换；WebVTT vertical-rl/vertical-lr、多列、Latin/数字、标点、组合直排和
  样式；字幕切换/关闭、跳转、普通窗口、全屏、旋转、应用内小窗、系统 PiP，以及 mpv
  等价媒体对照。完成该矩阵前只能标记为“实现完成、待真机验证”。

- ExoPlayer 适配批次 8 第五组实现已提交为
  `585bcfd5dd71ad520fb1a22e80d8ff6d0ad86a46`：Android 开启 Media3 时，直播不再被
  强制分流到 mpv；`isLive` 已从公共控制器贯穿 MethodChannel 到原生 `MediaRequest`，
  Media3 直播源使用 `LiveConfiguration` 和默认直播位置。首次打开、手动刷新、切
  清晰度/线路、切仅音频和自动重试均不 seek 到旧的绝对窗口位置；重试回到当前默认
  直播位置，原生与 Flutter 状态都不会把直播 `STATE_ENDED` 当作点播完成。
- 直播换清晰度、线路或仅音频时会继承当前播放/暂停意图；首次进入仍按原行为自动播放。
  设置文案和错误报告运行时说明已同步为 Android 视频（点播和直播）使用 Media3。
  现有 mpv `initLiveBuffer` 是字节缓存配置，不能无损映射到 Media3 的毫秒缓冲参数；本组
  使用 Media3 默认直播缓冲，未伪造等价参数，也没有静默回退 mpv。
- 定向 Dart 分析无问题，Media3 控制器测试新增直播通道参数覆盖；完整 `dart analyze`
  无 error/warning，保留 37 条既有 info；完整 `flutter analyze` 完成仓库分析，仅因相同
  37 条既有 info 返回非零；完整 `flutter test --concurrency=1` 共 22 项全部通过；Android
  Kotlin Debug 编译和 Release 构建通过。
- 最终 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-media3-live-audit-v2.apk`，
  SHA-256 为
  `C5BAB51DE83177F240B68FAD4C719B22963EED412CB792845B2210B632C6E465`；嵌入构建时间
  `2026-07-31 17:27:51 +08:00` 和准确实现提交。`tool/verify_release.ps1
  -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、universal ABI 和证书
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均符合基线。
  首个不含暂停切换保持修复的 `...media3-live-audit.apk` 已由 v2 替代，不作为测试目标；
  两者都是审计包，不更新发布基线。
- 第五组仍待真机验证：横屏/竖屏/方形直播的首播与尺寸，AVC/HEVC、HLS/FLV 等服务端
  实际可选组合，播放/暂停，清晰度、协议、格式、编码与 CDN 切换，暂停状态切换保持，
  仅音频开关，手动刷新，断网/恢复与重试耗尽，音频焦点、后台、媒体通知、应用内小窗、
  系统 PiP、前后台切换以及关闭/重进直播间。未完成上述真机矩阵前，只能标记为
  “Media3 直播实现完成、待真机验证”，不能宣称直播兼容已验收。

- ExoPlayer 适配批次 8 第四组实现已提交为
  `334297bbcdcc058245aa99a201297b2ae08900e4`：播放信息弹窗从视频头部组件抽成只接收
  `PlayerInfoEntry` 的公共组件；视频和直播传入 `PlPlayerController.playerInfoEntries`，
  视频 UI 不再 import `NativePlayer`，直播也不再为了复用弹窗依赖视频头部的底层播放器
  重载。
- 独立音频页的 mpv 信息、就绪状态和播放器输出音量操作收口到 `AudioController`；音频
  视图不再直接读取 `Player.state`/属性或调用 `pause`、`seek`、`setVolume`，也不再反向
  依赖视频头部组件。异常报告自定义字段由单一 `MPV Api Version` 改为 `Player Runtimes`，
  同时记录 Android 点播 Media3 与仍存在的 mpv API 版本。
- 第四组相关文件已格式化；定向分析无问题；完整 `dart analyze` 无 error/warning，保留
  37 条既有 info；完整 `flutter analyze` 完成仓库分析，仅因相同 37 条既有 info 返回
  非零；完整 `flutter test` 共 21 项全部通过；Android Release 构建明确成功，Gradle
  `assembleRelease` 耗时约 276 秒。
- 第四组 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-player-diagnostics-boundary-audit.apk`，
  SHA-256 为
  `3CB35E8D84E734DCC03BAFA32C97D85BBFCF62DF7E3414EB3246CA387DA8E5E2`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。该包从干净实现提交
  `334297bbcdcc058245aa99a201297b2ae08900e4` 构建，嵌入构建时间为
  `2026-07-31 16:49:59 +08:00`；它是审计包，不更新发布基线。
- 第四组仍待真机验证：Media3 点播、mpv 点播、Media3/mpv 直播和独立音频的播放信息字段、点击
  复制、播放器音量设置；音频页拖动进度以及跳转视频/MV/用户页前暂停；新产生的错误日志
  应显示 `Player Runtimes`。第四组提交当时直播仍使用 mpv；当前 Media3 直播验证应安装
  第五组 v2 审计包，独立音频仍使用 mpv。

- ExoPlayer 适配批次 8 第三组实现已提交为
  `7fcdd6d18b3f43588337d55c2d90ac8f56e3e0de`：`PlPlayerController` 新增后端中立的
  视频尺寸监听，Media3 事件和 mpv `size` 流都通过同一 API 分发真实尺寸并去重；切换
  媒体源会清空尺寸缓存。直播控制器不再直接订阅 mpv 播放器流，原有横竖屏判断和
  `isVertical` 回写语义保持不变。
- 直播头部菜单改用公共 `playerReady`、`playerInfoEntries` 和播放器输出音量 API，
  不再读取 mpv 对象、属性或直接调用其 `setVolume`。音频页同步桌面音量到现有视频
  播放器时也改走公共接口，并保留无条件向底层重新应用音量的原行为。
- 第三组相关文件已格式化；定向分析无问题；完整 `dart analyze` 无 error/warning，
  保留 37 条既有 info；完整 `flutter analyze` 完成仓库分析，仅因相同 37 条既有 info
  返回非零；完整 `flutter test` 共 21 项全部通过。Android Release 构建命令在工具
  120 秒等待上限处超时，但构建进程随后正常退出并于 `2026-07-31 16:29:54 +08:00`
  生成新 APK，产物校验通过。
- 第三组 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-live-boundary-audit.apk`，
  SHA-256 为
  `7D3C4B21ABDFBBEDEE19087FCB38D4029CC72154877BADCFC186A80C023516DA`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。该包从干净实现提交
  `7fcdd6d18b3f43588337d55c2d90ac8f56e3e0de` 构建，嵌入构建时间为
  `2026-07-31 16:26:56 +08:00`；它是审计包，不更新发布基线。
- 第三组仍待真机验证：直播横屏、竖屏和方形画面的方向识别，切清晰度/路线后尺寸更新，
  播放信息与播放器音量设置，以及桌面音频页与视频播放器的音量同步。本组仅清理直播
  UI/业务对 mpv 对象的直接依赖；第三组提交当时直播仍由 mpv 处理，当前 Media3 直播
  实现及测试目标以第五组 v2 审计包为准。

- ExoPlayer 适配批次 8 第二组实现已提交为
  `76a88888d460dffc89062536a6392edf5a325909`：主播放器与应用内小窗统一使用
  `PlPlayerSurface`，视频 UI 不再直接选择 Media3 Texture 或 mpv `SimpleVideo`，画面
  适配、比例覆盖、对齐、背景和水平/垂直翻转由适配组件内部保持原语义；未就绪或释放
  期间返回空画面，不会强制访问已释放控制器，也不会回退另一后端。
- 主播放器字幕层统一使用 `PlPlayerSubtitleLayer`，页面不再直接选择 Media3 cue renderer
  或 mpv 字幕 renderer，原有字幕样式、拖动、padding 回写和 Flutter 图层顺序保持不变。
  动态 WebP 的后端选择也收口到公共工厂与接口，`WebpPreset` 移至公共模型，Media3
  转换器不再为了复用接口而 import mpv 转换器。
- 批次 8 第二组相关文件已格式化；定向分析无问题；完整 `dart analyze` 无
  error/warning，保留 37 条既有 info；完整 `flutter analyze` 完成仓库分析，仅因相同
  37 条既有 info 返回非零；完整 `flutter test` 共 21 项全部通过；Android Release
  构建通过。
- 第二组 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-rendering-boundary-audit.apk`，
  SHA-256 为
  `F01609EBA9F6F96FB111A21B22A74E922B77CDC3FA8F3B77B58196C32126F6C2`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。该包从干净实现提交 `76a88888d460dffc89062536a6392edf5a325909`
  构建，构建时间为 `2026-07-31 15:05:41 +08:00`；它是审计包，不更新发布基线。
- 第二组仍待真机对照：mpv/Media3 普通窗口、全屏、旋转、全部画面适配/比例、双向翻转、
  字幕显示与拖动、应用内小窗缩小/恢复，以及动态 WebP 的开始、进度、取消和保存。直播
  仍由 mpv 处理，也需回归画面渲染；本组不代表 Media3 已支持直播或可删除 mpv。

- ExoPlayer 适配批次 8 首组实现已提交为
  `e93a97c20a35590052296d3ee20d16207675129b`：视频详情页的 B 站/外部字幕加载与关闭
  已收口到 `PlPlayerController.setApplicationSubtitle`，页面不再直接分支调用
  ExoPlayer 或 mpv 控制器；内联字幕、文件字幕、语言、标签和 MIME 的差异由公共控制器
  内部适配。视频页 SponsorBlock 也不再为满足混入接口而暴露 mpv 播放器对象，继续使用
  公共的 ready、playing 和 position listener；音频页保留原有默认实现。
- Android 设置文案已去除“实验性”和“关闭后完全恢复 mpv”，改为准确说明点播使用
  Android Media3、直播暂由兼容播放器处理；未隐藏直播仍未适配这一事实。
- 批次 8 相关文件已格式化；完整 `dart analyze` 无 error/warning，保留 37 条既有 info；
  完整 `flutter analyze` 完成仓库分析，仅因相同 37 条既有 info 返回非零；完整
  `flutter test` 共 21 项全部通过；Android Release 构建通过。
- 批次 8 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-backend-cleanup-audit-v2.apk`，
  SHA-256 为
  `33BA77BEFBC7748AF534747DD6162E4D7EE40913AC339C8D80D53CAF4A218717`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。该包从干净实现提交 `e93a97c20a35590052296d3ee20d16207675129b`
  构建并写入准确 commit hash，构建时间为 `2026-07-31 11:14:02 +08:00`；首个审计文件
  的构建时间参数偏快 8 小时，已由 v2 替代且不作为测试目标。它是审计包，不更新发布
  基线。
- 批次 8 首组仍待真机对照：mpv/Media3 下关闭字幕、B 站字幕、外部 VTT/SRT/ASS/SSA
  的加载与互切，以及播放、暂停、跳转时 SponsorBlock 位置监听。首组提交当时的直播、
  bitmap cue/竖排字幕和 Media3 超分缺口已分别在后续第五、第六和第八组实现但待真机
  验收；未适配音频滤镜和剩余生命周期边界仍是明确缺口。当前仍不能宣称已完整移除 mpv。

- ExoPlayer 适配批次 7 实现已提交为
  `51909790a75063e630d24afc2541d5baf83eb532`：普通截图和评论区视频截图通过既有公共
  `captureFrame` API 调用 Android `PixelCopy`，从 Flutter Texture 对应的 Media3
  `Surface` 复制当前视频帧；原生侧校正视频旋转、像素宽高比和 Flutter 水平/垂直翻转，
  返回 PNG 数据给既有 `ui.Image` 保存流程。截图只包含视频画面，不包含 Flutter 控件、
  弹幕、字幕或其他覆盖层；ExoPlayer 不回退 mpv。
- 动态 WebP 保留既有区间、画质预设、进度、取消、保存和播放状态恢复 UI。ExoPlayer
  使用独立 `MediaMetadataRetriever` 工作线程按区间采样视频 URL，不 seek、重载或重建
  当前播放会话；Android 将逐帧 WebP 封装为 RIFF `VP8X`/`ANIM`/`ANMF` 动画，最多均匀
  采样 600 帧。每个任务写独立临时文件，完整封装后才发布目标文件，取消或失败会删除
  不完整临时文件；mpv 继续使用原 `MpvConvertWebp` 路径。
- 批次 7 相关 Dart 文件已格式化；定向 `dart analyze` 和完整 `dart analyze` 均无
  error/warning，完整分析保留 37 条既有 info；完整 `flutter test` 共 20 项全部通过。
  Android WebP 容器 JVM 单元测试通过，覆盖 RIFF 长度、动画标志、画布、帧块、时长和
  奇数填充；Android Debug 编译和 Release 构建通过。使用可写的项目工具链运行完整
  `flutter analyze` 已进入并完成仓库分析，仅因同样 37 条既有 info 返回非零，不再是
  先前 Flutter SDK 缺失 iOS 资源的阻断结果。
- 批次 7 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch7-capture-audit.apk`，
  SHA-256 为
  `226B54B942B799B45AD114725B74F5A9A4CC469B0A03CDB6D8643153E7460A77`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。该包从干净实现提交
  `51909790a75063e630d24afc2541d5baf83eb532` 构建并显式写入版本、构建时间和 commit
  hash；它不是新版本交付，不更新发布基线。
- 2026-07-30 用户在 Samsung SM-S9180、Android 16 / SDK 36 上使用上述审计包触发普通
  截图失败：`PixelCopy failed with code 3`。代码 3 为 `ERROR_SOURCE_NO_DATA`，表示截图
  时 Flutter Texture 对应的 Surface 没有可复制的排队帧；该问题发生在实现提交
  `51909790a75063e630d24afc2541d5baf83eb532`，不是 Flutter 保存图片流程错误。
- 修复提交 `99f4a11450e6bf059e12495322f7ffc6461f7358` 保留 `PixelCopy` 快路径，对
  `ERROR_SOURCE_NO_DATA` 短延迟重试两次；仍无帧时使用独立 `MediaMetadataRetriever`
  按截图请求瞬间记录的视频 URL、请求头和播放位置取帧。兜底读取媒体源旋转元数据，
  继续校正像素宽高比和 Flutter 水平/垂直翻转，不 seek、暂停、重载或重建当前
  ExoPlayer 会话，也不回退 mpv；两条路径都失败时会同时保留 PixelCopy 与媒体源诊断。
- 修复后 Kotlin Debug 编译通过；完整 `dart analyze` 无 error/warning，保留 37 条既有
  info；完整 `flutter test` 共 20 项全部通过；Android JVM 单元测试和 Release 构建通过。
  新审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch7-capture-fix-audit.apk`，
  SHA-256 为
  `E5158B5EEF45D2C0481709C860E2240F9B800C69D054A53821E92EB303CEB24E`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和证书均符合基线。该包从干净实现提交 `99f4a11450e6bf059e12495322f7ffc6461f7358`
  构建并写入准确 commit hash；它是替换审计包，不更新发布基线。
- 用户在同一 Samsung Android 16 设备使用上述替换包复测后，错误已不再是 PixelCopy，
  而是在 `PlPlayerController.captureFrame` 将原生 PNG 解码为 `ui.Image` 时出现
  “native peer has been collected”。这确认原生 `ERROR_SOURCE_NO_DATA` 恢复已返回 PNG；
  新问题来自 Flutter SDK 的 `instantiateImageCodecFromBuffer` 会在 codec 创建后自动释放
  `ImmutableBuffer`，而应用 `finally` 又调用一次 `buffer.dispose()`，形成二次释放。
- 修复提交 `4085cc8ec0d838318fbc64c40b3e8361a9ae149d` 将截图解码收敛到公共 helper，
  改用 `instantiateImageCodec(Uint8List)` 并只释放 codec；返回的 `ui.Image` 仍由普通截图
  预览和评论区截图调用点在使用结束后释放。新增真实 Flutter 引擎回归测试：解码 PNG、
  释放 codec 后继续读取并编码返回图像，覆盖本次 native peer 生命周期错误。
- 定向分析通过；完整 `dart analyze` 无 error/warning，保留 37 条既有 info；完整
  `flutter test` 共 21 项全部通过；Android Release 构建通过。第二个替换审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch7-capture-lifetime-fix-audit.apk`，
  SHA-256 为
  `FC78284B7B2DCA6B1038C2E547C103A8A53767919E69DFA23EF4E3F2508D221E`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和证书均符合基线。该包从干净实现提交 `4085cc8ec0d838318fbc64c40b3e8361a9ae149d`
  构建并写入准确 commit hash；它是审计包，不更新发布基线。
- 当前 ADB 设备列表为空。批次 7 仍待真机对照：播放与暂停时的普通截图、评论区截图、
  横竖屏视频、像素宽高比、水平/垂直翻转、全屏和应用内小窗；动态 WebP 需覆盖短/长
  区间、不同画质预设、进度、取消、保存、失败清理、重复转换，以及转换期间当前播放
  会话位置、缓冲和播放/暂停状态不变。真机对照通过前不标记完整兼容。

- ExoPlayer 适配批次 6 实现已提交为
  `91841cbab07b46561340b2809617a0fdd082c3b7`：Android 原生层将 Media3 错误码、名称、
  分类、阶段、可恢复性、HTTP 状态、渲染器、音视频解码器、错误位置、播放意图、媒体源
  和完整 cause chain 结构化回传；URI 与异常消息中的查询参数/片段均会脱敏，后续错误
  报告不再只有 `ExoPlayer: Source error` 和空堆栈。旧版本已生成的历史日志不追溯修改。
- 批次 6 复用现有 `retryCount`/`retryDelay`：仅连接失败、超时、未分类网络 I/O、HTTP
  408/429/5xx 自动重试，延迟按尝试次数递增；401/403/404、本地文件、解码/DRM/不支持
  格式、失效会话和次数耗尽不重试。重试复用同一 ExoPlayer 会话，恢复错误时的位置与
  播放/暂停意图，并在恢复期间忽略 Media3 错误后产生的非播放状态覆盖。
- 新媒体、手动重载、恢复到 READY 或播放器释放都会取消重试计时。最终失败会退出缓冲、
  PiP 自动进入、唤醒锁和音频会话，显示按错误类型区分的用户提示，并以非空诊断堆栈
  上报一次；重复终态错误不会重复上报。
- 批次 6 相关文件已格式化；完整 `dart analyze` 无 error/warning，保留 37 条既有 info；
  完整 `flutter test` 共 18 项全部通过；Android Debug 和 Release 构建均通过。
  `flutter analyze` 仍在仓库分析前被工作区 Flutter SDK 缺失的 iOS 集成测试资源中断。
- 批次 6 最终 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch6-error-recovery-audit-v2.apk`，
  SHA-256 为
  `8479DAF896D0E1EBF3D1C704348556251E20684E42B195B418E01F9FC0ED1A59`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。最终 v2 包从干净 HEAD
  `bdcedd590f7d412fff658826c7c4df33d6cfd549` 构建并显式写入版本、构建时间和 commit
  hash；该包不是新版本交付，不更新发布基线。
- 批次 6 仍待真机对照：播放中/暂停时断网和恢复、连接超时、HTTP 5xx 自动恢复、重试
  耗尽、401/403/404、解码失败，以及普通窗口、全屏、后台、应用内小窗和系统 PiP。

- ExoPlayer 适配批次 5 实现已提交为
  `c3dc337f2c9ff6b8c77fb154bbb16e4235177935`：公共轨道模型可区分应用加载字幕与媒体
  内置文本轨；视频设置菜单仅在存在真实内置字幕时显示“内置字幕轨道”，不会重复列出
  B 站或外部文件字幕；mpv/ExoPlayer 共用关闭和指定内置轨选择流程。
- 批次 5 同步修正字幕互切语义：选择内置轨后，既有字幕控件显示关闭；再次选择 B 站
  或外部字幕时，Media3 清除旧的文本轨覆盖并启用应用字幕；关闭字幕会禁用整个文本轨
  类型，避免内置字幕静默重新出现。切换指定内置轨本身不重建音视频媒体源或跳转进度。
- 批次 5 相关文件已格式化；完整 `dart analyze` 无 error/warning，保留 37 条既有 info；
  完整 `flutter test` 共 16 项全部通过；Android Debug 和 Release 构建均通过。
  `flutter analyze` 仍在仓库分析前被工作区 Flutter SDK 缺失的 iOS 集成测试资源中断。
- 批次 5 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch5-embedded-subtitle-audit-v2.apk`，
  SHA-256 为
  `7930D4A39F33AC74F4D958A06316C0D187948DAB43EC0A1B464F7EF25062ABB2`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。最终 v2 包从干净 HEAD
  `7aec0b81463a6269dd593bdab86d6adc973209d9` 构建并显式写入版本、构建时间和 commit
  hash；该包不是新版本交付，不更新发布基线。
- 批次 5 仍待真机对照：含多个内置文本轨的本地/网络媒体，逐轨选择与关闭，内置字幕
  和 B 站/外部字幕双向切换，以及播放/暂停、跳转、全屏、后台、应用内小窗和系统 PiP。
- ExoPlayer 适配批次 4 实现已提交为
  `54babbf8f08577771fb600f0f6e63d039c5b6ead`：复用 mpv 当前的 loudnorm 参数生成和
  B 站服务器 `voiceBalance` 测量数据，将两遍 loudnorm 的目标增益及真峰值限制传入
  Media3；Android `DefaultAudioSink` 接入 16-bit/float PCM 处理器，声道联动、超峰
  立即降增益并在 80ms 内平滑恢复，不改变用户音量、静音和音频焦点增益。
- 批次 4 对 `dynaudnorm`、缺少服务器测量值的单遍 loudnorm、链式及任意自定义
  FFmpeg 滤镜不虚标兼容：ExoPlayer 保持原始音频并提示一次，相关能力继续列为缺口。
- 批次 4 全部相关 Dart 文件通过格式检查；完整 `dart analyze` 无 error/warning，
  保留 37 条既有 info；完整 `flutter test` 共 15 项全部通过，其中新增 6 项归一化
  参数和边界测试；Android Debug 和 Release 构建均通过。`flutter analyze` 仍在仓库
  分析前被工作区 Flutter SDK 缺失的 iOS 集成测试资源中断。
- 批次 4 最终 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch4-loudness-audit-v2.apk`，
  SHA-256 为
  `6511FB1003B4F7AB8DACBD67F99A152DD2A05162ADBA6F1EF581B3F821665381`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。该包不是新版本交付，不更新发布基线。
- 批次 4 仍待真机对照：同一含服务器测量参数的视频在 mpv/ExoPlayer 下的安静与
  已较响素材、扬声器/耳机、播放暂停、跳转、切清晰度/分P、后台、应用内小窗和
  系统 PiP；未完成上述对照前不得把响度归一化整体标记为完成。
- ExoPlayer 适配批次 3 实现已提交为
  `c02aea597c6c41184261a8e32aac401b145e39b6`：Media3 音视频/文本轨道的枚举、选中
  状态、支持状态和格式参数已回传 Flutter；公共控制器支持自动、关闭和指定轨道；
  视频设置菜单为 mpv 与 ExoPlayer 共用视频/音频轨道选择器；ExoPlayer 的“播放
  信息”入口不再隐藏，并显示媒体源、格式、当前轨道、倍速、音量及音视频解码器。
  “听视频”改为禁用视频轨，不再重建媒体源、跳转进度或丢失缓冲。
- 批次 3 全部相关文件通过格式检查；完整 `dart analyze` 无 error/warning，保留
  37 条既有 info；完整 `flutter test` 共 9 项全部通过；Android Debug 和 Release
  构建均通过。`flutter analyze` 仍在仓库分析前被工作区 Flutter SDK 缺失的 iOS
  集成测试资源中断。
- 批次 3 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch3-tracks-audit.apk`，
  SHA-256 为
  `60EF362B8B689C2EC3FE63A6BF3EFB498FE129A3C7A7126A2869DC668229894E`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。该包不是新版本交付，不更新发布基线。
- 批次 3 仍待真机对照：DASH 独立音视频、本地多轨文件、自动/关闭/指定轨道、
  播放与暂停状态下切换“听视频”、音频模式后重载再恢复画面，以及播放信息各字段。
  内置文本轨已由原生/公共 API 枚举并显示在信息面板，但本批未新增其独立选择入口。
- ExoPlayer 适配批次 2 实现已提交为
  `2cd76abe776a45d7d89dc8b9736418fcf8fea21e`：字幕源不再只记录数据/路径，而是保留
  VTT、SRT、ASS/SSA 格式；Flutter→MethodChannel→Media3 使用对应 MIME；Media3
  active cue 不再压成单一纯文本，而是把对齐、位置、锚点、尺寸、窗口色、字号、
  倾斜、层级及常用文本 span 回传给 Flutter Texture 字幕层渲染。外部字幕选择器
  支持大小写不敏感的 `.vtt/.srt/.ass/.ssa`，B 站 JSON 字幕仍转换为 VTT。
- 批次 2 全部相关文件通过格式检查；完整 `dart analyze` 无 error/warning，保留
  37 条既有 info；完整 `flutter test` 共 7 项全部通过。`flutter analyze` 仍在仓库
  分析前被工作区 Flutter SDK 缺失的 iOS 集成测试资源中断。
- 批次 2 Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch2-subtitle-audit-v2.apk`，
  SHA-256 为
  `DB1DAAD7FEA752B8A0B1DD62CD76EA9A91C5D964258BC7A4C38E1CDDCB9E20A9`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。该包不是新版本交付，不更新发布基线。
- 用户已反馈批次 2 当前真机流程未见问题。批次 2 提交时尚未桥接的 Media3 bitmap cue
  和 Flutter 竖排布局已在批次 8 第六组实现，但仍待实际媒体真机验收。
- ExoPlayer 适配批次 1 实现已提交为
  `ad34b69315e54a1ebfb7890262a29d7d2734604c`：播放器音量入口改走公共控制器并同时
  支持 mpv 与 ExoPlayer；普通截图和评论区视频截图改用可区分成功、未适配和失败的
  公共结果；
  超分辨率两个入口改走公共控制器，ExoPlayer 下保持关闭并给出明确迁移提示，不再
  隐藏设置入口或进入 mpv 空对象路径。批次 1 提交时 Media3 原生截图和超分效果仍是
  后续缺口；二者现已分别实现但仍待真机验收。
- 本批相关文件通过格式检查；完整 `dart analyze` 无 error/warning，保留 37 条既有
  info；新增的 3 个公共功能结果契约测试全部通过。`flutter analyze` 仍在仓库分析前
  被工作区 Flutter SDK 缺失的 iOS 集成测试资源中断。
- Android Release 审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch1-audit.apk`，
  SHA-256 为
  `35F2FA1E9F3889860FDD354F0E53BDE7A307BF39085414DF2410C50735003802`；
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId、应用名、版本、
  universal ABI 和签名证书均符合基线。该包不是新版本交付，不更新发布基线。
- 用户已反馈批次 1 当前真机流程未见问题。Media3 原生截图和超分效果仍未实现，
  本次反馈只确认现有入口及明确提示未观察到异常。
- 小窗生命周期修复的三个相关 Dart 文件已通过 `dart format` 和定向
  `dart analyze`；Android Release 构建及
  `tool/verify_release.ps1 -AllowAlreadyDelivered` 审计已通过。审计包位于
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-mini-lifecycle-audit.apk`，
  SHA-256 为
  `98BFAF6395AD25E99DA15F1E01558579FE0BF6E227919A597BBF6DE14C71ACE9`。
  完整 `flutter analyze` 仍被 Flutter SDK 缺失 iOS 测试资源中断；
- 互动视频和本地文件等尚未覆盖类型的小窗恢复参数；
- 不同 Android 版本、芯片、折叠屏以及尚未覆盖的息屏/亮屏和进程生命周期边界；
- 本次上游同步涉及的视频卡片、UGC 分P列表、动态/评论文本选择和滚动。

## ExoPlayer 已知未闭环项

- Media3 超分辨率实时效果已实现并通过自动化构建/测试；用户已在真机切换三档并接受
  当前无缝、肉眼差异不明显的 Lanczos 行为为“功能有效”。不同分辨率、编码、HDR、
  画面方向、GPU 性能和播放器生命周期仍可随相应场景扩展回归，但不再单独阻塞基础
  超分功能验收。
- 服务器提供测量参数的两遍 `loudnorm`、单遍 `loudnorm`、`dynaudnorm`、`volume=`、单个
  `highpass`、单个 `lowpass`、peaking `equalizer` 以及独立 `highshelf`/`lowshelf` 已完成
  实现；此前已验收的单段滤镜保持真机结论，多段与新增 shelf 类型仍待本轮真机对照。其他
  equalizer 宽度类型、多响度阶段及任意复杂链仍无
  类型、多个响度阶段及任意复杂链仍无 Media3 等价实现，Toast 会指明具体未适配滤镜名。
- 网络/源错误自动恢复与诊断已进入待真机验证；解码错误已实现一次硬解→软解自动回退
  重试（`0c647b5`），仍需真机覆盖具体硬件解码失败、回退后可播与终态诊断场景。
- Media3 自定义缓冲大小和点播缓冲时长按“时间安全阈值优先”重新实现，Samsung Android 16
  真机已确认不再黑屏；硬解开关已在 `3389f5a` 恢复生效，仍待真机对照 AVC/HEVC/AV1/
  DASH/直播/本地文件。mpv 自动同步、视频同步和具体硬解模式没有 Media3 一一对应能力。
- 进程重建和更多边缘生命周期仍需继续闭环。

## 下一步

- 优先补齐剩余 Media3 无等价实现的复杂 FFmpeg 音频滤镜（其他 equalizer 类型、多响度阶段
  和任意复杂链）；不得隐藏入口或静默回退 mpv。
- 完成网络/源错误恢复、真实硬解失败后的软件回退、硬解开关和缓冲设置的剩余真机矩阵。
- 继续闭环进程重建、互动视频/本地文件小窗恢复，以及折叠屏、不同芯片和息屏/亮屏等
  生命周期边界。
- 清理仓库既有 `flutter analyze` info，并在下次上游同步前先 fetch、审查重叠文件后再合并。
### 2026-08-08 lowpass audio-filter mapping

The ExoPlayer audio normalization bridge now supports one `lowpass=f=<Hz>` stage
alongside the existing `highpass`, volume, `loudnorm`, and `dynaudnorm` mappings.
Malformed or repeated low-pass stages remain explicit unsupported cases. Dart
resolution tests pass 19/19 and `:app:testDebugUnitTest --tests
com.example.piliplus.AudioNormalizationProcessorTest` passes. Android Release
build and `tool/verify_release.ps1 -AllowAlreadyDelivered` pass.

Audit APK:
`build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch9-lowpass-audit.apk`
SHA-256: `39A0797D8A888D46A06AC9A8ED8D1D26D46820951F5A39A2555240FDC0634614`.
The APK uses certificate SHA-256
`775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`.
Real-device listening comparison against MPV remains pending; this audit APK
does not update the formal release baseline.

### 2026-08-08 equalizer audio-filter mapping

ExoPlayer now maps one peaking FFmpeg equalizer stage with
`f=<Hz>:t=q:w=<Q>:g=<dB>` to a per-channel Media3 PCM RBJ biquad. Dart and
Android tests cover valid parameters, malformed/repeated stages, unsupported
equalizer types, gain limiting, and tone boost. Other equalizer types and
arbitrary filter chains remain unsupported; real-device listening comparison
against MPV is still required.

Final verification for this source state: the complete Flutter test suite
passes 54/54, the targeted Android `AudioNormalizationProcessorTest` passes,
targeted Dart analysis reports no issues, and Android Release builds
successfully. The final audit APK is
`build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch11-equalizer-audit.apk`
with SHA-256
`08C8BAA5AB8674BA12F52801148C85497D0C3E85AFBFE772235137EE5E029C23`.
`tool/verify_release.ps1 -AllowAlreadyDelivered` confirms application ID,
label, version, universal ABI, and certificate SHA-256
`775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`.
The earlier batch10 APK predates the complete-parameter validation and is not
the final audit artifact. The formal release baseline remains unchanged.

### 2026-08-09 播放页下拉手势

- 当前分支仍为 `main`，本批开始时 HEAD 为
  `2f512df47b308938164595ac3ba0f514fe53a5ac`；工作区原有音频滤镜、Android 单测和
  两份状态文档的未提交修改均保留，本批没有重置或覆盖这些修改。
- 第一版审计包经用户真机反馈确认存在三项缺陷：视频下拉未进入小窗；竖屏全屏没有动画；
  详情内容未在顶部时下拉也会触发竖屏全屏，破坏长详情页的正常滚动。第一版 APK 已废弃，
  不再作为测试目标。
- 用户第二次真机反馈确认 v3 仍未解决两个问题：视频区域下拉仍不进入小窗，详情页仍会在
  非顶部误触竖屏全屏。v3 及更早审计包全部废弃。
- v4 将原始指针监听直接挂到实际视频组件，不再通过详情页根层坐标推断命中区域。窗口态视频
  下拉达到 48 logical pixels 后，先通过既有服务保留播放器并建立小窗会话，再退出详情页；
  继续复用同一播放器、Flutter Texture、进度和缩小动画。
- 非视频区域不再使用页面级指针位移。只有 Android 垂直滚动系统实际发出向下顶部越界
  `OverscrollNotification`，且详情外层滚动位置此时确实位于最小值时，才累计下拉距离；
  回顶之前的正常滚动、惯性滚动、中部/底部下拉均不触发。累计达到 72 logical pixels 后，
  播放器高度跟手展开并用约 260 ms 补间完成竖屏全屏，不修改“默认全屏方向”。
- 按用户最终决定，评论标签整体禁用竖屏全屏下拉，包括标签栏与评论列表；评论滚动和
  下拉刷新保持原行为。短距离、向上和偏横向动作也不会触发上述两条手势。
- 新增真实顶部越界判定测试后，完整 `flutter test` 通过 59/59；本批 Dart 文件定向
  `dart analyze` 无问题，`git diff --check` 通过，Android Release 构建通过。
- v4 审计 APK：
  `build/app/outputs/flutter-apk/pili++-2.1.4-2026080901-universal-release-youtube-pull-gesture-audit-v4.apk`；
  applicationId `com.shudo.plusplus`、应用名 `pili++`、versionName `2.1.4`、versionCode
  `2026080901`、universal ABI 和证书 SHA-256
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均通过
  `tool/verify_release.ps1`；APK SHA-256 为
  `3D4E93956676F6E185C3B29937CEBD06855CD2605F5FAAF32AA7BDAEF2F2526C`。它由当前完整工作区
  构建，也包含本批开始前已存在的未提交音频滤镜修改，不是只含下拉手势的隔离包。
- 待 Android 真机分别在 mpv 与 ExoPlayer 下验证：播放/暂停状态的视频下拉进入小窗、
  小窗开关关闭时保持播放器原手势、详情顶部跟手动画及竖屏全屏、详情中部/底部不误触发、
  评论标签全部区域正常滚动/刷新、横向进度与纵向亮度/音量手势无回归，以及小窗恢复后的
  再次下拉。
- 2026-08-10 用户确认 v4 的视频下拉小窗和详情顶部过度滚动进入竖屏全屏已经可用，并要求
  补齐反向动作。v5 在未锁定的竖屏全屏视频区域识别向上滑动：播放器高度随手指从全屏向
  普通详情页收缩，达到 72 logical pixels 后按剩余进度补完 260 ms 完整曲线并显式保持竖屏
  退出全屏；未达到阈值则用 160 ms 回弹到全屏。多指、向下、短距离和偏横向动作不触发。
- 新增向上方向判定测试后，完整 `flutter test` 通过 61/61，定向 `dart analyze` 无问题，
  `git diff --check` 与 Android Release 构建通过。v5 APK 为
  `build/app/outputs/flutter-apk/pili++-2.1.5-2026081001-universal-release-portrait-fullscreen-swipe-up-v5.apk`，
  applicationId `com.shudo.plusplus`、应用名 `pili++`、versionName `2.1.5`、versionCode
  `2026081001`、universal ABI 和证书 SHA-256
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均通过
  `tool/verify_release.ps1`；APK SHA-256 为
  `7BF081F42736EDF1B8E4B814D8F5638C40CCE7D43065B268BE8C3E38484C61FA`。仍待真机确认上滑
  跟手、达阈值退出、短滑回弹、锁定状态不触发，以及 mpv/ExoPlayer 一致性。

### 2026-08-10 上游刷新布局语义树修复

- Samsung SM-S9180、Android 16 在上游同步后的 `2.1.5+2026081001` 报告
  `RenderSemanticsAnnotations was not laid out`、
  `_RenderObjectSemantics._updateSemanticsNodeGeometry` 空值异常和随后出现的
  `Future already completed`。堆栈位于 Flutter semantics/首帧阶段，没有 Media3 原生帧。
- 根因是上游新增 `RefreshLayout` 在 scale/position 为 0 时跳过刷新指示器布局，但
  semantics 仍会遍历该 slotted child 并读取 `semanticBounds`。修复后隐藏指示器也获得
  `0x0` 合法布局，动画监听通过 `markNeedsLayout` 进入正常布局阶段，不再在帧外直接调用
  child layout；刷新位移由 `RefreshIndicator` 显式传入，消除 RenderObject 的隐式 Hive 依赖。
- 新增启用 semantics 的组件回归测试，覆盖隐藏状态语义刷新和展开到 `49x49` 两条路径；
  定向测试和全量 Flutter 测试均通过，后者为 62/62。定向 Dart 分析无问题。
- 修复交付版本提升为 `2.1.6+2026081002`。仍需在报告问题的 Samsung Android 16 真机
  覆盖视频详情页初次打开、详情滚动、顶部下拉进入竖屏全屏、评论下拉刷新、小窗恢复、
  返回/重进及 TalkBack 开关场景，确认不再产生上述 semantics/首帧异常。
- Release APK 位于
  `build/app/outputs/flutter-apk/pili++-2.1.6-2026081002-universal-release-refresh-semantics-hotfix.apk`；
  `tool/verify_release.ps1` 已确认 applicationId `com.shudo.plusplus`、应用名 `pili++`、
  universal ABI、版本和证书指纹，APK SHA-256 为
  `4685A4A3BCA1D55EF299A529703A1684DB4DDE2946D34DC6DE988C8BBA45E4AF`。

### 2026-08-10 YouTube 下拉动画流畅度优化

- 对用户提供的两段 Samsung Android 16 录屏按 60 fps 采样详情面板边界。pili++ 第一段
  下拉约 0.7 秒只有 10 个有效位置，最长连续约 267 ms 停在同一位置；YouTube 对照段有
  31 个有效位置，最长停顿约 50 ms。源码对应问题是 `_pagePullAnimation` 每帧
  `setState`，同时改变 `ExtendedNestedScrollView` 的 header/pinned 高度，导致播放器、
  详情标签和内容树反复 rebuild/layout；达到 72 logical pixels 时还会在手指未释放前直接
  补完整段动画，造成位置突跳。
- 新实现保持嵌套滚动页和 header 的正常布局尺寸不变。播放器与详情面板分别由独立
  `AnimatedBuilder` 驱动，播放器外层仅扩展黑色合成区域并移动已有 `RepaintBoundary`，
  详情页缓存为独立重绘边界后只做 `Transform.translate`；动画 tick 不再调用页面级
  `setState`，也不再逐帧修改 sliver extent。
- 下拉/上滑进度按可用行程与实际指针距离一比一映射。详情顶部下拉只在
  `ScrollEndNotification` 松手时按 72 logical pixels 阈值决定进入竖屏全屏或回弹；竖屏
  全屏上滑退出同样在抬手时判定。视频区域下拉进入应用内小窗仍保留原 48 logical pixels
  触发语义，评论标签禁用详情下拉、详情非顶部不误触及播放器锁定规则均保持不变。
- 新增合成层 widget 测试，确认视频扩展期间父布局尺寸不变、播放器和详情面板位移与同一
  进度一致；定向测试 11/11、完整 Flutter 测试 66/66 通过。完整 `dart analyze` 为
  0 error、0 warning、35 条既有 info，Android Release 构建和发布校验通过。
- 交付 APK：
  `build/app/outputs/flutter-apk/pili++-2.1.7-2026081003-universal-release-youtube-pull-animation-v6.apk`；
  versionName `2.1.7`、versionCode `2026081003`、applicationId `com.shudo.plusplus`、
  应用名 `pili++`、universal ABI 和证书 SHA-256
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C` 均通过
  `tool/verify_release.ps1`；APK SHA-256 为
  `39970ED9E752F79B9040CBEEF08DF1B68C524DDB40B24F57AAC13BA783A0E90F`。
- 待同一 Samsung 真机在 mpv 与 ExoPlayer 下复录并逐帧验收：短拉回弹、超过阈值进入
  竖屏全屏、全屏上滑退出、长短视频、竖屏视频、播放/暂停、横向进度/纵向音量亮度、评论
  刷新、应用内小窗及小窗恢复。自动化通过不能替代 120 Hz 真机帧时间验证。

### 2026-08-10 竖屏全屏播放器连续缩放修复

- 用户 V6 真机录屏显示：进入竖屏全屏时，黑色播放器区域和详情面板先完成位移，播放器
  本体仍保持详情页高度；提交全屏状态后才切换到全屏高度，形成“先移动到中间、再放大”的
  两段式视觉。上滑退出时同样先移动，提交退出后才缩回。
- `PagePullVideoExpansion` 现在按同一个 `_pagePullAnimation` 进度插值播放器的真实高度，
  `videoPlayer`、视频画面和控制层在拖动与补间阶段同步重新布局；移除了固定高度播放器的
  `extraHeight / 2` 平移。外层 sliver extent 和详情面板合成层位移仍保持稳定，不恢复整页
  每帧 layout 的旧实现。
- 组件测试增加中间进度和全屏端点断言；定向测试 11/11、完整 Flutter 测试 66/66 通过，
  完整 `dart analyze` 为 0 error、0 warning、35 条既有 info。Android universal Release
  构建及发布身份校验通过。
- 交付 APK：
  `build/app/outputs/flutter-apk/pili++-2.1.8-2026081004-universal-release-pull-resize-v7-final.apk`；
  APK SHA-256 为
  `6748CDFF54C5B3C0BE7C2B5369AEE99CEF4486D838E250EDD2C3F43C6E3E40DA`，证书 SHA-256 为
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`。
- 待同一 Samsung Android 16 真机分别在 mpv/ExoPlayer 下验证：详情顶部下拉进入、短拉
  回弹、竖屏全屏上滑退出、短滑回弹、横屏/竖屏视频及播放/暂停状态；需要复录确认拖动期间
  画面尺寸与位置同步变化，进入和退出端点没有第二次跳变。

### 2026-08-11 ExoPlayer 换源宽高比刷新修复

- 用户报告 ExoPlayer 自动连播复用播放器时，4:3 视频切到 9:16 视频仍沿用上一视频的
  4:3 Texture/显示比例；直接打开 9:16 视频也可能先按错误比例显示。根因是 Media3
  `open` 只依赖异步 `onVideoSizeChanged`，换源时没有清除原生会话和 Flutter 视图中的
  上一媒体宽高，也没有利用业务层已经取得的新媒体宽高。
- ExoPlayer `open` 现在携带当前视频元数据宽高。原生会话在新 generation 开始时立即重置
  显示宽高、旋转和 `SurfaceProducer` 尺寸，再准备新媒体；Media3 解码器随后报告的实际
  `VideoSize` 仍会覆盖提示值。Flutter `ExoPlayerView` 同时跟踪 generation，新媒体尺寸未知
  时回到 16:9 占位，不再静默保留上一媒体比例。
- 新增 1440x1080 -> 1080x1920 的同会话连续 `open` 回归测试。定向 Dart 分析无问题，
  ExoPlayer 定向测试 18/18、完整 Flutter 测试 67/67、Android Debug Kotlin 编译和
  Android Release 构建均通过。
- Release 审计包为
  `build/app/outputs/flutter-apk/pili++-2.1.8-2026081004-universal-release-exo-aspect-ratio-audit.apk`，
  仅用于当前源码验证，不替代 2.1.8 正式交付、不更新发布基线。
  `verify_release.ps1 -AllowAlreadyDelivered` 已确认 applicationId `com.shudo.plusplus`、应用名 `pili++`、
  universal ABI 和既有证书；APK SHA-256 为
  `9E1BB226FDA7E5C4A972514D9C60AB2E3F4F7D21E22566E277D148FDC15527F5`。
- 待 Android 真机分别验证：直接打开 9:16 视频；4:3 自动连播到 9:16；9:16 自动连播到
  4:3；横竖屏、全屏、应用内小窗和系统 PiP 中换源。真机通过前本项保持“实现完成、待验证”。

### 2026-08-15 Android 具体硬解模式映射

- ExoPlayer 创建会话时现在会把 `Pref.hardwareDecoding` 的具体值经 MethodChannel 传到
  Android，不再只传硬解开关。`no` 选择仅软件视频 MediaCodec；`mediacodec`、
  `mediacodec-copy`、`auto`、`auto-safe`、`auto-copy` 使用 Android MediaCodec 路径；
  逗号分隔列表选择第一个 Android 可识别候选。关闭全局硬解开关时，软解优先级最高。
- `vaapi`、`nvdec`、`d3d11va`、`videotoolbox`、`vulkan` 等非 Android/mpv 专属模式
  不伪装成已支持：Media3 使用 Android 平台默认策略，并在 `PlaybackConfig` 中明确显示
  原请求值和 `unsupported on Android`。`*-copy` 在 Media3 中只能映射到相同的
  Surface/MediaCodec 路径，无法复制 mpv copy 模式的输出语义。
- 设置页“mpv 硬解模式”已改为后端通用“硬解模式”，说明 mpv 保持原模式、Media3 执行
  Android 映射。mpv 路径仍收到原始 `hwdec` 值，没有被本批改变。
- 新增 `Media3DecoderModeTest`，覆盖软解、Android 可识别模式、全局开关优先、非 Android
  模式诊断和候选列表解析；Dart MethodChannel 测试覆盖 `decoderMode` 传递。定向 Dart
  分析无问题，相关 Flutter 测试通过 19/19，Android `:app:testDebugUnitTest` 与 Android
  Release 构建通过。
- 审计 APK：
  `build/app/outputs/flutter-apk/pili++-2.1.8-2026081004-universal-release-exo-hwdec-mode-audit.apk`；
  versionName `2.1.8`、versionCode `2026081004`、applicationId `com.shudo.plusplus`、
  universal ABI 和既有证书均通过 `verify_release.ps1 -AllowAlreadyDelivered`。APK SHA-256：
  `5F4E78FEF5F69879E8B3F4DC04A7B69566C6459103F2DBD2DDAE67F2B0B36A49`。该包只用于审计，
  不更新正式发布基线。
- 仍待 Android 真机矩阵：AVC/HEVC/AV1、独立 DASH 音频、直播、本地文件、软硬解切换、
  解码失败的一次性软解回退、换源/清晰度/分P、拖动、后台、应用内小窗、系统 PiP、旋转，
  并覆盖至少两类不同芯片/MediaCodec 实现。完成前状态为“Android 映射已实现、待真机验收”。

### 2026-08-15 GitHub Actions Android CI

- `Build` workflow 现在在所有分支的非 Markdown 推送和 PR 上运行 Flutter 格式、静态分析和测试；
  纯 Markdown 提交仍由 `paths-ignore` 跳过。PR 继续生成开发 APK，非 PR 推送或手动运行则从
  GitHub Secrets 注入当前发布证书并生成签名 Android artifact。Secrets 为 `SIGN_KEYSTORE_BASE64`、
  `KEY_PASSWORD`，已按当前本地证书更新；证书和密码不写入 Git。
- CI 构建元数据改由 `tool/write_ci_build_metadata.ps1` 从现有 `pubspec.yaml` 读取版本，
  不再用 Git commit 数量重写 Android `versionCode`，避免自动构建生成低于既有交付包的
  版本。自动构建只上传 Actions artifact；创建 GitHub Release 仍需要手动触发并明确提供
  tag，正式交付仍应执行项目 release 校验和真机验收。
- 2026-08-16 PR Run `31921644323` 在提交 `96bfeabccd63cc61f22e4776a35351bb61da4524` 上通过：
  Flutter quality、Android 开发 APK、iOS 和 Windows 均成功；Android 的
  `Refresh media_kit native checksums` 步骤成功，证明外部 `vnext` 资源校验修复生效。
- 2026-08-16 手动 Android Release Run `31922285975`（仅 Android、无 tag）通过：四项
  签名 Secrets 写入成功，Release 构建、清理签名材料、重命名和三个 artifact 上传均成功。
  产物为 `pili++_android_2.1.8+2026081004_arm64-v8a.apk`、
  `pili++_android_2.1.8+2026081004_armeabi-v7a.apk`、
  `pili++_android_2.1.8+2026081004_x86_64.apk`，Actions artifact 摘要分别为
  `783d2503499ffcd29091bcee5b510bd3374597a3b6e280f88d19a9e5945322f7`、
  `42e3eb3cd3fe249b251afc8abd36ff0dc54c1f6766d29419fb7d388df1c8d4a5`、
  `bca34690db279c67a1ead669f9ad7e45161cadc692c04db5d9ea8771e6e81d12`。
- 之前 Run `31882803739` 的失败根因为 `media_kit` fork 固定的旧 MD5 与
  `libmpv-android-video-build` `vnext` 于 2026-08-13 更新后的资源不一致；没有跳过校验，
  新增 `tool/patch_media_kit_checksums.ps1` 严格替换已核实的三个当前 MD5 后恢复完整性校验。

### 2026-08-17 上游 Material UI/依赖同步

- 在工作区干净、上游 `upstream/main@f8b9ef3` 已 fetch 后合并上游新增的三个提交：
  `810c26a`（Material UI 迁移）、`f73b9c9`（Star History 修复）、`f8b9ef3`（依赖升级）。
  合并提交为 `03ed055`，合并前本地领先 77、上游领先 3；合并后本地领先 78、落后 0。
- 上游改动涉及 510 个文件；27 个文件与本地改造重叠，实际只有 5 个内容冲突。
  `.github/workflows/build.yml` 保留本地 checksum、签名 Secrets、构建元数据和签名材料清理；
  `lib/pages/video/view.dart` 保留本地视频 Listener、全屏和应用内小窗手势；
  `lib/plugin/pl_player/widgets/play_pause_btn.dart` 保留统一 `PlayerStatus` 回调，未恢复
  上游直接订阅 media_kit 的实现。Android Media3、应用内小窗、PiP、发布校验和状态文档文件
  未被删除或覆盖。
- 接受上游 `material_ui`、`cupertino_ui` 依赖以及 `flex_seed_scheme`/`getx` 的 `dev` 引用；
  其余播放器和业务逻辑仅做 Material UI 导入迁移。Flutter 3.47.0 工具链和项目 Flutter/material_ui
  patches 已应用。
- 合并后验证：`dart format --output=none --set-exit-if-changed lib test` 通过；`dart analyze`
  为 0 error、0 warning、35 条既有 info；`flutter test --no-pub --concurrency=1` 通过 69/69；
  Android `:app:testDebugUnitTest` 通过；Flutter Release 分 ABI 构建通过。
- 本地 Release 审计产物（未更新正式发布基线）：
  `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` SHA-256
  `037665AFBAB111B8F87F895FE0BF050D8A7E35D7DBD8C452B93F1A41A3942E8D`；
  `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` SHA-256
  `3759DB653EA61579F42C53E4949475D53D4C0AF1A3E352F0256F09FE71D6ACBB`；
  `build/app/outputs/flutter-apk/app-x86_64-release.apk` SHA-256
  `5E47CD1743E38B6B8104081DC1668B21F8416E85612F98167B1203989E0846BA`。
  三份 APK 均通过 `tool/verify_release.ps1 -AllowAlreadyDelivered`，applicationId、应用名、
  versionName/versionCode、ABI 和证书 `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`
  一致。当前没有新增正式交付包，版本基线仍为 `2026081004`。
- 本批未执行 Android 真机回归；mpv/ExoPlayer 播放控制、手势、应用内小窗和系统 PiP 仍需在
  合并后的准确源码状态上按既有矩阵复核，不能仅凭自动化结果标记真机验收完成。

### 2026-08-17 上游同步

- 在工作区干净且本地 CI 修复已提交为 `d7f7d259c6aa15676aebd02e19e9bae2aeecf023` 后，
  fetch 并合入 `upstream/main@3a7d4614743cb7289293d6c47e13d96aec544f18`。上游本批新增 15 个
  提交、改动 38 个文件；合并提交为 `4b827302d526eb35a9314590cba0d3b2e87ce4c6`。
- `lib/main.dart`、`pubspec.yaml` 自动合并；`lib/pages/video/view.dart` 的唯一文本冲突已
  人工处理：保留本地视频区域 `Listener` 和四个指针回调，以保持下拉进入应用内小窗手势；
  采用上游黑色背景 `isAntiAlias: false` 与封面层布局修正。未删除播放器控制层、ExoPlayer
  或应用内小窗逻辑。
- 使用独立 Flutter 3.47.0 工具链并按 CI 应用项目 patches：`dart format --output=none
  --set-exit-if-changed lib test` 通过（1330 个文件，0 changed）；`dart analyze` 通过，
  0 error、0 warning、35 条既有 info；`flutter test --no-pub --concurrency=1` 通过 69/69。
- Android `:app:testDebugUnitTest`/Release 构建已启动并完成源码与插件编译前置阶段，但在
  `:app:mergeDebugAssets` 获取 Flutter 3.47 engine artifact 时，Java TLS 连接
  `https://storage.googleapis.com/download.flutter.io/.../armeabi_v7a_debug-1.0.0-5f776256...pom`
  被远端中断而失败。该次没有生成可交付 APK；Android 构建与真机验证保持待完成，不能以此
  次失败宣称 Android Release 已验证。

### 2026-08-17 Actions checksum fix

- 手动 Actions Run `31987028340` 的 Android job 在 `Refresh media_kit native checksums` 失败：
  上游 `media_kit` 使用 `url + md5` 条目，而旧脚本只匹配 `name + md5`，并且把“已是正确值”
  错误当成未更新失败。
- `tool/patch_media_kit_checksums.ps1` 现同时匹配两种条目格式，依据当前
  `.dart_tool/package_config.json` 选择实际使用的 Git checkout，并允许已正确 checksum 幂等
  通过；缺失、重复或未知值仍会严格失败。
- 本地 Flutter 3.47.0 Pub 缓存验证通过，输出 `media_kit native checksums already current`；
  修复提交为 `4207fb2540448e660e7df1fc763ec4a29f076826` 并已推送。新的 Android-only Run
  `31991855057` 已通过 Flutter quality、checksum 校验、Release APK 构建、签名材料清理、
  重命名和三个 artifact 上传。产物为 `pili++_android_2.1.8+2026081004_arm64-v8a.apk`、
  `pili++_android_2.1.8+2026081004_armeabi-v7a.apk`、
  `pili++_android_2.1.8+2026081004_x86_64.apk`；本次手动运行未创建 GitHub Release。
