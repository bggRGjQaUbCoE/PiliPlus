# Phase 1 Release Build 26712728281 Monitor — Signing Evidence

Date: 2026-05-31
Review owner: Codex
Monitor target: Build workflow_dispatch run `26712728281`
Head SHA: `f868d6206a23fb77de424c9e45cfbc0aa618b0fa`

Status: **FAILED** — candidate monitor evidence only. Does not close any release gate.

---

## 1. Reading Scope

Files and data consulted:

- `.github/workflows/build.yml` (at local HEAD — includes signing-evidence steps)
- `gh run view 26712728281` — run identity
- `gh run watch 26712728281` — live completion monitoring (~10m 33s)
- `gh api .../jobs` — job and step-level results
- `gh api .../artifacts` — artifact inventory
- `gh run view --log --job 78725777900` — full Release Android job log
- `git rev-parse HEAD` — local HEAD
- Prior monitor reports:
  - `records/reasonix/monitor/2026-05-31-phase-1-release-build-workflow-dispatch-monitor.md` (run `26680259984`)
  - `records/reasonix/monitor/2026-05-31-phase-1-release-build-26711811133-monitor.md` (secrets missing)
  - `records/reasonix/monitor/2026-05-31-phase-1-release-build-26712487951-monitor.md` (`screen_brightness_android` kotlin() error)
- Commit context: `f868d6206` adds Gradle workaround for `screen_brightness_android`

---

## 2. Run Identity

| Field | Value |
|---|---|
| Run ID | `26712728281` |
| URL | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26712728281 |
| Event | `workflow_dispatch` |
| Branch | `phase-1-shielding-core` |
| Head SHA | `f868d6206a23fb77de424c9e45cfbc0aa618b0fa` |
| Workflow | Build |
| Status | `completed` |
| Conclusion | **`failure`** |
| Created | 2026-05-31T12:33:52Z |
| Updated | 2026-05-31T12:44:25Z |
| Duration | ~10m 33s |

---

## 3. Job Results

### Release Android — `failure`

| Step # | Step Name | Conclusion | Notes |
|---|---|---|---|
| 1 | Set up job | success | |
| 2 | 代码迁出 | success | |
| 3 | 构建Java环境 | success | |
| 4 | 安装Flutter | success | |
| 5 | Apply Patch | success | |
| **6** | **Write key** | **✅ success** | Secrets decoded to `key.jks` |
| 7 | Set and Extract version | success | Version: `2.0.7-f868d6206+5047` |
| **8** | **Flutter Build Release Apk** | **❌ failure** | Gradle built ~560s but APK signing failed: keystore password incorrect |
| 9 | Flutter Build Dev Apk | skipped | blocked |
| 10 | Rename | skipped | blocked |
| 11 | Capture Android signing fingerprints | skipped | blocked |
| 12 | Resolve release tag | skipped | blocked |
| 13 | Release | skipped | blocked |
| 14–16 | 上传 (3× APK) | skipped | blocked |
| 17 | 上传签名证据 | skipped | blocked |
| 32–35 | Post/Cleanup steps | success | |

### Other Jobs

| Job | Conclusion |
|---|---|
| ios | skipped |
| mac | skipped |
| linux_x64 | skipped |
| win_x64 | skipped |

---

## 4. Write key — Passed ✅

The `Write key` step passed with all four secrets resolving to non-empty redacted values (`***`). The `key.jks` file was decoded from `SIGN_KEYSTORE_BASE64` and written to `android/app/key.jks`.

---

## 5. Flutter Build Release Apk — Failed ❌

### screen_brightness_android kotlin() error: GONE ✅

The Gradle workaround at commit `f868d6206` successfully resolved the `kotlin()` method error. Evidence:

- Previous run (`26712487951`): `FAILURE: Build failed with an exception. ... Could not find method kotlin() ... screen_brightness_android`
- This run: **No kotlin() error.** The Gradle build progressed through dependency resolution, compilation, and reached the APK packaging/signing stage.

A Kotlin KGP deprecation warning was emitted for 15 plugins including `screen_brightness_android`, but this is non-fatal.

### New failure: Keystore password incorrect ❌

The build failed at the APK signing stage with:

```
FAILURE: Build failed with an exception.

> Multiple task action failures occurred:
   > A failure occurred while executing
     com.android.build.gradle.tasks.PackageAndroidArtifact$IncrementalSplitterRunnable
     > com.android.ide.common.signing.KeytoolException:
       Failed to read key *** from store
       "/home/runner/work/PiliAvalon-Worksite/PiliAvalon-Worksite/android/app/key.jks":
       Keystore was tampered with, or password was incorrect

   (repeated for all 3 ABIs — arm64-v8a, armeabi-v7a, x86_64)

Gradle task assembleRelease failed with exit code 1
```

