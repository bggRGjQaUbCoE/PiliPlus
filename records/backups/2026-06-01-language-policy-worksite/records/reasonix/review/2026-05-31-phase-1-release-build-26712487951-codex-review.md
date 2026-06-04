# Phase 1 Release Build 26712487951 — Codex Review

Date: 2026-05-31
Review owner: Codex
Reviewed artifact:

- `records/reasonix/monitor/2026-05-31-phase-1-release-build-26712487951-monitor.md`

Status: accepted as factual failed-run evidence; release build remains blocked

## Review Scope

Codex reviewed the persisted Reasonix monitor report for `Build` workflow_dispatch run `26712487951`.

Codex also performed direct read-only checks using:

- `gh run view 26712487951 -R CometDash77/PiliAvalon-Worksite --json databaseId,url,headSha,event,status,conclusion,createdAt,updatedAt,jobs`
- local inspection of `android/build.gradle.kts`, `android/settings.gradle.kts`, and `pubspec.lock`

Codex did not download APKs, publish a release, or inspect unpersisted Reasonix chat.

## Accepted Factual Findings

The Reasonix report is internally consistent and agrees with direct Codex checks:

- Run `26712487951` was a `Build` workflow_dispatch run on `phase-1-shielding-core`.
- The run head SHA was `a5d0d075cd80a35173355a52133057c7cec1679b`.
- The run completed with conclusion `failure`.
- The `Write key` step passed, proving the four signing secrets are now configured.
- The `Flutter Build Release Apk` step failed while evaluating `screen_brightness_android` v2.1.5.
- No release APK artifacts were produced.
- No `Android_signing_evidence` artifact was produced.
- No `apksigner verify --print-certs` evidence was captured.
- No release/pre-release was created for this run.

The release build failure changes the prior x86_64-only interpretation. `screen_brightness_android` is now confirmed as a release-build blocker, not only a dev APK / emulator-smoke blocker.

## Root Cause

`screen_brightness_android` v2.1.5 conditionally skips applying `kotlin-android` for AGP 9+, then still calls the `kotlin {}` Gradle DSL. This project uses AGP `9.0.1`, so the plugin's `kotlin {}` call fails with:

```text
Could not find method kotlin() for arguments [...] on project ':screen_brightness_android'
```

## Decision

The earlier decision not to adopt the Gradle workaround is superseded by this new release-build evidence.

Codex is adopting the minimal Gradle workaround in `android/build.gradle.kts`: apply `org.jetbrains.kotlin.android` to Android application/library subprojects via `plugins.withId(...)` before third-party plugin evaluation reaches `kotlin {}`.

## Release Gate Decision

Run `26712487951` does not close any release gate.

Still open:

- release APK artifact evidence
- `Android_signing_evidence`
- `apksigner verify --print-certs`
- real-device cover-install
- user manual retest
- Phase 1 green/accepted/complete status

After the Gradle workaround is pushed, the next required evidence is a new `Build` workflow_dispatch monitor report showing whether APK artifacts and signing evidence are produced.
