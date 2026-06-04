# Worker 1 — Matcher / Quick Action 语义候选分析

**日期**: 2026-05-31
**关联**: Phase 1 shielding
**依据**: 甲方反馈第 3 条
**类型**: 候选分析 — 不标 green

---

## 1. 核心问题

### 1.1 `keyword` 类型匹配域过宽

```dart
// shielding_matcher.dart:91-95
case ShieldRuleType.keyword:
  yield ifNullEmpty(candidate.title);
  yield ifNullEmpty(candidate.body);
  yield ifNullEmpty(candidate.authorName);
```

快速操作为 UP 名创建的 `ShieldRuleType.keyword` 规则，会同时匹配标题、正文、作者名三个字段。用户期望的是"只匹配用户标识字段"。

### 1.2 缺少"用户专用"匹配类型

甲方原文：

> 屏蔽用户关键词 means，针对用户这个分类下，屏蔽所有用户 id 里带这个词的操作，但是目前的系统，把用户名当作普通关键词的一种，不满意

期望语义：**用户关键词** = 在 uid + authorName 上做 **子串包含（contains）** 匹配。

### 1.3 UID 规则只做全等匹配

```dart
// shielding_matcher.dart:74-82
if (rule.type == ShieldRuleType.keyword) {
  return values.any((value) => value.contains(pattern));
}
return values.any((value) => value == pattern);
```

甲方期望"屏蔽所有用户 id 里带这个词的操作"（子串匹配），但 `uid + exact` 只做 `==`。

### 1.4 `upRuleOptions()` 生成两条规则

```dart
// shield_quick_action.dart:41-65
// 生成:
//   1. uid 精确屏蔽  → type: uid,  uid == pattern          ✅ 甲方认可
//   2. 用户名关键词  → type: keyword, title/body/authorName 含 pattern  ❌
```

---

## 2. 推荐方案：新增 `ShieldRuleType.userKeyword`

### 2.1 数据模型 — `shielding_models.dart`

`ShieldRuleType` 枚举新增成员：

```dart
enum ShieldRuleType {
  keyword,
  uid,
  category,
  tag,
  userKeyword,   // ← 新增
}
```

向后兼容：旧序列化数据不包含此值，无影响；`fromJson` 按 enum name 解析，不存的回退。

### 2.2 匹配器 — `shielding_matcher.dart`

**`_valuesForRule`**（L91-100）新增分支：

```dart
case ShieldRuleType.userKeyword:
  yield ifNullEmpty(candidate.uid);
  yield ifNullEmpty(candidate.authorName);
```

→ 只匹配 uid 和 authorName，不碰 title/body。

**`_exactMatches`**（L74-82）条件扩展：

```dart
if (rule.type == ShieldRuleType.keyword ||
    rule.type == ShieldRuleType.userKeyword) {
  return values.any((value) => value.contains(pattern));
}
return values.any((value) => value == pattern);
```

→ `userKeyword + exact` 使用 contains（子串匹配），满足"用户 id 里带这个词"的需求。

**regex / token** 通过 `_valuesForRule` 自然继承，无需额外改动。

### 2.3 Quick Action — `shield_quick_action.dart`

**`upRuleOptions()`**（L41-65）替换类型：

```dart
// 改前
type: ShieldRuleType.keyword,
// 改后
type: ShieldRuleType.userKeyword,
```

**`_ruleLabel()`** 新增分支：

```dart
ShieldRuleType.userKeyword => '屏蔽用户关键词「$pattern」',
```

**`_contextualRuleLabel()`** 同理处理。

---

## 3. 向后兼容分析

| 场景 | 行为 |
|------|------|
| 已有 `keyword` 规则（pattern 是 UP 名） | 继续工作，仍匹配 title/body/authorName |
| 新规则（通过 quick action 创建） | 使用 `userKeyword` 类型，只匹配 uid/authorName |
| 旧序列化数据升级后 | 不变 — `userKeyword` 仅出现在新建的规则上 |
| 存量 `keyword` 规则清理 | **不推荐在本阶段做**——把 pattern=UP 名的 `keyword` 转为 `userKeyword` 有歧义（同名关键词 vs 用户关键词），可以后续提供迁移工具让用户选择 |

---

## 4. 备选方案对比

| 方案 | 改动量 | 语义清晰度 | 风险 | 推荐？ |
|------|--------|-----------|------|--------|
| **A. 新增 `userKeyword` 类型** | 3 文件 ~15 行 | 清晰 | 低 | ⭐ 推荐 |
| B. 给 `ShieldRule` 加 `targetFields` 约束字段 | ~30 行 + 迁移 | 灵活但复杂 | 中 | ❌ 过度设计 |
| C. 不改模型，在 `_valuesForRule` 传额外 context | 侵入性强 | 模糊 | 高 | ❌ |
| D. UP 名直接用 `uid + contains` | 语义扭曲 | 混淆 | 中 | ❌ |

---

## 5. 边界明确

本 worker 不涉及：

- 长按 UI 视觉改造 / 卡片封面 → Worker 3
- 推荐流 tag 数据可用性 → Worker 2
- 旧过滤系统合并 → Worker 2
- 设置页分类 → Worker 3
- 验证 / 发布证据 → Worker 4

---

## 6. 等待其他 Worker 对齐

建议与其他三个 worker 的候选分析合并后，统一出实现计划。
