# pili++ 当前项目状态

> 最后核对：2026-08-02 17:06 +08:00
>
> 本文件记录会随开发变化、但后续任务必须知道的事实。开始任务时先核对这里与实际
> Git、源码和构建产物；结束任务前更新。长期规则见 `AGENTS.md`，ExoPlayer 详细兼容
> 记录见 `docs/android_exoplayer.md`。

## 仓库基线

- 当前分支：`main`
- 最新 GitHub 发布源提交：`859d39c4ff3c77c37e1cc1d7131192df8f8b4241`
  (`chore: prepare 2.1.2 release`)
- 最新功能快照：`c04a79fff718b4ce9024883d1bf898af43ddd7cc`
  (`fix: restore safe Media3 VOD buffering`)
- 最新上游合并提交：`0e4e8db250e986c4f8e32652fac2652651ec4168`
  (`Merge remote-tracking branch 'upstream/main' into codex/android-exoplayer`)
- 上游：`https://github.com/bggRGjQaUbCoE/PiliPlus.git`
- 已获取并合入的 `upstream/main`：`5296a8f7f07a22f347ad53bc8c7651e6787bf3ec`
- 当前分支已包含上游 `56ca0ca`、`10b723f`、`e4e7037`、`91e7899` 和 `5296a8f`；
  本状态更新提交完成后相对上游为本地领先 59、落后 0。
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
- 2026-08-02 用户确认接受 Media3 超分禁用/效率/画质的当前行为：运行时无缝切换不是
  缺陷，不要求复制上游 mpv/Anime4K 切换时的暂停加载；当前 Lanczos 效果即使肉眼差异
  不明显，也按“功能有效”处理。该决定关闭基础超分效果验收，不代表缓冲/硬解回退或
  其他第八批缺口一并完成。

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

- ExoPlayer 适配批次 8 在黑屏热修复后的第一项隔离恢复已提交为
  `c04a79fff718b4ce9024883d1bf898af43ddd7cc`：只恢复 Media3 点播缓冲设置，解码器仍固定
  使用已验证可播放的系统默认选择顺序，直播继续完整使用 Media3 默认 LoadControl。
  旧实现以默认约 8 MiB 为优先停止条件，可能在达到安全时间缓冲前停载；新实现对网络
  点播先保证最多 5 秒的安全最小时间，再由用户字节目标或最大缓冲时长停止，并保留同等
  时长的后向缓冲。极小值会被钳制到合法边界，本地媒体保留 Media3 本地时间阈值。
- `PlaybackConfig` 会显示 `decoder=platform-default (requested=...)`，明确硬解开关仍未
  应用；点播显示 `buffer=custom-safe`、目标 MiB、min/max 毫秒及 `timePriority=true`，
  直播显示 `buffer=media3-live-default`。设置页同步说明点播和直播的实际范围。
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
- 本组待报告问题的 Samsung Android 16 真机优先验证普通点播不黑屏、能持续播放和拖动，
  并核对 `PlaybackConfig` 为 `buffer=custom-safe`、`VideoOutput` 为
  `firstFrameRendered: true`。通过后可把旧 P0 收敛到解码器配置，再制作只恢复解码器的
  下一隔离包；未验证前不能把缓冲设置重新标记为完成。

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

- Android Media3 直播已实现但待完整真机矩阵验证；协议/格式/编码/CDN 组合、仅音频、
  暂停切换保持、错误恢复、后台/通知、小窗/PiP 和生命周期未验收前，不能删除 mpv 后端。
- 字幕 VTT/SRT/ASS/SSA 格式和结构化文本 cue 已接通，用户当前真机流程未见问题；
  bitmap cue 与 Flutter 竖排文字布局已实现并通过自动化验证，仍待含 PGS/DVB 与
  vertical-rl/vertical-lr 实际媒体的真机对照验收。
- 截图和动态 WebP 已有 ExoPlayer 原生实现并通过自动化构建/容器测试；Samsung Android
  16 上首个截图审计包曾触发 `PixelCopy ERROR_SOURCE_NO_DATA`，重试与媒体源独立取帧
  修复已确认能进入 Dart PNG 解码；随后发现并修复 `ImmutableBuffer` 二次释放，第二个
  替换审计包仍待同机完成预览/保存，以及画面方向、像素比例、翻转、不同媒体源、取消和
  播放状态保持的逐项对照。
- Media3 超分辨率实时效果已实现并通过自动化构建/测试；用户已在真机切换三档并接受
  当前无缝、肉眼差异不明显的 Lanczos 行为为“功能有效”。不同分辨率、编码、HDR、
  画面方向、GPU 性能和播放器生命周期仍可随相应场景扩展回归，但不再单独阻塞基础
  超分功能验收。
- 原生音视频轨道枚举/选择、播放器信息和内置文本轨独立选择入口已接入 Media3，
  批次 3 与批次 5 的对应流程仍待真机对照。
- 服务器提供测量参数的两遍 `loudnorm` 已接入 Media3 PCM 增益与真峰值限制器，仍待
  真机与 mpv 对照；`dynaudnorm`、无测量值的单遍 loudnorm、链式及任意自定义
  FFmpeg 滤镜尚无 Media3 等价实现。
- 网络/源错误自动恢复与诊断已进入待真机验证；解码错误目前提供明确终态诊断和提示，
  不自动重试，仍需真机覆盖具体硬件解码失败与切画质恢复流程。
