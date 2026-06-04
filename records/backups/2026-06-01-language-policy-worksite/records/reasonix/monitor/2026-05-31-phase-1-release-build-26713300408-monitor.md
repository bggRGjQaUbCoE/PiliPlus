# Phase 1 Release Build 26713300408 Monitor — Signing Evidence

Date: 2026-05-31
Review owner: Codex
Monitor target: Build workflow_dispatch run `26713300408`
Head SHA: `f868d6206a23fb77de424c9e45cfbc0aa618b0fa`

Status: **FAILED** (soft) — 16/17 steps passed. Only step 17 (`上传签名证据`) failed due to a workflow configuration bug (`archive: false` with multi-file glob). All APKs were built, signed, released, and uploaded as artifacts.

---

## 1. Reading Scope

Files and data consulted:

- `gh run view 26713300408` — run identity and step-level JSON results
- `gh run watch 26713300408` — live completion monitoring (~6 min, killed by timeout; run completed at ~7m)
- `gh api .../jobs` — job-level results (embedded in run view JSON)
- `gh api .../artifacts` — artifact inventory (3 APKs)
- `gh run view --log --job 78727341783` — full Release Android job log (956 lines)
- `git rev-parse HEAD` — local HEAD confirmation (`f868d6206`)
- `git status --short --branch` — confirms on `phase-1-shielding-core`
- Prior monitor report: `records/reasonix/monitor/2026-05-31-phase-1-release-build-26712728281-monitor.md` (previous run — keystore password failure)

---

## 2. Run Identity

| Field | Value |
|---|---|
| Run ID | `26713300408` |
| URL | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26713300408 |
| Event | `workflow_dispatch` |
| Branch | `phase-1-shielding-core` |
| Head SHA | `f868d6206a23fb77de424c9e45cfbc0aa618b0fa` |
| Workflow | Build |
| Status | `completed` |
| Conclusion | **`failure`** (1 failed step out of 17) |
| Created | 2026-05-31T13:00:03Z |
| Updated | 2026-05-31T13:07:11Z |
| Duration | ~7m 8s |
| Release Job ID | `78727341783` |

---

## 3. Job Results

### Release Android — `failure` (1/17 steps failed)

| Step # | Step Name | Conclusion | Notes |
|---|---|---|---|
| 1 | Set up job | ✅ success | Ubuntu 24.04, runner 2.334.0 |
| 2 | 代码迁出 | ✅ success | checkout@v6, fetch-depth: 0 |
| 3 | 构建Java环境 | ✅ success | Java Zulu JDK 17.0.19-10 |
| 4 | 安装Flutter | ✅ success | Flutter stable-3.44.0 |
| 5 | Apply Patch | ✅ success | 8 patches applied (overscroll revert + 7 flutter patches) |
| **6** | **Write key** | **✅ success** | All 4 secrets decoded; `key.jks` written; `key.properties` written |
| 7 | Set and Extract version | ✅ success | Version: `2.0.7-f868d6206+5046` |
| **8** | **Flutter Build Release Apk** | **✅ success** | Gradle `assembleRelease` ~331s; all 3 ABIs built |
| 9 | Flutter Build Dev Apk | ⏭ skipped | |
| **10** | **Rename** | **✅ success** | APKs renamed to `PiliAvalon_android_{version}_{abi}.apk` |
| **11** | **Capture Android signing fingerprints** | **✅ success** | apksigner verify --print-certs ran on all 3 APKs; 4 files created under `signing-evidence/` |
| **12** | **Resolve release tag** | **✅ success** | Tag: `phase-1-prebuild.26713300408` |
| **13** | **Release** | **✅ success** | GitHub Release created with 3 APK assets; prerelease=true |
| 14 | 上传 (arm64-v8a) | ✅ success | Artifact ID `7316968318`, 24.6 MB |
| 15 | 上传 (armeabi-v7a) | ✅ success | Artifact ID `7316968405`, 24.5 MB |
| 16 | 上传 (x86_64) | ✅ success | Artifact ID `7316968476`, 25.6 MB |
| **17** | **上传签名证据** | **❌ failure** | `archive: false` incompatible with 4 files matched by `signing-evidence/*` |
| 32–35 | Post/Cleanup steps | ✅ success | |

### Other Jobs

