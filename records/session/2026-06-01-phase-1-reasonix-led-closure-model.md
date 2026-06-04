# Phase 1 Reasonix-Led Closure Model

Audience classification: agent-facing.

Date: 2026-06-01
Decision owner: Codex
Repository boundary: CometDash77/PiliAvalon-Worksite
Status: Phase 1 yellow / not green

## Purpose

This record updates the Phase 1 closure operating model after records persistence at evidence/governance HEAD `ce45458c0`.

Product/APK reference remains `eda5bee71c2a1f0a0d15187d7104b7bda7a5a915`. This records-only update does not authorize product code edits, workflow edits, merge, release, or acceptance closure.

## Operating Model

Reasonix is the active labor owner for:

- dirty-work audits;
- GitHub Actions run watching;
- evidence summarization;
- candidate review and monitor reports persisted under `records/reasonix/...`.

Codex remains the owner for:

- principle setting;
- Reasonix prompt review;
- authority-boundary enforcement;
- Codex review artifacts;
- final interpretation of whether persisted Reasonix candidate evidence is citable.

User or human owner remains responsible for:

- physical-device retest;
- real-device cover-install evidence;
- client or user acceptance decisions.

## Governance Interpretation

Reasonix may perform Phase 1 closure review missions as candidate evidence and operational watch only. Reasonix output is not citable until it is persisted under `records/reasonix/...` and a matching Codex review artifact exists or Codex writes a fresh review in the current session.

Reasonix cannot claim Phase 1 green, cannot push, cannot merge, cannot release, cannot modify governance policy or workflow definitions, and cannot close runtime smoke, manual acceptance, technical-lead review, client acceptance, or user acceptance gates.

Automation green, CI green, runtime smoke green, technical-lead acceptance, and user/client acceptance remain separate gates. Passing one gate does not close another.

## Closure Matrix

| Gate | Owner | Current status | Closure requirement |
| --- | --- | --- | --- |
| Dirty-work audit | Reasonix candidate, Codex review | Open | Persisted `records/reasonix/...` report plus Codex review artifact. |
| GitHub Actions watch | Reasonix candidate, Codex review | Open if runs exist | Persisted monitor report with run IDs, URLs, conclusions, artifact names, and unknowns, then Codex review. |
| Technical review evidence | Reasonix candidate, Codex review | Open | Persisted technical review candidate plus Codex review accepting or restricting findings. |
| Physical-device retest | User/human | Open | Persisted user/human retest evidence for the referenced APK/product ref. |
| Client/user acceptance | User/human | Open | Explicit persisted acceptance decision. |
| Phase 1 green | Codex after all required gates | Blocked | Technical review evidence and physical-device user retest evidence must both be persisted and reviewed where applicable. |

## Stop Condition

If Reasonix or user evidence reports a product bug, Phase 1 closure stops. No bug-fix phase may start without explicit user authorization.

## Verification Requirement For Records Commits

Before committing records from this closure model:

- `git diff -- lib/utils/image_utils.dart` must be empty.
- `git diff --name-status eda5bee71..HEAD -- ':!records/**'` must be empty.
- Any staged diff must contain only `records/**`.

If inherited worktree or branch state makes one of these checks fail, record the exact failing output and do not claim a clean closure state.
