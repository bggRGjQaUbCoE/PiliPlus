# Phase 1 Release Build 26713648685 Monitor — Signing Evidence

Date: 2026-05-31
Review owner: Codex
Monitor target: Build workflow_dispatch run `26713648685`
Head SHA: `11e5dedb4c410d9588ca4cb294c39f28324887c7`

Status: **SUCCESS** — All 17 steps passed. The `archive: true` fix resolved the signing evidence upload failure from run `26713300408`. Three signed APKs, a GitHub Release, and the `Android_signing_evidence` artifact were all produced.

---

## 1. Reading Scope

Files and data consulted:

- `gh run view 26713648685` — run identity and step-level JSON results
- `gh run watch 26713648685` — live completion monitoring (~7 min, captured completion)
- `gh api .../jobs` — job-level results (embedded in run view JSON)
- `gh api .../artifacts` — artifact inventory (4 artifacts: 3 APKs + signing evidence)
- `gh run view --log --job 78728276691` — full Release Android job log (974 lines)
- `git rev-parse HEAD` — local HEAD confirmation (`11e5dedb4c410d9588ca4cb294c39f28324887c7`)
- `git status --short --branch` — confirms on `phase-1-shielding-core`
- Prior monitor reports:
  - `records/reasonix/monitor/2026-05-31-phase-1-release-build-26712728281-monitor.md` (keystore password failure)
  - `records/reasonix/monitor/2026-05-31-phase-1-release-build-26713300408-monitor.md` (archive:false bug)

---

## 2. Run Identity

| Field | Value |
|---|---|
| Run ID | `26713648685` |
| URL | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26713648685 |
| Event | `workflow_dispatch` |
| Branch | `phase-1-shielding-core` |
| Head SHA | `11e5dedb4c410d9588ca4cb294c39f28324887c7` |
| Workflow | Build |
| Status | `completed` |
| Conclusion | **`success`** |
| Created | 2026-05-31T13:15:42Z |
| Updated | 2026-05-31T13:22:40Z |
| Duration | ~6m 55s |
| Release Job ID | `78728276691` |

---

## 3. Job Results

### Release Android — `success` ✅ (all 17 steps passed)

| Step # | Step Name | Conclusion | Notes |
|---|---|---|---|
| 1 | Set up job | ✅ success | Ubuntu 24.04, runner 2.334.0 |
| 2 | 代码迁出 | ✅ success | checkout@v6, fetch-depth: 0 |
| 3 | 构建Java环境 | ✅ success | Java Zulu JDK 17.0.19-10 |
| 4 | 安装Flutter | ✅ success | Flutter stable-3.44.0 |
| 5 | Apply Patch | ✅ success | 8 patches applied |
| **6** | **Write key** | **✅ success** | All 4 secrets decoded; `key.jks` + `key.properties` written |
| 7 | Set and Extract version | ✅ success | Version: `2.0.7-11e5dedb4+5047` |
| **8** | **Flutter Build Release Apk** | **✅ success** | Gradle `assembleRelease` ~316s; all 3 ABIs built |
| 9 | Flutter Build Dev Apk | ⏭ skipped | |
| 10 | Rename | ✅ success | APKs renamed to `PiliAvalon_android_{version}_{abi}.apk` |
| **11** | **Capture Android signing fingerprints** | **✅ success** | `apksigner verify --print-certs` on all 3 APKs |
| 12 | Resolve release tag | ✅ success | Tag: `phase-1-prebuild.26713648685` |
| **13** | **Release** | **✅ success** | GitHub Release created with 3 APK assets; prerelease=true |
| 14 | 上传 (arm64-v8a) | ✅ success | |
| 15 | 上传 (armeabi-v7a) | ✅ success | |
| 16 | 上传 (x86_64) | ✅ success | |
| **17** | **上传签名证据** | **✅ success** | `archive: true`; 4 files zipped; 1,586 bytes uploaded |
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

