Audience classification: agent-facing

# Task-020 Slice 01 Stage A Fact-Check

Date: 2026-06-08
Role: `task020-slice01-stage-a-fact-check`
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `production`
Review owner: Codex

## Command Log

```text
pwd && git status --short --branch
exit code: 0
result: /home/mo/Documents/piliavalon, branch production, clean (no uncommitted changes shown)
```

```text
git ls-files test/
exit code: 0
result: 13 tracked test files (listed below in §9)
```

```text
find test -name "*.dart" -type f 2>/dev/null | head -40
exit code: 0
result: 13 dart test files on disk; all 13 are git-tracked
```

## Source Records Read

- `/home/mo/Documents/obsidian/VIBECODING项目/Piliavalon/records/worksite-communications/2026-06-08-task020-persistent-channel-quiet-to-worksite.md`
- `records/codex/implementation/2026-06-08-task-039-quiet-controls-implementation.md`
- `records/codex/verification/2026-06-08-task039-ci-success-review.md`
- `records/codex/implementation/2026-06-08-task-020-atomic-reasonix-plan.md`
- `.reasonix/skills/worksite-reasonix-harness.md`
- `.reasonix/skills/flutter-official-skill-router.md`
- `.agents/skills/dart-add-unit-test/SKILL.md`
- `.agents/skills/flutter-add-widget-test/SKILL.md`
- `.agents/skills/dart-run-static-analysis/SKILL.md`

## §1 — Channel UID and Channel Name Source

### UGC videos

Channel UID = `owner.mid` (int?), channel name = `owner.name` (String?).

Source: `lib/models_new/video/video_detail/data.dart:25` — `Owner? owner;`

Model: `lib/models/model_owner.dart:7-33` — `class Owner` with `@HiveType(typeId: 3)`, fields `mid` (HiveField 0), `name` (HiveField 1), `face` (HiveField 2).

Populated by: `lib/pages/video/introduction/ugc/controller.dart:119`

```dart
videoDetail.value = response;  // response is VideoDetailData from VideoHttp.videoIntro()
```

The HTTP request `VideoHttp.videoIntro(bvid: bvid)` fires at `ugc/controller.dart:94`.
After the response, the owner is accessible via:

```dart
Get.find<UgcIntroController>(tag: heroTag).videoDetail.value.owner?.mid
Get.find<UgcIntroController>(tag: heroTag).videoDetail.value.owner?.name
```

Usage references in ugc intro controller:
- `ugc/controller.dart:160`: `final mid = videoDetail.value.owner?.mid;`
- `ugc/controller.dart:344`: `videoDetail.owner!.name!`
- `ugc/controller.dart:366`: `videoDetail.owner?.name`
- `ugc/controller.dart:388-389`: `videoDetail.owner!.name!`, `videoDetail.owner!.mid!.toString()`
- `ugc/controller.dart:409`: `videoDetail.owner!.mid!`
- `ugc/controller.dart:426`: `videoDetail.owner?.mid`
- `ugc/controller.dart:547`: `videoDetail.owner?.name`
- `ugc/controller.dart:788`: `videoDetail.value.owner?.mid`

### PGC (bangumi) videos

PGC videos do NOT use an `Owner` model. The `PgcIntroController` at `lib/pages/video/introduction/pgc/controller.dart` uses `pgcItem` (a `PgcInfoModel`). No `owner.mid` is present. Channel identity for PGC is `seasonId` (`pgcItem.seasonId`), with title from `pgcItem.title`.

This means channel-level persistent rules for PGC must be keyed by `seasonId` rather than `owner.mid`. A single "channel quiet rule" data model must support both int-based keys: `mid` (for UGC) and `seasonId` (for PGC). Implementation must either unify on a string key or use a discriminated union.

## §2 — Channel UID Timing Relative to VideoReplyController

### VideoReplyController creation timing

`lib/pages/video/view.dart:140-159` (initState):

```dart
videoDetailController = Get.put(VideoDetailController(), tag: heroTag);  // line 144

if (videoDetailController.showReply) {                                     // line 150
    _videoReplyController = Get.put(                                       // line 151
        VideoReplyController(                                              // line 152
            aid: videoDetailController.aid,                                // line 153
            videoType: videoDetailController.videoType,                    // line 154
            heroTag: heroTag,                                              // line 155
        ),
        tag: heroTag,                                                      // line 157
    );
}
```

