# Phase 1 GitHub Release-Candidate Monitor

Date: 2026-05-31
Monitor owner: Reasonix (Codex-delegated, read-only)
Role ID: monitor-github-release-candidate
Target repo: `CometDash77/PiliAvalon-Worksite`
Artifact category: monitor

**Explicit statement: this is unreviewed candidate output until Codex review.**

---

## Reading Scope

- `records/reasonix/review/2026-05-31-phase-1-acceptance-fixes-codex-review.md`
- `records/session/2026-05-31-phase-1-release-decision.md`
- `records/session/2026-05-31-phase-1-codex-implementation-verification.md`

## Local State

| Item | Value |
|------|-------|
| Local branch | `phase-1-shielding-core` |
| Local HEAD | `9c9669e477310d9fa1325ca454a022688dc31597` |
| Working tree | Modified (21 files, all Phase 1 acceptance-fix changes uncommitted) |
| Remote tracking | `origin/phase-1-shielding-core` at same commit (up to date) |

## Target Branch / Run and Commit SHA

The most recent workflow_dispatch runs for the Phase 1 acceptance-fix candidate are on branch **`phase-1-shielding-acceptance-fixes`** at commit **`eda5bee71c2a1f0a0d15187d7104b7bda7a5a915`**.

This commit differs from:
- Local `phase-1-shielding-core` HEAD (`9c9669e`)
- Remote `phase-1-shielding-acceptance-fixes` HEAD (`0e75bca` — the branch has moved forward since the workflow ran)

Three workflow_dispatch runs were triggered in sequence on this commit:

| Run ID | Workflow | Triggered | Duration | Conclusion |
|--------|----------|-----------|----------|------------|
| 26707276542 | Phase 1 Shielding Verify | 2026-05-31T08:06:31Z | 3m15s | **success** |
| 26707279023 | Build | 2026-05-31T08:06:39Z | 13m25s | **success** |
| 26707550380 | Android Runtime Smoke | 2026-05-31T08:20:20Z | 2m28s | **success** |

## Factual Run Status / Conclusion

All three runs completed with **success** conclusion. No job or step failures in the final sequence. However, two earlier attempts on the same branch failed:

| Run ID | Workflow | Conclusion | Time |
|--------|----------|------------|------|
| 26706610388 | Phase 1 Shielding Verify | **failure** | 2026-05-31T07:32:51Z |
| 26706624102 | Build | **failure** | 2026-05-31T07:33:26Z |

The failure pair was followed by the success pair ~34 minutes later, suggesting a fix was pushed and re-dispatched.

## Job / Step Failures (if any)

**None in the final three-run sequence.** All job steps in runs 26707276542, 26707279023, and 26707550380 concluded `success` (except intentionally skipped steps: `Flutter Build Dev Apk` and non-Android platform jobs `linux_x64`, `ios`, `win_x64`, `mac`).

### Run 26707276542 — Phase 1 Shielding Verify

Single job `Focused Flutter verification` — 9 substantive steps, all passed:
1. Checkout
2. Setup Flutter
3. Flutter version
4. Install dependencies
5. Run shielding tests
6. Run settings model test
7. Run bootstrap startup test
8. Analyze

### Run 26707279023 — Build

Single active job `Release Android` — all steps passed:
1. 代码迁出 (checkout)
2. 构建Java环境 (setup Java 17 / Zulu)
3. 安装Flutter (Flutter stable via subosito/flutter-action)
4. Apply Patch (pwsh, continue-on-error)
5. Write key (decoded SIGN_KEYSTORE_BASE64 → key.jks + key.properties)
6. Set and Extract version
7. Flutter Build Release Apk (`--split-per-abi`, ~10m50s build time)
8. Rename (ABI-suffixed APK names)
9. Resolve release tag → `phase-1-prebuild.26707279023`
10. Release (GitHub Release as prerelease)
11–13. 上传 (artifact uploads: arm64-v8a, armeabi-v7a, x86_64)

### Run 26707550380 — Android Runtime Smoke

Single job `Install and launch APK on emulator` — all steps passed:
1. Checkout
2. Download x86_64 APK artifact (from Build run)
3. List downloaded APK
4. Enable KVM for emulator
5. Android emulator install and launch smoke (~2m20s)
6. Upload runtime smoke evidence

## Artifact Names and IDs

### Build run (26707279023) — 3 APK artifacts

| Artifact ID | Name | Size |
|-------------|------|------|
| 7315162555 | `PiliAvalon_android_2.0.7-eda5bee71+5041_arm64-v8a.apk` | 24,512,977 bytes |
| 7315162710 | `PiliAvalon_android_2.0.7-eda5bee71+5041_armeabi-v7a.apk` | 24,420,051 bytes |
| 7315162860 | `PiliAvalon_android_2.0.7-eda5bee71+5041_x86_64.apk` | 25,484,444 bytes |

All three APKs are also published as GitHub Release assets under tag `phase-1-prebuild.26707279023` (Release ID: 332089568, prerelease, draft: false).

### Android Runtime Smoke run (26707550380) — 1 evidence artifact

| Artifact ID | Name | Size |
|-------------|------|------|
| 7315187616 | `android-runtime-smoke-evidence` | 2,064,133 bytes |

