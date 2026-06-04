# Phase 1 Shielding Repair Worksite Declaration

Date: 2026-05-30 14:13:46 CST
Repository: `/home/mo/Documents/piliavalon`
Remote: `git@github.com:CometDash77/PiliAvalon-Worksite.git`
Branch: `phase-1-shielding-core`
Release type target: `prebuild`

## Boundary

`phase-1-prebuild.26675065521` is failed Phase 1 shielding acceptance evidence.
It may be cited only as failed history. It must not be reused as matcher,
quickAction, runtime-smoke, release, or user-acceptance evidence for this
repair.

This session must produce fresh repair commits, fresh automated evidence, fresh
Android runtime-smoke evidence, and fresh prebuild release notes. If any key
gate fails, the result remains yellow/red and must not be handed to the user as
green acceptance.

## Main Agent

- Role: total package integration, conflict handling, final verification, and
  release evidence assembly.
- Read scope: entire worksite repository, design-institute blueprint, worksite
  handoff, CI workflows, and prior session records.
- Write scope: integration edits after subagent handoffs, final session
  summary, release evidence draft, and conflict resolution.
- Forbidden write scope: design-institute repository files under
  `/home/mo/Documents/obsidian`, disabled remotes, upstream/reference forks,
  and unrelated `.codex/` workspace files.
- Verification commands:
  - `flutter test test/features/shielding`
  - `flutter test test/pages/setting/models/shielding_settings_test.dart`
  - `flutter analyze --no-fatal-infos`
  - Android runtime smoke via local device/emulator or GitHub Actions.
- Handoff location:
  `records/session/2026-05-30-phase-1-shielding-repair-main-handoff.md`

## Agent A - matcher/store/settings

- Role: matcher contract, store quickAction helper, settings simplification,
  and focused model tests.
- Write scope:
  - `lib/features/shielding/*`
  - `lib/pages/shielding_settings/view.dart`
  - `lib/pages/setting/models/shielding_settings.dart`
  - `test/features/shielding/*`
  - `test/pages/setting/models/shielding_settings_test.dart`
- Forbidden write scope: homepage, video page, comments UI, workflows, release
  notes, and records other than its handoff.
- Verification commands:
  - `flutter test test/features/shielding`
  - `flutter test test/pages/setting/models/shielding_settings_test.dart`
- Required fixes:
  - `keyword + exact` becomes case-insensitive literal contains.
  - `uid/category/tag + exact` remains equality.
  - Add quickAction helper with `block`, `quickAction`, `exact`, and
    `type + scope + pattern` de-duplication.
  - Manual add exposes only text keyword shielding; old allow/UID/regex rules
    remain display-compatible.
- Handoff location:
  `records/session/2026-05-30-phase-1-shielding-repair-agent-a-handoff.md`

## Agent B - homepage/video

- Role: recommendation card, video intro, tags, and related-video adapters/UI.
- Write scope:
  - homepage recommendation card/view/controller files
  - `lib/common/widgets/video_card/video_card_v.dart`
  - `lib/common/widgets/video_card/video_card_h.dart`
  - `lib/http/video.dart`
  - `lib/pages/video/related/*`
  - `lib/pages/video/introduction/ugc/*`
  - focused tests or test helpers for recommendation/video behavior
- Forbidden write scope: matcher/store/settings internals, comments UI,
  release notes, workflows, and records other than its handoff.
- Verification commands:
  - focused Flutter tests covering related-video filtering and quickAction
    entry behavior where practical
  - `flutter test test/features/shielding`
- Required fixes:
  - Recommendation cards expose free copy/selection and create
    `keyword/exact/recommendation` quickAction rules.
  - Video title/UP/tags/related cards expose shielding entry points.
  - Related-video list uses Phase 1 shielding filtering.
  - Saved rules remove current cards immediately or make them disappear after
    refresh.
- Handoff location:
  `records/session/2026-05-30-phase-1-shielding-repair-agent-b-handoff.md`

## Agent C - comments

- Role: main comments, child comments, free copy, comment-user entry, and
  comment filtering.
- Write scope:
  - `lib/pages/video/reply/**`
  - `lib/pages/video/reply_reply/**`
  - `lib/pages/common/reply_controller.dart`
  - `lib/grpc/reply.dart` only if needed for adapter filtering
  - focused comment shielding tests
- Forbidden write scope: matcher/store/settings internals, homepage/video UI,
  release notes, workflows, and records other than its handoff.
- Verification commands:
  - focused Flutter tests covering selected-text quickAction where practical
  - `flutter test test/features/shielding`
- Required fixes:
  - Free copy remains available.
  - Selected text writes Phase 1 quickAction, not only old
    `ReplyGrpc.replyRegExp`.
  - Comment user entry creates `uid/comment` quickAction.
  - Main comments, child comments, and preview child replies share Phase 1
    filtering or unresolved gaps remain yellow.
- Handoff location:
  `records/session/2026-05-30-phase-1-shielding-repair-agent-c-handoff.md`

## Agent D - verification/release

- Role: CI/run evidence, Android runtime smoke, release notes draft, rollback
  path, and yellow/red tracking.
- Write scope:
  - `records/session/*phase-1-shielding-repair*`
  - release notes draft under records/session
  - no product source unless explicitly asked by main agent for evidence-only
    plumbing
- Forbidden write scope: product source, tests, workflows unless main agent
  identifies a verification blocker requiring a workflow fix.
- Verification commands:
  - `flutter test test/features/shielding`
  - `flutter test test/pages/setting/models/shielding_settings_test.dart`
  - `flutter analyze --no-fatal-infos`
  - scoped GitHub Actions commands with `-R CometDash77/PiliAvalon-Worksite`
  - Android install/launch runtime smoke.
- Required evidence:
  - command results, workflow URL, commit SHA, screenshot/logcat paths, release
    notes draft, rollback path, and explicit failure-package warning.
- Handoff location:
  `records/session/2026-05-30-phase-1-shielding-repair-agent-d-handoff.md`
