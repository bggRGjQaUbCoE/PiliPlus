# Phase 1 Shielding CI Verification

- role: verification-owner
- session id: 2026-05-29-phase-1-shielding-ci-verification
- date: 2026-05-29
- repo: /home/mo/Documents/piliavalon
- branch: phase-1-shielding-core
- work package: integration-verification

## Writable Scope

- `.github/workflows/phase1_shielding_verify.yml`
- `records/session/2026-05-29-phase-1-shielding-ci-verification.md`

## Non-Writable Scope

- Product behavior code.
- comment-adapter implementation.
- recommendation-adapter implementation.
- settings-entry implementation.
- release/signing workflows and secrets.

## Skills And Standards

- Design-institute instruction: `/home/mo/Documents/obsidian/VIBECODING项目/Piliavalon/records/worksite-communications/2026-05-29-phase-1-ci-gh-verification-to-worksite.md`
- Worksite Option B declaration: `records/session/2026-05-29-phase-1-shielding-option-b-worksite-declaration.md`
- Verification discipline: do not mark green without command output.

## Start State

```text
git status --short --branch
## phase-1-shielding-core...origin/phase-1-shielding-core

git rev-parse HEAD
922e7ef76db5501ecb3270c3de722bb04f3f41b2

command -v gh
exit 0 after user installed gh

gh --version
gh version 2.45.0 (2025-07-18 Ubuntu 2.45.0-1ubuntu0.3)

gh auth status
sandboxed check first reported an invalid token / API issue; escalated network check then succeeded.
Logged in to github.com account CometDash77 with git protocol ssh.
Token value was not recorded.

gh workflow list
escalated network check succeeded and listed existing Build workflows.
```

## Workflow Added

- path: `.github/workflows/phase1_shielding_verify.yml`
- name: `Phase 1 Shielding Verify`
- triggers: `workflow_dispatch`, plus `push` on `phase-1-shielding-core` for shielding workflow/test paths.
- secrets: none.
- release artifacts: none.

## Workflow Commands

```text
flutter --version
flutter pub get
flutter test test/features/shielding
flutter test test/pages/setting/models/shielding_settings_test.dart
flutter analyze
```

## Run Evidence

Status: red / dependency-resolution-failure.

`gh` is installed and authenticated after browser/device login. The workflow was pushed and ran on GitHub Actions.

- workflow: `Phase 1 Shielding Verify`
- run id: `26622908422`
- run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26622908422`
- job URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26622908422/job/78452750305`
- branch: `phase-1-shielding-core`
- event: `push`
- commit SHA: `34e4fa6afa3572ed73000e5d11c6e797f0e963d9`
- conclusion: `failure`
- created: `2026-05-29T06:53:53Z`
- completed: `2026-05-29T06:55:30Z`

Step results:

| Step | Conclusion |
|---|---|
| Checkout | success |
| Setup Flutter | success |
| Flutter version | success |
| Install dependencies | failure |
| Run shielding tests | skipped |
| Run settings model test | skipped |
| Analyze | skipped |

Key log excerpts:

```text
Flutter 3.44.0 • channel stable • https://github.com/flutter/flutter.git
Tools • Dart 3.12.0 • DevTools 2.57.0

flutter pub get
Resolving dependencies...
Could not find a file named "pubspec.yaml" in https://github.com/bggRGjQaUbCoE/flutter_file_picker.git f6c2ab82ce7539dc26e6c16e1455b435fd2ded09.
Failed to update packages.
Process completed with exit code 1.
```

Interpretation: CI environment and Flutter installation worked, but dependency resolution failed before focused tests or analyzer could run. This is dependency/download/source-layout failure evidence, not a shielding behavior failure.

## Dependency Fix Attempt

Status: dependency gate fixed / next compile blocker found.

The follow-up dependency inspection used authenticated `gh` against `bggRGjQaUbCoE/flutter_file_picker` instead of guessing package layout.

Commands and findings:

```text
gh api repos/bggRGjQaUbCoE/flutter_file_picker/git/trees/dev?recursive=1 --jq '.tree[].path'
```

Result: ref `dev` contains `pubspec.yaml` at repository root (`.`). No shorter nested package path is needed.

```text
gh api repos/bggRGjQaUbCoE/flutter_file_picker/contents/pubspec.yaml?ref=dev --jq '.content | @base64d'
```

Result excerpt:

```text
name: file_picker
version: 12.0.0-beta.5
```

```text
gh api repos/bggRGjQaUbCoE/flutter_file_picker/git/ref/heads/dev
git ls-remote https://github.com/bggRGjQaUbCoE/flutter_file_picker.git refs/heads/dev
```

Result: branch `dev` resolves to `a8f06d11b0b8f6d903c5680b57a8d7a385992149`.

