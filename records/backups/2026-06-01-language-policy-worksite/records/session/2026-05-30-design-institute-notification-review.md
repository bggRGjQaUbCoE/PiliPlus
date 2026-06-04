# Phase 1 Design-Institute Notification Review

Date: 2026-05-30
Recorded at: 2026-05-30T21:35:12+08:00

## Question

Whether the current Phase 1 CI blocker should be discussed with the design
institute.

## Evidence Checked

- Local authority record:
  `records/session/2026-05-30-ci-evidence.md`.
- Earlier GitHub Actions runs `26684680541` and `26684934281` failed at
  Android x86_64 packaging, so runtime smoke was skipped.
- Commit `b6bb438f4` restored the Android x86_64 packaging gate.
- GitHub Actions run `26685711693`:
  - workflow: `Phase 1 CI`;
  - conclusion: `failure`;
  - focused Flutter verification: `success`;
  - Android x86_64 packaging: `success`;
  - `Android_x86_64` artifact produced, artifact id `7308754820`;
  - runtime smoke: `failure`.
- Runtime smoke installed the APK successfully, then failed to launch:
  - APK install: `Success`;
  - launch command: `am start -W -n com.example.piliplus.dev/.MainActivity`;
  - failure:
    `Activity class {com.example.piliplus.dev/com.example.piliplus.dev.MainActivity} does not exist`;
  - status: `30`;
  - reason: `launcher_start_failed`.

## Failure Classification

The previous failed command was an Android packaging command. That blocker is
now closed for commit `b6bb438f4`.

The current failed command is the runtime-smoke launch command:

```text
am start -W -n com.example.piliplus.dev/.MainActivity
```

Android reports:

```text
Activity class {com.example.piliplus.dev/com.example.piliplus.dev.MainActivity} does not exist
```

This is not a design presentation defect, UI interaction defect, content defect,
white-screen detection failure, or APK install failure. It is a runtime-smoke
launch-entry defect or an Android dev package/activity configuration mismatch.

## External Dependency Check

Historical records show that earlier prebuild distribution was required as a
manual-acceptance distribution point for the design institute. The current run
has produced an Android x86_64 artifact, but the runtime-smoke gate failed
before a valid app launch. It therefore must not be handed off as a manual
acceptance package.

The latest valid manual-acceptance prebuild baseline remains
`phase-1-prebuild.26680259984`, with its own build and runtime-smoke evidence.
Current Phase 1 status is still `not green` because runtime smoke has not
passed, and user manual acceptance plus same-signature cover install remain
pending.

## Decision

It is now reasonable to discuss this blocker with the design institute, using
the failure report and project progress record as the factual boundary.

The discussion should be framed as a runtime-smoke launch-entry problem:
Android x86_64 packaging has recovered, but the dev package launch target
`com.example.piliplus.dev/.MainActivity` does not exist. Do not frame it as a
confirmed UI, interaction, content, recommendation-feed, comment-area, or
white-screen defect.

## Escalation Threshold

Escalate beyond defect discussion if any of the following becomes true:

- The design institute is waiting for this specific APK, demo package,
  acceptance package, or manual-acceptance conclusion.
- The blocker changes an external schedule, review meeting, design acceptance,
  integration window, or delivery commitment.
- The fix requires a design-institute constraint, asset, package-name/activity
  decision, signing decision, device/install policy, or acceptance-criteria
  decision.
- The recovery estimate exceeds one working day or becomes uncertain.
- Someone has already represented the current failed run as ready for manual
  acceptance.

## Suggested External Message

```text
当前 Phase 1 尚未进入新的手动验收。CI 的功能验证和 Android x86_64 包装已恢复，但 runtime smoke 在启动 dev 包入口 com.example.piliplus.dev/.MainActivity 时失败，Android 报告该 Activity 不存在。因此本次 APK 不能作为验收包交付。请协助判断这是 runtime smoke 启动策略问题、Android dev 包名/Activity 配置问题，还是验收口径需要明确 dev APK 的启动入口。
```
