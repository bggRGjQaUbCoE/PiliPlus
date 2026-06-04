# Phase 1 Repeat Failure Root Cause

Date: 2026-05-31
Repo: `CometDash77/PiliAvalon-Worksite`
Branch audited locally: `phase-1-shielding-core`
Scope: read-only root-cause audit. No business code, workflow dispatch, release, or Reasonix monitoring was performed.

## Source Map

Primary user review file:

- `C:\Users\77182\Documents\obsidian\review.md` (`LastWriteTime: 2026-05-31 17:14:40`)

The file is outside the Git worktree, which is why the initial repo-local `Get-ChildItem -Recurse -Filter review.md` did not find it. After the user supplied the absolute path, this report was corrected to use that file as the primary acceptance checklist.

Supporting persisted worksite records:

- `records/session/2026-05-31-design-institute-phase-1-feedback-review.md`
- `records/session/2026-05-31-phase-1-manual-acceptance-user-original-feedback.md`

The original earlier customer feedback is preserved in `records/session/2026-05-31-phase-1-manual-acceptance-user-original-feedback.md:17-18`.

Image annotations referenced by `review.md` were found and visually inspected:

- `C:\Users\77182\Documents\obsidian\assets\review\file-20260531170356318.png`
- `C:\Users\77182\Documents\obsidian\assets\review\file-20260531170604020.png`
- `C:\Users\77182\Documents\obsidian\assets\review\file-20260531170802946.png`
- `C:\Users\77182\Documents\obsidian\assets\review\file-20260531170903342.png`
- `C:\Users\77182\Documents\obsidian\assets\review\file-20260531171025400.png`

## Executive Root Cause

This pass failed repeatedly because the gate was centered on implementation-shaped tests and CI smoke, while the user's acceptance criteria were product semantics and release-install semantics:

1. The new shielding system was added beside upstream legacy filters instead of replacing or hiding the old entrances.
2. Tests asserted the implemented model, including wrong behavior such as UP username quick action becoming generic `keyword` and not supporting the expected title-like split-word workflow.
3. UI/search entry points still exposed old settings, so "merged into one shielding system" was not actually true.
4. CI and runtime smoke proved "builds and launches" only; they did not prove manual shielding semantics, visual UX, categorized settings, or same-signature cover install.
5. The signing workflow can silently produce debug-signed release APKs if signing secrets are absent, and PR/dev artifacts use `.dev`, so cover-install compatibility was not a hard gate. `review.md:17` makes this the most severe blocker because old-rule compatibility could not be tested after uninstall/reinstall.
6. Reasonix/CI monitoring boundaries were known, but remote-green output was still easy to overread as acceptance-green.

## Failed/Partial Acceptance Matrix

