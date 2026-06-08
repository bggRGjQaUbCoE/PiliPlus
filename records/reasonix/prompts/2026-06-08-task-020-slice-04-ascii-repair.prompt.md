Audience classification: agent-facing

# Reasonix Prompt: Task-020 Slice 04 ASCII Repair

First confirm that response instructions / 响应指令 are enabled for this task.

You are Reasonix repair worker for Task-020 Slice 04 in `CometDash77/PiliAvalon-Worksite`.

## Harness

- role_id: `task020-slice04-ascii-repair`
- target_repo: `CometDash77/PiliAvalon-Worksite`
- target_branch_or_run: `production`
- task_difficulty: simple/narrow test-fixture cleanup
- model_strategy: `deepseek-flash` is sufficient
- allowed_commands: `pwd`, `git status --short --branch`, `rg`, `sed`, `cat`, `git diff --check`, `git diff`, `dart format test/features/channel_quiet/channel_matching_test.dart`, `flutter test test/features/channel_quiet/channel_matching_test.dart`
- forbidden_actions: no edits outside `test/features/channel_quiet/channel_matching_test.dart` and the expected repair artifact; no product-code edits; no dependency installs; no git add/commit/push/merge/tag/release; no workflow dispatch; no governance edits; no Design Institute edits
- expected_artifact_path: `records/reasonix/task-020/2026-06-08-slice-04-ascii-repair.md`
- max_iterations: 1
- max_time_minutes: 15
- usd_cap: 0.50
- review_owner: `Codex`

Use YOLO/edit-auto-free behavior for allowed slice edits only.

## Repair Tasks

1. In `test/features/channel_quiet/channel_matching_test.dart`, replace non-ASCII fixture strings with ASCII-only fixture strings. Example: replace `TestUP主` with `TestUP`, and replace any non-ASCII PGC title with `BangumiShow`.
2. Do not alter behavior or assertions except for matching the new ASCII fixture text.
3. Run `git diff --check`.
4. Try `dart format` and focused `flutter test`; if unavailable, record exact exit codes.
5. Write the repair artifact.

## Artifact Requirements

Write `records/reasonix/task-020/2026-06-08-slice-04-ascii-repair.md` with:

- Audience classification: `agent-facing`
- files changed;
- exact commands and exit codes;
- fixture replacements made;
- remaining local-tool limitations;
- non-claims for CI, release, acceptance, and later slices.
