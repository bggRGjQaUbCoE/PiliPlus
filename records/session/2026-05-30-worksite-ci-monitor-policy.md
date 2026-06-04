# Worksite CI Monitor Policy

Date: 2026-05-30
Role: worksite-governance

## Scope

This policy is project-local to this repository/worksite. It is not a global
user-machine policy.

## Runtime Smoke Acceptance

Runtime smoke passes only when the APK installs, launches through the Android
launcher-resolved entry or the manifest-derived fallback component, reaches
foreground app UI, has no app crash/ANR evidence, and produces screenshot,
window, uiautomator, logcat, and status evidence.

A failed launch-entry check is a CI/test-governance blocker. It is not product
UI acceptance evidence.

## Main Agent Rule

Main agents may dispatch workflow, build, and smoke runs, then continue
analysis, records, user interaction, and next-step planning.

Main agents must not run long-running CI monitors directly, including:

- `gh run watch`
- open-ended polling loops around `gh run view`, `gh run list`, `gh api`,
  build logs, or runtime-smoke status
- `tail -f` or follow-style remote log tracking

Short snapshot commands remain allowed:

- `gh run list --json ...`
- `gh run view <id> --json ...`
- one-shot artifact or log inspection after a run has completed

## Monitor Agent Exception

A blocked monitor command is allowed only when the worksite explicitly marks the
current role as `monitor-agent` or equivalent delegated CI observer. For the
project-local hook, set `WORKSITE_AGENT_ROLE=monitor-agent` for that delegated
observer process.

## Hook Binding

The project-local guard lives at:

```text
.codex/hooks/guard_ci_monitor.py
```

The project-local Codex hook binding lives at:

```text
.codex/settings.json
```

If a future agent runtime does not load `.codex/settings.json` automatically,
bind the PreToolUse shell hook manually to run:

```text
python .codex/hooks/guard_ci_monitor.py
```

## Monitor Result Shape

Delegated monitor reports must include:

```text
run_id
workflow
url
status
conclusion
head_sha
failed_job
failed_step
evidence_artifacts
recommended_next_action
```

## Current Baseline

`phase-1-prebuild.26680259984` remains the latest valid manual-acceptance
baseline until a later successful runtime-smoke run supersedes it.
