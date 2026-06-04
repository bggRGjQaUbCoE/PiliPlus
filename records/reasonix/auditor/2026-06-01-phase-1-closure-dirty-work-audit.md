# Phase 1 Closure Dirty-Work Audit

Audience classification: agent-facing.

Date: 2026-06-01
Auditor: Reasonix (role_id: auditor)
Target repo: CometDash77/PiliAvalon-Worksite
Review owner: Codex
Status: candidate evidence — not citable until Codex reviews and writes a matching review artifact

## Reading Scope

Commands executed (all read-only, within allowed set):

| # | Command | Result |
|---|---------|--------|
| 1 | `git status --short` | exit 0 — 49 M (unstaged) + 32 ?? (untracked) |
| 2 | `git diff --stat` | exit 0 — working tree vs HEAD, records-only |
| 3 | `git diff --name-status` | exit 0 — 49 files M, all records/meta |
| 4 | `git diff -- lib/utils/image_utils.dart` | exit 0 — EMPTY (no working-tree diff) |
| 5 | `git diff --name-status eda5bee71..HEAD -- ':!records/**'` | exit 0 — 90 files changed, product code affected |
| 6 | `git rev-parse HEAD` | exit 0 — efd5c54d832acc6ed49522422703b367f3320f68 |
| 7 | `git diff eda5bee71..HEAD -- lib/utils/image_utils.dart` | exit 0 — 4 lines changed (SaveResult? → SaveResult) |
| 8 | `git diff --stat eda5bee71..HEAD -- ':!records/**'` | exit 0 — 90 files, +83797/-1455 |
| 9 | `git log --oneline eda5bee71..HEAD` | exit 0 — 10 commits |
| 10 | `git branch --show-current` | exit 0 — phase-1-shielding-core |
| 11 | `git log -1 --format='%H %s' eda5bee71` | exit 0 — confirmed APK ref commit message |

## Factual Findings

### Finding 1: Branch Name Mismatch (CRITICAL)

- **Dispatched branch**: `phase-1-shielding-acceptance-fixes`
- **Actual current branch**: `phase-1-shielding-core`
- **Evidence**: `git branch --show-current` returned `phase-1-shielding-core` (command 10).
- **Impact**: The dispatch prompt targets a branch that is not currently checked out. All audit findings below are against `phase-1-shielding-core`, not the stated `phase-1-shielding-acceptance-fixes`. The dispatch prompt's branch reference is stale or incorrect.

### Finding 2: HEAD SHA Mismatch (CRITICAL)

- **Dispatched evidence HEAD**: `ce45458c0`
- **Actual HEAD**: `efd5c54d832acc6ed49522422703b367f3320f68`
- **Evidence**: `git rev-parse HEAD` returned `efd5c54...` (command 6). The SHA `ce45458c0` does not appear in the commit log between eda5bee71 and HEAD (command 9).
- **Impact**: The dispatch prompt references a commit that is not the current HEAD on the checked-out branch. The audit is therefore against the actual HEAD, not the stated evidence HEAD.

### Finding 3: Dirty Worktree — Records/Meta Only, Product Code Clean

- **Working tree modified (unstaged) files**: 49 files (command 1, command 3). All modified files are in:
  - `records/reasonix/auditor/` (14 files)
  - `records/reasonix/implementer/` (1 file)
  - `records/reasonix/monitor/` (13 files)
  - `records/reasonix/review/` (4 files)
  - `records/reasonix/verifier/` (1 file)
  - `records/session/` (14 files)
  - `records/worksite-communications/` (2 files)
  - `.codex/settings.json`, `README.md`, `phase1-report.md` (3 meta files)
- **Working tree untracked files**: 32 entries (command 1), all in `.reasonix/`, `.codex-artifacts/`, `.codex/hooks/`, `records/`, `AGENTS.md`, `build_*.yml`, and the dispatch prompts file itself.
- **Product code in working tree**: `git diff -- lib/utils/image_utils.dart` returned empty (command 4). No product code file appears in `git status --short` as modified or untracked.
- **Conclusion**: The working tree is dirty with records/documentation/meta changes ONLY. Zero product code files (`lib/`, `android/`, `test/`, `.github/workflows/`) have uncommitted modifications. This is a "clean product-code" dirty state — the code that would ship has no uncommitted edits.

### Finding 4: Product Code IS Changed Relative to APK Ref (eda5bee71)