`VideoReplyController` is created synchronously in `initState`. At this point:
- `VideoDetailController.onInit()` may not have completed yet
- `queryVideoUrl()` has NOT been called (that happens at `view.dart:176` in `videoSourceInit()`)
- `UgcIntroController.queryVideoIntro()` has NOT fired — the HTTP request carrying `owner` data has not even started

**Conclusion: channel UID is NOT available before `VideoReplyController` creation.** The guard at `view.dart:150` checks only `showReply` (a global setting), not channel UID. Pre-creation channel-rule blocking is impossible for the initial page load.

### VideoReplyController request-gate path

`lib/pages/video/reply/controller.dart:34-48` — all requests route through `customGetData()`:

```dart
Future<LoadingState<MainListReply>> customGetData() async {
    if (!videoCtr.effectiveShowReply) {                                    // line 35
        return Success(MainListReply(                                      // line 36
            cursor: CursorReply(isEnd: true),                              // line 37
            subjectControl: SubjectControl(count: Int64(0)),               // line 38
        ));
    }
    return ReplyGrpc.mainList(...);                                        // line 41-47
}
```

`effectiveShowReply` at `lib/pages/video/controller.dart:163-166`:

```dart
bool get effectiveShowReply => effectiveShowTemporaryContent(
    globalShow: showReply,
    temporaryHide: tempHideReply.value,
);
```

Currently only accounts for `showReply` (global) and `tempHideReply` (temporary). No channel-rule check. But the gate exists and can be extended.

### Post-UID-arrival prevention possibility

After the video-info HTTP response arrives, the channel UID becomes known. At that point, a persistent rule match can:
- Block all future `customGetData()` calls by extending `effectiveShowReply` to include channel-rule check
- This blocks refresh, pagination, sort, and reload (all route through `customGetData`)
- `VideoReplyPanel.initState()` at `reply/view.dart:52-54` also checks `effectiveShowReply` before calling `queryData()`

## §3 — Channel UID Timing Relative to PlDanmaku

### PlDanmaku instantiation

`lib/pages/video/view.dart:1318-1328` — `PlDanmaku` is created in the widget tree via `Obx()` builder:

```dart
Obx(
    () => PlDanmaku(
        key: ValueKey(videoDetailController.cid.value),
        ...
        videoDetailController: videoDetailController,
        ...
    ),
),
```

The `Obx` builder runs during `build()`, which is after `initState()` completes. However, the widget tree is built synchronously in the first frame — before the async video-info HTTP response.

`PlDanmaku.initState()` at `lib/pages/danmaku/view.dart:53-74`:

```dart
void initState() {
    super.initState();
    _plDanmakuController = PlDanmakuController(
        widget.cid, playerController, widget.isFileSource,
    );
    if (effectiveShowDanmaku) {                                            // line 60
        if (widget.isFileSource) {
            _plDanmakuController.initFileDmIfNeeded();
        } else {
            _plDanmakuController.queryDanmaku(
                PlDanmakuController.calcSegment(
                    playerController.position.inMilliseconds,
                ),
            );
        }
    }
    ...
}
```

`effectiveShowDanmaku` at `danmaku/view.dart:44-46`:

```dart
bool get effectiveShowDanmaku =>
    widget.videoDetailController?.effectiveShowDanmaku ??
    playerController.enableShowDanmaku.value;
```

This delegates to `VideoDetailController.effectiveShowDanmaku` at `controller.dart:168-171`:

```dart
bool get effectiveShowDanmaku => effectiveShowTemporaryContent(
    globalShow: plPlayerController.enableShowDanmaku.value,
    temporaryHide: tempHideDanmaku.value,
);
```

**Conclusion: channel UID is NOT available before `PlDanmaku.initState()` runs.** The first danmaku segment request at `danmaku/view.dart:64-68` fires before channel UID arrives. Pre-init danmaku prevention via channel rule is impossible.

### Post-UID-arrival danmaku gates

