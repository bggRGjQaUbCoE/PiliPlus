# Phase 1 Shielding — 设置入口与旧过滤兼容预审

**仓库:** CometDash77/PiliAvalon-Worksite
**分支:** phase-1-shielding-core
**审计者:** Reasonix Code（只读审计）

---

## 1. 设置入口点

| 入口 | 路径 | 状态 |
|------|------|------|
| 专用设置页面 | `lib/pages/shielding_settings/view.dart` | ✅ 完整页面，含全局开关、推荐开关、评论开关、规则 CRUD |
| 主设置链接 | `lib/pages/setting/view.dart:69` | ✅ 列为 `SettingType.shieldingSetting` → `ShieldingSettingsPage` |
| 路由注册 | `lib/router/app_pages.dart:72` | ✅ `'/shieldingSetting'` → `ShieldingSettingsPage()` |
| 设置模型（UI 标签） | `lib/pages/setting/models/shielding_settings.dart` | ✅ `shieldRuleSummary`、`shieldRuleTitle`、`shieldRuleSubtitle` |
| 命名空间存储 | `lib/features/shielding/shielding_store.dart` | ✅ 键前缀 `piliavalon.shielding.v1.*` |
| 设置搜索 | `lib/pages/setting/view.dart:145` | ✅ 搜索栏路由到 `/settingsSearch` |

**设置页面完全可访问且功能正常。** 此处无缺口。

---

## 2. 全局/场景开关覆盖

| 开关 | 字段/键 | 是否实现 |
|------|---------|----------|
| 主开关 | `ShieldRuleSet.globalEnabled` → `piliavalon.shielding.v1.global_enabled` | ✅ 是 |
| 推荐开/关 | `ShieldRuleSet.recommendationEnabled` → `piliavalon.shielding.v1.recommendation_enabled` | ✅ 是 |
| 评论开/关 | `ShieldRuleSet.commentEnabled` → `piliavalon.shielding.v1.comment_enabled` | ✅ 是 |
| 用户/UP 开/关 | — | ❌ 非专用开关（规则级别处理：添加 `ShieldRuleType.uid` 规则） |
| 标签开/关 | — | ❌ 非专用开关（规则级别处理：`ShieldRuleType.tag`） |
| 分类开/关 | — | ❌ 非专用开关（规则级别处理：`ShieldRuleType.category`） |

**子开关尊重主开关：** `ShieldRuleSet.isScopeEnabled()` 首先检查 `globalEnabled`，然后是范围特定标志。如果全局为 `false`，所有场景开关被忽略。

---

## 3. 旧版兼容性分析

### 3A. 三个活跃的旧版过滤系统

| 旧版系统 | 文件 | 状态 vs Phase 1 |
|----------|------|-----------------|
| `RecommendFilter`（标题关键词、时长、播放、点赞率、关注豁免、相关视频开关） | `lib/utils/recommend_filter.dart` | **仍然完全活跃。** 无自动迁移到 Phase 1 |
| `VideoHttp.zoneRegExp` / `banWordForZone`（分区关键词过滤） | `lib/http/video.dart:49` + `lib/pages/setting/models/recommend_settings.dart:68` | **仍然活跃。** 迁移模块完全未分析 |
| 评论关键词过滤器（`banWordForReply`） | `lib/pages/setting/models/extra_settings.dart` | **独立系统。** 使用 `ReplyGrpc.replyRegExp` / `ReplyGrpc.enableFilter`。未连接到 Phase 1 |

### 3B. 双重过滤 AND 执行路径（高风险）

在 `lib/http/video.dart` 中，Phase 1 和 `RecommendFilter` **两者**以 AND 关系运行：

```dart
// lib/http/video.dart:85 — Web 推荐
if (!RecommendFilter.filter(videoItem) && visible) {  // 旧 AND 新
```

```dart
// lib/http/video.dart:173 — App 推荐
if (!RecommendFilter.filter(videoItem) && visible) {  // 旧 AND 新
```

```dart
// lib/http/video.dart:350-356 — 相关视频
final list = RecommendFilter.applyFilterToRelatedVideos
    ? items?.where((i) => !RecommendFilter.filterAll(i)).toList()
    : items?.toList();
final visibleList = ShieldingAdapters.filterRecommendationVideos(list, shieldRuleSet);
```

**配置了 Phase 1 关键词规则的用户也必须配置旧的 `banWordForRecommend` 才能获得相同行为 — 否则旧过滤器会静默地与新过滤器一起继续应用。**

### 3C. 热门视频/排行榜绕过 Phase 1

```dart
// lib/http/video.dart:196-204 — 热门视频列表
!RecommendFilter.filterTitle(i['title']) &&
!RecommendFilter.filterLikeRatio(i['stat']['like'], i['stat']['view']) &&
zoneRegExp.hasMatch(i['tname'])  // 仅旧版 zone 过滤器，无 Phase 1
```

排行榜路径同样仅使用旧版过滤器，无 Phase 1。

### 3D. 迁移模块仅分析，从未应用

