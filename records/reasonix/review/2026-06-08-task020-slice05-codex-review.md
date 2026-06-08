Audience classification: agent-facing

# Codex Review: Task-020 Slice 05 Danmaku Gates

Date: 2026-06-08
Reviewed artifact: `records/reasonix/task-020/2026-06-08-slice-05-danmaku-gates.md`
Review owner: Codex
Status: approved for next slice, with correction below

## Review Summary

Slice 05 is accepted. It made no production-code changes and added focused danmaku effective-state tests to `test/pages/video/quiet_state_test.dart`. Current production code from Slices 03 and 04 already wires the persistent rule into `effectiveShowDanmaku`, clears visible danmaku when a hide-danmaku rule becomes active, hides render/tap UI, and blocks later segment work through the existing listener gate.

## Correction To Reasonix Artifact

The artifact states that the parent `Obx` around the `PlDanmaku` builder causes a rebuild after the rule match. That parent builder primarily reads `cid.value`; it does not need to rebuild for the later segment-request gate to work.

The accepted proof is:

- `videoPositionListen()` reads `effectiveShowDanmaku` every time the listener fires, so later segment work returns before `getCurrentDanmaku(...)` when the rule is active.
- `PlDanmaku.build()` has its own `Obx` that reads `effectiveShowDanmaku` for opacity.
- The tap-danmaku action has its own `Obx` that reads `effectiveShowDanmaku`.
- `VideoDetailController.setChannelQuietRule(...)` clears visible danmaku immediately when `hideDanmaku` first becomes active.

## Verification

Codex ran:

```text
git diff --check
exit code: 0
result: no whitespace errors
```

```text
rg -n "danmaku gate|hideDanmaku|effectiveShowDanmaku|setChannelQuietRule|queryDanmaku|opacity:|enableTapDm" test/pages/video/quiet_state_test.dart lib/pages/video/controller.dart lib/pages/danmaku/view.dart lib/plugin/pl_player/view/view.dart
exit code: 0
result: relevant gate/test references found
```

Reasonix attempted:

```text
dart format test/pages/video/quiet_state_test.dart
exit code: 127
result: dart unavailable locally
```

```text
flutter test test/pages/video/quiet_state_test.dart
exit code: 127
result: flutter unavailable locally
```

## Accepted Gate Evidence

- Initial danmaku request is still not fully preventable by persistent channel rule because channel identity may arrive after `PlDanmaku.initState()`.
- Later segment requests are blocked by `lib/pages/danmaku/view.dart` checking `!effectiveShowDanmaku` before `getCurrentDanmaku(...)`.
- Render opacity is hidden through `effectiveShowDanmaku`.
- Tap-danmaku action UI is hidden through `effectiveShowDanmaku`.
- Visible danmaku is cleared in `VideoDetailController.setChannelQuietRule(...)` when a hide-danmaku rule first becomes active.
- Global danmaku off remains a hard gate through `effectiveShowContent(...)`.
- Temporary danmaku hide remains layered through the same helper.

## Boundaries

This review does not claim settings-page management, video-detail rule action UI, CI green, installable package, user acceptance, merge, formal release, or parent closure.
