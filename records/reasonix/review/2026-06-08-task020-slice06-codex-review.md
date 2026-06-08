Audience classification: agent-facing

# Codex Review: Task-020 Slice 06 Video-Detail Rule Action UI

Date: 2026-06-08
Repository: `CometDash77/PiliAvalon-Worksite`
Branch/worktree: `production` at `/home/mo/Documents/piliavalon`
Review owner: Codex

## Reviewed Artifacts

- Candidate implementation artifact:
  `records/reasonix/task-020/2026-06-08-slice-06-video-detail-rule-entry.md`
- Repair artifact:
  `records/reasonix/task-020/2026-06-08-slice-06-popup-dialog-deferral-repair.md`
- Repair artifact:
  `records/reasonix/task-020/2026-06-08-slice-06-captured-target-and-test-compile-repair.md`
- Dispatch prompts:
  `records/reasonix/prompts/2026-06-08-task-020-slice-06-video-detail-rule-entry.md`
  `records/reasonix/prompts/2026-06-08-task-020-slice-06-repair-popup-dialog-deferral.md`
  `records/reasonix/prompts/2026-06-08-task-020-slice-06-repair-captured-target-and-tests.md`

## Scope Reviewed

Slice 06 scope was video-detail add/update/remove controls for the current
channel quiet rule. Settings-page management remains out of scope for Slice 06.

Reviewed files:

- `lib/pages/video/channel_quiet/channel_quiet_target.dart`
- `lib/pages/video/channel_quiet/channel_quiet.dart`
- `lib/pages/video/controller.dart`
- `lib/pages/video/view.dart`
- `test/features/channel_quiet/channel_quiet_target_test.dart`

## Findings And Repairs

### Repaired: popup dialog route/context risk

Initial Reasonix implementation opened `_showChannelQuietEditor(...)` directly
from `PopupMenuItem.onTap` using the popup `itemBuilder` context. Codex flagged
this as a Flutter route-order risk because the popup menu route dismisses around
the same time as the callback.

Reasonix repair changed the call to defer with
`WidgetsBinding.instance.addPostFrameCallback`, guard `mounted`, and use the
stable page state context:

- `lib/pages/video/view.dart:1241-1244`

This repair is accepted.

### Repaired: non-const static method in const test initializers

A review subagent found that `const ChannelQuietTarget(...)` test initializers
called non-const static methods `ChannelQuietRule.ugcKey()` and
`ChannelQuietRule.pgcKey()`, which would not compile.

Reasonix changed those two initializers to `final`:

- `test/features/channel_quiet/channel_quiet_target_test.dart:100-114`

This repair is accepted.

### Repaired: dialog captured target vs recomputed target

A review subagent found that the dialog displayed a captured
`ChannelQuietTarget`, but save/remove actions called methods that recomputed
`currentChannelTarget` at execution time. If GetX/page state changed while the
dialog was open, the operation could no-op or affect a different channel.

Reasonix added explicit target-based controller methods and updated the dialog
to call them:

- `lib/pages/video/controller.dart:263-295`
- `lib/pages/video/view.dart:1297-1310`

Existing current-channel wrapper methods now delegate through the explicit
target methods:

- `lib/pages/video/controller.dart:303-321`

This repair is accepted.

## Accepted Behavior

The current Slice 06 code adds a video-detail overflow-menu action only when a
current channel identity is available:

- Menu target lookup and action label:
  `lib/pages/video/view.dart:1235-1246`
- Dialog editor:
  `lib/pages/video/view.dart:1253-1317`
- Current UGC/PGC target computation:
  `lib/pages/video/controller.dart:226-255`
- Save/update persistence using `ChannelQuietStore.update()` for existing rules
  and `ChannelQuietStore.add()` for new rules:
  `lib/pages/video/controller.dart:263-287`
- Remove persistence:
  `lib/pages/video/controller.dart:292-295`
- Target model and labels:
  `lib/pages/video/channel_quiet/channel_quiet_target.dart:3-46`

The implementation preserves the existing global-gate precedence because saved
rules only update `currentChannelQuietRule`, and effective visibility still
flows through the prior global hard gates:

- `lib/pages/video/controller.dart:175-185`

## Verification Evidence

Fresh commands run by Codex:

| Command | Exit code | Result |
|---|---:|---|
| `git diff --check` | 0 | No whitespace errors. |
| `dart test test/features/channel_quiet/channel_quiet_target_test.dart` | 127 | `dart: command not found`; local SDK unavailable. |
| `flutter test test/features/channel_quiet/channel_quiet_target_test.dart` | 127 | `flutter: command not found`; local SDK unavailable. |
| `git status --short --branch` | 0 | Worktree remains on `production` with expected Task-020 modifications and untracked channel_quiet tests/files. |

No local Dart/Flutter test, format, or analyzer green is claimed. Remote
verification remains required in later slices.

## Residual Risks

- No widget test proves the dialog interaction path. The current tests cover
  target model labels and store persistence semantics, but not the actual
  `showDialog` UI.
- Local SDK is unavailable, so import ordering, analyzer lints, and widget
  compile checks must be proven by CI or a Flutter-capable environment.
- Only the upper-right video overflow popup path is wired in Slice 06. Header
  sheet/full-screen controls can remain a later UX extension unless the final
  acceptance definition requires every "more" surface to expose the persistent
  rule action.
- For PGC display name, `pgcItem.title` is used. `seasonTitle ?? title` may be
  a polish improvement, but the persistent key and behavior use the reviewed
  `pgc:<seasonId>` identity and are not blocked by this.

## Review Decision

Slice 06 is accepted for code-review purposes after the two Reasonix repair
passes above. This review does not claim automation green, runtime smoke,
technical-lead acceptance, user/client acceptance, merge, release, or parent
closure.
