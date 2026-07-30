# pili++ 当前项目状态

> 最后核对：2026-07-30 18:10 +08:00
>
> 本文件记录会随开发变化、但后续任务必须知道的事实。开始任务时先核对这里与实际
> Git、源码和构建产物；结束任务前更新。长期规则见 `AGENTS.md`，ExoPlayer 详细兼容
> 记录见 `docs/android_exoplayer.md`。

## 仓库基线

- 当前分支：`main`
- 最新 GitHub 发布源提交：`859d39c4ff3c77c37e1cc1d7131192df8f8b4241`
  (`chore: prepare 2.1.2 release`)
- 最新功能快照：`91841cbab07b46561340b2809617a0fdd082c3b7`
  (`feat: add ExoPlayer error recovery diagnostics`)
- 最新上游合并提交：`0e4e8db250e986c4f8e32652fac2652651ec4168`
  (`Merge remote-tracking branch 'upstream/main' into codex/android-exoplayer`)
- 上游：`https://github.com/bggRGjQaUbCoE/PiliPlus.git`
- 已获取并合入的 `upstream/main`：`5296a8f7f07a22f347ad53bc8c7651e6787bf3ec`
- 当前分支已包含上游 `56ca0ca`、`10b723f`、`e4e7037`、`91e7899` 和 `5296a8f`；
  本状态更新提交完成后相对上游为本地领先 28、落后 0。
- 应用内小窗、音频焦点/媒体控制、系统 PiP 恢复、版本更新和兼容记录已保存到上述
  功能快照。交接时应以实际 `git status` 为准；存在未提交修改时不得直接 merge 或
  rebase。
- `README.md` 已更新当前 ExoPlayer 迁移进度、应用内小窗行为、默认开关状态和
  上游同步说明；远程状态以实际 `git status` 和跟踪分支为准。

## 应用与发布身份

