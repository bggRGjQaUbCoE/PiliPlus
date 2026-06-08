Audience classification: agent-facing

# Task-020 Slice 04 Repair

Date: 2026-06-08
Role: `task020-slice04-repair`
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `production`
Review owner: Codex

## Source Artifact

- `records/reasonix/task-020/2026-06-08-slice-04-comment-gates.md` (Slice 04 original deliverable)

## Files Inspected

- `lib/pages/video/introduction/ugc/controller.dart`
- `lib/pages/video/introduction/pgc/controller.dart`
- `test/features/channel_quiet/channel_matching_test.dart`
- `test/pages/video/quiet_state_test.dart`

## Files Changed (This Repair)

- `lib/pages/video/introduction/ugc/controller.dart` — 3 edits:
  1. Stale-rule clear: `videoDetailCtr.setChannelQuietRule(null)` before returning when `mid == null`
  2. Removed unused `String? name` parameter from `_matchChannelQuietRule` method signature
  3. Removed unused `name` argument from call site at line 122
- `lib/pages/video/introduction/pgc/controller.dart` — 1 edit:
  1. Stale-rule clear: `videoDetailCtr.setChannelQuietRule(null)` before returning when `seasonId == null`

No changes to: `test/features/channel_quiet/channel_matching_test.dart`, `test/pages/video/quiet_state_test.dart`, danmaku files, settings UI, video-detail action UI, `.gitignore`.

## Issues Found and Fixes Applied

### Issue 1: Stale channel-quiet rule when mid/seasonId is null

**Root cause:** Both UGC `_matchChannelQuietRule` and PGC `_matchChannelQuietRule` returned without calling `setChannelQuietRule` when the channel identifier was null. This left `videoDetailCtr.currentChannelQuietRule` at whatever value it had from the previous video/page, causing a stale rule to affect comment gates on the new video.

**Stale-rule reasoning:**

The lifecycle is:

1. `VideoDetailController.onReset()` clears `currentChannelQuietRule.value = null`.
2. The intro controller (UGC or PGC) fires its async init/query.
3. If a matching rule is found, `setChannelQuietRule(rule)` sets it.
4. If the channel identifier is null (deleted account, edge case, missing route arg), the original code just returned — leaving `currentChannelQuietRule` as `null` from step 1 IF this is the first match. But in the UGC episode-switch path (`onChangeEpisode` → `queryVideoIntro`), `onReset()` also fires, clearing the rule to null. So the stale case primarily applies to: PGC `onInit()` where `seasonId` happens to be null from route args but a prior PGC page had set a rule on the same `videoDetailCtr` instance. Similarly for UGC if `onReset()` somehow isn't called between videos. The explicit null-set is defensive and correct regardless.

The concrete fix:

- UGC: `if (mid == null) { videoDetailCtr.setChannelQuietRule(null); return; }`
- PGC: `if (seasonId == null) { videoDetailCtr.setChannelQuietRule(null); return; }`

This ensures that a video without a channel identifier always clears any previously matched rule.

### Issue 2: Unused `name` parameter in UGC `_matchChannelQuietRule`

The `String? name` parameter in `_matchChannelQuietRule(int? mid, String? name)` was plumbed from `response.owner?.name` but was never used — the lookup uses only `mid` for the `ugc:<mid>` key. Removed from both signature and call site.

### Call site before/after

```dart
// Before (line 122)
_matchChannelQuietRule(response.owner?.mid, response.owner?.name);

// After
_matchChannelQuietRule(response.owner?.mid);
```

## Commands and Exit Codes

```text
pwd && git status --short --branch
exit code: 0
```

```text
git diff --check
exit code: 0
result: no whitespace errors
```

```text
git diff --stat
exit code: 0
result: 6 files changed, 228(+), 2(-) (cumulative across slices 02-04)
```

```text
dart format lib/pages/video/introduction/ugc/controller.dart lib/pages/video/introduction/pgc/controller.dart
exit code: 127
result: dart not available locally
```

```text
flutter test test/features/channel_quiet/channel_matching_test.dart test/pages/video/quiet_state_test.dart
exit code: 127
result: flutter not available locally
```

## Remaining Local-Tool Limitations

- `dart format` and `flutter test` are unavailable in the local sandbox (exit 127). This matches evidence from Slices 02, 03, and 04. Formatting and static-analysis verification must occur in remote CI or a future slice with a Flutter-instrumented environment.
- Full controller-level tests for `_matchChannelQuietRule` are not practical as pure unit tests because the method is a private instance method on GetX controllers (`UgcIntroController`, `PgcIntroController`) that calls `videoDetailCtr.setChannelQuietRule()` — a GetX-injected dependency. Full controller tests would require `Get.put`/`Get.find` and Flutter widget test harness initialization. The existing test files cover the pure layers adequately:
  - `test/features/channel_quiet/channel_matching_test.dart` — 6 tests on `ChannelQuietStore` lookup and `hideComments` derivation using `_MemoryBox`
  - `test/pages/video/quiet_state_test.dart` — tests on `effectiveShowContent`, `effectiveShowTemporaryContent`, and `quietControlsEffectiveTabIndex` helpers

## Non-Claims

- This repair does not claim `dart format` green (unavailable locally).
- This repair does not claim `flutter test` green (unavailable locally).
- This repair does not claim `dart analyze` green.
- This repair does not claim CI green, remote verification, runtime smoke, or user acceptance.
- This repair does not modify danmaku view/controller (Slice 05 scope).
- This repair does not add video-detail rule action UI (Slice 06 scope).
- This repair does not add settings-page management UI (Slice 07 scope).
- This repair does not push, merge, tag, release, or close any gate.
- The architectural constraint from Slice 01/04 remains: initial `VideoReplyController` creation is not prevented — the practical gate is `customGetData()` + tab hiding once the channel rule is effective.
