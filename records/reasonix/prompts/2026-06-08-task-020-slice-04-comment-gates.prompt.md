Audience classification: agent-facing

# Reasonix Prompt: Task-020 Slice 04 Comment Gates

First confirm that response instructions / 响应指令 are enabled for this task.

You are Reasonix Slice 04 for Task-020 in `CometDash77/PiliAvalon-Worksite`.

## Harness

- role_id: `task020-slice04-comment-gates`
- target_repo: `CometDash77/PiliAvalon-Worksite`
- target_branch_or_run: `production`
- task_difficulty: hard integration slice; touches video-detail channel matching and comment visibility/request behavior
- model_strategy: Codex selected `deepseek-pro` because this slice integrates storage, async intro timing, controller state, and existing comment gates
- allowed_commands: `pwd`, `git status --short --branch`, `rg`, `find`, `sed`, `nl`, `cat`, `git diff --stat`, `git diff --check`, `git diff`, `dart format <changed dart files>`, `flutter test <focused paths>`
- forbidden_actions: no danmaku view/controller edits; no settings route/page edits; no video-detail action UI edits; no dependency installs; no `git add`; no commit; no push; no merge; no tag; no release; no CI/workflow dispatch; no governance-policy edits; no Design Institute edits
- expected_artifact_path: `records/reasonix/task-020/2026-06-08-slice-04-comment-gates.md`
- max_iterations: 1
- max_time_minutes: 75
- usd_cap: 6.00
- review_owner: `Codex`

Use YOLO/edit-auto-free behavior for allowed slice commands and file edits only.

## Required Skills And Records

Read and follow:

- `.reasonix/skills/worksite-reasonix-harness.md`
- `.reasonix/skills/flutter-official-skill-router.md`
- `.agents/skills/dart-add-unit-test/SKILL.md`
- `.agents/skills/dart-run-static-analysis/SKILL.md`
- `records/reasonix/task-020/2026-06-08-slice-01-stage-a-fact-check.md`
- `records/reasonix/review/2026-06-08-task020-slice01-codex-review.md`
- `records/reasonix/review/2026-06-08-task020-slice02-codex-review.md`
- `records/reasonix/review/2026-06-08-task020-slice03-codex-review.md`
- `records/codex/implementation/2026-06-08-task-020-atomic-reasonix-plan.md`

## Write Scope

Allowed product files:

- `lib/pages/video/controller.dart`
- `lib/pages/video/introduction/ugc/controller.dart`
- `lib/pages/video/introduction/pgc/controller.dart`
- `lib/pages/video/reply/controller.dart` only if a tiny explicit comment-gate helper or test seam is needed
- `lib/pages/video/view.dart` only if needed for comment tab/panel update after rule match
- `lib/pages/video/channel_quiet/` only for tiny helper APIs needed by matching

Allowed test files:

- `test/features/channel_quiet/`
- `test/pages/video/quiet_state_test.dart` only if pure helper tests are extended
- `.gitignore` only if needed to keep focused tests trackable

Do not modify `lib/pages/danmaku/view.dart`, `lib/pages/danmaku/controller.dart`, settings pages/routes, header controls, plugin player files, or release/workflow files in this slice.

## Required Behavior

Implement comment-side persistent rule matching and gates:

- Do not claim initial `VideoReplyController` creation prevention. Slice 01 proved it is created before channel identity is available.
- Once UGC video intro response provides `owner.mid` and `owner.name`, look up `ChannelQuietStore` using `ChannelQuietRule.ugcKey(mid)`.
- Once PGC controller has `seasonId` and title, look up `ChannelQuietStore` using `ChannelQuietRule.pgcKey(seasonId)`, if PGC comments are in scope for current code. If not implementable, record why and keep UGC robust.
- Call `videoDetailCtr.setChannelQuietRule(ruleOrNull)` after lookup so `effectiveShowReply` reflects persistent hide-comments.
- When a matched rule has `hideComments == true`, comment tab/panel should hide through existing `effectiveShowReply` render paths.
- Later comment requests must be blocked by existing `VideoReplyController.customGetData()` because it checks `videoCtr.effectiveShowReply`.
- Preserve global hard gate: global comments off cannot be overridden by persistent or temporary controls.
- Preserve temporary controls behavior from Task-039.
- Do not add video-detail rule add/update/remove UI in this slice.

## TDD Requirements

Write failing tests before production edits where practical. Prefer pure tests for any new matching helper:

- UGC owner mid/name maps to a `ugc:<mid>` lookup key and display values.
- Missing UGC owner mid produces no active lookup/match.
- PGC season id/title maps to a `pgc:<seasonId>` lookup key if implemented.
- Effective comment hidden when matched rule has `hideComments == true`.
- Effective comment unaffected when matched rule only has `hideDanmaku == true`.

If full controller tests are too coupled to Flutter/GetX initialization, write focused pure-helper tests and record untested integration risks. If local `dart`/`flutter` is unavailable, record exact command and exit code. Still write tests and implementation.

## Artifact Requirements

Write `records/reasonix/task-020/2026-06-08-slice-04-comment-gates.md` with:

- Audience classification: `agent-facing`
- files changed;
- exact commands and exit codes;
- TDD evidence or local-tool-unavailable evidence;
- exact source line references for channel lookup timing and comment gate behavior after edits;
- explicit statement that initial `VideoReplyController` creation is still not prevented in current architecture;
- risks and later-slice dependencies;
- explicit boundaries: no danmaku gate, no settings UI, no video-detail rule UI, no CI green, no release, no user acceptance.
