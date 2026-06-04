# Phase 1 Release Build Workflow Dispatch Monitor

Date: 2026-05-31
Review owner: Codex
Monitor target: Latest user-triggered `Build` workflow_dispatch on `phase-1-shielding-core`
Monitored artifacts: run `26680259984` (head SHA `80f5e6d6a`)

Status: **Candidate monitor evidence only.** Does not close any release gate.

---

## 1. Reading Scope

Files read and verified:

- `.github/workflows/build.yml` (at local HEAD `a5d0d075c`, which includes signing-evidence steps added in `6f64672f8`)
- `records/reasonix/review/2026-05-31-phase-1-release-final-gates-codex-review.md`
- `records/reasonix/review/2026-05-31-phase-1-github-after-push-codex-review.md`
- `.github/workflows/build.yml` at run commit `80f5e6d6a` (via `git show`) — confirmed signing-evidence steps **not present**
- Git diff `80f5e6d6a..6f64672f8` — confirmed signing-evidence steps added in `6f64672f8`
- `git log --oneline --all --graph` for commit timeline

---

## 2. Factual Findings

1. The latest `Build` workflow_dispatch for branch `phase-1-shielding-core` is run `26680259984` at commit `80f5e6d6a` ("ci: bind prebuild releases to workflow commit").
2. The run concluded **success**; all release Android steps passed; the Dev Apk step was correctly skipped (`if: github.event_name == 'pull_request'`).
3. The workflow at `80f5e6d6a` did **not** contain the `Capture Android signing fingerprints` or `上传签名证据` steps. Those were added later in commit `6f64672f8` ("fix phase 1 shielding acceptance blockers").
4. A pre-release `phase-1-prebuild.26680259984` ("Phase 1 Prebuild - Manual Acceptance") was created with all three APK ABIs as release assets.
5. The `Write key` step at `80f5e6d6a` used a soft-fail pattern (`if [ ! -z ... ]`) that silently skipped signing when secrets were missing. This was hardened to a hard-fail (`exit 1`) in `6f64672f8`.
6. The Codex review documents (`2026-05-31-phase-1-release-final-gates-codex-review.md` and `2026-05-31-phase-1-github-after-push-codex-review.md`) both reference commits **after** `80f5e6d6a` (specifically `2ed9c8beb` and `6f64672f8`). Neither review has seen a Build run with the signing-evidence workflow steps.

---

## 3. Workflow Run Identity

| Field | Value |
|---|---|
| Run ID | `26680259984` |
| Run URL | https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26680259984 |
| Event | `workflow_dispatch` |
| Branch | `phase-1-shielding-core` |
| Head SHA | `80f5e6d6a7c63b4439c313281be76235f94ab0e6` |
| Status | `completed` |
| Conclusion | `success` |
| Created | 2026-05-30T09:21:20Z |
| Updated | 2026-05-30T09:28:48Z |

---

## 4. Job Results

### Release Android — `success`

| Step # | Step Name | Conclusion |
|---|---|---|
| 1 | Set up job | success |
| 2 | 代码迁出 | success |
| 3 | 构建Java环境 | success |
| 4 | 安装Flutter | success |
| 5 | Apply Patch | success |
| 6 | Write key | success |
| 7 | Set and Extract version | success |
| 8 | Flutter Build Release Apk | success |
| 9 | Flutter Build Dev Apk | **skipped** (correct — PR-only) |
| 10 | Rename | success |
| 11 | Resolve release tag | success |
| 12 | Release | success |
| 13 | 上传 (arm64-v8a APK) | success |
| 14 | 上传 (armeabi-v7a APK) | success |
| 15 | 上传 (x86_64 APK) | success |
| — | **Capture Android signing fingerprints** | **NOT PRESENT in workflow at this commit** |
| — | **上传签名证据** | **NOT PRESENT in workflow at this commit** |
| 28 | Post 安装Flutter | success |
| 29 | Post 构建Java环境 | success |
| 30 | Post 代码迁出 | success |
| 31 | Complete job | success |