| Item | Expected behavior | Actual evidence | Code path | Test coverage | Why gate missed it | Responsibility |
| --- | --- | --- | --- | --- | --- | --- |
| #1 | Basic previously checked item is accepted. It must not be used to override later blockers. | `review.md:1` says "已经确定没有问题了". | N/A. | N/A. | The previous pass over-weighted pass items instead of holding Phase 1 yellow for failed items #3, #7, #8, #9, #10. | 验收清单缺口 |
| #2 | Startup/no white screen remains accepted. | `review.md:2` says "没问题". Earlier user feedback also said no crash/no white screen. | Runtime smoke paths in `.github/workflows/android_runtime_smoke.yml`. | Bootstrap/smoke cover only launch health. | Launch health was incorrectly treated as broader product acceptance. | 验收清单缺口 |
| #3 UP/user keyword semantics and card UX | Long-press shielding surface should match the expected upstream-style layout, and "屏蔽用户关键词" must support split-word behavior like title shielding. | `review.md:3-6` says dissatisfaction, references `file-20260531170356318.png`, and says the cover still has problems; user keyword shielding should use split-word behavior like title shielding. The image marks layout/style issues and awkward `保存封面` placement. | `lib/features/shielding/shielding_models.dart:1-6`; `lib/features/shielding/shielding_matcher.dart:93-98`; `lib/common/widgets/video_card/shield_quick_action.dart:41-59`, `63-123`. | `test/features/shielding/video_card_shield_quick_action_test.dart:7-19` expects username to be `ShieldRuleType.keyword`, so it locked in the rejected behavior. No widget/visual test checks the annotated layout. | Tests verified local implementation, not user semantics or annotated UX. There was no failing test for split-word user keyword behavior, user-specific rule type, or cover/action layout. | 需求理解 / 实现范围 / 测试缺失 |
| #4/#5/#6 | These checklist items pass. | `review.md:7-9` says items 4, 5, and 6 are "没问题". | N/A for this audit. | N/A. | They do not close failed later items. | 验收清单缺口 |
| #6 recommendation tag shielding | Tag shielding must have observable behavior in recommendation feed; approved Phase 1 fallback is real tags when present, otherwise category/`tname` fallback for recommendation/related surfaces. | User said related videos worked but tag shielding did not affect recommendation feed and asked for fact-check (`manual...feedback.md:17-18`). Review says payload may not expose stable tags and needs category/`tname` fallback (`feedback-review.md:70-81`). | `lib/features/shielding/shielding_adapters.dart:14-25`, `lib/features/shielding/shielding_adapters.dart:52-64`, `lib/features/shielding/shielding_adapters.dart:94-106`. | Tests cover raw `tag`/`tags` mapping and even assert related-video tags are empty (`test/features/shielding/shielding_adapters_test.dart:12-45`, `88-114`, `204-245`). No test requires fallback when tags are absent. | The test matrix used synthetic payloads with ideal `tag` fields and did not model real recommendation payload absence. | 需求理解 / 测试缺失 |
| #7 legacy upstream filters | Old upstream shielding entrances must be hidden after merging into the new shielding system. They need not be deleted, but the old visible entry points must not remain as parallel configuration. | `review.md:10-14` says the logic still did not improve; annotated images show redundant results and old settings under `其它设置` and `推荐流设置`. `review.md:13-14` explicitly says the original entrances should be **隐藏**, not deleted, and that old storage logic does not interoperate with the new system. | Old UI: `lib/pages/setting/models/recommend_settings.dart:51-102`, `lib/pages/setting/models/extra_settings.dart:215-222`, `lib/pages/settings_search/view.dart:29-33`. Runtime: `lib/http/video.dart:71-86`, `lib/http/video.dart:152-174`, `lib/utils/recommend_filter.dart:4-43`. | `test/features/shielding/shielding_migration_test.dart` only verifies candidate analysis; it does not apply migration, hide entries, exclude old entries from settings search, or assert old keyword filters stop affecting recommendation visibility. | The requirement was interpreted as "do not delete old functions" rather than "merge behavior and hide old entrances". Tests never searched for old visible settings labels. | 需求理解 / 实现范围 / 测试缺失 |
| #8 settings IA | Shielding rules page should use same-row different-column category navigation; clicking a category should switch/jump pages. User does not want only vertical categorization. | `review.md:15` explicitly rejects vertical classification and asks for same-row/different-column categories with click-to-switch/jump. | Current page is a single vertical `ListView` with switches, one rule summary, then sorted rules (`lib/pages/shielding_settings/view.dart:67-126`). Labels only support four types (`lib/pages/setting/models/shielding_settings.dart:17-22`). | `test/pages/setting/models/shielding_settings_test.dart` checks labels and editor controls, not tab/segmented/category navigation. | The previous implementation satisfied "some category information exists" rather than the exact interaction model. | 需求理解 / 实现范围 |
| #9 scene switch isolation | Recommendation/comment scene switches must independently disable their corresponding filtering. Closing the comment shielding switch must make comment shielding stop. | `review.md:16` says separate recommendation/comment switches cannot be achieved: after closing comment shielding, shielding still applies. | Old `ReplyGrpc` filter remains independent of `ShieldRuleSet.commentEnabled`: `needRemoveGrpc` removes replies by `banWordForReply` or goods filter (`lib/grpc/reply.dart:39-42`), and gRPC list methods remove replies before new controller-level behavior (`lib/grpc/reply.dart:67-80`, `106-127`). | Comment tests cover new controller shielding only (`test/features/shielding/comment_reply_controller_test.dart:10-83`), not interaction with `ReplyGrpc.needRemoveGrpc` or old setting `banWordForReply`. | The gate tested the new path in isolation. It did not assert "comment switch off + old comment keywords present => comments visible". | 实现范围 / 测试缺失 |
| #10 signing / old-rule compatibility | New commit version must cover-update the installed app so old rules remain in place and legacy compatibility can be tested. | `review.md:17` calls this the most serious problem: signature inconsistency prevents cover update, forcing uninstall/reinstall, so old-rule compatibility cannot be tested at all. | `android/app/build.gradle.kts:21`, `android/app/build.gradle.kts:40-53`, `.github/workflows/build.yml:86-105`. | No automated same-signature install-over-previous-release test and no certificate fingerprint artifact. Runtime smoke installs one x86_64 APK on a clean emulator. | The release process documented signing/cover-install risk but did not hard-fail on missing/changed signing evidence before requesting user validation. | 发布流程 / 验收清单缺口 |

## Test And CI Blind Spots

The focused workflow is useful but narrow:

- `.github/workflows/phase1_shielding_verify.yml:45-55` runs shielding tests, settings-model test, bootstrap startup test, and analyze.
- Its path triggers omit `lib/http/video.dart`, `lib/utils/recommend_filter.dart`, `lib/grpc/reply.dart`, `lib/pages/setting/models/recommend_settings.dart`, and `lib/pages/setting/models/extra_settings.dart` (`phase1_shielding_verify.yml:8-17`). Changes to old filter exposure or runtime integration can avoid this gate.
- Runtime smoke (`.github/workflows/android_runtime_smoke.yml:68-83`) installs and launches an x86_64 APK and uploads evidence. It does not exercise long-press UI, settings categorization, recommendation payload tag semantics, old/new filter duplication, or same-signature cover install on a real user's installed app.
- Existing tests are model/adapter heavy. They prove `ShieldMatcher` and store behavior, but not end-to-end product behavior through upstream old settings and real feed payload shape.

