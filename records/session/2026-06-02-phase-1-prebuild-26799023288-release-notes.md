Audience classification: agent-facing

# Phase 1 Prebuild - Manual Acceptance

## Purpose

This is the accepted prebuild package for Phase 1 token-match deprecation validation. It is not a stable/latest release, but it is the user-accepted Phase 1 closure package as of 2026-06-02.

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

Passed by user report on 2026-06-02.

Raw user acceptance feedback:

```text
好了，目前这个问题已经完全消失，我觉得phase1可以宣告结束，虽然还是有不少问题我想提，但我觉得作为phase1已经彻底结束了，更新一切该更新的，持久化一切该持久化的，接下来还需要通知设计院准备phase2
```

Interpretation: the token-match deprecation issue and Phase 1 acceptance blockers are accepted as resolved for `phase-1-prebuild.26799023288`. The user explicitly closed Phase 1 and deferred remaining/new issues to Phase 2 planning.

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

- This is still a prebuild package, not a stable/latest release.
- Token mode remains in code for compatibility, so internal tests and migration code still reference it intentionally.
- Remaining/new product issues mentioned by the user are deferred to Phase 2; they are not Phase 1 blockers.

## Sources / License / Attribution

No new external source code, media, or third-party assets were copied for this package. The changes are internal worksite Flutter/Dart edits in the existing project codebase and remain under the repository's existing licensing posture.

## Rollback Plan

If a regression is later found, keep this tag as Phase 1 acceptance evidence and open a Phase 2 or hotfix track with fresh scope and verification. Do not mark `phase-1-prebuild.26799023288` stable/latest without a separate stable-release approval.

## Not Covered / Still Yellow

- Stable/latest release approval is not covered by this prebuild.
- Phase 2 scope is not defined in this release note.
- Remaining/new product issues are not Phase 1 blockers after the user's closure decision.

## User Action Required

No further Phase 1 retest action is required after the user's acceptance. Prepare Phase 2 planning for the remaining/new issues the user wants to raise.
