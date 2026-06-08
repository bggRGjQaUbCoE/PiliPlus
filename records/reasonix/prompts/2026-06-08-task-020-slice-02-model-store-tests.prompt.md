Audience classification: agent-facing

# Reasonix Prompt: Task-020 Slice 02 Model And Store Tests

First confirm that response instructions / 响应指令 are enabled for this task.

You are Reasonix Slice 02 for Task-020 in `CometDash77/PiliAvalon-Worksite`.

## Harness

- role_id: `task020-slice02-model-store-tests`
- target_repo: `CometDash77/PiliAvalon-Worksite`
- target_branch_or_run: `production`
- task_difficulty: hard implementation slice, but write scope is narrow: persistent rule model/store plus focused tests only
- model_strategy: Codex selected `deepseek-pro` because this slice defines durable storage contracts for later UI/request-gate slices
- allowed_commands: `pwd`, `git status --short --branch`, `rg`, `find`, `sed`, `nl`, `cat`, `git diff --stat`, `git diff --check`, `git diff`, `git ls-files`, `dart test <focused path>`, `flutter test <focused path>`, `dart format <changed dart files>`, file edits limited to the slice files listed below
- forbidden_actions: no video-detail UI edits; no comment gate edits; no danmaku gate edits; no settings-route/page edits; no dependency installs; no `git add`; no commit; no push; no merge; no tag; no release; no CI/workflow dispatch; no governance-policy edits; no Design Institute edits
- expected_artifact_path: `records/reasonix/task-020/2026-06-08-slice-02-model-store-tests.md`
- max_iterations: 1
- max_time_minutes: 60
- usd_cap: 5.00
- review_owner: `Codex`

Use YOLO/edit-auto-free behavior for the allowed slice commands and file edits. Do not ask approval for allowed commands or allowed file edits.

## Required Skills And Records

Read and follow:

- `.reasonix/skills/worksite-reasonix-harness.md`
- `.reasonix/skills/flutter-official-skill-router.md`
- `.agents/skills/dart-add-unit-test/SKILL.md`
- `.agents/skills/dart-run-static-analysis/SKILL.md`
- `records/reasonix/task-020/2026-06-08-slice-01-stage-a-fact-check.md`
- `records/reasonix/review/2026-06-08-task020-slice01-codex-review.md`
- `records/codex/implementation/2026-06-08-task-020-atomic-reasonix-plan.md`

## Write Scope

Allowed product files:

- Create `lib/pages/video/channel_quiet/channel_quiet_rule.dart`
- Create `lib/pages/video/channel_quiet/channel_quiet_store.dart`
- Create optional barrel `lib/pages/video/channel_quiet/channel_quiet.dart` if useful

Allowed test/gitignore files:

- Create focused tests under `test/features/channel_quiet/`
- Modify `.gitignore` only to unignore `test/features/channel_quiet/` and its children if needed

Do not modify `lib/pages/video/controller.dart`, `lib/pages/video/view.dart`, `lib/pages/video/reply/controller.dart`, `lib/pages/danmaku/view.dart`, settings pages, routes, or header controls in this slice.

## Required Behavior

Implement only the persistent rule model/store contract for later slices:

- Local persistent rule database keyed by channel identity.
- Rule fields:
  - channel identity key, supporting UGC and PGC. Use a stable string shape such as `ugc:<mid>` and `pgc:<seasonId>`.
  - channel UID/source id as a display/debug string or typed identity payload.
  - channel name.
  - hide comments default.
  - hide danmaku default.
  - created time.
  - updated time.
- Use namespaced JSON in `GStorage.setting` following `ShieldSettingsStore` style. Do not add a new Hive box or Hive adapter unless current code makes JSON impossible.
- Provide add/update/delete/list/lookup behavior.
- Ensure persistence reload behavior can be tested through an in-memory/fake box abstraction or store wrapper pattern.
- Keep rollback simple: prior JSON payload can be restored because all data lives under one namespaced setting key.

## TDD Requirements

Write failing tests first before implementation. Tests should cover at least:

- UGC key creation and serialization round-trip.
- PGC key creation and serialization round-trip.
- add rule stores created/updated times.
- update rule preserves created time and advances/changes updated time.
- delete removes by key.
- lookup by key returns the right rule and unmatched key is null.
- reload/load from stored JSON preserves rules.
- damaged JSON bypasses rules with empty/default state instead of throwing.

If local `dart`/`flutter` is unavailable, record exact command and exit code. Still write the tests and implementation.

## Artifact Requirements

Write `records/reasonix/task-020/2026-06-08-slice-02-model-store-tests.md` with:

- Audience classification: `agent-facing`
- commands run with exit codes;
- files changed;
- TDD red/green evidence, or local-tool-unavailable evidence;
- exact model/store API summary;
- storage key and rollback notes;
- test tracking/.gitignore notes;
- risks and what later slices must do;
- clear non-claims: no UI, no comment gate, no danmaku gate, no CI green, no release, no user acceptance.