No failed steps in the Release Android job.

### Other Jobs

| Job | Conclusion | Note |
|---|---|---|
| mac | skipped | `build_mac` input default `true` but workflow used reusable workflow — skipped |
| ios | skipped | `build_ios` input default `true` but workflow used reusable workflow — skipped |
| win_x64 | skipped | `build_win_x64` input default `true` but workflow used reusable workflow — skipped |
| linux_x64 | skipped | `build_linux_x64` input default `true` — skipped |

All non-Android jobs were skipped. No failure logged.

---

## 5. Artifact Inventory

### Workflow Artifacts

| Artifact ID | Artifact Name | Size (bytes) | Expired | URL |
|---|---|---|---|---|
| 7307178762 | `PiliAvalon_android_2.0.7-80f5e6d6a+5032_arm64-v8a.apk` | 24,509,081 | No | https://api.github.com/repos/CometDash77/PiliAvalon-Worksite/actions/artifacts/7307178762 |
| 7307178959 | `PiliAvalon_android_2.0.7-80f5e6d6a+5032_armeabi-v7a.apk` | 24,416,995 | No | https://api.github.com/repos/CometDash77/PiliAvalon-Worksite/actions/artifacts/7307178959 |
| 7307179146 | `PiliAvalon_android_2.0.7-80f5e6d6a+5032_x86_64.apk` | 25,482,872 | No | https://api.github.com/repos/CometDash77/PiliAvalon-Worksite/actions/artifacts/7307179146 |

- **arm64-v8a APK**: EXISTS ✅
- **armeabi-v7a APK**: EXISTS ✅
- **x86_64 APK**: EXISTS ✅ — marked **non-blocking** per user decision (dev/emulator path only)

### Release Assets

All three APKs are also published as assets on pre-release `phase-1-prebuild.26680259984`:

| Asset | Size | Downloads |
|---|---|---|
| `PiliAvalon_android_2.0.7-80f5e6d6a+5032_arm64-v8a.apk` | 24,509,081 | 4 |
| `PiliAvalon_android_2.0.7-80f5e6d6a+5032_armeabi-v7a.apk` | 24,416,995 | 0 |
| `PiliAvalon_android_2.0.7-80f5e6d6a+5032_x86_64.apk` | 25,482,872 | 0 |

### Artifact Naming Note

Artifacts are named after individual APK file basenames instead of the expected grouped names (`Android_arm64-v8a`, `Android_armeabi-v7a`, `Android_x86_64`) because `actions/upload-artifact@v7` with `archive: false` uses the uploaded file's basename as the artifact name when the path resolves to a single file. This is expected behavior — not an error.

---

## 6. Signing Evidence

### Android_signing_evidence Artifact

**NOT PRESENT.** The `Capture Android signing fingerprints` and `上传签名证据` workflow steps were not in `.github/workflows/build.yml` at commit `80f5e6d6a` (the commit this run executed against).

Evidence:
- `git show 80f5e6d6a:.github/workflows/build.yml` — no `signing`, `apksigner`, or `签名证据` text found.
- `git diff 80f5e6d6a..6f64672f8 -- .github/workflows/build.yml` — confirms both steps were added in `6f64672f8`.
- Steps 16–27 in the job are absent; the API returns exactly 19 steps.

### apksigner verify --print-certs

**NOT AVAILABLE.** No step captured this output.

### Certificate Fingerprints

**None.** No signing evidence was generated for this run.

### Write key Step Behavior

At `80f5e6d6a`, the `Write key` step used:
```bash
if [ ! -z "${{ secrets.SIGN_KEYSTORE_BASE64 }}" ]; then
  # decode and write key
fi
```
This is a **soft-fail pattern** — if signing secrets were missing the step would silently skip without error. It cannot be confirmed from this data whether signing actually occurred. The step concluded `success` either way.

The step was hardened to a hard-fail in `6f64672f8`:
```bash
if [ -z "${{ secrets.SIGN_KEYSTORE_BASE64 }}" ] || ... ; then
  echo "Release signing secrets are required..." >&2
  exit 1
fi
```