| Job | Conclusion |
|---|---|
| ios | skipped |
| mac | skipped |
| linux_x64 | skipped |
| win_x64 | skipped |

---

## 4. Write key — Passed ✅

All four secrets decoded successfully (all shown as `***` in log). The `key.jks` was decoded from `SIGN_KEYSTORE_BASE64` and written to `android/app/key.jks`. The `key.properties` was written with `storeFile=key.jks`, `storePassword`, `keyAlias`, and `keyPassword`.

This confirms the keystore password fix from the previous failed run (`26712728281`) was effective.

---

## 5. Flutter Build Release Apk — Passed ✅

The `flutter build apk --release --split-per-abi` command succeeded. Gradle `assembleRelease` completed in ~331 seconds with no `kotlin()` error (the `screen_brightness_android` Gradle workaround at `f868d6206` remains effective). All three APKs were built:

```
✓ Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (24.5MB)
✓ Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (24.6MB)
✓ Built build/app/outputs/flutter-apk/app-x86_64-release.apk (25.6MB)
```

No build errors. Non-fatal warnings only:
- KGP deprecation warnings for 15 plugins (including `screen_brightness_android`)
- `Caught exception: Already watching path` (Flutter file watcher noise)
- Several `uses or overrides a deprecated API` notes (Java compilation)

---

## 6. APK Artifact Inventory

| ABI | Artifact Name | Artifact ID | Size |
|---|---|---|---|
| arm64-v8a | `PiliAvalon_android_2.0.7-f868d6206+5046_arm64-v8a.apk` | `7316968318` | 24,575,894 bytes |
| armeabi-v7a | `PiliAvalon_android_2.0.7-f868d6206+5046_armeabi-v7a.apk` | `7316968405` | 24,489,651 bytes |
| x86_64 | `PiliAvalon_android_2.0.7-f868d6206+5046_x86_64.apk` | `7316968476` | 25,552,327 bytes |

All three artifacts are available for download until 2026-08-29.

---

## 7. Release / Pre-release

| Field | Value |
|---|---|
| Release tag | `phase-1-prebuild.26713300408` |
| Release name | `phase-1-prebuild.26713300408` |
| Prerelease | `true` |
| Latest | `false` |
| Commit | `f868d6206a23fb77de424c9e45cfbc0aa618b0fa` |
| Assets | 3 APKs (all ABIs uploaded successfully) |
| URL | https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26713300408 |

---

## 8. Android_signing_evidence Artifact Status

**Not present as a GitHub Actions artifact.** The `Capture Android signing fingerprints` step (step 11, `success`) ran `apksigner verify --print-certs` on all 3 APKs and wrote the output to `signing-evidence/`:

- `signing-evidence/PiliAvalon_android_2.0.7-f868d6206+5046_arm64-v8a.apk.certs.txt`
- `signing-evidence/PiliAvalon_android_2.0.7-f868d6206+5046_armeabi-v7a.apk.certs.txt`
- `signing-evidence/PiliAvalon_android_2.0.7-f868d6206+5046_x86_64.apk.certs.txt`
- `signing-evidence/cover-install-requirements.txt`

The signing evidence files were created on the runner, but step 17 (`上传签名证据`) failed to upload them because `actions/upload-artifact@v7` was configured with `archive: false` and `path: signing-evidence/*` — the glob matched 4 files, but `archive: false` only supports a single file.

**Error (line 916 of log):**
```
When 'archive' is set to false, only a single file can be uploaded. Found 4 files to upload.
```

---

## 9. apksigner verify --print-certs Output

The `apksigner verify --print-certs` command ran successfully for all 3 APKs (step 11 conclusion: `success`). The output files were created on the runner but the raw certificate data (SHA-256 fingerprints, signer DN, etc.) was not echoed to the GitHub Actions log — it was only written to the `.certs.txt` files under `signing-evidence/`. Since step 17 failed, these files are not retrievable as artifacts.

---

## 10. Root Cause: Step 17 Failure

The workflow step `上传签名证据` uses:

```yaml
- uses: actions/upload-artifact@v7
  with:
    archive: false
    name: Android_signing_evidence
    path: signing-evidence/*
```

The `archive: false` setting tells `upload-artifact@v7` to upload a single raw file (no zip). However, the `path` glob `signing-evidence/*` matches **4 files** (3 `.certs.txt` + 1 `.txt`), which violates the single-file constraint.

