# Phase 1 Prebuild 26677982092 - Superseded Evidence

## Purpose

This GitHub Release is retained only as superseded automation evidence. It is
not the final Phase 1 shielding repair package and must not be used for manual
acceptance.

## Reason Superseded

The Android APK assets were produced by GitHub Actions build run `26677982092`
from branch `phase-1-shielding-core` at commit
`75eb67d337eb986201a99ba0044ea3729fe2fce6`, but the automatically created
release tag `phase-1-prebuild.26677982092` points to commit
`64649874376bfc7ccc5e8110db39e0a53baf66f0` on `main`.

Because the release tag does not identify the repaired commit, this package is
not suitable as final release evidence.

## Evidence Status

- Build run: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26677982092
- Runtime smoke run: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26678166462
- Correct repair commit: `75eb67d337eb986201a99ba0044ea3729fe2fce6`
- Incorrect tag target: `64649874376bfc7ccc5e8110db39e0a53baf66f0`

## User Action Required

Do not install this superseded package for Phase 1 shielding acceptance. Use the
later prebuild whose tag points to the repaired commit.
