# Worker 3 候选分析：长按 UI / 设置分类

> **日期**: 2026-05-31
> **状态**: 候选分析 — 不得标 green
> **对应 Prompt**: 设计院仓库 `records/worksite-communications/2026-05-31-reasonix-phase-1-shielding-worker-prompts.md` #3

---

## 一、现状盘点

### 1.1 现有长按交互

| 触发点 | 文件 : 行 | 行为 |
|---|---|---|
| 视频卡片 (纵向) | `video_card_v.dart:85` | 弹出 `showRecommendationDialog` → 添加标题/UP主/推荐理由规则 |
| 视频卡片 (横向) | `video_card_h.dart:33` | 同上 |
| UP主名 (视频页) | `ugc/view.dart:791,917` | 弹出 `showUpDialog` → UID/关键词规则 |
| 评论文本 | `reply_item_grpc.dart:1143-1301` | 弹出 `showTextDialog` → 关键词规则（按钮触发，非标准长按） |
| **规则列表页** | `shielding_settings/view.dart` | 长按某条规则 → `_deleteRule` → 确认删除对话框 |

### 1.2 现有设置页面结构

```
ShieldingSettingsPage
├── 全局屏蔽开关 (globalEnabled)
├── 推荐流屏蔽开关 (recommendationEnabled)
├── 评论屏蔽开关 (commentEnabled)
├── 规则入口 → 新增规则编辑器 (dialog)
├── 错误提示 (loadErrors)
└── 规则列表 (按 updatedAt 倒序)
    └── 每条: 图标 + 标题 + 副标题 + 启用 Switch + tap编辑 + **长按→仅删除**
```

规则编辑器（`_openEditor`）是一个模态 dialog，包含类型/匹配方式/作用范围/动作/启用 四个 dropdown + 一个 text field。

### 1.3 ShieldRuleSource 已定义未暴露

```dart
enum ShieldRuleSource { manual, quickAction, imported }
```

- `addQuickActionRule` 已正确设置 `source: ShieldRuleSource.quickAction`（`shielding_store.dart:169`）
- 序列化/反序列化均支持（`shielding_models.dart:104-105`）
- **但设置页面完全不展示来源标签，不支持按来源过滤/分组**

---

## 二、候选 A：规则列表长按增强

**现状**：规则列表每项长按 → 删除（无其他选择）

**候选方案**：长按弹出 BottomSheet / PopupMenu

```
┌─────────────────────────────────────┐
│ 屏蔽关键词: "测试"                     │
│ 推荐 / 包含文字 / 已启用               │
├─────────────────────────────────────┤
│ ✏️  编辑规则                          │
│ 🔄  切换启用/停用                      │
│ 📋  复制模式串                        │
│ 🔁  创建相似规则（同 type/scope）       │
│ 📂  移动到分类...                      │
│ 🗑️  删除规则                          │
└─────────────────────────────────────┘
```

**收益**：
- 编辑目前需要 tap → 弹 dialog，长按直达减少步骤
- 切换启用需要滑动狭小的 Switch，长按菜单更易触碰
- 「创建相似规则」复用当前 type/scope/action 快速追加

**风险**：低 — 纯 UI 层，不改变数据模型

**涉及文件**：`lib/pages/shielding_settings/view.dart`

---

## 三、候选 B：评论区长按统一化

**现状**：评论区快速屏蔽入口分散，无统一长按手势

**候选方案**：评论列表项（`reply_item_grpc.dart`）长按 → QuickAction sheet

```
长按评论项 →
┌─────────────────────────────────────┐
│ 📛 屏蔽该用户 (UID: 12345)            │
│ 📝 屏蔽关键词: 评论内容片段             │
│ 🔇 屏蔽此 Tag（如有）                  │
├─────────────────────────────────────┤
│ 管理屏蔽规则 → 跳转设置                 │
└─────────────────────────────────────┘
```

**收益**：
- 与视频卡片的长按交互模式一致（`VideoCardShieldQuickAction`）
- 减少用户寻找屏蔽入口的认知成本

**风险**：中 — 评论列表项已有潜在长按手势（复制/举报），需协调不冲突

**涉及文件**：`lib/pages/video/reply/widgets/reply_item_grpc.dart`

