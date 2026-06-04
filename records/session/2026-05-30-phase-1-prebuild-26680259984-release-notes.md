# phase 1 prebuild 26680259984 release notes

Audience classification: agent-facing.

## Normalization Note

This file was normalized under the 2026-06-01 worksite language policy. The active agent-facing record is English. The pre-normalization source is preserved at records/backups/2026-06-01-language-policy-worksite/records/session/2026-05-30-phase-1-prebuild-26680259984-release-notes.md.

## Record Classification

- Repository boundary: CometDash77/PiliAvalon-Worksite
- Worksite path: records/session/2026-05-30-phase-1-prebuild-26680259984-release-notes.md
- Artifact category: session record
- Evidence status: Historical or candidate session evidence. It cannot claim green, cannot close acceptance, and requires fresh verification before current status claims.
- Review owner: Codex

## Summary

Prebuild release notes. This is dual-use release material; Chinese product labels are preserved only in the backup source.

## Preserved Evidence Anchors

- - `phase-1-prebuild.26678247652`: first manual acceptance found shielding
- - `phase-1-prebuild.26679987266`: Android APK filenames came from commit
- `5d0dfe67320ac9d23a3a1f3db4c1d0b1e24c6ad9`, but the GitHub tag pointed to
- `main` commit `64649874376bfc7ccc5e8110db39e0a53baf66f0`; do not use it for
- - Repository: `CometDash77/PiliAvalon-Worksite`
- - Branch: `phase-1-shielding-core`
- - Commit SHA: `80f5e6d6a7c63b4439c313281be76235f94ab0e6`
- - Tag: `phase-1-prebuild.26680259984`
- - Release title: `Phase 1 Prebuild - Manual Acceptance`
- - Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26680259984
- - Tag target evidence: `refs/tags/phase-1-prebuild.26680259984` points to
- `80f5e6d6a7c63b4439c313281be76235f94ab0e6`.
- - Worksite branch: `phase-1-shielding-core`.
- `records/session/2026-05-30-phase-1-manual-acceptance-filter-integration-failed.md`.
- `records/session/2026-05-30-phase-1-shielding-repair-main-handoff.md`.
- tags are present, and category filtering must remain separate from tags.
- https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680217189
- - `flutter test test/features/shielding`
- - `flutter test test/pages/setting/models/shielding_settings_test.dart`
- - `flutter analyze --no-fatal-infos`
- https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680259984
- https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680411611
- `android-runtime-smoke-evidence`, artifact id `7307197851`, digest
- `sha256:a4a9fcac8570c678279762837717ea98a6e94020bb02754d4e886f10e59d3831`.
- - `PiliAvalon_android_2.0.7-80f5e6d6a+5032_arm64-v8a.apk`
- - `PiliAvalon_android_2.0.7-80f5e6d6a+5032_armeabi-v7a.apk`
- - `PiliAvalon_android_2.0.7-80f5e6d6a+5032_x86_64.apk`
- `.github/workflows/build.yml`: when `SIGN_KEYSTORE_BASE64` is present, CI
- writes `android/app/key.jks` plus `KEYSTORE_PASSWORD`, `KEY_ALIAS`, and
- `KEY_PASSWORD` into `android/key.properties` before release build.

## Gate Boundary

Automation success, CI success, runtime smoke, technical-lead review, manual acceptance, and user/client acceptance are separate gates. This record cannot close any gate by itself.

## Citation Rule

Future worksite sessions may cite this record only with its evidence status and with fresh verification for any current-status claim.

