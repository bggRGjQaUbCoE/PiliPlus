# Phase 1 Release Build 26711811133 Monitor — Signing Evidence

Date: 2026-05-31
Review owner: Codex
Monitor target: Build workflow_dispatch run `26711811133`
Head SHA: `a5d0d075cd80a35173355a52133057c7cec1679b`

Status: **FAILED** — candidate monitor evidence only. Does not close any release gate.

---

## 1. Reading Scope

Files and data consulted:

- `.github/workflows/build.yml` (at local HEAD `a5d0d075c` — same as run commit)
- `gh run view 26711811133` — run identity
- `gh run watch 26711811133` — live completion monitoring
- `gh api .../jobs` — step-level results
- `gh api .../artifacts` — artifact inventory
- `gh api .../jobs/78723273773/logs` — full Release Android job log (truncated at tail; Write key failure captured)
- `git rev-parse HEAD` — local HEAD `a5d0d075c` matches run head SHA
- Prior monitor report `records/reasonix/monitor/2026-05-31-phase-1-release-build-workflow-dispatch-monitor.md` (run `26680259984` at `80f5e6d6a`)
- Codex reviews in `records/reasonix/review/2026-05-31-phase-1-release-final-gates-codex-review.md` and `2026-05-31-phase-1-github-after-push-codex-review.md`

---

## 2. Run Identity

| Field | Value |
|---|---|
| Run ID | `26711811133` |
| URL | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26711811133 |
| Event | `workflow_dispatch` |
| Branch | `phase-1-shielding-core` |
| Head SHA | `a5d0d075cd80a35173355a52133057c7cec1679b` |
| Workflow | Build |
| Status | `completed` |
| Conclusion | **`failure`** |
| Created | 2026-05-31T11:50:38Z |
| Updated | 2026-05-31T11:52:31Z |
| Duration | ~1m 53s |

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
| **6** | **Write key** | **❌ failure** | **Hardened check: all 4 signing secrets empty** |
| 7 | Set and Extract version | skipped | blocked by step 6 failure |
| 8 | Flutter Build Release Apk | skipped | blocked |
| 9 | Flutter Build Dev Apk | skipped | blocked |
| 10 | Rename | skipped | blocked |
| 11 | Capture Android signing fingerprints | skipped | blocked |
| 12 | Resolve release tag | skipped | blocked |
| 13 | Release | skipped | blocked |
| 14 | 上传 (arm64-v8a) | skipped | blocked |
| 15 | 上传 (armeabi-v7a) | skipped | blocked |
| 16 | 上传 (x86_64) | skipped | blocked |
| 17 | 上传签名证据 | skipped | blocked |
| 32 | Post 安装Flutter | success | |
| 33 | Post 构建Java环境 | success | |
| 34 | Post 代码迁出 | success | |
| 35 | Complete job | success | |

### Other Jobs

| Job | Conclusion | Note |
|---|---|---|
| ios | skipped | |
| linux_x64 | skipped | |
| mac | skipped | |
| win_x64 | skipped | |

### Failed Step Log Excerpt

From the raw job log (`78723273773`), timestamps `2026-05-31T11:52:26.794Z`—`2026-05-31T11:52:26.804Z`:

```
Run if [ -z "" ] || [ -z "" ] || [ -z "" ] || [ -z "" ]; then
  echo "Release signing secrets are required for cover-install compatible APKs." >&2
  exit 1
fi
  echo "" | base64 --decode > android/app/key.jks
  echo storeFile='key.jks' >> android/key.properties
  echo storePassword='' >> android/key.properties
  echo keyAlias='' >> android/key.properties
  echo keyPassword='' >> android/key.properties

Release signing secrets are required for cover-install compatible APKs.
Error: Process completed with exit code 1.
```

All four secrets resolved to empty strings:
- `SIGN_KEYSTORE_BASE64` → `""`
- `KEYSTORE_PASSWORD` → `""`
- `KEY_ALIAS` → `""`
- `KEY_PASSWORD` → `""`

The hardened check (`if [ -z "..." ] || ... exit 1`) from commit `6f64672f8` correctly caught the missing secrets and aborted the build. This is the **correct behavior** — it prevents producing unsigned or improperly signed APKs.

---

## 4. Release APK Artifact Inventory

**No artifacts were produced.** The run failed before any APK build step.

| Artifact Name | Status |
|---|---|
| `PiliAvalon_android_*_arm64-v8a.apk` | ❌ Not produced |
| `PiliAvalon_android_*_armeabi-v7a.apk` | ❌ Not produced |
| `PiliAvalon_android_*_x86_64.apk` | ❌ Not produced |

