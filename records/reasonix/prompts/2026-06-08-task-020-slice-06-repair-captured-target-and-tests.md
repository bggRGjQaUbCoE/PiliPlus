First confirm that response instructions / 响应指令 are enabled for this task.

Audience classification: agent-facing

role_id: task-020-slice-06-captured-target-and-test-compile-repair-agent
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: production worktree at /home/mo/Documents/piliavalon
review_owner: Codex

Task difficulty classification: simple bounded repair. Use deepseek-flash unless unavailable.

You are repairing two Codex/subagent review findings in Task-020 Slice 06 only.

Required skills before acting:
- Read `.reasonix/skills/worksite-reasonix-harness.md`.
- Read `.reasonix/skills/flutter-official-skill-router.md`.
- Read `.agents/skills/dart-add-unit-test/SKILL.md`, `.agents/skills/flutter-add-widget-test/SKILL.md`, and `.agents/skills/dart-run-static-analysis/SKILL.md` enough to follow reporting.
- Use YOLO/edit-auto-free behavior for allowed edits.

Expected artifact path:
`records/reasonix/task-020/2026-06-08-slice-06-captured-target-and-test-compile-repair.md`

max_iterations: 1 repair pass plus self-review
max_time_minutes: 20
usd_cap: 1.00

Allowed paths:
- `lib/pages/video/controller.dart`
- `lib/pages/video/view.dart`
- `test/features/channel_quiet/channel_quiet_target_test.dart`
- `records/reasonix/task-020/2026-06-08-slice-06-captured-target-and-test-compile-repair.md`

Allowed commands:
- `git diff -- lib/pages/video/controller.dart lib/pages/video/view.dart test/features/channel_quiet/channel_quiet_target_test.dart`
- `nl -ba <allowed paths>`
- `sed`
- `rg`
- `dart test test/features/channel_quiet/channel_quiet_target_test.dart` or `flutter test test/features/channel_quiet/channel_quiet_target_test.dart` if available
- `dart format <changed dart files>` or `flutter format <changed dart files>` if available
- `git diff --check`

Forbidden actions:
- No commits, pushes, merges, releases, workflow dispatch, dependency installs, destructive cleanup, or edits outside allowed paths.

Findings to repair:

1. High compile issue:
   - `test/features/channel_quiet/channel_quiet_target_test.dart` has `const ChannelQuietTarget(...)` initializers with `key: ChannelQuietRule.ugcKey(42)` and `key: ChannelQuietRule.pgcKey(888)`.
   - Dart const expressions cannot call non-const static methods.
   - Repair by removing `const` from those specific target initializers or otherwise making the tests compile without changing production semantics.

2. Medium captured-target issue:
   - `lib/pages/video/view.dart` opens the editor for a captured `ChannelQuietTarget target`, but dialog actions call `videoDetailController.saveCurrentChannelRule(...)` and `removeCurrentChannelRule()`.
   - Those methods recompute `currentChannelTarget` at execution time in `lib/pages/video/controller.dart`.
   - If route/GetX state changes while the dialog is open, save/remove can no-op or affect a different channel than the one shown.
   - Repair so dialog actions persist/remove the captured target shown in the dialog.

Preferred implementation:
- Add explicit target-based controller methods, for example:
  - `Future<void> saveChannelRule(ChannelQuietTarget target, {required bool hideComments, required bool hideDanmaku})`
  - `Future<void> removeChannelRule(ChannelQuietTarget target)`
- Keep current wrapper methods if useful:
  - `saveCurrentChannelRule(...)` can call `final target = currentChannelTarget; if (target == null) return; await saveChannelRule(target, ...)`
  - `removeCurrentChannelRule()` can call `removeChannelRule(target)`
- Update `lib/pages/video/view.dart` dialog Save/Remove actions to call the explicit captured-target methods.
- Preserve use of `ChannelQuietStore.update()` for existing rules, and `setChannelQuietRule(saved)` / `setChannelQuietRule(null)` immediate application.
- Keep popup dialog deferral from the previous repair intact.

Report requirements:
- Audience classification: agent-facing
- State response instructions confirmation.
- Exact files changed and line anchors.
- Exact commands and exit codes, including SDK blockers if local Dart/Flutter cannot run.
- State explicitly this is candidate evidence for Codex review and does not claim green/acceptance/merge/release/parent closure.
