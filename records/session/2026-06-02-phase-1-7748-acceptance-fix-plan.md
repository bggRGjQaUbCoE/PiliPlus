Audience classification: dual-use

# Phase 1 7748 Acceptance Judgment And Fix Plan

## Chinese Decision Summary

`phase-1-prebuild.26714387748` 不能关闭 Phase 1 手工验收，状态保持黄灯/失败待修。7748 不是 Phase 1 通过包；用户反馈构成产品修复需求。修复完成后必须重新出 prebuild APK，并重新做真实设备验收。新包仅作为复测包，不标记 stable，不关闭 Phase 1。

原始用户反馈保留为源材料，不改写为代理结论：

- Source: `/home/mo/Documents/obsidian/未命名.md`
- Screenshot evidence: `/home/mo/Documents/obsidian/assets/未命名/Screenshot_2026-06-02-10-00-56-236_com.example.pi.jpg`

验收目标：

- Release tag: `phase-1-prebuild.26714387748`
- Run ID: `26714387748`
- Commit: `e8e96787dabb5403348b5c1d71f7ba40970b0dcc`

## English Technical Body

### Corrected Acceptance Findings

- The finding that the UP username keyword path lacks an editable text field is valid.
- The finding that title keyword rules are incorrectly categorized as exact text is valid.
- The prior assertion about comment keywords requires correction: current quick comment actions use `ShieldScope.comment`, so categorization should prefer the comment scope. This remains a regression test item, not a confirmed implementation defect in the comment quick-add path.
- The finding that the recommendation shielding dialog lacks cover preview and places save/cancel controls in the wrong location is valid.

### Fix Scope

- Add a cover preview to `VideoCardShieldQuickAction.showRecommendationDialog()` when `cover` is non-empty.
- Place `保存封面` and `取消` directly under the preview.
- Avoid duplicate bottom `AlertDialog.actions` buttons for cover-present dialogs.
- Convert `_UpActionRow` from static UP-name text to an editable `TextField`.
- Make copy and username-keyword shield actions use the current edited UP text, preferring selected text when present.
- Keep UID shielding tied to the original UID, unaffected by UP-name edits.
- Keep username keyword quick rules as `ShieldRuleType.userKeyword`, `ShieldMatchMode.token`, and `ShieldScope.recommendation`.
- Update `shieldingRuleCategoryFor()` so:
  - `ShieldRuleType.keyword + ShieldScope.comment` maps to `评论关键词`.
  - `ShieldRuleType.keyword + ShieldScope.recommendation` maps to `标题关键词`.
  - `ShieldRuleType.keyword + ShieldScope.both` maps to `标题关键词`, because keyword exact mode currently means literal contains, not full-text equality.
  - `keyword + exact` no longer automatically maps to `精确文本`.

### Verification Plan

- `flutter test test/features/shielding/video_card_shield_quick_action_test.dart test/pages/setting/models/shielding_settings_test.dart`
- If the touched surface warrants broader regression coverage: `flutter test test/features/shielding`
- `flutter analyze --no-fatal-infos`

### Acceptance Criteria

- On the home recommendation feed, long-pressing a video card opens a dialog with cover preview.
- `保存封面` and `取消` are placed under the preview.
- Title shielding remains editable and can add a rule.
- UP username keyword shielding is editable and uses the edited text for the user keyword rule.
- UID shielding still uses the original UID and is not affected by UP-name text edits.
- Title keyword rules appear under `标题关键词` in settings.
- Comment keyword rules appear under `评论关键词` in settings.
- After fixes, publish a new prebuild APK for retesting only; do not mark stable and do not close Phase 1.
