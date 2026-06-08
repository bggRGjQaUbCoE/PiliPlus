Audience classification: agent-facing

# Reasonix Prompt: Task-020 Slice 03 Repair

First confirm that response instructions / 响应指令 are enabled for this task.

You are Reasonix repair worker for Task-020 Slice 03 in `CometDash77/PiliAvalon-Worksite`.

## Harness

- role_id: `task020-slice03-repair`
- target_repo: `CometDash77/PiliAvalon-Worksite`
- target_branch_or_run: `production`
- task_difficulty: simple/narrow repair of prior Slice 03 effective-state output
- model_strategy: `deepseek-flash` is acceptable because this is a narrow style/analyzer repair
- allowed_commands: `pwd`, `git status --short --branch`, `rg`, `sed`, `nl`, `cat`, `git diff --stat`, `git diff --check`, `git diff`, `dart format <changed dart files>`, `flutter test test/pages/video/quiet_state_test.dart`
- forbidden_actions: no edits outside `lib/pages/video/controller.dart`, `lib/pages/video/quiet_state.dart`, `test/pages/video/quiet_state_test.dart`, and the expected repair artifact; no request gates; no danmaku view/controller edits; no settings UI edits; no dependency installs; no git add/commit/push/merge/tag/release; no workflow dispatch; no governance edits; no Design Institute edits
- expected_artifact_path: `records/reasonix/task-020/2026-06-08-slice-03-repair.md`
- max_iterations: 1
- max_time_minutes: 20
- usd_cap: 1.00
- review_owner: `Codex`

Use YOLO/edit-auto-free behavior for allowed slice edits only.

## Required Inputs

Read:

- `records/reasonix/task-020/2026-06-08-slice-03-effective-state.md`
- `lib/pages/video/controller.dart`
- `lib/pages/video/quiet_state.dart`
- `test/pages/video/quiet_state_test.dart`

## Repair Tasks

1. Remove non-ASCII punctuation introduced by Slice 03 source comments. In particular, replace the em dash in `lib/pages/video/controller.dart` reset comment with ASCII punctuation.
2. Check for any other obvious analyzer/style issue in the Slice 03 files only. Do not change public behavior unless required for compile/analyzer correctness.
3. Run `git diff --check`.
4. Try `flutter test test/pages/video/quiet_state_test.dart` and `dart format` on changed Slice 03 files; if unavailable, record exact exit codes.
5. Write the repair artifact.

## Artifact Requirements

Write `records/reasonix/task-020/2026-06-08-slice-03-repair.md` with:

- Audience classification: `agent-facing`
- files inspected and changed;
- exact commands and exit codes;
- issues found and fixes applied;
- remaining local-tool limitations;
- non-claims for CI, release, acceptance, and later slices.