After the channel UID is known and a persistent rule matches:
- `videPositionListen()` at `danmaku/view.dart:99-101` returns before `getCurrentDanmaku()` if `!effectiveShowDanmaku` — this blocks all subsequent lazy segment requests
- Render opacity at `danmaku/view.dart:180-184` becomes 0 if `!effectiveShowDanmaku` — hides visible danmaku
- `toggleTempHideDanmaku()` already clears danmaku at `controller.dart:181-183` (`plPlayerController.danmakuController?.clear()`) — same pattern can be reused when a persistent rule becomes effective

## §4 — Settings-Page Entry Patterns and Route Conventions

### Settings type enum

`lib/models/common/setting_type.dart:1-15`:

```dart
enum SettingType {
  privacySetting('隐私设置'),
  shieldingSetting('屏蔽规则'),
  recommendSetting('推荐流设置'),
  videoSetting('音视频设置'),
  playSetting('播放器设置'),
  styleSetting('外观设置'),
  extraSetting('其它设置'),
  webdavSetting('WebDAV 设置'),
  about('关于'),
}
```

### Settings main page entry pattern

`lib/pages/setting/view.dart:48-92` — `_SettingsModel` list with type, subtitle, icon:

```dart
static const List<_SettingsModel> _items = [
    _SettingsModel(type: SettingType.privacySetting, subtitle: '黑名单、无痕模式', ...),
    _SettingsModel(type: SettingType.shieldingSetting, subtitle: '全局开关、推荐/评论场景、规则列表', ...),
    ...
];
```

Each entry renders a `ListTile` with `onTap: () => _toPage(item.type)`.

Navigation: `lib/pages/setting/view.dart:158-165`:

```dart
void _toPage(SettingType type) {
    if (_isPortrait) {
        Get.toNamed('/${type.name}');  // e.g. '/shieldingSetting'
    } else {
        _type = type; setState(() {});  // side-by-side on tablet
    }
}
```

### Route registration

`lib/router/app_pages.dart:84-207` — `GetPage` instances for all routes:

```dart
GetPage(name: '/setting', page: () => const SettingPage()),
GetPage(name: '/shieldingSetting', page: () => ...),
```

Accessing settings from elsewhere: `Get.toNamed('/setting', preventDuplicates: false)` at `lib/pages/mine/view.dart:215`.

### Closest analogous sub-page: ShieldingSettingsPage

`lib/pages/shielding_settings/view.dart` — a full management page with:
- AppBar with add (+) button
- ListView of rules with toggle and delete
- Uses `ShieldSettingsStore` for persistence
- Route: `GetPage(name: '/shieldingSetting'...)` not in main routes but embedded in settings

### What a new channel quiet settings entry requires:
1. Add `channelQuietSetting('频道静音')` to `SettingType` enum
2. Add `_SettingsModel` entry to `_items` list in `setting/view.dart`
3. Add route `GetPage(name: '/channelQuietSetting', page: () => const ChannelQuietSettingsPage())`
4. Implement the page itself under `lib/pages/setting/pages/` or `lib/pages/channel_quiet/`

## §5 — Local Storage/Database Choices

### Storage technology

`hive_ce` (Hive Community Edition) — `lib/utils/storage.dart:15`: `import 'package:hive_ce/hive.dart';`

### Box inventory

`lib/utils/storage.dart:18-25`:

| Box name | Type | Purpose |
|----------|------|---------|
| `userInfo` | `Box<UserInfoData>` | Login user info |
| `historyWord` | `Box<dynamic>` | Search history |
| `localCache` | `Box<dynamic>` | Local cache |
| `setting` | `Box<dynamic>` | Global settings (key-value) |
| `video` | `Box<dynamic>` | Video-related settings |
| `watchProgress` | `Box<int>` | Watch progress (keyed by cid) |
| `reply` | `Box<Uint8List>`? | Saved replies (optional) |

### Box initialization

`lib/utils/storage.dart:27-78` — `GStorage.init()` opens all boxes with `Hive.openBox()`, some with compaction strategies.

### Adapter registration

`lib/utils/storage.dart:99-108` — registered adapters: `OwnerAdapter`, `UserInfoDataAdapter`, `LevelInfoAdapter`, `BiliCookieJarAdapter`, `LoginAccountAdapter`, `AccountTypeAdapter`, `SetIntAdapter`, `RuleFilterAdapter`.

New models requiring `@HiveType` must register their adapter before box access.

### Key-value storage pattern (used by ShieldSettingsStore)

