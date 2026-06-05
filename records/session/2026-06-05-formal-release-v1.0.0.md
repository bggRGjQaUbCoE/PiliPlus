Audience classification: agent-facing

# Formal Release v1.0.0 Session Report

Date: 2026-06-05
Repository: `CometDash77/PiliAvalon-Worksite`
Worksite path: `/home/mo/Documents/piliavalon`
Release type: `stable`
Release tag: `v1.0.0`
Release title: `PiliAvalon v1.0.0`
Status: published stable/latest

## Source

- Source branch: `main`
- Source commit: `5ccc9bf243bab2c5f143032bd2549016a5b857da`
- Source subject: `Record verified Phase 1 main merge`
- Release strategy: Strategy B, fresh signed build from current product `main`
- Historical prebuild `phase-1-prebuild.26799023288` was audited but not reused.

## Repository Boundary

- `origin`: `git@github.com:CometDash77/PiliAvalon-Worksite.git`
- `upstream`: `https://github.com/bggRGjQaUbCoE/PiliPlus.git`
- `upstream` push URL: `DISABLED`
- Every repo-level `gh` command used `-R CometDash77/PiliAvalon-Worksite`.
- No design-institute files were modified.
- No Phase 2 work was started.

## Upstream Check

Initial release handoff check:

- Checked upstream SHA: `cd367a8649ed1f2bed7000d5e4bcb7096a811bc5`
- It was contained in selected source `origin/main` at `5ccc9bf243bab2c5f143032bd2549016a5b857da`.

Fresh continuation check on 2026-06-05:

- Fresh upstream SHA: `295a587df5bb3b5a6661edff1c692dc8196aae5e`
- New upstream commits after previous check: `2`
- Review record: `records/session/2026-06-05-v1.0.0-upstream-release-check.md`
- Recommendation: defer upstream sync until after `v1.0.0`; not a stable-release blocker.

## Old Prebuild Audit

- Tag: `phase-1-prebuild.26799023288`
- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26799023288
- Source commit: `96207857252a169f92cdabd4ce28282a5d432502`
- Signing fingerprint: `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

Conclusion: old APKs are historical accepted baseline evidence only. They were not promoted as `v1.0.0` assets because their source commit differs from the selected release source.

## Automation Evidence

| Gate | Run | Result |
|---|---|---|
| CI, focused tests, analyze, x86_64 dev build, dev runtime smoke | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26942794691 | success |
| Signed Android build | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26943699924 | success |
| Signed release-package runtime smoke | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26944140135 | success |
| Final runner-side signed Android build and release-asset upload | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26989901185 | success |
| Final release-package runtime smoke | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26990185880 | success |

CI run `26942794691` passed:

- `flutter test test/features/shielding`
- `flutter test test/pages/setting/models/shielding_settings_test.dart`
- `flutter test test/bootstrap/bootstrap_app_test.dart`
- `flutter analyze --no-fatal-infos`
- Android x86_64 build
- Android emulator runtime smoke

Signed build run `26943699924` passed:

- Android job: `Release Android`
- `ios`, `mac`, `win_x64`, and `linux_x64` skipped by dispatch input
- Tag input was empty, so no prerelease was created by the build workflow.

Signed runtime smoke run `26944140135` passed:

- Artifact source run: `26943699924`
- Package: `com.example.piliplus`
- Job: `Install and launch APK on emulator`

Final runner-side build run `26989901185` passed:

- Android job: `Release Android`
- Tag input: `v1.0.0`
- The workflow created GitHub Release `v1.0.0` as a prerelease and uploaded the three APK assets from the GitHub Actions runner.
- No APK was downloaded to the local workspace or `/tmp`.

Final runtime smoke run `26990185880` passed:

- Artifact source run: `26989901185`
- Package: `com.example.piliplus`
- Job: `Install and launch APK on emulator`
- Runtime evidence artifact: `android-runtime-smoke-evidence` (`7427057959`)

## APK Assets

Expected formal Release assets:

| Asset | Size | ABI |
|---|---:|---|
| `PiliAvalon_android_2.0.8-5ccc9bf24+5099_arm64-v8a.apk` | `24600437` | `arm64-v8a` |
| `PiliAvalon_android_2.0.8-5ccc9bf24+5099_armeabi-v7a.apk` | `24515271` | `armeabi-v7a` |
| `PiliAvalon_android_2.0.8-5ccc9bf24+5099_x86_64.apk` | `25588487` | `x86_64` |

No universal APK is required for this `v1.0.0` release by user-confirmed decision.

## Signing Evidence

- SHA-256 certificate fingerprint: `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`
- Evidence source: `Android_signing_evidence` artifact from final build run `26989901185`
- The evidence was streamed from GitHub artifact output without saving APK files locally.

## Manual Acceptance

Phase 1 manual acceptance passed on 2026-06-02 against `phase-1-prebuild.26799023288`.

Raw user feedback was preserved in `records/session/2026-06-02-phase-1-user-acceptance-closure.md`.

## Release Notes

- Release notes path: `records/session/2026-06-05-v1.0.0-release-notes.md`
- Required release-governance sections are present.
- Notes state that the release is stable, source commit is `5ccc9bf243bab2c5f143032bd2549016a5b857da`, assets are freshly built, old prebuild assets are not reused, and the latest upstream delta is deferred.

## Publication

GitHub Release `v1.0.0` was created by build run `26989901185` as a prerelease with the three APK assets uploaded from the GitHub Actions runner. After final runtime smoke passed, Codex updated the release notes and converted the release to stable/latest.

- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/v1.0.0
- Draft: `false`
- Prerelease: `false`
- Latest check: `/releases/latest` returned `v1.0.0`
- Target commit: `5ccc9bf243bab2c5f143032bd2549016a5b857da`
- Asset upload path: GitHub Actions runner, not local APK download.
- Failed intermediate draft: a temporary draft release was created for a streaming upload attempt, produced a partial `starter` asset, and was deleted before the final runner-side publication path. No stable release was published from that draft.

Required publication constraints:

- Do not download APK artifacts to the local workspace or `/tmp`.
- Keep APK bytes on GitHub infrastructure or stream without persistence.
- Publish stable/latest `v1.0.0`, not draft and not prerelease.
- Target commit must be `5ccc9bf243bab2c5f143032bd2549016a5b857da`.

## Rollback / Hotfix Path

If a regression is found:

1. Keep `v1.0.0` as the immutable release record.
2. Open a hotfix branch from `5ccc9bf243bab2c5f143032bd2549016a5b857da`.
3. Build, sign, and runtime-smoke the hotfix package.
4. Publish `v1.0.1` only after gates are green.

## Known Risks

- Latest PiliPlus upstream commits `73d7d78080270c374e28bb4d8d1c115086f0addb` and `295a587df5bb3b5a6661edff1c692dc8196aae5e` are deferred to post-release upstream sync review.
- No local Flutter test was run; GitHub Actions is the evidence authority for this release.
- Latest PiliPlus upstream commits `73d7d78080270c374e28bb4d8d1c115086f0addb` and `295a587df5bb3b5a6661edff1c692dc8196aae5e` remain deferred to post-release upstream sync review.
