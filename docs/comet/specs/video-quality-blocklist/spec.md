# 播放画质屏蔽（完整目标规格）

本规格描述归档后 `video-quality-blocklist` 能力的完整行为。

## 能力概述

设置页提供一份全局「屏蔽画质」多选列表。被勾选的画质从**播放路径**的画质选择中剔除：自动选档（播放初始化、半屏 → 全屏切换）不会选中它，播放器两处手动画质菜单不再列出它，`findVideoByQa` 的兜底也不会落到它。**下载路径完全不受影响**：下载面板的目标画质下拉仍列出全部画质，下载选档仍走未屏蔽逻辑。

屏蔽一个画质的实际效果是「跳过它并在同一选档规则内降一档」：屏蔽 1080P 高码率（112）后，能选 1080P60 帧（116）就选 116；只有 112 可用时选 1080P 高清（80）；本来就会选 80 时仍然选 80，不会被升档到 116。

## 数据模型

### 画质枚举（不变）

`VideoQuality`（`lib/models/common/video/video_quality.dart`）字段与取值不变：

| code | desc | shortDesc |
| --- | --- | --- |
| 129 | HDR Vivid | HDR Vivid |
| 127 | 8K 超高清 | 8K |
| 126 | 杜比视界 | 杜比 |
| 125 | HDR 真彩 | HDR |
| 120 | 4K 超高清 | 4K |
| 116 | 1080P 60帧 | 1080P60 |
| 112 | 1080P 高码率 | 1080P+ |
| 80 | 1080P 高清 | 1080P |
| 74 | 720P 60帧 | 720P60 |
| 64 | 720P 准高清 | 720P |
| 32 | 480P 标清 | 480P |
| 16 | 360P 流畅 | 360P |
| 6 | 240P 极速 | 240P |

### 屏蔽列表

- 存储键：`SettingBoxKey.blockedVideoQualities`，值为 `List<int>`（画质 code），存入 `GStorage.setting`。
- 读取：`Pref.blockedVideoQualities`（`lib/utils/storage_pref.dart`）返回 `Set<int>`；未设置或类型不符时返回空集合。
- 语义：一份全局列表，WiFi 与蜂窝共用，不按网络分别维护。

### 播放可选择的画质格式列表

`VideoDetailController.selectableVideoFormats`（`lib/pages/video/controller.dart`）：

- 数据源为 `data.supportFormats`。
- 剔除 `Pref.blockedVideoQualities` 命中的项（比较 `FormatItem.quality`）。
- 屏蔽集合为空时返回原列表；顺序保持 `supportFormats` 原顺序（由高到低）。
- `supportFormats` 为 null 时返回空列表。

## 自动选档

### `PlayUrlModel.findAvailableVideoQuality`

签名：`int findAvailableVideoQuality(int preferredQuality, {Set<int> blockedQualities = const {}})`

记 `curHighestVideoQa = dash!.video!.first.quality.code`。

1. `acceptQuality` 非 null 非空，且 `preferredQuality <= curHighestVideoQa`：
   - 候选集 = `acceptQuality` 剔除 `blockedQualities` 命中项后的列表。
   - 候选集非空 → 返回候选中「不超过 `preferredQuality` 的最高 code」，用 `findClosestTarget((e) => e <= preferredQuality, max)`；候选中无一不超过首选时沿用 `findClosestTarget` 的既有兜底（取候选集最大值）。
   - 候选集为空（全部被屏蔽）→ 返回**未剔除时**的 `acceptQuality.findClosestTarget((e) => e <= preferredQuality, max)`，即与旧版完全一致。
2. 否则（`acceptQuality` 为 null / 空，或 `preferredQuality > curHighestVideoQa`）：
   - `blockedQualities` 不含 `curHighestVideoQa` → 返回 `curHighestVideoQa`。
   - `blockedQualities` 含 `curHighestVideoQa`，且 `acceptQuality` 非 null：
     - 允许集 = `acceptQuality` 中未被屏蔽且 `<= curHighestVideoQa` 的项；
     - 允许集非空 → 返回其中的最高 code；
     - 允许集为空 → 返回 `curHighestVideoQa`（退回旧版结果）。
   - `acceptQuality` 为 null → 返回 `curHighestVideoQa`。

`blockedQualities` 缺省为空集合时，第 1 分支与 `acceptQuality` 非空时的旧版逐字节等价；`acceptQuality` 为 null 或空时不再进入 `findClosestTarget`，改为走第 2 分支返回 `curHighestVideoQa`，比旧版更安全。

### 半屏 → 全屏切换

`VideoDetailController.setupFullScreenQualitySwitch` 删除内联的 `findClosestTarget` 选档，改为：

