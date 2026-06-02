# phase 1 apk acceptance scope

Audience classification: agent-facing.

## Normalization Note

This file was normalized under the 2026-06-01 worksite language policy. The active agent-facing record is English. The pre-normalization source is preserved at records/backups/2026-06-01-language-policy-worksite/records/reasonix/auditor/2026-05-30-phase-1-apk-acceptance-scope.md.

## Record Classification

- Repository boundary: CometDash77/PiliAvalon-Worksite
- Worksite path: records/reasonix/auditor/2026-05-30-phase-1-apk-acceptance-scope.md
- Artifact category: Reasonix auditor candidate
- Evidence status: Candidate evidence only. It cannot claim green, cannot close acceptance, and requires Codex review before citation.
- Review owner: Codex

## Summary

APK acceptance-scope audit. It keeps install-over-existing, signing, and user acceptance separate from build availability.

## Preserved Evidence Anchors

- **Repo:** `CometDash77/PiliAvalon-Worksite`
- **Branch:** `phase-1-shielding-core`
- **HEAD:** `7670673b0c80c667136c03019381281049f640f9`
- **Previous Release tag:** `phase-1-prebuild.26680259984` → commit `80f5e6d6a`
- **Latest CI run:** 26686823386 → HEAD `7670673b0` ✅
- | Dimension | Release APK | CI Artifact `Android_x86_64` |
- | **Tag / Release** | `phase-1-prebuild.26680259984` | No tag (CI-only artifact) |
- | **Commit** | `80f5e6d6a` | `7670673b0` (HEAD, +6 commits ahead) |
- | **Build type** | `--release` (signed Release build) | `--release --android-project-arg dev=1` (dev build) |
- | **APK filename** | `PiliAvalon_android_2.0.7-80f5e6d6a+5032_*.apk` | `PiliAvalon_android_ci_7670673b0c80_x86_64.apk` |
- | **applicationId** | `com.example.piliplus` (release) | `com.example.piliplus.dev` (dev suffix) |
- | **Cover-install compatible** | ✅ Same `applicationId` as release installs | ⚠️ `.dev` suffix → different app, side-by-side |
- | 1 | `41b5a821` | CometDash77 | `records: publish phase 1 shielding repair prebuild` | Record-keeping |
- | 2 | `a6e97e6e` | CometDash Worksite | `ci: add phase 1 authoritative workflow` | CI workflow |
- | 3 | `62071ea9` | CometDash Worksite | `docs: record phase 1 ci failure evidence` | Documentation |
- | 4 | `b6bb438f` | CometDash Worksite | `Fix dev release Android resource packaging` | **Build fix** |
- | 5 | `30011208` | CometDash Worksite | `ci: resolve runtime smoke launcher activity` | CI/runtime smoke |
- | 6 | `7670673b` | CometDash Worksite | `records: persist runtime smoke launcher review` | Record-keeping |
- - Commit 2 adds the CI workflow (`.github/workflows/ci.yml`) → **not in APK**
- commits between `80f5e6d6a` and `7670673b0` do not change shielding feature
- `phase-1-prebuild.26680259984` arm64-v8a Release APK now.
- at `80f5e6d6a`, which is functionally representative of current HEAD for
- - Do not claim this is a latest-HEAD release APK. Latest HEAD `7670673b0` has no
- - ❌ `git add` / `git commit` / `git push`
- - ❌ `git merge`

## Reasonix Boundary

Reasonix output is candidate evidence only until it is persisted under records/reasonix/... and reviewed by Codex. Reasonix cannot claim green, cannot push, cannot merge, cannot release, cannot close acceptance, and cannot replace user/client acceptance. Reasonix cannot close runtime smoke, manual acceptance, technical-lead review, or client acceptance gates.

## Citation Rule

Future worksite sessions may cite this record only with its evidence status. If the record is a Reasonix candidate artifact, cite a matching Codex review artifact or write a fresh Codex review before relying on its conclusions.