`lib/features/shielding/shielding_store.dart:33-379`:
- Wraps `GStorage.setting` via `HiveShieldSettingsBox`
- Namespaced keys: `piliavalon.shielding.v1.rules`, `piliavalon.shielding.v1.global_enabled`, etc.
- Complex data serialized as JSON strings: `_box.put(rulesKey, jsonEncode(resolved.toJson()))`
- `snapshot()` for sync read, `load()` for async read with JSON parse, `save()` for atomic write
- No separate Hive box needed — uses the shared `setting` box with namespaced keys
- No separate `HiveType`/adapter needed when storing JSON strings

### Export/import

`lib/utils/storage.dart:80-97`:
- `exportAllSettings()` serializes `setting` and `video` boxes to JSON
- `importAllSettings()` deserializes and puts back
- Export/import does NOT cover `watchProgress` or `reply` boxes
- Any channel quiet data in `setting` box would be automatically included in export/import

### Compact/close/clear

`lib/utils/storage.dart:111-148` — batch methods for all boxes. Channel quiet data in `setting` box is automatically covered.

### Rollback pattern

No built-in transaction/rollback. ShieldSettingsStore writes are atomic per-key but not cross-key transactional. Rollback requires manual `put()` of previous value or `delete()` + re-save. For channel quiet rules, store a snapshot before mutation for manual rollback.

## §6 — Task-039 Temporary Effective-State Integration Points

### Controller state (`lib/pages/video/controller.dart:154-189`)

```dart
bool get showReply => isFileSource ? false : isUgc
    ? plPlayerController.showVideoReply : plPlayerController.showBangumiReply;

final RxBool tempHideReply = false.obs;
final RxBool tempHideDanmaku = false.obs;

bool get effectiveShowReply => effectiveShowTemporaryContent(
    globalShow: showReply, temporaryHide: tempHideReply.value);

bool get effectiveShowDanmaku => effectiveShowTemporaryContent(
    globalShow: plPlayerController.enableShowDanmaku.value,
    temporaryHide: tempHideDanmaku.value);

void toggleTempHideReply() { if (!showReply) return; tempHideReply.toggle(); }
void toggleTempHideDanmaku() {
    if (!plPlayerController.enableShowDanmaku.value) return;
    tempHideDanmaku.toggle();
    if (tempHideDanmaku.value) { plPlayerController.danmakuController?.clear(); }
}
void resetTempQuietControls() { tempHideReply.value = false; tempHideDanmaku.value = false; }
```

### Comment integration points

1. `lib/pages/video/view.dart:150` — `VideoReplyController` creation gate: `if (videoDetailController.showReply)` (global only, no temp)
2. `lib/pages/video/reply/controller.dart:35` — `customGetData()` gate: `if (!videoCtr.effectiveShowReply)` (global + temp)
3. `lib/pages/video/reply/view.dart:52-54` — init load gate: `if (...&& _videoReplyController.videoCtr.effectiveShowReply) { queryData(); }`
4. `lib/pages/video/view.dart` tab rendering — uses `effectiveShowReply` for tab visibility

### Danmaku integration points

1. `lib/pages/danmaku/view.dart:60` — init load gate: `if (effectiveShowDanmaku) { ...queryDanmaku(...); }`
2. `lib/pages/danmaku/view.dart:100` — position listener gate: `if (_controller == null || !effectiveShowDanmaku) return;`
3. `lib/pages/danmaku/view.dart:182` — render opacity: `opacity: effectiveShowDanmaku ? ... : 0`
4. `lib/plugin/pl_player/view/view.dart:1423-1428` — tap-danmaku action hidden when `!effectiveShowDanmaku`
5. `lib/pages/video/controller.dart:182` — danmaku clear on toggle: `plPlayerController.danmakuController?.clear()`

### No persistence in Task-039

Confirmed by Codex diff audit: no `setting.put`, `GStorage.setting`, `Hive`, `migration`, `channel UID`, `ShieldRuleType.uid`, or database writes in Task-039 product diff.

## §7 — Comment Controller Request Gates

### Current gate architecture

All comment data requests go through a single path:

1. `VideoReplyPanel.initState()` at `reply/view.dart:51-55`:
   ```dart
   _videoReplyController = Get.find<VideoReplyController>(tag: heroTag);
   if (_videoReplyController.loadingState.value is Loading &&
       _videoReplyController.videoCtr.effectiveShowReply) {
       _videoReplyController.queryData();
   }
   ```

