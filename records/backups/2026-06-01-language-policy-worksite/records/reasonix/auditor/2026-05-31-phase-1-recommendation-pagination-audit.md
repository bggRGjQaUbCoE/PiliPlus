# Phase 1 Shielding — 推荐流分页/空态预审

**仓库:** CometDash77/PiliAvalon-Worksite
**分支:** phase-1-shielding-core
**审计者:** Reasonix Code（只读审计）

---

## 1. 代码位置

| 组件 | 文件 | 关键行 |
|------|------|--------|
| 屏蔽核心模型 | `lib/features/shielding/shielding_models.dart` | 1–130：`ShieldRule`、`ShieldCandidate`、`ShieldRuleSet`、`ShieldMatchResult` |
| 屏蔽匹配器 | `lib/features/shielding/shielding_matcher.dart` | 1–97：`ShieldMatcher.match()`、`_matchValues()`、`_exactMatches()` |
| 屏蔽适配器 | `lib/features/shielding/shielding_adapters.dart` | `fromRecommendationJson()` 9–32；`_tags()` 72–83；`filterList()` 52–61 |
| 推荐API（Web） | `lib/http/video.dart` | `rcmdVideoList()` 26–66 |
| 推荐API（App） | `lib/http/video.dart` | `rcmdVideoListApp()` 68–126 |
| 热门视频API | `lib/http/video.dart` | `hotVideoList()` 128–158 |
| 相关视频API | `lib/http/video.dart` | `relatedVideoList()` 196–216 |
| 推荐控制器 | `lib/pages/rcmd/controller.dart` | 1–54：`isEnd => false`（硬编码） |
| 基础分页 | `lib/pages/common/common_list_controller.dart` | 1–65：`queryData()` 循环保护 |
| 旧版过滤器 | `lib/utils/recommend_filter.dart` | 1–40：时长/点赞率/标题正则 |

---

## 2. 分页分析

### 调用流程
1. `RcmdController.onInit()` 设置 `page = 0` 并调用 `queryData()`
2. `customGetData()` 分派到 `VideoHttp.rcmdVideoList()`（Web）或 `rcmdVideoListApp()`（App）
3. 每个 API 响应经过**三层**过滤：(a) `RecommendFilter` — 时长/点赞率/标题正则，(b) 黑名单 mid 检查，(c) `ShieldingAdapters.isVisible()`
4. 可见项收集到 `list` 中并作为 `Success(list)` 返回
5. 用户滚动到最后一项时，视图调用 `controller.onLoadMore()` → `queryData(false)`
6. `queryData(false)` 递增 `page` 并重新获取

### 当所有项被屏蔽时

`rcmdVideoList()` 第 46-56 行：如果 API 返回 20 项，但所有 20 项都被屏蔽规则或 `RecommendFilter` 阻止，则 `list` 保持为 `[]`。返回 `Success([])`。

在 `CommonListController.queryData()`（第 33-36 行）：
```dart
if (dataList == null || dataList.isEmpty) {
  isEnd = true;
  loadingState.value = Success(dataList);  // []
  isLoading = false;
  return;
}
```

**但是** `RcmdController` **覆盖了** `isEnd` **为硬编码的** `false`（第 16 行：`@override bool get isEnd => false`），这意味着**分页循环永远不会停止**。每次 `onLoadMore` 都会完全绕过 `isEnd` 检查，因为 `isEnd` 始终返回 `false`。

### 缺少最大重试保护

**没有最大页面限制或重试衰减。** 如果用户设置了非常宽泛的屏蔽规则，应用将无限循环：
- 获取带有 `freshIdx=0` 的页面 → 0 个可见项 → 显示 `HttpError`（"没有数据"）
- 用户点击"重试" → 相同的 `freshIdx=0`，相同的结果
- 或者，在滚动触发时，`page` 递增，但每个后续批次仍然被 100% 过滤 → 永远不会停止

在 `RcmdController` 或 `CommonListController` 中，**没有逻辑会声明"我们连续收到 N 个空页面；放弃或回退到更宽松的请求"。**

### 与旧版 RecommendFilter 的双重过滤

有了新的 Phase 1 屏蔽，现在有**两个**独立的后获取过滤器（`RecommendFilter` + `ShieldingAdapters`），两者都可能清空一个页面。如果两者都启用，分页循环退出的可能性进一步降低。

---

## 3. 空状态分析

### 渲染逻辑（`rcmd/view.dart` 第 62-97 行）

```dart
return switch (loadingState) {
  Loading() => _buildSkeleton,          // 10 个骨架卡片
  Success(:final response) =>
    response != null && response.isNotEmpty
      ? SliverGrid.builder(...)         // 正常列表
      : HttpError(onReload: controller.onReload),  // 空列表 → 错误！
  Error(:final errMsg) => HttpError(
    errMsg: errMsg,                     // API 错误 → 显示消息
    onReload: controller.onReload,
  ),
};
```

