<div align="center">
  <img width="180" height="180" src="assets/images/logo/logo.png" alt="pili++ logo">
  <h1>pili++</h1>
  <p>使用 Flutter 开发的哔哩哔哩第三方客户端</p>

  ![GitHub repo size](https://img.shields.io/github/repo-size/loneshu7/PiliPlusPlus)
  ![GitHub Repo stars](https://img.shields.io/github/stars/loneshu7/PiliPlusPlus)
  ![GitHub all releases](https://img.shields.io/github/downloads/loneshu7/PiliPlusPlus/total)
</div>

> [!IMPORTANT]
> pili++ 基于开源项目
> [bggRGjQaUbCoE/PiliPlus](https://github.com/bggRGjQaUbCoE/PiliPlus)。
> 当前 Android 端正在将 mpv 播放后端迁移到 AndroidX Media3
> ExoPlayer。迁移完成的标准是原 mpv 用户功能全部闭环，而不只是视频能够播放。

## 项目目标

Android 端使用 Media3 ExoPlayer 替代 mpv，同时保留原有 Flutter 播放器的
控件、手势、弹幕、字幕和业务行为：

- mpv 可用的功能，ExoPlayer 模式也必须可用；
- 相同入口、控件和手势产生相同结果；
- 播放状态正确回传到既有 Flutter UI 与业务逻辑；
- 不通过隐藏入口、静默回退 mpv 或显示“暂不支持”掩盖缺口；
- Media3 没有直接对应能力时，在原生桥接层或 Flutter 公共层实现等价结果。

详细验收标准见 [Android ExoPlayer 兼容记录](docs/android_exoplayer.md)。

## 当前迁移状态

| 范围 | 状态 |
| --- | --- |
| Flutter `Texture` 视频图层、DASH 合流与基础播放状态 | 已实现并通过 Release 构建 |
| 控制层、双击、进度/亮度/音量滑动与长按倍速 | 已真机验证 |
| 清晰度、CDN、分P切换与异常重载 | 已真机验证 |
| 全屏、旋转、锁定、画面适配、缩放与翻转 | 已真机验证 |
| 弹幕、字幕、章节、预览、高能进度与 SponsorBlock | 已真机验证 |
| ExoPlayer 自动进入 Android 系统画中画 | 已真机验证 |
| 应用内小窗及其与系统画中画的往返 | 已实现，待完整真机回归 |
| 音频焦点、媒体通知与耳机/蓝牙控制 | 已实现，待真机验证 |
| 全部 mpv 功能的完整替代 | 进行中 |

“已实现”表示代码和 Release 构建已通过，不等于真机验收完成。未经过真机
对照验证的项目会明确标记为“待真机验证”。

## 支持平台

- Android
- Android Pad
- iOS / iPadOS
- Windows
- Linux
- macOS

本仓库当前的重点开发和交付平台为 Android，其他平台能力主要继承自上游
PiliPlus。

## 主要功能

- 视频、番剧、课程、合集、互动视频与本地视频播放；
- 画质、音质、解码格式、分P、CDN、倍速和画面比例切换；
- 弹幕、高级弹幕、字幕、高能进度条、章节、缩略图预览与 SponsorBlock；
- 双击播放/暂停、长按倍速、横向进度和纵向亮度/音量手势；
- 全屏、横竖屏、画中画、后台音频和媒体控制；
- 可选的应用内小窗播放，返回其他页面时继续复用当前播放器；
- 推荐、热门、动态、搜索、评论、收藏、稍后再看、历史记录和私信；
- 离线缓存、DLNA、WebDAV 设置备份与多账号。

### 应用内小窗

“设置 → 播放设置 → 应用内小窗播放”开关默认关闭。开启后，从正在播放的视频页
返回应用内其他页面时，会将同一个播放器平滑缩小为悬浮小窗，而不是重新创建播放
会话。小窗会按视频真实宽高比适配，缩放与圆角动画同步进行；恢复时，小窗归位和
视频页加载同步进行。

应用内小窗提供播放/暂停、前进、后退、关闭和恢复入口，不显示“系统画中画”按钮。
应用进入后台时仍可按系统规则转入 Android 画中画；从系统画中画点击全屏会恢复到
当前视频详情页。打开下一个视频时，旧小窗结束并恢复为正常视频播放。

该功能及音频焦点、媒体按键等生命周期场景仍需要覆盖更多 Android 版本、设备和
视频类型后，才会标记为完整真机验收。

## 下载与安装

发布包将上传到
[PiliPlusPlus Releases](https://github.com/loneshu7/PiliPlusPlus/releases)。

Android Release APK：

- 用户可见名称为 `pili++`；
- applicationId 当前为 `com.shudo.plusplus`；
- 通用包同时包含 `arm64-v8a`、`armeabi-v7a` 和 `x86_64`；
- 后续版本必须使用同一证书签名，才能覆盖安装并保留应用数据。

不要从非本仓库或其他不可信渠道安装 APK。

## 检查更新

- 默认在应用启动时检查本仓库的 GitHub Releases；
- 可在“设置 → 其他设置 → 检查更新”启用或关闭启动检查；
- 可点击“关于 → 当前版本”手动检查；
- Android 会选择与设备 ABI 匹配的 Release APK，并交给浏览器下载；
- 当前不在应用内静默下载或自动安装，安装仍由 Android 系统确认。

Release APK 文件名必须保留版本号、`versionCode` 和 ABI，更新判断会优先读取
这些信息。

## Android 本地构建

### 环境

- Flutter `3.44.8`
- Dart `>= 3.12.0`
- JDK 17
- Android SDK / Build Tools

### 基础命令

```bash
flutter pub get
dart format .
flutter analyze
flutter build apk --release
```

正式发布时还应通过 `--build-name`、`--build-number` 和 `--dart-define`
写入版本、Git commit 与构建时间。

### Release 签名

Android 签名使用本地 `android/key.properties` 和对应 keystore。以下内容均被
Git 忽略，不得提交：

- keystore 文件；
- store password；
- key alias；
- key password。

GitHub Actions 发布需配置以下仓库 Secrets：

- `SIGN_KEYSTORE_BASE64`
- `KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`

## 验证要求

每批 Android 播放器修改至少完成：

1. `dart format`；
2. 相关文件静态分析；
3. Android Release 构建；
4. APK 签名、applicationId、版本、ABI 和 SHA-256 校验；
5. 使用同一视频与 mpv 执行相同操作进行真机对照；
6. 普通窗口、全屏及适用的前后台/画中画场景回归。

无法在当前环境完成的真机检查必须记录为“待真机验证”。

## 仓库

- 当前仓库：[loneshu7/PiliPlusPlus](https://github.com/loneshu7/PiliPlusPlus)
- 上游项目：[bggRGjQaUbCoE/PiliPlus](https://github.com/bggRGjQaUbCoE/PiliPlus)
- 原始项目：[guozhigq/pilipala](https://github.com/guozhigq/pilipala)
- 相关上游：[orz12/PiliPalaX](https://github.com/orz12/PiliPalaX)

提交问题前请先搜索
[现有 Issues](https://github.com/loneshu7/PiliPlusPlus/issues)。

本仓库会持续同步上游的界面、交互和依赖更新，并在合并时保留本分支的 ExoPlayer、
应用内小窗及 Android 发布身份改造。精确的同步基线、验证结果和待办记录见
[当前项目状态](docs/current_state.md)。

## 声明

本项目仅用于学习和测试，不提供任何破解内容。项目使用的接口资料均来自公开
渠道。使用者应遵守所在地区法律法规、哔哩哔哩用户协议及相关内容版权要求。

## 致谢

- [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)
- [media-kit](https://github.com/media-kit/media-kit)
- [flutter_meedu_videoplayer](https://github.com/zezo357/flutter_meedu_videoplayer)
- [dio](https://pub.dev/packages/dio)

感谢所有上游作者和贡献者。

## 许可证

本项目依据 [GNU General Public License v3.0](LICENSE) 发布。
