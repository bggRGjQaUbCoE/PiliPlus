Audience classification: agent-facing.

# Phase 1 Main Merge Session Report

Date: 2026-06-04
Task: `task-009`
Repository: `CometDash77/PiliAvalon-Worksite`
Worksite path: `/home/mo/Documents/piliavalon`
Branch: `merge/upstream-then-phase1`
Pull requests:
- Initial PR with state mismatch: https://github.com/CometDash77/PiliAvalon-Worksite/pull/2
- Final verified PR: https://github.com/CometDash77/PiliAvalon-Worksite/pull/3

## Goal

Prepare the accepted Phase 1 shielding work for merge into product `main`, while preserving the release and governance boundary:

- Work only in `/home/mo/Documents/piliavalon`.
- Do not modify design-institute files.
- Do not push to `upstream` / PiliPlus.
- Do not publish a GitHub Release.
- Do not promote `phase-1-prebuild.26799023288` to stable/latest.
- Do not start Phase 2, `task-015`, or `task-010`.

## Current Status

`task-009` is merged to product `main` and verified by Git ancestry.

- Current branch: `merge/upstream-then-phase1`
- Current pushed head before the PR state-mismatch repair: `3b7e53e9e302212831d4e491b7ab698fca33110e`
- Repaired branch head merged by PR `#3`: `8a958e0d2e85e59b0a577cc4bb52976516e5f6cb`
- Final `origin/main` merge commit: `3dc5ade21255fa61925a0c39bcffaaa3e7e31c98`
- Base product commit included in branch history: `508384c01`
- Phase 1 merge commit: `3d6979a0b`
- Dependency lock repair commit: `c1ecf8196`
- Current-main API drift repair commit: `a575617b4`
- Runtime smoke robustness commits:
  - `64695bbf0` (`Harden runtime smoke against launcher ANR`)
  - `4471a225c` (`Close launcher ANR dialog during smoke retry`)
- Pull request created: https://github.com/CometDash77/PiliAvalon-Worksite/pull/2
- Pull request created after PR state mismatch: https://github.com/CometDash77/PiliAvalon-Worksite/pull/3
- Main merge completed: yes. `origin/main` contains repaired Phase 1 head `8a958e0d2e85e59b0a577cc4bb52976516e5f6cb`.
- Verification command passed: `git merge-base --is-ancestor 8a958e0d2e85e59b0a577cc4bb52976516e5f6cb origin/main`.
- Earlier Phase 1 evidence head also passed ancestry verification: `git merge-base --is-ancestor 3b7e53e9e302212831d4e491b7ab698fca33110e origin/main`.

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
| `git diff --check` | 0 | No whitespace errors in the repaired merge. |
| `rg -n "<<<<<<<\|=======\|>>>>>>>" android/app/src/main/kotlin/com/example/piliplus/MainActivity.kt` | 1 | No conflict markers remained in the resolved file. |

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

## PR State Mismatch And Repair

PR `#2` was manually confirmed and GitHub reported it as merged:

- URL: https://github.com/CometDash77/PiliAvalon-Worksite/pull/2
- `mergedAt`: `2026-06-04T07:56:26Z`
- Reported merge commit: `b43446b3807e33092178d9fc2a8a5c9d6015359b`

After that PR state, Codex fetched and inspected the remote Git topology. The observed remote refs did not prove Phase 1 was in product `main`:

- `origin/main`: `cd367a8649ed1f2bed7000d5e4bcb7096a811bc5`
- `origin/merge/upstream-then-phase1`: `3b7e53e9e302212831d4e491b7ab698fca33110e`
- Observed merge base remained `508384c016a0235d27515851ab432ed00523b718`.

Conclusion: the user's PR confirmation was preserved as a real PR event, but Codex could not claim `task-009` merged until remote `main` contained the Phase 1 head by Git ancestry.

The current `origin/main` drift that had to be merged back into `merge/upstream-then-phase1` was:

- `af1cd30ed` `opt video bottomsheet`
- `7b01c3365` `more fab anim`
- `f63777152` `android patch`
- `cd367a864` `Release 2.0.8`

Merge conflict:

