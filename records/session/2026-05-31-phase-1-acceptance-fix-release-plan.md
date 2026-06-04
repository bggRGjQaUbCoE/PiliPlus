# phase 1 acceptance fix release plan

Audience classification: agent-facing.

## Normalization Note

This file was normalized under the 2026-06-01 worksite language policy. The active agent-facing record is English. The pre-normalization source is preserved at records/backups/2026-06-01-language-policy-worksite/records/session/2026-05-31-phase-1-acceptance-fix-release-plan.md.

## Record Classification

- Repository boundary: CometDash77/PiliAvalon-Worksite
- Worksite path: records/session/2026-05-31-phase-1-acceptance-fix-release-plan.md
- Artifact category: session record
- Evidence status: Historical or candidate session evidence. It cannot claim green, cannot close acceptance, and requires fresh verification before current status claims.
- Review owner: Codex

## Summary

Acceptance-fix release plan. It keeps release, CI, runtime smoke, manual acceptance, and client acceptance as separate gates.

## Preserved Evidence Anchors

- Repo: `CometDash77/PiliAvalon-Worksite`
- Branch context: `phase-1-shielding-core`
- Status: waiting for user-triggered Reasonix implementation/verifier/monitor artifacts
- - Reasonix candidate output is unreviewed until Codex writes a persisted review artifact under `records/reasonix/review/...`.
- - `C:\Users\77182\Documents\obsidian\review.md`
- - `records/session/2026-05-31-phase-1-repeat-failure-root-cause.md`
- The active acceptance blockers are `review.md` items #3, #7, #8, #9, and #10. Items #1/#2/#4/#5/#6 are not sufficient to mark Phase 1 green while these blockers remain open.
- - Existing tests that encode rejected behavior, especially storing username quick action as generic `ShieldRuleType.keyword`, must be replaced by failing tests for the intended semantics.
- - Turning comment shielding off must stop comment filtering, including paths that still use old `ReplyGrpc` / `banWordForReply` behavior.
- - Cover-install evidence must define and prove same `applicationId`, same signing certificate, and install-over-existing without uninstall, or explicitly mark this as pending user-device gate.
- - `records/reasonix/implementer/2026-05-31-phase-1-acceptance-fixes-*.md`
- - `records/reasonix/verifier/2026-05-31-phase-1-acceptance-verification-*.md`
- - `records/reasonix/monitor/2026-05-31-phase-1-github-runs-*.md`
- Release prep:
- - `records/reasonix/release/2026-05-31-phase-1-release-prep-*.md`
- - `records/reasonix/review/2026-05-31-phase-1-acceptance-fixes-codex-review.md`
- - `records/reasonix/review/2026-05-31-phase-1-github-runs-codex-review.md`
- - `records/session/2026-05-31-phase-1-release-decision.md`
- - `flutter analyze`

## Gate Boundary

Automation success, CI success, runtime smoke, technical-lead review, manual acceptance, and user/client acceptance are separate gates. This record cannot close any gate by itself.

## Citation Rule

Future worksite sessions may cite this record only with its evidence status and with fresh verification for any current-status claim.

