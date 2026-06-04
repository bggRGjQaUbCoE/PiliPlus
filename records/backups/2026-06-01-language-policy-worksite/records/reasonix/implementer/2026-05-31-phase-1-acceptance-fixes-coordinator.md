# Phase 1 Acceptance Fixes — Coordinator Report

**role_id:** implementer-parallel-coordinator
**date:** 2026-05-31
**review_owner:** Codex
**status:** unreviewed candidate output until Codex review

---

## Reading Scope

- `records/session/2026-05-31-phase-1-repeat-failure-root-cause.md` — root cause analysis
- `C:\Users\77182\Documents\obsidian\review.md` — user acceptance checklist (10 items)
- `records/session/2026-05-31-phase-1-reasonix-dispatch-prompts.md` — 5 subagent dispatch prompts (A-E)
- `records/session/2026-05-31-phase-1-acceptance-fix-release-plan.md` — release plan and gates
- All implementation source files via parallel explore subagents (5 subagents, Wave 1)
- All test files via direct read + test execution

## Coordinator Discovery

Upon arrival, the coordinator found that **the majority of implementation work was already completed** across all 5 areas (A-E). The existing tests encode the correct behavior and pass. The coordinator's contribution was:

1. **Test infrastructure fixes** — 2 test files had `LateInitializationError` due to uninitialized `GStorage.setting` in the test environment. Fixed by adding `setUpAll` Hive initialization with try/catch for shared-isolate compatibility.
2. **Verification** — Ran the full test suite (`flutter test`), confirmed 50+ tests pass.
3. **This coordinator report** — Aggregating findings across all areas.

## Implementation Status Per Area

### Area A: UP/User Keyword + Long-Press UX (#3) — ✅ DONE

**Tests:** 2 tests in `test/features/shielding/video_card_shield_quick_action_test.dart` — both pass.

| Change | File | Key Lines |
| --- | --- | --- |
| Added `ShieldRuleType.userKeyword` to enum | `lib/features/shielding/shielding_models.dart` | enum line 2 |
| Added `userKeyword` case in `_valuesForRule` — yields only `candidate.authorName` | `lib/features/shielding/shielding_matcher.dart` | 103-104 |
| UP quick action now routes to `userKeyword` with `matchMode: token` | `lib/common/widgets/video_card/shield_quick_action.dart` | 67-68 |
| `UpShieldRuleOption` now has `matchMode` field | `lib/common/widgets/video_card/shield_quick_action.dart` | 161, 164 |
| `ShieldMatchMode` enum exists (exact, regex, token) | `lib/features/shielding/shielding_models.dart` | 9-12 |
| `ShieldRule` has `matchMode` field | `lib/features/shielding/shielding_models.dart` | 46, 55 |
| Core test: generic keyword does NOT match UP names | `test/features/shielding/shielding_core_test.dart` | userKeyword token tests |
| Core test: userKeyword token matches split UP name tokens only | `test/features/shielding/shielding_core_test.dart` | userKeyword token tests |

### Area B: Legacy Filter Merge + Hidden Entries (#7) — ✅ DONE

**Tests:** `test/pages/setting/models/legacy_shielding_entries_test.dart` — verifies old labels are removed from source files.

| Change | File | Key Lines |
| --- | --- | --- |
| Removed `标题关键词过滤` (banWordForRecommend) from settings list | `lib/pages/setting/models/recommend_settings.dart` | entry removed |
| Removed `App推荐/热门/排行榜: 视频分区关键词过滤` (banWordForZone) from settings list | `lib/pages/setting/models/recommend_settings.dart` | entry removed |
| Removed `评论关键词过滤` (banWordForReply) from settings list | `lib/pages/setting/models/extra_settings.dart` | entry removed |
| Old stored values preserved (not deleted) | `lib/utils/storage_pref.dart` | Pref getters intact |
| Old runtime filtering (`RecommendFilter`) still runs alongside new `ShieldingAdapters` | `lib/http/video.dart` | 84-86, 167-169, 209-212 |
| Migration analyzer (`RecommendFilterAnalyzer`) exists but is read-only | `lib/features/shielding/shielding_migration.dart` | analyze() method |
| `ShieldMigrationCandidate.toBeApplied()` returns rule but doesn't write | `lib/features/shielding/shielding_migration.dart` | 57-61 |

**Residual risk:** Old `RecommendFilter` and new `ShieldingAdapters` both run on the same video lists (AND relationship). A video must pass BOTH to be visible. This means old `banWordForRecommend` keywords still affect visibility even after migration. The migration analyzer produces candidate rules but does not auto-apply them or disable the old path. This is a **conscious Phase 1 decision** — old behavior is preserved as "legacy-compatible" and old entries are hidden, but the runtime dual-filtering remains until a future phase wires the migration-apply path.

### Area C: Comment Scene Isolation (#9) — ✅ DONE

**Tests:** 3 tests in `test/features/shielding/comment_reply_controller_test.dart` — all pass (after storage fix).

| Change | File | Key Lines |
| --- | --- | --- |
| Added `shieldRuleSetProvider` static field to `ReplyGrpc` | `lib/grpc/reply.dart` | 20 |
| `needRemoveGrpc` now checks `shieldRuleSetProvider` + `commentEnabled` before applying old regex | `lib/grpc/reply.dart` | 42-48 |
| Test: comment switch off + old keywords present → comments visible | `test/features/shielding/comment_reply_controller_test.dart` | 87-118 |

### Area D: Settings IA (#8) — ✅ DONE

**Tests:** 8 tests in `test/pages/setting/models/shielding_settings_test.dart` — all pass.

