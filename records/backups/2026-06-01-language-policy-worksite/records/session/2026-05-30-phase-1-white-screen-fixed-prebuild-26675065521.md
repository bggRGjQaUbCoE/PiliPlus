# Phase 1 White-Screen Fixed Prebuild 26675065521

Date: 2026-05-30

## State

Phase 1 remains yellow pending user-side manual acceptance. A new Android prebuild has been published for validation:

- Release: `phase-1-prebuild.26675065521`
- Title: `Phase 1 Prebuild - Manual Acceptance`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26675065521
- Type: GitHub pre-release, not latest/stable

Old packages must not be treated as fixes:

- `phase-1-prebuild.26628409138` is not fixed.
- `phase-1-prebuild.26674691497` was superseded because its first runtime-smoke evidence was later found incomplete: the app launched, but a Pixel Launcher ANR dialog was foreground in the captured UI dump.

## Branch / Commits

- Branch: `phase-1-shielding-core`
- Startup/app build commit: `4c6f65ca0f549abe022e1611ad511dcae056e711`
- Runtime-smoke direct-launch commit: `121a3e7fa9da4f95c2e16a403b64b070618934b0`

## Automation Evidence

- Focused verify: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26674258036
- Android build: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26675065521
- Runtime smoke: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26675337037

Runtime smoke `26675337037` used Android artifact run `26675065521`:

- APK under test: `PiliAvalon_android_2.0.7-4c6f65ca0+5023_x86_64.apk`
- Package: `com.example.piliplus`
- Evidence status: `status=0`, `result=pass`
- `pidof.txt`: process id present
- `app-crash-error.txt`: empty
- `screenshot-blankness.txt`: `blankness_status=pass`
- `uiautomator.xml`: contains `package="com.example.piliplus"` and visible recommendation feed/home UI
- `window.txt`: `mCurrentFocus=Window{... com.example.piliplus/com.example.piliplus.MainActivity}`

Evidence artifact was downloaded only to `/tmp/piliavalon-runtime-smoke-26675337037` for inspection. No APK was downloaded locally.

## Release Assets

The release has user-installable Android APK assets attached by the remote build workflow:

- `PiliAvalon_android_2.0.7-4c6f65ca0+5023_arm64-v8a.apk`
- `PiliAvalon_android_2.0.7-4c6f65ca0+5023_armeabi-v7a.apk`
- `PiliAvalon_android_2.0.7-4c6f65ca0+5023_x86_64.apk`

## Implementation Notes

- `lib/main.dart` now starts a bootstrap UI before initialization and renders a visible startup failure screen instead of exiting silently before `runApp`.
- Android registers both branded and inherited method channels needed during startup.
- Runtime smoke now rejects app-specific crashes, blank/invalid screenshots, visible startup failure UI, missing UI dump, missing app package in UI dump, and non-app foreground windows.
- Runtime smoke launches `MainActivity` directly instead of using Monkey/Pixel Launcher, because emulator Pixel Launcher ANRs can obscure the app despite a successful app launch.

## Manual Acceptance

Pending and owned by the user:

- Install the new release APK.
- Confirm the first screen is not white.
- Confirm recommendation feed shielding.
- Confirm comment-area shielding.

## Release Governance

All repo-scoped GitHub CLI commands used `-R CometDash77/PiliAvalon-Worksite`.

`phase-1-prebuild.26675065521` release notes include the required governance sections:

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

## Rollback

If manual acceptance fails, do not ask the user to retry old APKs as fixes. Preserve the evidence, diagnose from the new user-device result, and publish a later prebuild with fresh build and runtime-smoke evidence.