The most important example of a bad test is `test/features/shielding/video_card_shield_quick_action_test.dart:17-19`, which asserts the rejected behavior: username keyword is stored as generic `ShieldRuleType.keyword`.

## Signing / Cover-Install Root Cause

Cover install requires both:

1. Same Android `applicationId`.
2. Same signing certificate as the already installed app.

Current decision tree:

| Question | Evidence | Consequence |
| --- | --- | --- |
| Is the artifact a PR/dev build? | PR build uses `flutter build ... --android-project-arg dev=1` (`build.yml:106-109`), and Gradle applies `.dev` suffix when `dev` property exists (`android/app/build.gradle.kts:55-63`). | It installs as `com.example.piliplus.dev`, not over `com.example.piliplus`. It cannot prove cover install. |
| Is the artifact workflow-dispatch release? | Workflow writes `android/key.properties` only if `SIGN_KEYSTORE_BASE64` is non-empty (`build.yml:86-95`). | If secrets are missing, no release key is configured. |
| What if signing config is missing? | Gradle signs all build types with `config ?: signingConfigs["debug"]` (`android/app/build.gradle.kts:51-54`). | Release APK can silently fall back to debug signing. That would break cover install over a previously release-signed app. |
| Is signing evidence uploaded? | No `apksigner verify --print-certs` digest artifact was found in the workflow. | Reviewers cannot compare certificate fingerprints across prebuilds. |
| Does smoke cover install? | Runtime smoke installs the selected APK on a fresh emulator, not over an existing release install. | It proves install/launch only, not upgrade compatibility. |

The prior process had enough warnings: `records/session/2026-05-30-ci-evidence.md:64-66` says workflow success alone is not green and same-signature cover install must pass. The failure is that this was documented but not enforced as a required gate before asking for acceptance.

## Reasonix / CI Boundary

The project policy is explicit:

- Main agents must not run long-running CI monitors directly (`records/session/2026-05-30-worksite-ci-monitor-policy.md:21-31`).
- Only a delegated monitor role may do that (`records/session/2026-05-30-worksite-ci-monitor-policy.md:39-44`).
- The hook blocks `gh run watch`, polling loops, and related monitor commands for main-agent roles (`.codex/hooks/guard_ci_monitor.py:35-50`, `63-80`).

This audit did not dispatch Reasonix. Existing Reasonix monitor output under `records/reasonix/monitor/2026-05-31-phase-1-remote-ci-smoke-monitor.md` marks itself as unreviewed candidate output (`lines 3-6`, `92-107`). It may support future review only after Codex review; it cannot by itself close CI, smoke, technical-lead review, or user acceptance.

## Second-Task Repair Inputs

Do not start these in Phase 1 root-cause reporting, but the next implementation task must treat them as required inputs:

1. Add user-specific rule type(s), e.g. `userKeyword`/`upKeyword`, and remove `authorName` from generic content `keyword` matching.
2. Route UP quick-action username shielding to the user-specific rule type. Update tests so the current `keyword` expectation fails first.
3. Implement recommendation tag fallback: real tags when present; category/`tname` fallback in recommendation and related-video surfaces for Phase 1.
4. Merge old `banWordForRecommend` into new rules with an actual one-time migration/apply path, then stop duplicate old keyword filtering in recommendation/related paths. Keep numeric thresholds as explicitly labeled legacy compatibility if not supported by new rules.
5. Decide comment legacy policy: either migrate/hide `banWordForReply` or wire it so the new comment switch controls the effective filtering path. Add tests around `ReplyGrpc.needRemoveGrpc`.
6. Hide old shielding entry points from `recommendSettings`, `extraSettings`, and settings search once their behavior is migrated or intentionally classified as legacy compatibility.
7. Redesign shielding settings IA into categorized rule groups with search/navigation.
8. Add signing gates: fail workflow if signing secrets are absent for release prebuild, upload `apksigner` certificate fingerprints, and add an install-over-previous-release acceptance step.
9. Keep CI green distinct from manual green. A successful build/smoke run can only say "automation passed"; it cannot say "甲方验收 passed."
10. If long-running GitHub run monitoring is needed, delegate to Reasonix monitor role and persist a Codex-reviewed monitor artifact before citing it.

## Verification Performed

Read-only commands and files used:

- `git status --short --branch`
- `rg --files` for review records and image candidates
- `rg` for `recommendSettings`, `extraSettings`, `banWordForReply`, `needRemoveGrpc`, `ReplyGrpc`, `applicationId`, signing, workflows, and tests
- Read acceptance records, key implementation files, test files, Gradle config, GitHub workflows, and CI monitor policy

Current conclusion: Phase 1 remains yellow/not green. The root cause is not one missing code line; it is an acceptance-gate mismatch where tests and CI validated narrower implementation facts than the user's stated behavior and release-install requirements.
