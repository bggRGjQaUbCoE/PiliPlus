# Native video output sizing

On the platforms backed by media-kit's `NativeVideoController` (iOS, macOS,
Windows and Linux) the player keeps decoding the selected stream, but sizes the
intermediate video output to the fitted video area in physical pixels instead of
the source resolution. The source dimensions remain the basis of Flutter layout,
independently of native output notifications.

Android is not covered. It uses `AndroidVideoController`, which only implements
`VideoOutputManager.SetSurfaceSize` and re-attaches the mpv surface through
`android-surface-size` (re-initializing `vo` and seeking) on every `videoParams`
change; it keeps the plain `FittedBox` + `SimpleVideo` surface.

- Respect device pixel ratio, BoxFit cropping/stretching, explicit aspect ratios,
  stream rotation, viewport changes and interactive zoom; cap at source size.
- Debounce resizing for 120 ms and serialize native calls. A briefly magnified
  frame may use the previous texture until the gesture settles. This also
  coalesces continuous window resizes on desktop: dragging a window keeps
  restarting the timer, so only one native resize runs once it settles.
- Reconcile native output notifications with the requested target dimensions.
- Suspend requests for routes disabled by TickerMode and cancel pending work on disposal.
- Keep the full source output when Anime4K is enabled, and when hardware
  acceleration is off (`hwdec == null`). The Windows and Linux software renderer
  clamps each axis to 1920x1080 independently, which would letterbox a source
  whose aspect ratio is wider or taller than 16:9.

## Platform behaviour

| Platform | Implementation | Effect of a resize |
| --- | --- | --- |
| iOS / macOS | `media_kit_video/common/darwin/Classes/plugin/VideoOutput.swift` | `texture.resize(size)` reallocates the BGRA pixel buffer, then notifies Dart. |
| Windows | `media_kit_video/windows/video_output.cc` | `CheckAndResize()` → `Resize()` unregisters and re-registers the Flutter texture and reallocates the D3D11 texture. `texture_id_` is briefly 0, so the video flashes for a frame. |
| Linux | `media_kit_video/linux/video_output.cc`, `texture_gl.cc` | The size is stored and honoured at render time. `texture_gl_populate_texture` rebuilds the mpv FBO/textures inside Flutter's populate callback; the Flutter texture is not unregistered. |
| Android | not implemented | Only `VideoOutputManager.SetSurfaceSize` exists; `AndroidVideoController.setSize` throws. |

The native side updates `controller.rect` when the output actually changes.
`VideoOutputResize` observes these notifications to reconcile the requested size.
Source dimensions are tracked separately through `player.stream.videoParams`.

## Known limitations

On Windows every applied resize flashes the video for at least one frame.
`VideoOutput::Resize()` unregisters the old Flutter texture before registering
the new one; while `texture_id_` is 0, `Render()` skips
`MarkTextureFrameAvailable` and the GPU surface callback returns `nullptr`, so
Dart keeps drawing an already unregistered texture id. This is inherent to the
pinned plugin and cannot be avoided from the app: resizing while paused does not
work either (`CheckAndResize()` runs from mpv's render callback, which does not
fire without new frames), and resizing only before the first frame would leave a
small output that Flutter then upscales once the player goes fullscreen. It is
accepted deliberately in exchange for a smaller output on high resolution
sources.

macOS and Linux resize in place: they neither change the texture id nor
unregister the Flutter texture, so they do not flash.

## Dependency contract

The lockfile pins My-Responsitories/media-kit at
73771ec38176be2d984a3049c28177bce23b54a0. This revision no longer has the
`NativeVideoController` videoParams listener that reset output dimensions on
stream changes. `NativeVideoSurface` continues to use
`VideoOutputManager.SetSize` on the existing method channel and observes
`controller.rect` to reconcile output notifications. The command accepts the
player handle, width and height as strings. Check this contract when updating
media-kit.

It does not replace the plugin's method-call handler. The surface only invokes
methods and must never call `setMethodCallHandler` on that channel, otherwise
`VideoOutput.Resize` notifications would no longer reach the controller.

## Verification

Run with the Flutter version required by pubspec.yaml:

```sh
flutter pub get
flutter analyze
```

Then, per platform, use a release/profile build and compare the same 4K60 clip
and `hwdec-current` value before and after the change:

1. Small player, fullscreen, both device orientations, portrait and rotated clips.
2. All fit modes, forced 4:3/16:9, pinch/wheel zoom, reset zoom and display scaling.
3. Quality/episode switches (including a different source resolution with the same
   viewport), navigation away/back, pause/resume and repeated player teardown.
4. Anime4K off/on/off, and with/without subtitles and danmaku.
5. Inspect resize logs to confirm physical output dimensions settle and do not
   oscillate. Compare GPU/frame time, memory and energy use.

Platform specific notes:

- iOS and macOS: `VideoOutput.Resize` log lines should be stable after each
  layout change. Also cover the desktop picture-in-picture window on macOS.
- Windows: expect one `media_kit: VideoOutput: Create Texture:` line and one
  visible flash per settled size, not one per frame. Repeat with hardware
  acceleration disabled (`Pref.enableHA`), where resizing must not happen at all.
- Linux: same scenarios as Windows, plus the software rendering fallback (EGL
  initialization failure) to confirm no letterboxing appears.

For a 3840x2160 source shown at 640x360 logical pixels at DPR 3, expect 1920x1080
output at 1x zoom and 3840x2160 at 2x zoom. Three 32-bit output buffers then use
about 24 MiB versus 95 MiB; this is not a claim about total process memory or power.

Runtime performance and visual parity on macOS, Windows and Linux have not been
profiled yet and still need verification on each of them.