```dart
final targetQa = data.findAvailableVideoQuality(
  fsQa,
  blockedQualities: Pref.blockedVideoQualities,
);
```

「只升不降」判定（`targetQa <= curQa` 时保留当前画质）与后续 `updatePlayer()` 调用保持不变。

### 下载选档（不屏蔽）

`lib/http/download.dart` 中 `response.findAvailableVideoQuality(entry.preferedVideoQuality)` 调用保持不变，不传 `blockedQualities`，因此下载链路完全不受屏蔽影响。

## 手动画质菜单

三处菜单都改用 `videoDetailController.selectableVideoFormats`，并保持各自既有的 `availableQa.contains(item.quality)` 可用性判断：

1. `lib/plugin/pl_player/view/view.dart` 的底部控制栏画质弹窗（`BottomControlType.qa`）：`itemBuilder` 遍历 `selectableVideoFormats`。
2. `lib/pages/video/widgets/header_control.dart` 的 `showSetVideoQa()`：`videoFormat` 取 `selectableVideoFormats`。
3. `lib/plugin/pl_player/view/view.dart` 的 `_screenshotWebp()` 动态截图「选择画质」弹窗：`itemBuilder` 遍历 `selectableVideoFormats`。

菜单项被选中后的链路（`cacheVideoQa` → `currentVideoQa.value` → `updatePlayer()` → `persistVideoQa(quality)` 与 toast）不变。

## 兜底画质

`VideoDetailController.findVideoByQa(int qa)` 中 `videoList.isEmpty` 分支：

- 兜底 = `allVideos` 中第一个未被 `Pref.blockedVideoQualities` 命中的项；全部被屏蔽时退回 `allVideos.first`（与旧版一致）。
- 兜底确定后照旧写 `currentVideoQa.value = VideoQuality.fromCode(fallback.id!)` 并返回该 `VideoItem`。

## 设置入口

`lib/pages/setting/models/video_settings.dart` 的视频设置列表中，在「全屏蜂窝网络画质」之后插入：

- 类型：`NormalModel`。
- 标题：`屏蔽画质`。
- `leading`：`Icon(MdiIcons.eyeOffOutline)`。
- 副标题：
  - 屏蔽集合为空 → `未屏蔽任何画质`。
  - 非空 → `已屏蔽：<desc 列表>`，`desc` 由遍历 `VideoQuality.values`（由高到低）筛选 `blocked.contains(e.code)` 后取 `e.desc` 得到，用 `、` 连接。
- `onTap`：`_showBlockedVideoQaDialog`。

`_showBlockedVideoQaDialog(BuildContext, VoidCallback)`：

```dart
final res = await showDialog<Set<int>>(
  context: context,
  builder: (context) => MultiSelectDialog<int>(
    title: '屏蔽画质',
    initValues: Pref.blockedVideoQualities,
    values: {for (final e in VideoQuality.values) e.code: e.desc},
  ),
);
if (res != null) {
  await GStorage.setting.put(SettingBoxKey.blockedVideoQualities, res.toList());
  SmartDialog.showToast('设置成功');
  setState();
}
```

- 选项覆盖 `VideoQuality.values` 全部 13 档，允许多选，允许取消全部勾选。
- 未设置过时所有项默认未勾选。
- 不为「当前默认画质正好被屏蔽」增加提示、拦截或自动改写：仅自动选档时按本规格降档。

## 行为矩阵

设 `blocked = {112}`，候选集 = `acceptQuality`，`highest` = 视频最高可用档。

| 首选画质 | 视频可用档 | 结果 | 说明 |
| --- | --- | --- | --- |
| ≥ 116 | 116, 112, 80 | 116 | 能上更高帧率就用 |
| 112 | 116, 112, 80 | 80 | 首选档被屏蔽，降一档 |
| ≥ 112 | 112, 80 | 80 | 只有高码率则用高清 |
| 80 | 116, 112, 80 | 80 | 不因屏蔽而升档 |
| ≤ 80 | 112, 80 | 旧版结果 | 剔除后无候选，退回旧版 |
| ≥ 112 | 112, 116 | 80 | 最高可用档被屏蔽，退到不超过它的未屏蔽档 |
| 任意 | 只含 112 | 112 | 剔除后无候选，退回旧版，保证有流可播 |

## 不变量

- 屏蔽集合为空时，播放与下载的画质选择结果必须与实现本能力前完全一致。
- 任何输入下都要返回一个可播放画质，播放不因屏蔽而中断。
- 屏蔽不改变码率、解码格式、CDN、音质、清晰度映射逻辑。
- 下载链路（下载面板下拉、`lib/http/download.dart` 选档、下载记录）不受屏蔽影响。
- `VideoQuality` 枚举与 `LiveQuality` 枚举取值不变。
