# Phase 1 Reasonix Closure Dispatch Prompts

Audience classification: agent-facing.

Date: 2026-06-01
Repository boundary: CometDash77/PiliAvalon-Worksite
Prompt owner: Codex
Status: prompts only; Reasonix output remains candidate evidence until Codex review

## Global Instructions

Use these prompts manually for Phase 1 closure monitoring and review labor. Each Reasonix worker must persist its final output under the exact expected `records/reasonix/...` path and must declare `Audience classification: agent-facing`.

Reasonix must not claim Phase 1 green, accepted, closed, released, or ready to merge. Reasonix must not push, merge, release, mutate workflows, edit product code, edit governance policy, or close user/manual/client acceptance.

Every final report must include:

- reading scope;
- factual findings;
- changes or recommendations;
- risks;
- unknowns;
- verification results;
- whether client decision is needed.

## Prompt A: Dirty-Work And Technical Review Auditor

```text
First confirm that response instructions / 响应指令 are enabled for this task.

role_id: auditor
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: branch phase-1-shielding-acceptance-fixes; evidence HEAD ce45458c0; product/APK ref eda5bee71c2a1f0a0d15187d7104b7bda7a5a915
allowed_commands:
- git status --short
- git diff --stat
- git diff --name-status
- git diff -- lib/utils/image_utils.dart
- git diff --name-status eda5bee71..HEAD -- ':!records/**'
- rg / rg --files read-only searches
- Get-Content read-only file inspection
- gh run view/list only when scoped with -R CometDash77/PiliAvalon-Worksite
forbidden_actions:
- product code edits
- workflow edits or gh workflow run
- governance policy edits
- git push, merge, release, tag creation, or destructive filesystem changes
- claiming Phase 1 green, accepted, closed, merged, released, or user/client approved
- closing runtime smoke, manual acceptance, technical-lead review, client acceptance, or user acceptance
max_iterations: 3
max_time_minutes: 30
usd_cap: 1.00
expected_artifact_category: auditor
expected_artifact_path: records/reasonix/auditor/2026-06-01-phase-1-closure-dirty-work-audit.md
review_owner: Codex

Task:
Audit Phase 1 closure readiness as candidate evidence only. Confirm whether product code remains untouched relative to the stated product/APK ref where the provided verification commands can prove it. Summarize dirty worktree state, missing gates, technical-review evidence status, user physical-device retest status, and any contradictions. Persist the report at the expected artifact path.
```

## Prompt B: GitHub Actions Monitor

```text
First confirm that response instructions / 响应指令 are enabled for this task.

role_id: monitor
target_repo: CometDash77/PiliAvalon-Worksite
target_branch_or_run: branch phase-1-shielding-acceptance-fixes; evidence HEAD ce45458c0; product/APK ref eda5bee71c2a1f0a0d15187d7104b7bda7a5a915; monitor only runs explicitly identified by the user or already visible for this branch
allowed_commands:
- gh run list -R CometDash77/PiliAvalon-Worksite --branch phase-1-shielding-acceptance-fixes
- gh run view <run-id> -R CometDash77/PiliAvalon-Worksite
- gh api repos/CometDash77/PiliAvalon-Worksite/actions/runs/<run-id>
- rg / rg --files read-only searches
- Get-Content read-only file inspection
forbidden_actions:
- gh workflow run
- product code edits
- workflow edits
- governance policy edits
- git push, merge, release, tag creation, or destructive filesystem changes
- claiming Phase 1 green, accepted, closed, merged, released, or user/client approved
- closing runtime smoke, manual acceptance, technical-lead review, client acceptance, or user acceptance
max_iterations: 5
max_time_minutes: 45
usd_cap: 1.50
expected_artifact_category: monitor
expected_artifact_path: records/reasonix/monitor/2026-06-01-phase-1-closure-github-runs-monitor.md
review_owner: Codex

Task:
Watch the relevant GitHub Actions runs as candidate evidence only. Persist a monitor report with run IDs, URLs, workflow names, head SHAs, conclusions, artifact names, missing artifacts, failed jobs, skipped jobs, and unknowns. Do not infer acceptance or release readiness from automation status.
```

## Codex Review Requirement

Codex must read only persisted Reasonix reports when reviewing Reasonix conclusions. Before citing a Reasonix conclusion, Codex must write or update a matching review artifact under `records/reasonix/review/...` that accepts, rejects, or restricts the candidate findings.

Phase 1 final closure remains blocked unless technical review evidence and physical-device user retest evidence are both persisted, with Codex review where the evidence comes from Reasonix.
