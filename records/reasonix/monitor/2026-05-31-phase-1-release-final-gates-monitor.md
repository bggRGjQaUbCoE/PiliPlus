# Phase 1 Release Final Gates — Monitor Report

**Generated:** 2026-05-31 ~10:45 UTC
**Monitor role:** `monitor-release-build-phase1-final-gates`
**Review owner:** Codex

---

## 1. Target

| Field | Value |
| --- | --- |
| Repository | `CometDash77/PiliAvalon-Worksite` |
| Branch | `phase-1-shielding-core` |
| Commit | `2ed9c8bebff0657b39c5b674eb34a88f0e05d1fa` |
| Commit message | `record phase 1 ci x86 decision` |
| Author | CometDash Worksite |
| Expected workflow | **Build** (workflow_dispatch) |

---

## 2. Build workflow_dispatch status

**Not triggered.** No `Build` workflow_dispatch run exists for commit `2ed9c8b`.

The only run for this commit is a push-triggered **Phase 1 CI** run.

| Run ID | Name | Event | Status | Conclusion | Created |
| --- | --- | --- | --- | --- | --- |
| [26710277634](https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26710277634) | Phase 1 CI | push | completed | **failure** | 2026-05-31T10:36:32Z |

---

## 3. Phase 1 CI run — job/step details

### Job: Focused Flutter verification (ID 78719106880) — ✅ success

All 12 steps passed:
- Set up job, Checkout, Setup Flutter, Flutter version, Install dependencies
- Run shielding tests, Run settings model test, Run bootstrap startup test
- Analyze
- Post-cleanup steps

### Job: Build Android x86_64 artifact (ID 78719219441) — ❌ failure

| Step | Conclusion |
| --- | --- |
| Set up job | success |
| Checkout | success |
| Setup Java | success |
| Setup Flutter | success |
| Install dependencies | success |
| **Build x86_64 APK** | **failure** |
| Stage x86_64 APK | skipped |
| Upload x86_64 APK | skipped |
| Post steps | success |

**Failure cause:**

```
FAILURE: Build failed with an exception.
Could not find method kotlin() for arguments [...] on project
':screen_brightness_android' of type org.gradle.api.Project.
BUILD FAILED in 44s
```

Root cause: The `kotlin()` Gradle DSL method is unavailable for the `:screen_brightness_android` subproject — the Kotlin Gradle plugin is not applied at a scope where that project can resolve it. This is a Gradle configuration issue in the `screen_brightness_android` plugin, not a shielding logic defect.

### Job: Android emulator runtime smoke (ID 78719356635) — ⏭️ skipped

This job depends on `android-x86-64` (Job 2). Since the build failed, the smoke job was skipped entirely. No steps executed.

---

## 4. Artifacts

### Phase 1 CI run (target commit): **zero artifacts**

The `Build x86_64 APK` step failed, so no APK was produced. The `Upload x86_64 APK` step was skipped.

### Most recent successful Build workflow_dispatch (reference)

