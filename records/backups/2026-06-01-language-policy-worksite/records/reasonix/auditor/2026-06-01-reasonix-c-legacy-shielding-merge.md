# Reasonix C — 上游旧屏蔽系统合并

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

> "有用了，但是是同样的问题，上游的屏蔽功能和新增的屏蔽系统同时在生效，不需要这样，上游的功能合并到这个屏蔽系统里"

## 3. 旧系统 vs 新系统入口

### 旧系统 — `lib/utils/recommend_filter.dart`

| 字段 | 存储键 | 功能 | 类型 |
|------|--------|------|------|
| `rcmdRegExp` | `banWordForRecommend` | 标题关键词正则 | 关键词屏蔽 |
| `minDurationForRcmd` | `minDurationForRcmd` | 最短视频时长（秒） | 数值阈值 |
| `minPlayForRcmd` | `minPlayForRcmd` | 最低播放量 | 数值阈值 |
| `minLikeRatioForRecommend` | `minLikeRatioForRecommend` | 最低点赞率（%） | 数值阈值 |
| `exemptFilterForFollowed` | `exemptFilterForFollowed` | 跳过已关注 UP | 豁免规则 |
| `applyFilterToRelatedVideos` | `applyFilterToRelatedVideos` | 在相关视频应用 | 开关 |

设置 UI：`lib/pages/setting/models/recommend_settings.dart`

### 新系统 — `lib/features/shielding/`

| 模块 | 文件 | 规则类型 | 覆盖范围 |
|------|------|---------|---------|
| 模型 | `shielding_models.dart` | `keyword` `uid` `category` `tag` | — |
| 匹配器 | `shielding_matcher.dart` | exact / regex / token | — |
| 存储 | `shielding_store.dart` | Hive 持久化 | — |
| 适配器 | `shielding_adapters.dart` | 推荐/评论/相关视频 | 推荐流 + 评论 |
| 迁移 | `shielding_migration.dart` | `RecommendFilterAnalyzer` | — |
| 快速操作 | `shield_quick_action.dart` | 长按卡片添规则 | — |
| 设置 | `shielding_settings/view.dart` | 规则编辑器 | — |

Scope: `recommendation`、`comment`、`both`。**无弹幕 scope。**

## 4. 双重生效路径

| 位置 | 文件:行 | 顺序 |
|------|--------|------|
| 推荐流 (Web) | `lib/http/video.dart:85` | **旧先** (`RecommendFilter.filter()`) → **新后** (`ShieldingAdapters`) — AND 关系 |
| 推荐流 (App) | `lib/http/video.dart:173` | 同上 |
| 相关视频 | `lib/http/video.dart:350-355` | **旧先** (`RecommendFilter.filterAll()`) → **新后** (`ShieldingAdapters.filterRecommendationVideos()`) |
| 评论 | `lib/pages/common/reply_controller.dart:91-99` | **仅新** (`ShieldingAdapters.filterList()`) |
| 弹幕 | `lib/plugin/pl_player/utils/danmaku_options.dart` | **仅旧** (`Pref.danmakuBlockType`) |

**视频必须通过旧 AND 新两层才能显示。** 用户设的旧关键词在 `RecommendFilter` 层屏蔽，新 keyword 规则在 `ShieldingAdapters` 层再屏蔽 — 两层完全独立，互不可见。

## 5. 迁移分析（`shielding_migration.dart`）

`RecommendFilterAnalyzer.analyze()` 产出 `ShieldMigrationReport`：

| 旧字段 | 可迁移？ | 迁移为 |
|--------|:---:|------|
| `banWordForRecommend`（简单竖线分隔词） | ✅ | 每个词 → `keyword+exact`，`scope=recommendation`，`source=imported` |
| `banWordForRecommend`（复杂正则） | ✅ | `keyword+regex` 单条规则 |
| `minDurationForRcmd` | ❌ | **不可迁移** — `ShieldRule` 无数值范围字段 |
| `minPlayForRcmd` | ❌ | **不可迁移** |
| `minLikeRatioForRecommend` | ❌ | **不可迁移** |
| `exemptFilterForFollowed` | ⚠️ | 注释记录 `isFollowed` 缺失 gap |
| `applyFilterToRelatedVideos` | ⚠️ | 新系统总是应用到相关视频，忽略开关 |

## 6. 合并方案

### Phase 1 Blocker

| 项目 | 说明 |
|------|------|
| ✅ 在推荐流中**停用** `RecommendFilter` 的标题关键词过滤，仅保留 `ShieldingAdapters` | `lib/http/video.dart:85` 删除 `!RecommendFilter.filter(videoItem)` 条件 |
| ✅ 将旧 `banWordForRecommend` 关键词**一次性迁移**到 `ShieldRuleSet` | 用 `RecommendFilterAnalyzer.analyze()` 在首次启动时自动迁移，写入 Hive |
| ✅ 在设置 UI 中显示迁移完成的提示 | 迁移后弹出提示 "旧屏蔽规则已合并"，并引导用户查看新屏蔽设置页 |

### 保留旧系统（不迁移）的功能

| 功能 | 原因 |
|------|------|
| `minDurationForRcmd` / `minPlayForRcmd` / `minLikeRatio` | `ShieldRule` 不支持数值阈值，保留在旧设置页 |
| 弹幕屏蔽 (`DanmakuBlockType`) | 新系统不支持弹幕 scope，弹幕有独立的 Bilibili API 同步 |
| `exemptFilterForFollowed` | 新系统缺少 `isFollowed` 上下文，作为 debt 跟进 |

### 非 Phase 1（后续 debt）

| 项目 | 说明 |
|------|------|
| `isFollowed` 上下文注入 | 需在匹配器或适配器层传递关注状态 |
| `applyFilterToRelatedVideos` 独立开关 | 当前新系统总是应用，需 UI 开关 |
| 数值阈值规则类型扩展 | 如需要，扩展 `ShieldRule` 模型 |
