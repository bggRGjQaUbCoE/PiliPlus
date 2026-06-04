# Phase 1 Shielding Repair Prebuild 26680259984 Release Notes

## Purpose

Validation-only prebuild for Phase 1 shielding repair manual acceptance.
This is not a stable release, not latest, and not a formal Phase 1 green
acceptance release.

This package supersedes the failed or invalid manual-acceptance packages listed
below:

- `phase-1-prebuild.26678247652`: first manual acceptance found shielding
  integration problems.
- `phase-1-prebuild.26679987266`: Android APK filenames came from commit
  `5d0dfe67320ac9d23a3a1f3db4c1d0b1e24c6ad9`, but the GitHub tag pointed to
  `main` commit `64649874376bfc7ccc5e8110db39e0a53baf66f0`; do not use it for
  acceptance evidence.

## Release Type

prebuild

The GitHub Release is a pre-release and must not be treated as latest/stable.

## Branch / Commit / Tag

- Repository: `CometDash77/PiliAvalon-Worksite`
- Branch: `phase-1-shielding-core`
- Commit SHA: `80f5e6d6a7c63b4439c313281be76235f94ab0e6`
- Tag: `phase-1-prebuild.26680259984`
- Release title: `Phase 1 Prebuild - Manual Acceptance`
- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26680259984
- Tag target evidence: `refs/tags/phase-1-prebuild.26680259984` points to
  `80f5e6d6a7c63b4439c313281be76235f94ab0e6`.

## Related PRs / Issues

- PR: none.
- Worksite branch: `phase-1-shielding-core`.
- Failed acceptance record:
  `records/session/2026-05-30-phase-1-manual-acceptance-filter-integration-failed.md`.
- Repair handoff record:
  `records/session/2026-05-30-phase-1-shielding-repair-main-handoff.md`.
- User feedback covered by this prebuild:
  - homepage recommendation shielding must keep cover preview/save and add a
    clear shielding entry;
  - hot page must apply Phase 1 recommendation shielding;
  - user shielding must explicitly choose UID or username keyword;
  - comment free-copy selected text must write Phase 1 comment rules;
  - tag shielding must affect recommendation-like lists only when real raw
    tags are present, and category filtering must remain separate from tags.

## Automation Evidence

- Focused verification run: success.
  https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680217189
  - `flutter test test/features/shielding`
  - `flutter test test/pages/setting/models/shielding_settings_test.dart`
  - bootstrap startup test
  - `flutter analyze --no-fatal-infos`
- Android build and release run: success.
  https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680259984
- Android runtime smoke run: success.
  https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680411611
- Runtime smoke evidence artifact:
  `android-runtime-smoke-evidence`, artifact id `7307197851`, digest
  `sha256:a4a9fcac8570c678279762837717ea98a6e94020bb02754d4e886f10e59d3831`.
- Build artifacts attached to this release:
  - `PiliAvalon_android_2.0.7-80f5e6d6a+5032_arm64-v8a.apk`
  - `PiliAvalon_android_2.0.7-80f5e6d6a+5032_armeabi-v7a.apk`
  - `PiliAvalon_android_2.0.7-80f5e6d6a+5032_x86_64.apk`

Signing evidence:

- The Android build used the workflow-dispatch signing path in
  `.github/workflows/build.yml`: when `SIGN_KEYSTORE_BASE64` is present, CI
  writes `android/app/key.jks` plus `KEYSTORE_PASSWORD`, `KEY_ALIAS`, and
  `KEY_PASSWORD` into `android/key.properties` before release build.
- Same-signature cover-install on the user's already installed APK is still a
  manual device check. If Android reports a signature mismatch, this prebuild
  is yellow/blocker; do not ask the user to uninstall and count that as pass.

No APK was downloaded locally for this publication path.

## Manual Acceptance

Status: pending.

Manual acceptance may start only on `phase-1-prebuild.26680259984`.

Required checks:

- Install the matching ABI APK over the currently installed app. This must be a
  cover install with the same package name/signature.
- First screen is nonblank and not a startup failure screen.
- Homepage recommendation card keeps the existing cover preview/save entry and
  also exposes a clear shielding entry.
- Homepage/title/recommendation keyword shielding hides the current card
  immediately or after refresh.
