# Phase 1 White Screen Fix Plan

- role: worksite-fix-plan
- session id: 2026-05-30-phase-1-white-screen-fix-plan
- date: 2026-05-30
- repo root: `/home/mo/Documents/piliavalon`
- writable GitHub repo: `CometDash77/PiliAvalon-Worksite`
- branch: `phase-1-shielding-core`
- status: in_progress / fix and runtime-smoke follow-up required

## Current State

The Phase 1 prebuild `phase-1-prebuild.26628409138` is not fixed. The
user-reported white-screen startup failure remains the governing state until a
new build is produced and checked again.

The automated runtime-smoke run `26672965859` is useful evidence for the
GitHub-hosted x86_64 emulator path, but it is not user-device acceptance and
must not be relabeled as such.

## Required Next Output

The next valid worksite output is a new fixed prebuild release, not a repeat of
the same APK handoff.

Minimum path:

1. diagnose startup bootstrap behavior;
2. implement a visible startup failure UI instead of silent exit/blank screen;
3. strengthen the Android runtime-smoke gate so blank screenshots cannot pass;
4. build a fresh APK;
5. run runtime smoke on the new APK;
6. publish a new pre-release for user manual acceptance.

## Risk Callout

Do not ask the user to retest `phase-1-prebuild.26628409138` as if it were a
new fix. User-side manual acceptance remains pending on a new build.

## Evidence Boundary

- `build-only`: focused CI and APK packaging evidence.
- `runtime-smoke`: install, launch, screenshot, logcat, and process evidence.
- `manual-acceptance`: user verification of recommendation and comment
  shielding after runtime smoke passes.
