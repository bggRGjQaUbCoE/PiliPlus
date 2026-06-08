Audience classification: agent-facing

# Reasonix Prompt: Task-020 Slice 03 Effective State

First confirm that response instructions / 响应指令 are enabled for this task.

You are Reasonix Slice 03 for Task-020 in `CometDash77/PiliAvalon-Worksite`.

## Harness

- role_id: `task020-slice03-effective-state`
- target_repo: `CometDash77/PiliAvalon-Worksite`
- target_branch_or_run: `production`
- task_difficulty: moderate implementation slice; state/controller wiring touches video-detail behavior but not request code or UI management pages
- model_strategy: Codex selected `deepseek-pro` because this slice defines the effective-state contract for later comment/danmaku gates
- allowed_commands: `pwd`, `git status --short --branch`, `rg`, `find`, `sed`, `nl`, `cat`, `git diff --stat`, `git diff --check`, `git diff`, `git check-ignore -v`, `dart format <changed dart files>`, `flutter test <focused paths>`
- forbidden_actions: no comment request gate edits; no danmaku view/controller edits; no settings route/page edits; no video-detail action UI edits; no dependency installs; no `git add`; no commit; no push; no merge; no tag; no release; no CI/workflow dispatch; no governance-policy edits; no Design Institute edits
- expected_artifact_path: `records/reasonix/task-020/2026-06-08-slice-03-effective-state.md`
- max_iterations: 1
- max_time_minutes: 60
- usd_cap: 5.00
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
- `records/reasonix/task-020/2026-06-08-slice-02-model-store-tests.md`
- `records/reasonix/task-020/2026-06-08-slice-02-repair.md`
- `records/reasonix/review/2026-06-08-task020-slice02-codex-review.md`
- `records/codex/implementation/2026-06-08-task-020-atomic-reasonix-plan.md`

## Write Scope

Allowed product files:

- Modify `lib/pages/video/quiet_state.dart`
- Modify `lib/pages/video/controller.dart`
- Modify or add under `lib/pages/video/channel_quiet/` only if a tiny state helper belongs there

Allowed test files:

- Modify `test/pages/video/quiet_state_test.dart`
- Create tests under `test/features/channel_quiet/` if more appropriate
- Modify `.gitignore` only if needed to keep new focused tests trackable

Do not modify `lib/pages/video/view.dart`, `lib/pages/video/reply/controller.dart`, `lib/pages/danmaku/view.dart`, `lib/pages/danmaku/controller.dart`, `lib/pages/video/widgets/header_control.dart`, routes, settings pages, or plugin player files in this slice.

## Required Behavior

Implement only effective-state modeling and controller-facing persistent-rule state:

- Preserve existing Task-039 temporary behavior.
- Add a helper with effective state:
  `globalShow && !persistentRuleHide && !temporaryHide`
- Global off remains a hard gate and cannot be overridden by persistent or temporary controls.
- Add controller-facing state that later slices can set after channel identity is known:
  - current channel quiet rule (or equivalent reactive fields)
  - effective comment visibility uses the persistent rule's `hideComments`
  - effective danmaku visibility uses the persistent rule's `hideDanmaku`
- If persistent hide-danmaku becomes effective, clear currently visible danmaku promptly using the existing `plPlayerController.danmakuController?.clear()` pattern.
- Provide a reset path that clears the current persistent-rule match when the video resets, while keeping the stored database intact.
- Do not load from storage or derive channel identity in this slice unless it is required for the state contract; later slices own channel matching, UI, and request gates.

## TDD Requirements

Write failing tests before production edits. Tests should cover at least:

- global true, persistent false, temporary false => visible.
- global true, persistent true, temporary false => hidden.
- global true, persistent false, temporary true => hidden.
- global true, persistent true, temporary true => hidden.
- global false with any persistent/temporary combination => hidden.
- existing tab-index tests still pass structurally.

If local `dart`/`flutter` is unavailable, record exact command and exit code. Still write tests and implementation.

## Artifact Requirements

Write `records/reasonix/task-020/2026-06-08-slice-03-effective-state.md` with:

- Audience classification: `agent-facing`
- files changed;
- exact commands and exit codes;
- TDD evidence or local-tool-unavailable evidence;
- effective-state API summary;
- controller state/reset/clear behavior;
- explicit boundaries: no request gates, no UI management, no CI green, no release, no user acceptance.