- Homepage UP shielding offers explicit choices:
  `屏蔽用户 UID: xxx` and `屏蔽用户名关键词: xxx`. Choosing username keyword must
  write a keyword rule for the UP name, not a UID rule.
- Hot page items are filtered by the same Phase 1 recommendation rule snapshot
  and global/recommendation switches.
- Video title, UP, category/tag, and related-video surfaces can create rules.
- Related videos are filtered by Phase 1 shielding regardless of the legacy
  `过滤器也应用于相关视频` switch. That switch only controls the legacy
  `RecommendFilter.filterAll` path.
- Comment menus distinguish `屏蔽评论用户 UID`, comment keyword selected text,
  and exact full-comment-text blocking.
- Comment free-copy selected text writes a Phase 1 comment rule first; legacy
  `ReplyGrpc.replyRegExp` is only a compatibility mirror after Phase 1 save
  succeeds.
- Main comments, child comments, and preview child replies are filtered.
- Turning off the Phase 1 global shielding switch restores recommendation,
  related-video, hot-page, and comment content.
- Existing `piliavalon.shielding.v1` rules and switches survive upgrade.

## Changes

- Fixed UP quick actions so UID and username keyword are separate, visible
  choices instead of silently selecting UID.
- Kept homepage recommendation cover preview/save and added Phase 1 shielding
  quick actions for title, UP, and recommendation reason.
- Connected hot page and related videos to Phase 1 recommendation shielding.
- Kept legacy recommendation settings behavior where appropriate:
  `已关注UP豁免推荐过滤` remains a legacy `RecommendFilter` exemption and does
  not override Phase 1 shielding rules; `过滤器也应用于相关视频` gates only legacy
  related-video filtering, while Phase 1 related-video filtering always follows
  the Phase 1 global/recommendation switches.
- Split tag and category semantics: `tag` rules match raw `tag/tags` values
  only; `category` rules match `tname`.
- Routed comment free-copy selected text into Phase 1 comment quick-action
  rules, with legacy regex mirroring only after the Phase 1 write succeeds.
- Added distinct comment actions for UID, selected keyword, and exact full text.
- Applied Phase 1 comment shielding to root comments, child comments, and
  preview child replies.

## Known Risks

- Manual acceptance is still pending and is required before Phase 1 can be
  called green.
- Cover-install signature compatibility is pending user-device evidence.
- Raw recommendation tag shielding only affects items that expose real
  `tag/tags` data. Many recommendation, hot, or related-video payloads expose
  only `tname`; those are category rules, not tag rules.
- Upstream legacy entries not converted to Phase 1 in this prebuild:
  `评论关键词过滤` remains the legacy regex setting but selected-text quick action
  now writes Phase 1 first; `动态关键词过滤` is not covered by this Phase 1
  recommendation/comment acceptance package.

## Sources / License / Attribution

No new external source code was copied for this prebuild. The repair uses
existing project code, existing project dependencies, and GitHub Actions
workflow configuration under the repository's existing license terms.

## Rollback Plan

If automation, runtime smoke, cover install, or manual acceptance fails:

- Do not mark Phase 1 green, stable, latest, accepted, or complete.
- Preserve the failed prebuild and user findings as evidence.
- Do not reuse `phase-1-prebuild.26678247652`,
  `phase-1-prebuild.26679987266`, or the failed package as acceptance evidence.
- Revert or supersede the repair range ending at
  `80f5e6d6a7c63b4439c313281be76235f94ab0e6` on
  `phase-1-shielding-core`, then publish a later prebuild with fresh focused
  tests, analyze, Android build, runtime smoke, release notes, signing notes,
  and rollback evidence.

## Not Covered / Still Yellow

- User manual acceptance: pending.
- Same-signature cover install on the user's device: pending.
- Stable/latest release approval: not covered.
- Dynamic keyword filtering: not covered by this Phase 1 prebuild.
- Legacy settings are reviewed for integration boundaries, but not all legacy
  filters are migrated into Phase 1 in this package.

## User Action Required

Install an APK from `phase-1-prebuild.26680259984` for the device ABI and run
the manual acceptance checks above. Do not use `phase-1-prebuild.26678247652`
or `phase-1-prebuild.26679987266` for this acceptance pass.
