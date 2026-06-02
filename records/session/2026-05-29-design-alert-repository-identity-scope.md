# design alert repository identity scope

Audience classification: agent-facing.

## Normalization Note

This file was normalized under the 2026-06-01 worksite language policy. The active agent-facing record is English. The pre-normalization source is preserved at records/backups/2026-06-01-language-policy-worksite/records/session/2026-05-29-design-alert-repository-identity-scope.md.

## Record Classification

- Repository boundary: CometDash77/PiliAvalon-Worksite
- Worksite path: records/session/2026-05-29-design-alert-repository-identity-scope.md
- Artifact category: session record
- Evidence status: Historical or candidate session evidence. It cannot claim green, cannot close acceptance, and requires fresh verification before current status claims.
- Review owner: Codex

## Summary

Normalized session record. It keeps reusable worksite evidence in English and points to the backup for the full source.

## Preserved Evidence Anchors

- - repo root: `/home/mo/Documents/piliavalon`
- - active branch: `phase-1-shielding-core`
- - intended writable GitHub repo: `CometDash77/PiliAvalon-Worksite`
- - upstream/reference repo: `bggRGjQaUbCoE/PiliPlus`
- records/session/2026-05-29-gh-repository-scope-guard.md
- The upstream/reference repo `bggRGjQaUbCoE/PiliPlus` is read-only reference
- Git remote state is mostly safe for Git writes:
- branch.phase-1-shielding-core.remote = origin
- gh workflow run phase1_shielding_verify.yml --ref phase-1-shielding-core
- Interpretation: an unscoped `gh` command resolved to upstream. No upstream
- command was:
- gh workflow run phase1_shielding_verify.yml --ref phase-1-shielding-core -R CometDash77/PiliAvalon-Worksite
- - `.github/workflows/build.yml` gates build jobs on
- `github.repository == 'bggRGjQaUbCoE/PiliPlus'` at multiple Android/iOS/Windows
- - `README.md` badges and star-history links target `bggRGjQaUbCoE/PiliPlus`.
- - `lib/common/constants.dart` contains the app source-code URL pointing at
- - `assets/linux/DEBIAN/control` and `windows/packaging/exe/make_config.yaml`
- - `pubspec.yaml` and `pubspec.lock` intentionally reference many
- `bggRGjQaUbCoE/*` dependency forks. These affect package resolution and must
- 1. Should `CometDash77/PiliAvalon-Worksite` become the primary public project
- 4. Which `bggRGjQaUbCoE/*` URLs are intentional dependency forks versus stale
- repository-identity references?
- - add a persistent guard that future `gh` commands must use explicit `-R` until
- - verify `git remote -v`, branch tracking, workflow dispatch, workflow run view,
- and push target all point to `CometDash77/PiliAvalon-Worksite`.

## Gate Boundary

Automation success, CI success, runtime smoke, technical-lead review, manual acceptance, and user/client acceptance are separate gates. This record cannot close any gate by itself.

## Citation Rule

Future worksite sessions may cite this record only with its evidence status and with fresh verification for any current-status claim.