- File: `android/app/src/main/kotlin/com/example/piliplus/MainActivity.kt`
- Resolution: use the current `origin/main` `AndroidHelper` architecture as the baseline, keep `AndroidHelper.ToDart.onConfigurationChanged?.run()`, `AndroidHelper.ToDart.onUserLeaveHint?.run()`, `AndroidHelper.isPipMode = isInPictureInPictureMode`, `onCreate` cutout mode, and `onDestroy` audio-service stop.
- Removed behavior: did not restore the old `io.flutter.SystemChrome` import or old `MethodChannel` `SystemChrome` bridge, because current `origin/main` removed `android/app/src/main/java/io/flutter/SystemChrome.java`.

Repair merge commit:

- Commit: `8a958e0d2e85e59b0a577cc4bb52976516e5f6cb`
- Message: `Merge current main after PR state mismatch`

## Repaired CI And PR Evidence

Repaired Phase 1 CI:

- Run: `26939753449`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26939753449
- Result: success
- Jobs:
  - `Focused Flutter verification` (`79478052023`): success
  - `Build Android x86_64 artifact` (`79478340844`): success
  - `Android emulator runtime smoke` (`79479274871`): success

Final PR:

- PR: https://github.com/CometDash77/PiliAvalon-Worksite/pull/3
- Base: `main`
- Head: `merge/upstream-then-phase1`
- Head commit: `8a958e0d2e85e59b0a577cc4bb52976516e5f6cb`
- State: merged
- `mergedAt`: `2026-06-04T08:52:08Z`
- Merge commit: `3dc5ade21255fa61925a0c39bcffaaa3e7e31c98`

PR Build:

- Run: `26940323567`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26940323567
- Result: success
- Jobs:
  - `Release Android` (`79479944570`): success
  - `ios / Release IOS` (`79479944653`): success
  - `win_x64 / Release Windows x64` (`79479944587`): success
  - `mac` (`79479944968`): skipped
  - `linux_x64` (`79479945068`): skipped

Post-merge verification:

- `git fetch origin main merge/upstream-then-phase1` updated `origin/main` from `cd367a8649ed1f2bed7000d5e4bcb7096a811bc5` to `3dc5ade21255fa61925a0c39bcffaaa3e7e31c98`.
- `git merge-base --is-ancestor 8a958e0d2e85e59b0a577cc4bb52976516e5f6cb origin/main` passed.
- `git merge-base --is-ancestor 3b7e53e9e302212831d4e491b7ab698fca33110e origin/main` passed.
- Final conclusion: Phase 1 is now truly in product `main`.

## User Feedback

Raw user feedback preserved:

```text
x86编译失败可以不管
```

Codex interpretation: the user would accept x86_64 compilation as a yellow gate if it failed. This exception was not needed for the final evidence because run `26937873673` passed x86_64 APK build/upload and Android emulator runtime smoke.

## PR Status

PR `#2` was created and manually confirmed, but its reported merged state did not match the remote `main` Git topology when inspected after the event:

- URL: https://github.com/CometDash77/PiliAvalon-Worksite/pull/2
- Base: `main`
- Head: `merge/upstream-then-phase1`
- Title: `Merge Phase 1 shielding into main`
PR `#3` is the final verified merge PR:

- URL: https://github.com/CometDash77/PiliAvalon-Worksite/pull/3
- Base: `main`
- Head: `merge/upstream-then-phase1`
- Title: `Merge Phase 1 shielding into main after PR state mismatch`
- Merge commit: `3dc5ade21255fa61925a0c39bcffaaa3e7e31c98`

Release state: no release was created.
Stable/latest state: no tag was promoted.

## Known Risks And Yellow Items

- No open `task-009` main-merge gate remains; Phase 1 is verified in `origin/main`.
- Local Flutter validation remains unavailable because `flutter` is not installed locally.
- GitHub Actions emitted a Node.js 20 deprecation warning for `actions/download-artifact@v6`; this did not fail the run, but should be tracked before GitHub's Node.js 20 removal window.
- Untracked `.codex/skills/` existed before this record work and was left untouched.

## Next Step

`task-009` main merge is complete. Do not start Phase 2, `task-015`, `task-010`, release publication, or stable/latest tag promotion from this session report alone.
