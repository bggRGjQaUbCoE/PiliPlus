# Phase 1 Shielding Option B Worksite Declaration

- role: master-agent
- session id: 2026-05-29-phase-1-shielding-option-b
- date: 2026-05-29
- repo: /home/mo/Documents/piliavalon
- branch: phase-1-shielding-core
- work package: option-b-handoff-and-evidence

## Writable Scope

- records/session/
- records/diffs/
- records/package-handoffs/
- Later explicitly assigned package task files only after this handoff evidence is complete.

## Non-Writable Scope Before Handoff Completion

- Product code.
- comment-adapter code, including lib/pages/common/reply_controller.dart and lib/pages/video/reply_reply/controller.dart.
- recommendation-adapter code.
- settings-entry code.

No product, comment-adapter, recommendation-adapter, or settings-entry code may be modified before the handoff is complete.

## Skills And Standards

- design audit
- variance review
- receiving-code-review workflow
- TDD and verification workflow

## Expected Evidence

- status, diff, and untracked snapshots from the start of the handoff
- reconstructed package handoff because the original package owner is not recoverable in this session
- yellow gaps for work that cannot be verified locally
- explicit test/build non-run reasons when Flutter, Dart, FVM, Android, or CI facilities are unavailable

## Execution Guardrails

- Treat existing uncommitted product changes as inherited state unless proven otherwise.
- Do not claim green test, build, Android, recommendation-flow, or comment-flow status without command output or manual evidence.
- Keep integration-verification yellow unless this session produces real logs.
