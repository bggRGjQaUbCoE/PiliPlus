# Reasonix B — 推荐流标签屏蔽 fact-check

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

> "相关视频也生效了，但是标签屏蔽没有作用，我期望的是标签屏蔽的效果在推荐流生效，但是程序似乎没有这样的读取，请问是逻辑问题吗？推荐流不识别视频的标签，所以是不点进去不识别吗？need factcheck"

## 3. 关键代码路径

### 数据模型

| 符号 | 路径 | 行为 |
|------|------|------|
| `ShieldCandidate.tags` | `lib/features/shielding/shielding_models.dart:208` | `List<String> tags` — 字段已就绪 |
| `ShieldRuleType.tag` | `lib/features/shielding/shielding_models.dart:5` | 标签规则类型已就绪 |
| `ShieldMatcher._valuesForRule` tag 分支 | `lib/features/shielding/shielding_matcher.dart:102` | 直接 yield `candidate.tags` |

### 适配器构建

| 函数 | 路径 | 行为 |
|------|------|------|
| `ShieldingAdapters._tags` | `lib/features/shielding/shielding_adapters.dart:89-102` | 读 `json['tag']` 或 `json['tags']`，逗号/空格/中文标点分隔 |
| `ShieldingAdapters.fromRecommendationJson` | `lib/features/shielding/shielding_adapters.dart:30` | `tags: _tags(rawJson)` — 尝试读 raw JSON |
| `ShieldingAdapters.fromRelatedVideo` | `lib/features/shielding/shielding_adapters.dart:52-60` | `tags: const []` — **硬编码空列表** |

### API 层

| 函数 | 路径 | 关键点 |
|------|------|--------|
| Web 推荐 | `lib/http/video.dart:75-93` | `/x/web-interface/feed`，item JSON 无稳定 tag 字段 |
| App 推荐 | `lib/http/video.dart:140-172` | `/x/v2/feed/index`，args 有 `tname`，无 tag 列表 |
| `RcmdVideoItemModel` | `lib/models/model_rec_video_item.dart:18-39` | 仅解析 title/owner/stat，不解析 tag/tags |
| `HotVideoItemModel` | `lib/models/model_hot_video_item.dart:14` | 含 `tname`（单字符串），无 tag 数组 |

## 4. 事实结论：推荐流没有可用 tags

| 流类型 | 构建路径 | category (`tname`) | tags (`candidate.tags`) | 结论 |
|--------|---------|:---:|:---:|------|
| Web 推荐 | `fromRecommendationJson` | ✅ | ⚠️ 极少 item 附带 `tag`/`tags` | **tag 规则基本不生效** |
| App 推荐 | `fromRecommendationJson` | ✅ `args.tname` | ❌ 响应不包含 | **tag 规则不生效** |
| 相关视频 | `fromRelatedVideo` | ✅ `item.tname` | ❌ 硬编码 `[]` | **tag 规则永远不生效** |
| 最热视频 | `fromRelatedVideo` | ✅ `item.tname` | ❌ 硬编码 `[]` | **tag 规则永远不生效** |

**答案：不是逻辑 bug，是推荐流 payload 本身不携带视频标签。**

Bilibili API 的推荐流 endpoint 返回的 item 结构为 `{ id, bvid, title, pic, owner, stat, duration, tname, rcmd_reason }` —— 没有 tag list。标签数据仅在视频详情 API (`/x/web-interface/view`) 中作为 `VideoTagItem[]` 返回。

## 5. 推荐方案

| 方案 | 可行性 | 风险 | 推荐 |
|------|:---:|------|:---:|
| A. 不在推荐流暴露 tag 屏蔽 | ✅ | 不改变行为；甲方仍然不满意 | ❌ |
| B. 用 `tname`（category）作为 tag 的 fallback | ✅ | 把二级分类名当作标签，语义合理 | ✅ **推荐** |
| C. 进入详情页后按 tag 生效 | ✅ | 只有点进视频才会屏蔽，推荐流卡片仍可见 | ⚠️ |
| D. 额外请求详情数据获取 tag | ✅ | 大量额外网络开销 | ❌ |

### 推荐实现

在 `_valuesForRule` 中，`ShieldRuleType.tag` 分支扩展到也检查 `candidate.category`：

```dart
// lib/features/shielding/shielding_matcher.dart
case ShieldRuleType.tag:
  for (final tag in candidate.tags) yield tag;
  if (candidate.category != null) yield candidate.category;  // 🆕 tname fallback
```

同时在 `fromRelatedVideo` 中修复 tags 缺值：

```dart
// lib/features/shielding/shielding_adapters.dart
tags: item.tname != null ? [item.tname!] : const [],
```

## 6. Phase 1 判定

| 项目 | Blocker | Debt |
|------|:---:|:---:|
| 修复 `fromRelatedVideo` tags 硬编码 `[]` | ✅ | |
| tag 规则 fallback 到 `candidate.category` (tname) | ✅ | |
| 推荐流切换至详情页后再检查 tag | | ✅ |
| 额外请求详情数据获取 tag（如有必要） | | ✅ |
