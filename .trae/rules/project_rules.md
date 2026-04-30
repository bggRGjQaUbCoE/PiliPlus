# PiliPlus Project Rules

## 1. Framework & Versions

| Component | Version | Notes |
|-----------|---------|-------|
| Flutter | 3.41.6 | Managed by FVM, do NOT use system Flutter |
| Dart SDK | >=3.10.0 | |
| Android SDK | 35 | Located at `.android-sdk` |
| Java | 17 | |

**Critical**: Always use FVM Flutter:
```powershell
# Correct
& "C:\Users\VG622\fvm\versions\3.41.6\bin\flutter.bat" <command>

# Wrong - system Flutter incompatible
flutter <command>
```

## 2. Architecture & State Management

- **State Management**: GetX (forked from `bggRGjQaUbCoE/getx`)
- **Pattern**: MVC-like with Controllers in `lib/pages/*/controller.dart`
- **Pages**: Each feature has `view.dart` (UI) + `controller.dart` (logic)
- **Common Components**: `lib/pages/common/` for shared controllers

## 3. Key Dependencies

### UI & Theme
- `dynamic_color` - Material You dynamic theming
- `font_awesome_flutter`, `material_design_icons_flutter` - Icons
- `flutter_smart_dialog` - Toast/dialogs (forked)
- `extended_nested_scroll_view` - Nested scrolling (forked)

### Network & Data
- `dio` - HTTP client with `dio_http2_adapter`
- `hive_ce` - Local storage
- `protobuf` - Protocol Buffers for API
- `cookie_jar` - Cookie management

### Video & Media
- `media_kit` + `media_kit_video` - Video player (forked)
- `audio_service` - Background audio
- `canvas_danmaku` - Danmaku/barrage (forked)
- `floating` - Picture-in-Picture (forked)

## 4. Coding Standards

### File Organization
```
lib/
├── pages/           # Feature pages (view + controller)
├── common/          # Shared widgets & controllers
├── models/          # Data models
├── services/        # API services
├── utils/           # Utilities
└── plugin/          # Custom plugins
```

### Naming Conventions
- Pages: `*_page.dart` or `view.dart` / `controller.dart`
- Controllers extend `GetxController`
- Use `const` constructors where possible

### Code Style
- Follow existing patterns in nearby files
- Check imports to understand framework choices
- Use `Get.find<T>()` for dependency injection
- Prefer `Obx()` or `GetBuilder()` for reactive UI

## 5. Prohibited Practices

- Do NOT add new dependencies without checking existing alternatives
- Do NOT use system Flutter - always use FVM
- Do NOT expose or log API keys, secrets, or credentials
- Do NOT modify `android/build.gradle.kts` mirror configurations
- Do NOT commit `key.properties` or signing keys

## 6. Environment Requirements

Required environment variables for any build/run:
```powershell
$env:JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3"
$env:ANDROID_HOME="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
$env:ANDROID_SDK_ROOT="c:\traeapp\PiliPlusgzy622Mod\.android-sdk"
```

## 7. Testing

- No test suite currently configured
- Manual testing on Android device required for UI changes
- Test video playback, danmaku, and login flows for media-related changes

## 8. Build & Release

See `.trae/AGENT_QUICKSTART.md` for detailed build instructions.

Key points:
- Use `--release` for production builds
- R8 full mode enabled for obfuscation
- ProGuard rules in `android/app/proguard-rules.pro`
