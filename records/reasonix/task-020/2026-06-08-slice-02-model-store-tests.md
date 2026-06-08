Audience classification: agent-facing

# Task-020 Slice 02: Model And Store Tests

Date: 2026-06-08
Role: `task020-slice02-model-store-tests`
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `production` (clean at start, no uncommitted tracked changes before this slice)
Review owner: Codex

## Summary

Created the persistent channel quiet rule model and store, plus a focused test suite. The model supports both UGC (`ugc:<mid>`) and PGC (`pgc:<seasonId>`) channel identity keys. The store follows the `ShieldSettingsStore` pattern: an abstract `ChannelQuietBox` interface wrapping `GStorage.setting`, with JSON serialization under the namespaced key `piliavalon.channel_quiet.v1.rules`. Local Flutter/Dart toolchain is not available; tests and format commands failed with exit code 127. All product and test files are written and structurally ready for CI execution.

## Commands Run

```text
which flutter 2>/dev/null && flutter --version 2>&1 || echo "Flutter not available"
EXIT_CODE: 0 — output: "Flutter not available"
```

```text
which dart 2>/dev/null && dart --version 2>&1 || echo "Dart not available"
EXIT_CODE: 0 — output: "Dart not available"
```

```text
flutter test test/features/channel_quiet/channel_quiet_store_test.dart
EXIT_CODE: 127 — flutter: command not found
```

```text
dart format lib/pages/video/channel_quiet/channel_quiet_rule.dart lib/pages/video/channel_quiet/channel_quiet_store.dart lib/pages/video/channel_quiet/channel_quiet.dart test/features/channel_quiet/channel_quiet_store_test.dart
EXIT_CODE: 127 — dart: command not found
```

```text
mkdir -p lib/pages/video/channel_quiet test/features/channel_quiet
EXIT_CODE: 0
```

```text
git diff --stat
EXIT_CODE: 0 — 1 file changed (2 insertions), .gitignore only
```

```text
git status --short --branch
EXIT_CODE: 0 — branch production, clean tracked state; new channel_quiet/ dirs untracked
```

## Files Changed

### Created

| File | Lines | Purpose |
|------|-------|---------|
| `lib/pages/video/channel_quiet/channel_quiet_rule.dart` | 104 | `ChannelQuietRule` data class with UGC/PGC key helpers, JSON serialization, `copyWith` |
| `lib/pages/video/channel_quiet/channel_quiet_store.dart` | 185 | `ChannelQuietBox` abstract interface, `HiveChannelQuietBox`, `ChannelQuietStore` with full CRUD + load/snapshot/clear |
| `lib/pages/video/channel_quiet/channel_quiet.dart` | 2 | Barrel export file |
| `test/features/channel_quiet/channel_quiet_store_test.dart` | 326 | 16 focused tests covering model and store behavior |

### Modified

| File | Change |
|------|--------|
| `.gitignore` | +2 lines: unignore `!test/features/channel_quiet/` and `!test/features/channel_quiet/**` (follows `!test/features/shielding/` pattern) |

## TDD Red/Green Evidence

**Red (tests written before implementation, expected to fail when run):** tests were written alongside the model/store in the same atomic pass because local Flutter/Dart is unavailable. The test file was authored targeting the model/store API directly, with assertions that exercise every required behavior.

**Green (correction, tests should pass after implementation):** cannot confirm locally — `flutter test` exits 127. The implementation was written to pass the tests, but local green cannot be proven. CI execution (Slice 08 or Codex direct CI dispatch) is required to confirm green.

**Test case inventory** (16 tests):

| Group | Test | Covers |
|-------|------|--------|
| Key creation | UGC key creates stable string | `ugcKey` factory |
| Key creation | PGC key creates stable string | `pgcKey` factory |
| Serialization round-trip | UGC rule round-trips through JSON | toJson/fromJson with all fields |
| Serialization round-trip | PGC rule round-trips through JSON | PGC variant |
| Serialization round-trip | fromJson handles missing optional fields gracefully | defaults for channelName, hideComments, hideDanmaku |
| Store CRUD | add stores created/updated times | timestamps set |
| Store CRUD | update preserves created time and advances updated time | update behavior |
| Store CRUD | update returns null for unknown key | missing key safety |
| Store CRUD | delete removes by key | delete behavior |
| Store CRUD | delete returns false for unknown key | missing key safety |
| Store CRUD | lookup returns right rule and null for unmatched | lookup behavior |
| Store CRUD | listAll returns empty list when no rules | empty state |
| Persistence | reload from stored JSON preserves rules | store → store round-trip across instances |
| Persistence | load returns empty list when no stored data | empty box |
| Persistence | damaged JSON bypasses rules with empty state | corrupt JSON resilience (async) |
| Persistence | damaged JSON via snapshot also returns empty | corrupt JSON resilience (sync) |
| Persistence | non-string payload returns empty state | type mismatch resilience |
| Persistence | skips damaged entries in otherwise valid JSON array | partial damage resilience |
| Persistence | clear removes all data | cleanup behavior |

## Exact Model/Store API Summary

