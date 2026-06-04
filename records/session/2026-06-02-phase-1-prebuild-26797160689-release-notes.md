Audience classification: agent-facing

# Phase 1 Prebuild - Manual Acceptance

## Purpose

This is a formal prebuild package for user/manual validation of the Phase 1 shielding feedback fixes. It is not a stable release, does not mark Phase 1 green, and must not be treated as latest/stable acceptance evidence until the user completes real-device retesting.

## Release Type

`prebuild`

## Branch / Commit / Tag

- Branch: `phase-1-shielding-core`
- Commit: `7ded76b1c73b95eabd9de2a28f84311d8bb8e3cd`
- Tag: `phase-1-prebuild.26797160689`
- Release title: `Phase 1 Prebuild - Manual Acceptance`
- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26797160689
- Version: `2.0.7-7ded76b1c+5060`

## Related PRs / Issues

- Phase 1 shielding manual acceptance/user feedback follow-up.
- Worksite feedback report: `records/session/2026-06-02-phase-1-user-feedback-technical-report.md`
- Supersedes `phase-1-prebuild.26795421337` for this specific feedback retest because the new package includes the UP quick-action, recommendation-reason, and settings-category fixes.

## Automation Evidence

- Phase 1 Shielding Verify: success
  - Run ID: `26797083508`
  - URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26797083508
  - Head SHA: `7ded76b1c73b95eabd9de2a28f84311d8bb8e3cd`
  - Covered: `flutter test test/features/shielding`, `flutter test test/pages/setting/models/shielding_settings_test.dart`, `flutter test test/bootstrap/bootstrap_app_test.dart`, and `flutter analyze --no-fatal-infos`.
- Android-only Build: success
  - Run ID: `26797160689`
  - URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26797160689
  - Head SHA: `7ded76b1c73b95eabd9de2a28f84311d8bb8e3cd`
  - Android job: `Release Android`
  - Non-Android jobs: skipped by workflow-dispatch inputs.
- Attached release APK assets:
  - `PiliAvalon_android_2.0.7-7ded76b1c+5060_arm64-v8a.apk`
  - `PiliAvalon_android_2.0.7-7ded76b1c+5060_armeabi-v7a.apk`
  - `PiliAvalon_android_2.0.7-7ded76b1c+5060_x86_64.apk`

### Android Release Signing Evidence

| APK | SHA-256 fingerprint |
|---|---|
| `PiliAvalon_android_2.0.7-7ded76b1c+5060_arm64-v8a.apk` | `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |
| `PiliAvalon_android_2.0.7-7ded76b1c+5060_armeabi-v7a.apk` | `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |
| `PiliAvalon_android_2.0.7-7ded76b1c+5060_x86_64.apk` | `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |

Cover-install verification requires:

- same applicationId: `com.example.piliplus`
- same signing certificate fingerprint as the installed release
- install over existing app without uninstall

## Manual Acceptance

Pending.

This prebuild exists for user real-device retesting. CI/build success does not close manual acceptance, technical-lead review, runtime smoke, or client/user acceptance gates.

## Changes

- UP quick-action row now presents the ordinary `复制` / `屏蔽` / `屏蔽用户 UID: <uid>` shape.
- UP ordinary `屏蔽` creates a `userKeyword` token rule from the current editable UP text.
- UID shielding still uses the original UID and is not affected by editing the UP text field.
- Recommendation reason is now represented as `ShieldRuleType.reasonKeyword`.
- `ShieldCandidate` now carries a recommendation `reason` field.
- Recommendation JSON/app adapter maps `rcmd_reason` into the shielding candidate.
- `reasonKeyword` matching is restricted to recommendation reason text and does not match title, UP, or comment text.
- Recommendation reason quick action creates a recommendation-reason rule.
- Settings category navigation now includes `推荐理由` and removes visible `精确文本` / `旧规则兼容` categories.
- Imported/legacy rules still load through the existing compatibility path and now categorize by actual rule type instead of a source-only legacy bucket.

## Known Risks

- This is a prebuild validation package. It has not been accepted by the user on a real device.
- Runtime smoke and user manual acceptance remain separate gates.
- The network-unreachable video host message in the raw user feedback is not addressed by this shielding-focused package because it was not established as part of the Phase 1 shielding bug.

## Sources / License / Attribution

No new external source code, media, or third-party assets were copied for this package. The changes are internal worksite Flutter/Dart edits in the existing project codebase and remain under the repository's existing licensing posture.

## Rollback Plan

If this prebuild is unsuitable, keep or return to the prior acceptable APK and supersede this tag with a newer prebuild after another verified fix. Do not mark `phase-1-prebuild.26797160689` stable/latest. Preserve this release as prebuild evidence and do not reuse it as acceptance evidence unless the user explicitly passes real-device retesting.

## Not Covered / Still Yellow

- User real-device retest is pending.
- Manual acceptance is pending.
- Runtime smoke is not closed by this release note.
- Technical-lead/client acceptance is not closed by CI or build success.
- Phase 1 remains yellow until all required gates are explicitly closed with fresh evidence.

## User Action Required

Install the matching Android APK for the test device ABI from this prerelease and retest the Phase 1 shielding feedback items:

- UP row ordinary `屏蔽` behavior and original UID behavior.
- Recommendation reason rule creation, categorization, and matching.
- Settings page absence of `精确文本` and `旧规则兼容` visible category pages.