Run [#26707279023](https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26707279023) (branch `phase-1-shielding-acceptance-fixes`, commit `eda5bee7`) produced:

| Artifact ID | Name | Size |
| --- | --- | --- |
| 7315162860 | `PiliAvalon_android_2.0.7-eda5bee71+5041_x86_64.apk` | 25.5 MB |
| 7315162710 | `PiliAvalon_android_2.0.7-eda5bee71+5041_armeabi-v7a.apk` | 24.4 MB |
| 7315162555 | `PiliAvalon_android_2.0.7-eda5bee71+5041_arm64-v8a.apk` | 24.5 MB |

**Note:** This Build run used the `main` branch's `build.yml` (which lacks the signing-evidence step). The `phase-1-shielding-core` branch's `build.yml` adds the signing evidence capture but has never been exercised via workflow_dispatch.

---

## 5. Android_signing_evidence artifact

### Workflow definition

The `build.yml` on `phase-1-shielding-core` (SHA `34453b8`) includes:

- **"Capture Android signing fingerprints"** step — runs `apksigner verify --print-certs` on each APK, saves to `signing-evidence/`
- **"上传签名证据"** (Upload signing evidence) step — uploads `Android_signing_evidence` artifact

Both are conditional: `if: github.event_name == 'workflow_dispatch'`

### Current availability: **Not available**

- Search for artifacts matching "sign" across all repo artifacts: **zero results**
- The Build workflow has never been dispatched on the `phase-1-shielding-core` branch
- Without a Build workflow_dispatch run, the `apksigner verify --print-certs` evidence does not exist

---

## 6. Runtime smoke evidence

### Phase 1 CI (target commit): **Not available**

The `Android emulator runtime smoke` job was skipped (build dependency failed).

### Standalone Android Runtime Smoke workflow_dispatch

Most recent: Run [#26707550380](https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26707550380) (branch `phase-1-shielding-acceptance-fixes`, commit `eda5bee7`):

| Artifact ID | Name | Size |
| --- | --- | --- |
| 7315187616 | `android-runtime-smoke-evidence` | 2.1 MB |

This was triggered against a **different commit** (`eda5bee7`), not the target commit `2ed9c8b`.

The standalone `Android Runtime Smoke` workflow accepts an `artifact_run_id` input to download an APK from a prior Build run. For it to work against the target commit, the Build workflow must first succeed and produce an `Android_x86_64` artifact.

---

## 7. User-device cover-install / manual retest gate

### Status: **Pending — blocked on Build workflow_dispatch**

The cover-install gate requires:
1. A successful **Build** workflow_dispatch run on `phase-1-shielding-core` that:
   - Produces signed APKs via the `Write key` step (uses `SIGN_KEYSTORE_BASE64` + keystore secrets)
   - Generates `Android_signing_evidence` artifact with `apksigner verify --print-certs` output
   - Produces `cover-install-requirements.txt` documenting: same `applicationId`, same signing fingerprint, install-without-uninstall capability
2. User verification on their device: install the APK over the existing release app without uninstall

### Blockers to clear before this gate can be exercised:
1. **Fix the Gradle Kotlin plugin issue** — `:screen_brightness_android` cannot resolve `kotlin()` method; likely needs the Kotlin Gradle plugin applied or the Plugin DSL adjusted
2. **Trigger Build workflow_dispatch** — once the build fix is pushed, dispatch the Build workflow on the target branch
3. **Verify secrets availability** — the `Write key` step now fails hard (exits 1) if any signing secret is missing (`SIGN_KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`)

---

## 8. Summary

| Gate | Status | Evidence |
| --- | --- | --- |
| Flutter verification (shielding tests, analyze) | ✅ Passed | Phase 1 CI job 78719106880 |
| Build Android x86_64 APK | ❌ Failed | Gradle `kotlin()` method not found |
| APK artifacts (any) | ❌ None | Build step failed; no artifacts uploaded |
| `Android_signing_evidence` artifact | ❌ Not generated | Build workflow_dispatch never triggered |
| `apksigner verify --print-certs` evidence | ❌ Not available | Requires Build workflow_dispatch on phase-1-shielding-core |
| Runtime smoke (CI-attached) | ⏭️ Skipped | Depends on failed build job |
| Runtime smoke (standalone) | ⚠️ Available for prior commit only | Run 26707550380, commit `eda5bee7` |
| Cover-install / manual retest gate | 🔒 Pending | Blocked on Build fix + workflow_dispatch |

**Bottom line:** The `Build` workflow_dispatch has **not been triggered** for the target commit. The Phase 1 CI build failed due to a Gradle/Kotlin plugin configuration issue in `screen_brightness_android`. No APK artifacts, no signing evidence, and no runtime smoke are available for commit `2ed9c8b`. The user-device cover-install gate remains pending.
