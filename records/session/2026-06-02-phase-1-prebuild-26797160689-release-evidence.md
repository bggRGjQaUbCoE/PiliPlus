Audience classification: agent-facing

# Phase 1 Prebuild 26797160689 Release Evidence

## Summary

Published Android-only Phase 1 shielding feedback prebuild `phase-1-prebuild.26797160689` from verified commit `7ded76b1c73b95eabd9de2a28f84311d8bb8e3cd`.

Release type: `prebuild`.

Phase 1 remains yellow. Manual acceptance is pending.

## Branch And Commit

- Repository: `CometDash77/PiliAvalon-Worksite`
- Branch: `phase-1-shielding-core`
- Implementation commit: `f82d9efae` (`Fix phase 1 shielding feedback semantics`)
- CI compile follow-up commit: `7ded76b1c` (`Fix related video shielding adapter compile`)
- Published commit: `7ded76b1c73b95eabd9de2a28f84311d8bb8e3cd`

## Fix Scope

- UP row no longer exposes the standalone `屏蔽用户名关键词: <UP>` component.
- UP row ordinary `屏蔽` creates `userKeyword` token rules from the editable UP field.
- UID quick action keeps the original UID.
- Recommendation reason uses `reasonKeyword`, maps into `ShieldCandidate.reason`, and only matches the reason field.
- Settings visible categories include `推荐理由` and exclude `精确文本` / `旧规则兼容`.
- Imported rules still categorize by actual type.

## Verification

### Failed Prior Verification

- Run ID: `26796939985`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26796939985
- Result: failure
- Cause: compile error from invalid `HotVideoItemModel.rcmdReason` reads in related-video adapter.
- Action: fixed by commit `7ded76b1c`.

### Passing Verification

- Workflow: `Phase 1 Shielding Verify`
- Run ID: `26797083508`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26797083508
- Result: success
- Head SHA: `7ded76b1c73b95eabd9de2a28f84311d8bb8e3cd`
- Steps passed:
  - `flutter test test/features/shielding`
  - `flutter test test/pages/setting/models/shielding_settings_test.dart`
  - `flutter test test/bootstrap/bootstrap_app_test.dart`
  - `flutter analyze --no-fatal-infos`

Local Flutter/Dart verification was not run because the local shell has no `flutter`, `dart`, or `fvm` executable on PATH. GitHub Actions was used for tests/build per user instruction.

## Build Evidence

- Workflow: `Build`
- Run ID: `26797160689`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26797160689
- Result: success
- Head SHA: `7ded76b1c73b95eabd9de2a28f84311d8bb8e3cd`
- Android job: `Release Android`
- Non-Android jobs: skipped by dispatch inputs.
- Dispatch command used Android-only booleans and tag template `phase-1-prebuild.{run_id}`.

## Release Evidence

- Release tag: `phase-1-prebuild.26797160689`
- Release title: `Phase 1 Prebuild - Manual Acceptance`
- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26797160689
- Prerelease: true
- Draft: false
- Target commit: `7ded76b1c73b95eabd9de2a28f84311d8bb8e3cd`
- Version: `2.0.7-7ded76b1c+5060`

Release assets:

- `PiliAvalon_android_2.0.7-7ded76b1c+5060_arm64-v8a.apk`
- `PiliAvalon_android_2.0.7-7ded76b1c+5060_armeabi-v7a.apk`
- `PiliAvalon_android_2.0.7-7ded76b1c+5060_x86_64.apk`

Action artifacts:

- `Android_signing_evidence`
- `PiliAvalon_android_2.0.7-7ded76b1c+5060_arm64-v8a.apk`
- `PiliAvalon_android_2.0.7-7ded76b1c+5060_armeabi-v7a.apk`
- `PiliAvalon_android_2.0.7-7ded76b1c+5060_x86_64.apk`

Signing fingerprint for all release APKs:

`0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

Release notes source:

`records/session/2026-06-02-phase-1-prebuild-26797160689-release-notes.md`

## Commands

Every repo-level `gh` command used `-R CometDash77/PiliAvalon-Worksite`.

Key commands:

```bash
git push origin phase-1-shielding-core
gh run watch 26797083508 -R CometDash77/PiliAvalon-Worksite --exit-status
gh workflow run build.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core -f build_android=true -f build_ios=false -f build_mac=false -f build_win_x64=false -f build_linux_x64=false -f tag='phase-1-prebuild.{run_id}'
gh run watch 26797160689 -R CometDash77/PiliAvalon-Worksite --exit-status
gh release view phase-1-prebuild.26797160689 -R CometDash77/PiliAvalon-Worksite --json tagName,name,url,isPrerelease,isDraft,targetCommitish,publishedAt,author,assets,body
gh api repos/CometDash77/PiliAvalon-Worksite/actions/runs/26797160689/artifacts
gh api repos/CometDash77/PiliAvalon-Worksite/releases/tags/phase-1-prebuild.26797160689 --jq '{tag_name, name, prerelease, draft, make_latest, target_commitish, html_url, assets: [.assets[].name]}'
```

## Manual Acceptance

Pending. This release is only a user retest package.

## Known Risks

- No local Flutter tests were run due missing local Flutter tooling.
- The prebuild has not been real-device accepted by the user.
- Runtime smoke and technical-lead/client acceptance remain separate gates.
- The network-unreachable raw feedback line was not in scope for this shielding fix.

## Rollback

If this prebuild fails, keep it as prebuild evidence and supersede it with a newer verified prebuild after another fix. Do not mark `phase-1-prebuild.26797160689` stable/latest or use it as accepted Phase 1 evidence without user retest.