---

## 四、候选 C：设置规则分类与分组

**现状**：规则列表一维平面排列，不区分类型/来源

### 方案 C1 — 按类型分段 Tab

```
┌─── 全部 ──┬── 关键词 ──┬── UID ──┬── 分区 ──┬── 标签 ──┐
│                                                       │
│  Keyword rule 1                   启用  [🔘]         │
│  Keyword rule 2                   启用  [🔘]         │
└───────────────────────────────────────────────────────┘
```

### 方案 C2 — 按来源折叠分组

```
┌───────────────────────────────────────────┐
│ ▼ 手动添加 (3)                             │
│   rule A                                   │
│   rule B                                   │
│ ▼ 快捷操作 (12)                            │
│   rule C                                   │
│   rule D                                   │
│ ▼ 导入 (0)                                 │
└───────────────────────────────────────────┘
```

### 方案 C3 — 搜索 + 过滤栏

```
┌───────────────────────────────────────────┐
│ 🔍 搜索规则...    [全部|关键词|UID|...] ▼  │
├───────────────────────────────────────────┤
│ 匹配结果列表                               │
└───────────────────────────────────────────┘
```

**收益**：
- 规则数量增多时（12+）平面列表不可管理
- 区分快捷操作自动添加的规则与手动精设的规则
- 搜索功能对大规则集必不可少

**风险**：低 — 全部 UI 组合，store 已有 `source` 和 `type` 字段

**涉及文件**：`lib/pages/shielding_settings/view.dart`, `lib/pages/setting/models/shielding_settings.dart`

---

## 五、候选 D：ShieldRuleSource 来源标签暴露

**现状**：`ShieldRuleSource` 枚举完整，store 写入正确，序列化/反序列化支持完整 — **只有 UI 不展示**

**候选方案**：在规则列表项的副标题/图标旁标记来源标签

```
规则标题行                      [手动] [🔘]
规则标题行                      [快捷] [🔘]
```

或使用不同颜色的图标区分来源。

**收益**：零数据模型改动，纯展示增强，帮助用户理解规则从何而来

**风险**：无

**涉及文件**：`lib/pages/setting/models/shielding_settings.dart`（`shieldRuleSubtitle`）

---

## 六、候选 E：规则列表批量操作

**现状**：规则只能单条编辑/删除/切换

**候选方案**：进入批量选择模式（类似 iOS 编辑列表）

```
[完成] [全选] [批量删除] [批量启用/停用]
─────────────────────────────────────
☐ 规则 A
☐ 规则 B
☒ 规则 C
```

**触发方式**：导航栏长按「编辑」/ FAB 长按切换模式

**收益**：清理大量过期规则时避免逐条操作

**风险**：中 — 需管理选中状态，Store 层需增加 `deleteRules`/`batchUpdate` 方法

**涉及文件**：`lib/pages/shielding_settings/view.dart`, `lib/features/shielding/shielding_store.dart`

---

## 七、候选 F：长按 Toast 反馈统一化

**现状**：快速添加规则后 Toast 文案不统一，某些入口静默无反馈

**候选方案**：
- 成功：`已屏蔽「XXX」` + 可选 SnackBar 撤销（3s undo）
- 已存在：`已存在「XXX」` + 跳转编辑链接
- 失败：显示具体错误

**收益**：用户操作信心提升，undo 降低误操作风险

**风险**：低 — Toast/SnackBar 层改动

---

## 八、优先级建议

| 优先级 | 候选 | 理由 |
|---|---|---|
| **P0** | A（长按菜单）+ D（来源标签） | 现有体验最差的两个点，改动最小 |
| **P1** | C（设置分类分组） | 规则增多后的必选项，可选最小 C3 起步 |
| **P2** | B（评论区长按） | 需协调现有手势 |
| **P3** | E（批量操作）+ F（SnackBar 撤销） | 高价值但非阻塞 |

---

## 九、共同约束

与 Worker 1/2/4 的共同边界：
1. **只产候选分析，不得标 green** — 本文件全篇为分析，不涉及实现交付
2. 如需实现，依赖 `design-institute` 侧确认方向后再出计划
3. 不破坏现有规则序列化格式（`shielding_store.dart` JSON 结构不变）