2. `queryData()` → `customGetData()` at `reply/controller.dart:34-48`:
   ```dart
   Future<LoadingState<MainListReply>> customGetData() async {
       if (!videoCtr.effectiveShowReply) {
           return Success(MainListReply(
               cursor: CursorReply(isEnd: true),
               subjectControl: SubjectControl(count: Int64(0)),
           ));
       }
       return ReplyGrpc.mainList(oid: ..., type: ..., mode: mode, cursorNext: cursorNext, ...);
   }
   ```

### Request types gated

Since `customGetData()` is the `ReplyController` base method, the following all flow through it:
- Initial query (`queryData()`)
- Refresh (pull-to-refresh triggers `queryData()`)
- Pagination (scroll-to-bottom triggers `queryData()` with cursor)
- Sort changes (changing sort mode triggers reload via `queryData()`)
- Reload (explicit reload triggers `queryData()`)

**Gate coverage: complete.** If `effectiveShowReply` is false, no `ReplyGrpc.mainList()` request reaches the network.

### Current gate checks only global + temporary

```dart
effectiveShowReply = showReply && !tempHideReply.value
```

No channel rule awareness. Extending this to `showReply && !tempHideReply.value && !channelRuleHidesReply` is the integration point.

### VideoReplyController creation gate

`view.dart:150`: `if (videoDetailController.showReply)` — still global-only. Even with channel rule integration, `VideoReplyController` will be created before channel UID arrives. This is NOT avoidable for the initial page load. The `customGetData()` gate is the practical prevention layer.

## §8 — Danmaku Init/Request/Render Gates

### Init gate

`lib/pages/danmaku/view.dart:60-69`:

```dart
if (effectiveShowDanmaku) {
    if (widget.isFileSource) {
        _plDanmakuController.initFileDmIfNeeded();
    } else {
        _plDanmakuController.queryDanmaku(
            PlDanmakuController.calcSegment(playerController.position.inMilliseconds),
        );
    }
}
```

`effectiveShowDanmaku` at `danmaku/view.dart:44-46` delegates to `widget.videoDetailController?.effectiveShowDanmaku`.

### Request gate (position listener)

`lib/pages/danmaku/view.dart:99-101`:

```dart
void videoPositionListen(Duration position) {
    if (_controller == null || !effectiveShowDanmaku) { return; }
    ...
    List<DanmakuElem>? currentDanmakuList = _plDanmakuController.getCurrentDanmaku(currentPosition);
```

All lazy segment requests are gated. If `effectiveShowDanmaku` is false, `getCurrentDanmaku()` never runs.

### Render gate

`lib/pages/danmaku/view.dart:180-184`:

```dart
AnimatedOpacity(
    opacity: effectiveShowDanmaku ? playerController.danmakuOpacity.value : 0,
    ...
)
```

### Clear gate

`lib/pages/video/controller.dart:182`: `plPlayerController.danmakuController?.clear()` on temp hide toggle. Same clear call can be used when a persistent rule match is detected.

### Tap-danmaku UI gate

`lib/plugin/pl_player/view/view.dart:1423-1428` — tap action hidden when `!effectiveShowDanmaku`.

## §9 — Test Locations Not Ignored by .gitignore

### .gitignore test rules

`/home/mo/Documents/piliavalon/.gitignore:150-166`:

```gitignore
!test/
test/*
!test/bootstrap/
test/bootstrap/*
!test/bootstrap/bootstrap_app_test.dart
!test/features/
test/features/*
!test/features/shielding/
!test/features/shielding/**
!test/pages/
test/pages/*
!test/pages/setting/
test/pages/setting/*
!test/pages/setting/models/
test/pages/setting/models/*
!test/pages/setting/models/shielding_settings_test.dart
!test/pages/setting/models/recommend_settings_test.dart
```

### Git-tracked test files (13 total)

```text
test/android_release_signing_test.dart
test/bootstrap/bootstrap_app_test.dart
test/features/shielding/comment_reply_controller_test.dart
test/features/shielding/shielding_adapters_test.dart
test/features/shielding/shielding_core_test.dart
test/features/shielding/shielding_migration_test.dart
test/features/shielding/shielding_recommend_tag_enricher_test.dart
test/features/shielding/shielding_store_test.dart
test/features/shielding/video_card_shield_quick_action_test.dart
test/pages/setting/models/legacy_shielding_entries_test.dart
test/pages/setting/models/recommend_settings_test.dart
test/pages/setting/models/shielding_settings_test.dart
test/pages/video/quiet_state_test.dart
```

