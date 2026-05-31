# Phase 1 Release Build Workflow Dispatch — Codex Review

Date: 2026-05-31
Review owner: Codex
Reviewed artifact:

- `records/reasonix/monitor/2026-05-31-phase-1-release-build-workflow-dispatch-monitor.md`

Status: accepted as factual monitor evidence for old release APK existence; rejected as signing gate evidence

## Review Scope

Codex reviewed the persisted Reasonix monitor report and performed local read-only checks against git history and `.github/workflows/build.yml`.

Codex did not trigger GitHub Actions, did not monitor GitHub Actions directly, did not download artifacts, did not publish a release, and did not inspect unpersisted Reasonix chat.

## Accepted Factual Findings

The Reasonix report is internally consistent and is accepted for these facts:

- `Build` workflow_dispatch run `26680259984` completed successfully on branch `phase-1-shielding-core`.
- The run head SHA was `80f5e6d6a7c63b4439c313281be76235f94ab0e6`.
- The run produced Android APK artifacts for `arm64-v8a`, `armeabi-v7a`, and `x86_64`.
- The same APKs were published under pre-release `phase-1-prebuild.26680259984`.
- The workflow file at commit `80f5e6d6a` did not contain `Capture Android signing fingerprints`, `Android_signing_evidence`, or `apksigner verify --print-certs` capture steps.
- The current workflow at local `HEAD` `a5d0d075cd80a35173355a52133057c7cec1679b` does contain signing-evidence capture and upload steps.

Codex locally confirmed:

- `git show --no-patch --format='%H%n%s' 80f5e6d6a` resolves to `80f5e6d6a7c63b4439c313281be76235f94ab0e6` / `ci: bind prebuild releases to workflow commit`.
- `git show 80f5e6d6a:.github/workflows/build.yml` has no `apksigner`, `signing-evidence`, `Android_signing_evidence`, `签名证据`, or `Capture Android signing` match.
- `.github/workflows/build.yml` at current `HEAD` contains `Capture Android signing fingerprints`, `apksigner verify --print-certs`, `signing-evidence`, and `Android_signing_evidence`.

## Release Gate Decision

The run `26680259984` may be cited as evidence that old release APK artifacts existed for commit `80f5e6d6a`.

It does not close:

- current-commit release build evidence
- `Android_signing_evidence`
- `apksigner verify --print-certs`
- real-device cover-install
- user manual retest
- Phase 1 green/accepted/complete status

Reason: the monitored run predates the workflow signing-evidence steps and therefore cannot prove certificate identity or cover-install compatibility for the current release gate.

## Manual Acceptance Decision

Manual acceptance should not proceed as final Phase 1 release acceptance using run `26680259984` alone.

The recommended next step is a new user-triggered `Build` workflow_dispatch at the current branch tip, followed by a Reasonix monitor report that captures:

- release APK artifact names and IDs
- `Android_signing_evidence`
- `apksigner verify --print-certs` output

After Codex reviews that new persisted report, the user can perform real-device cover-install and manual retest against the reviewed APK.

The user may still choose to do an exploratory local install of the older `80f5e6d6a` APK, but that would be informal testing only and would not close the recorded release gates.
