Audience classification: agent-facing

# Reasonix Prompt: Task-020 Slice 02 Repair

First confirm that response instructions / 响应指令 are enabled for this task.

You are Reasonix repair worker for Task-020 Slice 02 in `CometDash77/PiliAvalon-Worksite`.

## Harness

- role_id: `task020-slice02-repair`
- target_repo: `CometDash77/PiliAvalon-Worksite`
- target_branch_or_run: `production`
- task_difficulty: simple/narrow repair of prior Slice 02 model/store output
- model_strategy: `deepseek-flash` is acceptable because this is a narrow analyzer/test-contract repair; use current `reasonix doctor` alias if different
- allowed_commands: `pwd`, `git status --short --branch`, `rg`, `sed`, `nl`, `cat`, `git diff --stat`, `git diff --check`, `git diff`, `git check-ignore -v`, `dart format <changed dart files>`, `flutter test test/features/channel_quiet/channel_quiet_store_test.dart`
- forbidden_actions: no edits outside `.gitignore`, `lib/pages/video/channel_quiet/`, `test/features/channel_quiet/`, and the expected repair artifact; no video controller/view edits; no comment gate edits; no danmaku edits; no settings UI edits; no dependency installs; no git add/commit/push/merge/tag/release; no workflow dispatch; no governance edits; no Design Institute edits
- expected_artifact_path: `records/reasonix/task-020/2026-06-08-slice-02-repair.md`
- max_iterations: 1
- max_time_minutes: 25
- usd_cap: 1.00
- review_owner: `Codex`

Use YOLO/edit-auto-free behavior for allowed slice edits only.

## Required Inputs

Read:

- `records/reasonix/task-020/2026-06-08-slice-02-model-store-tests.md`
- `lib/pages/video/channel_quiet/channel_quiet_rule.dart`
- `lib/pages/video/channel_quiet/channel_quiet_store.dart`
- `test/features/channel_quiet/channel_quiet_store_test.dart`
- `.gitignore`

## Repair Tasks

1. Remove any obvious analyzer issues in the Slice 02 files, especially unused imports.
2. Check test/report mismatch risks: the test inventory in the report claims 16 tests but the file may contain more; update only the repair artifact with the true count. Do not rewrite the original Slice 02 artifact unless a factual correction is necessary for future readers.
3. Run `git diff --check`.
4. Try `dart format` and focused `flutter test`; if unavailable, record exact exit codes.
5. Keep the existing public API stable unless a compile/analyzer issue requires a minimal adjustment.

## Artifact Requirements

Write `records/reasonix/task-020/2026-06-08-slice-02-repair.md` with:

- Audience classification: `agent-facing`
- files inspected and changed;
- exact commands and exit codes;
- issues found and fixes applied;
- remaining local-tool limitations;
- non-claims for CI, release, acceptance, and later slices.
