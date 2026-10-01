# Streaming Accelerator 验证摘要

日期：2026-10-01。开发分支：`feature/streaming-accelerator`。

## 已实现

- Smart CDN：默认 OFF；有限 Range 探测、EWMA、低缓冲确认、收益门槛、冷却、资源指纹校验与原源恢复。
- V1b：高码率视频探测优先；区分切线与缓冲恢复；补齐 Android 插件注册构建检查。
- V1c：独立实验性单连接视频 Range 代理；音频保持原路径；实际转发计量、seek 取消与原源恢复。该模式不做 CDN 切换，不提供多 Range 并发。
- 原生依赖版本、直播、下载、远端投屏和上游仓库未修改。

## 本地结果

|检查|结果|
|---|---|
|原 V1b 策略与设置测试|39 项通过，exit 0|
|V1c 完整加速模块测试|61 项通过，exit 0|
|新增/修改的模块、设置页面、播放器控制器和测试 analyzer|No issues found，exit 0|
|固定 Windows mpv 合成 EDL 冒烟|代理视频 + 直连音频，时长 60 秒、seek 30 秒、切回远端、暂停、1.25 倍速；代理请求 5 次、错误 0|
|独立副本回滚|10 个原文件恢复、4 个新增文件移除；原 39 项测试通过|
|Android debug APK|ZIP CRC、插件注册、签名和 16 KiB 页对齐检查通过|

V1c 测试 APK SHA256：`48f7c18636ed477927ab2d983e9d18a6cbe5039ab5ec96a4db9d332700e40a1b`。
本地 APK 和原始日志不纳入源码版本控制。

## 复跑

使用项目固定的 Flutter/Dart 版本及既有 common SDK patches，执行：

```sh
flutter test --no-pub test/services/video_accelerator
dart analyze lib/services/video_accelerator
dart analyze lib/pages/setting/pages/streaming_accelerator.dart
dart analyze lib/plugin/pl_player/controller.dart
dart analyze test/services/video_accelerator
```

Windows native 测试另需 `PILIBOOST_LIBMPV`、`PILIBOOST_NATIVE_FIXTURE` 和原插件 event-loop DLL。未配置时 native 测试跳过，不等于通过。合成媒体由 `tool/phase1/create_native_fixture.py` 生成。
Android 构建使用 `tool/phase1/build_android_test.ps1`，显式传入本地 SDK 和 Python 路径。

## 实机边界

用户反馈 V1b 同一视频复测不再卡顿；截图显示该次没有切线，尚未进行受控 OFF/ON 对照，未归因为确定的加速收益。
V1c 尚待 Android 真视频、长播、后台/PiP、错误恢复与网络切换验证。Windows 合成测试不替代其他平台实测。
后续在本阶段稳定后实现 V2 bounded cache/chunk scheduler 与动态并发，再推进 V3 多 CDN。
