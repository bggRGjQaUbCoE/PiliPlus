Audience classification: agent-facing

# Phase 1 Prebuild - Manual Acceptance

## Purpose

This is a formal prebuild package for user/manual validation of the Phase 1 token-match deprecation fix. It is not a stable release, does not mark Phase 1 green, and must not be treated as latest/stable acceptance evidence until the user completes real-device retesting.

## Release Type

`prebuild`

## Branch / Commit / Tag

- Branch: `phase-1-shielding-core`
- Commit: `96207857252a169f92cdabd4ce28282a5d432502`
- Tag: `phase-1-prebuild.26799023288`
- Release title: `Phase 1 Prebuild - Manual Acceptance`
- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26799023288
- Version: `2.0.7-962078572+5062`

## Related PRs / Issues

- Phase 1 shielding manual acceptance/user feedback follow-up.
- Requirement record: `records/session/2026-06-02-phase-1-token-match-deprecation-requirements.md`
- Supersedes `phase-1-prebuild.26797160689` for this specific retest because this package includes the token-match deprecation and UP keyword regex quick-action behavior.

## Automation Evidence

- Phase 1 Shielding Verify: success
  - Run ID: `26798658801`
  - URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26798658801
  - Head SHA: `96207857252a169f92cdabd4ce28282a5d432502`
  - Covered: `flutter test test/features/shielding`, `flutter test test/pages/setting/models/shielding_settings_test.dart`, `flutter test test/bootstrap/bootstrap_app_test.dart`, and `flutter analyze --no-fatal-infos`.
- Phase 1 CI: success
  - Run ID: `26798658868`
  - URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26798658868
  - Head SHA: `96207857252a169f92cdabd4ce28282a5d432502`
  - Covered: focused verification, Android x86_64 artifact build, and Android emulator install/launch runtime smoke.
- Android-only Build: success
  - Run ID: `26799023288`
  - URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26799023288
  - Head SHA: `96207857252a169f92cdabd4ce28282a5d432502`
  - Android job: `Release Android`
  - Non-Android jobs: skipped by workflow-dispatch inputs.
- Attached release APK assets:
  - `PiliAvalon_android_2.0.7-962078572+5062_arm64-v8a.apk`
  - `PiliAvalon_android_2.0.7-962078572+5062_armeabi-v7a.apk`
  - `PiliAvalon_android_2.0.7-962078572+5062_x86_64.apk`

### Android Release Signing Evidence

| APK | SHA-256 fingerprint |
|---|---|
| `PiliAvalon_android_2.0.7-962078572+5062_arm64-v8a.apk` | `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |
| `PiliAvalon_android_2.0.7-962078572+5062_armeabi-v7a.apk` | `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |
| `PiliAvalon_android_2.0.7-962078572+5062_x86_64.apk` | `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |

Cover-install verification requires:

- same applicationId: `com.example.piliplus`
- same signing certificate fingerprint as the installed release
- install over existing app without uninstall

## Manual Acceptance

Pending.

This prebuild exists for user real-device retesting. CI/build/runtime-smoke success does not close manual acceptance, technical-lead review, or client/user acceptance gates.

## Changes

- `ShieldMatchMode.token` remains in serialized model support and matcher compatibility, with an inline source notice that it is no longer a user-facing mode.
- Settings rule editor no longer offers `词元匹配` in the match-mode dropdown.
- Persisted rules with `match_mode: token` load as escaped regex rules.
- Token-to-regex conversion uses delimiter-boundary matching to preserve whole-token intent for old user/UP keyword rules instead of degrading to broad contains matching.
- Converted token rules participate in existing dedupe, so equivalent legacy token and current regex rules do not appear twice.
- UP ordinary `屏蔽` creates a `userKeyword` regex rule from the current editable UP text.
- UP keyword regex generation escapes regex metacharacters from the edited text.
- UID shielding remains unchanged: original UID text, `ShieldRuleType.uid`, and `ShieldMatchMode.exact`.
- Existing token matcher tests remain in place to prove the enum and matcher branch were not removed.

## Known Risks

- This is a prebuild validation package. It has not been accepted by the user on a real device.
- Token mode remains in code for compatibility, so internal tests and migration code still reference it intentionally.
- User manual acceptance and technical-lead/client acceptance remain separate gates.

## Sources / License / Attribution

No new external source code, media, or third-party assets were copied for this package. The changes are internal worksite Flutter/Dart edits in the existing project codebase and remain under the repository's existing licensing posture.

## Rollback Plan

If this prebuild is unsuitable, keep or return to the prior acceptable APK and supersede this tag with a newer prebuild after another verified fix. Do not mark `phase-1-prebuild.26799023288` stable/latest. Preserve this release as prebuild evidence and do not reuse it as acceptance evidence unless the user explicitly passes real-device retesting.

## Not Covered / Still Yellow

- User real-device retest is pending.
- Manual acceptance is pending.
- Technical-lead/client acceptance is not closed by CI, runtime smoke, or build success.
- Phase 1 remains yellow until all required gates are explicitly closed with fresh evidence.

## User Action Required

Install the matching Android APK for the test device ABI from this prerelease and retest the Phase 1 shielding feedback items:

- `词元匹配` is no longer selectable in normal settings UI.
- Existing token rules still load and behave through converted regex matching.
- UP row ordinary `屏蔽` creates a user/UP keyword regex rule from the edited UP text.
- UID shielding still uses the original UID and exact matching.
