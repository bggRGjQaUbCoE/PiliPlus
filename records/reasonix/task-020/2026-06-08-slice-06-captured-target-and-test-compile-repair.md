# Task-020 Slice 06 — Captured-Target and Test Compile Repair

**Audience classification:** agent-facing

**Response instructions confirmed:** Yes, response instructions / 响应指令 are enabled for this task.

**role_id:** task-020-slice-06-captured-target-and-test-compile-repair-agent

**target_repo:** `CometDash77/PiliAvalon-Worksite`

**target_branch_or_run:** production worktree at `/home/mo/Documents/piliavalon`

**review_owner:** Codex

**Task difficulty classification:** simple bounded repair (deepseek-flash)

---

## Summary

Two findings from Task-020 Slice 06 were repaired:

### Finding 1 — High: const compile error in test file

**File:** `test/features/channel_quiet/channel_quiet_target_test.dart`

**Root cause:** Two test initializers used `const ChannelQuietTarget(key: ChannelQuietRule.ugcKey(42), ...)` and `const ChannelQuietTarget(key: ChannelQuietRule.pgcKey(888), ...)`. Dart `const` expressions cannot call non-const static methods.

**Fix:** Removed `const` → changed to `final target = ChannelQuietTarget(...)` on both lines (99, 108 in the original file).

**Line anchors:**
- Line 100: `final target = ChannelQuietTarget(key: ChannelQuietRule.ugcKey(42), ...)` (was `const`)
- Line 109: `final target = ChannelQuietTarget(key: ChannelQuietRule.pgcKey(888), ...)` (was `const`)

All other `const ChannelQuietTarget(...)` usages in the file use only string literal arguments (valid in const context) and were left unchanged.

### Finding 2 — Medium: captured-target race in view.dart dialog

**Root cause:** The dialog Save/Remove actions called `videoDetailController.saveCurrentChannelRule(...)` and `videoDetailController.removeCurrentChannelRule()`, which re-compute `currentChannelTarget` at execution time. If route/GetX state changes while the dialog is open, the wrong channel could be affected or the operation could silently no-op.

**Fix:** Added two explicit target-based methods to `VideoDetailController` in `lib/pages/video/controller.dart`:

1. **`saveChannelRule(ChannelQuietTarget target, {required bool hideComments, required bool hideDanmaku})`** — contains the full save/update logic (store lookup, update or add, `setChannelQuietRule`).
2. **`removeChannelRule(ChannelQuietTarget target)`** — contains the full delete logic (store delete, `setChannelQuietRule(null)`).

Existing convenience methods now delegate:

3. **`saveCurrentChannelRule(...)`** captures `currentChannelTarget` and delegates to `saveChannelRule(target, ...)`.
4. **`removeCurrentChannelRule()`** captures `currentChannelTarget` and delegates to `removeChannelRule(target)`.

**File:** `lib/pages/video/view.dart`

- Line 1299: `await videoDetailController.removeChannelRule(target)` (was `removeCurrentChannelRule()`)
- Lines 1306-1310: `await videoDetailController.saveChannelRule(target, hideComments: hideComments, hideDanmaku: hideDanmaku)` (was `saveCurrentChannelRule(...)`)

The dialog captures `ChannelQuietTarget target` and `ChannelQuietRule? existing` from the enclosing closure before the dialog opens, so the dialog always operates on the channel that was shown when the user tapped the menu item. The popup dialog deferral from the previous repair (`addPostFrameCallback` + mounted guard) is preserved.

---

## Files Changed

| File | Edit type | Line anchors |
|---|---|---|
| `test/features/channel_quiet/channel_quiet_target_test.dart` | Two `const` → `final` | Lines 100, 109 |
| `lib/pages/video/controller.dart` | Added `saveChannelRule`, `removeChannelRule`; delegate in existing methods | Lines 263-296 (new methods), 298-320 (delegates) |
| `lib/pages/video/view.dart` | Two call-site replacements in dialog actions | Lines 1299, 1306-1310 |

---

## Verification

`flutter test test/features/channel_quiet/channel_quiet_target_test.dart` could not be run because the Dart/Flutter SDK is not installed locally (exit code 127 from both `flutter` and `dart`). Verification must be done via GitHub Actions or by a developer with the SDK.

**Static checks passed:**
- `git diff --check` reports no whitespace errors (empty output = clean).
- All three modified files were read back to confirm correct syntax alignment.
- Type resolution: `ChannelQuietTarget` is exported from `channel_quiet.dart` barrel (confirmed via `grep`). Import already present in both `controller.dart` and `view.dart` from previous slice work.

---

## Risks and Unknowns

- **SDK unavailable locally:** The test file compile fix is a mechanical `const` → `final` change with no semantic impact. The controller and view changes follow the exact same API patterns used in the existing code. Both are low-risk, but cannot be confirmed green without SDK access or a CI run.
- **Existing uncommitted state:** The working tree contains uncommitted code from prior slices (e.g., `channel_quiet.dart` import, `currentChannelQuietRule`, `setChannelQuietRule`, `currentChannelTarget`, `_showChannelQuietEditor`, `quietControlPopupItems` changes). The Task-020 Slice 06 repairs sit on top of that state. If those prior slices are not present at review time, the compilation may fail for reasons unrelated to this slice's repairs.

---

## Status

This is **candidate evidence** for Codex review. It does **not** claim green, acceptance, merge, release, or closure of any gate.

- ❌ Automation/CI green
- ❌ Runtime smoke
- ❌ Technical-lead acceptance
- ❌ User/client acceptance
