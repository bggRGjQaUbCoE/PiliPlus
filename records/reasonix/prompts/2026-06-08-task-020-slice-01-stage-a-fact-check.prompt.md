Audience classification: agent-facing

# Reasonix Prompt: Task-020 Slice 01 Stage A Fact-Check

First confirm that response instructions / 响应指令 are enabled for this task.

You are Reasonix Slice 01 for Task-020 in `CometDash77/PiliAvalon-Worksite`.

## Harness

- role_id: `task020-slice01-stage-a-fact-check`
- target_repo: `CometDash77/PiliAvalon-Worksite`
- target_branch_or_run: `production`
- task_difficulty: hard/cross-cutting fact-check for storage, Flutter UI, video detail, comments, danmaku, and release-bound implementation planning
- model_strategy: Codex selected `deepseek-pro` for this slice because findings will determine cross-cutting implementation boundaries
- allowed_commands: read-only shell/file commands only, including `pwd`, `git status --short --branch`, `rg`, `find`, `sed`, `nl`, `cat`, `git grep`, `git diff --stat`, `git log --oneline -n 5`
- forbidden_actions: no file edits except writing the expected artifact; no product-code edits; no formatting; no dependency installs; no Flutter/Dart test runs; no `git add`; no commit; no push; no merge; no tag; no release; no CI/workflow dispatch; no governance-policy edits; no Design Institute edits
- expected_artifact_path: `records/reasonix/task-020/2026-06-08-slice-01-stage-a-fact-check.md`
- max_iterations: 1
- max_time_minutes: 40
- usd_cap: 3.00
- review_owner: `Codex`

Use YOLO/edit-auto-free behavior only for writing the expected artifact. Do not ask approval for allowed read-only commands or the artifact write.

## Required Skills

Read and follow:

- `.reasonix/skills/worksite-reasonix-harness.md`
- `.reasonix/skills/flutter-official-skill-router.md`
- `.agents/skills/dart-add-unit-test/SKILL.md`
- `.agents/skills/flutter-add-widget-test/SKILL.md`
- `.agents/skills/dart-run-static-analysis/SKILL.md`

Use Reasonix subagents if they can independently audit settings/storage, comments, and danmaku faster. Persist only the final consolidated artifact at the expected path.

## Source Records To Read

- `/home/mo/Documents/obsidian/VIBECODING项目/Piliavalon/records/worksite-communications/2026-06-08-task020-persistent-channel-quiet-to-worksite.md`
- `records/codex/implementation/2026-06-08-task-039-quiet-controls-implementation.md`
- `records/codex/verification/2026-06-08-task039-ci-success-review.md`
- `records/codex/implementation/2026-06-08-task-020-atomic-reasonix-plan.md`

## Fact-Check Scope

Before any Task-020 implementation, verify code reality and record exact file/line references for:

1. where video detail obtains channel UID and channel name;
2. whether channel UID is available before `VideoReplyController` creation;
3. whether channel UID is available before `PlDanmaku` initializes or requests segments;
4. existing settings-page entry patterns and route conventions;
5. existing local storage/database choices, models, adapters, migrations, export/import, compact/close/clear, and rollback patterns;
6. Task-039 temporary effective-state integration points for comments and danmaku;
7. current comment controller request gates for initial query, refresh, pagination, sort, reload;
8. current danmaku init/request/render gates;
9. test locations that are not ignored by `.gitignore`;
10. any code reality that changes or constrains the atomic slice plan.

If channel UID is only available after the first video-info request, record the exact first-request window and say precisely which prevention claims are possible and impossible.

## Artifact Requirements

Write `records/reasonix/task-020/2026-06-08-slice-01-stage-a-fact-check.md` with:

- Audience classification: `agent-facing`
- command log with exact commands and exit codes;
- source records read;
- Stage A findings with exact file/line references;
- channel UID/name timing conclusion;
- comment and danmaku timing/request-gate conclusions;
- storage/settings/test pattern conclusions;
- risks/unknowns;
- whether the Codex atomic plan needs changes before Slice 02.

Do not claim implementation, green, acceptance, merge, release, or closure.