- **Scope**: `git diff --name-status eda5bee71..HEAD -- ':!records/**'` (command 5) shows 90 files changed between the APK ref and current HEAD, excluding records.
- **Product code files changed** (committed, not dirty):
  - `lib/utils/image_utils.dart`: 4 lines (SaveResult? → SaveResult nullability fix) — command 7
  - `lib/features/shielding/`: shielding_adapters.dart, shielding_matcher.dart, shielding_migration.dart, shielding_models.dart, shielding_store.dart — substantial changes
  - `lib/common/widgets/video_card/shield_quick_action.dart`: 147 lines changed
  - `lib/grpc/reply.dart`: 11 lines changed
  - `lib/http/video.dart`: 80 lines changed
  - `lib/pages/common/common_list_controller.dart`: 4 lines changed
  - `lib/pages/rcmd/controller.dart`: 3 lines removed
  - `lib/pages/setting/models/`: extra_settings.dart, recommend_settings.dart, shielding_settings.dart — various
  - `lib/pages/shielding_settings/view.dart`: 104 lines changed
  - `lib/pages/video/reply/widgets/reply_item_grpc.dart`: 28 lines changed
  - `lib/utils/recommend_filter.dart`: 24 lines added
  - `android/app/build.gradle.kts`: 21 lines (signing fingerprint parsing)
  - `android/build.gradle.kts`: 12 lines (kotlin plugin)
  - `.github/workflows/build.yml`: 80 lines (signing evidence artifact)
  - `test/`: 10 files modified, 1 deleted, 2 added
  - `pubspec.lock`: 472 lines (dependency updates)
- **Conclusion**: Product code is NOT "untouched" relative to the APK ref. The branch contains ~10 commits of product-code changes on top of the APK ref, including shielding fixes, signing hardening, CI changes, and test updates. This is expected for an acceptance-fixes branch but contradicts any literal reading of "product code remains untouched."

### Finding 5: Commit History Between APK Ref and HEAD

10 commits on top of eda5bee71 (command 9):

```
efd5c54d8 Record phase 1 governance escalation
e8e96787d Harden signing fingerprint parsing
07ae82c03 Publish signing fingerprint summary
11e5dedb4 Fix signing evidence artifact upload
f868d6206 fix android release kotlin plugin application
a5d0d075c record phase 1 release final gates review
2ed9c8beb record phase 1 ci x86 decision
bfded7c67 record phase 1 after-push monitor review
6f64672f8 fix phase 1 shielding acceptance blockers  <-- primary product-code commit
9c9669e47 records: sync phase 1 worksite progress
3a848f213 records: persist phase 1 shielding worker 4 governance analysis
```

The bulk of product-code changes is in `6f64672f8 fix phase 1 shielding acceptance blockers`.

### Finding 6: Missing Gates

The following gates are referenced in the AGENTS.md governance policy and remain open (Reasonix cannot close any of them):

| Gate | Status | Evidence |
|------|--------|----------|
| CI / automation green | Unknown — needs Monitor (Prompt B) | No run data in this audit scope |
| Runtime smoke | Evidence artifacts exist under `.reasonix/evidence-smoke/` and `.reasonix/evidence-check/`, but status not determined here | Screenshots, logcat, uiautomator dumps committed |
| Technical-lead review | Not yet performed / not yet recorded | No dedicated tech-lead review artifact found |
| Codex review | Partially recorded — 4 review artifacts exist but have unstaged modifications | `records/reasonix/review/*.md` all show `M` in working tree |
| Manual acceptance | Not yet performed | No manual acceptance record found |
| User physical-device retest | Evidence artifacts exist, but user retest gate not explicitly closed | `.reasonix/evidence-smoke/` and `.reasonix/evidence-check/` exist |
| Client acceptance | Not yet performed | No client acceptance record found |

### Finding 7: Technical-Review Evidence Status

- **Committed Codex review records**: Present in the commit history (commits 2ed9c8beb, bfded7c67, a5d0d075c reference "record phase 1 ... review").
- **Unstaged Codex review modifications**: 4 review files show `M` in `git status --short` (`records/reasonix/review/*.md`). These are edited in the working tree but not staged/committed.
- **Gap**: The working-tree modifications to Codex review records have not been committed. If these contain review conclusions about the current branch state, those conclusions are not yet part of the branch evidence.

### Finding 8: User Physical-Device Retest Status

