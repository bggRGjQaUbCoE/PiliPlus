# Phase 1 Release Build 26714004486 Monitor — Signing Evidence

Date: 2026-05-31
Review owner: Codex
Monitor target: Build workflow_dispatch run `26714004486`
Head SHA: `07ae82c0328f27b5fb116142df5bb7ce80fb8e5a`

Status: **FAILED** — Step 11 (`Capture Android signing fingerprints`) exited with code 1. The new SHA-256 fingerprint extraction grep pattern did not match the apksigner output, causing the empty-fingerprint guard to abort. No artifacts or release were produced.

---

## 1. Reading Scope

Files and data consulted:

- `gh run view 26714004486` — run identity and step-level JSON results
- `gh run watch 26714004486` — live completion monitoring (~7 min; captured failure at step 11)
- `gh api .../artifacts` — confirmed 0 artifacts
- `gh run view --log --job 78729225321` — full Release Android job log (858 lines)
- `git rev-parse HEAD` — local HEAD confirmation (`07ae82c0328f27b5fb116142df5bb7ce80fb8e5a`)
- `git status --short --branch` — confirms on `phase-1-shielding-core`
- Prior monitor reports:
  - `records/reasonix/monitor/2026-05-31-phase-1-release-build-26713648685-monitor.md` (previous fully successful run)

---

## 2. Run Identity

| Field | Value |
|---|---|
| Run ID | `26714004486` |
| URL | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26714004486 |
| Event | `workflow_dispatch` |
| Branch | `phase-1-shielding-core` |
| Head SHA | `07ae82c0328f27b5fb116142df5bb7ce80fb8e5a` |
| Workflow | Build |
| Status | `completed` |
| Conclusion | **`failure`** |
| Created | 2026-05-31T13:31:45Z |
| Updated | 2026-05-31T13:38:46Z |
| Duration | ~6m 57s |
| Release Job ID | `78729225321` |

---

## 3. Job Results

### Release Android — `failure` (step 11 failed)

| Step # | Step Name | Conclusion | Notes |
|---|---|---|---|
| 1 | Set up job | ✅ success | Ubuntu 24.04, runner 2.334.0 |
| 2 | 代码迁出 | ✅ success | checkout@v6 |
| 3 | 构建Java环境 | ✅ success | Java Zulu JDK 17.0.19-10 |
| 4 | 安装Flutter | ✅ success | Flutter stable-3.44.0 |
| 5 | Apply Patch | ✅ success | 8 patches applied |
| **6** | **Write key** | **✅ success** | All 4 secrets decoded |
| 7 | Set and Extract version | ✅ success | Version: `2.0.7-07ae82c03+5048` |
| **8** | **Flutter Build Release Apk** | **✅ success** | Gradle ~312.6s; all 3 ABIs built |
| 9 | Flutter Build Dev Apk | ⏭ skipped | |
| 10 | Rename | ✅ success | APKs renamed |
| **11** | **Capture Android signing fingerprints** | **❌ failure** | `exit code 1` — SHA-256 grep pattern mismatch (see §5) |
| 12 | Resolve release tag | ⏭ skipped | blocked by step 11 failure |
| 13 | Release | ⏭ skipped | blocked |
| 14–16 | 上传 (3×) | ⏭ skipped | blocked |
| 17 | 上传签名证据 | ⏭ skipped | blocked |
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

All three ABIs built successfully (~312.6s):

```
✓ Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (24.5MB)
✓ Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (24.6MB)
✓ Built build/app/outputs/flutter-apk/app-x86_64-release.apk (25.6MB)
```

Version: `2.0.7-07ae82c03+5048`. No build errors.

---

## 6. Capture Android signing fingerprints — Failed ❌

### What changed at `07ae82c03`

Commit `07ae82c03` extended the Capture step script to:

1. Generate a `remote-fingerprint-summary.md` file with a markdown table of SHA-256 fingerprints per ABI
2. Write the summary to `$GITHUB_STEP_SUMMARY` (visible in the Actions job summary page)
3. **Guard against empty SHA-256 values** — if `grep` doesn't find `Signer #1 certificate SHA-256 digest:` in any `.certs.txt` file, exit 1

### The failing script (from log lines 775–798)

```bash
sha256="$(grep -m 1 "Signer #1 certificate SHA-256 digest:" "$cert_file" | sed 's/.*: //')"
if [ -z "$sha256" ]; then
  echo "Missing SHA-256 fingerprint in ${cert_file}" >&2
  exit 1
fi
```

### Error observed

```
Capture Android signing fingerprints   ##[error]Process completed with exit code 1.
```

No stderr message was captured in the log between `##[endgroup]` and the error line. The script exited at the `exit 1` guard, indicating one of the `.certs.txt` files had no matching line for `Signer #1 certificate SHA-256 digest:`.

### Root cause analysis

The `grep -m 1 "Signer #1 certificate SHA-256 digest:"` pattern is looking for an exact string match in the apksigner output. There are several possible causes for the mismatch:

1. **Locale/encoding difference.** The apksigner output might use a slightly different label on the runner's locale (e.g., `SHA256` without hyphen, or different capitalization).
2. **apksigner version output format change.** The build-tools version selected dynamically (`ls "${ANDROID_HOME}/build-tools" | sort -V | tail -n 1`) might output a format that doesn't match the grep pattern.
3. **The cert file might have CRLF line endings** (if apksigner writes with Windows-style endings), causing `grep` to not match the pattern with a trailing `\r`.
4. **File I/O race condition.** The apksigner output might not have been fully flushed to disk before the grep runs in the same script — unlikely since redirection `>` is synchronous, but possible with buffered output.

