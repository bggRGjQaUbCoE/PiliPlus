Audience classification: agent-facing

# Phase 1 Latest Prebuild Release Handoff

Date: 2026-06-02
Repository: `CometDash77/PiliAvalon-Worksite`
Branch: `phase-1-shielding-core`
Owner: Codex
Status: blocked by failing Phase 1 CI; do not publish another APK until fixed

## User Request

The user asked to commit the acceptance fixes and use the latest commit to make GitHub build a brand-new APK and release it.

## Completed Work

### Code And Record Commits

Two commits were created and pushed to `origin/phase-1-shielding-core`:

1. `f091d197593607eef90464f3688a40f9f93151d7`
   - Commit message: `Fix phase 1 shielding acceptance blockers`
   - Scope:
     - Added recommendation cover preview and inline `保存封面` / `取消` controls.
     - Made UP username keyword row editable.
     - Preserved UID rule behavior against the original UID.
     - Fixed settings categorization for title/comment keyword rules.
     - Added tests.
     - Added `records/session/2026-06-02-phase-1-7748-acceptance-fix-plan.md`.

2. `8c4db8278c84d099bac24c811fb06cc58e5cd3e9`
   - Commit message: `Fix recommendation cover dialog layout`
   - Scope:
     - Removed `LayoutBuilder` from `_RecommendationCoverPreview` after CI showed `AlertDialog` intrinsic sizing cannot host that `LayoutBuilder`.

The worktree after the second push had no tracked local changes. Only unrelated untracked `.codex/skills/` remained.

### Build Workflow Run

Workflow dispatched:

```bash
gh workflow run build.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core -f build_android=true -f build_ios=false -f build_mac=false -f build_win_x64=false -f build_linux_x64=false -f tag='phase-1-prebuild.{run_id}'
```

Result:

- Build run: `26794582723`
- Run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26794582723`
- Trigger commit: `f091d197593607eef90464f3688a40f9f93151d7`
- Conclusion: `success`
- Android job: `Release Android`, job id `78988080229`, success
- Release tag created: `phase-1-prebuild.26794582723`
- Release URL: `https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/phase-1-prebuild.26794582723`
- Release state: prerelease, not draft
- APK assets:
  - `PiliAvalon_android_2.0.7-f091d1975+5052_arm64-v8a.apk`
  - `PiliAvalon_android_2.0.7-f091d1975+5052_armeabi-v7a.apk`
  - `PiliAvalon_android_2.0.7-f091d1975+5052_x86_64.apk`
- Signing fingerprint for all APKs:
  - `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

Important: this release is not from the latest branch commit anymore. It is from `f091d1975`, and that commit failed Phase 1 CI. Treat `phase-1-prebuild.26794582723` as superseded/not suitable for final retest handoff unless the user explicitly chooses to inspect it as a failed-CI build. Do not mark Phase 1 green.

## CI State

### CI Run For `f091d1975`

- Phase 1 CI run: `26794577965`
- Run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26794577965`
- Commit: `f091d197593607eef90464f3688a40f9f93151d7`
- Conclusion: `failure`
- Failed job: `Focused Flutter verification`
- Failed step: `Run shielding tests`
- Command: `flutter test test/features/shielding`
- High-signal failure:
  - Test: `VideoCardShieldQuickAction recommendation dialog shows cover preview with save and cancel below`
  - Error: `LayoutBuilder does not support returning intrinsic dimensions.`
  - Relevant widget: `AlertDialog`
  - File reference from log: `lib/common/widgets/video_card/shield_quick_action.dart:82:16`
  - Summary: `58 tests passed, 1 failed.`

This failure prompted commit `8c4db8278`.

### CI Run For `8c4db8278`

- Phase 1 CI run: `26794928915`
- Run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26794928915`
- Commit: `8c4db8278c84d099bac24c811fb06cc58e5cd3e9`
- Conclusion: `failure`
- Failed job: `Focused Flutter verification`
- Failed step: `Run shielding tests`
- Downstream jobs skipped:
  - `Build Android x86_64 artifact`
  - `Android emulator runtime smoke`

The exact failing test/error for `26794928915` was not captured because a subsequent `gh run view --log-failed` call returned:

```text
error connecting to api.github.com
check your internet connection or https://githubstatus.com
```

Next session must inspect this run log before making further changes.

## Governance State

- Release type remains `prebuild`.
- Phase 1 remains yellow/not green.
- Manual acceptance is not closed.
- `phase-1-prebuild.26794582723` must not be marked stable or latest acceptance.
- A new APK should only be produced after the latest commit passes the required focused tests and preferably the Phase 1 CI chain.
- The existing auto-created release body for `phase-1-prebuild.26794582723` only contains signing evidence, not the full governance release-notes contract. If it remains visible, it should be edited or clearly superseded after the CI issue is resolved.

## Next-Session Plan

1. Read this file, `AGENTS.md`, and `.codex/skills/worksite-release-governance/SKILL.md`.
2. Confirm branch and worktree:
   - `git status --short --branch`
   - `git log --oneline --decorate -n 8`
3. Inspect failed CI run `26794928915` with explicit repo scoping:
   - `gh run view 26794928915 -R CometDash77/PiliAvalon-Worksite --json status,conclusion,url,headSha,jobs`
   - `gh run view 26794928915 -R CometDash77/PiliAvalon-Worksite --log-failed`
4. Fix the new failure. Likely areas:
   - `lib/common/widgets/video_card/shield_quick_action.dart`
   - `test/features/shielding/video_card_shield_quick_action_test.dart`
5. Commit and push a new superseding commit on `phase-1-shielding-core`.
6. Wait for push-triggered `Phase 1 CI` to pass, or at minimum capture exact failures and do not release if it fails.
7. After CI is acceptable, dispatch a new Android-only Build workflow from the latest commit:

```bash
gh workflow run build.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core -f build_android=true -f build_ios=false -f build_mac=false -f build_win_x64=false -f build_linux_x64=false -f tag='phase-1-prebuild.{run_id}'
```

8. Verify the new Build run success and release:
   - `gh run view <new-run-id> -R CometDash77/PiliAvalon-Worksite --json status,conclusion,url,headSha,jobs`
   - `gh release view phase-1-prebuild.<new-run-id> -R CometDash77/PiliAvalon-Worksite --json tagName,name,isPrerelease,isDraft,url,publishedAt,targetCommitish,assets,body`
9. Edit the new GitHub Release notes to include the required prebuild release sections:
   - Purpose
   - Release Type
   - Branch / Commit / Tag
   - Related PRs / Issues
   - Automation Evidence
   - Manual Acceptance
   - Changes
   - Known Risks
   - Sources / License / Attribution
   - Rollback Plan
   - Not Covered / Still Yellow
   - User Action Required
10. Persist a final release evidence record under `records/session/` and commit/push that record.

## User-Facing Summary To Preserve

当前已提交并推送修复，但最新提交 `8c4db8278` 的 Phase 1 CI 仍失败。因此不应继续把已经生成的 `phase-1-prebuild.26794582723` 当作最终复测包，因为它来自较早提交 `f091d1975`，且同提交 CI 失败。下一轮应先查明并修复 `26794928915` 的失败，再用通过验证的最新 commit 重新触发 GitHub Build 生成新的 prebuild APK。