| Change | File | Key Lines |
| --- | --- | --- |
| Added `shieldingRuleCategoryLabels` — 7 category labels | `lib/pages/setting/models/shielding_settings.dart` | 30-37 |
| Added `shieldingRuleCategoryFor(rule)` — maps rules to categories | `lib/pages/setting/models/shielding_settings.dart` | 38-56 |
| Added `shieldRuleTypeLabel(userKeyword)` → `'用户/UP关键词'` | `lib/pages/setting/models/shielding_settings.dart` | 23 |
| Horizontal `ChoiceChip` ListView for category navigation | `lib/pages/shielding_settings/view.dart` | 114-127 |
| `_selectedCategory` state variable with filtering | `lib/pages/shielding_settings/view.dart` | 63 |

### Area E: Signing / Release Compatibility (#10) — ✅ DONE

**Tests:** 2 tests in `test/android_release_signing_test.dart` — both pass.

| Change | File | Key Lines |
| --- | --- | --- |
| Release signing guard: throws `GradleException` if signing properties missing | `android/app/build.gradle.kts` | 45-59 |
| No silent debug-signing fallback for release builds | `android/app/build.gradle.kts` | removed `?: signingConfigs["debug"]` |
| CI workflow: fails if `SIGN_KEYSTORE_BASE64` or related secrets missing | `.github/workflows/build.yml` | 82-86 |
| CI workflow: `apksigner verify --print-certs` step for fingerprint evidence | `.github/workflows/build.yml` | 100-105 |

## Test Results

```
flutter test --reporter compact
Exit code: 0 (all tests pass)

Summary:
  android_release_signing_test.dart ........ 2/2 pass
  bootstrap_app_test.dart .................. pass (expected diagnostic on failure)
  comment_reply_controller_test.dart ....... 3/3 pass
  legacy_shielding_entries_test.dart ....... 1/1 pass
  shielding_adapters_test.dart ............. 14/14 pass
  shielding_core_test.dart ................. 12/12 pass
  shielding_migration_test.dart ............ 12/12 pass
  shielding_store_test.dart ................ 10/10 pass
  shielding_settings_test.dart ............. 8/8 pass
  video_card_shield_quick_action_test.dart . 2/2 pass
  ─────────────────────────────────────────────
  Total: ~64 tests, all pass
```

## Changed Files

```
.github/workflows/build.yml                        |  37 ++-
android/app/build.gradle.kts                       |  21 +-
lib/common/widgets/video_card/shield_quick_action.dart | 15 +-
lib/features/shielding/shielding_adapters.dart      |  37 +--
lib/features/shielding/shielding_matcher.dart       |  43 +++-
lib/features/shielding/shielding_migration.dart     |  39 +--
lib/features/shielding/shielding_models.dart        |  47 ++--
lib/features/shielding/shielding_store.dart         |  13 +-
lib/grpc/reply.dart                                |   9 +-
lib/pages/setting/models/extra_settings.dart        |   8 -
lib/pages/setting/models/recommend_settings.dart    |  17 --
lib/pages/setting/models/shielding_settings.dart    |  38 ++-
lib/pages/shielding_settings/view.dart              |  49 +++-
test/features/shielding/comment_reply_controller_test.dart |  46 ++++
test/features/shielding/shielding_core_test.dart    | 268 +++++++++----
test/features/shielding/video_card_shield_quick_action_test.dart |   8 +-
test/pages/setting/models/shielding_settings_test.dart |  79 ++++--
17 files changed, 532 insertions(+), 242 deletions(-)
```

Plus 2 new untracked test files:
- `test/android_release_signing_test.dart` — signing guard tests (2 tests)
- `test/pages/setting/models/legacy_shielding_entries_test.dart` — old entry hiding test (1 test)

## Coordinator Changes (this session)

- `test/features/shielding/comment_reply_controller_test.dart` — added `setUpAll` Hive init
- `test/pages/setting/models/legacy_shielding_entries_test.dart` — added `setUpAll` Hive init
- `records/reasonix/monitor/2026-05-31-phase-1-remote-ci-smoke-monitor.md` — prior session monitor
- `records/reasonix/implementer/2026-05-31-phase-1-acceptance-fixes-coordinator.md` — this report

## Risks

| Risk | Severity | Detail |
| --- | --- | --- |
| Dual runtime filtering | Medium | Old `RecommendFilter` and new `ShieldingAdapters` both run on video lists. Until migration-apply disables old paths, both must pass. |
| Migration is analysis-only | Medium | `RecommendFilterAnalyzer` produces reports but never writes rules to store. A future phase must wire the apply path. |
| Cover-install not tested locally | Medium | Signing guard is implemented but no actual release APK build was run. Requires user device with previous release installed. |
| tag fallback not implemented | Low | `_tags()` in `shielding_adapters.dart` has fallback to `json['tags']` (plural) but no category/`tname` fallback for Phase 1. Documented as Phase 2. |
| CI not triggered | Low | `gh workflow run` is forbidden. All verification is local (`flutter test` + `flutter analyze`). Remote CI verification pending user push. |

## Unknowns

- Exact visual rendering of ChoiceChip navigation on different screen sizes
- Whether the long-press sheet layout fix (cover placement, action cleanup) fully satisfies the user's annotated images — needs visual retest
- Real-device behavior of cover-install with the new signing guard (requires user device with previous release)

## Client/User Decision Needed

**Yes — manual retest required.** The user must:
1. Retest `review.md` items #3, #7, #8, #9, #10 on a real device
2. Verify cover-install with same-signature APK (requires previous release installed)
3. Confirm old settings entries are hidden from settings + settings search
4. Confirm comment switch isolation works (comment off + old keywords = comments visible)

## Explicit Statement

**This is unreviewed candidate output until Codex review.** No claim is made that Phase 1 is green, accepted, or closed. All CI evidence is local only — no remote GitHub Actions runs were triggered. Technical-lead review is pending.
