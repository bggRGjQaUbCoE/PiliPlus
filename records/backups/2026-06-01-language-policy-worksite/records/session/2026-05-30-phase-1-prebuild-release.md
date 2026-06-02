# Phase 1 Prebuild Release

- role: worksite-release
- session id: 2026-05-30-phase-1-prebuild-release
- date: 2026-05-30
- recorded at: 2026-05-30T01:50:29Z
- repo root: `/home/mo/Documents/piliavalon`
- writable GitHub repo: `CometDash77/PiliAvalon-Worksite`
- branch: `phase-1-shielding-core`

## Design-Instruction Source

Design-institute instruction, read-only:

```text
/home/mo/Documents/obsidian/VIBECODING.../Piliavalon/records/worksite-communications/2026-05-30-phase-1-prebuild-release-to-worksite.md
```

No design-institute files were modified.

## Release

- release URL: `https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26628409138`
- tag: `phase-1-prebuild.26628409138`
- title: `Phase 1 Prebuild - Manual Acceptance`
- release type: GitHub pre-release
- draft: false
- prerelease: true
- target commitish: `cf9ed10f0ce1c8c71925fd72e014d890ddcea221`
- published at: `2026-05-30T01:41:01Z`

## Attached Assets

Release assets verified after publication:

- `PiliAvalon_android_2.0.7-6a476b925+5008_arm64-v8a.apk`
- `PiliAvalon_android_2.0.7-6a476b925+5008_armeabi-v7a.apk`
- `PiliAvalon_android_2.0.7-6a476b925+5008_x86_64.apk`

Asset attachment note:

- The design-institute source evidence referenced existing Android build run
  `26628409138` at commit `cf9ed10f0ce1c8c71925fd72e014d890ddcea221`.
- The user clarified that APKs did not need to be downloaded into this local
  worktree.
- To avoid asking the user to download APKs from Actions artifacts and to avoid
  storing APKs locally, the worksite created the pre-release and then triggered
  GitHub Actions run `26670980273` with tag
  `phase-1-prebuild.26628409138` so GitHub attached APK assets directly to the
  pre-release.
- Therefore attached APK filenames reflect run `26670980273` head SHA
  `6a476b925d610238a19632bce86900eadfb1cd7a`, while the source evidence run
  remains `26628409138`.

## Source Actions Evidence

Design-institute source Android build evidence:

- workflow: `Build`
- run id: `26628409138`
- run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26628409138`
- branch: `phase-1-shielding-core`
- commit SHA: `cf9ed10f0ce1c8c71925fd72e014d890ddcea221`
- conclusion: `success`

Focused CI evidence:

- workflow: `Phase 1 Shielding Verify`
- run id: `26628278834`
- run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26628278834`
- conclusion: `success`

Release-asset attachment run:

- workflow: `Build`
- run id: `26670980273`
- run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26670980273`
- job URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26670980273/job/78614013909`
- branch: `phase-1-shielding-core`
- commit SHA: `6a476b925d610238a19632bce86900eadfb1cd7a`
- conclusion: `success`
- Android job steps verified successful: release APK build, rename, release,
  upload arm64-v8a, upload armeabi-v7a, upload x86_64.

## Release Notes

The release page contains the exact notes below.

```text
Purpose: manual acceptance only; this is not a formal release.

Branch: `phase-1-shielding-core`

Commit SHA: `cf9ed10f0ce1c8c71925fd72e014d890ddcea221`

Build run URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26628409138

Focused CI run URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26628278834

Automation status:

- Focused shielding tests/analyze: green.
- Android APK build: green.

Manual acceptance checklist:

1. Android install and launch.
2. Recommendation feed shielding behavior.
3. Comment-area shielding behavior.

Known limits:

- Not Phase 1 green.
- Not a formal release.
- Not merged to `main`.

Rollback path:

- Keep using the previous build, or delete this prebuild release.
- Do not merge `phase-1-shielding-core` to `main` until accepted.

Sources:

- No new external code copy in this release package.
- Phase 1 reuse decision remains `records/reuse-decisions/2026-05-29-phase-1-shielding-engine-reuse.md`.
- Upstream/fork GPL-3.0 attribution remains governed by design-institute records.

Packaging note:

- This GitHub pre-release is the manual acceptance distribution point required by the design institute.
- To avoid requiring the user to download APKs from GitHub Actions artifacts or storing APKs in the local worktree, the worksite triggered GitHub Actions run `26670980273` with tag `phase-1-prebuild.26628409138` to attach APK assets directly to this pre-release.
- Attached APK filenames therefore reflect run `26670980273` head SHA `6a476b925d610238a19632bce86900eadfb1cd7a`; the design-institute source evidence run remains `26628409138` at commit `cf9ed10f0ce1c8c71925fd72e014d890ddcea221`.
```

## GitHub CLI Repository Scope

All successful GitHub CLI commands that inspected or mutated repository state
for this release used explicit repository scope:

```text
-R CometDash77/PiliAvalon-Worksite
```

Successful scoped operations included:

- `gh release view phase-1-prebuild.26628409138 -R CometDash77/PiliAvalon-Worksite ...`
- `gh release create phase-1-prebuild.26628409138 ... -R CometDash77/PiliAvalon-Worksite`
- `gh workflow run build.yml ... -R CometDash77/PiliAvalon-Worksite`
- `gh run list -R CometDash77/PiliAvalon-Worksite ...`
- `gh run watch 26670980273 -R CometDash77/PiliAvalon-Worksite --exit-status`
- `gh run view 26670980273 -R CometDash77/PiliAvalon-Worksite ...`
- `gh release edit phase-1-prebuild.26628409138 ... -R CometDash77/PiliAvalon-Worksite`

Non-repository authentication and local help commands were not repository-state
operations.

## Manual Acceptance Status

This release is ready for user manual acceptance:

1. Android install and launch.
2. Recommendation feed shielding behavior.
3. Comment-area shielding behavior.

This record does not mark Phase 1 green.
