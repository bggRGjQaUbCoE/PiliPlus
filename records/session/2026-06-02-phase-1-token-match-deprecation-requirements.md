Audience classification: dual-use

# Phase 1 Token Match Deprecation Requirements

## 中文决策摘要

用户确认 `phase-1-prebuild.26797160689` 的其他验收项暂无问题，但提出两个新的屏蔽规则语义调整需求：

1. “词元匹配”作为用户可见匹配方式没有实际意义，应废弃并隐藏；底层枚举/兼容能力不删除。
2. 如果用户配置文件中已有“词元匹配”规则，读取时要识别并转换成正则匹配形式。
3. 用户点击“屏蔽用户关键词”时，新增规则统一使用正则匹配形式。

Phase 1 仍应基于现有屏蔽体系继续修，不应另起一套规则系统。

## Raw User Feedback

```text
all done,but firt,我发现词源匹配没有什么意义，这个匹配方式废弃，但是不用删除而是隐藏，如果用户文件里有词源匹配的方式，识别并转换成正则匹配的形式，第二，屏蔽用户关键词的形式，在用户点击后，统一用正则匹配的形式，其他的暂无问题，把我的描述转化成技术面的修改需求
```

Follow-up persistence request:

```text
把需求持久化文件
```

## Technical Requirements

### 1. Deprecate visible token matching

- Keep `ShieldMatchMode.token` in the model for backward compatibility.
- Do not show token matching as a selectable option in the settings rule editor.
- Existing persisted rules using `match_mode: token` must still load without errors.
- User-visible rule details should not present token matching as a normal current option after conversion.

### 2. Convert persisted token rules to regex rules on load

- When loading persisted shielding rules, detect `ShieldMatchMode.token`.
- Convert those rules to `ShieldMatchMode.regex`.
- The converted regex should preserve the old token-style exact-token intent as much as practical.
- Escape user-provided pattern text before embedding it in regex syntax.
- Ensure conversion participates in existing dedupe behavior so a legacy token rule and its converted regex equivalent do not create duplicated user-visible rules.
- Preserve rule type, scope, action, enabled state, source, id/update metadata unless a local pattern requires changing metadata for migration clarity.

### 3. New user/UP keyword quick actions must create regex rules

- The recommendation shield dialog UP row ordinary `屏蔽` button still creates `ShieldRuleType.userKeyword`.
- The new rule must use `ShieldMatchMode.regex`, not `ShieldMatchMode.token`.
- The pattern must be generated from the current editable UP text field value.
- The generated regex must escape regex metacharacters from the UP text.
- UID shielding remains unchanged:
  - type: `ShieldRuleType.uid`
  - match mode: `ShieldMatchMode.exact`
  - pattern source: original UID, not edited UP text

### 4. Compatibility boundaries

- Do not remove `ShieldMatchMode.token` from serialized model support.
- Do not break old rule import, legacy text import, dedupe, corrupted JSON bypass, or global/recommendation/comment switch behavior.
- Do not change exact matching semantics for title, reason, UID, category, tag, or comment rules except where token rules are converted.

## Suggested Test Coverage

- Settings rule editor match-mode dropdown does not contain `词元匹配`.
- Persisted JSON containing `match_mode: token` loads successfully.
- A persisted token `userKeyword` rule becomes a regex rule after load.
- Converted regex still matches the intended UP/user token.
- Converted regex escapes special characters in user text.
- UP row ordinary `屏蔽` creates `userKeyword` with `ShieldMatchMode.regex`.
- UP row ordinary `屏蔽` uses the edited UP text field value.
- UID quick action still creates `ShieldMatchMode.exact` and uses the original UID after UP text editing.
- Existing legacy/imported rules still categorize by real type and do not reappear under a visible legacy bucket.

## Acceptance Criteria

- Users cannot choose token matching from normal settings UI.
- Existing token rules do not disappear or crash loading.
- Existing token rules behave through converted regex matching.
- New UP keyword quick-action rules are regex rules.
- Other accepted `phase-1-prebuild.26797160689` behavior remains unchanged.
