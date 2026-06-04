# Phase 1 Shielding — 评论屏蔽逻辑预审

**仓库:** CometDash77/PiliAvalon-Worksite
**分支:** phase-1-shielding-core
**审计者:** Reasonix Code（只读审计）

---

## 1. 代码位置

| 文件 | 用途 | 关键行 |
|------|------|--------|
| `lib/pages/common/reply_controller.dart` | 共享回复控制器 — `handleListResponse` + `applyShielding` | 61–66, 91–117 |
| `lib/pages/video/reply/controller.dart` | 视频主回复控制器（无 `setIndexById`） | 1–41 |
| `lib/pages/video/reply/view.dart` | 视频主回复视图（无目标查找） | 1–203 |
| `lib/pages/video/reply_reply/controller.dart` | 嵌套回复控制器 — **缺陷流程**（`handleListResponse` + `setIndexById`） | 86–91, 100–106 |
| `lib/pages/video/reply_reply/view.dart` | 嵌套回复视图 — 使用 `_controller.index.value` + `response[index]` | 290–320 |
| `lib/pages/video/reply/widgets/reply_item_grpc.dart` | 回复项显示组件 — `replyItemRow` 显示 `replyItem.count`（API 总数，非过滤后长度） | ~302–385 |
| `lib/features/shielding/shielding_adapters.dart` | `filterList` + `fromReplyInfo` 适配器 | 33–44, 58–80 |
| `lib/features/shielding/shielding_models.dart` | `ShieldRule`、`ShieldRuleSet`、`ShieldCandidate` | 全文件 |
| `lib/features/shielding/shielding_matcher.dart` | 核心匹配逻辑 | 全文件 |

---

## 2. 分析 — 回复查找流程与 Off-by-One 缺陷

### 从深链接/通知查找回复的流程：

1. `VideoReplyReplyPanel.toReply()` 使用 `id`（目标回复的 rpid）导航
2. `VideoReplyReplyController.onInit()` → `queryData()` → 从 gRPC API 获取详情列表
3. 关键序列在 `handleListResponse()` 中（`reply_reply/controller.dart:86–91`）：
   ```
   setIndexById(id, dataList)   // 步骤 A：在原始未过滤列表上进行索引查找
   super.handleListResponse(dataList)  // 步骤 B：应用屏蔽，原地修改列表
   ```
4. `setIndexById` 通过 `indexWhere` 找到目标位置并存储在 `this.index.value`
5. `super.handleListResponse` → `ReplyController.handleListResponse` → `applyShielding` → `ShieldingAdapters.filterList` 返回一个新列表，已移除被屏蔽项。然后 `handleListResponse` 清空 `dataList` 并重新添加仅可见项
6. 在 `_buildBody` 中，存储的 `jumpIndex` 被用作 `response[jumpIndex]` 来高亮目标并驱动 `jumpToItem`

### Off-by-One 缺陷：

当屏蔽移除了**目标之前的任何项**时，存储的 `index` 会变得过时 — 它仍然指向原始未过滤位置，但过滤后的列表已发生偏移。

**示例：**
- 原始列表：`[A, B(被屏蔽), C, D(目标)]` — `setIndexById` → `index = 3` ✓
- 屏蔽后：`[A, C, D(目标)]` — 列表现在是 3 项
- `response[3]` → **越界**（或如果列表更长则指向错误项）
- `jumpToItem(3)` → 滚动到错误位置

**目标自身被屏蔽的情况：** 如果目标回复自身匹配屏蔽规则，`setIndexById` 仍能找到它（原始列表），但屏蔽后它被移除。过时的 `index` 然后指向不同的回复或越界。

### 现有测试覆盖

`test/features/shielding/shielding_adapters_test.dart:236–248`：测试 `"direct reply target lookup runs before comment shielding"` 断言 `index.value == 1` 并检查过滤后的列表大小。它确认索引在屏蔽之前被捕获 — 但**未验证**过滤后的 `response[jumpIndex]` 是否仍然指向正确的项。测试目标（id=42）在列表中处于**最后位置**（2 项列表中的索引 1），因此其后没有项被屏蔽；无法出现 off-by-one。

### 嵌套回复计数显示

在 `reply_item_grpc.dart` 中，`replyItemRow` 使用 `replyItem.count`（API 总数，而非 `replies.length`）来显示"共N条回复"文本。如果所有子回复被过滤掉，它仍显示原始计数 — 视觉不一致但不会崩溃。

---

## 3. 缺失测试

1. **屏蔽移除目标之前的项后出现 Off-by-one** — 列表 `[可见, 被屏蔽, 可见, 目标]`：验证屏蔽后的 `response[jumpIndex]` 仍然 == 目标
2. **目标回复自身被屏蔽** — 目标匹配屏蔽规则：验证优雅降级（无崩溃，显示 toast 或占位符）
3. **列表最前面的被屏蔽项** — 索引 0 被屏蔽，目标在索引 3：验证高亮和滚动落在正确的回复上
4. **嵌套回复（"楼中楼"）计数一致性** — 子回复被屏蔽时父 `replyItem.count` vs 过滤后的 `replies.length`
5. **分页偏移不被过滤破坏** — 页面边界处的被屏蔽项可能偏移游标/偏移对齐
6. **`applyFirstFloorShielding` + 深链接到一楼** — 当一楼（根回复）自身是目标且被屏蔽时

---

## 4. 最小修复范围建议

| 优先级 | 文件 | 问题 |
|--------|------|------|
| **1（关键）** | `lib/pages/video/reply_reply/controller.dart` | `handleListResponse` 在屏蔽之前对原始列表运行 `setIndexById`；`super.handleListResponse` 修改列表后，存储的索引过时。修复：在屏蔽后重新查找索引，或使用基于回复 ID 的滚动而非基于位置的滚动 |
| **2（逻辑）** | `lib/pages/common/reply_controller.dart` | `applyShielding` + `handleListResponse` 原地修改 `dataList`。这是根本原因 — 父合约静默修改了子组件已查询索引的列表。考虑屏蔽是否应生成*单独的*显示列表而非修改原始列表 |
| **3（显示）** | `lib/pages/video/reply_reply/view.dart` | `_buildBody` 直接使用 `response[jumpIndex]` — 当目标回复被屏蔽移除或其索引偏移时需要回退方案 |
| **4（一致性）** | `lib/pages/video/reply/widgets/reply_item_grpc.dart` | `replyItemRow` 显示 `replyItem.count`（API 总数）但仅渲染 `replies.length` 项 — 考虑在屏蔽场景中将显示计数限制为可见计数 |

**不应更改的文件：** `shielding_adapters.dart`、`shielding_matcher.dart`、`shielding_models.dart`、`shielding_store.dart` — 核心屏蔽逻辑正确且经过充分测试。缺陷在于*消费者*（回复控制器 + 视图）如何处理过滤后的状态。

---

**⚠️ 本报告是只读候选审计。不宣布测试通过或 gate 关闭。**
