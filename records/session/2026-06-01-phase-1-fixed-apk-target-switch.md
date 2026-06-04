# Phase 1 Fixed APK Target Switch

Audience classification: agent-facing.

Date: 2026-06-01
Decision owner: Codex
Repository boundary: CometDash77/PiliAvalon-Worksite
Branch context: `phase-1-shielding-core`
Status: Phase 1 yellow / not green

## Decision

Phase 1 manual review target is switched from the older APK/product reference `eda5bee71c2a1f0a0d15187d7104b7bda7a5a915` to the fixed signed prebuild:

- Fixed APK target: `phase-1-prebuild.26714387748`
- Build run ID: `26714387748`
- Build commit: `e8e96787dabb5403348b5c1d71f7ba40970b0dcc`
- Branch: `phase-1-shielding-core`
- Release URL: `https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26714387748`

The older closure model in `records/session/2026-06-01-phase-1-reasonix-led-closure-model.md` remains historical evidence for the previous target. This record supersedes its `eda5bee71...` APK target for Phase 1 manual review.

## Rationale

Run `26714387748` is the first reviewed fixed signed prebuild target that includes the Phase 1 shielding, signing, and CI evidence fixes. The local branch currently differs from tag `phase-1-prebuild.26714387748` only by records when excluding `records/**`, so a new product rebuild is not required before manual APK review unless manual review finds a product bug.

No product code, workflow, release, merge, or acceptance closure is authorized by this target switch.

## Reviewed Build Evidence Baseline

The following reviewed Reasonix build evidence is accepted as the release-build baseline for this manual review handoff:

- Reasonix monitor candidate: `records/reasonix/monitor/2026-05-31-phase-1-release-build-26714387748-monitor.md`
- Codex review: `records/reasonix/review/2026-05-31-phase-1-release-build-26714387748-codex-review.md`

Accepted baseline facts from the Codex-reviewed record:

- Build workflow run `26714387748` completed successfully.
- Head SHA was `e8e96787dabb5403348b5c1d71f7ba40970b0dcc`.
- Release `phase-1-prebuild.26714387748` exists.
- Three APK artifacts exist:
  - `PiliAvalon_android_2.0.7-e8e96787d+5049_arm64-v8a.apk`
  - `PiliAvalon_android_2.0.7-e8e96787d+5049_armeabi-v7a.apk`
  - `PiliAvalon_android_2.0.7-e8e96787d+5049_x86_64.apk`
- `Android_signing_evidence` exists.
- Reviewed signing fingerprint: `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

These facts do not close real-device install, launch, cover-install, manual acceptance, technical-lead acceptance, or user/client acceptance gates.

## Manual Review Target

Use the `arm64-v8a` APK unless the physical Android device requires another ABI. If the device requires another ABI, record the device ABI reason and selected APK filename.

Manual review must preserve:

- APK filename and source release tag.
- Install or cover-install result.
- Launch result, including whether startup is blank or crashes.
- Screenshots or screen recording when possible.
- Raw user feedback in the user's original language, unchanged.
- Any blocked or baseline-limited gate with the precise reason it cannot be proven.

## Phase 1 Manual Review Focus

The physical-device retest should focus on previously failed or unclear Phase 1 items:

| Item | Required retest focus | Current gate status before retest |
| --- | --- | --- |
| Startup | App launches with no blank screen or crash. | Open. |
| #3 UP/user shielding | User keyword shielding must apply to user identity matching, not generic content keyword matching. Quick UP shield should still provide UID shielding where available. | Open; prior feedback reported failure/regression. |
| Long-press quick shield | Verify the available long-press shielding action and capture whether the card/cover interaction is acceptable. | Open/debt; not sufficient alone to close functional gates. |
| #6/#7 tag and recommendation behavior | Tag rules should use real tags when present and category/`tname` fallback in recommendation or related-video surfaces. | Open. |
| #7 legacy compatibility | Legacy text rules should be imported/bridged into the new shielding system without duplicated visible old keyword layers. | Baseline-limited if the old-rule device state was already deleted. |
| #8 settings organization | Settings category entry and organization should be clear. | Partially accepted previously; retest for regression. |
| #9 comment shielding | Verify the remaining comment shielding semantics and whether meaningless whole-comment text shielding is still exposed. | Open due to later user feedback. |
| #10 signing and cover-install | Install over an existing same-package baseline without uninstall where possible. If no same-key installed baseline exists, record as blocked or baseline-limited, not passed. | Baseline-limited until a same-key installed baseline exists. |

## Closure Matrix

| Gate | Owner | Current status | Requirement to move forward |
| --- | --- | --- | --- |
| Fixed APK build evidence | Reasonix candidate plus Codex review | Reviewed baseline available | Use only with `records/reasonix/review/2026-05-31-phase-1-release-build-26714387748-codex-review.md`. |
| Product diff from fixed APK tag | Codex | Verified in current session | `git diff --name-status phase-1-prebuild.26714387748..HEAD -- ':!records/**'` must remain empty before handoff/commit. |
| Dirty product files | Codex | Verified in current session | `git status --short -- lib android test .github pubspec.lock` must remain empty before handoff/commit. |
| Physical-device APK retest | User/human | Open | Persist install, launch, screenshots/video if possible, and raw user feedback. |
| Same-key cover-install | User/human | Baseline-limited unless a same-key installed baseline exists | Record actual install path. If no same-key baseline exists, do not mark passed. |
| Reasonix finding classification | Reasonix candidate plus Codex review | Optional/open after feedback | Any Reasonix classification must be persisted under `records/reasonix/...` and Codex-reviewed before citation. |
| Product bug triage | Codex after user feedback | Open | If manual review reports a product bug, stop closure and request explicit authorization for a new fix/build/retest cycle. |
| User/client acceptance | User/human | Open | Must be explicitly recorded; automation and signing evidence cannot substitute for acceptance. |
| Phase 1 green | Codex after all gates | Blocked | Requires reviewed fixed APK evidence, persisted physical-device retest, reviewed Reasonix classification if used, no open product bug, and explicit user/client acceptance. |

## Reasonix Boundary

Reasonix may perform audit, classification, and monitor labor only. Reasonix output is candidate evidence until persisted under `records/reasonix/...` and reviewed by Codex.

Reasonix cannot claim green, cannot push, cannot merge, cannot release, cannot replace user/client acceptance, and cannot close runtime smoke, manual acceptance, technical-lead review, or client acceptance gates.

## Stop Condition

If manual APK review reports a product bug or a regression, do not continue toward Phase 1 green. Record the raw feedback unchanged, keep Phase 1 yellow, and request explicit user authorization before starting any new product-fix/build/retest cycle.
