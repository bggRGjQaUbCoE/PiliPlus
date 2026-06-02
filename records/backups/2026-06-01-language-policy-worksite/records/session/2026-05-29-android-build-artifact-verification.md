# Android Build Artifact Verification

- role: worksite-verification
- session id: 2026-05-29-android-build-artifact-verification
- date: 2026-05-29
- repo root: `/home/mo/Documents/piliavalon`
- branch: `phase-1-shielding-core`
- writable GitHub repo: `CometDash77/PiliAvalon-Worksite`

## Scope

This record covers Android build artifact evidence only. It does not close
Android install/launch or manual recommendation/comment acceptance.

All GitHub CLI commands were explicitly scoped with:

```text
-R CometDash77/PiliAvalon-Worksite
```

## Local Tool Availability

Local Android runtime verification could not be run in this shell:

```text
command -v flutter
exit 1

command -v adb
exit 1

command -v java
exit 1
```

## Workflow Dispatch

Command:

```text
gh workflow run build.yml --ref phase-1-shielding-core -f build_android=true -f build_ios=false -f build_mac=false -f build_win_x64=false -f build_linux_x64=false -f tag= -R CometDash77/PiliAvalon-Worksite
```

Run evidence:

- workflow: `Build`
- run id: `26628409138`
- run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26628409138`
- job URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26628409138/job/78470780117`
- branch: `phase-1-shielding-core`
- event: `workflow_dispatch`
- commit SHA: `cf9ed10f0ce1c8c71925fd72e014d890ddcea221`
- conclusion: `success`
- job: `Release Android`
- duration: `11m47s`

Step results:

| Step | Conclusion |
|---|---|
| Checkout | success |
| Setup Java | success |
| Setup Flutter | success |
| Apply Patch | success |
| Write key | success |
| Set and Extract version | success |
| Flutter Build Release Apk | success |
| Flutter Build Dev Apk | skipped |
| Rename | success |
| Release | skipped |
| Upload Android arm64-v8a | success |
| Upload Android armeabi-v7a | success |
| Upload Android x86_64 | success |

Non-Android jobs were skipped by workflow inputs:

- `ios`
- `mac`
- `linux_x64`
- `win_x64`

## Remaining Runtime Evidence

Still yellow:

- Android install/launch.
- recommendation feed manual acceptance.
- comment-area manual acceptance.
