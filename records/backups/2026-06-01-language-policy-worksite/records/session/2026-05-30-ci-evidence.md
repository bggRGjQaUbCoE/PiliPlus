# Phase 1 CI Evidence Record

Date: 2026-05-30

## Scope

This record captures the unified Phase 1 CI entry for run `26684680541`.
GitHub Actions is the authority for build and runtime evidence. Local Windows
preflight is only a quick secondary check and does not prove APK packaging,
emulator launch, device behavior, manual acceptance, or same-signature
cover-install.

## Repository

- Repo: `CometDash77/PiliAvalon-Worksite`
- Local root: `C:\Users\77182\Documents\Coding\piliavalon`
- Branch: `phase-1-shielding-core`
- Commit SHA: `a6e97e6e089079c100e03be812affe3302c838f8`

## Workflow

- Workflow name: `Phase 1 CI`
- Workflow file: `.github/workflows/ci.yml`
- Run id: `26684680541`
- Run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26684680541`
- Job URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26684680541/job/78650789088`
- Event: `workflow_dispatch`
- Conclusion: `failure`
- Created: `2026-05-30T13:11:41Z`
- Completed: `2026-05-30T13:15:08Z`

All GitHub CLI commands used to dispatch, inspect, or download evidence for this
repo must explicitly target `CometDash77/PiliAvalon-Worksite`. Use
`-R CometDash77/PiliAvalon-Worksite` for supported `gh` commands, and use
`repos/CometDash77/PiliAvalon-Worksite/...` endpoints for `gh api`.

## Evidence Classes

| Evidence class | Status | Evidence |
|---|---|---|
| `local-preflight` | `fail` | `powershell -ExecutionPolicy Bypass -File tool/preflight.ps1` reached `flutter pub get`, then failed with exit 69: socket error finding `flutter_volume_controller` at `https://pub.dev`. |
| `build-only` | `pass` | `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26684680541/job/78650789088` completed successfully. Listed steps all succeeded: `Install dependencies`, `Run shielding tests`, `Run settings model test`, `Run bootstrap startup test`, `Analyze`. |
| `packaging-only` | `fail` | `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26684680541/job/78650887126` failed at `Build x86_64 APK`. `Stage x86_64 APK` and `Upload x86_64 APK` were skipped. `flutter build apk --release --split-per-abi --target-platform android-x64 --android-project-arg dev=1 --pub` failed during Gradle `assembleRelease` with `android/build.gradle.kts` line 62: `Build Type release contains custom resource values, but the feature is disabled.` |
| `runtime-smoke` | `blocked-by-packaging` | `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26684680541/job/78650959882` was skipped because the upstream Android x86_64 build failed. No runtime evidence was produced. |
| `manual-acceptance` | `pending` | User-side real-device acceptance is required and cannot be replaced by CI. |
| `same-signature-cover-install` | `pending` | User-side cover install over the currently installed package is required. Uninstall-first does not count. |

## Artifact Evidence

- Android x86_64 artifact name: `Android_x86_64`
- Android x86_64 artifact URL: `none - not produced; upload did not run because the x86_64 build failed`
- Runtime smoke evidence artifact: `android-runtime-smoke-evidence`
- Runtime smoke evidence URL: `none - not produced; upstream packaging failed before runtime artifacts could be created`
- Runtime smoke status file: `none - not produced; upstream packaging failed before runtime artifacts could be created`
- Runtime smoke checked files: install, launch, pid, window, uiautomator, logcat, screenshot, blankness report, status.

## Release Evidence

- Release tag: `none`
- Release URL: `none`
- Release title: `none`
- Release type: `none`

Do not use release existence or workflow success as Phase 1 green evidence by
itself. A prebuild remains validation-only unless user manual acceptance and
same-signature cover-install pass.

## Decision

- Current Phase 1 decision: `not green`
- Reason: manual acceptance and same-signature cover-install are still pending
  unless separately filled with user-side evidence.
- Latest valid manual-acceptance prebuild baseline before this CI run:
  `phase-1-prebuild.26680259984`.

## Notes

- Failed or superseded prebuilds must remain preserved as evidence and must not
  be reused for acceptance.
- If runtime smoke fails, do not ask the user to continue manual acceptance on
  that artifact.
- If Android reports a signature mismatch during cover install, record the gate
  as yellow/blocker.
