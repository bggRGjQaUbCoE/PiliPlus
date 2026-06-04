# Phase 1 Acceptance Fix + Release Plan

Date: 2026-05-31
Repo: `CometDash77/PiliAvalon-Worksite`
Branch context: `phase-1-shielding-core`
Status: waiting for user-triggered Reasonix implementation/verifier/monitor artifacts

## Authority Boundary

Codex is reviewer and dispatcher only for this phase until the user explicitly changes the governance model.

- Codex must not edit business code, trigger GitHub workflows, monitor long-running runs, publish a release, or invoke Reasonix/subagents directly.
- If Reasonix or any subagent work is needed, Codex must provide a prompt for the user to run manually.
- Reasonix candidate output is unreviewed until Codex writes a persisted review artifact under `records/reasonix/review/...`.
- No unpersisted chat text may be cited as implementation, verification, CI, release, or acceptance evidence.

## Source Evidence

Primary acceptance checklist:

- `C:\Users\77182\Documents\obsidian\review.md`

Root-cause report:

- `records/session/2026-05-31-phase-1-repeat-failure-root-cause.md`

The active acceptance blockers are `review.md` items #3, #7, #8, #9, and #10. Items #1/#2/#4/#5/#6 are not sufficient to mark Phase 1 green while these blockers remain open.

## Required Fix Scope

### #3 UP/User Keyword + Long-Press UX

- User/UP keyword shielding must be distinct from generic content title keyword shielding.
- User/UP keyword shielding must support split/token matching behavior comparable to title shielding.
- The video-card long-press shielding sheet must address the annotated layout issue: cover remains visible, action layout is cleaned up, and `保存封面` is not awkwardly placed as a shielding action.
- Existing tests that encode rejected behavior, especially storing username quick action as generic `ShieldRuleType.keyword`, must be replaced by failing tests for the intended semantics.

### #7 Legacy Upstream Filters

- Old upstream filter behavior must be bridged or migrated into the new shielding system.
- Old visible settings entrances must be hidden from settings and settings search after behavior is handled.
- Stored old values must not be deleted silently.
- Reasonix must prove old labels do not remain visible as parallel shielding configuration.

### #8 Settings Information Architecture

- Shielding settings must not be a vertical-only categorized list.
- It must support same-row/different-column category navigation where clicking a category switches or jumps to that category.
- Categories must cover user/UP, title keyword, tag, category, comment keyword/user, exact text, and legacy-compatible rules where applicable.

### #9 Scene Switch Isolation

- Recommendation and comment scene switches must independently control their filtering.
- Turning comment shielding off must stop comment filtering, including paths that still use old `ReplyGrpc` / `banWordForReply` behavior.
- Required test: comment switch off plus old comment keywords present means matching comments remain visible.

### #10 Signing / Cover-Install Compatibility

- Release APK build must fail if release signing secrets are absent.
- Release evidence must include certificate fingerprint artifacts.
- Cover-install evidence must define and prove same `applicationId`, same signing certificate, and install-over-existing without uninstall, or explicitly mark this as pending user-device gate.

## Required Reasonix Artifacts

Implementation:

- `records/reasonix/implementer/2026-05-31-phase-1-acceptance-fixes-*.md`

Verification:

- `records/reasonix/verifier/2026-05-31-phase-1-acceptance-verification-*.md`

GitHub run monitoring:

- `records/reasonix/monitor/2026-05-31-phase-1-github-runs-*.md`

Release prep:

- `records/reasonix/release/2026-05-31-phase-1-release-prep-*.md`

Codex reviews after Reasonix artifacts exist:

- `records/reasonix/review/2026-05-31-phase-1-acceptance-fixes-codex-review.md`
- `records/reasonix/review/2026-05-31-phase-1-github-runs-codex-review.md`
- `records/session/2026-05-31-phase-1-release-decision.md`

## Verification Gate

Reasonix must provide persisted evidence for:

- focused tests for user keyword split/token behavior
- old-entry hiding in settings and settings search
- legacy filter bridge/migration behavior
- comment switch isolation including old reply keyword path
- settings category navigation
- `flutter analyze`
- Android release build with signing guard
- runtime smoke evidence
- certificate fingerprint evidence
- cover-install proof or explicit pending user-device gate

## Codex Review Gate

Codex must reject the candidate if any of these are true:

- Old shielding entry points remain visible outside the new or explicitly labeled legacy-compatible system.
- Tests encode the old rejected behavior.
- CI/smoke evidence is described as user acceptance.
- Signing evidence is absent.
- Release build can silently fall back to debug signing when release signing secrets are missing.
- Reasonix claims Phase 1 green, client acceptance, manual acceptance, technical-lead review, or final release authority.

## Release Policy

Reasonix may prepare release evidence but must not publish by default.

After Codex review passes, the user must explicitly authorize release. If release execution must stay with Reasonix, Codex will provide a separate user-triggered release-runner prompt and then review the persisted output.

Phase 1 remains yellow until the user confirms real-device cover install and manual retest.
