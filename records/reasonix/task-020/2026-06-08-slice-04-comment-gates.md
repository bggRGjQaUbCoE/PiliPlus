Audience classification: agent-facing

# Task-020 Slice 04 Comment Gates

Date: 2026-06-08
Role: `task020-slice04-comment-gates`
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `production`
Review owner: Codex

## Command Log

```text
pwd && git status --short --branch
exit code: 0
result: branch production; .gitignore, controller.dart, pgc/controller.dart,
 ugc/controller.dart, quiet_state.dart, quiet_state_test.dart modified;
 channel_quiet/ and test/features/channel_quiet/ untracked (from Slice 02)
```

```text
git diff --check
exit code: 0
result: no whitespace errors
```

```text
dart format <changed files>
exit code: 127
result: dart unavailable locally (matches Slice 02/03 evidence)
```

```text
flutter test test/features/channel_quiet/channel_matching_test.dart
exit code: 127
result: flutter unavailable locally
```

## Files Changed (This Slice)

### Product files

- `lib/pages/video/introduction/ugc/controller.dart` — added `_matchChannelQuietRule(mid, name)` private method + imports; called after `videoDetail.value = response` (line ~122) when `owner.mid` and `owner.name` are available from the video intro HTTP response
- `lib/pages/video/introduction/pgc/controller.dart` — added `_matchChannelQuietRule()` private method + imports; called after `super.onInit()` in `onInit()` when `seasonId` and `pgcItem.title` are available from route args

No changes to: `lib/pages/video/controller.dart`, `lib/pages/video/view.dart`, `lib/pages/video/reply/controller.dart`, `lib/pages/video/reply/view.dart`, `lib/pages/video/quiet_state.dart`, `lib/pages/danmaku/`, `lib/pages/setting/`, `lib/pages/video/channel_quiet/` (model/store from Slice 02 unchanged).

### Test files

- `test/pages/video/quiet_state_test.dart` — added 4 tests in `comment gate: persistent hideComments hides reply` group
- `test/features/channel_quiet/channel_matching_test.dart` — new file, 6 tests covering UGC/PGC key lookup, null mid, hideComments vs hideDanmaku, and null match behavior

### .gitignore

Already covers `test/features/channel_quiet/**` from Slice 02 — no .gitignore edit needed this slice.

## TDD Evidence

### Test file: `test/pages/video/quiet_state_test.dart`

Added `comment gate: persistent hideComments hides reply` group (4 tests):

| Test | Expected |
|------|----------|
| hidden when channel rule hideComments is true | `effectiveShowContent(global: true, persistent: true, temp: false)` → false |
| visible when channel rule only has hideDanmaku | `effectiveShowContent(global: true, persistent: false, temp: false)` → true |
| visible when no channel rule matches | same → true |
| hard gate: global off overrides everything | `global: false` + any combination → false |

These tests validate that:
- `effectiveShowReply` is false when a matched rule has `hideComments == true`
- `effectiveShowReply` is true when a matched rule only has `hideDanmaku == true`
- The global hard gate is preserved

### Test file: `test/features/channel_quiet/channel_matching_test.dart`

6 tests covering the matching-to-comment-gate pipeline:

| Test | Expected |
|------|----------|
| UGC owner mid maps to `ugc:<mid>` lookup key | `store.lookup(ChannelQuietRule.ugcKey(mid))` returns rule with name |
| missing UGC owner mid produces null lookup | lookup returns null |
| PGC season id maps to `pgc:<seasonId>` lookup key | lookup returns rule with title |
| matched hideComments true → persistentRuleHideReply true | `rule?.hideComments ?? false` → true |
| hideDanmaku-only rule → persistentRuleHideReply false | `rule?.hideComments ?? false` → false |
| null match → persistentRuleHideReply false | `rule?.hideComments ?? false` → false |

Tests use `_MemoryBox` (in-memory `ChannelQuietBox`) avoiding Hive initialization dependency.

### Full controller test limitation

