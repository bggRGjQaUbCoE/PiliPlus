# Phase 1 Fixed APK Manual-Review Readiness Audit

Audience classification: agent-facing.

Date: 2026-06-01
Auditor: Reasonix (role_id: auditor)
Target repo: CometDash77/PiliAvalon-Worksite
Review owner: Codex
Status: candidate evidence — not citable until Codex reviews and writes a matching review artifact

## Reading Scope

### Records read

| # | Path | Category |
|---|------|----------|
| 1 | `records/session/2026-06-01-phase-1-fixed-apk-target-switch.md` | Session decision record |
| 2 | `records/session/2026-06-01-phase-1-fixed-apk-manual-review-package.md` | User-facing review package |
| 3 | `records/reasonix/monitor/2026-05-31-phase-1-release-build-26714387748-monitor.md` | Reasonix monitor candidate |
| 4 | `records/reasonix/review/2026-05-31-phase-1-release-build-26714387748-codex-review.md` | Codex review artifact |
| 5 | `records/session/2026-05-31-design-institute-worksite-governance-escalation.md` | Governance escalation record |

### Verification commands executed

| # | Command | Exit | Summary |
|---|---------|------|---------|
| 1 | `git status --short` | 0 | 49 M (records/meta only) + 38 ?? (untracked) |
| 2 | `git diff --name-status phase-1-prebuild.26714387748..HEAD -- ':!records/**'` | 0 | **EMPTY** |
| 3 | `git status --short -- lib android test .github pubspec.lock` | 0 | **EMPTY** |
| 4 | `gh run view 26714387748 -R CometDash77/PiliAvalon-Worksite --json ...` | 0 | Run confirmed: completed, success |
| 5 | `gh api .../actions/runs/26714387748/artifacts --jq '...'` | 0 | 4 artifacts: 3 APKs + signing evidence |
| 6 | `gh api .../releases/tags/phase-1-prebuild.26714387748 --jq '...'` | 0 | Release confirmed: prerelease, 3 APK assets |
| 7 | `git rev-parse HEAD` | 0 | efd5c54d832acc6ed49522422703b367f3320f68 |
| 8 | `git log -1 --format='%H %s' phase-1-prebuild.26714387748` | 0 | e8e96787d — confirmed tag commit |

## Factual Findings

### Finding 1: Target Confirmed (PASS)

The APK target for Phase 1 manual review is `phase-1-prebuild.26714387748`, **not** `eda5bee71`.

- **Tag**: `phase-1-prebuild.26714387748`
- **Tag commit**: `e8e96787dabb5403348b5c1d71f7ba40970b0dcc` — "Harden signing fingerprint parsing" (command 8)
- **Run ID**: `26714387748`
- **Release URL**: `https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26714387748`
- **Target switch record**: `records/session/2026-06-01-phase-1-fixed-apk-target-switch.md` explicitly supersedes `eda5bee71` as the Phase 1 manual review target.

### Finding 2: Build Run Evidence Confirmed (PASS)

GitHub run `26714387748` and its artifacts are confirmed:

| Field | Value |
|-------|-------|
| Run status | `completed` |
| Run conclusion | `success` |
| Event | `workflow_dispatch` |
| Branch | `phase-1-shielding-core` |
| Head SHA | `e8e96787dabb5403348b5c1d71f7ba40970b0dcc` |
| Release tag | `phase-1-prebuild.26714387748` |
| Prerelease | `true` |

Artifacts (all not expired):

| # | Artifact name | Size | Artifact ID |
|---|---------------|------|-------------|
| 1 | `PiliAvalon_android_2.0.7-e8e96787d+5049_arm64-v8a.apk` | 24,576,093 B | 7317264644 |
| 2 | `PiliAvalon_android_2.0.7-e8e96787d+5049_armeabi-v7a.apk` | 24,489,651 B | 7317264837 |
| 3 | `PiliAvalon_android_2.0.7-e8e96787d+5049_x86_64.apk` | 25,552,359 B | 7317265011 |
| 4 | `Android_signing_evidence` | 2,096 B | 7317265122 |

Three APK assets are attached to the GitHub release. `Android_signing_evidence` is a separate artifact (not an asset on the release), also not expired.

Codex-reviewed signing fingerprint: `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`.

### Finding 3: Product Diff from Fixed Tag (PASS)

```
git diff --name-status phase-1-prebuild.26714387748..HEAD -- ':!records/**'
→ (empty — exit 0, zero files changed)
```