---

## 5. Release / Pre-release Asset Inventory

**No release was created.** The `Resolve release tag` and `Release` steps were skipped due to the Write key failure.

No tag `phase-1-prebuild.26711811133` was found in the release list.

---

## 6. Android_signing_evidence Artifact Status

**Not present.** The `Capture Android signing fingerprints` and `上传签名证据` steps were skipped.

This run is notable because it is the **first observed Build workflow_dispatch that included these steps in the workflow definition** (added in `6f64672f8`). The steps exist in the workflow but were never reached due to the Write key failure.

Step numbers confirm the workflow version:
- Step 11: `Capture Android signing fingerprints` (new — not present in run `26680259984`)
- Step 17: `上传签名证据` (new — not present in run `26680259984`)

---

## 7. apksigner verify --print-certs Output

**Not available.** No APKs were built, so no signing fingerprint capture occurred.

---

## 8. Cover-install Requirements File Status

**Not present.** The `Capture Android signing fingerprints` step, which generates `signing-evidence/cover-install-requirements.txt`, was skipped.

---

## 9. Risks

| Risk | Severity | Detail |
|---|---|---|
| Signing secrets missing | **Critical** | All four required secrets (`SIGN_KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`) are not configured in the GitHub repository. The hardened workflow check correctly prevents building unsigned APKs, but this also means **no release APKs can be produced via CI** until secrets are configured. |
| Prior APK run uses soft-fail | **High** | Run `26680259984` at `80f5e6d6a` used the old soft-fail pattern and succeeded, but its APKs may be unsigned or debug-signed. The signing status of those APKs is unconfirmed. |
| No path to CI-signed APKs | **High** | The current workflow (after `6f64672f8`) requires all four signing secrets to be present. Without them, every Build workflow_dispatch will fail at the Write key step. |
| Workflow evolution gap | **Medium** | The signing-evidence capture steps are now in the workflow but have never been exercised successfully. Any latent bugs in those steps won't be discovered until the secrets are configured. |
| x86_64 path | **Non-blocking** | Per user decision. |

---

## 10. Unknowns

1. **Signing certificate identity.** Even if secrets were configured, we don't know what certificate they encode. The first successful build with secrets will produce the first `apksigner verify --print-certs` output.
2. **Whether the secrets exist at all.** No evidence confirms whether the signing keystore has been generated and exists offline.
3. **Whether run `26680259984` APKs are signed.** The soft-fail pattern would have silently skipped signing if the same secret absence existed at that time. Those APKs need local `apksigner verify` inspection.
4. **Timeline for secret configuration.** This is a user/repo-admin action outside the scope of this monitor.

---

## 11. Verification Results

| Check | Result |
|---|---|
| Run identity confirmed | ✅ `26711811133`, workflow_dispatch, `a5d0d075c` |
| Run completed | ✅ `completed`, `failure` (1m 53s) |
| Write key step failed | ✅ Confirmed — all 4 secrets empty, `exit 1` |
| Hardened check working | ✅ Correctly prevented build with missing secrets |
| Signing-evidence steps present in workflow | ✅ Steps 11, 17 confirmed (new since `6f64672f8`) |
| APK artifacts produced | ❌ None |
| Android_signing_evidence artifact | ❌ Not present |
| apksigner verify --print-certs | ❌ Not captured |
| Release created | ❌ None |

---

## 12. Client/User Decision Needed

**Yes.** The following decisions are needed:

1. **Configure signing secrets in the GitHub repository.** The four secrets (`SIGN_KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`) must be set in the repo's Actions secrets before any Build workflow_dispatch can succeed. This is a repo-admin action.

2. **Verify the signing status of run `26680259984` APKs.** If those APKs are intended to be used for cover-install and manual retest, download them and run `apksigner verify --print-certs` locally. If they're unsigned, they won't pass cover-install.

3. **Re-trigger Build workflow_dispatch after secrets are configured.** Only then will the signing-evidence capture steps (11 and 17) be exercised and produce usable evidence.

4. **Release gates remain open:**
   - Release `Build` workflow_dispatch → **failed** (this run)
   - Release APK artifacts → **not produced**
   - `Android_signing_evidence` → **not produced**
   - `apksigner verify --print-certs` → **not captured**
   - Real-device cover-install → **pending**
   - User manual retest → **pending**
   - Phase 1 green/accepted/complete → **not closed**

---

*This artifact is candidate monitor evidence only. Release decisions require Codex review of this persisted artifact, configured signing secrets, a successful Build run with signing evidence, plus separate user cover-install and manual retest evidence.*
