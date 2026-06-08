# Task-020 Slice 06 — Popup Dialog Deferral Repair

**Audience classification:** agent-facing

**Response instructions:** confirmed enabled for this task.

**role_id:** task-020-slice-06-popup-dialog-deferral-repair-agent
**target_repo:** CometDash77/PiliAvalon-Worksite
**review_owner:** Codex

---

## Finding

`lib/pages/video/view.dart` line 1241 (pre-fix) called `_showChannelQuietEditor(context, target, existing)` directly from `PopupMenuItem.onTap`. The `context` was the popup `itemBuilder` context, which can be invalidated or stale after the popup route dismisses. Opening a dialog synchronously during the popup dismiss transition can race the route removal.

## Repair applied

Wrapped the `_showChannelQuietEditor` call in `WidgetsBinding.instance.addPostFrameCallback` and switched to the stable page state `this.context`:

**File:** `lib/pages/video/view.dart`
**Line anchor:** 1241 (post-fix)

```diff
-          onTap: () => _showChannelQuietEditor(context, target, existing),
+          onTap: () => WidgetsBinding.instance.addPostFrameCallback((_) {
+            if (!mounted) return;
+            _showChannelQuietEditor(this.context, target, existing);
+          }),
```

### Rationale

- `addPostFrameCallback` defers execution until after the current frame completes — by then the popup menu route has been dismissed.
- `if (!mounted) return` guards against calling `showDialog` on a disposed state.
- `this.context` (the `_VideoDetailPageVState` context) is stable and valid for the page lifetime, unlike the popup `itemBuilder` context.
- No other behavior was changed. The `_showChannelQuietEditor` method and its callers are unaffected.

## Verification

| Check | Result |
|---|---|
| File edit applied | ✅ `git diff` shows exact targeted change |
| Format (`dart format`) | ⚠️ `dart`/`flutter` not in PATH — skipped |
| Static analysis (`dart analyze`) | ⚠️ `dart` not in PATH — skipped |
| Line grep `_showChannelQuietEditor` | Line 1243 (inside addPostFrameCallback) and line 1253 (method definition) — correct |
| Indentation consistency | ✅ 10-space `onTap:` on new block lines, matching surrounding widget tree |
| Import `WidgetsBinding` | ✅ Already available via `import 'package:flutter/material.dart'` (line 69) |

## Status

This is **candidate evidence** for Codex review. It does not claim green, acceptance, merge, release, or parent-closure. Codex must review and decide whether to promote the fix.

## SDK blocker note

`dart` and `flutter` CLI binaries are not available on `PATH` in this worksite environment. Static analysis and formatting could not be executed locally. A GitHub Actions verification run or a local environment with the full Flutter SDK is needed to confirm zero analysis warnings.

## Repository boundary

Only `lib/pages/video/view.dart` was touched. No import changes were needed (`WidgetsBinding` is re-exported by `package:flutter/material.dart`).
