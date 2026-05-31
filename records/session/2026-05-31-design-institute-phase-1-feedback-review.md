# Phase 1 Feedback Review - Design Institute Technical Lead Decision

Date: 2026-05-31
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `phase-1-shielding-core`
Review target commit from request: `ce5f6915d` (`records: persist phase 1 acceptance feedback`)
Local Worksite HEAD during review: `3a848f213` (`records: persist phase 1 shielding worker 4 governance analysis`)
Role: design-institute / technical-lead review record
Scope: records-only review; no functional code, CI, release, merge, or push action.

## Files Read

Required persistent inputs:

1. `records/session/2026-05-31-design-institute-phase-1-user-original-feedback.md`
2. `records/session/2026-05-31-phase-1-manual-acceptance-user-original-feedback.md`
3. `records/reasonix/auditor/2026-05-30-phase-1-apk-acceptance-scope.md`
4. `records/reasonix/auditor/2026-05-30-phase-1-evidence-gap.md`

Reasonix auxiliary conclusions:

1. `records/reasonix/auditor/2026-06-01-reasonix-a-up-shielding-semantics.md`
2. `records/reasonix/auditor/2026-06-01-reasonix-b-tag-shielding-factcheck.md`
3. `records/reasonix/auditor/2026-06-01-reasonix-c-legacy-shielding-merge.md`
4. `records/reasonix/auditor/2026-06-01-reasonix-d-ux-settings-ia.md`

Selected implementation files spot-checked for decision support:

- `lib/features/shielding/shielding_models.dart`
- `lib/features/shielding/shielding_matcher.dart`
- `lib/features/shielding/shielding_adapters.dart`
- `lib/http/video.dart`
- `lib/utils/recommend_filter.dart`
- `lib/common/widgets/video_card/shield_quick_action.dart`
- `lib/common/widgets/video_card/video_card_h.dart`
- `lib/common/widgets/video_card/video_card_v.dart`
- `lib/pages/shielding_settings/view.dart`

## Customer Original Evidence

Primary customer text is in `records/session/2026-05-31-design-institute-phase-1-user-original-feedback.md:29-30`.
The same original feedback is also preserved in `records/session/2026-05-31-phase-1-manual-acceptance-user-original-feedback.md:17-19`.

Relevant original-feedback fragments:

- UP/user semantics: "up主改变的还是不对，屏蔽用户关键词means，针对用户这个分类下，屏蔽所有用户id里带这个词的操作，但是目前的系统，把用户名当作普通关键词的一种，不满意"
- Long-press card UX: "我希望是在piliplus上游的那种长按卡片有显示封面的方式魔改，目前的不够美观"
- Tag shielding: "相关视频也生效了，但是标签屏蔽没有作用，我期望的是标签屏蔽的效果在推荐流生效...need factcheck"
- Legacy merge: "上游的屏蔽功能和新增的屏蔽系统同时在生效，不需要这样，上游的功能合并到这个屏蔽系统里"
- Settings IA: "我需要设置也的分类页，方便整理"

## Reasonix Auxiliary Summary

### A - UP User Shielding Semantics

Reasonix A concludes this is a Phase 1 blocker. Current `ShieldRuleType` only has `keyword`, `uid`, `category`, and `tag`; `keyword` matching still includes `authorName`, so username shielding is mixed with generic content keyword shielding. Quick UP actions currently generate a `uid` rule and a generic `keyword` rule for username.

Recommended model:

- Keep `uid` as exact UID match.
- Add user-category rule types such as `upName` and `upKeyword`.
- Remove `authorName` from generic `keyword` matching.
- Map UP quick action username shielding to user-specific rule type, not generic keyword.
- Treat old generic keyword records that were created from UP quick actions as migration/debt unless they are needed to avoid data loss.

Technical-lead interpretation: The customer explicitly rejected username/user keyword living in normal keyword space. Phase 1 must separate user identity matching from content keyword matching.

