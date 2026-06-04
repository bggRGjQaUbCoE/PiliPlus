# Phase 1 Codex Implementation And Verification

Date: 2026-05-31
Repo: `CometDash77/PiliAvalon-Worksite`
Branch context: `phase-1-shielding-core`
Status: Codex implementation candidate reviewed locally; not a release decision; not user acceptance

## Scope

This pass addresses `review.md` blockers #3, #7, #8, #9, and #10 from:

- `C:\Users\77182\Documents\obsidian\review.md`
- `records/session/2026-05-31-phase-1-repeat-failure-root-cause.md`

Reasonix was not invoked by Codex. The user was given a prompt to trigger Reasonix manually. This record describes only Codex-local edits and verification.

## Changes

### #3 UP/User Keyword Semantics

- Added `ShieldRuleType.userKeyword`.
- Removed author/UP name matching from generic `ShieldRuleType.keyword`.
- Added author-specific token matching for `userKeyword` rules.
- Updated video-card UP quick action so username shielding creates `userKeyword` + `ShieldMatchMode.token`, while UID remains `uid`.

Key files:

- `lib/features/shielding/shielding_models.dart`
- `lib/features/shielding/shielding_matcher.dart`
- `lib/features/shielding/shielding_adapters.dart`
- `lib/common/widgets/video_card/shield_quick_action.dart`

### #7 Legacy Entry Hiding And Scene Bridge

- Removed visible old recommendation title/zone filter entries from `recommendSettings`.
- Removed visible old comment keyword entry from `extraSettings`.
- Kept old storage keys and static legacy filter state intact.
- Added legacy text import into `ShieldSettingsStore.snapshot()` / `save()`:
  - `banWordForRecommend` becomes imported recommendation keyword rules.
  - `banWordForZone` becomes imported recommendation category rules.
  - `banWordForReply` becomes imported comment keyword rules.
- Imported legacy text rules are persisted on first save and guarded by `piliavalon.shielding.v1.legacy_text_imported`, so user-deleted imported rules are not regenerated from old hidden keys.
- Disabled direct old text filtering paths by default after merge:
  - `RecommendFilter.filterTitle`
  - `ReplyGrpc.needRemoveGrpc` old reply regex path
  - `VideoHttp` old zone regex checks
- Kept old numeric recommendation filters active because duration/play/like thresholds are not text shielding rules and still have visible settings.
- Changed comment selected-text quick action to write only to the new shielding rule store, not `banWordForReply`.

Key files:

- `lib/features/shielding/shielding_store.dart`
- `lib/pages/setting/models/recommend_settings.dart`
- `lib/pages/setting/models/extra_settings.dart`
- `lib/utils/recommend_filter.dart`
- `lib/http/video.dart`
- `lib/pages/video/reply/widgets/reply_item_grpc.dart`

### #8 Settings IA

- Added horizontal `ChoiceChip` category navigation on the shielding settings page.
- Added category labels covering user/UP, title keyword, tag, category, comment keyword, exact text, and legacy-compatible rules.
- Filtered the visible rule list by selected category.

Key files:

- `lib/pages/setting/models/shielding_settings.dart`
- `lib/pages/shielding_settings/view.dart`

### #9 Comment Scene Isolation

- Added `ReplyGrpc.shieldRuleSetProvider` bridge.
- Hidden legacy reply keyword filtering now obeys `ShieldRuleSet.commentEnabled`.
- Anti-goods reply filtering remains separate because it is not the keyword shielding path described by `review.md` #9.

Key file:

- `lib/grpc/reply.dart`

### #10 Signing / Cover-Install Evidence

- Non-dev release builds now fail when release signing config is absent.
- PR/dev release builds still use `.dev` and debug signing, preserving CI/dev behavior.
- Workflow dispatch release path now fails if signing secrets are absent.
- Workflow uploads `apksigner verify --print-certs` evidence and a cover-install requirements note.

Key files:

- `android/app/build.gradle.kts`
- `.github/workflows/build.yml`

## Test-First Evidence

Initial focused red run failed before implementation with missing:

- `ShieldRuleType.userKeyword`
- `UpShieldRuleOption.matchMode`
- `ReplyGrpc.shieldRuleSetProvider`
- `shieldingRuleCategoryLabels`
- `RecommendFilter.shieldRuleSetProvider`

After implementation, the focused suite passed.

## Verification

Passing:

```text
flutter test test\features\shielding\video_card_shield_quick_action_test.dart test\features\shielding\shielding_core_test.dart test\features\shielding\shielding_adapters_test.dart test\features\shielding\comment_reply_controller_test.dart test\pages\setting\models\shielding_settings_test.dart test\pages\setting\models\legacy_shielding_entries_test.dart test\android_release_signing_test.dart
```

Result:

```text
38 tests passed
```

Later focused acceptance suite after legacy-merge follow-up:

```text
flutter test test\features\shielding test\pages\setting\models\shielding_settings_test.dart test\pages\setting\models\legacy_shielding_entries_test.dart test\android_release_signing_test.dart
```

Result:

```text
66 tests passed
```

Analyzer:

```text
flutter analyze --no-fatal-infos
```

Result:

```text
exit 0
```

Diff hygiene:

```text
git diff --check
```

Result:

```text
exit 0; CRLF warnings only
```

Final pre-commit verification in this session:

```text
git diff --cached --check
```

Result:

```text
exit 0; global ignore permission warning only
```

```text
flutter test
```

Result:

```text
67 tests passed; exit 0
```

```text
flutter analyze --no-fatal-infos
```

Result:

```text
50 info issues found; exit 0
```

Notes:

- Plain `flutter analyze` still exits 1 because this repository has existing info-level lints with fatal infos enabled by default.
- The remaining analyzer output is info-level lint/deprecation noise, mostly in existing copied Flutter widget files plus a few style suggestions. No analyzer errors or warnings were reported under `--no-fatal-infos`.

Not performed:

- No GitHub workflow run was triggered.
- No release was published.
- No Android release APK was built in this Codex pass.
- No real-device cover install was performed.

## Remaining Gates

Phase 1 is still not green until:

- Reasonix outputs, if any, are persisted and reviewed by Codex.
- GitHub release workflow/build evidence exists for the reviewed commit.
- Signing fingerprint evidence is compared against the installed release.
- User performs real-device cover install without uninstall and manual retest.