The current HEAD (`efd5c54d8`, "Record phase 1 governance escalation") differs from the fixed tag `phase-1-prebuild.26714387748` (`e8e96787d`, "Harden signing fingerprint parsing") **only by records commits**. Zero product code, build config, or test files differ when excluding `records/**`.

### Finding 4: Dirty Product Files (PASS)

```
git status --short -- lib android test .github pubspec.lock
→ (empty — exit 0, zero files)
```

No product code directories or files have uncommitted modifications. The working tree is clean for shipping code.

### Finding 5: Working Tree Dirty State (Records/Meta Only)

The full `git status --short` (command 1) shows:

- **49 modified (unstaged) files**: All in `records/` (45), `.codex/settings.json` (1), `README.md` (1), `phase1-report.md` (1), `records/worksite-communications/` (2). Zero product code.
- **38 untracked entries**: `.codex-artifacts/`, `.codex/hooks/`, `.reasonix/` logs and truncated results, `AGENTS.md`, `build_80f5e6d6a.yml`, `records/backups/`, `records/diffs/`, `records/reasonix/auditor/` (2 new), `records/reasonix/review/` (2 new), `records/session/` (4 new session records including the target-switch and review-package).

Per prior user instruction: keep as-is, do not reset.

### Finding 6: Manual-Review Checklist Gate Inventory

The manual-review package (`records/session/2026-06-01-phase-1-fixed-apk-manual-review-package.md`) enumerates 9 review items. The governance escalation record (`records/session/2026-05-31-design-institute-worksite-governance-escalation.md`) documents the current state from prior user feedback:

| # | Item | Pre-review status | Source |
|---|------|-------------------|--------|
| 1 | APK install | Open — pending user retest | Review package item 1 |
| 2 | Startup | Open — pending user retest | Review package item 2 |
| 3 | UP/user shielding | **Failed** — user reports regression to pre-2668025995 logic, worse than 26707279023 | Governance escalation §User Feedback |
| 4 | Long-press quick shield | Open/debt | Target switch §Manual Review Focus |
| 5 | #6/#7 tag and recommendation behavior | Open | Review package item 4 |
| 6 | #7 legacy compatibility | **Unverifiable** — old-rule baseline destroyed by deletion/reinstall | Governance escalation §Acceptance Findings |
| 7 | #8 settings organization | **Partially accepted** — IA clarity accepted | Governance escalation §Acceptance Findings |
| 8 | #9 comment shielding | **Unresolved** — "屏蔽整条评论文本" still exposed, user states meaningless | Governance escalation §Acceptance Findings |
| 9 | #10 signing/cover-install | **Baseline-limited** — no same-key installed baseline exists | Governance escalation §Acceptance Findings; Target switch §Closure Matrix |
| — | User/client acceptance | **Open** — must be explicitly recorded | Target switch §Closure Matrix |

### Finding 7: Governance Escalation Status

The design-institute escalation (`records/session/2026-05-31-design-institute-worksite-governance-escalation.md`) identifies a **governance-system defect**, not merely an implementation miss:

- Worksite agents over-weighted CI/build/signing success and under-weighted unresolved acceptance issues.
- User acceptance feedback was not converted into a durable controlling issue board.
- Regressions against prior APK behavior were not tracked as first-class blockers.
- Deferred/unverifiable gates (#7, #10) were not clearly separated from passed gates.

The escalation requests a Design Institute governance ruling on mandatory kanban-style issue tracking. This escalation is **still open** — no ruling is recorded in the audit scope.

### Finding 8: Closure Matrix — Current Gate Status

From the target-switch record (`records/session/2026-06-01-phase-1-fixed-apk-target-switch.md`):

| Gate | Owner | Status |
|------|-------|--------|
| Fixed APK build evidence | Codex (reviewed) | ✅ Reviewed baseline available |
| Product diff from fixed APK tag | Codex | ✅ Verified empty in this audit (Finding 3) |
| Dirty product files | Codex | ✅ Verified clean in this audit (Finding 4) |
| Physical-device APK retest | User/human | 🔴 Open |
| Same-key cover-install | User/human | 🟡 Baseline-limited |
| Reasonix finding classification | Reasonix + Codex | 🟡 Optional/open |
| Product bug triage | Codex after user feedback | 🔴 Open — #3 failed, #9 unresolved |
| User/client acceptance | User/human | 🔴 Open |
| Phase 1 green | Codex after all gates | 🔴 Blocked |

## Verification Results Summary

All 8 verification commands completed with exit 0. All 5 records were successfully read.

| Verification | Expected | Actual | Result |
|-------------|----------|--------|--------|
| 1. Target is phase-1-prebuild.26714387748, not eda5bee71 | Tag confirmed, target-switch record present | `phase-1-prebuild.26714387748` at `e8e96787d` confirmed via gh API | ✅ PASS |
| 2. Three APK artifacts + Android_signing_evidence | 4 artifacts, none expired | 3 APKs + 1 signing evidence artifact; release has 3 APK assets | ✅ PASS |
| 3. HEAD differs from fixed tag only by records | `git diff --name-status ... -- ':!records/**'` empty | EMPTY — exit 0, zero files | ✅ PASS |
| 4. No dirty product files | `git status --short -- lib android test .github pubspec.lock` empty | EMPTY — exit 0, zero files | ✅ PASS |
| 5. Manual-review checklist preserves open gates | All open gates explicitly listed | 9 review items enumerated; governance escalation documents #3 failed, #7 unverifiable, #9 unresolved, #10 baseline-limited | ✅ PASS |
| 6. Report does not claim Phase 1 green | Explicit non-green statement | This report does not claim Phase 1 green anywhere | ✅ PASS |

## Missing or Blocked Gates

The following gates are **open** and block Phase 1 closure:

1. **Physical-device APK retest** — User must install, launch, and exercise the fixed APK (`arm64-v8a` default) on a real device.
2. **#3 UP/user shielding** — Currently **failed** per prior user feedback. Retest must determine whether this build regresses from `26707279023`.
3. **#9 comment shielding** — **Unresolved** per prior user feedback. "屏蔽整条评论文本" still exposed.
4. **#10 cover-install** — **Baseline-limited**. Cannot be proven without a same-key installed baseline.
5. **#7 legacy compatibility** — **Unverifiable** with current device state. Old-rule baseline destroyed.
6. **User/client acceptance** — Must be explicitly recorded by the user.
7. **Design Institute governance ruling** — Open escalation; no ruling recorded.

## Risks

| Risk | Severity | Detail |
|------|----------|--------|
| #3 regression unaddressed | **High** | User explicitly reported #3 is worse than prior build. If not fixed, user acceptance will fail again. |
| Governance escalation unresolved | **High** | The worksite governance defect that caused prior acceptance failures has no Design Institute ruling. Without it, the same process failures may recur. |
| #7/#10 permanently unverifiable | **Medium** | Legacy compatibility and cover-install gates may never be closable in Phase 1 if baselines are lost. Explicit deferral/rationale needed. |
| Local dirty worktree | **Low** | 49 unstaged records modifications. Per user decision, kept as-is. Not blocking. |
| Evidence artifacts on wrong branch | **Low** | `.reasonix/evidence-smoke/` and `.reasonix/evidence-check/` directories are committed on `phase-1-shielding-core` but not on `phase-1-shielding-acceptance-fixes`. For this audit, the target is the fixed tag on `phase-1-shielding-core`, so this is not a mismatch. |

## Unknowns

1. Whether the Design Institute has responded to the governance escalation.
2. Whether the user has a physical device with a same-key installed baseline for #10 cover-install testing.
3. Whether the user plans to retest against this specific APK or defer to a future build.
4. Whether #3 can be fixed without a product-code change (and thus a new APK build).
5. Whether the `arm64-v8a` APK is the correct ABI for the user's physical device.

## Client Decision Needed

Yes — the following require user/client decision:

1. **Retest authorization**: Should the user proceed with physical-device retest against `PiliAvalon_android_2.0.7-e8e96787d+5049_arm64-v8a.apk` from `phase-1-prebuild.26714387748`, given that #3 is already known to be failed/unresolved per prior feedback?
2. **Product bug triage**: If #3 and #9 are still broken in this build, should Phase 1 closure stop and a new fix/build/retest cycle be authorized?
3. **Gate deferral**: Should #7 (legacy compatibility) and #10 (cover-install) be formally deferred with explicit rationale, or should the user attempt to restore baselines?

---

*Reasonix auditor run complete (fixed-APK manual-review readiness audit). This report is candidate evidence only. Codex must write or update a matching review artifact under `records/reasonix/review/...` before any conclusion from this report may be cited. Phase 1 remains not green.*