**Fix needed (workflow YAML change):**
- Change `archive: false` to `archive: true` (or remove the `archive` key entirely — default is `true`), OR
- Change `path` to upload each file individually with separate steps, OR
- Use `path: signing-evidence/cover-install-requirements.txt` for a single file, with separate steps for the cert files.

---

## 11. Risks

| Risk | Severity | Detail |
|---|---|---|
| Signing evidence not persisted | **Medium** | The apksigner cert output was generated but not uploaded due to workflow config bug. The evidence existed transiently on the runner but is now lost. The APKs themselves are signed (build succeeded), but the certificate fingerprint records are unavailable for review. |
| Workflow config bug blocks evidence gate | **Medium** | The `archive: false` + multi-file glob is a workflow YAML error that will block every future Build run from uploading signing evidence until fixed. |
| KGP deprecation warnings (15 plugins) | **Low** | Non-fatal but signals future compatibility issues with Flutter's built-in Kotlin migration. |
| Positive: Pipeline is structurally proven | **Positive** | All build/signing/release steps work. Only the evidence upload step has a configuration bug. |
| Positive: Keystore password issue resolved | **Positive** | The previous run's blocker (keystore password incorrect) is confirmed fixed. |

---

## 12. Unknowns

1. **Certificate fingerprints.** The apksigner output was generated but not uploaded. The actual SHA-256 fingerprint of the signing certificate is unknown from this run. Would need to download one of the APK artifacts and run `apksigner verify --print-certs` locally to recover.

2. **Whether the signing certificate matches the installed release on the user's device.** This depends on whether the keystore used for encoding `SIGN_KEYSTORE_BASE64` is the same keystore used for the previous production release. Cannot verify without the fingerprint data.

---

## 13. Verification Results

| Check | Result |
|---|---|
| Run identity confirmed | ✅ `26713300408`, workflow_dispatch, `f868d6206` |
| Run completed | ✅ `completed`, `failure` (~7m 8s) |
| Write key passed | ✅ All 4 secrets decoded to `key.jks` + `key.properties` |
| `screen_brightness_android` kotlin() error | ✅ **Still resolved** (Gradle workaround holds) |
| Flutter Build Release Apk | ✅ All 3 ABIs built (~331s) |
| APK signing | ✅ Build succeeded (signing is part of assembleRelease) |
| Android_signing_evidence artifact | ❌ Not uploaded (step 17 failed due to workflow config bug) |
| apksigner verify --print-certs captured | ⚠️ Generated on runner but not persisted as artifact |
| 3 APK artifacts | ✅ All uploaded successfully |
| Release created | ✅ `phase-1-prebuild.26713300408` (prerelease) |
| Keystore password issue (from prior run) | ✅ **Fixed** |
| KGP deprecation warnings (15 plugins) | ⚠️ Non-fatal |

---

## 14. Client/User Decision Needed

**Yes — one fix needed.** The pipeline is otherwise fully functional:

1. **Fix the workflow YAML for step 17 (`上传签名证据`).** Change `archive: false` to `archive: true` (or remove the `archive` key) in the `actions/upload-artifact@v7` step that uploads `signing-evidence/*`. With `archive: true`, the 4 files will be zipped into a single artifact named `Android_signing_evidence`.

2. **Re-trigger Build workflow_dispatch after the fix.** The pipeline is proven:
   - ✅ Write key (secrets decode)
   - ✅ Flutter Build Release Apk (Gradle + signing)
   - ✅ APK artifact uploads (all 3 ABIs)
   - ✅ GitHub Release creation
   - ✅ apksigner verify --print-certs capture
   - ❌ Signing evidence upload (config bug — trivial fix)

3. **Release evidence gates.** Once the workflow fix is deployed and a new Build run produces the `Android_signing_evidence` artifact:
   - Download the `Android_signing_evidence` artifact
   - Review the certificate fingerprints against the installed release
   - Perform cover-install verification
   - Complete manual retest

---

*This artifact is monitor evidence. Step 17 failure is a workflow configuration bug — not a build, signing, or secrets issue. The 3 signed APKs exist as artifacts and as GitHub Release assets. Release decisions require the signing evidence artifact (after the workflow fix), Codex review of this persisted monitor, plus separate user cover-install and manual retest evidence.*
