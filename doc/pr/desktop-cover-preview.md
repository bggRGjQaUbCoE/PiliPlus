# 桌面端视频封面悬停预览 PR

## 提交信息

- 目标仓库：`bggRGjQaUbCoE/PiliPlus`
- 目标分支：`main`
- 来源仓库：`0x535a/PiliPlus`
- 来源分支：`feat/desktop-cover-preview`
- 拆分基线：`e3aff4435e0df6d703b359b6999c6aa41a4fd678`
- 建议标题：`feat: 支持桌面端视频封面悬停预览`
- 对比入口：<https://github.com/bggRGjQaUbCoE/PiliPlus/compare/main...0x535a:feat/desktop-cover-preview>

分支从上游 `main` 新建，提取 `deploy` 中的封面预览功能，并修复预览播放器的异步竞态。未带入国际化、Apple 播放/PiP、打包配置和依赖变更。旧的 `cover_preview` 分支和 `deploy` 均保留。

以下“PR 正文”可复制到 GitHub。本文中的实机检查尚未执行，完成后可更新验证说明。当前未创建 PR。

## PR 正文

### 功能说明

桌面端浏览视频列表时，鼠标停留在视频卡片封面上即可静音预览视频，减少反复打开详情页的操作。

- 支持横版、竖版视频卡片，限 Windows、macOS、Linux。
- 默认开启，悬停 0.5 秒后触发；播放设置中可关闭，或将延迟设为 0.1–3.0 秒。
- 优先选择低清视频流，同画质优先 AVC；只播放视频，不播放音频。
- 保持视频原始比例和封面圆角，预览层使用 200ms 淡入淡出。
- 预览请求使用匿名账号，不借用用户配置的播放账号；预览组件不发送观看心跳。
- 多张卡片共用一个预览播放器。鼠标移出后停止预览，关闭设置后释放播放器。
- 按卡片已有类型信息排除直播、课程、跳转内容等不适合预览的条目。

### 实现说明

新增封面预览组件与控制器，接入现有两类视频卡片。为 CID 查询和播放地址接口增加可选的显式账号参数，并在 DRM 回退及 UGC 转 PGC 重试时保留该参数；未指定账号的调用沿用现有逻辑。

播放器初始化、打开、停止、销毁按顺序执行，并在异步操作前后检查当前请求。快速切换卡片、初始化时移出、播放中关闭设置时，旧请求不会重新启动预览或停止新卡片的播放。卡片复用为其他视频时会取消旧请求，初始化失败时也会释放已创建的原生播放器。

新增回归测试覆盖控制器竞态，以及接口回退时账号参数的保留。

### 验证结果

验证环境：macOS，Flutter 3.47.9，Dart 3.13.7。

- 新增测试：8 项全部通过。
  ```sh
  flutter test --no-pub test/http/preview_account_test.dart test/common/widgets/video_cover_preview_controller_test.dart
  ```
- 相关文件静态分析：通过，无问题。
  ```sh
  flutter analyze --no-pub lib/common/widgets/video_card lib/http/search.dart lib/http/video.dart lib/pages/setting/models/play_settings.dart lib/utils/storage_key.dart lib/utils/storage_pref.dart test/http/preview_account_test.dart test/common/widgets/video_cover_preview_controller_test.dart
  ```
- 全量 `flutter test --no-pub`：39 项通过、3 项失败。已在独立的上游基线 `e3aff4435` 中复现相同的 3 项失败：账号删除测试 2 项因 `GStorage.setting` 未初始化失败；窗口位置测试 1 项的越界位置计算与预期不符。
- 全量 `flutter analyze --no-pub`：39 条 info 提示，与上游基线逐条一致，无新增提示。
- `git diff --check`：通过。

自动化测试使用模拟的播放器和 HTTP 响应；尚未验证真实 B 站播放地址、登录账号观看历史及三个桌面平台的实际播放效果，也未执行桌面应用构建。

## 提交前建议手工检查

- [ ] 横版、竖版卡片悬停触发预览，封面圆角正确，点击仍进入原视频。
- [ ] 横屏、竖屏视频比例正确，预览始终静音。
- [ ] 快速移入移出、连续切换多张卡片、滚动复用卡片后无串播。
- [ ] 播放中关闭预览能停止并释放播放器，重新开启可正常预览。
- [ ] 延迟调整、重置、取消及重启后的设置保存符合预期。
- [ ] 网络失败、视频不可用时保留封面，后续卡片仍可正常预览。
- [ ] 登录账号预览后，其观看历史未因预览而新增记录。
- [ ] Windows、macOS、Linux 的实际播放效果；移动端原有卡片显示与点击正常。
- [ ] 补充一段悬停预览录屏，展示触发、移出和设置入口。