### B - Recommendation Tag Shielding Fact-Check

Reasonix B concludes this is a Phase 1 blocker with a product-level fallback decision. The recommendation payload generally does not provide a stable real tag list before opening video details. `ShieldingAdapters.fromRecommendationJson` only reads `tag` / `tags` if they happen to exist, while recommendation items commonly provide `tname` / `args.tname` as category. Related-video construction has category available through `item.tname`, but tag matching currently depends on `candidate.tags`.

Recommended approach:

- Do not add per-card detail fetches for Phase 1 because it adds high network cost and latency.
- Do not hide tag rules from recommendation flow because the customer explicitly expects recommendation-feed effect.
- Use `category` / `tname` as a Phase 1 fallback for tag rules in recommendation and related-video contexts.
- Document that this is not true video-detail tag matching; it is recommendation-feed fallback semantics.

Technical-lead interpretation: This is not primarily a matcher bug when payload lacks tags, but the current UX promise still fails. Phase 1 needs a deterministic fallback so the customer's "tag shielding in recommendation feed" expectation has observable behavior.

### C - Legacy Upstream Shielding Merge

Reasonix C concludes this is a Phase 1 blocker. The old `RecommendFilter` layer and the new `ShieldingAdapters` layer both run in recommendation paths, producing an AND relationship where both systems can independently remove cards. Comments are already mainly new-system filtered; danmaku and numeric recommendation thresholds remain outside the new model.

Recommended merge direction:

- Stop using old `RecommendFilter` title-keyword filtering in recommendation/related-video paths once equivalent keyword rules are migrated into the new shielding rule set.
- Migrate old `banWordForRecommend` into new `ShieldRule` records as one-time import.
- Keep numeric filters such as duration, play count, and like-ratio in legacy settings for now because the new rule model has no numeric-threshold type.
- Keep danmaku shielding separate unless a new scope is explicitly designed.
- Avoid double-effect or duplicate configuration for comment and recommendation shielding.

Technical-lead interpretation: The customer asked for one shielding system. Phase 1 must eliminate duplicate keyword-layer behavior for recommendation shielding, while leaving unsupported numeric/danmaku features as compatible legacy islands.

### D - UX / Settings Information Architecture

Reasonix D concludes settings categorization is a Phase 1 blocker and long-press visual polish is Phase 1 debt. Current `ShieldingSettingsPage` is a single long form with switches, one linear rule list, and a FAB; there is no category grouping, search, or navigation. Long-press cards already open a shielding dialog from horizontal and vertical cards, but the customer prefers upstream-style cover-visible interaction.

Recommended settings IA:

- User / UP
- Title keywords
- Tags
- Category / 分区
- Comment keywords
- Comment users
- Exact text
- Legacy compatible rules

Phase split:

- Blocker: rule management categorized grouping, search, and navigable classification.
- Debt: more polished upstream-style long-press card surface with cover preview, richer empty states, import/export, batch actions, and full classified edit forms.

Technical-lead interpretation: Settings classification is explicitly requested as organization needed for acceptance. The long-press cover-preview UI is important but can follow after the functional blockers, unless the customer declares visual parity mandatory before retest.

## Technical-Lead Decision

Phase 1 must remain non-green. The customer's feedback is primary evidence and overrides earlier repair-blueprint assumptions.

Accepted blocker set for the next implementation pass:

1. UP/user shielding semantics must be corrected by adding user-specific rule type(s), removing `authorName` from generic content keywords, and routing UP quick actions into the user namespace.
2. Recommendation-feed tag shielding must have an explicit Phase 1 behavior. The approved behavior is `tag` rule matching real tags when present and falling back to `category` / `tname` in recommendation and related-video surfaces. Extra detail fetches are rejected for Phase 1.
3. Legacy upstream recommendation keyword shielding must be merged into the new shielding system by one-time migration and by disabling duplicate old keyword filtering on recommendation/related-video paths. Numeric thresholds and danmaku remain legacy-compatible debt.
4. Shielding settings must gain category organization, search, and navigation sufficient to manage user/UP, title keyword, tag, category, comment keyword, comment user, exact text, and legacy-compatible rule groups.

