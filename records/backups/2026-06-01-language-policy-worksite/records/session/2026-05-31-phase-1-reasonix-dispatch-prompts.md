# Phase 1 Reasonix Dispatch Prompts

Date: 2026-05-31
Status: prompts only; Codex has not invoked Reasonix/subagents

Use these prompts manually. Each Reasonix worker must persist its final report under the exact expected path pattern. After the workers finish, provide Codex the persisted paths or a concise summary plus paths for review.

## Global Instructions For Every Reasonix Worker

Start every prompt with:

```text
First confirm that response instructions / 响应指令 are enabled for this task.
```

Required constraints:

- Do not push, merge, publish releases, mutate GitHub workflows, trigger GitHub workflows, edit governance files, or claim any green/client/manual/technical-lead gate is closed.
- Persist all findings and evidence into `records/reasonix/...`.
- Treat chat text as non-evidence unless it is copied into a persisted artifact.
- Use test-first work where implementation changes are required.
- Report reading scope, factual findings, changes or recommendations, risks, unknowns, verification results, and whether client decision is needed.
- Keep all conclusions factual. Do not declare Phase 1 accepted.

## Subagent A: UP/User Keyword + Long-Press UX

```text
First confirm that response instructions / 响应指令 are enabled for this task.

role_id: implementer-up-user-keyword-ux
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: local branch phase-1-shielding-core at C:\Users\77182\Documents\Coding\piliavalon
review_owner: Codex
max_iterations: 5
max_time_minutes: 90
usd_cap: 3
expected_artifact_category: implementer
expected_artifact_path: records/reasonix/implementer/2026-05-31-phase-1-acceptance-fixes-up-user-keyword-ux.md

reading scope:
- records/session/2026-05-31-phase-1-repeat-failure-root-cause.md
- C:\Users\77182\Documents\obsidian\review.md
- C:\Users\77182\Documents\obsidian\assets\review\file-20260531170356318.png
- lib/features/shielding/**
- lib/common/widgets/video_card/shield_quick_action.dart
- existing shielding and video-card quick-action tests

task:
Fix review.md item #3. Write failing tests first for:
- UP/user keyword rule is separate from generic content/title keyword rule.
- UP/user keyword supports title-like split/token workflow.
- long-press quick action routes username shielding to the user-specific rule type, not generic keyword.
- long-press sheet layout intent is covered as far as practical by widget/golden/structure tests.

Then implement the minimum code changes needed. Address the annotated long-press layout intent: cover-visible, cleaned-up action layout, and no awkward 保存封面 placement inside shielding actions.

allowed_commands:
- git status, git diff, git diff --stat
- rg, Get-Content, Select-String, Get-ChildItem
- flutter test for focused shielding/video-card tests
- flutter analyze only if needed for this worker's touched files
- dart format on touched Dart files

forbidden_actions:
- git push, git merge, release creation, workflow mutation, gh workflow run, gh run watch
- editing records outside this worker's report except necessary implementation/test files
- claiming Phase 1 green, user acceptance, client acceptance, or technical-lead approval

final report must include:
- exact files changed
- failing tests added before implementation and final results
- residual risks or unknowns
- whether Codex review or client decision is needed
```

## Subagent B: Legacy Filter Merge + Hidden Old Entries

```text
First confirm that response instructions / 响应指令 are enabled for this task.

role_id: implementer-legacy-filter-merge-hidden-entries
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: local branch phase-1-shielding-core at C:\Users\77182\Documents\Coding\piliavalon
review_owner: Codex
max_iterations: 5
max_time_minutes: 90
usd_cap: 3
expected_artifact_category: implementer
expected_artifact_path: records/reasonix/implementer/2026-05-31-phase-1-acceptance-fixes-legacy-filter-merge.md

reading scope:
- records/session/2026-05-31-phase-1-repeat-failure-root-cause.md
- C:\Users\77182\Documents\obsidian\review.md
- C:\Users\77182\Documents\obsidian\assets\review\file-20260531170604020.png
- C:\Users\77182\Documents\obsidian\assets\review\file-20260531170802946.png
- C:\Users\77182\Documents\obsidian\assets\review\file-20260531170903342.png
- C:\Users\77182\Documents\obsidian\assets\review\file-20260531171025400.png
- lib/pages/setting/models/recommend_settings.dart
- lib/pages/setting/models/extra_settings.dart
- lib/pages/settings_search/view.dart
- lib/http/video.dart
- lib/utils/recommend_filter.dart
- shielding migration/settings tests

task:
Fix review.md item #7. Write failing tests first for:
- old upstream shielding entries no longer appear as parallel settings entries.
- settings search does not expose hidden old shielding labels.
- old stored values are not deleted.
- old recommendation filter behavior is bridged/migrated into the new shielding system or explicitly represented as legacy-compatible rules.

Then implement the minimum code changes needed. Hide old visible entry points after behavior is handled. Do not silently delete stored old values.

allowed_commands:
- git status, git diff, git diff --stat
- rg, Get-Content, Select-String, Get-ChildItem
- flutter test for focused settings/shielding/recommendation tests
- flutter analyze only if needed for this worker's touched files
- dart format on touched Dart files

forbidden_actions:
- git push, git merge, release creation, workflow mutation, gh workflow run, gh run watch
- deleting stored legacy settings values as a shortcut
- claiming Phase 1 green, user acceptance, client acceptance, or technical-lead approval

final report must include:
- old labels searched and proof they are hidden from visible settings/search
- migration/bridge behavior and storage preservation details
- tests added and results
- residual risks or unknowns
```

