# Phase 1 Acceptance Fixes — Codex Review

Date: 2026-05-31
Review owner: Codex
Reviewed artifact:

- `records/reasonix/implementer/2026-05-31-phase-1-acceptance-fixes-coordinator.md`

Status: accepted with release gates still open

## Scope

Codex reviewed the Reasonix coordinator report, local diff, `review.md` blockers #3/#7/#8/#9/#10, and fresh local verification. Reasonix output remains a candidate unless matched by this Codex review.

## Findings

### #3 UP/User Keyword

Accepted.

- `ShieldRuleType.userKeyword` exists.
- Generic `keyword` no longer matches `authorName`.
- UP quick action stores username shielding as `userKeyword` with `ShieldMatchMode.token`.
- Focused tests verify generic keyword does not match UP names and user keyword token rules match split UP name tokens.

### #7 Legacy Filter Merge

Reasonix coordinator output was not sufficient as first written because it explicitly left old `RecommendFilter` and new `ShieldingAdapters` running as a dual AND filter. Codex treated that as a remaining blocker and corrected it in this pass.

Accepted after Codex follow-up changes:

- Hidden old visible settings entries remain removed:
  - `标题关键词过滤`
  - `App推荐/热门/排行榜: 视频分区关键词过滤`
  - `评论关键词过滤`
- Old stored values are not deleted.
- Old text rules are imported/merged into the new shielding rule set as `ShieldRuleSource.imported`:
  - `banWordForRecommend` -> recommendation keyword rules
  - `banWordForZone` -> recommendation category rules
  - `banWordForReply` -> comment keyword rules
- Imported legacy text rules are persisted on first save and marked with `piliavalon.shielding.v1.legacy_text_imported`, so user-managed imported rules are not regenerated after deletion.
- Direct old text filtering paths are disabled by default after merge:
  - `RecommendFilter.filterTitle`
  - `ReplyGrpc.needRemoveGrpc` old reply regex path
  - `VideoHttp` old zone text checks
- Old numeric recommendation filters remain in place because duration/play/like thresholds are not text shielding rules and still have visible non-shielding settings entries.

### #8 Settings IA

Accepted for Phase 1.

- `ShieldingSettingsPage` has same-row horizontal category navigation using `ChoiceChip`.
- Category labels cover user/UP, title keyword, tag, category, comment keyword, exact text, and legacy-compatible rules.
- The list switches by selected category.

Residual UX risk: this was verified by widget tests, not a visual screenshot pass.

### #9 Comment Scene Isolation

Accepted.

- Comment-scoped ShieldingAdapters filtering obeys `commentEnabled`.
- Old `ReplyGrpc` keyword path is disabled by default after merge and still obeys `commentEnabled` if explicitly re-enabled for compatibility tests.
- Text-selection comment quick action now writes only to the new shielding rule store, not `banWordForReply`.

### #10 Signing / Cover Install

Accepted for local code review, not accepted as release evidence.

- Release Gradle config fails non-dev release builds without signing config.
- Workflow dispatch release fails if signing secrets are missing.
- Workflow captures `apksigner verify --print-certs` evidence.

Release remains blocked until remote build/signing evidence and real-device cover-install evidence exist.

## Reasonix Artifact Quality

The coordinator report is useful but has limitations:

- It correctly identifies many implementation areas and test targets.
- It originally marked #7 done while also admitting runtime dual-filtering remained. Codex rejected that part and fixed the blocker.
- Separate verifier output contains contradictory statements: one section claims commands were actually run, while a later section says the commands were not run and are templates. Codex therefore did not use that report as final verification evidence.
- Monitor output claims remote CI/build/smoke success, but Codex did not independently monitor GitHub runs in this pass and does not use it as release authorization.

## Fresh Codex Verification

Commands run locally:

```text
flutter test test\features\shielding\shielding_store_test.dart
```

Result:

```text
13 tests passed
```

```text
flutter test test\features\shielding test\pages\setting\models\shielding_settings_test.dart test\pages\setting\models\legacy_shielding_entries_test.dart test\android_release_signing_test.dart
```

Result:

```text
66 tests passed
```

```text
flutter analyze --no-fatal-infos
```

Result:

```text
exit 0; 50 info-level issues, no fatal analyzer errors under --no-fatal-infos
```

```text
git diff --check
```

Result:

```text
exit 0; CRLF warnings only
```

## Review Decision

Implementation candidate is accepted for local Phase 1 acceptance-fix scope.

This is not a release approval and not a Phase 1 green decision. Remaining gates:

- Reasonix, manually triggered by the user, must monitor any remote GitHub build/release workflow.
- Signing fingerprint evidence must be reviewed from persisted artifacts.
- User must perform real-device cover install without uninstall.
- User must complete manual retest for #3/#7/#8/#9/#10.