The following are accepted as Phase 1 debt, not blockers:

1. Upstream-style long-press card UI polish with larger/cleaner cover preview.
2. Per-video detail fetch for true tag lists in recommendation feed.
3. Numeric-threshold rule types in the new shielding model.
4. Danmaku scope migration into the new shielding system.
5. Import/export, batch operations, empty-state illustration, and advanced rule editor forms.
6. Full package-runtime-contract rename.

## Blocker List

1. `upName` / `upKeyword` or equivalent user-specific rule model absent.
2. Generic `keyword` still covers `authorName`; this violates the customer's user/category separation.
3. UP quick action username option writes generic `keyword` instead of a user-specific rule.
4. Recommendation tag shielding has no reliable observable behavior when feed payload lacks tags; implement `category` / `tname` fallback for `tag` rules.
5. Related/recommendation adapters must consistently expose category fallback for tag matching.
6. Old `RecommendFilter` keyword layer and new shielding layer both affect recommendation visibility; migrate old keywords and stop duplicate keyword filtering.
7. Settings page lacks categorized rule management, search, and navigation.

## Debt List

1. Long-press card UI should be redesigned toward PiliPlus upstream-style cover-visible interaction, but it is not the immediate Phase 1 acceptance blocker after functional semantics are corrected.
2. True video-tag matching in recommendation feed via detail API remains deferred because of network and latency risk.
3. Legacy numeric filters should remain in compatibility settings until the new model supports numeric rules.
4. Danmaku shielding remains legacy/out of current Phase 1 shielding scope.
5. Old generic keyword migration heuristics for previously created UP username quick-action rules may need a careful non-lossy migration plan.
6. package-runtime-contract rename remains outside Phase 1 and should be tracked as a separate release identity phase.

## package-runtime-contract Decision

Continue the Phase 1 exemption. `package-runtime-contract` rename remains yellow/debt and must not block this shielding acceptance pass.

Reason:

- `records/reasonix/auditor/2026-05-30-phase-1-apk-acceptance-scope.md:129-135` records that the package/runtime identity remains unchanged and recommends keeping it yellow/debt.
- `records/reasonix/auditor/2026-05-30-phase-1-evidence-gap.md:192-222` records that package/runtime rename is outside the current shielding runtime smoke and should not be mixed into Phase 1 shielding evidence.
- Renaming package/runtime identifiers would require a separate build, install, launch, channel, imports, and release-signature verification cycle.

## Prebuild Decision

Yes, a new prebuild is needed after the blocker fixes are implemented.

Reason:

- The manual acceptance target `phase-1-prebuild.26680259984` predates these unresolved blockers.
- `records/reasonix/auditor/2026-05-30-phase-1-apk-acceptance-scope.md:56` states that exact latest-HEAD acceptance requires a new prebuild.
- The next customer retest must use a package containing the corrected UP semantics, tag fallback, legacy merge behavior, and settings categorization.

Do not publish or trigger a build from this review record. New prebuild requires explicit implementation completion and release authorization.

## Next Owner

1. Reasonix / implementation harness: execute the next functional pass for the blocker set above in `CometDash77/PiliAvalon-Worksite` on `phase-1-shielding-core`.
2. Codex main session: archive this review record and, after implementation, verify records/tests without modifying CI or publishing.
3. Technical lead / design institute: re-review once blocker implementation evidence exists.
4. 甲方: retest only after a new authorized prebuild is produced from the blocker-fix commit.

## Gate Statement

Current manual acceptance and 甲方验收 still have not passed. Phase 1 must not be marked green.

Android startup/no-white-screen is not the current blocker, but it does not close manual acceptance. The remaining blockers are functional/product acceptance issues in shielding semantics, recommendation tag behavior, legacy-system consolidation, and settings organization.
