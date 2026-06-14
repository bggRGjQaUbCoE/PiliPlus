# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

PiliPlus is a third-party BiliBili client built with Flutter, targeting Android, iOS, Pad, Windows, Linux, and macOS. It is a heavily-modified fork of pilipala/PiliPalaX. Locale is hard-coded to `zh-CN` (with `en-US` fallback); UI strings and comments are predominantly Chinese.

## Toolchain

- **Flutter is pinned to `3.44.2`** via `.fvmrc` and `pubspec.yaml` (`environment.flutter`). Use FVM or the exact matching version — the project relies on patched Flutter SDK internals (see below).
- Dart SDK `>=3.12.0`. Java 17 for Android.

## Common commands

```bash
flutter pub get                 # install deps
flutter analyze                 # lint (config in analysis_options.yaml)
flutter run                     # run on connected device
flutter test                    # run tests (note: the test/ dir is minimal)
dart format lib/                 # format (trailing_commas: preserve — see analysis_options.yaml)
dart run tool/jnigen.dart       # regenerate Android JNI bindings -> lib/utils/android/bindings.g.dart
```

Release builds inject version metadata via dart-defines from a generated `pili_release.json` (keys `pili.name`, `pili.code`, `pili.hash`, `pili.time`, consumed by `lib/build_config.dart`). `lib/scripts/build.ps1` generates that file from git; CI then runs e.g.:

```bash
flutter build apk --release --split-per-abi --dart-define-from-file=pili_release.json --pub
flutter build ios --release --no-codesign --dart-define-from-file=pili_release.json
flutter build linux --release --pub --dart-define-from-file=pili_release.json
```

### Flutter SDK patching (important)

Before building, CI applies `.patch` files from `lib/scripts/` **to the Flutter SDK itself** via `lib/scripts/patch.ps1 <platform>` (run from `$FLUTTER_ROOT`). These patch Flutter framework internals (bottom sheets, scroll views, navigator, text selection, modal barrier, etc.) to work around upstream bugs — see the issue links in `patch.ps1`. If you hit behavior that contradicts stock Flutter in those areas, a patch is likely the cause. Patches differ per platform (android/ios/linux/macos/windows).

## Architecture

### State management — GetX everywhere

The app uses **GetX** (`get` package) for routing, DI, and reactive state. The dominant pattern is a per-feature folder under `lib/pages/<feature>/` containing:
- `controller.dart` — a `GetxController` holding reactive state (`Rx<T>`, `.obs`) and business logic.
- `view.dart` — the widget tree, wired to the controller via `GetView`/`Obx`.

Routes are declared centrally in `lib/router/app_pages.dart` (`Routes.getPages`, e.g. `/videoV` → `VideoDetailPageV`). `main.dart` boots a `GetMaterialApp`. App-wide singletons (`AccountService`, `DownloadService`) are registered with `Get.lazyPut` in `main()`.

### Networking — `lib/http/`

- `lib/http/init.dart` builds the `Dio` client (HTTP/2 via `dio_http2_adapter`, gzip/brotli decoding, cookie/account interceptor). Per-domain API classes live alongside (`video.dart`, `reply.dart`, `user.dart`, …).
- **All API methods return `LoadingState<T>`** (`lib/http/loading_state.dart`), a sealed class with `Loading` / `Success<T>` / `Error` variants. Consume with pattern matching: `if (res case Success(:final response)) { ... }`. This is the canonical request-result idiom across the codebase — follow it for new endpoints.
- WBI signing (`lib/utils/wbi_sign.dart`) and app signing (`lib/utils/app_sign.dart`) are required for many Bilibili endpoints.

### gRPC — `lib/grpc/`

Bilibili gRPC APIs. **Generated protobuf code lives in `lib/grpc/bilibili/` and is excluded from analysis** (`analysis_options.yaml`). Hand-written request wrappers (`grpc_req.dart`, `view.dart`, `dyn.dart`, …) sit at the top of `lib/grpc/`. Do not hand-edit files under `lib/grpc/bilibili/`.

### Models — `lib/models/` vs `lib/models_new/`

Two model trees exist. `lib/models_new/` is the newer, preferred location (mirrors API response shapes); `lib/models/` is older/common (and holds shared enums under `models/common/`). Prefer `models_new` for new API response models. `.g.dart` files are generated (json_serializable / Hive adapters) — regenerate with build_runner rather than editing by hand.

### Video player — `lib/plugin/pl_player/` + `lib/pages/video/`

This is the most complex subsystem. The playback engine is **media_kit / media_kit_video** (libmpv under the hood — note `NativePlayer.apiVersion` in `main.dart`).

- `lib/plugin/pl_player/controller.dart` — `PlPlayerController`, the large central player controller (wraps media_kit `Player`/`VideoController`, manages play state, gestures, fullscreen, danmaku integration, volume/brightness, sponsor-block via `BlockConfigMixin`). It exposes a single shared `_instance`.
- `lib/plugin/pl_player/view/view.dart` — the player widget and gesture/overlay layer.
- `lib/plugin/pl_player/models/` — player enums/value types (`video_fit_type`, `gesture_type`, `play_speed`, `fullscreen_mode`, …).
- `lib/pages/video/` — the video detail page (controller + view) that hosts the player plus introduction, replies, related, danmaku, download panel, AI conclusion, view points, etc. — each its own sub-folder with controller/view.
- Danmaku rendering uses `canvas_danmaku`. Fullscreen orientation logic is in `lib/plugin/pl_player/utils/fullscreen.dart`.

### Android native interop — `lib/utils/android/`

Native Android calls go through **jnigen**-generated JNI bindings (`bindings.g.dart`, regenerate with `dart run tool/jnigen.dart` per `tool/README.md`) wrapped by `PiliAndroidHelper` in `android_helper.dart`. Native Kotlin/Java sources live under `android/`.

### Persistence

Local storage uses **Hive** (`hive_ce`). `GStorage` (`lib/utils/storage.dart`) opens the boxes; typed accessors are in `lib/utils/storage_pref.dart` (`Pref.*`) with keys in `lib/utils/storage_key.dart`. Read settings via `Pref.<name>` rather than touching boxes directly.

## Conventions

- **Imports must be `package:PiliPlus/...` absolute** — `avoid_relative_lib_imports` and `always_use_package_imports` are enforced lints. Relative imports inside `lib/` will fail analysis.
- `always_declare_return_types`, `avoid_print` (use `debugPrint` guarded by `kDebugMode`, or the `logger`), and `prefer_const_*` are enforced — see `analysis_options.yaml` for the full enabled set.
- Crash reporting uses `catcher_2` (enabled when `Pref.enableLog`); logger is `lib/services/logger.dart`.
- UI scaling: the app wraps everything in a `ScaledWidgetsFlutterBinding` + `MediaQuery` override driven by `Pref.uiScale`/`Pref.defaultTextScale` (see `MyApp._builder` in `main.dart`) — be mindful when computing sizes from `MediaQuery`.
