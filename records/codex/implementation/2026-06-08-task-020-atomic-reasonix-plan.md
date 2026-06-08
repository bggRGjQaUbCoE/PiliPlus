Audience classification: agent-facing

# Task-020 Atomic Reasonix Plan

Date: 2026-06-08
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `production`
Coordinator/reviewer: Codex
Primary worker: Reasonix

## Goal

Implement persistent channel UID quiet rules for video-detail comments and danmaku, with local persistence, settings management, video-detail add/update/remove actions, request/render gates, remote verification, and an installable validation package.

## Difficulty And Model Policy

Overall difficulty: hard and cross-cutting. The task touches persistent storage, settings UI, video-detail state, comment request gates, danmaku initialization/request/render gates, tests, CI, build artifacts, and release-governance evidence.

Default Reasonix model: use the provider aliases reported by the current `reasonix doctor` in this workspace. On 2026-06-08 at plan time, the available DeepSeek aliases were `deepseek-pro` and `deepseek-flash`. Use `deepseek-pro` for implementation, integration, review, and remote-monitor slices. `deepseek-flash` may be used only for narrow read-only/report-only continuations. If a later `reasonix doctor` reports `deepseek-v4-pro` / `deepseek-v4-flash` instead, use those current aliases and record the alias change in the slice prompt.

## Current Code Anchors And Stage A Constraints

- Global comment gate and temporary state live in `lib/pages/video/controller.dart:154-189`.
- `VideoReplyController` is created only when global comments are enabled in `lib/pages/video/view.dart:150-158`.
- Comment requests are gated through `VideoReplyController.customGetData()` in `lib/pages/video/reply/controller.dart:34-48`.
- Danmaku effective state is read by `PlDanmaku` in `lib/pages/danmaku/view.dart:42-70`, listener gating is in `lib/pages/danmaku/view.dart:98-120`, and render opacity is in `lib/pages/danmaku/view.dart:180-193`.
- Hive boxes are initialized in `lib/utils/storage.dart:18-78`, exported/imported in `lib/utils/storage.dart:80-97`, and compacted/closed/cleared in `lib/utils/storage.dart:111-148`.
- Slice 01 fact-check plus Codex review established that channel identity arrives after initial video-detail setup: `VideoReplyController` creation cannot currently be prevented by channel rule, and the first `PlDanmaku.initState()` segment request cannot currently be prevented by channel rule.
- Current-architecture Task-020 behavior must be stated precisely: hide after rule match, clear visible danmaku after rule match, gate every later comment request through `customGetData()`, and gate every later danmaku segment request through effective-state checks. Do not claim full pre-fetch prevention.

## Atomic Slice Rules

Each Reasonix slice must:

- start with `First confirm that response instructions / 响应指令 are enabled for this task.`;
- use `.reasonix/skills/worksite-reasonix-harness.md`;
- for Flutter/Dart work, read `.reasonix/skills/flutter-official-skill-router.md` and the relevant official `.agents/skills/<skill-name>/SKILL.md`;
- use subagents where safe and useful;
- use YOLO/edit-auto-free behavior for its allowed slice only;
- persist a candidate artifact under `records/reasonix/task-020/...`;
- not push, merge, tag, release, mutate CI/workflow definitions, or claim accepted/green/released;
- leave Codex as `review_owner`.

Execution gate: run exactly one Reasonix slice at a time unless Codex explicitly records that two slices are independent and safe to overlap. Do not start the next slice until the previous slice's persisted artifact exists and Codex has written the matching review artifact listed below. Slice 01 may revise the later slice boundaries before Slice 02 starts.

## Slice 01: Stage A Fact-Check And Final Slice Plan

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-01-stage-a-fact-check.md`

Scope: read-only.

Tasks:

- Read the Task-020 handoff and Task-039 implementation/CI records.
- Verify exact file/line references for channel UID/name timing, comment controller creation, comment request gates, danmaku initialization/request/render gates, settings-page patterns, and storage/database patterns.
- Determine whether channel UID is available before `VideoReplyController` creation and before `PlDanmaku` initialization.
- Produce a final implementation slice plan if code reality differs from the handoff.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice01-codex-review.md`.

## Slice 02: Data Model And Persistence Tests

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-02-model-store-tests.md`

Scope: model/store only.

Likely files:

- Create `lib/pages/video/channel_quiet/channel_quiet_rule.dart`.
- Create or modify `lib/pages/video/channel_quiet/channel_quiet_store.dart`.
- Create focused tests under a non-ignored `test/features/...` path.

Tasks:

- Write failing tests first for rule serialization, add/update/delete, timestamp behavior, reload persistence, and keyed lookup by channel identity.
- Model channel identity so it can represent UGC `owner.mid` and PGC `seasonId`, for example a stable key such as `ugc:<mid>` / `pgc:<seasonId>` plus display fields. If implementation later scopes PGC out, record the explicit reason and risk before coding.
- Implement the minimal model/store against the project storage pattern confirmed in Slice 01.
- Use namespaced JSON in `GStorage.setting` following the `ShieldSettingsStore` style unless the current code forces another storage surface.
- Do not touch video-detail UI, comment gates, or danmaku gates.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice02-codex-review.md`.

