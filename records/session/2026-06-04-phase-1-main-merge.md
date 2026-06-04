Audience classification: agent-facing.

# Phase 1 Main Merge Session Report

Date: 2026-06-04
Task: `task-009`
Repository: `CometDash77/PiliAvalon-Worksite`
Worksite path: `/home/mo/Documents/piliavalon`
Branch: `merge/upstream-then-phase1`
Pull request: https://github.com/CometDash77/PiliAvalon-Worksite/pull/2

## Goal

Prepare the accepted Phase 1 shielding work for merge into product `main`, while preserving the release and governance boundary:

- Work only in `/home/mo/Documents/piliavalon`.
- Do not modify design-institute files.
- Do not push to `upstream` / PiliPlus.
- Do not publish a GitHub Release.
- Do not promote `phase-1-prebuild.26799023288` to stable/latest.
- Do not start Phase 2, `task-015`, or `task-010`.

## Current Status

`task-009` is ready for PR review.

- Current branch: `merge/upstream-then-phase1`
- Current pushed head before this record commit: `4471a225c29be4188ae74be7b5b899435668775b`
- Base product commit included in branch history: `508384c01`
- Phase 1 merge commit: `3d6979a0b`
- Dependency lock repair commit: `c1ecf8196`
- Current-main API drift repair commit: `a575617b4`
- Runtime smoke robustness commits:
  - `64695bbf0` (`Harden runtime smoke against launcher ANR`)
  - `4471a225c` (`Close launcher ANR dialog during smoke retry`)
- Pull request created: https://github.com/CometDash77/PiliAvalon-Worksite/pull/2
- Main merge completed: no. The branch is open for PR review and has not been merged to `main`.

## Repository Identity

- `origin`: `git@github.com:CometDash77/PiliAvalon-Worksite.git`
- `upstream`: `https://github.com/bggRGjQaUbCoE/PiliPlus.git`
- `upstream` push URL: `DISABLED`
- Additional read-only remotes:
  - `pilinara`: `https://github.com/Starfallan/PiliNara.git` with disabled push
  - `pilisuper`: `https://github.com/FRBLanApps/PiliSuper.git` with disabled push

All GitHub CLI commands used for run/PR evidence were scoped with `-R CometDash77/PiliAvalon-Worksite`.

## Local Validation

| Command | Exit status | Result |
|---|---:|---|
| `git status --short --branch` | 0 | Branch is `merge/upstream-then-phase1`; untracked `.codex/skills/` existed before this record work; this report was untracked until committed. |
| `command -v flutter` | 1 | Local Flutter is unavailable in this environment. |
| `bash -n .github/scripts/android_runtime_smoke.sh` | 0 | Runtime smoke script syntax passed. |

Local Flutter test/analyze could not be run because `flutter` is not installed on this machine.

## CI Run History

| Run ID | Head / scope | Result | Notes |
|---:|---|---|---|
| `26935400763` | early `merge/upstream-then-phase1` | failed | Focused verification failed at `Verify dependency lock is clean`; downstream x86/runtime jobs did not run. |
| `26935669982` | after lock repair | failed | Dependency lock gate passed; shielding tests failed (`0 tests passed, 6 failed`). |
| `26936062323` | `a575617b4` API drift repair | failed | Focused Flutter verification passed; x86_64 APK build/upload passed; Android runtime smoke failed with exit code `110`. Evidence showed APK install and `am start -W` succeeded, `app-crash-error.txt` was empty, and the failure was at runtime-smoke/emulator UI visibility (`uiautomator_xml_missing_app_package`) with launcher/system ANR evidence. |
| `26937225591` | `64695bbf0` first smoke hardening | failed | Focused Flutter verification passed; x86_64 APK build/upload passed; Android runtime smoke still failed with exit code `110` / `uiautomator_xml_missing_app_package`. |
| `26937873673` | `4471a225c` final smoke hardening | passed | Focused Flutter verification passed in 2m12s; x86_64 APK build/upload passed in 6m7s; Android emulator runtime smoke passed in 2m29s. |

Final green run:

- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26937873673
- Jobs:
  - `Focused Flutter verification` (`79471873113`): pass
  - `Build Android x86_64 artifact` (`79472205533`): pass
  - `Android emulator runtime smoke` (`79473136579`): pass
- Artifacts:
  - `Android_x86_64`
  - `android-runtime-smoke-evidence`
- Runtime evidence artifact URL from job log: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26937873673/artifacts/7405870771
- Runtime smoke evidence downloaded for inspection to `/tmp/piliavalon-task009-26937873673/android-runtime-smoke-evidence`.

## Final Runtime Smoke Evidence

Downloaded evidence files from run `26937873673`:

- `adb-install.txt`
- `adb-launch.txt`
- `app-crash-error.txt`
- `launcher-component.txt`
- `launcher-resolution.txt`
- `logcat-crash-error.txt`
- `logcat.txt`
- `pidof.txt`
- `runtime-smoke-metadata.txt`
- `screenshot-blankness.txt`
- `screenshot.png`
- `status.txt`
- `uiautomator-dump.txt`
- `uiautomator-pull.txt`
- `uiautomator.xml`
- `window.txt`

Key evidence:

```text
status=0
result=pass
```

```text
artifact_run_id=26937873673
apk=runtime-smoke/apk/PiliAvalon_android_ci_4471a225c29b_x86_64.apk
package_name=com.example.piliplus.dev
github_sha=4471a225c29be4188ae74be7b5b899435668775b
github_ref=refs/heads/merge/upstream-then-phase1
15
sdk_gphone64_x86_64
```

`app-crash-error.txt` was zero bytes in the final passed smoke evidence.

## User Feedback

Raw user feedback preserved:

```text
x86编译失败可以不管
```

Codex interpretation: the user would accept x86_64 compilation as a yellow gate if it failed. This exception was not needed for the final evidence because run `26937873673` passed x86_64 APK build/upload and Android emulator runtime smoke.

## PR Status

PR `#2` was created for review:

- URL: https://github.com/CometDash77/PiliAvalon-Worksite/pull/2
- Base: `main`
- Head: `merge/upstream-then-phase1`
- Title: `Merge Phase 1 shielding into main`
- Release state: no release was created.
- Stable/latest state: no tag was promoted.

## Known Risks And Yellow Items

- The PR is not merged to `main`; final `main` integration remains pending review and merge.
- Local Flutter validation remains unavailable because `flutter` is not installed locally.
- GitHub Actions emitted a Node.js 20 deprecation warning for `actions/download-artifact@v6`; this did not fail the run, but should be tracked before GitHub's Node.js 20 removal window.
- Untracked `.codex/skills/` existed before this record work and was left untouched.

## Next Step

Review PR `#2` and decide whether to merge `merge/upstream-then-phase1` into `main`. Do not start Phase 2 or release work from this session report alone.
