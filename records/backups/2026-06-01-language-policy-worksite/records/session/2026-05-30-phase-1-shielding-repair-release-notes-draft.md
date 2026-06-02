# Phase 1 Shielding Repair Prebuild Release Notes Draft

## Purpose

Validation-only prebuild for Phase 1 shielding repair. This is for automated
verification, Android runtime smoke, and user/manual acceptance after the repair
lands. It is not stable, not latest, and not a formal Phase 1 acceptance
release.

`phase-1-prebuild.26675065521` is a failed Phase 1 shielding package. It may be
cited only as failed history and cannot be reused as matcher, quickAction,
runtime-smoke, release, manual-acceptance, or final acceptance evidence for this
repair.

## Release Type

prebuild

GitHub release must be marked as a pre-release. Do not mark it latest/stable.

## Branch / Commit / Tag

- Repository: `CometDash77/PiliAvalon-Worksite`
- Branch: `phase-1-shielding-core`
- Repair commit SHA: `<REPAIR_COMMIT_SHA>`
- Tag: `<phase-1-prebuild.NEW_RUN_ID>`
- Title: `Phase 1 Prebuild - Manual Acceptance`
- Release URL: `<GITHUB_RELEASE_URL>`
- Artifact run id: `<ANDROID_BUILD_RUN_ID>`

## Related PRs / Issues

- PR: `<PR_URL_OR_NONE>`
- Issue/design record: `records/session/2026-05-30-phase-1-shielding-repair-worksite-declaration.md`
- Failed prior package: `phase-1-prebuild.26675065521`
- Failed acceptance record: `records/session/2026-05-30-phase-1-manual-acceptance-filter-integration-failed.md`

## Automation Evidence

Required commands before publishing or handing to user acceptance:

```bash
flutter test test/features/shielding
flutter test test/pages/setting/models/shielding_settings_test.dart
flutter analyze --no-fatal-infos
```

Required scoped GitHub Actions commands:

```bash
gh workflow run phase1_shielding_verify.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core
gh run list -R CometDash77/PiliAvalon-Worksite --workflow "Phase 1 Shielding Verify" --branch phase-1-shielding-core --limit 5
gh run view <PHASE1_VERIFY_RUN_ID> -R CometDash77/PiliAvalon-Worksite --log

gh workflow run build.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core -f build_android=true -f build_ios=false -f build_mac=false -f build_win_x64=false -f build_linux_x64=false -f tag=
gh run list -R CometDash77/PiliAvalon-Worksite --workflow build.yml --branch phase-1-shielding-core --limit 5
gh run view <ANDROID_BUILD_RUN_ID> -R CometDash77/PiliAvalon-Worksite

gh workflow run android_runtime_smoke.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core -f artifact_run_id=<ANDROID_BUILD_RUN_ID> -f package_name=com.example.piliplus
gh run list -R CometDash77/PiliAvalon-Worksite --workflow "Android Runtime Smoke" --branch phase-1-shielding-core --limit 5
gh run view <ANDROID_RUNTIME_SMOKE_RUN_ID> -R CometDash77/PiliAvalon-Worksite
```

Evidence placeholders:

- Focused verify run: `<PHASE1_VERIFY_RUN_URL>` / conclusion `<PASS_FAIL>`
- Android build run: `<ANDROID_BUILD_RUN_URL>` / conclusion `<PASS_FAIL>`
- Android runtime smoke run: `<ANDROID_RUNTIME_SMOKE_RUN_URL>` / conclusion `<PASS_FAIL>`
- Android runtime smoke screenshot: `<SCREENSHOT_PATH_OR_ARTIFACT_NAME>`
- Android runtime smoke logcat: `<LOGCAT_PATH_OR_ARTIFACT_NAME>`
- Android runtime smoke UI/window evidence: `<UI_WINDOW_EVIDENCE_PATH_OR_ARTIFACT_NAME>`
- Release artifact/tag: `<ARTIFACT_NAMES>` / `<TAG>`

Do not replace placeholders with green/pass wording unless fresh successful
output has been observed for the repair commit.

## Manual Acceptance

Status: pending.

Required user/manual acceptance checks:

- Install the new prebuild APK.
- First screen is nonblank and not a startup failure screen.
- Homepage recommendation shielding quickAction can be created from content and
  the affected recommendation disappears immediately or after refresh.
- Video title, uploader, tags, and related-video surfaces can create shielding
  rules and related videos are filtered.
- Main comments, child comments, and preview child replies are filtered.
- Free copy remains available.
- Closing the total shielding switch restores recommendation, related-video,
  and comment content.
- Existing `piliavalon.shielding.v1` rules and switches survive upgrade.

## Changes

- `<REPAIR_CHANGE_1>`
- `<REPAIR_CHANGE_2>`
- `<REPAIR_CHANGE_3>`

Expected repair scope:

- Matcher exact semantics: keyword exact is case-insensitive literal contains;
  uid/category/tag exact remains structured equality.
- quickAction helper writes block/exact/quickAction rules with
  `type + scope + pattern` de-duplication.
- Homepage, video page, related-video, and comment surfaces add Phase 1
  shielding entry points.
- Settings manual add is simplified to text keyword shielding while old
  allow/UID/regex rules remain display-compatible.

## Known Risks

- Until fresh repair verification runs pass, automated status is yellow.
- Until Android runtime smoke passes on the new artifact, runtime status is
  yellow/red.
- Until user/manual acceptance passes, Phase 1 shielding remains incomplete.
- Existing package `phase-1-prebuild.26675065521` failed shielding acceptance
  and cannot be reused to close any repaired gate.

## Sources / License / Attribution

No new external source code is included by this draft. If the repair copies or
adapts external code, update this section before publishing with source URL,
license, attribution, and reuse decision. Existing project dependencies remain
under their existing licenses.

## Rollback Plan

If any automated, runtime-smoke, or manual-acceptance gate fails:

- Do not mark Phase 1 green, stable, latest, accepted, or complete.
- Keep the failed prebuild as a GitHub pre-release evidence record.
- Do not reuse `phase-1-prebuild.26675065521` or the failed repair prebuild as
  acceptance evidence.
- Revert or supersede only the repair commit range identified by
  `<REPAIR_COMMIT_SHA_RANGE>` on `phase-1-shielding-core`, then publish a later
  prebuild with fresh focused tests, analyze, Android build, runtime smoke, and
  release notes.
- Preserve user-device findings, screenshots, logcat, and run URLs in
  `records/session/` before any follow-up attempt.

## Not Covered / Still Yellow

- Fresh repair commit SHA: pending.
- Fresh focused verification run: pending.
- Fresh Android build artifact: pending.
- Fresh Android runtime smoke screenshot/logcat: pending.
- User/manual acceptance: pending.
- Stable/latest release approval: not covered by this prebuild.

## User Action Required

After fresh automation and runtime-smoke evidence pass, install the new
prebuild APK and complete the manual acceptance checks listed above. Do not
install or re-test `phase-1-prebuild.26675065521` as the repaired package.
