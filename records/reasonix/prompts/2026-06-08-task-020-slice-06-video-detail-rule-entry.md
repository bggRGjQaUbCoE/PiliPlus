First confirm that response instructions / 响应指令 are enabled for this task.

Audience classification: agent-facing

role_id: task-020-slice-06-video-detail-rule-entry-implementation-agent
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: production worktree at /home/mo/Documents/piliavalon
review_owner: Codex

Task difficulty classification: moderate integration. This slice touches video-detail controller state plus one UI entry and focused tests, with no release/CI authority. Use deepseek-pro quality for implementation judgment.

You are implementing one atomic Task-020 slice only: add/update/remove UI for the current video-detail channel quiet rule.

Hard governance boundaries:
- Reasonix output is candidate evidence only. Persist your report at the expected artifact path below; Codex will review it before relying on it.
- Do not commit, push, merge, release, dispatch workflows, close acceptance, claim green, or edit governance policy.
- Keep internal records in professional English.
- Product UI strings may remain Chinese to match the app.
- Use YOLO/edit-auto-free behavior for the allowed file edits and commands so this bounded slice does not stall on approval prompts.

Required skills before acting:
- Read `.reasonix/skills/worksite-reasonix-harness.md`.
- Read `.reasonix/skills/flutter-official-skill-router.md`.
- Then read the relevant official project skills under `.agents/skills/`, at minimum:
  - `dart-add-unit-test`
  - `flutter-add-widget-test` if you add widget tests
  - `dart-run-static-analysis`
- Use your own subagents where they improve quality, but keep this shared product-state slice atomic and do not create overlapping edits.

Expected artifact path:
`records/reasonix/task-020/2026-06-08-slice-06-video-detail-rule-entry.md`

max_iterations: 1 implementation pass plus self-review
max_time_minutes: 35
usd_cap: 2.00

Allowed commands:
- `pwd`
- `git status --short --branch`
- `git diff --stat`
- `git diff -- <allowed paths>`
- `rg`
- `sed`
- `nl -ba`
- `find`
- `dart test <focused test paths>` or `flutter test <focused test paths>` if available
- `dart format <changed dart files>` or `flutter format <changed dart files>` if available

Forbidden actions:
- No `git add`, `git commit`, `git push`, `git merge`, `git checkout`, `git reset`, `git restore`, or release commands.
- No network dependency installation.
- No destructive cleanup.
- No edits outside allowed paths.
- No changes to CI/workflows, governance files, release files, design-institute files, or global Reasonix/Codex config.

Allowed product/test paths for this slice:
- `lib/pages/video/controller.dart`
- `lib/pages/video/view.dart`
- `lib/pages/video/channel_quiet/**`
- `test/features/channel_quiet/**`
- `test/pages/video/quiet_state_test.dart` only if necessary
- `records/reasonix/task-020/2026-06-08-slice-06-video-detail-rule-entry.md`

Current reviewed baseline:
- Slice 02 added `ChannelQuietRule`, `ChannelQuietStore`, and store tests.
- Slice 03 added `VideoDetailController.currentChannelQuietRule`, persistent hide getters, `effectiveShowContent`, and `setChannelQuietRule`.
- Slice 04 matches UGC/PGC stored rules after channel identity is known.
- Slice 05 verified existing danmaku gates can read effective state; no product code change was needed.

Reality anchors to verify before editing:
- `lib/pages/video/view.dart` around `quietControlPopupItems()` currently contains only temporary hide comments/danmaku popup items.
- `lib/pages/video/controller.dart` around current quiet state has `currentChannelQuietRule`, `persistentRuleHideReply`, `persistentRuleHideDanmaku`, and `setChannelQuietRule`.
- UGC channel identity can be read after detail response from `UgcIntroController.videoDetail.value.owner?.mid` and `owner?.name`.
- PGC identity can be read from current `VideoDetailController.seasonId` / `PgcIntroController.pgcItem.title`, with `ChannelQuietRule.pgcKey(seasonId)`.
- Existing edit-dialog pattern exists in `lib/pages/shielding_settings/view.dart` using `showDialog`, `StatefulBuilder`, `SwitchListTile`, and `TextButton`.

Required behavior for this slice:
1. Add a current-channel persistent quiet action in the video-detail more menu.
2. If current channel identity is not available, do not show the persistent action or make it a harmless disabled/no-op path.
3. If no rule exists for the current channel, the action opens a compact editor to add one.
4. If a rule exists, the action opens the same editor prefilled for update and offers removal.
5. Editor must support hide-comments and hide-danmaku defaults.
6. Do not allow global comments/danmaku off to be overridden. Saving a rule only changes persistent rule state; effective visibility must still flow through existing global hard gates.
7. When saved, persist with `ChannelQuietStore` and immediately call `setChannelQuietRule(savedRule)`.
8. When removed, delete from `ChannelQuietStore` and immediately clear `currentChannelQuietRule`.
9. Preserve `createdAt` on updates by using `ChannelQuietStore.update()` for existing rules, not `add()` as a blind overwrite.
10. Avoid large refactors. Header control duplication can remain for a later slice unless the more-menu implementation needs a tiny shared helper.

TDD requirement:
- Add focused tests before production code where practical.
- Prefer pure Dart tests for helper behavior such as current-channel target data, add/update/remove persistence semantics, or action labels.
- If local Dart/Flutter commands are unavailable, record the exact command and exit code in the report; do not claim local green.

Suggested implementation shape, not mandatory:
- Add a small pure helper/model under `lib/pages/video/channel_quiet/`, for example `ChannelQuietTarget` and/or functions for action labels and save/update/remove against `ChannelQuietStore`.
- Add methods to `VideoDetailController` to compute the current channel target and to save/remove the current channel rule.
- Add one `PopupMenuItem` to `quietControlPopupItems()` in `lib/pages/video/view.dart` that opens a `showDialog` editor with two switches and Save/Remove/Cancel actions.
- Keep source comments ASCII. Existing Chinese UI labels are acceptable.

Report requirements for the expected artifact:
- Audience classification: agent-facing
- State whether response instructions were confirmed.
- List exact files changed.
- List exact commands run and exit codes.
- Summarize behavior implemented.
- Include exact file/line anchors after implementation for the menu entry, controller helper(s), and tests.
- Record any local verification blocker, especially if `dart`/`flutter` is unavailable.
- State explicitly that this is candidate evidence for Codex review and does not claim green, acceptance, merge, release, or parent closure.
