# Task-020 Slice 06: Video Detail Channel Quiet Rule Entry

**Audience classification:** agent-facing

**Date:** 2026-06-08

**role_id:** task-020-slice-06-video-detail-rule-entry-implementation-agent

**review_owner:** Codex

---

## Response Instructions Confirmation

Response instructions / 响应指令 were confirmed as enabled for this task.

---

## Summary

Implemented a persistent channel quiet rule entry in the video detail
more-menu (`PopupMenuButton`).  When the current channel identity is
known (UGC owner mid or PGC season id), the menu shows an "add channel
quiet" or "edit channel quiet" action.  Tapping it opens a `showDialog`
editor with two `SwitchListTile` widgets for hide-comments and
hide-danmaku defaults, plus Save / Remove / Cancel actions.

Persistence goes through `ChannelQuietStore`: new rules use `add()`;
existing rules use `update()` to preserve `createdAt`.  On save the
controller immediately calls `setChannelQuietRule(savedRule)`; on remove
it calls `setChannelQuietRule(null)`.  The effective visibility still
flows through the existing global hard gates (`showReply` /
`enableShowDanmaku`).

---

## Files Changed

| File | Change |
|---|---|
| `lib/pages/video/channel_quiet/channel_quiet_target.dart` | **new** — `ChannelQuietTarget` data class, `channelQuietActionLabel()`, `channelQuietEditorTitle()` |
| `lib/pages/video/channel_quiet/channel_quiet.dart` | added `export 'channel_quiet_target.dart'` |
| `lib/pages/video/controller.dart` | added `currentChannelTarget` getter, `saveCurrentChannelRule()`, `removeCurrentChannelRule()` |
| `lib/pages/video/view.dart` | added `import channel_quiet`, updated `quietControlPopupItems(BuildContext)`, added `_showChannelQuietEditor()` |
| `test/features/channel_quiet/channel_quiet_target_test.dart` | **new** — 16 pure Dart tests |

---

## Behavior Implemented

### 1. ChannelQuietTarget model (`lib/pages/video/channel_quiet/channel_quiet_target.dart`)

- `ChannelQuietTarget` — 3-field data class (`key`, `channelUid`, `channelName`)
  with `==`/`hashCode`/`toString`.
- `channelQuietActionLabel(ChannelQuietRule?)` → `'添加频道屏蔽'` or `'编辑频道屏蔽'`
- `channelQuietEditorTitle(ChannelQuietRule?)` → `'新增频道屏蔽'` or `'编辑频道屏蔽'`

### 2. Controller (`lib/pages/video/controller.dart`)

- **`currentChannelTarget`** getter (line ~220):
  - Returns `null` for local file sources.
  - For UGC: reads `UgcIntroController.videoDetail.value.owner?.mid` and
    `owner?.name`, builds `ChannelQuietTarget` with `ugcKey(mid)`.
  - For PGC: uses `seasonId` and `PgcIntroController.pgcItem.title`,
    builds `ChannelQuietTarget` with `pgcKey(seasonId)`.
  - Returns `null` silently when data is not yet available or
    `Get.find` fails.

- **`saveCurrentChannelRule({hideComments, hideDanmaku})`** (line ~248):
  - Guards on `currentChannelTarget != null`.
  - Looks up existing rule via `ChannelQuietStore().lookup(key)`.
  - Existing → `store.update()` (preserves `createdAt`).
  - New → `store.add()`.
  - Calls `setChannelQuietRule(saved)` immediately.

- **`removeCurrentChannelRule()`** (line ~277):
  - Guards on `currentChannelTarget != null`.
  - Calls `store.delete(key)`.
  - Calls `setChannelQuietRule(null)`.

### 3. View (`lib/pages/video/view.dart`)

- **`quietControlPopupItems(BuildContext context)`** (line ~1217):
  - Accepts a `BuildContext` parameter (was parameterless before).
  - Computes `videoDetailController.currentChannelTarget`.
  - When non-null, looks up existing rule and adds one `PopupMenuItem`
    with label from `channelQuietActionLabel(existing)` and
    `onTap` → `_showChannelQuietEditor(...)`.
  - When channel identity is unavailable, the entry is silently absent.