- 用户可见名称：`pili++`
- Android applicationId：`com.shudo.plusplus`
- Android namespace：`com.shudo.plusplus`
- Java/Kotlin package：`com.example.piliplus`
- Release 证书 SHA-256：
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`
- 机器可读发布基线：`tool/release_baseline.json`

## 最近一次交付

- 版本：`2.1.3`
- versionCode：`2026072808`
- ABI：universal (`arm64-v8a`、`armeabi-v7a`、`x86_64`)
- 文件名：`pili++-2.1.3-2026072808-universal-release.apk`
- APK SHA-256：
  `7989CFCE97FA9EF9AF934436683C2743DDE4F518C2C4CCAEAEB4EB5BD52EA1DE`
- 2026-07-28 20:27 已在本地交付通用 APK，尚未发布 GitHub Release；通用 APK 已通过
  `tool/verify_release.ps1` 的应用身份、版本、ABI 和签名校验。

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

## 已验证状态

根据 `docs/android_exoplayer.md` 中记录的 2026-07-26、2026-07-28 和 2026-07-30
真机反馈，以下场景已经过当前测试设备验证：

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

这些记录只代表当时设备和操作范围，不自动覆盖折叠屏、不同 Android 版本、不同芯片
或后续代码修改后的回归结果。

## 最近一次上游同步验证

- 2026-07-28 已将 `upstream/main@5296a8f` 合入当前分支，无文本冲突。
- `pubspec.yaml` 同时保留 `2.1.0+2026072806` 和上游 `jnigen ^0.17.0`。
- JNI 绑定同时保留上游回调参数释放和应用内小窗所需 PiP 模式变化回调；新版
  `jnigen` 完整生成后文件无差异。
- 上游涉及的 17 个 Dart 文件通过格式检查，0 个文件需要修改。
- `dart analyze` 无 error/warning，有 37 条既有 info。
- `flutter analyze` 被工作区 Flutter SDK 缺失的 iOS 测试资源目录中断，不是仓库
  分析错误；Android Release 构建随后通过。
- 合并审计 APK 的 applicationId、应用名、versionName、versionCode、ABI 和签名
  校验通过，SHA-256 为
  `79FD550A9BCC82A9370AADE46C02EB09D6EFE8F5E68F5BD29AE1D099EE7991CB`。
- 上游 UI 和文本选择变化仍需真机回归；审计 APK 不是新版本交付，不更新发布基线。

## 当前待验证修改

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
- 用户已反馈批次 2 当前真机流程未见问题。Media3 bitmap cue 尚未桥接；
  vertical-writing 元数据虽已回传，但 Flutter 竖排布局尚未等价实现，不能标记为
  完整字幕兼容。
- ExoPlayer 适配批次 1 实现已提交为
  `ad34b69315e54a1ebfb7890262a29d7d2734604c`：播放器音量入口改走公共控制器并同时
  支持 mpv 与 ExoPlayer；普通截图和评论区视频截图改用可区分成功、未适配和失败的
  公共结果；
  超分辨率两个入口改走公共控制器，ExoPlayer 下保持关闭并给出明确迁移提示，不再
  隐藏设置入口或进入 mpv 空对象路径。Media3 原生截图和超分效果仍是后续缺口，
  本批不标记为已适配。
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

- 直播仍使用 mpv。
- 字幕 VTT/SRT/ASS/SSA 格式和结构化文本 cue 已接通，用户当前真机流程未见问题；
  bitmap cue 与 Flutter 竖排文字布局尚未闭环。
- 截图和动图截取尚无 ExoPlayer 等价实现；截图调用已公共化且不再静默失败。
- 超分辨率入口已不再隐藏或进入 mpv 空对象路径，但 Media3 等价效果尚未实现。
- 原生音视频轨道枚举/选择、播放器信息和内置文本轨独立选择入口已接入 Media3，
  批次 3 与批次 5 的对应流程仍待真机对照。
- 服务器提供测量参数的两遍 `loudnorm` 已接入 Media3 PCM 增益与真峰值限制器，仍待
  真机与 mpv 对照；`dynaudnorm`、无测量值的单遍 loudnorm、链式及任意自定义
  FFmpeg 滤镜尚无 Media3 等价实现。
- 网络/源错误自动恢复与诊断已进入待真机验证；解码错误目前提供明确终态诊断和提示，
  不自动重试，仍需真机覆盖具体硬件解码失败与切画质恢复流程。
- 进程重建和更多边缘生命周期仍需继续闭环。

## 下一步

1. 使用批次 6 审计 APK 对照可恢复与永久错误，覆盖断网恢复、超时、HTTP 5xx、
   重试耗尽、401/403/404、解码失败、播放/暂停意图，以及全屏、后台、应用内小窗和
   系统 PiP；通过后补充真机验证记录。
2. 使用批次 5 审计 APK 对照含多个内置文本轨的本地/网络媒体，覆盖逐轨选择、关闭、
   内置字幕与 B 站/外部字幕双向切换，以及播放/暂停、跳转、全屏、后台、应用内小窗
   和系统 PiP；通过后补充真机验证记录。
3. 使用批次 4 最终审计 APK 对照服务器测量 loudnorm 的音量和听感，并覆盖切换、
   后台、应用内小窗和系统 PiP；通过后补充真机验证记录。
4. 使用批次 3 审计 APK 在 mpv 与 ExoPlayer 下逐项对照 DASH 独立音视频、本地
   多轨、自动/关闭/指定轨道、“听视频”无重载切换及播放信息字段；通过后补充真机
   验证记录。
5. 下一批优先处理截图/动图、直播或剩余生命周期边界中的最高优先级闭环；动态/自定义
   音频滤镜仍保留为独立兼容任务。
6. 批次 2 的 bitmap cue、竖排字幕，以及批次 1 的 Media3 截图、动图和超分效果
   仍是明确功能缺口，不因当前真机流程无异常而关闭。
7. 修复 Flutter SDK 缺失的 iOS 测试资源后重跑完整 `flutter analyze`。
8. 真机回归本次上游同步涉及的视频卡片、UGC 分P列表、动态/评论文本选择和滚动。
9. 继续跟踪上游；下次同步仍先 fetch、检查重叠文件，再执行合并和完整验证。