**Interpretation:** The keystore file (`key.jks`) was successfully decoded from `SIGN_KEYSTORE_BASE64`, but the password used to unlock it is incorrect. Either `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, or both are wrong. The Gradle build completed all compilation and reached the final APK signing step.

### Non-fatal warning noted

During the build, a non-fatal exception was logged:
```
Caught exception: Already watching path: /home/runner/work/.../android
```
This is a Flutter tooling file-watcher issue unrelated to the build failure.

---

## 6. screen_brightness_android kotlin() Error Status

| Run | Commit | Error |
|---|---|---|
| `26712487951` | `a5d0d075c` | ❌ `Could not find method kotlin()` |
| **`26712728281`** | **`f868d6206`** | **✅ RESOLVED** |

The Gradle workaround (`org.jetbrains.kotlin.android` applied to subprojects) at commit `f868d6206` successfully eliminated the `screen_brightness_android` `kotlin()` error.

---

## 7. Release APK Artifact Inventory

**No artifacts were produced.** The build failed at the APK signing stage (after compilation but before APK output).

| ABI | Status |
|---|---|
| arm64-v8a | ❌ Not produced (signing failed) |
| armeabi-v7a | ❌ Not produced (signing failed) |
| x86_64 | ❌ Not produced (signing failed) |

---

## 8. Release / Pre-release Asset Inventory

**No release was created.** The `Release` step was skipped.

---

## 9. Android_signing_evidence Artifact Status

**Not present.** The `Capture Android signing fingerprints` (step 11) and `上传签名证据` (step 17) steps were skipped.

---

## 10. apksigner verify --print-certs Output

**Not available.** No APKs were produced.

---

## 11. Cover-install Requirements File Status

**Not present.** Would be generated by step 11 if build had succeeded.

---

## 12. Risks

| Risk | Severity | Detail |
|---|---|---|
| Keystore password incorrect | **Critical** | The `key.jks` was decoded correctly, but `KEYSTORE_PASSWORD` and/or `KEY_PASSWORD` are wrong. The Gradle keystore loader rejects them. All three ABI APK signing attempts failed identically. |
| No APKs available for cover-install | **High** | No signed release APKs exist from any Build run since `80f5e6d6a`. Run `26680259984` APKs may be unsigned (soft-fail Write key). |
| `screen_brightness_android` fixed but pipeline still blocked | **Medium** | The Gradle fix works, but a new blocker (keystore password) was revealed immediately after. |
| Kotlin KGP deprecation warnings | **Low** | 15 plugins emit KGP warnings. Non-fatal but indicates future compatibility risk with newer Flutter/Gradle. |
| Positive: Gradle workaround works | **Positive** | The `screen_brightness_android` fix at `f868d6206` is validated — the `kotlin()` error is resolved. |
| Positive: Secrets decoding works | **Positive** | `SIGN_KEYSTORE_BASE64` → `key.jks` decoding is correct. |

---

## 13. Unknowns

1. **Which password is wrong.** The error "Keystore was tampered with, or password was incorrect" could mean:
   - `KEYSTORE_PASSWORD` (keystore file password) is wrong
   - `KEY_PASSWORD` (key alias password) is wrong
   - Both are wrong

2. **Whether the keystore file itself is valid.** The `base64 --decode` step succeeded, but the resulting JKS file could be corrupted or from a different keystore format.

3. **Source of the keystore.** The user mentioned `C:\Users\77182\.codex\memories\PiliAvalon-release-signing` — is this the keystore that was base64-encoded? Were the passwords correctly transferred?

4. **Whether run `26680259984` APKs are signed.** Those APKs exist but their signing status is unknown.

---

## 14. Verification Results

| Check | Result |
|---|---|
| Run identity confirmed | ✅ `26712728281`, workflow_dispatch, `f868d6206` |
| Run completed | ✅ `completed`, `failure` (10m 33s) |
| Write key passed | ✅ Secrets decoded to `key.jks` |
| `screen_brightness_android` kotlin() error | ✅ **RESOLVED** by Gradle workaround |
| Gradle build reached signing stage | ✅ Compilation completed (560s) |
| APK signing | ❌ Failed — keystore password incorrect (×3 ABIs) |
| APK artifacts produced | ❌ None |
| Android_signing_evidence artifact | ❌ Not present |
| apksigner verify --print-certs | ❌ Not captured |
| Release created | ❌ None |
| Kotlin KGP warnings (15 plugins) | ⚠️ Non-fatal |

---

## 15. Client/User Decision Needed

**Yes.** The following decisions are needed:

1. **Fix the keystore password.** The `key.jks` file decodes correctly but the password is wrong. Verify and correct `KEYSTORE_PASSWORD` and/or `KEY_PASSWORD` in the GitHub repo's Actions secrets. The keystore file itself appears valid (successful decode, no base64 errors).

2. **Local verification suggested.** Before updating secrets, run locally to confirm the keystore and its passwords:
   ```
   keytool -list -v -keystore <keystore.jks> -storepass <storepass>
   ```
   This would confirm whether the keystore is valid and the passwords work before encoding for GitHub.

3. **Re-trigger Build workflow_dispatch after password fix.** The pipeline is now structurally proven:
   - ✅ Write key (secrets decode)
   - ✅ Gradle compilation (screen_brightness_android fixed)
   - ❌ APK signing (password mismatch — last remaining blocker)

   Once the password is fixed, the full pipeline should produce APKs + signing evidence.

4. **Release gates remain open.** The four-run progression shows incremental progress:
   - `26680259984`: APKs produced, no signing evidence (old workflow)
   - `26711811133`: Secrets missing (blocked at Write key)
   - `26712487951`: Secrets OK, Gradle broken (blocked at kotlin())
   - **`26712728281`**: Secrets OK, Gradle fixed, **keystore password wrong** (blocked at signing)

   Release evidence still needs: successful signed APK build → signing evidence capture → Codex review → user cover-install → user manual retest.

---

*This artifact is candidate monitor evidence only. Release decisions require Codex review of this persisted artifact, a successful Build run after the keystore password fix, plus separate user cover-install and manual retest evidence.*
