# Design-Institute Runtime Smoke Launcher Review

Date: 2026-05-30
Recorded at: 2026-05-30T22:20:00+08:00

## Scope

This record persists the design-institute review decision for the Phase 1
runtime-smoke launcher fix. It is a governance and evidence-gate record only;
it does not change runtime code, CI code, release metadata, or acceptance
labels.

## Reviewed Commit

```text
300112080 ci: resolve runtime smoke launcher activity
```

## Decision

The launcher strategy in commit `300112080` is correct for the dev APK package
and activity relationship:

```text
package: com.example.piliplus.dev
activity class: com.example.piliplus.MainActivity
```

The runtime smoke should prefer the Android launcher-resolved component. If the
launcher component cannot be resolved, it may fall back to the manifest-derived
component for `com.example.piliplus.MainActivity` under package
`com.example.piliplus.dev`.

This decision supersedes only the earlier interpretation that launching
`com.example.piliplus.dev/.MainActivity` was a valid dev APK entry point. It
does not rewrite the earlier failure reports or convert any failed run into a
passed runtime-smoke result.

## Required Pass Criteria

A later runtime-smoke run may be accepted only when all of the following are
true:

- The APK installs successfully.
- The app launches through the launcher-resolved component, or through the
  manifest fallback component if launcher resolution is unavailable.
- Foreground app UI is visible.
- There is no app crash or ANR evidence.
- The evidence artifact is complete and reviewed, including:
  - `launcher-component.txt`
  - `launcher-resolution.txt`
  - `adb-install.txt`
  - `adb-launch.txt`
  - `window.txt`
  - `uiautomator.xml`
  - `logcat.txt`
  - `app-crash-error.txt`
  - `screenshot.png`
  - `screenshot-blankness.txt`
  - `pidof.txt`
  - `status.txt`

## Current Gate

GitHub Actions run `26686476869` is not accepted by this record. At review
time, the run and its evidence had not been accepted through full artifact
review.

No new manual-acceptance APK is approved from commit `300112080` unless a later
runtime-smoke decision records both a passing CI result and reviewed evidence
for install, launch, foreground UI, crash/ANR absence, screenshot, window,
uiautomator, logcat, process, and status.

## Release Boundary

Do not publish, relabel, or hand off a new manual-acceptance package from this
launcher fix until runtime smoke has passed and the evidence has been reviewed.

The latest valid manual-acceptance baseline remains:

```text
phase-1-prebuild.26680259984
```
