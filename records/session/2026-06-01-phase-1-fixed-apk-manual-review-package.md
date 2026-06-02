# Phase 1 Fixed APK Manual Review Package

Audience classification: dual-use.

Date: 2026-06-01
Package owner: Codex
Repository boundary: CometDash77/PiliAvalon-Worksite
Manual review target: `phase-1-prebuild.26714387748`
Status: ready for user physical-device review; Phase 1 not green

## 中文决策摘要

这次手工验收请不要再测旧包 `eda5bee71...`，改测固定签名预构建包：

- 版本：`phase-1-prebuild.26714387748`
- GitHub run：`26714387748`
- commit：`e8e96787dabb5403348b5c1d71f7ba40970b0dcc`
- release：`https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26714387748`
- 默认 APK：`PiliAvalon_android_2.0.7-e8e96787d+5049_arm64-v8a.apk`

如果手机不是 arm64，请改用对应 ABI 的 APK，并记录原因。这个包已有 Codex 复核过的构建和签名证据，但这不等于手工验收通过。Phase 1 仍然是黄灯，必须等真实设备复测、原始反馈记录、问题分类和明确用户验收结论之后才能继续推进。

如果这次复测发现产品 bug 或明显回归，不要继续宣称 Phase 1 可以关闭；需要先记录原始反馈，然后由用户明确授权新的修复、构建、复测循环。

## User Review Checklist

请在真实 Android 设备上测试，并尽量保留截图或录屏。反馈可以直接按下面项目写，原文会作为验收证据保留。

1. APK 安装
   - 安装的是哪个 APK 文件？
   - 是覆盖安装，还是卸载后安装？
   - 如果覆盖安装失败，报错是什么？

2. 启动
   - 是否能打开 app？
   - 是否有白屏、闪退、卡死？

3. UP/用户屏蔽
   - 长按视频卡片后，UID 屏蔽是否可用？
   - 用户关键词是否只影响用户身份匹配，而不是普通标题/内容关键词？
   - 交互是否仍然回退到旧逻辑或比 `26707279023` 更差？

4. 标签/推荐流屏蔽
   - 标签规则在推荐流中是否有可见效果？
   - 相关视频中是否有可见效果？
   - 如果你认为没有效果，请记录具体规则和测试视频/页面。

5. 旧规则兼容
   - 如果设备上还保留旧规则状态，请检查旧规则是否被新屏蔽系统接管。
   - 如果旧规则基线已经因为卸载或清数据丢失，请写明“无法测试旧规则兼容，因为旧基线已丢失”。这个门禁不能算通过。

6. 设置页分类
   - 设置页分类和入口是否清楚？
   - 是否方便整理规则？

7. 评论屏蔽
   - 评论屏蔽是否符合预期？
   - “屏蔽整条评论文本”是否仍然出现，是否仍然让你觉得没有意义？

8. 签名/覆盖安装
   - 如果设备上已有同包名、同签名的旧版本，请测试直接覆盖安装。
   - 如果没有同签名旧版本，请记录“没有同签名基线，覆盖安装门禁受限/无法证明”，不要写成通过。

9. 总结
   - 这次是否可以接受 Phase 1？
   - 如果不能，请列出仍然阻塞的条目。

## English Technical Body

Use this package for user-side physical-device review of the fixed signed APK only. Do not use it as a release, merge, or green-status decision.

Reviewed build baseline:

- Reasonix monitor candidate: `records/reasonix/monitor/2026-05-31-phase-1-release-build-26714387748-monitor.md`
- Codex review: `records/reasonix/review/2026-05-31-phase-1-release-build-26714387748-codex-review.md`
- Release tag: `phase-1-prebuild.26714387748`
- Run ID: `26714387748`
- Commit: `e8e96787dabb5403348b5c1d71f7ba40970b0dcc`
- Signing fingerprint: `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

APK priority:

1. `PiliAvalon_android_2.0.7-e8e96787d+5049_arm64-v8a.apk`
2. `PiliAvalon_android_2.0.7-e8e96787d+5049_armeabi-v7a.apk` only if the device requires 32-bit ARM.
3. `PiliAvalon_android_2.0.7-e8e96787d+5049_x86_64.apk` only for x86_64 Android targets.

Evidence to preserve:

- Raw user feedback, unchanged and in the original language.
- APK filename, release tag, and run ID.
- Device model and Android version if available.
- Install result and whether install was an over-install or a clean install.
- Launch result.
- Screenshots or video if available.
- Any baseline limitation, especially for #7 legacy compatibility and #10 cover-install.

Post-review handling:

- Persist raw user feedback unchanged under `records/session/...`.
- If classification is useful, ask Reasonix to classify findings into accepted, failed, blocked, and deferred cards under `records/reasonix/...`.
- Codex must review any Reasonix classification artifact before citing it.
- If a product bug is reported, stop Phase 1 closure and request explicit authorization for a new fix/build/retest cycle.

Phase 1 remains not green until fixed APK build evidence is reviewed, physical-device retest evidence is persisted, any Reasonix classification is Codex-reviewed, no product bug remains open, and user/client acceptance is explicitly recorded.
