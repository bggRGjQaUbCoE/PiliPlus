Audience classification: agent-facing

# Task-020 Slice 03: Effective State

Date: 2026-06-08
Role: `task020-slice03-effective-state`
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `production`
Review owner: Codex

## Summary

Implemented the three-level effective-state helper (`effectiveShowContent`) and
controller-facing persistent-rule state for channel quiet rules. The existing
Task-039 temporary behavior is preserved. `effectiveShowTemporaryContent` is
untouched for backward compatibility. Tests cover all 8 truth-table combinations
plus the full global-off override, and the existing tab-index tests remain
structurally unchanged.

## Command Log

```text
pwd && git status --short --branch
exit code: 0
result: branch production; .gitignore, controller.dart, quiet_state.dart,
        quiet_state_test.dart modified; channel_quiet dirs untracked
```

```text
git diff --check
exit code: 0
result: no whitespace errors
```

```text
git diff --stat
exit code: 0
result:
 .gitignore                             |  2 +
 lib/pages/video/controller.dart        | 38 +++++++++++++++-
 lib/pages/video/quiet_state.dart       | 12 +++++
 test/pages/video/quiet_state_test.dart | 81 ++++++++++++++++++++++++++++++++++
 4 files changed, 131 insertions(+), 2 deletions(-)
```

```text
flutter test test/pages/video/quiet_state_test.dart
exit code: 127
result: flutter: command not found
```

```text
dart format lib/pages/video/quiet_state.dart lib/pages/video/controller.dart
         test/pages/video/quiet_state_test.dart
exit code: 127
result: dart: command not found
```

## Files Changed

### Modified

| File | Change |
|------|--------|
| `lib/pages/video/quiet_state.dart` | +12 lines: added `effectiveShowContent` helper with doc comment |
| `lib/pages/video/controller.dart` | +38/-2 lines: added reactive `currentChannelQuietRule`, `persistentRuleHideReply`/`persistentRuleHideDanmaku` getters, `setChannelQuietRule()` method, wired 3-level helper into `effectiveShowReply`/`effectiveShowDanmaku`, added reset path in `onReset()` |
| `test/pages/video/quiet_state_test.dart` | +81 lines: added `effectiveShowContent` test group with 5 tests covering all 8 truth-table combinations; existing `effectiveShowTemporaryContent` and `quietControlsEffectiveTabIndex` groups preserved |

### Not Changed

- `lib/pages/video/view.dart`
- `lib/pages/video/reply/controller.dart`
- `lib/pages/danmaku/view.dart`
- `lib/pages/danmaku/controller.dart`
- `lib/pages/video/widgets/header_control.dart`
- `lib/pages/video/channel_quiet/` (Slice 02 artifacts, untouched)
- `.gitignore` change is from Slice 02, not this slice

## TDD Evidence

### Red phase

Tests for `effectiveShowContent` were written before the production function
existed. The test file references a symbol (`effectiveShowContent`) that was not
yet defined in `quiet_state.dart`. This fulfills the "write failing tests first"
requirement.

### Green phase

`effectiveShowContent` was then added to `quiet_state.dart` with the signature
matching the tests. Local test execution cannot confirm green because
Flutter/Dart is unavailable (exit code 127). CI execution (Slice 08) is required
to confirm pass status.

### Test coverage

| Group | Test | Expected |
|-------|------|----------|
| `effectiveShowContent` | visible: global on, persistent off, temporary off | `true` |
| `effectiveShowContent` | hidden: global on, persistent on, temporary off | `false` |
| `effectiveShowContent` | hidden: global on, persistent off, temporary on | `false` |
| `effectiveShowContent` | hidden: global on, persistent on, temporary on | `false` |
| `effectiveShowContent` | hidden: global off x 4 combos | `false` x 4 |
| `effectiveShowTemporaryContent` | 4 combos (preserved) | unchanged |
| `quietControlsEffectiveTabIndex` | 4 tab-index tests (preserved) | unchanged |

Total: 13 test cases across 3 groups (5 new + 1 existing + 4 existing).

## Effective-State API Summary

### `quiet_state.dart`

```dart
/// Three-level effective visibility: global gate, persistent channel rule,
/// and temporary (per-page) override.
///
/// Global off is a hard gate that cannot be overridden by persistent or
/// temporary controls.
bool effectiveShowContent({
  required bool globalShow,
  required bool persistentRuleHide,
  required bool temporaryHide,
}) =>
    globalShow && !persistentRuleHide && !temporaryHide;
```

