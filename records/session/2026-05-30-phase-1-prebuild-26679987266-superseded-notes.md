# Phase 1 Prebuild 26679987266 Superseded Notes

## Purpose

This GitHub Release is superseded and must not be used for user/manual
acceptance.

It was created after the repair commit
`5d0dfe67320ac9d23a3a1f3db4c1d0b1e24c6ad9`, and its APK filenames contain
`5d0dfe673`, but the GitHub tag points to the wrong commit:
`64649874376bfc7ccc5e8110db39e0a53baf66f0` on `main`.

Use `phase-1-prebuild.26680259984` instead.

## Release Type

prebuild, superseded.

## Branch / Commit / Tag

- Invalid tag: `phase-1-prebuild.26679987266`
- Tag target observed: `64649874376bfc7ccc5e8110db39e0a53baf66f0`
- Intended repair commit at the time: `5d0dfe67320ac9d23a3a1f3db4c1d0b1e24c6ad9`
- Replacement release: `phase-1-prebuild.26680259984`
- Replacement commit: `80f5e6d6a7c63b4439c313281be76235f94ab0e6`

## Related PRs / Issues

- Superseded during Phase 1 shielding repair publication.

## Automation Evidence

The build run succeeded, but the release tag target was wrong:

- Build run: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26679987266
- Invalid release: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26679987266

## Manual Acceptance

Not allowed. Do not use this package for manual acceptance.

## Changes

No acceptance changes are claimed for this superseded release.

## Known Risks

Using this release would repeat the prior tag-target mismatch problem.

## Sources / License / Attribution

No new external source code was copied for this superseded release.

## Rollback Plan

Use the replacement release `phase-1-prebuild.26680259984`. Preserve this
release only as publication-failure evidence.

## Not Covered / Still Yellow

- All manual acceptance gates are not covered by this superseded release.

## User Action Required

Do not install this release for acceptance. Use
`phase-1-prebuild.26680259984`.