- **Evidence artifacts committed**: Both `.reasonix/evidence-smoke/` and `.reasonix/evidence-check/` directories contain runtime smoke artifacts (screenshots, logcat dumps, uiautomator XML, window dumps, status files) committed to the branch.
- **Status**: The presence of these artifacts suggests a physical-device retest was performed at some point. However, the auditor has no means to verify:
  - Whether the evidence corresponds to the current HEAD or an earlier commit
  - Whether the test was performed by the user (as required) or by automation
  - Whether the test covers all acceptance criteria
- **Gap**: The user physical-device retest gate requires explicit user attestation. The evidence artifacts are candidate evidence, not a gate closure.

## Changes or Recommendations

1. **Fix branch reference in dispatch prompt**: The prompt targets `phase-1-shielding-acceptance-fixes` but the current branch is `phase-1-shielding-core`. Either switch branches or update the dispatch prompt.
2. **Fix HEAD reference in dispatch prompt**: The prompt states `ce45458c0` as evidence HEAD, but actual HEAD is `efd5c54d8`. Update the dispatch prompt if the SHA was a typo.
3. **Commit or reset unstaged Codex review modifications**: The 4 modified review files in the working tree should be either committed (if the reviews are complete) or reset (if accidental edits).
4. **Commit or clean up unstaged records modifications**: All 49 modified records files are unstaged. Consider whether these are intentional edits awaiting commit or artifacts of a bulk formatting operation (the CRLF warnings suggest possible line-ending normalization).
5. **Clarify "untouched" semantics**: The dispatch prompt asks to "confirm whether product code remains untouched relative to the stated product/APK ref." Product code is demonstrably NOT untouched (10 commits of changes). Clarify whether the intent was "working tree is clean of product-code edits" (TRUE) or "no product code changes since APK ref" (FALSE).

## Risks

| Risk | Severity | Detail |
|------|----------|--------|
| Branch mismatch | **High** | Audit may be against wrong branch — the actual `phase-1-shielding-acceptance-fixes` branch may differ |
| HEAD mismatch | **High** | Dispatch prompt references a non-existent HEAD SHA — `ce45458c0` not found |
| Unstaged review records | **Medium** | Codex review conclusions may be stale if unstaged modifications are not committed |
| LF/CRLF warnings | **Low** | 49 files show "LF will be replaced by CRLF" warnings — possible line-ending normalization in working tree, which may cause spurious diffs |
| Large untracked artifacts | **Low** | `.reasonix/truncated-results/` (26 files), `.reasonix/log-*` files, `.codex-artifacts/` — not tracked, may be accidentally committed later |

## Unknowns

1. Whether `phase-1-shielding-acceptance-fixes` branch actually exists and what its state is (not checked out).
2. Whether the CI runs on the actual branch (`phase-1-shielding-core`) have passed — requires Monitor (Prompt B) to determine.
3. Whether the user has completed physical-device retest against current HEAD — requires user attestation.
4. Whether the technical lead has reviewed and approved — no tech-lead review artifact found.
5. Whether the 49 unstaged modifications are intentional (e.g., bulk language-policy normalization) or accidental.
6. The content of `build_80f5e6d6a.yml` (untracked) — whether this is a CI artifact that should be cleaned up.

## Verification Results

All 11 read-only commands completed with exit 0. No verification commands failed. The evidence gathered is internally consistent.

Key verifications passed:
- `git diff -- lib/utils/image_utils.dart` returns empty → product code working tree is clean
- `git status --short` contains no `lib/`, `android/`, `test/` entries → no dirty product code
- `git rev-parse HEAD` returns a valid SHA
- `git log -1 eda5bee71` confirms the APK ref commit exists and matches the stated message

Key verifications flagged:
- Actual HEAD ≠ stated HEAD (efd5c54d8 ≠ ce45458c0)
- Actual branch ≠ stated branch (phase-1-shielding-core ≠ phase-1-shielding-acceptance-fixes)

## Client Decision Needed

Yes — the following require user/client decision:

1. **Branch/HEAD discrepancy**: Should the audit proceed against `phase-1-shielding-core` at `efd5c54d8`, or should the correct branch be checked out and the audit re-run?
2. **Unstaged modifications**: Should the 49 modified records files be committed, reset, or left as-is?
3. **"Untouched" intent**: Does "product code remains untouched" mean "working tree is clean" (PASS) or "zero product-code commits since APK ref" (FAIL — 10 commits exist)?

---

*Reasonix auditor run complete. This report is candidate evidence only. Codex must write or update a matching review artifact under `records/reasonix/review/...` before any conclusion from this report may be cited.*