All four secrets decoded successfully (all `***` in log). `key.jks` decoded from `SIGN_KEYSTORE_BASE64` → `android/app/key.jks`. `key.properties` written with `storeFile=key.jks`, `storePassword`, `keyAlias`, `keyPassword`.

---

## 5. Flutter Build Release Apk — Passed ✅

Gradle `assembleRelease` completed in ~316 seconds. All three ABIs built successfully:

```
✓ Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (24.5MB)
✓ Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (24.6MB)
✓ Built build/app/outputs/flutter-apk/app-x86_64-release.apk (25.6MB)
```

No build errors. Non-fatal warnings only:
- KGP deprecation warnings for 15 plugins (`screen_brightness_android` included)
- `Caught exception: Already watching path` (Flutter file watcher noise)
- Several `uses or overrides a deprecated API` notes

---

## 6. APK Artifact Inventory

| ABI | Artifact Name | Artifact ID | Size |
|---|---|---|---|
| arm64-v8a | `PiliAvalon_android_2.0.7-11e5dedb4+5047_arm64-v8a.apk` | `7317061539` | 24,575,941 bytes |
| armeabi-v7a | `PiliAvalon_android_2.0.7-11e5dedb4+5047_armeabi-v7a.apk` | `7317061641` | 24,489,647 bytes |
| x86_64 | `PiliAvalon_android_2.0.7-11e5dedb4+5047_x86_64.apk` | `7317061724` | 25,552,213 bytes |

All expire 2026-08-29.

---

## 7. Android_signing_evidence Artifact — ✅ Present

| Field | Value |
|---|---|
| Artifact name | `Android_signing_evidence` |
| Artifact ID | `7317061786` |
| Size | 1,586 bytes (zipped) |
| SHA-256 | `1d039dd6068cd3d53896538716b77622a0a14ecc5af2acd9a5d2709ad95b6ac7` |
| Contents | 4 files in `signing-evidence/`: 3 `.certs.txt` (apksigner output per ABI) + `cover-install-requirements.txt` |
| Archive format | `.zip` (archive: true) |
| Upload status | ✅ Successfully uploaded |
| Download URL | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26713648685/artifacts/7317061786 |

---

## 8. archive Fix Confirmed

The workflow fix at commit `11e5dedb4` changed step 17's `archive` parameter:

| Run | `archive` value | Result |
|---|---|---|
| `26713300408` | `false` | ❌ Failed — "only a single file can be uploaded. Found 4 files" |
| **`26713648685`** | **`true`** | **✅ Success — 4 files zipped into `Android_signing_evidence.zip`** |

Evidence from log line ~903:
```
archive: true
```

---

## 9. apksigner verify --print-certs

The `apksigner verify --print-certs` command ran successfully for all 3 APKs (step 11: `success`). The output was written to:

- `signing-evidence/PiliAvalon_android_2.0.7-11e5dedb4+5047_arm64-v8a.apk.certs.txt`
- `signing-evidence/PiliAvalon_android_2.0.7-11e5dedb4+5047_armeabi-v7a.apk.certs.txt`
- `signing-evidence/PiliAvalon_android_2.0.7-11e5dedb4+5047_x86_64.apk.certs.txt`
- `signing-evidence/cover-install-requirements.txt`

The raw certificate data (SHA-256 fingerprints, signer DN) is inside the `Android_signing_evidence` artifact. Download and unzip to review.

---

## 10. Release / Pre-release

| Field | Value |
|---|---|
| Release tag | `phase-1-prebuild.26713648685` |
| Release name | `phase-1-prebuild.26713648685` |
| Prerelease | `true` |
| Latest | `false` |
| Commit | `11e5dedb4c410d9588ca4cb294c39f28324887c7` |
| Assets | 3 APKs (all ABIs uploaded) |
| URL | https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26713648685 |

---

## 11. Risks