---

## 7. Risks

| Risk | Severity | Detail |
|---|---|---|
| Signing evidence absent | **High** | No `apksigner verify --print-certs` output exists for this run. Cannot confirm the APKs were signed with the expected certificate. The `Write key` soft-fail pattern means signing may not have occurred. |
| Workflow version mismatch | **High** | The Codex reviews reference post-`80f5e6d6a` commits. No Build workflow_dispatch has been run with the current workflow definition (which includes signing-evidence capture). |
| Cover-install verification impossible | **High** | Without signing evidence, cover-install compatibility with an existing signed release install cannot be confirmed from this monitor data. |
| Non-Android jobs skipped | **Low** | mac/ios/win_x64/linux_x64 jobs were skipped. Not a blocker per task scope (Android-only release path). |
| x86_64 APK | **Non-blocking** | Per user decision, x86_64 is dev/emulator path only and not required for release progression. |

---

## 8. Unknowns

1. **Whether the APKs are actually signed.** The `Write key` step concluded success, but with the soft-fail pattern, success is reported even if secrets were absent and no key was written. The Flutter build would still produce APKs (unsigned or debug-signed).
2. **Whether cover-install works.** Requires user device testing with these specific APK artifacts.
3. **Whether a newer Build workflow_dispatch with signing evidence should be triggered.** The workflow now has the signing-evidence steps (since `6f64672f8`), but no run has been triggered with that version. This is a user decision — not for this monitor to trigger.
4. **Certificate identity.** Even if signing occurred, the certificate fingerprint is unknown because no capture step existed.
5. **The `screen_brightness_android` Gradle issue.** This run didn't build a dev APK (correctly skipped for workflow_dispatch), so the x86_64 release APK built successfully. The Gradle issue only affects dev builds. It remains a CI risk but wasn't exercised here.

---

## 9. Verification Results

| Check | Result |
|---|---|
| `gh run list` confirms latest Build workflow_dispatch | ✅ Run `26680259984` |
| `gh run view` confirms status/completion | ✅ `completed` / `success` |
| `gh api .../jobs` confirms all release steps passed | ✅ No failures |
| `gh api .../artifacts` confirms 3 APK artifacts | ✅ All three ABIs present, not expired |
| `gh release view` confirms release assets | ✅ All three APKs published |
| `git show 80f5e6d6a:.github/workflows/build.yml` confirms workflow version | ✅ Signing steps absent |
| `git diff 80f5e6d6a..6f64672f8 -- build.yml` confirms signing steps added later | ✅ |
| Android_signing_evidence artifact exists | ❌ Not present |
| apksigner verify --print-certs output exists | ❌ Not captured |

---

## 10. Client/User Decision Needed

**Yes.** The following decisions are needed:

1. **Should a new Build workflow_dispatch be triggered** at the current branch tip (or at `6f64672f8` or later) to capture signing evidence with the updated workflow? The current workflow definition (as of local HEAD `a5d0d075c`) includes `Capture Android signing fingerprints` and `上传签名证据` steps, but no run has exercised them.

2. **Are the existing APKs from run `26680259984` acceptable** for cover-install and manual retest despite the absence of signing evidence from the CI pipeline? The user could download the APKs and verify signing locally via `apksigner verify --print-certs`.

3. **Release gates remain open.** Per Codex review in `2026-05-31-phase-1-release-final-gates-codex-review.md`:
   - Release `Build` workflow_dispatch result → candidate evidence exists (this report)
   - `Android_signing_evidence` → **not satisfied** for this run
   - `apksigner verify --print-certs` → **not satisfied** for this run
   - Real-device cover-install → **pending user action**
   - User manual retest → **pending user action**
   - Phase 1 green/accepted/complete → **not closed**

---

*This artifact is candidate monitor evidence only. Release decisions require Codex review of this persisted artifact plus separate user cover-install and manual retest evidence.*
