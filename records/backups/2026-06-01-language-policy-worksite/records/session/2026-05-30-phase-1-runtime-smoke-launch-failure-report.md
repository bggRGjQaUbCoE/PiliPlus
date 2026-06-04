# Phase 1 Runtime Smoke Launch Failure Report

Date: 2026-05-30
Recorded at: 2026-05-30T21:50:00+08:00

## Scope

This record captures the current Phase 1 runtime-smoke blocker for design
institute defect discussion. It supersedes the earlier packaging-only blocker:
Android x86_64 packaging is now restored, but runtime smoke cannot launch the
dev APK entry point.

## Repository

- Repo: `CometDash77/PiliAvalon-Worksite`
- Local root: `C:\Users\77182\Documents\Coding\piliavalon`
- Branch: `phase-1-shielding-core`
- Commit: `b6bb438f4`

## CI Run

- Workflow: `Phase 1 CI`
- Run id: `26685711693`
- Status: `failure`
- Current blocker: `runtime-smoke`

## Fixed Since Previous Blocker

Commit `b6bb438f4` fixed the Android x86_64 packaging gate. The
`Android_x86_64` artifact was produced, so the previous Gradle packaging
configuration failure is no longer the active blocker for this run.

## Runtime Smoke Evidence

Observed facts from the runtime-smoke launch step:

```text
APK install: Success
launch command: am start -W -n com.example.piliplus.dev/.MainActivity
failure: Activity class {com.example.piliplus.dev/com.example.piliplus.dev.MainActivity} does not exist
status: 30
reason: launcher_start_failed
```

## Failure Classification

This is not evidence of a design presentation defect, UI interaction defect,
content defect, white-screen detection failure, or APK installation failure.

The APK installed successfully. The failure occurred before first-screen
inspection because the smoke script attempted to launch
`com.example.piliplus.dev/.MainActivity`, and Android reported that
`com.example.piliplus.dev.MainActivity` does not exist.

The active defect class is one of:

- runtime-smoke launch-entry inference defect;
- dev package name and Activity class mismatch;
- Android manifest / activity-alias / launch configuration mismatch for the
  dev build;
- acceptance-launch strategy mismatch if the app should be launched through a
  different package/activity or launcher intent.

## Acceptance Decision

Current Phase 1 status remains `not green`.

Do not hand this APK to the user for same-signature cover install or manual
acceptance. Runtime smoke did not reach a valid app launch, so the artifact is
not a usable acceptance package.

The latest valid manual-acceptance baseline remains
`phase-1-prebuild.26680259984`.

## Design-Institute Discussion Prompt

```text
请设计院基于 records/session/2026-05-30-phase-1-runtime-smoke-launch-failure-report.md 和 records/session/2026-05-30-phase-1-project-progress-for-design-institute.md 评审 Phase 1 当前缺陷：Android x86_64 包装已恢复，但 runtime smoke 因 dev 包名启动入口 com.example.piliplus.dev/.MainActivity 不存在而失败，请判断这是测试启动策略、Android 包名/Activity 配置，还是验收口径需要调整。
```
