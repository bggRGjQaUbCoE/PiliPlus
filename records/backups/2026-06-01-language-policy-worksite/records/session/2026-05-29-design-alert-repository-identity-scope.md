# Design Alert: Repository Identity Scope

- role: design-alert
- priority: high
- date: 2026-05-29
- repo root: `/home/mo/Documents/piliavalon`
- active branch: `phase-1-shielding-core`
- intended writable GitHub repo: `CometDash77/PiliAvalon-Worksite`
- upstream/reference repo: `bggRGjQaUbCoE/PiliPlus`

## Summary

The worksite repo still contains mixed repository identity signals. Git writes
currently target the worksite fork, but GitHub CLI default inference and several
tracked files still reference upstream. This is a high-priority governance item
for design review because a full retargeting pass can touch workflows,
documentation, packaging metadata, issue templates, app constants, and operator
instructions.

Do not treat this as a small incidental cleanup inside a feature fix. It needs a
dedicated design decision and scoped implementation plan.

## Immediate Guardrail

Persistent operator guard:

```text
records/session/2026-05-29-gh-repository-scope-guard.md
```

Until repository identity is redesigned, all GitHub CLI commands that operate
on GitHub repository state must explicitly include:

```text
-R CometDash77/PiliAvalon-Worksite
```

The upstream/reference repo `bggRGjQaUbCoE/PiliPlus` is read-only reference
only. Do not trigger workflows, push, create pull requests, open issues, or
perform other write/action operations there.

## Evidence

Git remote state is mostly safe for Git writes:

```text
origin    git@github.com:CometDash77/piliavalon-worksite.git
upstream  https://github.com/bggRGjQaUbCoE/PiliPlus.git
upstream.pushurl = DISABLED
branch.phase-1-shielding-core.remote = origin
```

GitHub CLI incident:

```text
gh workflow run phase1_shielding_verify.yml --ref phase-1-shielding-core
HTTP 404: Not Found (https://api.github.com/repos/bggRGjQaUbCoE/PiliPlus/actions/workflows/phase1_shielding_verify.yml)
```

Interpretation: an unscoped `gh` command resolved to upstream. No upstream
workflow was found or triggered, and no upstream code was changed. The corrected
command was:

```text
gh workflow run phase1_shielding_verify.yml --ref phase-1-shielding-core -R CometDash77/PiliAvalon-Worksite
```

Tracked files with upstream identity signals:

- `.github/workflows/build.yml` gates build jobs on
  `github.repository == 'bggRGjQaUbCoE/PiliPlus'` at multiple Android/iOS/Windows
  job conditions.
- `.github/ISSUE_TEMPLATE/bug-反馈.yml` and
  `.github/ISSUE_TEMPLATE/功能请求.yml` link users to upstream issue searches.
- `README.md` badges and star-history links target `bggRGjQaUbCoE/PiliPlus`.
- `lib/common/constants.dart` contains the app source-code URL pointing at
  upstream.
- `assets/linux/DEBIAN/control` and `windows/packaging/exe/make_config.yaml`
  contain upstream maintainer/homepage or publisher URLs.
- `pubspec.yaml` and `pubspec.lock` intentionally reference many
  `bggRGjQaUbCoE/*` dependency forks. These affect package resolution and must
  not be blanket-rewritten without dependency-source review.

## Design Questions

1. Should `CometDash77/PiliAvalon-Worksite` become the primary public project
   identity for workflows, issue templates, README badges, source-code URLs, and
   packaging metadata?
2. Should workflow conditions recognize only the worksite repo, or both worksite
   and upstream?
3. Should the upstream remote remain configured for read-only fetches?
4. Which `bggRGjQaUbCoE/*` URLs are intentional dependency forks versus stale
   repository-identity references?

## Recommended Next Package

Create a dedicated repository-identity retargeting package before modifying
these files. Minimum acceptance criteria:

- inventory every upstream reference by category: workflow behavior,
  documentation, packaging metadata, app-visible links, dependency source, and
  historical records.
- update only references approved by design; leave dependency forks alone unless
  a dependency-source replacement is explicitly approved.
- add a persistent guard that future `gh` commands must use explicit `-R` until
  the repo identity pass is complete.
- verify `git remote -v`, branch tracking, workflow dispatch, workflow run view,
  and push target all point to `CometDash77/PiliAvalon-Worksite`.

## Status

Open / high priority for design院. This alert records the issue; it does not
perform the broad retargeting.
