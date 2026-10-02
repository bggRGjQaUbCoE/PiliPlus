# 作者主页视频列表 · 播放量筛选（完整目标规格）

本规格描述归档后 `member-video-filter` 能力的完整行为（修改后）。

## 能力概述

在作者主页视频列表（`MemberVideo`，复用于 contribute 的 `video` / `charging_video` / `season_video` / `series` 等 tab）的 header 筛选图标点击后，弹出一个 BottomSheet。用户通过触控滑块设置播放量区间（最小 / 最大），并通过显式确认按钮应用过滤；列表按条件在客户端本地过滤已加载的视频，过滤后为空时自动补载下一页。

## 数据模型

`MemberVideoFilter`（`lib/pages/member_video/video_filter.dart`）保持字段不变：

- `bool enableMinPlay`：是否启用最小播放量阈值（隐藏低于阈值）。
- `int minPlay`：最小播放量阈值（原始整数，1万=10000）。
- `bool enableMaxPlay`：是否启用最大播放量阈值（隐藏高于阈值）。
- `int maxPlay`：最大播放量阈值（原始整数）。
- `bool hideCompleted`：隐藏已看完。
- `bool hideInProgress`：隐藏看过未看完。
- `static const int playSliderMax = 5000000`（新增）：滑块上界，=500万，同时是「不限制上限」的端点语义值。

筛选判定 `shouldHide(SpaceArchiveItem)` 语义不变：

- `enableMinPlay` 且 `item.stat.view != null` 且 `view < minPlay` → 隐藏。
- `enableMaxPlay` 且 `item.stat.view != null` 且 `view > maxPlay` → 隐藏。
- `hideCompleted` 且 `isCompleted(item)` → 隐藏。
- `hideInProgress` 且 `isInProgress(item)` → 隐藏。
- `view == null` 时播放量阈值不隐藏该条（保留，交由「已观看」开关决定）。

## UI 结构

`MemberVideoFilterDialog.show(BuildContext, MemberVideoFilter)` 仍为 `showModalBottomSheet` + `StatefulBuilder`，宽度约束沿用 `min(640, shortestSide)`。

弹窗内容自上而下：

1. 标题「播放量筛选（万）」。
2. `RangeSlider` 区间控件：
   - 范围 `[0, playSliderMax]`（0 – 500万），连续滑块（不设 `divisions`，保证任意万级精度可拖动与输入一致���。
   - 左端 thumb = 最小阈值，右端 thumb = 最大阈值。
3. 滑块两端数字标签（横向 Row，左标签靠左、右标签靠右，可点击）：
   - 左标签文本：`start == 0` → 「不限」（不限制下限）；否则 `NumUtils.numFormat(start)`。
   - 右标签文本：`end == playSliderMax` → 「不限」（不限制上限）；否则 `NumUtils.numFormat(end)`。
   - 点击任一标签 → 弹出数字输入对话框（见下）。
4. 「已观看」区段：两个 `SwitchListTile`（`hideCompleted` / `hideInProgress`），行为不变。
5. 底部操作行：
   - 左：「清除所有过滤条件」`TextButton`（仅 `hasActiveFilter` 时显示）。
   - 右：「确认」`IconButton`（check 图标，`Icons.check`）。

### 滑块端点 ↔ filter 字段映射

弹窗内维护草稿 `RangeValues draft(start, end)`（double，单位原始整数，范围 `0..playSliderMax`）。

打开弹窗时由当前 `filter` 初始化草稿：

- `draft.start = filter.enableMinPlay ? filter.minPlay.toDouble() : 0.0`
- `draft.end = filter.enableMaxPlay ? filter.maxPlay.toDouble() : playSliderMax.toDouble()`

点「确认」时由草稿写回 `filter`：

- `start == 0` → `enableMinPlay = false`（`minPlay` 保持原值或置默认，不影响判定）。
- `start > 0` → `enableMinPlay = true`，`minPlay = start.toInt()`。
- `end == playSliderMax` → `enableMaxPlay = false`。
- `end < playSliderMax` → `enableMaxPlay = true`，`maxPlay = end.toInt()`。
- 两个「已观看」开关直接写回对应字段。

### 区间钳制

拖动 `RangeSlider` 时 `onChanged` 保证 `start <= end`（Flutter `RangeSlider` 自身保证 thumb 不交叉）；通过数字输入设置单端时：

- 左端输入值 `v`：若 `v >= draft.end`，钳制为 `draft.end`（或当右端=不限即 `playSliderMax` 时允许任意 `>0` 值，此时 `end` 仍为 `playSliderMax`）。
- 右端输入值 `v`：若 `v <= draft.start`，钳制为 `draft.start`。
- 输入越界（>500万）按 `playSliderMax` 处理（=不限上限）；输入 0 / 空 / 「不限」按对应端点「不限制」处理。

### 数字输入对话框

点击数字标签弹出 `AlertDialog`：

- `TextField`，`keyboardType: TextInputType.number`，`autofocus: true`。
- hint：「输入万为单位数字，如 10.5万 / 2亿；0 或不限 表示不限制」。
- 预填当前端的显示值（万格式字符串，如「10万」；端点为「不限」时预填空）。
- 解析：`NumUtils.parseNum(text)` 得原始整数 `v`。
- 「取消」：关闭，不修改草稿。
- 「确定」：按区间钳制规则更新草稿对应端，关闭。

## 触发与生效

- 「确认」按钮 `onPressed`：把草稿写回 `filter`（按映射），`Navigator.pop()` 关闭弹窗。外层 `.whenComplete(_controller.onFilterChanged)` 随后触发 `applyFilter()`，列表按新条件过滤；过滤后为空且未到底时 `_autoLoadMoreLoop()` 自动补载。
- 非确认关闭（下滑 / 遮罩 / 返回 / 「取消」类操作）：不写回 `filter`，`whenComplete` 触发的 `applyFilter()` 用旧 `filter` 值重新过滤（幂等，列表不变）。
- 「清除所有过滤条件」：草稿与开关归位（`start=0` / `end=playSliderMax` / `hideCompleted=false` / `hideInProgress=false`），随后由用户点「确认」应用，或直接调用 `filter.reset()` 并关闭弹窗（实现择一，需保证列表恢复全量）。

## header 与空态

- header 筛选图标：`filterActive` 为 true 时显示 `Icons.filter_list` 并高亮（primary），否则 `Icons.filter_list_off`。
- 过滤后空态：`_buildFilteredOutAutoLoading`（loading / 可调整提示）、`_buildFilteredOutEnd`（到底无匹配），均保留「调整过滤条件」入口，行为不变。

## 验收映射

- A1 端点语义与映射
- A2 数字标签显示与点击输入
- A3 确认按钮应用并关闭、列表重新过滤
- A4 非确认关闭不应用
- A5 区间钳制
- A6 已观看两开关不变
- A7 清除并归位
- A8 图标高亮与空态不变
- A9 `shouldHide` 语义与单测不破坏
