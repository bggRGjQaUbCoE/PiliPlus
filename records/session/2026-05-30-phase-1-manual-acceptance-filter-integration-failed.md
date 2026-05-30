# Phase 1 Manual Acceptance Filter Integration Failed

Date: 2026-05-30

## Release Under Test

- Release: `phase-1-prebuild.26675065521`
- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26675065521
- Release type: prebuild / GitHub pre-release, not latest/stable
- Worksite branch: `phase-1-shielding-core`

## User Manual Acceptance Result

The user-side manual acceptance result for `phase-1-prebuild.26675065521`
is mixed and does not close Phase 1 shielding:

- Android first screen / white-screen check: pass. The new prebuild no longer
  opens to a blank white first screen on the user's device.
- Shielding matching behavior: partial. Regex matching is effective in manual
  testing, but exact matching is ineffective.
- Comment-area shielding: fail/incomplete. The feature is not completely
  invalid, but the matching modes and interaction model do not meet Phase 1
  acceptance.
- Overall shielding manual acceptance: yellow/red. Phase 1 must not be marked
  green, stable, accepted, or complete.

## Failed Scope

The current aggregated shielding page is only a partial consolidation. Regex
rules can take effect, but exact-match rules do not take effect in the user's
manual test. This does not prove that the other settings screens, filtering
rules, and runtime comment/feed data paths have been truly integrated.

Observed acceptance boundary:

- The "total shielding page" did not make all page-level matching modes take
  effect.
- Regex matching works.
- Exact matching does not work.
- The page cannot be counted as a successful Phase 1 shielding integration.
- The user should not be asked to re-test the same unfixed behavior as if it
  were a new acceptance attempt.

## Interaction Requirement Boundary

The upstream PiliPlus comment long-press path can still work:

1. Long press a comment.
2. Choose free copy.
3. Select text.
4. Add the selected text to filtering.

That path is an existing upstream capability and is not the intended final
interaction model for this fork.

Source/term-source matching must not depend on the user manually typing or
manually adding rules in a settings page. It should be added through content
interactions in the product surface, including:

- recommendation feed home page interactions;
- video page interactions;
- comment-area interactions.

Phase 1 acceptance must evaluate this fork's integrated shielding behavior and
interaction-entry design, not only the inherited upstream manual-add route.

## Required Design-Institute Review

The next step is a design-institute review and fix plan, not a repeated user
acceptance request against the same uncorrected prebuild.

The design institute is requested to output:

- A full inventory of shielding settings entry points: every settings screen,
  every filtering rule type, and every comment/feed data path affected by
  Phase 1 shielding.
- A data-flow review from the aggregated shielding page into the real filtering
  engine.
- A root-cause classification for why regex matching works but exact matching
  does not: missing persistence, missing filtering-engine connection,
  incompatible rule format, isolated/read-only UI, matching-mode dispatch bug,
  or another identified cause.
- A formal interaction design for source/term-source matching that adds rules
  from recommendation feed home page, video page, and comment-area interactions,
  rather than relying on manual settings-page entry or the original upstream
  route as the only working path.
- Worksite-executable repair steps, acceptance criteria, and a test matrix for
  recommendation feed and comment-area shielding.
- A requirement that any next prebuild must include new code fixes, fresh
  automation evidence, and a user re-acceptance package.

## Current Phase 1 State

- Startup white-screen regression: cleared by user first-screen validation for
  `phase-1-prebuild.26675065521`.
- Shielding manual acceptance: failed/incomplete. Regex matching passed, exact
  matching failed, and interaction-based source/term-source rule addition is
  not yet accepted.
- Phase 1 green decision: blocked until a later fixed prebuild passes automated
  evidence and user manual acceptance.

## Governance Notes

- Do not mark this prebuild as stable/latest.
- Do not mark Phase 1 as green.
- Do not ask the user to repeat the same failed shielding acceptance before a
  new fix is produced.
- Preserve this record as the authoritative user manual acceptance result for
  `phase-1-prebuild.26675065521`.
