# Outcome

把作者主页视频列表的「按播放量筛选」输入方式从「预设 Chip + 自定义对话框」改为触控滑块输入 + 显式确认按钮，消除「调整了数量但没有变化」的困惑。

# Scope

- 改造 `MemberVideoFilterDialog`（`lib/pages/member_video/widgets/member_video_filter_dialog.dart`）：移除最小/最大播放量的预设 Chip 与自定义输入对话框，改为 `RangeSlider`（范围 0–500万，单位万）+ 两端可点击的数字标签输入。
- 新增「确认」图标按钮：点击 = 把当前滑块/开关草稿写入过滤条件，关闭弹窗，触发列表按新条件重新过滤。
- 非确认关闭（下滑 / 点遮罩 / 系统返回）= 撤销草稿，过滤条件保持弹窗打开前的状态。
- 保留「已观看」两个开关（隐藏已看完 / 隐藏看过未看完）与「清除所有过滤条件」按钮。
- `MemberVideoFilter` 数据模型字段保持不变（`enableMinPlay`/`minPlay`/`enableMaxPlay`/`maxPlay`/`hideCompleted`/`hideInProgress`），由 UI 层做滑块端点 ↔ 字段映射。
- 新增/更新对应单测与 widget 测试。

# Non-goals

- 不改服务端请求与分页加载逻辑（`customGetData` / `customHandleResponse` / `_autoLoadMoreLoop`）。
- 不改「已观看」判定逻辑（`isCompleted` / `isInProgress`）。
- 不改搜索页或其他页面的筛选 UI。
- 不改视频卡片、header 其它按钮（排序、集数、计数）。
- 不引入新依赖。

# Acceptance examples

- A1 滑块最左端=0=不限制下限（`enableMinPlay` 关闭）；最右端=500万=不限制上限（`enableMaxPlay` 关闭）；拖到中间值=启用对应阈值，隐藏区间外的视频。
- A2 滑块两端数字实时显示当前阈值（万/亿格式）；点击数字弹输入框，万为单位且兼容 `10.5万` / `2亿`；左端输 `0` / `不限` → 不限制下限，右端输 `≥500万` / `不限` → 不限制上限。
- A3 点「确认」图标：草稿写入 `filter`，关闭弹窗，列表按新条件重新过滤（修复「调了没反应」）。
- A4 非确认关闭（下滑 / 遮罩 / 返回）：不应用草稿，`filter` 保持打开前状态。
- A5 最小阈值不得大于最大阈值：拖动 / 输入越界时自动钳制，保持区间合法。
- A6 「已观看」两开关行为不变（隐藏已看完 / 隐藏看过未看完）。
- A7 「清除所有过滤条件」：滑块归位（左 0 / 右 500万）、开关全关、确认后列表恢复全量。
- A8 过滤激活时筛选图标高亮、过滤后空态自动补载 / 到底提示行为不变。
- A9 `MemberVideoFilter.shouldHide` 语义不变（min / max / null view），现有单测继续通过；新增滑块端点 ↔ 字段映射与区间钳制的测试。

# Constraints and invariants

- 内部数值仍用原始 `int`（1万=10000），仅 UI 显示 / 输入用万单位。
- 单位解析复用 `NumUtils.parseNum`，格式化复用 `NumUtils.numFormat`。
- 滑块范围上界常量 `5000000`（500万）；端点 0 / 500万 折叠为「不启用」语义。
- 弹窗沿用现有 BottomSheet + 搜索页 Material 风格。

# Decisions

- 工作区：新 worktree（基于 main，与现有 TrollStore worktree 隔离并行）。
- `RangeSlider` 拖动范围 0–500万，最右端=不限上限，最左端=不限下限。
- 确认图标点击=应用并关闭弹窗。
- 输入单位=万，兼容 `10.5万` / `2亿`（沿用 `parseNum`）。
- 非确认关闭（下滑 / 遮罩 / 返回）= 撤销草稿、不应用：用户明确要求「确认图标一键应用」，故「确认」是唯一生效动作；非确认关闭保持弹窗打开前的过滤条件，使「确认」成为可靠的单一生效入口，直接修复「调了没反应」。草稿用独立局部状态承载，只在确认时写回 `filter`，`whenComplete` 触发的 `applyFilter()` 对未变更的 `filter` 幂等。

# Open questions

（无；Shape 已由用户确认。）

# Verification expectations

- 单测：滑块端点 ↔ `filter` 字段映射、区间钳制、`shouldHide` 语义不变（更新 `test/pages/member_video/video_filter_test.dart` 或新增映射测试）。
- widget 测试：确认按钮应用草稿并关闭、取消关闭不应用。
- 人工：作者主页打开筛选弹窗，拖滑块 → 点确认 → 列表变化；下滑取消 → 列表不变。
