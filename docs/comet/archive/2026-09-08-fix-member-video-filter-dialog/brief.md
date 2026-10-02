# 目标

修复作者主页视频列表「播放量筛选」按钮点击无反应的回归：点击 header 筛选图标（及两个空态入口）后，过滤 BottomSheet 能正常弹出，筛选功能恢复可用。行为与既有 `member-video-filter` 能力规格完全一致，不引入任何新行为。

# 范围

- `lib/pages/member_video/widgets/member_video_filter_dialog.dart`：UI 框架依赖从 `flutter/material.dart` 迁移到 `material_ui`。
- `lib/pages/member_video/video_filter.dart`：`RangeValues` 改用 material_ui 版本（与弹窗、RangeSlider 类型一致）。
- `test/pages/member_video/video_filter_test.dart`：同步改用 material_ui 的 `RangeValues`。
- `test/pages/member_video/` 新增一个最小 widget 回归测试：在 material_ui `MaterialApp` + material_ui 本地化代理下 pump 弹窗并断言内容出现。

# 非目标

- 不迁移 `lib/pages/mine/widgets/later_card_item.dart` 与 `lib/pages/setting/pages/double_tap_seek_zone_setting.dart`（二者无弹窗/路由调用，不受本回归影响；其主题一致性属另一潜在问题，留给后续 change）。
- 不改变 `member-video-filter` 能力的任何既有行为（`docs/comet/specs/member-video-filter/spec.md` 不需修改）。
- 不处理其它页面、弹窗或全局配置。

# 验收示例

- A1 点击作者主页视频列表 header 的筛选图标，BottomSheet 正常弹出并显示完整内容（播放量滑块、两端数字标签、「已观看」两个开关、确认按钮），debug 与 release 构建均无异常。
- A2 弹窗内设置过滤条件（拖滑块或数字输入）后点「确认」→ 弹窗关闭、列表按条件过滤、header 图标高亮为 `filter_list`；非确认关闭（下滑 / 遮罩 / 返回）→ 过滤不应用、列表不变。
- A3 点击两端数字标签弹出数字输入对话框，输入如「10.5万」确定后滑块端点更新为 105000；越界 / 交叉输入按既有钳制规则处理。
- A4 过滤后列表为空时的两个空态入口（「调整过滤条件」按钮）同样能正常弹出弹窗。
- A5 member_video 相关文件（弹窗、video_filter、对应测试）不再 import `flutter/material.dart`，统一使用 material_ui；`flutter analyze` 无新增告警；既有与新增测试全部通过。

# 约束与不变量

- `member-video-filter` 能力既有行为不变（端点语义、钳制、确认/非确认关闭、空态入口等，见既有 spec）。
- 不改动其它页面与全局配置；不升级 / 不修改依赖版本。

# 决策

- D1 根因（已查证）：merge f6d4cb359（v2.1.2，2026-08-30）将全 app 迁移到 `material_ui` 包（flutter/material 的完整 fork，自带独立的 `Theme` / `MaterialLocalizations` / `showModalBottomSheet` 等同名但不同类型的 API）。`main.dart` 的 `GetMaterialApp` 注入的是 material_ui 的 `GlobalMaterialLocalizations.delegates`，运行时树里只有 material_ui 的 `MaterialLocalizations`。而 fork 独有的 member_video 弹窗文件未被迁移脚本覆盖（上游不存在这些文件），仍 import `flutter/material.dart` 并调用 flutter/material 的 `showModalBottomSheet`：debug 构建下 `assert(debugCheckHasMaterialLocalizations)` 直接抛异常；release 构建下路由构建时 `MaterialLocalizations.of(context).modalBarrierDismissLabel`（SDK bottom_sheet.dart:464）经 `Localizations.of<MaterialLocalizations>(...)!`（material_localizations.dart:716-718）空断言崩溃 → 整个路由 scope 构建失败，屏幕上无任何可见反应。与「按钮还在、点击无效、弹窗打不开」的现象完全吻合；时间线吻合（v2.1.0+1-20260823 正常 → v2.1.2+1-20260830 失效）。
- D2 修复方式：三个文件整体迁移到 material_ui。material_ui 与 flutter/material 的同名类型（如 `RangeValues`）是不同类型，必须整链一致；material_ui 已导出弹窗所需全部符号（`showModalBottomSheet`、`RangeSlider`/`RangeValues`、`AlertDialog`、`TextField`/`TextInputType`、`SwitchListTile`、`FilledButton`、`InkWell` 等），且与全 app 517 个文件的既有约定一致。这是唯一可行方向，无用户可见行为差异，故不作为用户决定。
- D3 新增最小 widget 回归测试：以 material_ui `MaterialApp` + material_ui 本地化代理 pump `MemberVideoFilterDialog.show`，断言 sheet 内容出现。该测试在旧代码（flutter/material 弹窗）下必然失败，可精确防止回归。

# 待解决问题

（无 —— 用户已于 2026-09-08 确认 Shape 结论，进入 Build。）

# 验证预期

- `flutter analyze` 通过，无新增告警。
- `flutter test test/pages/member_video/` 全部通过（既有单测 + 新增弹窗回归测试）。
- 用户在真机 / 模拟器手动验收 A1-A4（重点：release 构建下点击筛选图标能弹出弹窗并完成一次筛选）。