- Media3 自定义缓冲大小和点播缓冲时长已按“时间安全阈值优先”重新实现并生成隔离包，
  仍待 Samsung Android 16 真机确认不再黑屏；硬解总开关继续停用，使用系统默认解码器
  顺序。mpv 自动同步、视频同步和具体硬解模式没有 Media3 一一对应能力。
- 进程重建和更多边缘生命周期仍需继续闭环。

## 下一步

- 最高优先在报告问题的 Samsung SM-S9180 Android 16 上覆盖安装安全缓冲隔离包，先测
  普通点播首帧、连续播放、拖动和重开，并核对 `PlaybackConfig` 与 `VideoOutput`。若不
  黑屏，再扩展 UGC、PGC、DASH、清晰度/分P、全屏、后台、小窗和 PiP，并进入只恢复
  解码器的下一隔离组；若重新黑屏，立即回退到全黑热修复 v2 并停止恢复解码器。

1. Media3 超分基础行为已按用户决定验收；后续在 480p/720p/1080p/4K、不同编码、HDR、
   截图、全屏、小窗和 PiP 回归时顺带记录尺寸与性能，不再要求通过肉眼明显差异或复制
   mpv/Anime4K 的暂停加载来证明基础功能有效。

2. 使用安全缓冲隔离 APK 验证默认/小/大缓冲和上述播放场景；通过后制作只恢复解码器的
   新包，覆盖硬解开关、AVC、HEVC、AV1、DASH、本地文件、直播、清晰度/分P、全屏、
   后台、小窗和 PiP。旧缓冲/解码组合审计 APK 不再使用。
3. 使用批次 8 Media3 直播 v2 审计 APK 完成横屏/竖屏/方形直播、AVC/HEVC、服务端
   可选协议/格式、清晰度/线路/CDN、播放/暂停及暂停切换保持、仅音频、刷新、断网重试、
   后台/通知、应用内小窗、系统 PiP 和前后台生命周期验证；与 mpv 模式逐项对照。
4. 使用批次 8 第四组审计 APK 在 Media3 点播、mpv 点播、Media3/mpv 直播和独立音频中验证
   播放信息、字段复制和播放器音量；回归音频进度拖动与跳页前暂停，并确认新错误日志
   显示 `Player Runtimes`。
5. 使用批次 8 第三组审计 APK 验证直播横屏、竖屏和方形画面的尺寸/方向识别，切
   清晰度与路线后的尺寸更新，播放信息和播放器音量，并在桌面验证音频页与视频播放
   器的音量同步；直播仍需确认 mpv 行为无回归。
6. 使用批次 8 渲染边界审计 APK 在 mpv 与 Media3 下对照普通窗口、全屏、旋转、全部
   画面适配/比例、双向翻转、字幕显示与拖动、应用内小窗缩小/恢复，以及动态 WebP 的
   开始、进度、取消和保存；直播画面改用本组 Media3 直播 v2 包与 mpv 模式对照。
7. 使用批次 8 首组审计 APK 在 mpv 与 Media3 下对照关闭字幕、B 站字幕和外部
   VTT/SRT/ASS/SSA 的加载与互切，并覆盖播放、暂停、跳转时 SponsorBlock 位置更新。
8. 使用批次 7 截图生命周期修复审计 APK，先在报告问题的 Samsung Android 16 设备测试
   播放状态普通截图，确认能显示预览、点击后成功保存且不再出现 native peer 错误；再测
   暂停状态，并在 mpv 与 ExoPlayer 下对照普通截图、评论区截图和动态 WebP，
   覆盖横竖屏、像素宽高比、水平/垂直翻转、播放/暂停、全屏、小窗、不同区间/预设、
   进度、取消、保存、失败清理和当前播放会话不受转换影响；通过后补充真机验证记录。
9. 使用批次 6 审计 APK 对照可恢复与永久错误，覆盖断网恢复、超时、HTTP 5xx、
   重试耗尽、401/403/404、解码失败、播放/暂停意图，以及全屏、后台、应用内小窗和
   系统 PiP；通过后补充真机验证记录。
10. 使用批次 5 审计 APK 对照含多个内置文本轨的本地/网络媒体，覆盖逐轨选择、关闭、
   内置字幕与 B 站/外部字幕双向切换，以及播放/暂停、跳转、全屏、后台、应用内小窗
   和系统 PiP；通过后补充真机验证记录。
11. 使用批次 4 最终审计 APK 对照服务器测量 loudnorm 的音量和听感，并覆盖切换、
   后台、应用内小窗和系统 PiP；通过后补充真机验证记录。
12. 使用批次 3 审计 APK 在 mpv 与 ExoPlayer 下逐项对照 DASH 独立音视频、本地
   多轨、自动/关闭/指定轨道、“听视频”无重载切换及播放信息字段；通过后补充真机
   验证记录。
13. 使用批次 8 字幕边缘审计 APK 对照含 PGS/DVB 位图字幕和 WebVTT
   vertical-rl/vertical-lr 的本地/网络媒体，覆盖透明度、尺寸、锚点、切换、关闭、
   多列、标点、样式、跳转、普通窗口、全屏、旋转、应用内小窗和系统 PiP，并与 mpv
   模式逐项对照；通过后补充真机验证记录。
14. 直播真机结果稳定后，下一组优先处理本地视频或剩余生命周期边界；动态/自定义
   音频滤镜仍保留为独立兼容任务。
15. 清理仓库既有 37 条 info 后，使完整 `flutter analyze` 以零退出码通过。
16. 真机回归本次上游同步涉及的视频卡片、UGC 分P列表、动态/评论文本选择和滚动。
17. 继续跟踪上游；下次同步仍先 fetch、检查重叠文件，再执行合并和完整验证。
