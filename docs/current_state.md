# pili++ 当前项目状态

> 最后核对：2026-07-28 17:20 +08:00
>
> 本文件记录会随开发变化、但后续任务必须知道的事实。开始任务时先核对这里与实际
> Git、源码和构建产物；结束任务前更新。长期规则见 `AGENTS.md`，ExoPlayer 详细兼容
> 记录见 `docs/android_exoplayer.md`。

## 仓库基线

- 当前分支：`codex/android-exoplayer`
- 最新功能快照：`e433cf18720fc15ccbba872a6de73df4715e5c8c`
  (`feat: add in-app mini player lifecycle`)
- 最新上游合并提交：`0e4e8db250e986c4f8e32652fac2652651ec4168`
  (`Merge remote-tracking branch 'upstream/main' into codex/android-exoplayer`)
- 上游：`https://github.com/bggRGjQaUbCoE/PiliPlus.git`
- 已获取并合入的 `upstream/main`：`5296a8f7f07a22f347ad53bc8c7651e6787bf3ec`
- 当前分支已包含上游 `56ca0ca`、`10b723f`、`e4e7037`、`91e7899` 和 `5296a8f`；
  本状态更新提交完成后相对上游为本地领先 7、落后 0。
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

- 版本：`2.1.0`
- versionCode：`2026072806`
- ABI：universal (`arm64-v8a`、`armeabi-v7a`、`x86_64`)
- 文件名：`pili++-2.1.0-2026072806-universal-release.apk`
- APK SHA-256：
  `C8AFD03AF78F17E1324351CF0F627E599C203543259197E01760F6B1DA2EF099`
- 2026-07-28 15:52 使用当前源码重新构建了相同版本作为发布校验脚本的审计样本，
  当前位于 `build/app/outputs/flutter-apk/`；重建哈希与既有交付记录一致，但这不是一次
  新交付。再次交付仍必须递增 versionCode、重新构建并记录新哈希。

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

根据 `docs/android_exoplayer.md` 中记录的 2026-07-26 和 2026-07-28 真机反馈，以下
场景已经过当前测试设备验证：

- 点击显示/隐藏控制层、双击播放/暂停、横向跳转、纵向亮度/音量和长按倍速；
- 清晰度、CDN、网络错误重载和分P切换的播放状态保持；
- 全屏、旋转、锁定、画面适配、缩放、翻转和常用手势；
- 弹幕、字幕、章节/看点、预览、高能进度和 SponsorBlock；
- ExoPlayer 自动进入系统 PiP；
- 应用内小窗的播放、暂停、拖动、关闭、恢复、动画与视频比例适配；
- 应用内小窗进入系统 PiP，以及 PiP 全屏恢复详情页的完整往返；
- 音频焦点、媒体通知、媒体按键和有线耳机/蓝牙控制。

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

- 互动视频和本地文件等尚未覆盖类型的小窗恢复参数；
- 不同 Android 版本、芯片、折叠屏以及尚未覆盖的息屏/亮屏和进程生命周期边界；
- 本次上游同步涉及的视频卡片、UGC 分P列表、动态/评论文本选择和滚动。

## ExoPlayer 已知未闭环项

- 直播仍使用 mpv。
- 截图和动图截取尚无 ExoPlayer 等价实现。
- 超分辨率入口在 ExoPlayer 模式下仍被隐藏。
- 原生音视频轨道枚举/选择和完整播放器信息尚未接入 Media3。
- mpv `loudnorm` 音频归一化尚无 Media3 等价实现。
- 网络变化、解码失败、进程重建和更多边缘生命周期仍需继续闭环。

## 下一步

1. 真机回归本次上游同步涉及的视频卡片、UGC 分P列表、动态/评论文本选择和滚动。
2. 继续跟踪上游；下次同步仍先 fetch、检查重叠文件，再执行合并和完整验证。
3. 继续处理最高优先级的 ExoPlayer 未闭环项，不得通过隐藏入口或回退 mpv 宣称完成。
