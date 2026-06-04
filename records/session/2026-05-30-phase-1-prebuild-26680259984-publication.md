# Phase 1 Prebuild 26680259984 Publication Record

Date: 2026-05-30

## Summary

Published a new Phase 1 shielding repair prebuild for user/manual acceptance:

- Release type: prebuild.
- Tag: `phase-1-prebuild.26680259984`.
- Title: `Phase 1 Prebuild - Manual Acceptance`.
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26680259984
- Branch: `phase-1-shielding-core`.
- Commit: `80f5e6d6a7c63b4439c313281be76235f94ab0e6`.

This prebuild is not stable, not latest, and not Phase 1 green. It exists only
to let the user begin the repaired manual acceptance pass.

## Release Correction Before Publication

Run `26679987266` created `phase-1-prebuild.26679987266` with Android APK names
from commit `5d0dfe67320ac9d23a3a1f3db4c1d0b1e24c6ad9`, but the GitHub tag
pointed to `main` commit `64649874376bfc7ccc5e8110db39e0a53baf66f0`.

That package was not handed to user acceptance. It must remain superseded and
invalid for acceptance evidence.

The workflow was fixed in commit
`80f5e6d6a7c63b4439c313281be76235f94ab0e6` by setting
`target_commitish: ${{ github.sha }}`, `prerelease: true`, and
`make_latest: false` for Android prebuild releases.

## Evidence

- Focused verify run: success.
  https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680217189
- Android build/release run: success.
  https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680259984
- Android runtime smoke run: success.
  https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680411611
- Runtime smoke evidence artifact:
  `android-runtime-smoke-evidence`, id `7307197851`, digest
  `sha256:a4a9fcac8570c678279762837717ea98a6e94020bb02754d4e886f10e59d3831`.

## Assets

- `PiliAvalon_android_2.0.7-80f5e6d6a+5032_arm64-v8a.apk`
- `PiliAvalon_android_2.0.7-80f5e6d6a+5032_armeabi-v7a.apk`
- `PiliAvalon_android_2.0.7-80f5e6d6a+5032_x86_64.apk`

## Signing / Cover Install

The workflow-dispatch Android release build uses the configured signing secret
path when `SIGN_KEYSTORE_BASE64` is present. Same-signature cover install over
the user's currently installed package is not proven by CI and remains a manual
acceptance gate. Signature mismatch is yellow/blocker; uninstalling first does
not count as cover-install pass.

## Manual Acceptance Status

Pending. The user may start only after the GitHub Release notes are updated
with the governance sections from
`records/session/2026-05-30-phase-1-prebuild-26680259984-release-notes.md`.

## Command Scope

All GitHub CLI commands used for repo-level run/release operations included
`-R CometDash77/PiliAvalon-Worksite`.

No APK or artifact was downloaded locally. The release assets were produced and
attached by GitHub Actions.

## Rollback

If manual acceptance fails, do not mark Phase 1 green. Preserve the failed
prebuild as evidence, revert or supersede the repair range ending at
`80f5e6d6a7c63b4439c313281be76235f94ab0e6`, and publish a later prebuild with
fresh verify, Android build, runtime smoke, release notes, signing notes, and
rollback evidence.