## Signing Fingerprint Artifact — ABSENT

**No signing fingerprint evidence artifact was produced.** The remote `build.yml` at commit `eda5bee` (the version that actually ran) does **not** contain:

- A "Capture Android signing fingerprints" step (`apksigner verify --print-certs`)
- A "上传签名证据" (upload signing evidence) step
- A `cover-install-requirements.txt` generation step

The local working tree's `build.yml` (modified, uncommitted on `phase-1-shielding-core`) **does** contain these steps, matching the #10 acceptance-fix requirements from the Codex review. However, these changes:
- Are not committed on any branch
- Have not been pushed to any remote
- Were not present in the workflow that produced the three APK artifacts

The remote `build.yml` at `eda5bee` also uses a non-strict signing-secret check (`if [ ! -z ... ]` — proceeds without signing if secrets are missing) rather than the strict check (`if [ -z ... ]; then exit 1; fi`) present in the local working tree.

## APK Artifact Presence — PRESENT

Three split-per-ABI release APKs exist as both workflow artifacts and GitHub Release assets. Version string: `2.0.7-eda5bee71+5041`.

| ABI | Release download |
|-----|-----------------|
| arm64-v8a | `https://github.com/CometDash77/PiliAvalon-Worksite/releases/download/phase-1-prebuild.26707279023/PiliAvalon_android_2.0.7-eda5bee71%2B5041_arm64-v8a.apk` |
| armeabi-v7a | `https://github.com/CometDash77/PiliAvalon-Worksite/releases/download/phase-1-prebuild.26707279023/PiliAvalon_android_2.0.7-eda5bee71%2B5041_armeabi-v7a.apk` |
| x86_64 | `https://github.com/CometDash77/PiliAvalon-Worksite/releases/download/phase-1-prebuild.26707279023/PiliAvalon_android_2.0.7-eda5bee71%2B5041_x86_64.apk` |

## Unknowns

1. **Signing certificate fingerprint** — Cannot be verified from remote artifacts. The APKs were signed (Write key step executed successfully), but the `apksigner verify --print-certs` output was never captured or uploaded. Without this, there is no remote evidence that the APK signing certificate matches the user's installed release certificate.
2. **What changed between failed and successful runs** — The two failure runs (26706610388, 26706624102) at 07:32–07:33 UTC and the success runs at 08:06–08:20 UTC are ~34 minutes apart. The commit SHA is the same (`eda5bee`) for both the failures and successes, so the fix was likely a workflow input change or secret configuration change, not a code change.
3. **`phase-1-shielding-acceptance-fixes` vs `phase-1-shielding-core` divergence** — The acceptance-fixes branch HEAD (`0e75bca`) is ahead of the run commit (`eda5bee`) and differs from `phase-1-shielding-core` (`9c9669e`). The relationship between these branches is not documented in the records read.
4. **Smoke evidence contents** — The `android-runtime-smoke-evidence` artifact (2 MB) was not downloaded or inspected. Its contents (screenshots, logs, etc.) are unknown.

## Risks

1. **No signing fingerprint evidence (HIGH)** — The #10 acceptance-fix requirement states "Workflow captures `apksigner verify --print-certs` evidence." This was not produced. Even though the APK was signed (Write key step succeeded), there is no remote artifact proving the signing certificate fingerprint. A real-device cover install cannot be validated against remote evidence without this.
2. **Workflow definition mismatch (MEDIUM)** — The local `build.yml` (with signing-evidence steps) differs from the remote `build.yml` that actually ran (without them). The signing-evidence improvement exists only in the uncommitted working tree on `phase-1-shielding-core`. If a release decision depends on signing evidence, a new workflow run with the updated `build.yml` must be triggered.
3. **Branch fragmentation (LOW)** — Three branches/commits are in play: `phase-1-shielding-core` (local work), `phase-1-shielding-acceptance-fixes` HEAD (`0e75bca`), and the run commit (`eda5bee`). The acceptance-fix workflow ran on a commit that is neither the local HEAD nor the current tip of its own branch.
4. **No `phase-1-shielding-core` build** — The local branch (`phase-1-shielding-core` at `9c9669e`) has never had a workflow_dispatch build. All builds were on `phase-1-shielding-acceptance-fixes`.

## Client Decision Needed

1. **Re-run with signing evidence?** — To satisfy the #10 acceptance gate, a new Build workflow_dispatch must be triggered from a branch that includes the signing-evidence steps (currently only in the uncommitted local working tree). Options:
   - Commit + push the local `build.yml` changes to a branch, then dispatch.
   - Cherry-pick the signing-evidence steps onto `phase-1-shielding-acceptance-fixes` and re-dispatch.
2. **Accept existing APKs for cover-install test?** — The user could download an APK from the existing release, perform a real-device cover install, and manually run `apksigner verify --print-certs` locally. This would satisfy the signing-evidence requirement without a new workflow run, but the evidence would be local, not remote-persisted.
3. **Reconcile branch strategy** — Decide whether `phase-1-shielding-core` or `phase-1-shielding-acceptance-fixes` is the authoritative Phase 1 branch before triggering any further workflows.

---

*End of monitor report. This is unreviewed candidate output until Codex review.*