The existing `effectiveShowTemporaryContent` (2-level: global + temporary) is
preserved unchanged for any code that still uses it directly.

### `controller.dart` -- new state fields

```dart
/// The quiet rule currently matched for this video's channel.
/// Set by later slices once channel identity is known.
/// `null` means no persistent rule is active for the current channel.
final Rx<ChannelQuietRule?> currentChannelQuietRule =
    Rx<ChannelQuietRule?>(null);

bool get persistentRuleHideReply =>
    currentChannelQuietRule.value?.hideComments ?? false;
bool get persistentRuleHideDanmaku =>
    currentChannelQuietRule.value?.hideDanmaku ?? false;
```

### `controller.dart` -- modified effective getters

```dart
bool get effectiveShowReply => effectiveShowContent(
    globalShow: showReply,
    persistentRuleHide: persistentRuleHideReply,
    temporaryHide: tempHideReply.value,
);

bool get effectiveShowDanmaku => effectiveShowContent(
    globalShow: plPlayerController.enableShowDanmaku.value,
    persistentRuleHide: persistentRuleHideDanmaku,
    temporaryHide: tempHideDanmaku.value,
);
```

### `controller.dart` -- rule setter with danmaku clear

```dart
/// Set the current channel's persistent quiet rule.
///
/// Called by later slices once the channel identity is known and a matching
/// rule is found in [ChannelQuietStore].  Pass `null` to clear the active
/// match without touching the persisted database.
///
/// When a rule with `hideDanmaku == true` takes effect, visible danmaku
/// is cleared immediately so the screen does not show stale danmaku.
void setChannelQuietRule(ChannelQuietRule? rule) {
    final previous = currentChannelQuietRule.value;
    currentChannelQuietRule.value = rule;
    if (rule?.hideDanmaku == true && (previous?.hideDanmaku != true)) {
      plPlayerController.danmakuController?.clear();
    }
}
```

### Reset path

In `onReset()` (line ~1367), after `resetTempQuietControls()`:

```dart
// Clear the current persistent-rule match without touching the stored
// database -- later slices re-evaluate the match when channel identity
// becomes available again.
currentChannelQuietRule.value = null;
```

This clears the in-memory reactive match but does NOT call `ChannelQuietStore`
-- the persisted database is left intact for later slices to re-read.

## Controller State / Reset / Clear Behavior

### Default state

`currentChannelQuietRule` starts as `null`. Both persistent-rule hide getters
return `false` when null. The effective state behaves identically to the
Task-039 two-level helper until a later slice sets a non-null rule.

### Setting a rule match

Later slices call `setChannelQuietRule(rule)` with a `ChannelQuietRule` from
`ChannelQuietStore`. The reactive field updates, and `effectiveShowReply` /
`effectiveShowDanmaku` recompute through the 3-level `effectiveShowContent`
helper. If the rule's `hideDanmaku` transitions from inactive to active,
`plPlayerController.danmakuController?.clear()` fires immediately -- same
pattern as `toggleTempHideDanmaku()`.

### Resetting on video change

`onReset()` now contains `currentChannelQuietRule.value = null;` after
`resetTempQuietControls()`. This drops the current rule match so the next
video starts with no persistent rule active. Later slices must re-derive
channel identity and call `setChannelQuietRule()` again to re-apply.

### No storage mutation in this slice

`currentChannelQuietRule` is an in-memory reactive field. It does not read
from or write to `ChannelQuietStore`, Hive, or any other persistence surface.
Storage ownership stays with Slice 02's `ChannelQuietStore` and later slices
that call `store.lookup()` / `store.add()`.

## Explicit Boundaries

This slice does **not** claim:

- Comment request gate edits (`lib/pages/video/reply/controller.dart`)
- Danmaku view/controller edits (`lib/pages/danmaku/view.dart`,
  `lib/pages/danmaku/controller.dart`)
- Settings route/page edits
- Video-detail action UI edits (`lib/pages/video/widgets/header_control.dart`)
- Channel identity derivation or storage loading (later slices own that)
- Local test green (Flutter/Dart unavailable, exit 127)
- CI green, manual acceptance, technical-lead review, client acceptance, or
  user acceptance
- Git add, commit, push, merge, tag, release, or workflow dispatch
- Governance-policy edits or Design Institute edits
- Any modification to `lib/pages/video/channel_quiet/` (Slice 02 artifacts
  are untouched)
