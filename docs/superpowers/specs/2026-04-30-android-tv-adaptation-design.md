# PiliPlus Android TV Adaptation Design Spec

## Overview

Add Android TV support to PiliPlus via independent TV flavor, with dedicated Leanback-style UI, D-pad focus navigation, and CI/CD pipeline for TV APK builds.

## Architecture

### Flavor Separation
- New `main_tv.dart` entry point alongside existing `main.dart`
- Android `tv` productFlavor in `build.gradle.kts`
- TV-specific `AndroidManifest.xml` with Leanback declarations
- Shared layers: `http/`, `models/`, `models_new/`, `grpc/`, `services/`, `utils/`
- TV-exclusive UI: `lib/pages_tv/` directory

### Platform Detection
- Extend `PlatformUtils` with `isTV` flag (set from `main_tv.dart`)
- Runtime check for TV-specific behavior in shared code

## TV UI Design

### Home Page (Leanback Style)
- Left sidebar: collapsible category bar (icons when collapsed, icons+text when focused)
- Categories: Recommend, Hot, Live, Anime/PGC, Ranking, Dynamics, History, Watch Later, Favorites, Search, Settings
- Right area: horizontal scrolling content rows per category
- Cards: scale ~1.1 on focus + highlight border + title overlay

### Card Types
- Video: thumbnail + title + UP name + view count
- Live: thumbnail + streamer + category + online count
- PGC: vertical poster + title + rating + update status

### Navigation
- Reuse GetX routing with TV-specific route table pointing to `pages_tv/`
- Fade/slide transitions for large screen
- Back key returns to previous page; exit confirmation on home

## Focus Management System

### Core Components
- `TVFocusWrapper`: focus scale animation + highlight border
- `TVPage`: base page class handling remote key events (back, menu)
- `TVRow`: horizontal scrollable row with focus-aware auto-scroll
- `TVCard`: focusable card with scale animation

### Remote Control Mapping
- OK: confirm / play / pause
- Long-press OK: temporary speed +1x (release to restore)
- D-pad: focus navigation / seek during playback
- Back: navigate back
- Menu: open settings panel

## Video Player (TV)

### Mixed Control Mode
- Default: immersive fullscreen, no UI overlay
- OK: toggle play/pause
- Long-press OK: current speed +1x temporary acceleration, release restores
- Left/Right: seek (tap 10s, hold continuous)
- Up: show top info bar (title, quality, danmaku status)
- Down: show bottom control bar
- Auto-hide after idle timeout

### Bottom Control Bar (horizontal focus navigation)
- Progress bar (left/right fine-tune)
- Play/Pause
- Quality selector
- Danmaku toggle
- Danmaku settings (font size, opacity, density, simplified mode toggle)
- Speed selector
- Next episode (when applicable)
- Episode list

### Danmaku
- Default: ON, auto-scaled font for large screens
- Settings: font size, opacity, display area, speed
- Simplified danmaku mode toggle: filters to ~50% density

## Feature Modules (TV)

### Search
- Top: virtual keyboard grid (pinyin/letters + numbers), D-pad character selection
- Right: real-time search suggestions
- Bottom: hot searches + search history (direct selection to skip typing)
- Results: grid card layout

### Live
- List: horizontal rows by category
- Player: simplified controls (quality, danmaku, volume; no progress bar/speed)

### PGC (Anime/Movies)
- Detail: large banner + info, episode row below
- Episode selection: horizontal scrolling with D-pad

### History / Watch Later / Favorites
- Grid card list with focus navigation
- Long-press OK: context menu (delete, remove from favorites, etc.)

### Dynamics
- Simplified to UP update list, video dynamics prioritized
- Image/text dynamics show title + thumbnail only

### Ranking
- Left: category tab list
- Right: ranked content grid

### Settings
- Vertical list, focus per item
- Toggle: OK key to switch
- Selector: side panel popup
- Includes: play settings, danmaku settings, default quality, about, login/logout

### Login
- QR code display, prompt user to scan with Bilibili mobile app
- Poll `pollTvCode()` API, auto-navigate on success

## Android Configuration

### TV Flavor Manifest (`android/app/src/tv/AndroidManifest.xml`)
- Declare `android.software.leanback` (required)
- `android.hardware.touchscreen` required=false
- TV banner icon (320x180)
- Leanback launcher intent-filter
- Keep PiP, audio service, deep linking

### Build Configuration
- Add `tv` and `mobile` productFlavors in `build.gradle.kts`
- TV build: `flutter build apk --flavor tv -t lib/main_tv.dart`
- Mobile build: `flutter build apk --flavor mobile -t lib/main.dart`
- TV APK: universal (no ABI split)

## CI/CD

### GitHub Actions (`build.yml`)
- New `build_android_tv` input toggle
- New `android-tv` job:
  - Same setup steps (Java 17, Flutter, patch, signing)
  - Build command: `flutter build apk --flavor tv -t lib/main_tv.dart --release`
  - Output: `PiliPlus_android_tv_${version}.apk`
  - Upload as `Android_TV` artifact
  - Include in release assets

## File Structure

```
lib/
  main_tv.dart
  utils/platform_utils.dart  (add isTV)
  pages_tv/
    tv_app.dart
    tv_routes.dart
    home/
    video/
    live/
    pgc/
    search/
    history/
    later/
    favorite/
    dynamics/
    rank/
    login/
    setting/
    common/
      tv_focus_wrapper.dart
      tv_page.dart
      tv_card.dart
      tv_row.dart
      tv_keyboard.dart
      tv_player_controls.dart
android/
  app/build.gradle.kts  (add flavors)
  app/src/tv/AndroidManifest.xml
  app/src/tv/res/drawable/tv_banner.png
  app/src/mobile/AndroidManifest.xml  (move from main)
.github/workflows/build.yml  (add TV job)
```
