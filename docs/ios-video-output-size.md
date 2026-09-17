# iOS video output sizing

The iOS player keeps decoding the selected stream, but sizes the intermediate
BGRA output to the fitted video area in physical pixels. The source dimensions
remain the basis of Flutter layout, independently of native output notifications.

- Respect device pixel ratio, BoxFit cropping/stretching, explicit aspect ratios,
  stream rotation, viewport changes and interactive zoom; cap at source size.
- Debounce resizing for 120 ms and serialize native calls. A briefly magnified
  frame may use the previous texture until the gesture settles.
- Reapply the target after media-kit overwrites output dimensions on stream changes.
- Suspend requests for routes disabled by TickerMode and cancel pending work on disposal.
- Keep full source output when Anime4K is enabled. Other platforms retain their existing surface.

## Dependency contract

The lockfile pins My-Responsitories/media-kit at
b0187daeb076cbe29c3d332f0626cca5a34f1624. Its NativeVideoController videoParams
listener sends original dimensions without updating the setSize cache. Therefore
IosVideoSurface uses VideoOutputManager.SetSize on the existing method channel
and observes controller.rect to reconcile native overrides. Check this contract
when updating media-kit. It does not replace the plugin's method-call handler.

## Verification

Run with the Flutter version required by pubspec.yaml:

```sh
flutter pub get
flutter analyze
flutter test test/plugin/pl_player/video_output_size_test.dart
```

On a physical iPhone in a release/profile build, compare the same 4K60 clip and
hwdec-current value before and after the change:

1. Small player, fullscreen, both device orientations, portrait and rotated clips.
2. All fit modes, forced 4:3/16:9, pinch zoom, reset zoom and display scaling.
3. Quality/episode switches (including a different source resolution with the same
   viewport), navigation away/back, pause/resume and repeated player teardown.
4. Anime4K off/on/off, and with/without subtitles and danmaku.
5. Inspect TextureGL resize logs to confirm physical output dimensions settle and
   do not oscillate. Compare Instruments GPU/frame time, memory and energy use.

For a 3840x2160 source shown at 640x360 logical pixels at DPR 3, expect 1920x1080
output at 1x zoom and 3840x2160 at 2x zoom. Three 32-bit output buffers then use
about 24 MiB versus 95 MiB; this is not a claim about total process memory or power.

Implementation was reviewed on Windows without Flutter/Dart installed. The
analyzer and test commands could not execute, and no iOS build or device profiling
has been performed. Runtime performance and visual parity still need verification.