Full controller tests that verify `videoDetailCtr.setChannelQuietRule(...)` is called after UGC/PGC intro would require GetX and Flutter initialization (`Get.put`, `Get.find`, `Rx` reactive chains). These are not practical as pure tests. The integration risk is recorded below.

## Channel Lookup Timing

### UGC (`UgcIntroController.queryVideoIntro()`)

```text
lib/pages/video/introduction/ugc/controller.dart:121-122
```

`_matchChannelQuietRule(response.owner?.mid, response.owner?.name)` is called immediately after `videoDetail.value = response`. At this point:

- `response.owner?.mid` contains the channel UID (int?)
- `response.owner?.name` contains the channel display name (String?)
- The `videoDetailCtr` reference is available (inherited from `CommonIntroController`)

When `mid` is null (e.g., deleted account, edge case), the method returns without calling `setChannelQuietRule`, leaving `currentChannelQuietRule` at its previous value (which `onReset()` clears to null on video switch).

### PGC (`PgcIntroController.onInit()`)

```text
lib/pages/video/introduction/pgc/controller.dart:68-69
```

`_matchChannelQuietRule()` is called after `super.onInit()`. At this point:

- `seasonId` is available from `Get.arguments['seasonId']`
- `pgcItem.title` is available from `Get.arguments['pgcItem']`
- PGC's `queryVideoIntro()` has already run (called from `CommonIntroController.onInit()` line 83), so `videoDetail.value.title` is set

When `seasonId` is null, the method returns without calling `setChannelQuietRule`.

### Re-match on video/page switch

- `VideoDetailController.onReset()` at `controller.dart:1369` clears `currentChannelQuietRule.value = null`
- When a new video (new cid) is loaded within the same detail page, `UgcIntroController.queryVideoIntro()` fires again, re-matching the rule
- For PGC, episode switches within the same season call `queryVideoIntro(episode)` at `pgc/controller.dart:309` — since `seasonId` doesn't change, the rule remains the same (idempotent lookup)

## Comment Gate Behavior After Edits

### How the existing gate chain activates

Once `videoDetailCtr.setChannelQuietRule(rule)` is called with a matching rule that has `hideComments == true`:

1. `VideoDetailController.currentChannelQuietRule` (line 167-168) is set to the matched rule
2. `persistentRuleHideReply` (line 170-171) derives `currentChannelQuietRule.value?.hideComments ?? false` → `true`
3. `effectiveShowReply` (line 175-179) computes `effectiveShowContent(globalShow: showReply, persistentRuleHide: true, temporaryHide: tempHideReply.value)` → `false` (unless global is also off)
4. `VideoReplyController.customGetData()` (reply/controller.dart:35) checks `!videoCtr.effectiveShowReply` → returns empty `MainListReply` — **blocks all comment network requests** (refresh, pagination, sort, reload)
5. `VideoReplyPanel.initState()` (reply/view.dart:52-53) checks `effectiveShowReply` before calling `queryData()` — blocks initial comment load when panel activates
6. `buildTabBar()` in `view.dart:1386` checks `videoDetailController.effectiveShowReply` → comments tab is NOT included in tabs list → comment panel is hidden
7. `quietControlsEffectiveTabIndex` (view.dart:1398) handles tab index adjustment when the reply tab appears/disappears

### Global hard gate preserved

`showReply` is the outer AND in `effectiveShowReply`. If `showReply` is false (file source or global setting off), `effectiveShowReply` is always false regardless of channel rule or temporary state. A channel rule with `hideComments == true` cannot make comments visible if `showReply` is already false.

### Temporary controls preserved

`tempHideReply` continues to work as before. The three-level precedence (`effectiveShowContent: globalShow && !persistentRuleHide && !temporaryHide`) ensures that toggling `tempHideReply` on/off works alongside the persistent channel rule.

### Initial VideoReplyController creation — NOT prevented

As established in Slice 01 and confirmed by Codex review:

