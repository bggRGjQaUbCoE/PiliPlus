# Reasonix D — UX / 设置分类页复核

**Date:** 2026-06-01  
**Repo:** `CometDash77/PiliAvalon-Worksite`  
**Branch:** `phase-1-shielding-core`  
**Target commit:** `ce5f6915d`  
**Role:** 只读复核，未修改功能代码。

---

## 1. 已读持久化文件

| # | 文件 |
|---|------|
| 1 | `records/session/2026-05-31-design-institute-phase-1-user-original-feedback.md` |
| 2 | `records/session/2026-05-31-phase-1-manual-acceptance-user-original-feedback.md` |
| 3 | `records/reasonix/auditor/2026-05-30-phase-1-apk-acceptance-scope.md` |
| 4 | `records/reasonix/auditor/2026-05-30-phase-1-evidence-gap.md` |

## 2. 甲方原文

> "我希望是在piliplus上游的那种长按卡片有显示封面的方式魔改，目前的不够美观"  
> "可以，但是我需要设置也的分类页，方便整理"

## 3. 关键代码路径

| 组件 | 路径 | 行为 |
|------|------|------|
| 设置页导航 | `lib/pages/setting/view.dart:65-104` | 8 分类入口，`shieldingSetting` 为其中之一 |
| Shielding 设置页 | `lib/pages/shielding_settings/view.dart` | 单页大表单：3 个开关 + 线性规则列表 + FAB 新增 |
| 水平卡片长按 | `lib/common/widgets/video_card/video_card_h.dart:33-49` | `onLongPress` → `showRecommendationDialog` |
| 垂直卡片长按 | `lib/common/widgets/video_card/video_card_v.dart:85-102` | 同上 |
| 卡片三点菜单 | `lib/common/widgets/video_popup_menu.dart` | 独立 `PopupMenuButton`，与长按并行 |
| 详情页 UP 操作 | `lib/pages/ugc/view.dart:791` | `showUpDialog(upName, upUid)` |
| 详情页标题操作 | `lib/pages/ugc/view.dart:331` | `showTextDialog` type=keyword |
| 快捷规则存库 | `lib/features/shielding/shielding_store.dart` | `addQuickActionRule`，namespace `piliavalon.shielding.v1` |
| 设置类型枚举 | `lib/models/common/setting_type.dart` | 9 个值，`shieldingSetting` 路由 |

## 4. 当前设置页结构

当前 `ShieldingSettingsPage` (`lib/pages/shielding_settings/view.dart`) 是**一个长表单单页**，没有分类、搜索、分组、导入导出、空状态引导：

```
┌──────────────────────┐
│ 全局开关    [Switch]  │
│ 推荐流屏蔽   [Switch]  │
│ 评论屏蔽    [Switch]  │
│ ────────────────────  │
│ 屏蔽规则     [▶]      │
│  ├ 规则 1 [Switch]    │
│  ├ 规则 2 [Switch]    │
│  └ ...              │
│ [+ FAB 新增规则]      │
└──────────────────────┘
```

## 5. 推荐分类页 IA

```
设置 → 屏蔽规则
│
├── 📋 规则概览
│   ├── 总数: 12  启用: 8
│   ├── 按类型: 关键词(5)  UID(3)  标签(2)  分区(2)
│   └── 按来源: 推荐流(8)  评论(4)
│
├── 🔍 规则管理 (独立分类页)
│   ├── [搜索规则...]
│   ├── ── 用户屏蔽 ──
│   │   ├── UID: 546195 [✔]
│   │   └── 用户名: 张三 [✔]
│   ├── ── 标题关键词 ──
│   │   ├── '广告' [✔]
│   │   └── '促销' [✘]
│   ├── ── 标签分区 ──
│   │   ├── 标签: '娱乐' [✔]
│   │   └── 分区: '科技' [✔]
│   └── [+ FAB 新增规则]
│
├── 📥 数据
│   ├── 从旧系统导入
│   └── 导出规则
│
└── 🔧 快速操作记录
    ├── 最近添加: UID 546195 (来自长按)
    └── [清空历史]
```

## 6. 长按卡片交互现状

- `VideoCardH`（水平卡）和 `VideoCardV`（垂直卡）的长按均调用 `VideoCardShieldQuickAction.showRecommendationDialog`
- 弹出 `AlertDialog`，含标题编辑区 + UP 行 + 推荐理由 + 保存封面/关闭按钮
- 甲方希望「piliplus上游的那种长按卡片有显示封面的方式魔改，目前的不够美观」——需要保留封面预览的更美观长按菜单
- 详情页 UP 区使用 `showUpDialog`（独立对话框），标题区使用 `showTextDialog`

## 7. Phase 1 判定

| 项目 | Blocker | Debt |
|------|:---:|:---:|
| 规则管理页增加分类/分组（按类型：用户屏蔽/标题关键词/标签分区） | ✅ | |
| 规则管理页增加搜索功能 | ✅ | |
| 设置页导航增加二级 Tab 或分类入口 | ✅ | |
| 长按卡片优化（保留封面预览的更美观 UI） | | ✅ |
| 规则编辑器改为分类表单（非单模态框） | | ✅ |
| 空状态引导插画 | | ✅ |
| 规则批量操作 | | ✅ |
| 导入/导出 | | ✅ |
