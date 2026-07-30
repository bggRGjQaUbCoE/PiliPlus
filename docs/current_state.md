# pili++ 当前项目状态

> 最后核对：2026-07-30 13:07 +08:00
>
> 本文件记录会随开发变化、但后续任务必须知道的事实。开始任务时先核对这里与实际
> Git、源码和构建产物；结束任务前更新。长期规则见 `AGENTS.md`，ExoPlayer 详细兼容
> 记录见 `docs/android_exoplayer.md`。

## 仓库基线

- 当前分支：`main`
- 最新 GitHub 发布源提交：`859d39c4ff3c77c37e1cc1d7131192df8f8b4241`
  (`chore: prepare 2.1.2 release`)
- 最新功能快照：`2cd76abe776a45d7d89dc8b9736418fcf8fea21e`
  (`feat: preserve subtitle formats and cues in ExoPlayer`)
- 最新上游合并提交：`0e4e8db250e986c4f8e32652fac2652651ec4168`
  (`Merge remote-tracking branch 'upstream/main' into codex/android-exoplayer`)
- 上游：`https://github.com/bggRGjQaUbCoE/PiliPlus.git`
- 已获取并合入的 `upstream/main`：`5296a8f7f07a22f347ad53bc8c7651e6787bf3ec`
- 当前分支已包含上游 `56ca0ca`、`10b723f`、`e4e7037`、`91e7899` 和 `5296a8f`；
  本状态更新提交完成后相对上游为本地领先 17、落后 0。
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
- 批次 2 仍待真机对照：mpv/ExoPlayer 的内置 VTT、外部 VTT/SRT/ASS/SSA、字幕
  切换与关闭、样式和定位、全屏/旋转及字幕拖动。Media3 bitmap cue 尚未桥接；
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
- 本批仍待真机对照：mpv/ExoPlayer 播放器音量调整及静音/音频焦点状态；mpv 普通
  截图回归；ExoPlayer 普通截图和评论区截图的明确反馈；番剧全屏底栏和设置菜单的
  超分辨率入口在 ExoPlayer 下无异常、mpv 下 Shader 行为不回归。
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
- 字幕 VTT/SRT/ASS/SSA 格式和结构化文本 cue 已接通，但仍待真机对照；bitmap cue
  与 Flutter 竖排文字布局尚未闭环。
- 截图和动图截取尚无 ExoPlayer 等价实现；截图调用已公共化且不再静默失败。
- 超分辨率入口已不再隐藏或进入 mpv 空对象路径，但 Media3 等价效果尚未实现。
- 原生音视频轨道枚举/选择和完整播放器信息尚未接入 Media3。
- mpv `loudnorm` 音频归一化尚无 Media3 等价实现。
- 网络变化、解码失败、进程重建和更多边缘生命周期仍需继续闭环。

## 下一步

1. 使用批次 2 审计 APK 在 mpv 与 ExoPlayer 下逐项对照内置 VTT、外部
   VTT/SRT/ASS/SSA、切换/关闭、样式定位、字幕拖动、全屏和旋转；通过后补充真机
   验证记录。
2. 使用批次 1 审计 APK 完成播放器音量、截图反馈和两个超分辨率入口的真机对照；
   通过后补充真机验证记录。
3. 批次 2 真机回归后继续处理 bitmap cue、竖排字幕等明确边缘缺口，或进入适配
   计划中下一组最高优先级的音视频轨道枚举/选择闭环。
4. 修复 Flutter SDK 缺失的 iOS 测试资源后重跑完整 `flutter analyze`。
5. 真机回归本次上游同步涉及的视频卡片、UGC 分P列表、动态/评论文本选择和滚动。
6. 继续跟踪上游；下次同步仍先 fetch、检查重叠文件，再执行合并和完整验证。