```text
lib/pages/video/view.dart:150 — if (videoDetailController.showReply)
```

The `VideoReplyController` is still created synchronously in `initState()` using `showReply` (global only). Channel identity is not yet available at that point. The `VideoReplyController` WILL be created even if a channel rule would hide comments — but it will be kept idle by `customGetData()` returning empty results and the comment tab hiding.

This is the architectural constraint recorded in Slice 01 §10 Constraint 1. The practical prevention layer is `customGetData()` + tab hiding after channel UID is known.

## Risks And Later-Slice Dependencies

1. **No local Dart/Flutter**: Tests and formatting not locally verified. Slice 08 or remote CI must prove status.

2. **Channel UID race with tab switch**: If the user switches to the comments tab before the video intro HTTP response completes, the tab will initially show (global check passes), then potentially hide when the response arrives with a matching hide rule. The `buildTabBar` already handles tab index adjustment via `quietControlsEffectiveTabIndex`. There could be a brief flash of the comments tab before the rule match causes it to disappear. This is the same class of race as temporary controls and is acceptable for Slice 04.

3. **`ChannelQuietStore` re-instantiation**: Each `_matchChannelQuietRule` call creates a new `ChannelQuietStore()` instance wrapping `GStorage.setting`. This follows the existing `ShieldSettingsStore()` pattern used throughout the codebase (new instance per call). The store is lightweight — just a wrapper around the Hive box. Overhead is negligible.

4. **`GStorage.setting` availability**: Both UGC and PGC lookup assume `GStorage.setting` Hive box is open. At the time `UgcIntroController.queryVideoIntro()` returns (async HTTP response), the app is fully initialized, so the box should be open. The `try/catch` in both `_matchChannelQuietRule` methods catches any Hive errors and falls back to null rule match.

5. **PGC comments in scope**: PGC comment gating is implemented in this slice. The `PgcIntroController` matches rules by `pgc:<seasonId>` key and applies them to `videoDetailCtr`. The existing `VideoReplyController.customGetData()` and `buildTabBar` already work for PGC videos (they check `effectiveShowReply` generically). No additional PGC-specific comment gate code is needed.

6. **`name` parameter unused in UGC matching**: The `_matchChannelQuietRule(mid, name)` method receives `name` but doesn't currently use it for anything beyond the lookup itself. The `ChannelQuietStore` uses `key` (`ugc:<mid>`) for lookup, not name. The `name` parameter is plumbed in case future slices need it for creating new rules from the video-detail UI.

7. **No reply/controller changes needed**: The existing `VideoReplyController.customGetData()` at `reply/controller.dart:35` already gates on `videoCtr.effectiveShowReply`, which is already three-level-aware from Slice 03. No edits to `reply/controller.dart` or `reply/view.dart` were needed in this slice.

## Boundaries

- This slice does not claim format/analyze/test green (local tools unavailable).
- This slice does not claim CI green, remote verification, or user acceptance.
- This slice does not modify danmaku view/controller (Slice 05 scope).
- This slice does not add video-detail rule action UI (Slice 06 scope).
- This slice does not add settings-page management UI (Slice 07 scope).
- This slice does not push, merge, tag, release, or close any gate.
- Initial `VideoReplyController` creation is still not prevented in current architecture — the controller is created before channel identity is available. The practical gate is `customGetData()` + tab hiding once the rule is effective.

## Explicit Statement

**Initial `VideoReplyController` creation is still not prevented in the current architecture.** The controller is created synchronously in `initState()` at `view.dart:150-158` based on `showReply` (global only). Channel identity arrives later, after an async HTTP response. The `VideoReplyController` will be created even when a persistent channel rule would hide comments. However, once the channel identity is known and `setChannelQuietRule()` is called, the controller is effectively kept idle:

- `customGetData()` returns empty results (no network requests)
- The comments tab is hidden from the tab bar
- `VideoReplyPanel.initState()` skips `queryData()` because `effectiveShowReply` is false