## Subagent C: Comment/Recommendation Scene Isolation

```text
First confirm that response instructions / 响应指令 are enabled for this task.

role_id: implementer-comment-scene-isolation
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: local branch phase-1-shielding-core at C:\Users\77182\Documents\Coding\piliavalon
review_owner: Codex
max_iterations: 4
max_time_minutes: 75
usd_cap: 2
expected_artifact_category: implementer
expected_artifact_path: records/reasonix/implementer/2026-05-31-phase-1-acceptance-fixes-comment-scene-isolation.md

reading scope:
- records/session/2026-05-31-phase-1-repeat-failure-root-cause.md
- C:\Users\77182\Documents\obsidian\review.md
- lib/grpc/reply.dart
- lib/features/shielding/**
- existing comment/reply shielding tests

task:
Fix review.md item #9. Write failing tests first for:
- comment switch off + old comment keywords present => comments remain visible.
- recommendation and comment switches control only their own scenes.
- old ReplyGrpc / banWordForReply keyword path cannot bypass the new comment scene switch.

Then implement the minimum code changes needed.

allowed_commands:
- git status, git diff, git diff --stat
- rg, Get-Content, Select-String, Get-ChildItem
- flutter test for focused comment/reply/shielding tests
- flutter analyze only if needed for this worker's touched files
- dart format on touched Dart files

forbidden_actions:
- git push, git merge, release creation, workflow mutation, gh workflow run, gh run watch
- claiming Phase 1 green, user acceptance, client acceptance, or technical-lead approval

final report must include:
- exact old path controlled
- tests added and results
- residual risks or unknowns
```

## Subagent D: Settings IA

```text
First confirm that response instructions / 响应指令 are enabled for this task.

role_id: implementer-settings-ia
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: local branch phase-1-shielding-core at C:\Users\77182\Documents\Coding\piliavalon
review_owner: Codex
max_iterations: 5
max_time_minutes: 90
usd_cap: 3
expected_artifact_category: implementer
expected_artifact_path: records/reasonix/implementer/2026-05-31-phase-1-acceptance-fixes-settings-ia.md

reading scope:
- records/session/2026-05-31-phase-1-repeat-failure-root-cause.md
- C:\Users\77182\Documents\obsidian\review.md
- lib/pages/shielding_settings/view.dart
- lib/pages/setting/models/shielding_settings.dart
- shielding settings tests

task:
Fix review.md item #8. Write failing tests first for:
- shielding settings exposes same-row/different-column category navigation.
- clicking category switches or jumps to that category.
- categories cover user/UP, title keyword, tag, category, comment keyword/user, exact text, and legacy-compatible rules when present.

Then implement the minimum UI/model changes needed. Avoid a vertical-only category presentation.

allowed_commands:
- git status, git diff, git diff --stat
- rg, Get-Content, Select-String, Get-ChildItem
- flutter test for focused shielding settings tests
- flutter analyze only if needed for this worker's touched files
- dart format on touched Dart files

forbidden_actions:
- git push, git merge, release creation, workflow mutation, gh workflow run, gh run watch
- claiming Phase 1 green, user acceptance, client acceptance, or technical-lead approval

final report must include:
- navigation pattern implemented
- categories covered
- tests added and results
- residual risks or unknowns
```

## Subagent E: Signing / Release Compatibility

