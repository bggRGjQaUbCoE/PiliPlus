# Reasonix A — UP 用户屏蔽语义复核

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

> "up主改变的还是不对，屏蔽用户关键词means，针对用户这个分类下，屏蔽所有用户id里带这个词的操作，但是目前的系统，把用户名当作普通关键词的一种，不满意……但是有屏蔽uid的选项这个对了"

## 3. 关键代码路径

| 符号 | 路径 | 行为 |
|------|------|------|
| `ShieldRuleType` | `lib/features/shielding/shielding_models.dart:1-5` | 4 个值：`keyword` `uid` `category` `tag`。**无 `up` 或 `user` 类型** |
| `ShieldCandidate` | `lib/features/shielding/shielding_models.dart:205-222` | 含 `uid`（UID 数字字符串）和 `authorName`（用户名），但 keyword 规则同时检查 title + body + authorName |
| `ShieldMatcher._exactMatches` | `lib/features/shielding/shielding_matcher.dart:69-79` | keyword 模式对 title/body/authorName 做 `contains`（子串包含）；uid 模式做全等 |
| `ShieldMatcher._valuesForRule` | `lib/features/shielding/shielding_matcher.dart:93-100` | keyword 分支 yield title + body + authorName → **三个字段不分来源** |
| `VideoCardShieldQuickAction.upRuleOptions` | `lib/common/widgets/video_card/shield_quick_action.dart:42-60` | 为 UP 生成 2 条规则：`uid` 精确 + `keyword` 用户名（但 keyword 规则不是专用 UP 规则） |
| `ShieldingAdapters.fromRecommendationJson` | `lib/features/shielding/shielding_adapters.dart:21-23` | `uid` ← `owner.mid`；`authorName` ← `owner.name` |
| `ShieldScope` | `lib/features/shielding/shielding_models.dart:9-12` | `recommendation`、`comment`、`both`。**无 user/up 专用 scope** |

## 4. 结论：当前实现不满足甲方语义

### 甲方的期望模型

```
用户屏蔽
├── 屏蔽 UID（精确匹配）✅ 已实现
└── 屏蔽用户关键词 → 只在「用户」分类下生效
    ├── 匹配范围：用户 ID / 用户名
    ├── 不匹配：视频标题、评论正文、评论用户名
    └── 规则应有独立的「用户关键词」类型
```

### 当前实现的缺陷

1. **`keyword` 规则不分来源**：一条 keyword 规则同时扫描视频标题 + 评论正文 + UP 用户名三个字段。用户设 keyword `"小张"` 会同时屏蔽：标题含"小张"的所有视频、评论正文含"小张"的所有评论、UP 用户名含"小张"的视频。

2. **无 `up_username` / `upKeyword` 规则类型**：`ShieldRuleType` 缺少表示「只对用户维度生效的 keyword」的类型。`upRuleOptions()` 生成的 `keyword` 规则打入的是通用 keyword namespace，与标题屏蔽混在一起。

3. **`uid` 类型只做全等匹配**：甲方说「屏蔽所有用户 id 里带这个词的操作」，即 UID contains 匹配。当前 `uid` 是全等匹配，`keyword` 是 contains——但 keyword 扫描的是 title/body/authorName，不是 uid 字段。

## 5. 推荐数据模型

```dart
enum ShieldRuleType {
  keyword,       // 内容关键词 — 仅匹配 title + body
  uid,            // UID 精确匹配 — 值全等
  category,
  tag,
  upName,         // 🆕 用户名关键词 — 仅匹配 authorName，子串包含
  upKeyword,      // 🆕 用户 UID 子串关键词 — 仅匹配 uid 字段，子串包含
}
```

`_valuesForRule` 变更：

```dart
case ShieldRuleType.keyword:
  yield ifNullEmpty(candidate.title);
  yield ifNullEmpty(candidate.body);
  // 不再 yield authorName —— 从 keyword 中移除

case ShieldRuleType.upName:
  yield ifNullEmpty(candidate.authorName);   // 🆕 只匹配用户名

case ShieldRuleType.upKeyword:
  yield ifNullEmpty(candidate.uid);           // 🆕 只匹配 UID 含子串

case ShieldRuleType.uid:
  yield ifNullEmpty(candidate.uid);           // 全等（不变）
```

### UI 文案映射

| 规则类型 | 用户可见标签 | 对话框输入说明 |
|---------|-------------|---------------|
| `keyword` | 屏蔽标题关键词「…」 | 屏蔽所有标题/评论含此关键词的内容 |
| `uid` | 屏蔽指定 UID | 精确屏蔽此 UID 用户的所有内容 |
| `upName` | 屏蔽用户名含「…」 | 屏蔽所有用户名含此关键词的 UP（仅用户维度） |
| `upKeyword` | 屏蔽 UID 含「…」 | 屏蔽所有 UID 含此关键词的用户（子串匹配） |

## 6. Phase 1 判定

| 项目 | Blocker | Debt |
|------|:---:|:---:|
| 新增 `ShieldRuleType.upName` / `upKeyword` | ✅ | |
| 从 `keyword` 的 `_matchValues` 中移除 `authorName` | ✅ | |
| `upRuleOptions()` 改为生成 `upName` 规则而非 `keyword` | ✅ | |
| 旧 `keyword` 规则的 `authorName` 迁移到 `upName` | | ✅ |
| 设置页 UI 新增「用户关键词屏蔽」分类 | | ✅ |
| `fromRecommendationJson` 等处适配新字段 | | ✅ |
