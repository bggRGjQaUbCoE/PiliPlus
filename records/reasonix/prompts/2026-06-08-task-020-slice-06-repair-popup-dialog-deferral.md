First confirm that response instructions / 响应指令 are enabled for this task.

Audience classification: agent-facing

role_id: task-020-slice-06-popup-dialog-deferral-repair-agent
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: production worktree at /home/mo/Documents/piliavalon
review_owner: Codex

Task difficulty classification: simple bounded UI repair. Use deepseek-flash unless unavailable.

You are repairing one Codex review finding in Task-020 Slice 06 only.

Required skills before acting:
- Read `.reasonix/skills/worksite-reasonix-harness.md`.
- Read `.reasonix/skills/flutter-official-skill-router.md`.
- Read `.agents/skills/flutter-add-widget-test/SKILL.md` and `.agents/skills/dart-run-static-analysis/SKILL.md` enough to follow verification/reporting.
- Use YOLO/edit-auto-free behavior for allowed edits.

Expected artifact path:
`records/reasonix/task-020/2026-06-08-slice-06-popup-dialog-deferral-repair.md`

max_iterations: 1 repair pass plus self-review
max_time_minutes: 15
usd_cap: 0.75

Allowed paths:
- `lib/pages/video/view.dart`
- `records/reasonix/task-020/2026-06-08-slice-06-popup-dialog-deferral-repair.md`

Allowed commands:
- `git diff -- lib/pages/video/view.dart`
- `nl -ba lib/pages/video/view.dart`
- `sed`
- `rg`
- `dart format lib/pages/video/view.dart` or `flutter format lib/pages/video/view.dart` if available

Forbidden actions:
- No commits, pushes, merges, releases, workflow dispatch, dependency installs, or edits outside allowed paths.

Finding to repair:
- `lib/pages/video/view.dart` currently opens `_showChannelQuietEditor(context, target, existing)` directly from `PopupMenuItem.onTap`.
- This can race the popup menu route dismissal and use an unsafe/stale menu context.

Required repair:
- Defer opening the channel quiet editor until after the popup menu has dismissed.
- Prefer a minimal local change such as wrapping the dialog call in `WidgetsBinding.instance.addPostFrameCallback((_) { if (!mounted) return; _showChannelQuietEditor(this.context, target, existing); });`
- Use the page state's stable `this.context`, not the popup `itemBuilder` context, when opening the dialog after deferral.
- Keep behavior otherwise unchanged.

Report requirements:
- Audience classification: agent-facing
- State response instructions confirmation.
- Exact file changed and line anchor.
- Exact commands and exit codes, including local SDK blockers if format/analyze cannot run.
- Explicitly state this is candidate evidence for Codex review and does not claim green/acceptance/merge/release/parent closure.
