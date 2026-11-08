# Android Dolby Vision validation build

On Android, open **设置 → 播放器设置 → 杜比视界播放器** and select
**Media3 · SurfaceView（新合成）**. Reopen the online video and select
**杜比视界** in the quality menu. The selection takes effect the next time a
video source is loaded. A fresh install defaults to mpv.

Media3 sends the video to a SurfaceView while Flutter keeps its main scene on
its original render surface. The existing player continues to own danmaku,
subtitles, gestures and controls. Other qualities, live streams and downloaded
videos use mpv. The Flutter texture option is experimental and did not display
Dolby Vision correctly in the device comparison.

The tester confirmed normal playback and UI with the new SurfaceView
composition in the ARM64 build `2.2.0-hdrtest.4`.

Build with the project's Flutter SDK patches applied:

```sh
flutter build apk --release --target-platform android-arm64 --split-per-abi \
  --android-project-arg dev=1
```

## Device checks

- Open the same Profile 5 and Profile 8 samples used for the standalone build.
  Select **杜比视界** in the regular quality menu and compare both samples with
  the official app. Check for Profile 5 color tint and Profile 8 HDR output.
- Select mpv and reload the same video to confirm it uses the original backend.
  Reopen settings to confirm the selection was saved.
- Confirm danmaku, subtitles, pause/resume, seeking, and playback speed in the
  same player. Check that audio stays in sync.
- Switch from Dolby Vision to SDR and back. Check position and single audio
  output. Background and resume the app and verify playback and surface recovery.
  Switch subtitles during playback and verify that the position is retained.
- Set native player volume to 50% and 100%. Check the audible difference and
  verify the native volume does not change the saved mpv volume. Press M on an
  external keyboard to mute, switch quality while muted, then press M again
  to restore the current backend's saved volume.
- Interrupt the network while playing an online Dolby Vision video and restore
  it during the 1, 3, or 9 second backoff. Verify playback resumes near the same
  position. Repeat with the network left disconnected, and with manual pause
  or a quality switch during backoff. Verify retries stop after three attempts
  or when the previous session is no longer active.
- Simulate an error from the composition setup channel. Verify the player
  shows the mpv instructions and does not create a SurfaceView or continue
  playing audio.
- Leave the playback page and return, then open a page with a native view after
  closing playback. Verify the UI after repeated Dolby Vision to SDR switches.
- Test consecutive videos, fullscreen, picture-in-picture and folding.
- Record model, firmware, BV/CID and the stream profile. Decoder name alone does
  not establish HDR display output. `adb logcat -s PiliNativeHDR` records decoder
  names and playback error codes without signed media URLs.

In Dolby Vision mode, mpv shaders and the player's frame screenshot feature are
unavailable. Subtitle changes can briefly rebuffer.