`lib/features/shielding/shielding_migration.dart` 包含 `RecommendFilterAnalyzer.analyze()`，生成 `ShieldMigrationCandidate` 对象。文件明确记录：**"只产候选分析，不得标 green"**。生产中无代码调用 `toBeApplied()`。

| 旧设置 | 迁移可行性 | Phase 1 等效 |
|--------|------------|-------------|
| `banWordForRecommend`（管道分隔） | **直接** → 多个 `keyword+exact` 规则 | ✅ 就绪 |
| `banWordForRecommend`（复杂正则） | **直接** → 单个 `keyword+regex` 规则 | ✅ 就绪 |
| `minDurationForRcmd` | **不支持**（数值阈值） | ❌ 无等效 |
| `minPlayForRcmd` | **不支持**（数值阈值） | ❌ 无等效 |
| `minLikeRatioForRecommend` | **不支持**（数值阈值） | ❌ 无等效 |
| `exemptFilterForFollowed` | **部分**（Phase 1 中无"关注豁免"） | ❌ 缺口 |
| `banWordForZone` | **完全未分析** | ❌ 未迁移 |

---

## 4. QuickAction 风险评估

| 关注点 | 评估 | 文件:行 |
|--------|------|---------|
| **追加 vs 去重** | ✅ 按 `type + scope + matchMode + pattern.toLowerCase()` 去重 | `shielding_store.dart:153-161` |
| **命名空间** | ✅ 操作类型标记 `ShieldRuleSource.quickAction` | `shielding_models.dart:36` |
| **损坏 JSON 绕过** | ✅ 两级 try-catch：`tryFromJson()` → `disabledWithError`，以及 `snapshot()` → 回退 | `shielding_models.dart:76-83`、`shielding_store.dart:81-92` |
| **空模式守卫** | ✅ `addQuickActionRule` 对空修剪模式抛出异常 | `shielding_store.dart:143-145` |
| **UI 显示错误** | ✅ `loadErrors` 渲染为带错误详情的警告横幅 | `shielding_settings/view.dart:104-112` |
| **验证时保存回滚** | ✅ `_validate` 在写入前运行；抛出 `ShieldStoreException`，旧负载保留 | `shielding_store.dart:117-119` |

**QuickAction 中未发现关键风险。** 去重正确，命名空间清晰，损坏负载导致优雅降级。

---

## 5. 现有测试覆盖

| 测试文件 | 覆盖内容 | 完整性 |
|----------|----------|--------|
| `test/features/shielding/shielding_core_test.dart` | ShieldMatcher：关键词/正则/uid/分类/标签匹配，允许优先，禁用规则，范围不匹配，全局跳过 | ✅ 全面 |
| `test/features/shielding/shielding_store_test.dart` | JSON 往返，损坏 JSON，正则验证，quickAction 去重，命名空间标志保留 | ✅ 全面 |
| `test/features/shielding/shielding_adapters_test.dart` | 适配器映射，`filterList`，分类过滤 | ✅ 全面 |
| `test/features/shielding/shielding_migration_test.dart` | RecommendFilterAnalyzer | ✅ 全面 |
| `test/features/shielding/video_card_shield_quick_action_test.dart` | uid+keyword 的 `upRuleOptions` | ⚠️ 仅测试选项生成 |
| `test/features/shielding/comment_reply_controller_test.dart` | 评论屏蔽应用于嵌套回复 + 一楼根回复 | ✅ 全面 |
| `test/pages/setting/models/shielding_settings_test.dart` | UI 标签格式化 + 组件渲染 | ✅ |

### 缺失测试

1. **热门/排行榜集成** — `hotVideoList` 和排名路径应用 `RecommendFilter` + `zoneRegExp` 但未应用 Phase 1
2. **全局关闭后旧 RecommendFilter 仍活跃** — 无测试验证当 `globalEnabled=false` 时旧过滤器是否仍然静默过滤
3. **`zoneRegExp` 与 Phase 1 分类规则的交互** — 两个系统都作用于 `tname`/category；组合过滤后可见项数量不变
4. **设置页面：从主设置到屏蔽设置的导航** — 无测试验证完整的导航流程
5. **设置页面：规则删除确认对话框**

---

## 6. 最小修复/补测列表

| 优先级 | 类别 | 描述 |
|--------|------|------|
| **P0** | 修复 | 全局开关关闭时 `RecommendFilter` + `zoneRegExp` 仍暗中生效 — 需要在 `globalEnabled=false` 时禁用旧过滤器，或在 UI 中清晰标注 |
| **P0** | 修复 | 热门/排行榜绕过 Phase 1 — 需要将 Phase 1 屏蔽添加到这些路径 |
| **P1** | 修复 | 迁移模块从未应用 — 需要在设置中提供一键迁移按钮 |
| **P1** | 测试 | 全局关闭后旧 RecommendFilter 仍活跃 |
| **P1** | 测试 | 热门/排行榜与屏蔽的集成 |
| **P2** | 测试 | `zoneRegExp` 与分类规则的交互 |
| **P2** | 测试 | 设置导航流程 |
| **P2** | 修复 | 设置页面分类（甲方要求） |

---

**⚠️ 本报告是只读候选审计。不宣布功能验收或 gate 关闭。**
