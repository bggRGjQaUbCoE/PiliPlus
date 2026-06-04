# Phase 1 Release Build 26714387748 Monitor — Signing Evidence

Date: 2026-05-31
Review owner: Codex
Monitor target: Build workflow_dispatch run `26714387748`
Head SHA: `e8e96787dabb5403348b5c1d71f7ba40970b0dcc`

Status: **SUCCESS** — All 17 steps passed. The hardened SHA-256 fingerprint extraction (commit `e8e96787d`) resolved the grep failure from run `26714004486`. Three signed APKs, a GitHub Release with fingerprint table in the body, `Android_signing_evidence` artifact, and remote job summary all produced.

---

## 1. Reading Scope

Files and data consulted:

- `gh run view 26714387748` — run identity and step-level JSON results
- `gh run watch 26714387748` — live completion monitoring (~6 min; captured success)
- `gh api .../artifacts` — artifact inventory (4 artifacts: 3 APKs + signing evidence)
- `gh api repos/.../releases/tags/phase-1-prebuild.26714387748` — release body with fingerprint table
- `gh run view --log --job 78730267788` — full Release Android job log (1024 lines)
- `git rev-parse HEAD` — local HEAD confirmation (`e8e96787dabb5403348b5c1d71f7ba40970b0dcc`)
- `git status --short --branch` — confirms on `phase-1-shielding-core`
- Prior monitor reports:
  - `records/reasonix/monitor/2026-05-31-phase-1-release-build-26714004486-monitor.md` (grep failure — this run's fix target)
  - `records/reasonix/monitor/2026-05-31-phase-1-release-build-26713648685-monitor.md` (first fully successful run with signing evidence)

---

## 2. Run Identity

| Field | Value |
|---|---|
| Run ID | `26714387748` |
| URL | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26714387748 |
| Event | `workflow_dispatch` |
| Branch | `phase-1-shielding-core` |
| Head SHA | `e8e96787dabb5403348b5c1d71f7ba40970b0dcc` |
| Workflow | Build |
| Status | `completed` |
| Conclusion | **`success`** |
| Created | 2026-05-31T13:48:32Z |
| Updated | 2026-05-31T13:54:34Z |
| Duration | ~5m 58s |
| Release Job ID | `78730267788` |

---

## 3. Job Results

### Release Android — `success` ✅ (all 17 steps passed)

| Step # | Step Name | Conclusion | Notes |
|---|---|---|---|
| 1 | Set up job | ✅ success | Ubuntu 24.04, runner 2.334.0 |
| 2 | 代码迁出 | ✅ success | checkout@v6 |
| 3 | 构建Java环境 | ✅ success | Java Zulu JDK 17.0.19-10 |
| 4 | 安装Flutter | ✅ success | Flutter stable-3.44.0 |
| 5 | Apply Patch | ✅ success | 8 patches applied |
| **6** | **Write key** | **✅ success** | All 4 secrets decoded |
| 7 | Set and Extract version | ✅ success | Version: `2.0.7-e8e96787d+5049` |
| **8** | **Flutter Build Release Apk** | **✅ success** | ~3m 48s; all 3 ABIs built |
| 9 | Flutter Build Dev Apk | ⏭ skipped | |
| 10 | Rename | ✅ success | APKs renamed |
| **11** | **Capture Android signing fingerprints** | **✅ success** | Hardened grep parsed fingerprints; summary generated (see §6) |
| 12 | Resolve release tag | ✅ success | Tag: `phase-1-prebuild.26714387748` |
| **13** | **Release** | **✅ success** | GitHub Release; body populated from `remote-fingerprint-summary.md` via `body_path` |
| 14 | 上传 (arm64-v8a) | ✅ success | Artifact ID `7317264644` |
| 15 | 上传 (armeabi-v7a) | ✅ success | Artifact ID `7317264837` |
| 16 | 上传 (x86_64) | ✅ success | Artifact ID `7317265011` |
| **17** | **上传签名证据** | **✅ success** | `Android_signing_evidence`; 2,096 bytes; `archive: true` |
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

All four secrets decoded successfully. `key.jks` written to `android/app/key.jks`.

---

## 5. Flutter Build Release Apk — Passed ✅

All three ABIs built successfully (~3m 48s). No build errors. Version: `2.0.7-e8e96787d+5049`.

```
✓ Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (24.5MB)
✓ Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (24.6MB)
✓ Built build/app/outputs/flutter-apk/app-x86_64-release.apk (25.6MB)
```

---

## 6. Capture Android signing fingerprints — Passed ✅

### Hardened parsing (commit `e8e96787d`)

The script at `e8e96787d` replaced the brittle `grep -m 1 "Signer #1 certificate SHA-256 digest:"` with a defense-in-depth pipeline:

```
sha256="$(
  LC_ALL=C tr -d '\r' < "$cert_file" |    # strip CRLF
    tr '[:lower:]' '[:upper:]' |           # normalize case
    sed -nE '/SHA[ -]?256/{                # match SHA-256 / SHA256 / SHA 256
      h
      s/.*DIGEST[^0-9A-F]*//
      t normalize
      g
      s/.*SHA[ -]?256[^0-9A-F]*//
      :normalize
      s/[^0-9A-F]//g                       # strip non-hex
      p
      q
    }'
)"
if ! printf '%s' "$sha256" | grep -Eq '^[0-9A-F]{64}$'; then   # validate 64 hex chars
  echo "Missing SHA-256 fingerprint in ${cert_file}" >&2
  cat "$cert_file" >&2                                         # dump cert file for debug
  exit 1
fi
```

Improvements over the failed `07ae82c03` version:
- **CRLF stripping:** `LC_ALL=C tr -d '\r'` handles Windows line endings
- **Case normalization:** `tr '[:lower:]' '[:upper:]'` ensures case-insensitive matching
- **Flexible pattern:** `sed -nE '/SHA[ -]?256/'` matches `SHA-256`, `SHA256`, or `SHA 256`
- **Hex-only extraction:** `s/[^0-9A-F]//g` strips colons and other non-hex characters
- **Strict validation:** `grep -Eq '^[0-9A-F]{64}$'` enforces exactly 64 uppercase hex digits
- **Debug output on failure:** `cat "$cert_file" >&2` dumps the cert file to stderr for diagnosis

### Remote fingerprint summary (`remote-fingerprint-summary.md`)

The summary was generated and written to `$GITHUB_STEP_SUMMARY` (visible in the Actions job summary page) **and** used as the release body via `body_path: signing-evidence/remote-fingerprint-summary.md`.

---

## 7. SHA-256 Fingerprints — All 3 ABIs Identical ✅

| ABI | SHA-256 Fingerprint |
|---|---|
| arm64-v8a | `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |
| armeabi-v7a | `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |
| x86_64 | `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |

**All 3 ABIs share the same signing certificate fingerprint.** This is expected for a single `key.jks` signing all APK splits from the same `assembleRelease` task.

---

## 8. APK Artifact Inventory

| ABI | Artifact Name | Artifact ID | Size |
|---|---|---|---|
| arm64-v8a | `PiliAvalon_android_2.0.7-e8e96787d+5049_arm64-v8a.apk` | `7317264644` | 24,576,093 bytes |
| armeabi-v7a | `PiliAvalon_android_2.0.7-e8e96787d+5049_armeabi-v7a.apk` | `7317264837` | 24,489,651 bytes |
| x86_64 | `PiliAvalon_android_2.0.7-e8e96787d+5049_x86_64.apk` | `7317265011` | 25,552,359 bytes |

All expire 2026-08-29.

---

## 9. Android_signing_evidence Artifact — ✅ Present

| Field | Value |
|---|---|
| Artifact name | `Android_signing_evidence` |
| Artifact ID | `7317265122` |
| Size | 2,096 bytes (zipped) |
| SHA-256 (artifact) | `eb24032badf713006e17fc6def41bb2d1b8e4ad6e901d08a387d69e04c9d5c0f` |
| Contents | 5 files: 3 `.certs.txt` + `remote-fingerprint-summary.md` + `cover-install-requirements.txt` |
| Archive format | `.zip` (archive: true) |
| Download URL | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26714387748/artifacts/7317265122 |

---

## 10. Release / Pre-release

| Field | Value |
|---|---|
| Release tag | `phase-1-prebuild.26714387748` |
| Release name | `phase-1-prebuild.26714387748` |
| Prerelease | `true` |
| Latest | `false` |
| Commit | `e8e96787dabb5403348b5c1d71f7ba40970b0dcc` |
| Body populated via | `body_path: signing-evidence/remote-fingerprint-summary.md` |
| Assets | 3 APKs |
| URL | https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26714387748 |

### Release Body (excerpt — full fingerprint table)

```
## Android release signing evidence

- Run ID: 26714387748
- Commit: e8e96787dabb5403348b5c1d71f7ba40970b0dcc
- Version: 2.0.7-e8e96787d+5049

| APK | SHA-256 fingerprint |
|---|---|
| arm64-v8a | 0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051 |
| armeabi-v7a | 0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051 |
| x86_64 | 0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051 |

Cover-install verification requires:
- same applicationId: com.example.piliplus
- same signing certificate fingerprint as the installed release
- install over existing app without uninstall
```

---

## 11. Remote Fingerprint Summary Status — ✅ Generated

The `remote-fingerprint-summary.md` file was:

1. Written to disk at `signing-evidence/remote-fingerprint-summary.md` ✅
2. Appended to `$GITHUB_STEP_SUMMARY` (visible in Actions job summary page) ✅
3. Used as the release body via `body_path: signing-evidence/remote-fingerprint-summary.md` in the `softprops/action-gh-release@v2` step ✅

---

## 12. Risks

| Risk | Severity | Detail |
|---|---|---|
| Signing certificate identity unverified | **Medium** | The fingerprint `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` is confirmed present in the release body, but hasn't been compared against the user's installed production release fingerprint. |
| Node.js 20 deprecation | **Low** | `softprops/action-gh-release@v2` still uses Node.js 20. Deprecation effective June 16th, 2026. |
| KGP deprecation warnings (15 plugins) | **Low** | Non-fatal future compatibility risk. |
| Positive: Hardened grep is robust | **Positive** | The defense-in-depth parsing (CRLF strip, case normalization, flexible pattern, hex-only extraction, 64-char validation) should survive apksigner output format variations. |
| Positive: Fingerprints visible remotely | **Positive** | Fingerprints are in the release body (no artifact download needed) and the job summary page. |

---

## 13. Unknowns

1. **Whether `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` matches the installed production release.** The user must verify this fingerprint against the installed app on their device.

---

## 14. Verification Results

| Check | Result |
|---|---|
| Run identity confirmed | ✅ `26714387748`, workflow_dispatch, `e8e96787d` |
| Head SHA matches `e8e96787dabb5403348b5c1d71f7ba40970b0dcc` | ✅ |
| Run completed successfully | ✅ `success` (~5m 58s) |
| Write key passed | ✅ |
| Flutter Build Release Apk | ✅ All 3 ABIs built |
| APK signing | ✅ (part of assembleRelease) |
| Capture Android signing fingerprints | ✅ Hardened grep parsed all 3 fingerprints |
| Remote fingerprint summary generated | ✅ Written to `$GITHUB_STEP_SUMMARY` |
| No empty SHA-256 values in summary | ✅ All 3 fingerprints are 64 hex chars |
| Prerelease body contains SHA-256 fingerprint table | ✅ via `body_path` |
| All 3 ABI fingerprints are identical | ✅ `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` |
| Android_signing_evidence artifact | ✅ 2,096 bytes, ID `7317265122` |
| 3 APK artifacts | ✅ All uploaded |
| Release created | ✅ `phase-1-prebuild.26714387748` (prerelease) |

---

## 15. Progress Across Runs

| Run | Commit | Key Change | Result |
|---|---|---|---|
| `26712728281` | `f868d6206` | Gradle workaround for `screen_brightness_android` | ❌ Keystore password wrong |
| `26713300408` | `f868d6206` | Password fix (same commit) | ❌ `archive: false` bug |
| `26713648685` | `11e5dedb4` | `archive: true` fix | ✅ First full success |
| `26714004486` | `07ae82c03` | Fingerprint summary + grep guard | ❌ grep mismatch |
| **`26714387748`** | **`e8e96787d`** | **Hardened SHA-256 parsing** | **✅ All 17 passed + remote fingerprints** |

---

## 16. Client/User Decision Needed

**Yes — release evidence gates require human verification:**

1. **Compare the signing certificate fingerprint.** The SHA-256 fingerprint for all 3 APKs is:
   ```
   0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051
   ```
   Compare this against the fingerprint of the currently installed release on the user's device. The fingerprint is visible remotely in:
   - The release body at https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26714387748
   - The Actions job summary page

2. **Cover-install verification:**
   - Install one APK from this release over the existing installed app
   - Confirm install succeeds without uninstall (same `applicationId: com.example.piliplus`, same signing certificate)
   - Perform manual retest

3. **Release gates that remain open:**
   - ✅ Pipeline structural proof (this run)
   - ✅ Fingerprints visible remotely in release body
   - ✅ All 3 ABI fingerprints identical
   - ⬜ Certificate fingerprint match with installed production release
   - ⬜ Cover-install verification
   - ⬜ Manual retest
   - ⬜ Codex review of persisted monitor

---

*This artifact is monitor evidence. Run `26714387748` is the first fully successful Build that includes remote-readable SHA-256 fingerprints in the release body. All 17 steps passed, all 4 artifacts (3 APKs + signing evidence with the new summary file) were produced, and the signing certificate fingerprint `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051` is confirmed identical across all 3 ABIs. The hardened grep parsing at `e8e96787d` resolves the `07ae82c03` failure. Remaining gates are human verification (fingerprint match, cover-install, retest).*
