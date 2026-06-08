Audience classification: agent-facing

# Task-020 Slice 05 Danmaku Gates

Date: 2026-06-08
Role: `task020-slice05-danmaku-gates`
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `production`
Review owner: Codex

## Conclusion: No Product-Code Changes Needed

All 7 danmaku gate behaviors required by the atomic plan are already correctly
implemented by the Slices 03 and 04 product code. The existing `effectiveShowContent`
three-level gate in Slice 03, combined with the Slice 04 channel-rule lookup
wiring into the UGC and PGC intro controllers, fully satisfies the danmaku
requirements. No production-code edits were made in this slice.

The only change is 4 new danmaku-focused tests added to the existing
`test/pages/video/quiet_state_test.dart`.

## Command Log

```text
pwd && git status --short --branch
exit code: 0
branch: production, tracking origin/production

modified:  .gitignore
modified:  lib/pages/video/controller.dart
modified:  lib/pages/video/introduction/pgc/controller.dart
modified:  lib/pages/video/introduction/ugc/controller.dart
modified:  lib/pages/video/quiet_state.dart
modified:  test/pages/video/quiet_state_test.dart
untracked: lib/pages/video/channel_quiet/
untracked: test/features/channel_quiet/
```

```text
git diff --check
exit code: 0
result: no whitespace errors
```

```text
git diff --stat
exit code: 0
result: 6 files, +285/-2; quiet_state_test.dart accounts for +194
```

```text
rg -n "[^\x00-\x7F]" test/pages/video/quiet_state_test.dart || echo "no non-ASCII matches"
exit code: 0
result: no non-ASCII matches
```

```text
dart format test/pages/video/quiet_state_test.dart 2>&1; echo "dart format exit: $?"
exit code: 127
result: dart: command not found
```

```text
flutter test test/pages/video/quiet_state_test.dart 2>&1; echo "flutter test exit: $?"
exit code: 127
result: flutter: command not found
```

## Files Changed

**One file changed in this slice:**

- `test/pages/video/quiet_state_test.dart` — Added 4 danmaku gate tests
  (57 new lines in a group `danmaku gate: persistent hideDanmaku hides danmaku`).

**No production files changed in this slice.** All production files listed as
modified in git status are from prior slices (02/03/04).

## Source-Line Proof For All 7 Danmaku Gates

### Gate 1: Init gate (first segment request — NOT preventable)

`lib/pages/danmaku/view.dart:44-46` and `:60-70`

```dart
bool get effectiveShowDanmaku =>
    widget.videoDetailController?.effectiveShowDanmaku ??
    playerController.enableShowDanmaku.value;
```

In `initState()` at line 60: `if (effectiveShowDanmaku) { ... queryDanmaku(...); }`

**Stage A limitation confirmed:** `initState()` runs in the first frame build,
before the async UGC/PGC intro HTTP response arrives. At that point
`currentChannelQuietRule` is `null`, so `persistentRuleHideDanmaku` is `false`.
The first danmaku segment request cannot be prevented by a channel rule.
This is the accepted current-architecture limitation. The effective-state
gate is structurally correct; it just cannot see the channel rule yet.

### Gate 2: Later segment-request gate (position listener)

`lib/pages/danmaku/view.dart:99-101`

```dart
void videoPositionListen(Duration position) {
    if (_controller == null || !effectiveShowDanmaku) {
      return;
    }
```

After a persistent rule with `hideDanmaku == true` is matched and
`setChannelQuietRule()` sets `currentChannelQuietRule`, the `Obx` wrapping
in `lib/pages/video/view.dart` (the parent `PlDanmaku` builder) causes a
rebuild. The new `effectiveShowDanmaku` reads the updated
`persistentRuleHideDanmaku`, which is now `true`.
All subsequent `videoPositionListen()` calls return at line 100 before
`getCurrentDanmaku()` can trigger a lazy `queryDanmaku(segmentIndex)`.

✅ Later segment requests are fully blocked.

### Gate 3: Render opacity gate

`lib/pages/danmaku/view.dart:180-184`

```dart
Obx(
  () => AnimatedOpacity(
    opacity: effectiveShowDanmaku
        ? playerController.danmakuOpacity.value
        : 0,
```