| Risk | Severity | Detail |
|---|---|---|
| Signing certificate identity unverified | **Medium** | The apksigner cert output exists in the artifact but hasn't been reviewed against the installed release. Need to download `Android_signing_evidence` and compare fingerprints. |
| KGP deprecation warnings (15 plugins) | **Low** | Non-fatal but signals future compatibility risk with Flutter's built-in Kotlin migration. |
| Node.js 20 deprecation warning | **Low** | `softprops/action-gh-release@v2` uses Node.js 20. Deprecated as of June 16th, 2026. Should update before September 2026. |
| Positive: Pipeline is fully functional | **Positive** | All 17 steps passed. No blockers remain. |
| Positive: `screen_brightness_android` fix holds | **Positive** | The Gradle workaround at `f868d6206` (and subsequent commits) continues to work. |

---

## 12. Unknowns

1. **Certificate fingerprint values.** The apksigner output is inside the `Android_signing_evidence` artifact zip. The actual SHA-256 fingerprint of the signing certificate is not visible inline in the log. Must download artifact to inspect.

2. **Whether the keystore matches the installed release.** The pipeline proves the keystore works, but whether it's the *same* keystore as the user's installed production release must be verified by comparing certificate fingerprints.

---

## 13. Verification Results

| Check | Result |
|---|---|
| Run identity confirmed | ✅ `26713648685`, workflow_dispatch, `11e5dedb4` |
| Head SHA matches `11e5dedb4c410d9588ca4cb294c39f28324887c7` | ✅ |
| Run completed successfully | ✅ `success` (~6m 55s) |
| Write key passed | ✅ All 4 secrets decoded |
| Flutter Build Release Apk | ✅ All 3 ABIs built (~316s) |
| APK signing | ✅ Build succeeded (signing is part of assembleRelease) |
| Capture Android signing fingerprints | ✅ apksigner ran on all 3 APKs |
| Android_signing_evidence artifact | ✅ **Present** (1,586 bytes, ID `7317061786`) |
| 上传签名证据 passed | ✅ `archive: true` fix confirmed working |
| 3 APK artifacts | ✅ All uploaded |
| Release created | ✅ `phase-1-prebuild.26713648685` (prerelease) |
| `screen_brightness_android` kotlin() error | ✅ Still resolved |

---

## 14. Progress Across Runs

| Run | Issue | Status |
|---|---|---|
| `26712728281` | Keystore password incorrect | ❌ Fixed in later runs |
| `26713300408` | `archive: false` broke signing evidence upload | ❌ Fixed at `11e5dedb4` |
| **`26713648685`** | **—** | **✅ All 17 steps passed** |

---

## 15. Client/User Decision Needed

**Yes — release evidence gates require human review:**

1. **Download `Android_signing_evidence`** (artifact ID `7317061786`). Unzip and review:
   - The 3 `.certs.txt` files for APK signing certificate fingerprints
   - Verify all 3 ABIs share the same signing certificate
   - Compare the SHA-256 fingerprint against the fingerprint of the currently installed release on the user's device (`C:\Users\77182\.codex\memories\PiliAvalon-release-signing`)

2. **Cover-install verification:**
   - Install one of the APKs from this release over the existing installed app
   - Confirm install succeeds without uninstall (same `applicationId: com.example.piliplus`, same signing certificate)
   - Perform manual retest

3. **Release gates that remain open:**
   - ✅ Pipeline structural proof (this run)
   - ⬜ Certificate fingerprint match with installed release
   - ⬜ Cover-install verification
   - ⬜ Manual retest
   - ⬜ Codex review of persisted monitor

---

*This artifact is monitor evidence. Run `26713648685` is the first fully successful Build since the `screen_brightness_android` Gradle fix was applied. All 17 steps passed, all 4 artifacts (3 APKs + signing evidence) were produced, and a GitHub Release with all 3 APK assets exists. The pipeline is structurally proven — remaining gates are human verification (fingerprint match, cover-install, retest).*
