Audience classification: agent-facing

# Codex Review: Task-020 Slice 04 Comment Gates

Date: 2026-06-08
Reviewed artifacts:

- `records/reasonix/task-020/2026-06-08-slice-04-comment-gates.md`
- `records/reasonix/task-020/2026-06-08-slice-04-repair.md`
- `records/reasonix/task-020/2026-06-08-slice-04-ascii-repair.md`

Review owner: Codex
Status: approved for next slice, with verification limitations

## Review Summary

Slice 04 is accepted after two narrow repair passes. It wires persistent channel-rule lookup into the UGC and PGC intro controllers once channel identity is available, and relies on the reviewed Slice 03 effective-state path plus existing comment request/tab gates.

The implementation correctly does not claim initial `VideoReplyController` creation prevention. The controller is still created before channel identity is known; later comment requests are blocked after the rule is matched by `VideoReplyController.customGetData()` checking `effectiveShowReply`.

## Files Reviewed

- `lib/pages/video/introduction/ugc/controller.dart`
- `lib/pages/video/introduction/pgc/controller.dart`
- `test/features/channel_quiet/channel_matching_test.dart`
- `test/pages/video/quiet_state_test.dart`

## Accepted Implementation

- UGC intro now calls `_matchChannelQuietRule(response.owner?.mid)` after `videoDetail.value = response`.
- UGC lookup uses `ChannelQuietRule.ugcKey(mid)` against `ChannelQuietStore`.
- PGC intro now calls `_matchChannelQuietRule()` after `super.onInit()` when `seasonId`/`pgcItem` are available.
- PGC lookup uses `ChannelQuietRule.pgcKey(seasonId)` against `ChannelQuietStore`.
- Both UGC and PGC paths clear the active in-memory rule via `videoDetailCtr.setChannelQuietRule(null)` when the identifier is null or lookup fails.
- The unused UGC `name` parameter was removed.
- The new channel-matching test fixtures are ASCII-only after repair.

## Gate Chain

After a matching rule is set:

- `VideoDetailController.currentChannelQuietRule` stores the in-memory match.
- `persistentRuleHideReply` reads `rule.hideComments`.
- `effectiveShowReply` computes `globalShow && !persistentRuleHide && !temporaryHide`.
- `VideoReplyController.customGetData()` returns an empty `MainListReply` before `ReplyGrpc.mainList(...)` when `effectiveShowReply` is false.
- Existing video-detail tab/panel render paths use `effectiveShowReply`, so the comments tab/panel hides once the match becomes effective.

## Verification

Codex ran:

```text
git diff --check
exit code: 0
result: no whitespace errors
```

```text
rg -n "[^\x00-\x7F]" test/features/channel_quiet/channel_matching_test.dart || true
exit code: 0
result: no non-ASCII matches
```

Reasonix attempted:

```text
dart format lib/pages/video/introduction/ugc/controller.dart lib/pages/video/introduction/pgc/controller.dart
exit code: 127
result: dart unavailable locally
```

```text
flutter test test/features/channel_quiet/channel_matching_test.dart test/pages/video/quiet_state_test.dart
exit code: 127
result: flutter unavailable locally
```

## Limitations And Risks

- The new tests cover pure store lookup and effective-state behavior. They do not instantiate the private GetX intro-controller matchers. Remote analyzer/tests are required to prove compile status.
- A user may briefly see the comments tab before the async UGC intro response arrives and applies a matching rule. This is an accepted current-architecture timing limit from Slice 01.
- Initial `VideoReplyController` creation remains global-only and is not prevented by persistent rules.

## Boundaries

This review does not claim danmaku gating, settings-page management, video-detail rule action UI, CI green, installable package, user acceptance, merge, formal release, or parent closure.
