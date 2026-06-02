Audience classification: agent-facing

# Phase 1 Prebuild 26799023288 Release Evidence

## Summary

Published Android-only Phase 1 token-match deprecation prebuild `phase-1-prebuild.26799023288` from verified commit `96207857252a169f92cdabd4ce28282a5d432502`.

Release type: `prebuild`.

Phase 1 is closed by user acceptance on 2026-06-02. Manual acceptance passed for `phase-1-prebuild.26799023288`.

## Branch And Commit

- Repository: `CometDash77/PiliAvalon-Worksite`
- Branch: `phase-1-shielding-core`
- Published commit: `96207857252a169f92cdabd4ce28282a5d432502`
- Commit subject: `Deprecate visible token match mode`

## Fix Scope

- Hide token matching from normal settings UI.
- Keep `ShieldMatchMode.token` and the token matcher branch for compatibility.
- Add a source-code notice that token is deprecated as a visible/user-facing mode and should not be used for new rules.
- Convert persisted token rules to escaped regex rules through store normalization.
- Preserve old token-style whole-token intent using delimiter-boundary regex conversion.
- Deduplicate converted token rules against equivalent regex rules.
- Create new UP keyword quick-action rules as regex rules from the edited UP text.
- Keep UID quick action exact and based on the original UID.

## Verification

### Failed Prior Verification

- Run ID: `26798541986`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26798541986
- Result: failure
- Cause: settings test tapped `完全相同`, but keyword exact mode is displayed as `包含文字`.
- Action: amended the test to use the actual UI label and force-with-lease pushed the corrected commit.

### Passing Verification

- Workflow: `Phase 1 Shielding Verify`
- Run ID: `26798658801`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26798658801
- Result: success
- Head SHA: `96207857252a169f92cdabd4ce28282a5d432502`
- Steps passed:
  - `flutter test test/features/shielding`
  - `flutter test test/pages/setting/models/shielding_settings_test.dart`
  - `flutter test test/bootstrap/bootstrap_app_test.dart`
  - `flutter analyze --no-fatal-infos`

- Workflow: `Phase 1 CI`
- Run ID: `26798658868`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26798658868
- Result: success
- Head SHA: `96207857252a169f92cdabd4ce28282a5d432502`
- Jobs passed:
  - Focused Flutter verification
  - Android x86_64 artifact build
  - Android emulator install/launch runtime smoke

Local Flutter/Dart verification was not run because the local shell has no `flutter`, `dart`, or `fvm` executable on PATH. GitHub Actions was used for tests/build per user instruction.

## Build Evidence

- Workflow: `Build`
- Run ID: `26799023288`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26799023288
- Result: success
- Head SHA: `96207857252a169f92cdabd4ce28282a5d432502`
- Android job: `Release Android`
- Non-Android jobs: skipped by dispatch inputs.
- Dispatch command used Android-only booleans and tag template `phase-1-prebuild.{run_id}`.
- APKs were not downloaded locally; the workflow published assets directly to the GitHub prerelease.

## Release Evidence

- Release tag: `phase-1-prebuild.26799023288`
- Release title: `Phase 1 Prebuild - Manual Acceptance`
- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26799023288
- Prerelease: true
- Draft: false
- Target commit: `96207857252a169f92cdabd4ce28282a5d432502`
- Version: `2.0.7-962078572+5062`

Release assets:

- `PiliAvalon_android_2.0.7-962078572+5062_arm64-v8a.apk`
- `PiliAvalon_android_2.0.7-962078572+5062_armeabi-v7a.apk`
- `PiliAvalon_android_2.0.7-962078572+5062_x86_64.apk`

Action artifacts:

- `Android_arm64-v8a`
- `Android_armeabi-v7a`
- `Android_x86_64`
- `Android_signing_evidence`

Signing fingerprint for all release APKs:

`0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

Release notes source:

`records/session/2026-06-02-phase-1-prebuild-26799023288-release-notes.md`

## Commands

Every repo-level `gh` command used `-R CometDash77/PiliAvalon-Worksite`.

Key commands:

```bash
git push --force-with-lease origin phase-1-shielding-core
gh run watch 26798658801 -R CometDash77/PiliAvalon-Worksite --exit-status
gh run watch 26798658868 -R CometDash77/PiliAvalon-Worksite --exit-status
gh workflow run build.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core -f build_android=true -f build_ios=false -f build_mac=false -f build_win_x64=false -f build_linux_x64=false -f tag='phase-1-prebuild.{run_id}'
gh run watch 26799023288 -R CometDash77/PiliAvalon-Worksite --exit-status
gh release view phase-1-prebuild.26799023288 -R CometDash77/PiliAvalon-Worksite --json tagName,name,isDraft,isPrerelease,targetCommitish,url,createdAt,publishedAt,assets,body
gh api repos/CometDash77/PiliAvalon-Worksite/releases/tags/phase-1-prebuild.26799023288 --jq '{tag_name, name, draft, prerelease, make_latest, target_commitish, html_url, assets: [.assets[].name]}'
gh release edit phase-1-prebuild.26799023288 -R CometDash77/PiliAvalon-Worksite --title 'Phase 1 Prebuild - Manual Acceptance' --notes-file records/session/2026-06-02-phase-1-prebuild-26799023288-release-notes.md --prerelease
```

## Manual Acceptance

Passed by user report on 2026-06-02.

Raw user acceptance feedback:

```text
好了，目前这个问题已经完全消失，我觉得phase1可以宣告结束，虽然还是有不少问题我想提，但我觉得作为phase1已经彻底结束了，更新一切该更新的，持久化一切该持久化的，接下来还需要通知设计院准备phase2
```

Codex interpretation:

- The user reports the current problem has fully disappeared.
- The user explicitly declares Phase 1 complete.
- Remaining/new issues are deferred to Phase 2 and are not blockers for Phase 1 closure.
- The accepted package is `phase-1-prebuild.26799023288`.

## Known Risks

- No local Flutter tests were run due missing local Flutter tooling.
- This package remains a prebuild and was not promoted to stable/latest.
- Remaining/new product issues are expected for Phase 2 planning.

## Rollback

If a regression is later found, keep this tag as Phase 1 acceptance evidence and open a Phase 2 or hotfix track with fresh scope and verification. Do not mark `phase-1-prebuild.26799023288` stable/latest without a separate stable-release approval.