```text
First confirm that response instructions / 响应指令 are enabled for this task.

role_id: implementer-signing-release-compatibility
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: local branch phase-1-shielding-core at C:\Users\77182\Documents\Coding\piliavalon
review_owner: Codex
max_iterations: 5
max_time_minutes: 90
usd_cap: 3
expected_artifact_category: implementer
expected_artifact_path: records/reasonix/implementer/2026-05-31-phase-1-acceptance-fixes-signing-release.md

reading scope:
- records/session/2026-05-31-phase-1-repeat-failure-root-cause.md
- C:\Users\77182\Documents\obsidian\review.md
- android/app/build.gradle.kts
- .github/workflows/build.yml
- existing Android build/release notes under records/session

task:
Fix review.md item #10. Write failing checks/tests first where practical for:
- release build must fail if release signing secrets/config are absent.
- release APK cannot silently fall back to debug signing.
- certificate fingerprint evidence is produced for release artifacts.
- cover-install verification requirements are documented as same applicationId, same signing cert, install-over-existing without uninstall.

Then implement the minimum Gradle/workflow/release-prep changes needed. Do not publish a release.

allowed_commands:
- git status, git diff, git diff --stat
- rg, Get-Content, Select-String, Get-ChildItem
- Gradle/Flutter build dry checks needed for signing guard if locally feasible
- flutter analyze only if touched Dart files require it
- formatting for touched files

forbidden_actions:
- git push, git merge, release creation, workflow mutation beyond the requested workflow edits, gh workflow run, gh run watch
- publishing release artifacts
- claiming cover-install passed unless a real install-over-existing proof is persisted
- claiming Phase 1 green, user acceptance, client acceptance, or technical-lead approval

final report must include:
- signing guard behavior
- fingerprint artifact path/command
- whether local release build was run or why it remains pending
- cover-install evidence status or pending user-device gate
```

## Subagent F: GitHub Runs Monitor

Do not run this until after implementation changes are pushed or a GitHub run exists and the user asks Reasonix to monitor it.

```text
First confirm that response instructions / 响应指令 are enabled for this task.

role_id: monitor-github-runs
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: <fill branch, PR, workflow run id, or release workflow run id>
review_owner: Codex
max_iterations: 12
max_time_minutes: 60
usd_cap: 2
expected_artifact_category: monitor
expected_artifact_path: records/reasonix/monitor/2026-05-31-phase-1-github-runs-<run-or-branch>.md

reading scope:
- GitHub run/job/log/artifact metadata for the target only
- relevant workflow files if needed for interpreting run status

task:
Monitor factual GitHub workflow/action/run state only. Persist:
- run URL and ids
- head SHA and branch
- job status/conclusion
- failed steps and relevant log excerpts
- artifact ids/names/sizes
- unknowns and pending states

allowed_commands:
- gh run view -R CometDash77/PiliAvalon-Worksite ...
- gh api repos/CometDash77/PiliAvalon-Worksite/...
- gh run download -R CometDash77/PiliAvalon-Worksite ... only for metadata/evidence artifacts when necessary

forbidden_actions:
- gh workflow run
- gh run rerun
- git push, merge, release publication, workflow mutation
- claiming automation green as client/user/manual acceptance
- claiming Phase 1 green or release approval

final report must include:
- factual status
- evidence paths and artifact identifiers
- explicit statement that Codex review is required before citation
```

## Optional Release-Prep Worker

Run only after Codex reviews implementation/verification and the user asks for release preparation. This is not release publication.

```text
First confirm that response instructions / 响应指令 are enabled for this task.

role_id: release-prep
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: <fill reviewed commit or run id>
review_owner: Codex
max_iterations: 4
max_time_minutes: 60
usd_cap: 2
expected_artifact_category: release
expected_artifact_path: records/reasonix/release/2026-05-31-phase-1-release-prep-<sha-or-run>.md

task:
Prepare release evidence only. Do not publish. Gather:
- reviewed commit SHA
- release APK artifact identity
- applicationId
- signing certificate fingerprint
- install-over-existing proof status or pending user-device gate
- release notes draft
- residual blockers

allowed_commands:
- git status, git rev-parse HEAD, git diff --stat
- gh api -R CometDash77/PiliAvalon-Worksite for artifact metadata
- apksigner verify --print-certs on local APK if available

forbidden_actions:
- release publication, gh release create/upload/edit, gh workflow run, gh run rerun
- git push, merge, tag creation
- claiming Phase 1 green or manual acceptance

final report must include:
- whether release is technically prepared
- exactly what remains for Codex review and user authorization
```