### Evidence that the apksigner itself ran

In prior runs (`26713300408`, `26713648685`), the same apksigner invocation produced `.certs.txt` files that were successfully uploaded. The apksigner binary and path resolution are proven to work. The failure is in the **new grep/sed parsing logic**, not in the apksigner invocation.

---

## 7. APK Artifact Inventory

**No artifacts were produced.** Step 11 failure blocked steps 14–17.

| ABI | Status |
|---|---|
| arm64-v8a | ❌ Not uploaded (step 11 failure blocked step 14) |
| armeabi-v7a | ❌ Not uploaded (blocked) |
| x86_64 | ❌ Not uploaded (blocked) |

---

## 8. Android_signing_evidence Artifact Status

**Not present.** Step 17 (`上传签名证据`) was skipped due to step 11 failure.

---

## 9. Remote Fingerprint Summary Status

**Not generated.** The `remote-fingerprint-summary.md` file was being constructed by the script but the script exited before writing it to `$GITHUB_STEP_SUMMARY`. The job summary page will show no signing evidence.

---

## 10. Release / Pre-release Status

**No release was created.** Steps 12 (`Resolve release tag`) and 13 (`Release`) were skipped.

---

## 11. apksigner verify --print-certs Output

The apksigner command was invoked identically to the prior successful runs. In those runs, the output was generated correctly. In this run, the cert files were presumably created, but the SHA-256 grep parse failed immediately after, preventing any output from being visible in the log.

---

## 12. Risks

| Risk | Severity | Detail |
|---|---|---|
| SHA-256 grep pattern fragile | **High** | The new guard depends on exact string matching of apksigner output. Any formatting variation (locale, version, line endings) will cause false failures. The prior runs proved apksigner works; the failure is purely in the grep parsing. |
| No APKs persisted | **High** | The APKs were built and renamed but not uploaded. Even though the build succeeded, the artifacts are lost. |
| No release produced | **High** | Steps 12–17 all skipped. |
| Regression from proven pipeline | **Medium** | Commit `07ae82c03` introduced the new parsing logic. The pipeline was fully functional at `11e5dedb4` (run `26713648685`). |
| KGP deprecation warnings | **Low** | 15 plugins emit KGP warnings (non-fatal). |
| Build itself is proven | **Positive** | Steps 1–10 all passed. The build, signing (via assembleRelease), and APK production are solid. |

---

## 13. Unknowns

1. **Exact apksigner output format on this runner.** Was it `SHA-256 digest:` or `SHA256 digest:` or `SHA-256 Digest:`? Without the cert file contents, the exact mismatch is unknown.

2. **Which cert file failed the grep.** The script loops over all 3 `.certs.txt` files — any of them could have triggered the `exit 1`. The error message `Missing SHA-256 fingerprint in ${cert_file}` was written to stderr but not captured in the log output.

3. **Whether the cert files were actually created.** The apksigner command ran, but without the files being uploaded, we can't verify their contents.

---

## 14. Verification Results

| Check | Result |
|---|---|
| Run identity confirmed | ✅ `26714004486`, workflow_dispatch, `07ae82c03` |
| Head SHA matches `07ae82c0328f27b5fb116142df5bb7ce80fb8e5a` | ✅ |
| Run completed | ✅ `completed`, `failure` (~6m 57s) |
| Write key passed | ✅ |
| Flutter Build Release Apk | ✅ All 3 ABIs built (~312.6s) |
| APK signing | ✅ (part of assembleRelease) |
| Capture Android signing fingerprints | ❌ `exit code 1` — SHA-256 grep failed |
| Remote fingerprint summary | ❌ Not generated |
| Prerelease body fingerprint table | ❌ Not created (no release) |
| Android_signing_evidence artifact | ❌ Not present |
| 3 APK artifacts | ❌ Not uploaded (blocked) |
| Release created | ❌ Not created (blocked) |

---

## 15. Suggested Fix

The grep pattern needs to be more robust. Options:

1. **Use a broader regex:** `grep -i "sha.*256.*digest"` to match regardless of hyphenation or case
2. **Add debug output before the guard:** `cat "$cert_file"` to see the actual apksigner output in the log before attempting the grep
3. **Use `apksigner verify --print-certs --verbose`** to ensure consistent output format
4. **Trim whitespace from the extracted value:** `sha256="$(... | tr -d '\r' | xargs)"` to handle CRLF issues
5. **Fallback approach:** Also try `grep -m 1 "certificate SHA256"` or parse the DN line as confirmation that the cert file is valid before bailing

---

## 16. Client/User Decision Needed

**Yes — fix the grep pattern and re-trigger.**

1. **Fix the SHA-256 extraction in the workflow YAML.** The build and signing are proven to work. The only issue is the grep/sed parsing of apksigner output in step 11's script.

2. **Consider adding debug output** (`cat "$cert_file"`) before the grep to make future failures transparent in the log.

3. **Re-trigger Build workflow_dispatch after the fix.** The pipeline through step 10 is solid — this is purely a script parsing bug in the newly-added fingerprint summary generation.

---

*This artifact is monitor evidence. Run `26714004486` failed at step 11 due to a SHA-256 fingerprint extraction grep mismatch in the newly-added `remote-fingerprint-summary.md` generation script. The build, signing, and APK production (steps 1–10) all passed. The fix is a script adjustment in the workflow YAML — no secrets, Gradle, or keystore changes needed.*
