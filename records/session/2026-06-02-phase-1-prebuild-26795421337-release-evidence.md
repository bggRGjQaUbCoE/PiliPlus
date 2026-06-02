Audience classification: agent-facing

# Phase 1 Prebuild 26795421337 Release Evidence

Date: 2026-06-02
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `phase-1-shielding-core`
Release type: `prebuild`
Owner: Codex
Status: published as prerelease for manual acceptance; Phase 1 remains yellow

## Summary

Codex fixed the latest Phase 1 CI failure, verified the latest branch head with `Phase 1 Shielding Verify`, dispatched an Android-only `Build` workflow, and verified the resulting GitHub prerelease and APK assets remotely. APKs were not downloaded locally.

## Code Changes

Latest release commit:

- `d63007d0b91dd08fee3f999bf6bee049f2034832`
- Commit message: `Fix recommendation cover URL normalization`

Relevant preceding fix commits in this session:

- `3611f70e4e0c1f0415d33e10d3b20a78263d33ac` - `Fix recommendation shield dialog CI failure`
- `1e920e3e9f2afce536f3687c13fb1a6e25432c86` - `Stabilize recommendation cover preview test`

The recommendation cover preview still appears when `cover` is non-empty. The inline `保存封面` and `取消` actions remain under the preview. Cover-present dialogs still omit duplicate bottom actions. UP username remains editable. UID action still uses the original UID.

## Verification Evidence

Local verification:

- `flutter test test/features/shielding/video_card_shield_quick_action_test.dart test/pages/setting/models/shielding_settings_test.dart`
- Result: blocked locally because `flutter` was not available in the shell (`/bin/bash: line 1: flutter: command not found`).

GitHub Actions verification:

- Workflow: `Phase 1 Shielding Verify`
- Run ID: `26795348737`
- Run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26795348737`
- Trigger: `workflow_dispatch`
- Head SHA: `d63007d0b91dd08fee3f999bf6bee049f2034832`
- Conclusion: `success`
- Job: `Focused Flutter verification`
- Passed steps:
  - `Run shielding tests`
  - `Run settings model test`
  - `Run bootstrap startup test`
  - `Analyze`

Superseded failed runs:

- `26794928915`: failed before this session because `NetworkImgLayer` read uninitialized `GStorage.setting` in the recommendation cover preview test.
- `26795188051`: failed on commit `3611f70e4e0c1f0415d33e10d3b20a78263d33ac` because `cover.http2https` was not available from the current imports.
- `26795288458`: superseded by commit `d63007d0b91dd08fee3f999bf6bee049f2034832`; not used as release evidence.

## Build Evidence

- Workflow: `Build`
- Run ID: `26795421337`
- Run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26795421337`
- Head SHA: `d63007d0b91dd08fee3f999bf6bee049f2034832`
- Conclusion: `success`
- Android job: `Release Android`
- Android job URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26795421337/job/78990582589`
- Non-Android jobs skipped:
  - `win_x64`
  - `ios`
  - `mac`
  - `linux_x64`

## Release Evidence

- Release tag: `phase-1-prebuild.26795421337`
- Release title: `Phase 1 Prebuild - Manual Acceptance`
- Release URL: `https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26795421337`
- Draft: `false`
- Prerelease: `true`
- Target commitish: `d63007d0b91dd08fee3f999bf6bee049f2034832`
- Published at: `2026-06-02T03:00:04Z`

APK assets:

- `PiliAvalon_android_2.0.7-d63007d0b+5057_arm64-v8a.apk`
- `PiliAvalon_android_2.0.7-d63007d0b+5057_armeabi-v7a.apk`
- `PiliAvalon_android_2.0.7-d63007d0b+5057_x86_64.apk`

Signing fingerprint for all APKs:

- `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

## Release Notes

The GitHub Release notes were updated to include the required worksite release-governance sections:

- Purpose
- Release Type
- Branch / Commit / Tag
- Related PRs / Issues
- Automation Evidence
- Manual Acceptance
- Changes
- Known Risks
- Sources / License / Attribution
- Rollback Plan
- Not Covered / Still Yellow
- User Action Required

The notes explicitly state this is a prerelease prebuild for validation only and that Phase 1 remains yellow until real-device retest and user/client acceptance.

## Manual Acceptance

Manual acceptance status: pending.

Required follow-up:

- Install one APK over the existing app without uninstall.
- Confirm signing/cover-install compatibility on the target device.
- Retest the Phase 1 recommendation shielding acceptance items on a real device.
- Collect user/client acceptance before any stable/latest claim.

## Known Yellow Items

- Real-device runtime retest is pending.
- User/client acceptance is pending.
- This is not a stable release.
- This prebuild does not close Phase 1.

## Rollback

If this prebuild is unsuitable, keep or return to the prior accepted APK and supersede this tag with a newer prebuild after another verified fix. Do not mark `phase-1-prebuild.26795421337` as stable/latest.

## Command Scope Confirmation

All GitHub CLI commands in this release sequence used explicit repository scoping with `-R CometDash77/PiliAvalon-Worksite`.