- **`_showChannelQuietEditor(BuildContext context, ChannelQuietTarget target, ChannelQuietRule? existing)`** (line ~1251):
  - Uses `showDialog` + `StatefulBuilder` + `AlertDialog`.
  - Shows channel name as `titleMedium` text.
  - Two `SwitchListTile` widgets: hideComments, hideDanmaku.
  - Three action buttons: Cancel, Remove (only when `existing != null`), Save.
  - Save calls `videoDetailController.saveCurrentChannelRule(...)`.
  - Remove calls `videoDetailController.removeCurrentChannelRule()`.

- **`_moreBtn`** call site updated to pass `context` (line ~1325).

---

## Tests Added

`test/features/channel_quiet/channel_quiet_target_test.dart` — 16 tests:

- **ChannelQuietTarget** (4 tests): UGC/PGC field correctness, equality,
  toString.
- **channelQuietActionLabel** (2 tests): null → add label, rule → edit label.
- **channelQuietEditorTitle** (2 tests): null → add title, rule → edit title.
- **ChannelQuietTarget key construction** (2 tests): ugcKey/pgcKey match.
- **save/update/remove persistence semantics** (6 tests):
  - add creates rule with fresh createdAt
  - update preserves createdAt and changes fields
  - delete removes rule from store
  - add for existing key acts as upsert
  - lookup returns null for missing target
  - (plus the verify-cached-state check inside the update test)

All tests are pure Dart using `_MemoryBox`; no Flutter widget test is
required in this slice because the editor dialog is a thin wrapper
around `SwitchListTile` + `TextButton` with no custom widget to test.

---

## Commands Run

| Command | Exit code | Notes |
|---|---|---|
| `which dart` | 1 | `dart` not available in environment |
| `which flutter` | 1 | `flutter` not available in environment |
| `git status --short --branch` | 0 | confirmed branch = production |
| `git diff --stat` | 0 | verified diff scope |
| `git diff -- lib/pages/video/controller.dart` | 0 | reviewed controller changes |
| `git diff -- lib/pages/video/view.dart` | 0 | reviewed view changes |

`dart test` and `dart analyze` were **not** run because the Dart/Flutter
SDK is not installed in the current environment.  The test file follows
the exact same `_MemoryBox` pattern used in the two existing test files
(`channel_quiet_store_test.dart`, `channel_matching_test.dart`) and
should pass once the SDK is available.

---

## Key Code Anchors

### Controller — currentChannelTarget (line ~220)

```dart
ChannelQuietTarget? get currentChannelTarget {
    if (isFileSource) return null;
    if (isUgc) {
      try {
        final ugcCtr = Get.find<UgcIntroController>(tag: heroTag);
        final detail = ugcCtr.videoDetail.value;
        final mid = detail.owner?.mid;
        if (mid == null) return null;
        return ChannelQuietTarget(
          key: ChannelQuietRule.ugcKey(mid),
          channelUid: mid.toString(),
          channelName: detail.owner?.name ?? '',
        );
      } catch (_) {
        return null;
      }
    } else {
      if (seasonId == null) return null;
      try {
        final pgcCtr = Get.find<PgcIntroController>(tag: heroTag);
        final title = pgcCtr.pgcItem.title;
        return ChannelQuietTarget(
          key: ChannelQuietRule.pgcKey(seasonId!),
          channelUid: seasonId.toString(),
          channelName: title ?? '',
        );
      } catch (_) {
        return null;
      }
    }
  }
```

### Menu entry — quietControlPopupItems (line ~1237)

```dart
    // Persistent channel quiet rule entry -- only when identity is known
    final target = videoDetailController.currentChannelTarget;
    if (target != null) {
      final existing = ChannelQuietStore().lookup(target.key);
      items.add(
        PopupMenuItem(
          onTap: () => _showChannelQuietEditor(context, target, existing),
          child: Text(channelQuietActionLabel(existing)),
        ),
      );
    }
```

### Test group — save/update/remove persistence semantics (test file line ~121)

Six tests covering:
- `add` creates with fresh createdAt and correct fields
- `update` preserves createdAt, advances updatedAt, changes fields
- `delete` removes from store, subsequent lookup returns null
- `add` for existing key acts as upsert (only one rule per key)
- `lookup` returns null for missing key
- cached state reflects update after `store.update`

---

## Verification Blocker

The local Dart/Flutter SDK is not installed.  `dart test` and
`dart analyze` could not be run.  The test code follows established
project conventions and uses the same `_MemoryBox` pattern as existing
tests.

---

## Governance Statement

This is **candidate evidence** for Codex review.  It does **not** claim
green, acceptance, merge, release, or parent closure.  No commits,
pushes, merges, releases, or workflow dispatches were performed.
