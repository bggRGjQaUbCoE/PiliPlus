# Android Dolby Vision validation build

On Android, enable **播放器设置 → 杜比视界原生解码** and select **杜比视界**
in the usual quality menu to play an online video through Media3. The setting
is off by default and applies the next time a video source is loaded. The video
is decoded into a SurfaceView embedded in the existing player. Flutter continues to own danmaku, subtitles, gestures and the
playback controls. Other qualities, live streams and downloaded videos use mpv.

Build with the project's Flutter SDK patches applied:

```sh
flutter build apk --release --target-platform android-arm64 --split-per-abi \
  --android-project-arg dev=1
```

## Device checks

- Open the same Profile 5 and Profile 8 samples used for the standalone build.
  Select **杜比视界** in the regular quality menu and compare both samples with
  the official app. Check for Profile 5 color tint and Profile 8 HDR output.
- Toggle the setting off and reload the same video to confirm it returns to mpv.
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
- Test consecutive videos, fullscreen, picture-in-picture and folding.
- Record model, firmware, BV/CID and the stream profile. Decoder name alone does
  not establish HDR display output. `adb logcat -s PiliNativeHDR` records decoder
  names and playback error codes without signed media URLs.

In Dolby Vision mode, mpv shaders and the player's frame screenshot feature are
unavailable. Subtitle changes can briefly rebuffer.
