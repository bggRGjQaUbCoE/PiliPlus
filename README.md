<!-- Audience classification: user-facing. -->

<div align="center">
  <img width="160" height="160" src="assets/images/logo/logo.png" alt="PiliAvalon logo">
  <h1>PiliAvalon</h1>
  <p>基于 PiliPlus 的 Bilibili 第三方客户端，面向更可控的个人内容屏蔽体验。</p>

  ![GitHub repo size](https://img.shields.io/github/repo-size/CometDash77/PiliAvalon-Worksite)
  ![GitHub Repo stars](https://img.shields.io/github/stars/CometDash77/PiliAvalon-Worksite)
  ![GitHub all releases](https://img.shields.io/github/downloads/CometDash77/PiliAvalon-Worksite/total)

  [下载正式版](https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/v1.0.0) · [English](README.en.md) · [源代码](https://github.com/CometDash77/PiliAvalon-Worksite)
</div>

## 下载

当前正式版：**PiliAvalon v1.0.0**

- Release: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/v1.0.0
- 状态：stable / latest
- 来源提交：`5ccc9bf243bab2c5f143032bd2549016a5b857da`
- APK 版本串：`2.0.8-5ccc9bf24+5099`
- 签名证书 SHA-256 指纹：`0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

请选择与你设备匹配的 APK：

| 设备类型 | Release 资产 |
| --- | --- |
| 大多数现代 Android 手机 | `PiliAvalon_android_2.0.8-5ccc9bf24+5099_arm64-v8a.apk` |
| 较旧的 32 位 Android 设备 | `PiliAvalon_android_2.0.8-5ccc9bf24+5099_armeabi-v7a.apk` |
| Android 模拟器或 x86_64 环境 | `PiliAvalon_android_2.0.8-5ccc9bf24+5099_x86_64.apk` |

`v1.0.0` 正式版只提供以上三个 ABI APK，不提供 universal APK。

## 当前特色

PiliAvalon v1.0.0 的重点是 Phase 1 个人屏蔽能力，已在正式版中发布：

- **结构化屏蔽规则**：支持标题/正文关键词、用户/UP 关键词、推荐理由、用户 UID、分区、标签等规则类型。
- **推荐流屏蔽**：可对推荐列表、相关视频等推荐内容应用屏蔽规则。
- **评论区屏蔽**：可对评论文本和用户相关信息应用屏蔽规则。
- **设置入口与规则管理**：提供屏蔽设置页，可查看、添加、编辑、启用或停用规则。
- **全局与分区开关**：支持全局开关，并可分别控制推荐与评论屏蔽范围。
- **可逆与兼容路径**：保留既有规则兼容迁移，旧词元匹配不再作为普通新规则入口。
- **上游对齐适配**：在 PiliPlus 代码基础上维护屏蔽功能，尽量降低与上游后续同步的冲突面。

PiliAvalon 也继承 PiliPlus 已有的播放、搜索、动态、评论、收藏、稍后再看、多账号、缓存、WebDAV 设置备份等基础客户端能力。具体能力以当前 APK 实际表现为准。

## 应用预览

以下图片为通用客户端界面预览，不代表所有屏蔽设置界面都已配套截图。

<div align="center">
  <img src="assets/screenshots/510shots_so.png" width="32%" alt="home preview">
  <img src="assets/screenshots/174shots_so.png" width="32%" alt="search preview">
  <img src="assets/screenshots/850shots_so.png" width="32%" alt="media preview">
  <br>
  <img src="assets/screenshots/main_screen.png" width="96%" alt="main screen preview">
</div>

## Roadmap

- 完善屏蔽规则的用户引导、提示文案与更多场景覆盖。
- 继续跟进 PiliPlus 上游更新，在不破坏已验证屏蔽能力的前提下同步必要修复。
- 后续新阶段能力将单独规划范围与验收标准。

## 从源码构建

本项目使用 Flutter。请先安装仓库要求的 Flutter / Dart 环境，然后执行：

```bash
flutter pub get
flutter test test/features/shielding
flutter test test/pages/setting/models/shielding_settings_test.dart
flutter analyze --no-fatal-infos
flutter build apk --release --split-per-abi
```

构建产物通常位于 `build/app/outputs/flutter-apk/`。本地构建不会自动代表正式发布；正式版请以 GitHub Release 页面为准。

## 开源与致谢

PiliAvalon 基于 [PiliPlus](https://github.com/bggRGjQaUbCoE/PiliPlus) 开发，并感谢 PiliPlus、PiliPalaX、PiliPala 及相关开源社区的长期工作。本项目不代表上游项目背书。

感谢以下项目与生态：

- [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)
- [flutter_meedu_videoplayer](https://github.com/zezo357/flutter_meedu_videoplayer)
- [media-kit](https://github.com/media-kit/media-kit)
- [dio](https://pub.dev/packages/dio)
- Flutter 与 Dart 开源生态

## 上游项目

- PiliPlus: <https://github.com/bggRGjQaUbCoE/PiliPlus>

## 声明

PiliAvalon 是第三方客户端项目，仅用于学习、研究与个人使用。项目不提供破解内容，不提供对第三方平台服务条款的规避承诺。请自行确认使用方式符合所在地法律法规及相关平台规则。

## 许可证

本仓库使用 [GNU General Public License v3.0](LICENSE)。

## Star History

<a href="https://www.star-history.com/#CometDash77/PiliAvalon-Worksite&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=CometDash77/PiliAvalon-Worksite&type=Date&theme=dark">
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=CometDash77/PiliAvalon-Worksite&type=Date">
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=CometDash77/PiliAvalon-Worksite&type=Date">
 </picture>
</a>
