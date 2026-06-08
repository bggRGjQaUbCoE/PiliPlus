Audience classification: agent-facing

# Reasonix Prompt: Task-020 Slice 04 Repair

First confirm that response instructions / 响应指令 are enabled for this task.

You are Reasonix repair worker for Task-020 Slice 04 in `CometDash77/PiliAvalon-Worksite`.

## Harness

- role_id: `task020-slice04-repair`
- target_repo: `CometDash77/PiliAvalon-Worksite`
- target_branch_or_run: `production`
- task_difficulty: moderate/narrow repair of comment-gate integration
- model_strategy: `deepseek-pro` because this fixes stale-rule behavior in an async controller integration
- allowed_commands: `pwd`, `git status --short --branch`, `rg`, `sed`, `nl`, `cat`, `git diff --stat`, `git diff --check`, `git diff`, `dart format <changed dart files>`, `flutter test <focused paths>`
- forbidden_actions: no edits outside `lib/pages/video/introduction/ugc/controller.dart`, `lib/pages/video/introduction/pgc/controller.dart`, `test/features/channel_quiet/`, `test/pages/video/quiet_state_test.dart`, and the expected repair artifact; no danmaku edits; no settings UI edits; no video-detail action UI edits; no dependency installs; no git add/commit/push/merge/tag/release; no workflow dispatch; no governance edits; no Design Institute edits
- expected_artifact_path: `records/reasonix/task-020/2026-06-08-slice-04-repair.md`
- max_iterations: 1
- max_time_minutes: 35
- usd_cap: 2.00
- review_owner: `Codex`

Use YOLO/edit-auto-free behavior for allowed slice edits only.

## Required Inputs

Read:

- `records/reasonix/task-020/2026-06-08-slice-04-comment-gates.md`
- `lib/pages/video/introduction/ugc/controller.dart`
- `lib/pages/video/introduction/pgc/controller.dart`
- `test/features/channel_quiet/channel_matching_test.dart`
- `test/pages/video/quiet_state_test.dart`

## Repair Tasks

1. Fix stale-rule behavior:
   - In UGC matching, if `mid == null`, call `videoDetailCtr.setChannelQuietRule(null)` before returning.
   - In PGC matching, if `seasonId == null`, call `videoDetailCtr.setChannelQuietRule(null)` before returning.
2. Remove the unused UGC `name` parameter from `_matchChannelQuietRule(...)` and its call site unless you use it meaningfully.
3. Add or adjust focused tests if there is a pure helper seam. If not practical because the matcher is private/controller-bound, explicitly record the limitation in the repair artifact.
4. Run `git diff --check`.
5. Try focused `flutter test` and `dart format`; if unavailable, record exact exit codes.
6. Write the repair artifact.

## Artifact Requirements

Write `records/reasonix/task-020/2026-06-08-slice-04-repair.md` with:

- Audience classification: `agent-facing`
- files inspected and changed;
- exact commands and exit codes;
- issues found and fixes applied;
- stale-rule reasoning;
- remaining local-tool limitations;
- non-claims for CI, release, acceptance, and later slices.