When `effectiveShowDanmaku` becomes `false`, the `Obx` triggers a rebuild
and `AnimatedOpacity` transitions opacity to 0 over 100ms. Visible danmaku
on screen fades out.

✅ Render hides danmaku when rule is active.

### Gate 4: Tap-danmaku UI gate

`lib/plugin/pl_player/view/view.dart:1423-1428`

```dart
if (plPlayerController.enableTapDm)
  Obx(
    () {
      if (!videoDetailController.effectiveShowDanmaku) {
        return const SizedBox.shrink();
      }
```

When `effectiveShowDanmaku` is `false`, the tap-danmaku action UI widget
returns `SizedBox.shrink()`, taking zero space in the layout.
There is no stale tap target left behind.

✅ Tap-danmaku UI is fully hidden.

### Gate 5: Clear on rule match

`lib/pages/video/controller.dart:213-219`

```dart
void setChannelQuietRule(ChannelQuietRule? rule) {
    final previous = currentChannelQuietRule.value;
    currentChannelQuietRule.value = rule;
    if (rule?.hideDanmaku == true && (previous?.hideDanmaku != true)) {
      plPlayerController.danmakuController?.clear();
    }
}
```

When a persistent rule with `hideDanmaku == true` first becomes active
(and the previous rule did not already hide danmaku), the visible danmaku
canvas is cleared immediately so stale danmaku does not remain on screen.

The existing `toggleTempHideDanmaku()` at `controller.dart:192-198` uses
the same `plPlayerController.danmakuController?.clear()` call.

✅ Danmaku is cleared promptly when a hide-danmaku rule first activates.

### Gate 6: Global hard gate

`lib/pages/video/controller.dart:181-185`

```dart
bool get effectiveShowDanmaku => effectiveShowContent(
    globalShow: plPlayerController.enableShowDanmaku.value,
    persistentRuleHide: persistentRuleHideDanmaku,
    temporaryHide: tempHideDanmaku.value,
);
```

`lib/pages/video/quiet_state.dart:41-46`

```dart
bool effectiveShowContent({
  required bool globalShow,
  required bool persistentRuleHide,
  required bool temporaryHide,
}) =>
    globalShow && !persistentRuleHide && !temporaryHide;
```

When `enableShowDanmaku.value` is `false` (global danmaku off), the `&&`
short-circuit guarantees `effectiveShowDanmaku` is `false` regardless of
persistent or temporary state. No downstream override can re-enable danmaku.
This is the same `globalShow` pattern used by `effectiveShowTemporaryContent`
from Task-039.

✅ Global off is a hard gate; cannot be overridden.

### Gate 7: Temporary controls preserved

`lib/pages/video/controller.dart:184` and `toggleTempHideDanmaku()` at `:192-198`

```dart
bool get effectiveShowDanmaku => effectiveShowContent(
    ...,
    temporaryHide: tempHideDanmaku.value,
);
```

The temporary toggle (`toggleTempHideDanmaku()`) still writes `tempHideDanmaku`,
which feeds into `effectiveShowContent` as the third parameter. The caller at
`lib/pages/video/view.dart` around the "quiet controls" widget still calls
`toggleTempHideDanmaku()` on the same controller. The temporary override is
independent of and layered on top of the persistent rule:

```
effectiveShowDanmaku = globalShow && !persistentRuleHide && !temporaryHide
```

✅ Temporary controls behavior preserved.

## New Tests Added

### `test/pages/video/quiet_state_test.dart` — danmaku gate group

Four tests mirroring the existing comment-gate group but explicitly for danmaku:

1. **`hidden when channel rule hideDanmaku is true`** — `effectiveShowContent`
   returns `false` when `persistentRuleHide: true, temporaryHide: false`
   (assuming `globalShow: true`).

2. **`visible when channel rule only has hideComments (not hideDanmaku)`** —
   `effectiveShowContent` returns `true` when `persistentRuleHide: false`,
   proving that a `hideComments`-only rule does not imply danmaku hiding.

3. **`visible when no channel rule matches (persistentRuleHide false)`** —
   Regression test for the null-match case.

