# Capture-capable media libraries

The application uses the five local `packages/media_kit_libs_*` packages. They
consume `native/artifacts/<platform>`; they never download the old decoder-only
bundles. Do not substitute system libmpv for the Linux artifact.

Run `python3 native/build.py android|ios|macos|windows|linux` on the matching
builder, then `python3 native/verify.py <platform>` before building the Flutter
application. The `capture-native.yml` reusable workflow produces artifacts for
application workflows. It does not publish releases. Source commits are pinned
in `sources.json`; the Apple WebP archive and Linux FFmpeg archive are checked
against fixed SHA256 digests. Output artifacts include `SHA256SUMS`.

Builders:

- Android: Linux, Android SDK (`ANDROID_HOME`), NDK 27.1.12297006, Java 21,
  Gradle and Flutter; follows the pinned upstream bundle script.
- Apple: macOS/Xcode, `brew install go meson ninja nasm make`.
- Windows: the upstream `ghcr.io/shinchiro/archlinux` cross-build container.
- Linux: Ubuntu 24.04; dependencies are listed in `capture-native.yml`.

Retain upstream LICENSE files when distributing binaries. The local plugin
sources retain the media-kit MIT license; native components retain their own
licenses.

Linux artifacts include the matching libmpv headers and relocatable pkg-config
metadata. The player plugin links against this SDK, and the application loads
the bundled library explicitly. Each media library uses `$ORIGIN` to resolve
its bundled dependencies after the application directory is moved.
The application bundle retains the host GTK, font configuration, C++ and ALSA
runtime instead of overriding them with copies from the build distribution.

`desktop-capture-test.yml` produces desktop test archives without publishing a
release. It defaults to Linux; Windows requires an explicit platform selection.
Its optional `native_run` input reuses a completed Linux media artifact while
rebuilding the application from the selected branch.

## Runtime verification

Create a 320x180, three-second sample (for example with FFmpeg `testsrc2`), then:

```
CAPTURE_TEST_LIBMPV=/absolute/path/to/bundled/libmpv.so.2 \
CAPTURE_TEST_VIDEO=/absolute/path/to/sample.mp4 \
flutter test test/player/animation_export_integration_test.dart
```

The integration test calls the actual exporter, starts at one second, checks the
cropped preview and animated GIF/WebP frame sizes, and rejects single-frame
output. Run this against each platform's actual library with its matching test
runner; building or listing codecs alone is insufficient. On Linux, apply the
project patches and run `bash native/test_linux.sh` to build the native event
loop before testing. Also check rotated
and non-square-pixel video, first/last frames, looping, cancellation, gallery
animation preservation, save permissions, and ordinary playback on devices.

## Capture behavior

Headless probes explicitly enable the video track (`vid=auto`) and read decoder
orientation after decoding starts. Preview and encoding normalize orientation
and pixel aspect ratio before applying the same crop mapping.

The editor offers free selection and 14 fixed ratios. Selection state includes
the preset and lasts for the current capture dialog; resetting restores the
full frame and free selection. Ratio crops use reduced integer pixel units.

The behavior suite covers endpoint controls, crop geometry, touch/mouse layout,
rotation, non-square pixels, quality changes, failure and cancellation. Native
export tests are opt-in through the environment variables above, and must run
against the library packaged by the corresponding platform build. The desktop
workflow runs analysis, the behavior suite and actual Linux export tests before
packaging. Device gallery, permissions, interactive playback and other platform
builds require their own validation.
