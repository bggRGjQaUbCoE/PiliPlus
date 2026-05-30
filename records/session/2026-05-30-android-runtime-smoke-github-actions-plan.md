# Android Runtime Smoke GitHub Actions Plan

- role: worksite-runtime-smoke-gate
- session id: 2026-05-30-android-runtime-smoke-github-actions-plan
- date: 2026-05-30
- repo root: `/home/mo/Documents/piliavalon`
- writable GitHub repo: `CometDash77/PiliAvalon-Worksite`
- branch: `phase-1-shielding-core`
- status: workflow-added / dispatch-required

## Purpose

Phase 1 prebuild launch showed a white screen in user manual acceptance. The worksite environment has no local Flutter/adb/Java runtime, so the first Android install/launch smoke gate is moved to GitHub Actions instead of asking the user to be the first startup smoke test.

This record adds the workflow definition only. It does not claim runtime success until the workflow is pushed, dispatched, and its evidence artifact is reviewed.

## Added Workflow

Workflow path:

```text
.github/workflows/android_runtime_smoke.yml
```

Workflow name:

```text
Android Runtime Smoke
```

Triggers:

- `push` to `phase-1-shielding-core` when `.github/workflows/android_runtime_smoke.yml` changes. This uses the current default build run id and package name.
- `workflow_dispatch` with manual inputs after the workflow is available to dispatch.

Manual inputs:

- `artifact_run_id`: default `26628409138`, the prior Build workflow run containing APK artifacts.
- `package_name`: default `com.example.piliplus`, matching `android/app/build.gradle.kts` and `AndroidManifest.xml`.

## Runtime Smoke Coverage

The workflow is designed to:

- download the selected run's `*_x86_64.apk` artifact;
- enable KVM on the GitHub-hosted Ubuntu runner;
- start an x86_64 Android emulator with `reactivecircus/android-emulator-runner@v2`;
- install the APK with `adb install -r`;
- launch the app through the launcher category with `adb shell monkey`;
- wait 25 seconds for first-screen behavior;
- capture logcat, `dumpsys window`, screenshot, install output, launch output, pid, and metadata;
- upload all evidence as `android-runtime-smoke-evidence`.

## Evidence Classification

- Downloaded APK and artifact run id: `packaging-only`.
- Emulator install/launch, logcat, screenshot, window state, and pid evidence: `runtime-smoke`.
- Screenshot review is still required before declaring runtime smoke acceptable. A workflow pass only proves install/launch command completion and live process checks; it does not by itself prove that the first screen is visually correct.

## Dispatch Command

After committing and pushing this workflow to the worksite branch, the `push` trigger should run the first smoke attempt automatically.

For later manual reruns, dispatch it with an explicit repository target:

```text
gh workflow run android_runtime_smoke.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core -f artifact_run_id=26628409138 -f package_name=com.example.piliplus
```

Then monitor with:

```text
gh run list -R CometDash77/PiliAvalon-Worksite --workflow "Android Runtime Smoke" --branch phase-1-shielding-core --limit 5
gh run watch -R CometDash77/PiliAvalon-Worksite <run-id>
```

## Acceptance Rule

Phase 1 remains yellow until:

1. the runtime smoke workflow runs on GitHub Actions;
2. the evidence artifact is downloaded or inspected;
3. screenshot/logcat/window evidence shows the app reached an acceptable first screen instead of white screen, crash, or hang;
4. recommendation-feed and comment-area manual acceptance later pass on a runtime-smoke-cleared prebuild.

If the workflow cannot start an emulator, cannot install the APK, cannot launch the app, records white screen, or lacks evidence artifacts, record the gate as failed or blocked and keep Phase 1 yellow.

## First Dispatch Finding

Initial push-triggered run:

- run id: `26672323068`
- conclusion: failure
- failed step: `Download x86_64 APK artifact`
- root cause: the Build run artifacts are named as APK filenames, for example `PiliAvalon_android_2.0.7-cf9ed10f0+5006_x86_64.apk`, not `Android_x86_64`.

Workflow correction:

- replace exact artifact name lookup with pattern `*_x86_64.apk`;
- set `merge-multiple: true` so the APK lands directly under `runtime-smoke/apk`.
