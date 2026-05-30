# Runtime Smoke Release Update

- role: worksite-runtime-smoke-release-update
- session id: `2026-05-30-runtime-smoke-release-update`
- date: 2026-05-30
- repo: `/home/mo/Documents/piliavalon`
- branch: `phase-1-shielding-core`
- release: `phase-1-prebuild.26628409138`
- release URL: `https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26628409138`
- status: runtime-smoke automated gate green / user manual acceptance pending

## Scope

This session continued the Android `runtime-smoke` gate after the user reported that the Phase 1 prebuild installed but opened to a white screen.

The user clarified that manual acceptance is user-facing and will be performed by the user. The worksite therefore records only automation evidence and keeps user manual acceptance pending.

## Commits Pushed

Pushed to `origin/phase-1-shielding-core`:

1. `e0223f265be6bb28862e67875c9856de2e345b3a`
   - message: `ci: run runtime smoke commands from script`
   - purpose: move emulator install/launch commands into `.github/scripts/android_runtime_smoke.sh` so the emulator action runs the smoke command as one script.

2. `18f30dff8027c502308d2f8ae14d01ce02d45123`
   - message: `ci: upload runtime smoke evidence archive`
   - purpose: remove `archive: false` from evidence upload because `actions/upload-artifact@v7` allows raw upload only for a single file, while runtime smoke evidence has multiple files.

## Remote Runtime Smoke Evidence

- workflow: `Android Runtime Smoke`
- run id: `26672965859`
- run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26672965859`
- conclusion: `success`
- artifact: `android-runtime-smoke-evidence`
- artifact id: `7304909486`
- artifact URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26672965859/artifacts/7304909486`
- artifact size: 592623 bytes

Remote log facts:

- APK source run: `26628409138`
- APK selected by remote runner: `PiliAvalon_android_2.0.7-cf9ed10f0+5006_x86_64.apk`
- package launched: `com.example.piliplus`
- emulator: Android `15`, `sdk_gphone64_x86_64`
- install result: `Success`
- launch command: `adb shell monkey -p com.example.piliplus -c android.intent.category.LAUNCHER 1`
- launcher events injected: `1`
- app pid after wait: `2595`
- script status: `status=0`
- evidence upload: 8 files uploaded as `android-runtime-smoke-evidence.zip`

## Release Notes Update

Updated GitHub pre-release `phase-1-prebuild.26628409138` with:

- automated runtime smoke run URL;
- runtime smoke artifact URL;
- install/launch/process evidence summary;
- explicit note that APK handling stayed remote;
- explicit note that user-facing manual acceptance remains pending.

Manual acceptance in the release now means:

1. Android user-device install and first-screen behavior: pending user-side verification.
2. Recommendation feed shielding behavior: pending user-side verification.
3. Comment-area shielding behavior: pending user-side verification.

## Acceptance Decision

- `build-only`: green from focused shielding tests/analyze.
- `packaging-only`: green from APK build and pre-release asset attachment.
- `runtime-smoke`: green for automated GitHub x86_64 emulator install/launch/process gate.
- `manual-acceptance`: pending user-side verification.

Phase 1 is not green until the user completes manual acceptance.

## Repository Boundary

All repository write actions targeted `CometDash77/PiliAvalon-Worksite`.

`gh run` and `gh release` commands used `-R CometDash77/PiliAvalon-Worksite`. `gh api` calls used explicit `repos/CometDash77/PiliAvalon-Worksite/...` endpoints because `gh api` does not support `-R`.

No design-institute files were modified.

No APK was downloaded to the local workstation; the APK artifact was consumed by the GitHub-hosted runner during the workflow.
