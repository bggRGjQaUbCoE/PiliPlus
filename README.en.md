<!-- Audience classification: user-facing. -->

<div align="center">
  <img width="160" height="160" src="assets/images/logo/logo.png" alt="PiliAvalon logo">
  <h1>PiliAvalon</h1>
  <p>A PiliPlus-based third-party Bilibili client focused on more controllable personal content shielding.</p>

  ![GitHub repo size](https://img.shields.io/github/repo-size/CometDash77/PiliAvalon-Worksite)
  ![GitHub Repo stars](https://img.shields.io/github/stars/CometDash77/PiliAvalon-Worksite)
  ![GitHub all releases](https://img.shields.io/github/downloads/CometDash77/PiliAvalon-Worksite/total)

  [Download stable release](https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/v1.0.0) · [中文](README.md) · [Source](https://github.com/CometDash77/PiliAvalon-Worksite)
</div>

## Download

Current stable release: **PiliAvalon v1.0.0**

- Release: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/v1.0.0
- Status: stable / latest
- Source commit: `5ccc9bf243bab2c5f143032bd2549016a5b857da`
- APK version string: `2.0.8-5ccc9bf24+5099`
- Signing certificate SHA-256 fingerprint: `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

Choose the APK that matches your device:

| Device type | Release asset |
| --- | --- |
| Most modern Android phones | `PiliAvalon_android_2.0.8-5ccc9bf24+5099_arm64-v8a.apk` |
| Older 32-bit Android devices | `PiliAvalon_android_2.0.8-5ccc9bf24+5099_armeabi-v7a.apk` |
| Android emulators or x86_64 environments | `PiliAvalon_android_2.0.8-5ccc9bf24+5099_x86_64.apk` |

The `v1.0.0` stable release provides exactly these three ABI APKs. There is no universal APK for this release.

## Current Features

PiliAvalon v1.0.0 focuses on the released Phase 1 personal shielding capability:

- **Structured shielding rules**: title/body keywords, user/UP keywords, recommendation reasons, user UID, category, and tag rules.
- **Recommendation-feed shielding**: rules can apply to recommendation lists and related-video surfaces.
- **Comment-area shielding**: rules can apply to comment text and user-related comment information.
- **Settings and rule management**: a shielding settings page for viewing, adding, editing, enabling, and disabling rules.
- **Global and scoped switches**: a global switch plus separate recommendation and comment shielding controls.
- **Reversible compatibility path**: legacy persisted rules remain compatible while token matching is removed from normal new-rule creation.
- **Upstream-aligned adaptation**: shielding is maintained on top of PiliPlus while keeping the integration surface reviewable for future upstream syncs.

PiliAvalon also inherits PiliPlus client capabilities such as playback, search, dynamics, comments, favorites, watch later, multiple accounts, cache, and WebDAV settings backup. Actual behavior follows the current APK.

## App Preview

These are general client previews and do not imply that every shielding settings screen has a release-specific screenshot.

<div align="center">
  <img src="assets/screenshots/510shots_so.png" width="32%" alt="home preview">
  <img src="assets/screenshots/174shots_so.png" width="32%" alt="search preview">
  <img src="assets/screenshots/850shots_so.png" width="32%" alt="media preview">
  <br>
  <img src="assets/screenshots/main_screen.png" width="96%" alt="main screen preview">
</div>

## Roadmap

- Improve rule-management guidance, in-app copy, and coverage across more content surfaces.
- Continue reviewing PiliPlus upstream changes and sync necessary fixes without invalidating verified shielding behavior.
- Future-stage work will start from a separate scope and acceptance plan.

## Build From Source

Install the Flutter / Dart toolchain required by this repository, then run:

```bash
flutter pub get
flutter test test/features/shielding
flutter test test/pages/setting/models/shielding_settings_test.dart
flutter analyze --no-fatal-infos
flutter build apk --release --split-per-abi
```

Local build outputs are usually under `build/app/outputs/flutter-apk/`. A local build is not a formal release; use the GitHub Release page for stable downloads.

## Open Source And Attribution

PiliAvalon is based on [PiliPlus](https://github.com/bggRGjQaUbCoE/PiliPlus). Thanks to PiliPlus, PiliPalaX, PiliPala, and the wider open-source community. This project does not imply endorsement by upstream projects.

Additional thanks:

- [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)
- [flutter_meedu_videoplayer](https://github.com/zezo357/flutter_meedu_videoplayer)
- [media-kit](https://github.com/media-kit/media-kit)
- [dio](https://pub.dev/packages/dio)
- The Flutter and Dart open-source ecosystem

## Upstream

- PiliPlus: <https://github.com/bggRGjQaUbCoE/PiliPlus>

## Notice

PiliAvalon is a third-party client project for learning, research, and personal use. It does not provide cracked content and does not promise to bypass any third-party platform terms. Confirm that your usage complies with local laws and the relevant platform rules.

## License

This repository is licensed under the [GNU General Public License v3.0](LICENSE).
