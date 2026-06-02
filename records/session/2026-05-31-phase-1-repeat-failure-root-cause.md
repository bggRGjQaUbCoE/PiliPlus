# phase 1 repeat failure root cause

Audience classification: agent-facing.

## Normalization Note

This file was normalized under the 2026-06-01 worksite language policy. The active agent-facing record is English. The pre-normalization source is preserved at records/backups/2026-06-01-language-policy-worksite/records/session/2026-05-31-phase-1-repeat-failure-root-cause.md.

## Record Classification

- Repository boundary: CometDash77/PiliAvalon-Worksite
- Worksite path: records/session/2026-05-31-phase-1-repeat-failure-root-cause.md
- Artifact category: session record
- Evidence status: Historical or candidate session evidence. It cannot claim green, cannot close acceptance, and requires fresh verification before current status claims.
- Review owner: Codex

## Summary

Root-cause analysis for repeated Phase 1 acceptance failures. It separates automation success from manual/user acceptance.

## Preserved Evidence Anchors

- Repo: `CometDash77/PiliAvalon-Worksite`
- Branch audited locally: `phase-1-shielding-core`
- - `C:\Users\77182\Documents\obsidian\review.md` (`LastWriteTime: 2026-05-31 17:14:40`)
- - `records/session/2026-05-31-design-institute-phase-1-feedback-review.md`
- - `records/session/2026-05-31-phase-1-manual-acceptance-user-original-feedback.md`
- The original earlier customer feedback is preserved in `records/session/2026-05-31-phase-1-manual-acceptance-user-original-feedback.md:17-18`.
- Image annotations referenced by `review.md` were found and visually inspected:
- - `C:\Users\77182\Documents\obsidian\assets\review\file-20260531170356318.png`
- - `C:\Users\77182\Documents\obsidian\assets\review\file-20260531170604020.png`
- - `C:\Users\77182\Documents\obsidian\assets\review\file-20260531170802946.png`
- - `C:\Users\77182\Documents\obsidian\assets\review\file-20260531170903342.png`
- - `C:\Users\77182\Documents\obsidian\assets\review\file-20260531171025400.png`
- 2. Tests asserted the implemented model, including wrong behavior such as UP username quick action becoming generic `keyword` and not supporting the expected title-like split-word workflow.
- - `.github/workflows/phase1_shielding_verify.yml:45-55` runs shielding tests, settings-model test, bootstrap startup test, and analyze.
- - Existing tests are model/adapter heavy. They prove `ShieldMatcher` and store behavior, but not end-to-end product behavior through upstream old settings and real feed payload shape.
- The most important example of a bad test is `test/features/shielding/video_card_shield_quick_action_test.dart:17-19`, which asserts the rejected behavior: username keyword is stored as generic `ShieldRuleType.keyword`.
- 1. Same Android `applicationId`.
- | Is the artifact workflow-dispatch release? | Workflow writes `android/key.properties` only if `SIGN_KEYSTORE_BASE64` is non-empty (`build.yml:86-95`). | If secrets are missing, no release key is configured. |
- | Is signing evidence uploaded? | No `apksigner verify --print-certs` digest artifact was found in the workflow. | Reviewers cannot compare certificate fingerprints across prebuilds. |
- - Main agents must not run long-running CI monitors directly (`records/session/2026-05-30-worksite-ci-monitor-policy.md:21-31`).
- - Only a delegated monitor role may do that (`records/session/2026-05-30-worksite-ci-monitor-policy.md:39-44`).
- - The hook blocks `gh run watch`, polling loops, and related monitor commands for main-agent roles (`.codex/hooks/guard_ci_monitor.py:35-50`, `63-80`).
- 1. Add user-specific rule type(s), e.g. `userKeyword`/`upKeyword`, and remove `authorName` from generic content `keyword` matching.
- 2. Route UP quick-action username shielding to the user-specific rule type. Update tests so the current `keyword` expectation fails first.
- 3. Implement recommendation tag fallback: real tags when present; category/`tname` fallback in recommendation and related-video surfaces for Phase 1.
- 5. Decide comment legacy policy: either migrate/hide `banWordForReply` or wire it so the new comment switch controls the effective filtering path. Add tests around `ReplyGrpc.needRemoveGrpc`.
- 6. Hide old shielding entry points from `recommendSettings`, `extraSettings`, and settings search once their behavior is migrated or intentionally classified as legacy compatibility.
- 8. Add signing gates: fail workflow if signing secrets are absent for release prebuild, upload `apksigner` certificate fingerprints, and add an install-over-previous-release acceptance step.
- - `git status --short --branch`
- - `rg --files` for review records and image candidates

## Gate Boundary

Automation success, CI success, runtime smoke, technical-lead review, manual acceptance, and user/client acceptance are separate gates. This record cannot close any gate by itself.

## Citation Rule

Future worksite sessions may cite this record only with its evidence status and with fresh verification for any current-status claim.

