# Phase 1 CI Evidence Record

Date: 2026-05-30

## Scope

This record is the fill-in template for the unified Phase 1 CI entry.
GitHub Actions is the authority for build and runtime evidence. Local Windows
preflight is only a quick secondary check and does not prove APK packaging,
emulator launch, device behavior, manual acceptance, or same-signature
cover-install.

## Repository

- Repo: `CometDash77/PiliAvalon-Worksite`
- Local root: `C:\Users\77182\Documents\Coding\piliavalon`
- Branch: `phase-1-shielding-core`
- Commit SHA at template creation: `41b5a8217793cd47a7e71183e11b894201db93a2`

## Workflow

- Workflow name: `Phase 1 CI`
- Workflow file: `.github/workflows/ci.yml`
- Run id: `none - not dispatched from this local change`
- Run URL: `none - not dispatched from this local change`
- Job URL: `none - not dispatched from this local change`
- Event: `none`
- Conclusion: `not-run`
- Created: `none`
- Completed: `none`

All GitHub CLI commands used to dispatch, inspect, or download evidence for this
repo must explicitly target `CometDash77/PiliAvalon-Worksite`. Use
`-R CometDash77/PiliAvalon-Worksite` for supported `gh` commands, and use
`repos/CometDash77/PiliAvalon-Worksite/...` endpoints for `gh api`.

## Evidence Classes

| Evidence class | Status | Evidence |
|---|---|---|
| `local-preflight` | `fail` | `powershell -ExecutionPolicy Bypass -File tool/preflight.ps1` reached `flutter pub get`, then failed with exit 69: socket error finding `flutter_volume_controller` at `https://pub.dev`. |
| `build-only` | `not-run` | `Phase 1 CI` focused verification has not been dispatched from this local change. This class records dependency, test, and analyzer evidence only; it is not APK packaging proof. |
| `packaging-only` | `not-run` | `Phase 1 CI` Android x86_64 build has not been dispatched from this local change; artifact `Android_x86_64` is pending. |
| `runtime-smoke` | `not-run` | `Phase 1 CI` has not been dispatched from this local change; evidence artifact `android-runtime-smoke-evidence` is pending. |
| `manual-acceptance` | `pending` | User-side real-device acceptance is required and cannot be replaced by CI. |
| `same-signature-cover-install` | `pending` | User-side cover install over the currently installed package is required. Uninstall-first does not count. |

## Artifact Evidence

- Android x86_64 artifact name: `Android_x86_64`
- Android x86_64 artifact URL: `none - not produced by this local change yet`
- Runtime smoke evidence artifact: `android-runtime-smoke-evidence`
- Runtime smoke evidence URL: `none - not produced by this local change yet`
- Runtime smoke status file: `none - not produced by this local change yet`
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
- Latest valid manual-acceptance prebuild baseline before this CI template:
  `phase-1-prebuild.26680259984`.

## Notes

- Failed or superseded prebuilds must remain preserved as evidence and must not
  be reused for acceptance.
- If runtime smoke fails, do not ask the user to continue manual acceptance on
  that artifact.
- If Android reports a signature mismatch during cover install, record the gate
  as yellow/blocker.
