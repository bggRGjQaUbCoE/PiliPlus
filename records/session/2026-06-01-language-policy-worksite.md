# Worksite Language Policy Activation

Audience classification: agent-facing.

## Scope

- Repository: `CometDash77/PiliAvalon-Worksite`
- Local path: `C:\Users\77182\Documents\Coding\piliavalon`
- Branch: `phase-1-shielding-core`
- Date: 2026-06-01

## Changes

- Added root `AGENTS.md` as the active worksite governance surface.
- Preserved `.codex/hooks/guard_ci_monitor.py` and the existing `PreToolUse` CI monitor hook.
- Added `.codex/hooks/language_policy_hook.py` and configured reminder hooks for `SessionStart`, `UserPromptSubmit`, and `Stop`.
- Normalized active `records/worksite-communications/*.md` records to English agent-facing records.
- Normalized active `records/reasonix/**/*.md` reusable records to English agent-facing records with candidate-evidence and Codex-review boundaries.
- Normalized selected reusable internal `records/session/*.md` records to English while preserving raw feedback records and user-facing reports in their original language.
- Added audience classification to `phase1-report.md` and `README.md` so remaining Chinese is classified as user-facing.

## Backups

Pre-change copies were saved under:

`records/backups/2026-06-01-language-policy-worksite/`

## Diff Evidence

The unified diff for this activation pass is saved at:

`records/diffs/2026-06-01-language-policy-worksite.diff`

## Remaining Chinese Classification

Remaining Chinese is intentional when it is one of:

- User-facing product or decision-report text in `README.md` and `phase1-report.md`.
- Raw user feedback preserved in original language.
- Chinese product UI labels or historical path components.
- The required Reasonix response-instruction term `响应指令`.

## Reasonix Boundary

Reasonix output is candidate evidence only until persisted and Codex-reviewed. Reasonix cannot claim green, cannot push, cannot merge, cannot release, cannot close acceptance, and cannot replace user/client acceptance.