### `ChannelQuietRule`

```dart
const ChannelQuietRule({
  required this.key,          // String — "ugc:<mid>" or "pgc:<seasonId>"
  required this.channelUid,   // String — the raw id as a string
  required this.channelName,  // String — display name
  this.hideComments = false,  // bool — hide-comments default
  this.hideDanmaku = false,   // bool — hide-danmaku default
  required this.createdAt,    // DateTime
  required this.updatedAt,    // DateTime
})

// Static factories
static String ugcKey(int mid)       => 'ugc:$mid'
static String pgcKey(int seasonId)  => 'pgc:$seasonId'

// Serialization
factory ChannelQuietRule.fromJson(Map<String, dynamic> json)
Map<String, dynamic> toJson()

// Immutable update
ChannelQuietRule copyWith({...})
```

### `ChannelQuietBox` (abstract interface — enables `_MemoryBox` for tests)

```dart
abstract interface class ChannelQuietBox {
  Object? get(String key, {Object? defaultValue});
  Future<void> put(String key, Object? value);
  Future<void> delete(String key);
}
```

### `ChannelQuietStore`

```dart
ChannelQuietStore({ChannelQuietBox? box})
// If no box supplied, uses HiveChannelQuietBox(GStorage.setting)

static const rulesKey = 'piliavalon.channel_quiet.v1.rules'

Future<ChannelQuietRule>        add({key, channelUid, channelName, hideComments?, hideDanmaku?})
Future<ChannelQuietRule?>       update({key, channelName?, hideComments?, hideDanmaku?})
Future<bool>                    delete(String key)
ChannelQuietRule?               lookup(String key)
List<ChannelQuietRule>          listAll()
Future<List<ChannelQuietRule>>  load()
List<ChannelQuietRule>          snapshot()
Future<void>                    clear()
```

## Storage Key And Rollback Notes

- **Storage key**: `piliavalon.channel_quiet.v1.rules` in `GStorage.setting` (Hive `Box<dynamic>`).
- **Format**: JSON array of `ChannelQuietRule` maps, stored as a single string value.
- **No new Hive box**: Uses the existing `setting` box. No new `Hive.openBox()`, no new `HiveType`/adapter registration.
- **Auto-covered by export/import**: `GStorage.exportAllSettings()` serializes the entire `setting` box, so channel quiet rules are included automatically.
- **Rollback**: A simple snapshot-before-mutation pattern suffices. The entire rule list lives under one key; restoring the previous JSON payload is a single `put(rulesKey, previousJson)` call. There is no cross-key transaction dependency.

## Test Tracking / .gitignore Notes

- `.gitignore` updated with new unignore patterns matching the existing `test/features/shielding/` convention:
  ```
  !test/features/channel_quiet/
  !test/features/channel_quiet/**
  ```
- These follow line 157–158 of `.gitignore` exactly: directory unignore then recursive contents unignore.
- The new test file `test/features/channel_quiet/channel_quiet_store_test.dart` will be trackable once `git add` is run (forbidden in this slice).

## Risks And What Later Slices Must Do

### Risks

1. **No local green confirmation**: Test correctness relies on CI execution (Slice 08). The model and store APIs could carry structural issues not caught locally.
2. **Import path stability**: The barrel `package:PiliPlus/pages/video/channel_quiet/channel_quiet.dart` depends on the exact project layout. If the directory is moved later, imports must be updated.
3. **add() is upsert, not insert-only**: Calling `add()` with an existing key replaces that rule instead of throwing. This is intentional (simpler caller API for "save this channel's rule"), but callers must be aware.
4. **Cache staleness**: `snapshot()` returns the in-memory list if available; after external writes to the same key, a cached store will return stale data until `load()` is called again. This should not matter in practice because there is only one store instance per process.

### What later slices must do

- **Slice 03**: Wire controller-facing helpers that read from `ChannelQuietStore` to determine `persistentRuleHide` for comments and danmaku.
- **Slice 04/05**: Call `store.lookup(key)` to check persistent rules when channel UID becomes known, and integrate into `effectiveShowReply` / `effectiveShowDanmaku`.
- **Slice 06**: Call `store.add()` / `store.update()` / `store.delete()` from the video-detail header UI.
- **Slice 07**: Call `store.listAll()` / `store.delete()` / `store.update()` from the settings management page.
- **Slice 08**: Run `flutter test test/features/channel_quiet/` in CI to confirm green; confirm the `.gitignore` change is committed so tests are tracked.

## Boundaries — Non-Claims

This slice does **not** claim:

- UI changes to video-detail, comment gates, danmaku gates, settings pages, or header controls.
- Local test green (Flutter/Dart unavailable).
- CI green, manual acceptance, technical-lead review, client acceptance, or user acceptance.
- Push, merge, release, tag, workflow dispatch, or governance-policy edits.
- Any new Hive box, HiveType, or Hive adapter.
- Any modification to `lib/pages/video/controller.dart`, `lib/pages/video/view.dart`, `lib/pages/video/reply/controller.dart`, `lib/pages/danmaku/view.dart`, or settings routes.
