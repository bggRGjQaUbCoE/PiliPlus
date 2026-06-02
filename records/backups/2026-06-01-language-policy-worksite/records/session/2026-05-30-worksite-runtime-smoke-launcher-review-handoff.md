# Worksite Runtime Smoke Launcher Review Handoff

Date: 2026-05-30
Recorded at: 2026-05-30T22:20:00+08:00

## Scope

This handoff gives the worksite the next evidence-review action after the
launcher fix in commit `300112080`. It is documentation and governance only; it
does not approve a release package.

## Reviewed Commit

```text
300112080 ci: resolve runtime smoke launcher activity
```

## Next Action

Inspect GitHub Actions run `26686476869` only after it has completed and only
through its uploaded runtime-smoke evidence. Do not treat workflow completion,
artifact existence, or a zero exit code alone as manual-acceptance approval.

Required evidence files:

- `launcher-component.txt`
- `launcher-resolution.txt`
- `adb-install.txt`
- `adb-launch.txt`
- `window.txt`
- `uiautomator.xml`
- `logcat.txt`
- `app-crash-error.txt`
- `screenshot.png`
- `screenshot-blankness.txt`
- `pidof.txt`
- `status.txt`

## Pass Rules

Runtime smoke may be accepted only if the evidence shows all of the following:

- APK install succeeded.
- Launcher resolution selected a valid component, or the manifest fallback
  launched `com.example.piliplus.MainActivity` for package
  `com.example.piliplus.dev`.
- `adb-launch.txt` shows a successful launch.
- `window.txt` and `uiautomator.xml` show the app in foreground UI.
- `screenshot.png` and `screenshot-blankness.txt` do not indicate a blank or
  white-screen launch.
- `logcat.txt` and `app-crash-error.txt` show no app crash or ANR.
- `pidof.txt` shows the app process exists after launch.
- `status.txt` records a passing smoke status.

## Fail Rules

Runtime smoke remains failed or blocked if any of the following are true:

- The APK does not install.
- No valid launcher-resolved or manifest fallback component is launched.
- The launch command fails.
- The app is not foregrounded.
- Evidence shows a crash, ANR, white screen, blank screenshot, or missing app
  process.
- Any required evidence file is missing or incomplete.
- The run completed but evidence artifacts were not reviewed.

## Release Gate

Do not publish, relabel, or hand off a new manual-acceptance APK before runtime
smoke passes and the evidence files above are reviewed.

The latest valid manual-acceptance baseline remains:

```text
phase-1-prebuild.26680259984
```

No package from run `26686476869` or commit `300112080` supersedes that
baseline unless a later record explicitly accepts the completed runtime-smoke
run after full evidence review.
