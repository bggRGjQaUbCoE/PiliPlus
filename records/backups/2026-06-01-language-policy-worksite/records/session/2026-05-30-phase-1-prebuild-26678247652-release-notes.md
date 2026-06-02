# Phase 1 Prebuild - Manual Acceptance

## Purpose

Validation-only prebuild for Phase 1 shielding repair. This release is for
automated verification, Android runtime smoke, and user/manual acceptance. It is
not stable, not latest, and not formal Phase 1 acceptance.

`phase-1-prebuild.26675065521` is a failed Phase 1 shielding package. It is
retained only as failed history and must not be reused as acceptance evidence.

## Release Type

prebuild

This GitHub Release is marked as a pre-release.

## Branch / Commit / Tag

- Repository: `CometDash77/PiliAvalon-Worksite`
- Branch: `phase-1-shielding-core`
- Commit: `75eb67d337eb986201a99ba0044ea3729fe2fce6`
- Tag: `phase-1-prebuild.26678247652`
- Tag target: `75eb67d337eb986201a99ba0044ea3729fe2fce6`
- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26678247652

## Related PRs / Issues

- PR: none
- Worksite declaration: `records/session/2026-05-30-phase-1-shielding-repair-worksite-declaration.md`
- Failed prior package: `phase-1-prebuild.26675065521`
- Superseded package: `phase-1-prebuild.26677982092` because its tag targeted `main`

## Automation Evidence

- Phase 1 Shielding Verify: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26677182554
  - Commit: `75eb67d337eb986201a99ba0044ea3729fe2fce6`
  - Result: success
  - Covered: `flutter test test/features/shielding`, `flutter test test/pages/setting/models/shielding_settings_test.dart`, bootstrap startup test, `flutter analyze --no-fatal-infos`.
- Android build/release: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26678247652
  - Commit: `75eb67d337eb986201a99ba0044ea3729fe2fce6`
  - Result: success
  - APK assets:
    - `PiliAvalon_android_2.0.7-75eb67d33+5028_arm64-v8a.apk`
    - `PiliAvalon_android_2.0.7-75eb67d33+5028_armeabi-v7a.apk`
    - `PiliAvalon_android_2.0.7-75eb67d33+5028_x86_64.apk`
- Android runtime smoke: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26678391077
  - Commit: `75eb67d337eb986201a99ba0044ea3729fe2fce6`
  - Artifact source run: `26678247652`
  - Result: success
  - Evidence artifact: `android-runtime-smoke-evidence`

## Manual Acceptance

Status: pending.

Required user/manual acceptance checks:

- Install the new prebuild APK.
- First screen is nonblank and not a startup failure screen.
- Homepage recommendation shielding quickAction can be created from content and the affected recommendation disappears immediately or after refresh.
- Video title, uploader, tags, and related-video surfaces can create shielding rules and related videos are filtered.
- Main comments, child comments, and preview child replies are filtered.
- Free copy remains available.
- Closing the total shielding switch restores recommendation, related-video, and comment content.
- Existing `piliavalon.shielding.v1` rules and switches survive upgrade.

## Changes

- Repaired comment shielding testability by letting `ReplyController` use an overridable `shieldingRuleSet`.
- Preserved production shielding store path while avoiding uninitialized `GStorage.setting` in focused tests.
- Carries the Phase 1 repair set from commit `5bd4b700190382a919c0bc8a58680f5a9f731bac`, including matcher semantics, quickAction helper, homepage/video adapters, and comment filtering.

## Known Risks

- Manual acceptance is still pending.
- This is a validation prebuild only; it is not stable/latest.
- `phase-1-prebuild.26677982092` is superseded because its release tag targeted `main` even though its APK build was from the repair commit.
- Local network artifact downloads were unstable; APK publication used the GitHub runner release path instead of local artifact download/re-upload.

## Sources / License / Attribution

No new external source code was copied for this repair. Existing project dependencies remain under their existing licenses.

## Rollback Plan

If automated, runtime-smoke, or manual-acceptance evidence later fails:

- Do not mark Phase 1 green, stable, latest, accepted, or complete.
- Keep this prebuild as a pre-release evidence record.
- Do not reuse `phase-1-prebuild.26675065521`, `phase-1-prebuild.26677982092`, or any failed/superseded package as acceptance evidence.
- Revert or supersede commit range ending at `75eb67d337eb986201a99ba0044ea3729fe2fce6` on `phase-1-shielding-core`, then publish a later prebuild with fresh focused tests, analyze, Android build, runtime smoke, and release notes.

## Not Covered / Still Yellow

- User/manual acceptance is pending.
- Stable/latest release approval is not covered.

## User Action Required

Install an APK from `phase-1-prebuild.26678247652` and complete the manual acceptance checks above. Do not use `phase-1-prebuild.26675065521` or `phase-1-prebuild.26677982092` for acceptance.