4. **`hard gate: global off overrides everything even with channel hideDanmaku rule`** —
   When `globalShow: false`, `effectiveShowContent` returns `false` regardless
   of `persistentRuleHide` and `temporaryHide`.

### Store lookup for hideDanmaku (existing test, no additions needed)

`test/features/channel_quiet/channel_matching_test.dart:38-54` already tests
that a PGC rule with `hideDanmaku: true` produces `hideDanmaku == true` on
lookup, and `:71-83` tests that a `hideDanmaku`-only rule does not imply
`hideComments`. The store lookup path is fully covered by Slice 04 tests.

## Gate Chain (Full Path)

```
ChannelQuietStore.lookup(key)  →  ChannelQuietRule.hideDanmaku
    ↓
VideoDetailController.persistentRuleHideDanmaku  →  effectiveShowContent
    ↓
VideoDetailController.effectiveShowDanmaku
    ↓
PlDanmaku._PlDanmakuState.effectiveShowDanmaku  (danmaku/view.dart:44-46)
    ↓
    ├── initState(): skip first queryDanmaku if already false
    ├── videoPositionListen(): block later segment requests
    ├── build(): AnimatedOpacity to 0
    └── PlDanmakuController.queryDanmaku(): no inline gate, but called only
        from videoPositionListen/getCurrentDanmaku which are already gated

PlPlayerView tap-danmaku Obx: hide if !effectiveShowDanmaku
    (pl_player/view/view.dart:1426-1428)
```

## What This Slice Does NOT Do

- No settings route/page edits (Slice 07 scope).
- No video-detail rule action UI edits (Slice 06 scope).
- No comment-specific edits.
- No dependency installs.
- No `git add` / commit / push / merge / tag / release.
- No CI/workflow dispatch.
- No governance-policy or Design Institute edits.

## Risks and Later-Slice Dependencies

1. **First frame danmaku request:** The very first `PlDanmaku.initState()`
   segment request fires with `effectiveShowDanmaku` reading the pre-match
   state (global on, no persistent rule yet). This is accepted architecture
   limitation. A brief burst of danmaku may appear before the async intro
   response arrives and applies the hide rule. This is a user-visible timing
   window, not a code bug.

2. **Obx reactivity on PlDanmaku:** The `PlDanmaku` widget is created inside
   an `Obx` in `lib/pages/video/view.dart:1318`. The `Obx` listens to whatever
   reactive state is read inside its builder. The `effectiveShowDanmaku` getter
   reads `currentChannelQuietRule` (an `Rx<ChannelQuietRule?>`), `plPlayerController.
   enableShowDanmaku` (another Rx), and `tempHideDanmaku` (another Rx). When
   `setChannelQuietRule()` updates `currentChannelQuietRule`, the Obx should
   trigger a `PlDanmaku` rebuild with the new `effectiveShowDanmaku`. However,
   the `PlDanmaku` uses `ValueKey(videoDetailController.cid.value)` — a key
   that does not change on rule match. This means the existing widget instance
   is rebuilt (not replaced), and `didUpdateWidget` runs, which only handles
   font-scale changes. The render opacity and position-listener gates are
   evaluated live (not cached), so they should pick up the new value
   correctly. No regression expected, but the rebuild path should be verified
   on a real device/emulator (Slice 08/09 remote CI).

3. **PlDanmakuController.queryDanmaku has no inline gate:** The method at
   `lib/pages/danmaku/controller.dart:44-65` does not check
   `effectiveShowDanmaku` itself. It is called only from:
   - `initState()` line 64 — first-frame, before rule match (accepted)
   - `getCurrentDanmaku()` line 107 — only reached if `videoPositionListen`
     passed the `effectiveShowDanmaku` gate at line 100
   So the missing inline gate is safe given current call sites. If a new
   caller is added, it would need its own gate. This is a latent risk
   documented for future maintainers.

4. **No local Flutter/Dart:** Static analysis and test execution must be
   delegated to remote CI (Slice 08/09). This slice provides the test code
   but cannot prove it compiles or passes.

## Boundaries

This slice does not claim CI green, manual acceptance, technical-lead review,
user/client acceptance, merge, release, or parent closure.