### 无法区分的状态

| 场景 | 显示内容 | 重试操作 |
|------|----------|----------|
| API 返回空（真正无内容） | "没有数据" | 重新获取相同的端点 |
| 所有项被屏蔽规则阻止 | "没有数据" | 重新获取相同的端点 |
| 所有项被 RecommendFilter 过滤 | "没有数据" | 重新获取相同的端点 |
| 网络错误 | 错误消息文本 | 重新获取相同的端点 |

**没有专门的"所有内容被过滤"消息、图标或标记。** 用户无法判断屏蔽规则是否导致了空提要。重试循环没有帮助，因为相同的规则仍然适用。

---

## 4. 标签/分类屏蔽审计

### 标签提取（`shielding_adapters.dart` 第 72-83 行）

```dart
static List<String> _tags(Map<String, dynamic> json) {
  final raw = json['tag'] ?? json['tags'];
  // ... 仅读取 json['tag'] / json['tags']
}
```

**✅ 正确：** 此方法仅读取 `json['tag']` 或 `json['tags']`。它**不**读取 `tname`、`category` 或任何其他字段。

### 分类提取

`tname` 字段专门映射到 `ShieldCandidate.category`，用于 `ShieldRuleType.category` 规则，**而非**标签规则。枚举分支独立，无交叉污染。

### 匹配语义

| ShieldRuleType | 精确模式 | 正则模式 | 标记模式 |
|----------------|----------|----------|----------|
| `keyword` | `contains()`（子串） | `RegExp.hasMatch()` | `tokens` 列表 |
| `uid` | `==`（相等） | `RegExp.hasMatch()` | `tokens` 列表 |
| `category` | `==`（相等） | `RegExp.hasMatch()` | `tokens` 列表 |
| `tag` | `==`（相等） | `RegExp.hasMatch()` | `tokens` 列表 |

所有比较不区分大小写。标签的精确模式要求**完全匹配**（标准化后）。标签 "games" 不会匹配标签 "game"。

### 标签字段覆盖差距

`fromRelatedVideo()` 不为热门/相关视频设置标签。这意味着**标签屏蔽规则适用于推荐提要（`fromRecommendationJson`），但不适用于热门页面或相关视频面板。**

---

## 5. 推荐的测试矩阵

### 高优先级

| # | 测试场景 | 文件 | 预期断言 |
|---|----------|------|----------|
| T1 | 所有项被阻止时分页设置 `isEnd = true` | `test/pages/rcmd/controller_test.dart` | 屏蔽清空整个 API 响应时 `RcmdController` 最终停止加载 |
| T2 | 连续 N 个页面为空时最大重试保护触发 | `test/pages/rcmd/controller_test.dart` | N 次空结果后加载停止 |
| T3 | 空状态组件区分"全部过滤"与"无内容" | `test/common/widgets/http_error_test.dart` | 显示"全部被过滤"而非通用"没有数据" |
| T4 | 标签屏蔽规则正确忽略 `tname` 字段 | `test/features/shielding/` | `ShieldRuleType.tag` 不匹配 `ShieldCandidate.category` |

### 中优先级

| # | 测试场景 |
|---|----------|
| T5 | `_tags()` 处理各种输入格式（字符串、列表、缺失、null、空） |
| T6 | 标签精确匹配是严格相等（非子串） |
| T7 | 推荐视频列表触发 `RecommendFilter` + `ShieldingAdapters` 顺序不变 |
| T8 | `fromRelatedVideo()` 对热门/相关视频不产生标签 |

### 低优先级

| # | 测试场景 |
|---|----------|
| T9 | `onReload` 重置 `freshIdx` 到 0（刷新） |
| T10 | 屏蔽禁用时 `RecommendFilter` 仍然生效 |

---

## 6. 关键发现总结

1. **分页无限循环风险：** `RcmdController.isEnd` 硬编码为 `false`。当屏蔽阻止所有可加载项时无衰减或最大重试次数。

2. **无法区分的空状态：** 无论是 API 空回复、网络错误、旧版 `RecommendFilter` 还是新屏蔽规则，都显示相同的 `HttpError`（"没有数据"）。

3. **标签匹配正确性：** `_tags()` 在读取字段时是安全的 — 仅 `json['tag']` / `json['tags']`。`tname` 严格映射到 `category`。无交叉污染。

4. **热门/相关视频标签覆盖差距：** `fromRelatedVideo()` 适配器不传递标签，因此标签屏蔽规则不适用于热门页面或相关视频面板。

---

**⚠️ 本报告是只读候选审计。不宣布任何 gate 关闭或测试通过。**