Root-cause interpretation: the committed `pubspec.lock` pinned `file_picker` to stale resolved ref `f6c2ab82ce7539dc26e6c16e1455b435fd2ded09`, which was the SHA shown in the failing CI log. The dependency declaration in `pubspec.yaml` already uses `path: "."` implicitly and the current `dev` tree exposes a valid root `pubspec.yaml`, so no `path:` entry was added to `pubspec.yaml`. The narrow fix is to refresh `pubspec.lock` for `file_picker` to `a8f06d11b0b8f6d903c5680b57a8d7a385992149`.

Local Flutter tool status:

```text
command -v flutter
exit 1
```

Local `flutter pub get` could not be run because Flutter is not installed in this worksite shell. CI remains the verification authority for `flutter pub get`, focused tests, and analyzer.

## Follow-Up Run Evidence

Status: red / shielding-test-compile-failure.

The lockfile refresh was committed and pushed:

- commit SHA: `52f31ea97ecb42034083c9cb990f9051e1f8c18f`
- commit subject: `Fix file picker CI lock ref`

GitHub Actions run:

- workflow: `Phase 1 Shielding Verify`
- run id: `26623639477`
- run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26623639477`
- job URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26623639477/job/78455087760`
- branch: `phase-1-shielding-core`
- event: `push`
- conclusion: `failure`
- created: `2026-05-29T07:12:43Z`
- completed: `2026-05-29T07:15:41Z`

Step results:

| Step | Conclusion |
|---|---|
| Checkout | success |
| Setup Flutter | success |
| Flutter version | success |
| Install dependencies | success |
| Run shielding tests | failure |
| Run settings model test | skipped |
| Analyze | skipped |

Key log excerpts:

```text
flutter pub get
...
Install dependencies: success

flutter test test/features/shielding
lib/pages/common/publish/common_publish_page.dart:32:5: Error: No named parameter with the name 'uiScale'.
    uiScale: Pref.uiScale,
    ^^^^^^^
../../../.pub-cache/git/flutter_chat_packages-59ae27131e36f14a9cd1a18057a416360969ac42/packages/chat_bottom_container/lib/panel_container.dart:13:7: Context: The class 'ChatBottomPanelContainerController' has a constructor that takes no arguments.
class ChatBottomPanelContainerController<T> {
      ^
Failed to load ".../test/features/shielding/shielding_store_test.dart"
Failed to load ".../test/features/shielding/shielding_adapters_test.dart"
Failed to load ".../test/features/shielding/shielding_core_test.dart"
0 tests passed, 3 failed.
Process completed with exit code 1.
```

Interpretation: the original `flutter_file_picker` dependency-resolution blocker is fixed in CI. The next blocker is a compile-time API mismatch between `lib/pages/common/publish/common_publish_page.dart` and the resolved `chat_bottom_container` package from `flutter_chat_packages-59ae27131e36f14a9cd1a18057a416360969ac42`. Settings model test and analyzer remained skipped because the focused shielding test step failed first.

## Evidence Table

| Item | Status | Evidence |
|---|---|---|
| `gh` installed | green | `gh --version` returned 2.45.0. |
| `gh` authenticated | green | Escalated `gh auth status` succeeded for CometDash77; token value not recorded. |
| workflow file | green | Pushed in commit `34e4fa6afa3572ed73000e5d11c6e797f0e963d9`; GitHub ran workflow id/name `Phase 1 Shielding Verify`. |
| Flutter setup | green | `flutter --version` reported Flutter 3.44.0 and Dart 3.12.0. |
| `flutter pub get` | green | Follow-up run `26623639477` completed `Install dependencies` successfully after refreshing `file_picker` resolved ref to `a8f06d11b0b8f6d903c5680b57a8d7a385992149`. |
| `flutter test test/features/shielding` | red | Follow-up run `26623639477` failed at compile/load: `common_publish_page.dart:32:5` passes named parameter `uiScale`, but resolved `ChatBottomPanelContainerController` constructor takes no arguments. |
| `flutter test test/pages/setting/models/shielding_settings_test.dart` | yellow | Skipped because `flutter test test/features/shielding` failed first. |
| `flutter analyze` | yellow | Skipped because `flutter test test/features/shielding` failed first. |
| Android build artifact | yellow | Not covered by this focused workflow. |
| Android install/launch | yellow | Not covered by this focused workflow. |
| recommendation feed manual acceptance | yellow | Not covered by this focused workflow. |
| comment-area manual acceptance | yellow | Not covered by this focused workflow. |
| comment-adapter variance | yellow | Not closed by CI workflow creation. |
| recommendation pagination/loading proof | yellow | Not closed unless a focused test is later added and run. |

## Next Action

Investigate the `uiScale` API mismatch in `common_publish_page.dart` versus the resolved `chat_bottom_container` dependency. Do not mark Phase 1 shielding tests, settings model test, or analyzer green until a later CI run reaches and passes those commands.