## Slice 03: Effective State Integration Tests And Controller Model

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-03-effective-state.md`

Scope: pure state/controller helpers only.

Likely files:

- Modify `lib/pages/video/quiet_state.dart` or add focused helpers under `lib/pages/video/channel_quiet/`.
- Modify `lib/pages/video/controller.dart` only for persistent-rule effective state wiring.
- Add focused tests under a non-ignored `test/features/...` path.

Tasks:

- Write failing tests for precedence: global setting > channel persistent rule > current-page temporary override.
- Preserve hard gates: global comments/danmaku off cannot be overridden.
- Add controller-facing helpers that expose effective comment/danmaku visibility from global, persistent channel rule, and temporary sources.
- Ensure the effective-state shape is `globalShow && !persistentRuleHide && !temporaryHide`.
- Do not change settings UI or network request code in this slice.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice03-codex-review.md`.

## Slice 04: Comment Gate Integration

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-04-comment-gates.md`

Scope: video-detail comments only.

Likely files:

- Modify `lib/pages/video/view.dart`.
- Modify `lib/pages/video/reply/controller.dart`.
- Add or extend focused tests if controller behavior can be tested without full app boot.

Tasks:

- Do not claim initial `VideoReplyController` creation prevention in the current architecture. Slice 01 proved the controller is created before channel identity is available.
- Block all refresh, pagination, sort, reload, and any other later comment requests once the persistent rule is effective.
- Hide the comments tab/panel without misleading blank UI.
- Preserve the global-off hard gate.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice04-codex-review.md`.

## Slice 05: Danmaku Gate Integration

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-05-danmaku-gates.md`

Scope: danmaku only.

Likely files:

- Modify `lib/pages/danmaku/view.dart`.
- Modify `lib/pages/danmaku/controller.dart` only if a deeper request gate is required.
- Modify player call sites only as needed to pass effective state.

Tasks:

- Do not claim prevention of the first danmaku segment request in the current architecture. Slice 01 proved `PlDanmaku.initState()` can request before channel identity is available.
- Block all later segment requests once the rule is effective.
- Clear or hide visible danmaku promptly after a rule becomes effective.
- Preserve the global-off hard gate.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice05-codex-review.md`.

## Slice 06: Video-Detail Rule Action UI

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-06-video-detail-ui.md`

Scope: video-detail add/update/remove controls only.

Likely files:

- Modify `lib/pages/video/widgets/header_control.dart`.
- Modify `lib/pages/video/view.dart` if the upper-right more menu owns the action.
- Add widget/unit tests where practical.

Tasks:

- Add a current-channel action with stateful wording for adding, updating, or removing the rule.
- Allow setting hide-comments default and hide-danmaku default for the current channel.
- Keep UI compact and avoid tutorial text.
- Do not add settings-page management in this slice.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice06-codex-review.md`.

## Slice 07: Settings-Page Management UI

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-07-settings-management.md`

Scope: settings route/page only.

Likely files:

- Modify the settings model file identified in Slice 01.
- Add a management page under `lib/pages/setting/...` or an established route location.
- Add widget tests where practical.

Tasks:

- Add a settings-page entry for persistent channel quiet rules.
- List stored rules with channel name, UID, enabled defaults, and updated time where consistent with local UI style.
- Support delete and update/toggle behavior.
- Keep storage behavior through Slice 02 store APIs.
- Update `.gitignore` only as needed to ensure new focused tests are tracked.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice07-codex-review.md`.

## Slice 08: Focused Verification

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-08-focused-verification.md`

Scope: local or remote test execution as available.

Tasks:

- Run focused tests for model/store, effective state, comment gates, danmaku gates, and settings UI.
- Run static analysis if local Flutter/Dart is available; otherwise record the local limitation.
- If new test directories/files are ignored by `.gitignore`, fix tracking rules before treating tests as accepted evidence.
- Persist exact commands, exit codes, and output summaries.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice08-codex-review.md`.

## Slice 09: Remote Verification Monitor

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-09-remote-verification-monitor.md`

Scope: GitHub Actions monitoring only, after Codex pushes/dispatches a branch/run.

Tasks:

- Monitor remote analyze/test/build/runtime smoke with long wait intervals.
- Persist run ID, URL, head SHA, job conclusions, artifact names, and failures if any.
- Do not claim green until Codex reviews the artifact.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice09-codex-review.md`.

## Slice 10: Installable Validation Package And Final Report Inputs

Expected artifact: `records/reasonix/task-020/2026-06-08-slice-10-validation-package.md`

Scope: artifact/release evidence collection only, after remote build succeeds.

Tasks:

- Identify the user-installable validation APK/package artifact or prerelease equivalent.
- Record artifact/release URL, SHA, rollback notes, and residual risks.
- Do not publish a formal release or claim user/client acceptance.

Codex review artifact: `records/reasonix/review/2026-06-08-task020-slice10-codex-review.md`.

## Final Codex Report

Final required report path:

`records/codex/implementation/2026-06-08-task-020-persistent-channel-quiet-implementation.md`

The final report must cite only persisted Reasonix artifacts that have matching Codex review artifacts, and must include commands, exit codes, CI URL, artifact/release URL, rollback, risks, and explicit non-claims for user acceptance, merge, formal release, and parent closure.
