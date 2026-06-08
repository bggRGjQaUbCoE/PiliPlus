Audience classification: agent-facing

# Reasonix Prompt: Task-020 Slice 05 Danmaku Gates

First confirm that response instructions / 响应指令 are enabled for this task.

You are Reasonix Slice 05 for Task-020 in `CometDash77/PiliAvalon-Worksite`.

## Harness

- role_id: `task020-slice05-danmaku-gates`
- target_repo: `CometDash77/PiliAvalon-Worksite`
- target_branch_or_run: `production`
- task_difficulty: hard review/integration slice; danmaku request timing is subtle and must preserve Stage A limitations
- model_strategy: Codex selected `deepseek-pro` because this slice must audit and, only if needed, modify danmaku request/render gates
- allowed_commands: `pwd`, `git status --short --branch`, `rg`, `find`, `sed`, `nl`, `cat`, `git diff --stat`, `git diff --check`, `git diff`, `dart format <changed dart files>`, `flutter test <focused paths>`
- forbidden_actions: no settings route/page edits; no video-detail rule action UI edits; no comment-specific edits unless correcting a regression from prior slices; no dependency installs; no `git add`; no commit; no push; no merge; no tag; no release; no CI/workflow dispatch; no governance-policy edits; no Design Institute edits
- expected_artifact_path: `records/reasonix/task-020/2026-06-08-slice-05-danmaku-gates.md`
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
- `records/reasonix/review/2026-06-08-task020-slice03-codex-review.md`
- `records/reasonix/review/2026-06-08-task020-slice04-codex-review.md`
- `records/codex/implementation/2026-06-08-task-020-atomic-reasonix-plan.md`

## Write Scope

Allowed product files if needed:

- `lib/pages/danmaku/view.dart`
- `lib/pages/danmaku/controller.dart`
- `lib/pages/video/controller.dart` only for tiny `hideDanmaku` effective-state/clear fixes
- `lib/plugin/pl_player/view/view.dart` only if tap-danmaku UI still leaks while hidden

Allowed test files:

- `test/pages/video/quiet_state_test.dart`
- `test/features/channel_quiet/`
- `.gitignore` only if needed to keep focused tests trackable

Do not modify settings pages/routes, video-detail rule action UI, release/workflow files, or Design Institute files in this slice.

## Required Behavior

Audit existing danmaku behavior after Slices 03/04 and implement only missing pieces:

- Do not claim prevention of the first `PlDanmaku.initState()` segment request. Slice 01 proved channel identity may arrive after that first request.
- Once a matched persistent rule has `hideDanmaku == true`, `VideoDetailController.effectiveShowDanmaku` must become false.
- Visible danmaku must be cleared promptly when the persistent rule becomes active. Slice 03 `setChannelQuietRule()` already attempts this; verify and repair only if needed.
- Later danmaku segment requests must be blocked once `effectiveShowDanmaku` is false.
- Render opacity and tap-danmaku action UI must remain hidden when `effectiveShowDanmaku` is false.
- Preserve global danmaku hard gate: global danmaku off cannot be overridden by persistent or temporary controls.
- Preserve temporary controls behavior.

## TDD / Test Requirements

Write or extend focused tests before production edits where practical:

- `effectiveShowContent` hides when persistent `hideDanmaku` is true.
- A `hideComments`-only rule does not imply persistent danmaku hide.
- Global false remains hidden regardless of persistent/temporary state.
- Store lookup for a `hideDanmaku` rule produces the expected `hideDanmaku` flag.

If no production edits are needed because existing Slice 03/04 gates already satisfy behavior, still write focused tests and record the source-line proof. If local `dart`/`flutter` is unavailable, record exact command and exit code.

## Artifact Requirements

Write `records/reasonix/task-020/2026-06-08-slice-05-danmaku-gates.md` with:

- Audience classification: `agent-facing`
- files changed or explicit no-product-code-change decision;
- exact commands and exit codes;
- TDD evidence or local-tool-unavailable evidence;
- exact source line references for initial request limitation, later segment-request gate, render opacity gate, tap-danmaku UI gate, and clear-on-rule-match behavior;
- risks and later-slice dependencies;
- explicit boundaries: no settings UI, no video-detail rule UI, no CI green, no release, no user acceptance.
