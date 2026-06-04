# Phase 1 Project Progress For Design Institute

Date: 2026-05-30
Recorded at: 2026-05-30T21:50:00+08:00

## Current Status

Phase 1 is `not green`.

The previous Android x86_64 packaging blocker has been cleared, but the current
unified Phase 1 CI run is blocked by runtime smoke launch failure. The package
cannot be treated as ready for manual acceptance.

## Completed

- Focused Flutter verification passed.
- Android x86_64 APK build passed.
- `Android_x86_64` artifact was produced.
- Artifact id: `7308754820`.
- Commit `b6bb438f4` restored the Android x86_64 packaging gate.

## Not Completed

- Runtime smoke has not passed.
- Runtime smoke failed at app launch:
  `Activity class {com.example.piliplus.dev/com.example.piliplus.dev.MainActivity} does not exist`.
- Build prebuild publication has not continued after the runtime-smoke failure.
- The new APK must not be handed to the user for same-signature cover install
  or manual acceptance.

## Acceptance Baseline

The latest valid manual-acceptance prebuild baseline remains:

```text
phase-1-prebuild.26680259984
```

That baseline remains separate from the failed run described here. The current
artifact must not be relabeled as an acceptance package unless a later run
passes runtime smoke and records fresh evidence.

## Defect Discussion Boundary

The current evidence supports discussing a launch-entry/runtime-smoke defect
with the design institute. It does not support reporting a confirmed visual,
interaction, content, or recommendation/comment shielding design defect.

The key question for review is whether runtime smoke should launch through a
different strategy, whether the Android dev package/activity configuration is
wrong, or whether the acceptance criteria should explicitly define the launch
entry for dev APKs.
