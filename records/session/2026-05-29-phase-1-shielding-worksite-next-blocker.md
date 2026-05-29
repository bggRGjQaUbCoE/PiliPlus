# Phase 1 Shielding Worksite Next Blocker

- role: worksite-reminder
- date: 2026-05-29
- repo: `/home/mo/Documents/piliavalon`
- branch: `phase-1-shielding-core`
- owner for next action: worksite

## Current State

The Phase 1 CI dependency gate is fixed. Commit `52f31ea97ecb42034083c9cb990f9051e1f8c18f` refreshed the `file_picker` lockfile resolved ref to verified `dev` head `a8f06d11b0b8f6d903c5680b57a8d7a385992149`.

Follow-up CI run `26623639477` reached `flutter pub get` successfully, then failed in `flutter test test/features/shielding`.

Evidence record:

- `records/session/2026-05-29-phase-1-shielding-ci-verification.md`
- run URL: `https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26623639477`

## Next Blocker

Fix the worksite compile mismatch:

```text
lib/pages/common/publish/common_publish_page.dart:32:5: Error: No named parameter with the name 'uiScale'.
    uiScale: Pref.uiScale,
    ^^^^^^^
../../../.pub-cache/git/flutter_chat_packages-59ae27131e36f14a9cd1a18057a416360969ac42/packages/chat_bottom_container/lib/panel_container.dart:13:7:
Context: The class 'ChatBottomPanelContainerController' has a constructor that takes no arguments.
```

Interpretation: product code calls `ChatBottomPanelContainerController(uiScale: ...)`, but the resolved `chat_bottom_container` dependency constructor currently takes no arguments.

## Required Worksite Action

Investigate `lib/pages/common/publish/common_publish_page.dart` against the resolved `flutter_chat_packages` / `chat_bottom_container` API and apply the minimal worksite fix. Do not mark Phase 1 green until CI reaches and passes:

```text
flutter test test/features/shielding
flutter test test/pages/setting/models/shielding_settings_test.dart
flutter analyze
```

Design-institute action is not required for this blocker unless the worksite discovers the fix needs a blueprint decision.
