# Repository Identity Retarget

- role: worksite-retarget
- session id: 2026-05-29-repository-identity-retarget
- date: 2026-05-29
- repo root: `/home/mo/Documents/piliavalon`
- branch: `phase-1-shielding-core`
- writable GitHub repo: `CometDash77/PiliAvalon-Worksite`
- upstream/reference repo: `bggRGjQaUbCoE/PiliPlus`

## Scope Rule

This package is limited to the current worksite repository. It does not write to
or mutate upstream/reference repositories.

All repository-state `gh` commands used for this package must explicitly target:

```text
-R CometDash77/PiliAvalon-Worksite
```

## Remote Retarget Evidence

`origin` was normalized from the lowercase worksite URL to the canonical
worksite repository:

```text
origin  git@github.com:CometDash77/PiliAvalon-Worksite.git (fetch)
origin  git@github.com:CometDash77/PiliAvalon-Worksite.git (push)
upstream  https://github.com/bggRGjQaUbCoE/PiliPlus.git (fetch)
upstream  DISABLED (push)
```

Reference remotes `pilinara`, `pilisuper`, and `upstream` keep `pushurl`
disabled. Branch `phase-1-shielding-core` tracks `origin`.

## Classification

`worksite-owned-identity` was retargeted:

- README project title, badges, downloads, and star-history links.
- GitHub Actions repository conditions for pull-request build jobs.
- Release artifact names for Android, iOS, macOS, Windows, and Linux workflows.
- GitHub issue-template historical issue search links.
- App-visible product name constants and source-code/update URLs.
- Android, iOS, macOS, Linux, Debian, and Windows packaging display names.

`dependency-source` was left unchanged:

- `pubspec.yaml` git dependencies under `https://github.com/bggRGjQaUbCoE/*`.
- `pubspec.lock` resolved dependency URLs and refs.

`package-runtime-contract` was left unchanged pending an explicit package rename:

- `pubspec.yaml` package name `PiliPlus`.
- Dart imports and parts using `package:PiliPlus/...`.
- Android method channel string `PiliPlus`.

`historical-evidence` and `upstream-attribution` were left unchanged:

- Prior session records describing the earlier unscoped `gh` incident.
- Prior CI records and design alerts documenting `bggRGjQaUbCoE/PiliPlus`.
- Patch comments that cite historical upstream issue URLs.

## Verification Commands

Retarget package checks:

```text
git remote -v
git config --get-regexp 'remote\..*\.pushurl|branch\.phase-1-shielding-core\.remote'
rg 'bggRGjQaUbCoE/PiliPlus|piliavalon-worksite|github.repository ==|PiliPlus_(android|ios|windows|linux|macos)|PiliPlus-Win|PiliPlus\.AppDir|PiliPlus Linux|PRODUCT_NAME = PiliPlus|android:label="PiliPlus"|sourceCodeUrl|appName' README.md .github android ios macos assets windows lib/common/constants.dart records/session
git diff --check
gh workflow list -R CometDash77/PiliAvalon-Worksite
gh run list -R CometDash77/PiliAvalon-Worksite
```

No repo-level `gh` command was run without explicit `-R CometDash77/PiliAvalon-Worksite`.