### Where to add new tests

- **Feature tests** (channel quiet store/model): `test/features/channel_quiet/` — needs `.gitignore` update: `!test/features/channel_quiet/` + `!test/features/channel_quiet/**` (following the shielding pattern)
- **Settings model tests**: `test/pages/setting/models/` — needs `.gitignore` update to unignore the specific new test file(s)
- Note: `test/pages/video/quiet_state_test.dart` IS git-tracked (not ignored). The existing `test/pages/*` exclusions have been overridden by `!test/pages/` + selective unignores; `quiet_state_test.dart` is at a depth that the .gitignore rules pass through. Wait — actually checking: `test/pages/*` ignores everything in test/pages, but `!test/pages/` unignores the directory. `test/pages/video/quiet_state_test.dart` is under `test/pages/video/` which is a subdirectory of `test/pages/`. Since `test/pages/*` only matches top-level entries in test/pages, `test/pages/video/` (a directory) may or may not be matched... Let me recheck: `test/pages/*` with git semantics matches all files and dirs immediately inside test/pages, so `test/pages/video/` IS ignored. BUT `git ls-files` shows `test/pages/video/quiet_state_test.dart` IS tracked. This means it was added before the ignore rules or the rules have an exception we missed. Regardless — `git ls-files` output is authoritative.

### .gitignore update needed for Task-020 tests

For channel quiet feature tests, add:
```gitignore
!test/features/channel_quiet/
!test/features/channel_quiet/**
```

For settings management tests, add a specific unignore line following the pattern of `!test/pages/setting/models/shielding_settings_test.dart`.

## §10 — Code Reality That Changes/Constrains the Atomic Plan

### Constraint 1: Channel UID timing — no pre-creation prevention

Channel UID arrives AFTER both `VideoReplyController` and `PlDanmaku` initialization. The atomic plan's Slice 04 claim "Avoid creating VideoReplyController when a matched channel rule hides comments and UID timing allows it" is **impossible in the current architecture**. The controller is created in `initState()` synchronously, well before the async video-info HTTP request completes.

**Adjustment needed**: Slice 04 must pivot to: (a) allow controller creation as usual; (b) once channel UID is known and a persistent rule matches, gate `customGetData()` (already in place for temp controls — extend with channel check), hide the comment tab/panel, and block all future requests. The controller may need to be created but kept idle.

### Constraint 2: Danmaku first-segment request cannot be prevented

`PlDanmaku.initState()` fires the first `queryDanmaku()` before channel UID is known. The first segment load cannot be prevented by channel rules. However:
- Subsequent segments ARE preventable via the position-listener gate
- Visible danmaku can be cleared immediately when a rule match is detected
- The render opacity can be set to 0

**Adjustment needed**: Slice 05 must document that the very first danmaku segment request cannot be escalated, and rely on clearing + opacity + segment-request blocking for subsequent segments.

### Constraint 3: PGC videos lack `owner.mid`

PGC (bangumi) videos use `seasonId` not `owner.mid`. The persistent rule data model must support both UGC (`owner.mid`) and PGC (`seasonId`) channel identification. This affects:
- Data model key design
- Channel name source (UGC: `owner.name`, PGC: `pgcItem.title`)
- Matching logic in both comment and danmaku gates

**Adjustment needed**: The data model in Slice 02 should use a composite or string-based key that can represent both UGC mid and PGC seasonId. Alternatively, store `channelType` (ugc/pgc) + `channelId` as separate fields.

### Constraint 4: Storage pattern — use `setting` Box, not new Box

The established pattern (ShieldSettingsStore) stores complex data as JSON strings in the `GStorage.setting` box with namespaced keys. A new Hive box is NOT needed. This means:
- No new `Hive.openBox()` call
- No new `HiveType`/adapter registration unless a typed box is chosen
- Auto-included in `exportAllSettings()`/`importAllSettings()` since these iterate `setting` box
- Auto-covered by compact/close/clear

