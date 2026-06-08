Audience classification: agent-facing

# Codex Review: Task-020 Slice 01 Stage A Fact-Check

Date: 2026-06-08
Reviewed artifact: `records/reasonix/task-020/2026-06-08-slice-01-stage-a-fact-check.md`
Review owner: Codex
Status: approved for planning use, with required plan revisions before Slice 02

## Review Summary

The Slice 01 artifact is accepted as citable Stage A fact-check evidence after spot-checking the highest-risk claims against current source files.

The key timing finding is correct: channel identity is not available before the initial `VideoReplyController` creation or the first `PlDanmaku.initState()` segment request in the current architecture. Task-020 implementation must therefore avoid overstating prefetch prevention. It can gate later comment refresh/pagination/sort/reload requests, hide comments after rule match, clear/hide danmaku after rule match, and block later danmaku segment requests once the rule is effective.

## Spot-Checked Evidence

- `lib/pages/video/view.dart:140-176`: `VideoDetailController` and `VideoReplyController` are created in `initState()` before `videoSourceInit()` calls `queryVideoUrl()`.
- `lib/pages/video/introduction/ugc/controller.dart:92-119`: UGC video detail, including owner data, is populated only after `VideoHttp.videoIntro(bvid: bvid)` returns.
- `lib/pages/danmaku/view.dart:53-70`: `PlDanmaku.initState()` can call `queryDanmaku(...)` immediately when the current effective danmaku state is true.
- `lib/pages/danmaku/view.dart:98-101`: later position-listener danmaku work already returns before segment lookup/request when effective danmaku is false.
- `lib/pages/video/reply/controller.dart:34-48`: comment network requests route through `customGetData()` and return before `ReplyGrpc.mainList(...)` when effective comments are false.
- `lib/utils/storage.dart:18-98`: shared Hive `setting` box is the appropriate storage surface for namespaced JSON settings, and settings export/import covers that box.

## Accepted Findings

- UGC channel identity is based on `owner.mid` and `owner.name` after video intro data arrives.
- PGC does not expose the same `owner.mid` path in the inspected controller; Task-020 needs a rule key model that can represent UGC and PGC identities if PGC comments/danmaku are in scope.
- A new Hive box is not necessary for Task-020; use a namespaced key in `GStorage.setting` unless later implementation evidence proves otherwise.
- Settings management should follow the existing `SettingType` + `SettingPage` + `GetPage` route pattern.
- Existing tests are selectively unignored; new `test/features/channel_quiet/**` tests require `.gitignore` updates or a currently tracked/non-ignored path.

## Required Plan Revisions

Before Slice 02 starts, the atomic plan must be revised to:

- state that the current architecture cannot prevent initial `VideoReplyController` creation by channel rule;
- state that the current architecture cannot prevent the first danmaku segment request by channel rule;
- change comment acceptance to later-request gating plus tab/panel hiding once the rule is effective;
- change danmaku acceptance to clear/hide plus later segment-request gating once the rule is effective;
- require a UGC/PGC-capable rule key design or explicitly record any later decision to scope only UGC;
- include `.gitignore` handling for new focused tests.

## Boundaries

This review does not claim Task-020 implementation, tests, CI green, package availability, user acceptance, merge, formal release, or parent closure.