**Recommendation**: Follow `ShieldSettingsStore` pattern — `ChannelQuietStore` wrapping `GStorage.setting` with namespaced keys, JSON serialization.

### Constraint 5: Settings entry pattern — add to `SettingType` enum

Adding a settings management page requires:
1. New `SettingType.channelQuietSetting` enum value
2. New `_SettingsModel` entry in the settings list
3. New route in `app_pages.dart`
4. New page implementation

This is a well-established pattern (shielding, WebDAV, about all follow it). Slice 07 should follow this exactly.

### Constraint 6: Precedence model must integrate with existing

Current effective state:
```
effectiveShowReply = globalShow && !tempHideReply
effectiveShowDanmaku = globalShow && !tempHideDanmaku
```

New precedence:
```
effectiveShowReply = globalShow && !channelRuleHidesReply && !tempHideReply
effectiveShowDanmaku = globalShow && !channelRuleHidesDanmaku && !tempHideDanmaku
```

The hard gates are preserved: `globalShow` (`showReply` / `enableShowDanmaku`) is the outer AND. If global is off, nothing below can re-enable.

**Slice 03 adjustment**: The `effectiveShowTemporaryContent` helper may need to become `effectiveShowContent` accepting three levels, or a new helper added alongside.

### Summary of plan changes needed

| Slice | Issue | Recommended change |
|-------|-------|--------------------|
| 02 | PGC vs UGC key | Use string key `"ugc:$mid"` / `"pgc:$seasonId"` or tuple |
| 03 | Precedence 3-level | Extend `effectiveShowTemporaryContent` to accept channel-rule override |
| 04 | "Avoid creating VideoReplyController" impossible | Pivot to: create normally, gate `customGetData()` + hide panel after UID arrives |
| 05 | "Avoid initializing danmaku" impossible | Pivot to: allow init, clear after match, block segment requests, zero opacity |
| 07 | Settings entry pattern | Follow `SettingType` enum + route convention exactly |

## §11 — Risks and Unknowns

1. **PGCIinfoModel owner/uploader**: Not verified whether PGC items have any mid-like upstream uploader concept. If needed, the API may return a different field.
2. **`PlDanmaku` rebuild on channel rule match**: The `PlDanmaku` uses `Obx()` wrapping that listens to reactive state. If channel-rule match is added to the reactive chain, the widget should rebuild. But the existing `cid`-based `ValueKey` means a cid change creates a new widget instance, not a cid-same rule change. Rule match must trigger an update via existing reactive channels (e.g., `effectiveShowDanmaku` based on an `RxBool`).
3. **Channel UID race with tab switch**: If the user switches tabs quickly before video-info arrives, the channel UID may arrive while the comments tab is not active. The system must handle this by checking the rule when the comments tab becomes active.
4. **Edge case: unknown channel (file source, no owner)**: `isFileSource` already returns `showReply = false`. Local files have no channel concept. The channel quiet store should handle `null` channel gracefully.
5. **No local Flutter/Dart**: Static analysis and test execution must be delegated to GitHub Actions (CI). Slice 08 should record this limitation and plan CI dispatch.
6. **Hive adapter typeId collision**: Existing typeIds in use: 1 (Stat), 3 (Owner), 4 (UserInfoData), 5 (LevelInfo), 9 (LoginAccount). Any new `@HiveType` must use an unused typeId.

## §12 — Atomic Plan Revision Recommendation

The Codex atomic plan at `records/codex/implementation/2026-06-08-task-020-atomic-reasonix-plan.md` needs the following revisions before Slice 02:

1. **Slice 02**: Data model must handle both UGC mid and PGC seasonId.
2. **Slice 03**: Effective state must accept channel-rule as middle layer, not just bolt on.
3. **Slice 04**: Change "Avoid creating VideoReplyController" to "Create normally; gate customGetData() and hide panel after channel UID known."
4. **Slice 05**: Change "Avoid initializing danmaku" to "Allow normal init; clear danmaku after rule match, block future segment requests."
5. **Slice 07/08**: Add `.gitignore` update for new test locations.
6. **Slice 08**: Record that local Flutter/Dart is unavailable; plan CI dispatch.

## Boundaries

This is a read-only fact-check. No product-code edits, persistence writes, CI dispatch, acceptance claims, merge, release, or closure are performed or claimed.
